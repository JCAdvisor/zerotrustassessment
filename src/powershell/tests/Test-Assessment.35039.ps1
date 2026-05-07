<#
.SYNOPSIS
    O monitoramento de conformidade de comunicação está configurado para o Microsoft Copilot

.DESCRIPTION
    Este teste verifica se as regras de Comunicação em Conformidade direcionadas a interações do Copilot estão corretamente
    configuradas e habilitadas. Ele verifica se as políticas de revisão de supervisão com regras voltadas ao Copilot
    estão ativas e possuem caixas de correio de revisão configuradas para processar alertas.

.NOTES
    Test ID: 35039
    Category: Data Security Posture Management
    Pillar: Data
    Required Module: ExchangeOnlineManagement
    Required Connection: Security & Compliance PowerShell
#>

function Test-Assessment-35039 {
    [ZtTest(
        Category = 'Gerenciamento de postura de segurança de dados',
        ImplementationCost = 'Medium',
        Service = ('SecurityCompliance'),
        CompatibleLicense = ('EXCHANGE_S_ENTERPRISE'),
        Pillar = 'Dados',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger locatários e sistemas de produção',
        TenantType = ('Workforce'),
        TestId = 35039,
        Title = 'Monitoramento de conformidade de comunicação configurado para o Microsoft Copilot',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Start' -Tag Test -Level VeryVerbose

    $activity = 'Verificando regras de Comunicação em Conformidade para conteúdo do Copilot'
    Write-ZtProgress -Activity $activity -Status 'Obtendo regras de revisão de supervisão'

    # Q1: Find Communication Compliance rules targeting Copilot content
    $copilotRules = @()
    $errorMsg = $null

    try {
        $allRules = Get-SupervisoryReviewRule -IncludeRuleXml -ErrorAction Stop
        $allReviewPolicy = Get-SupervisoryReviewPolicyV2

        foreach ($rule in $allRules) {
            if (-not [string]::IsNullOrWhiteSpace($rule.RuleXml)) {
                try {
                    # Wrap RuleXml in a root element to handle multiple rule elements
                    $wrappedXml = "<root>$($rule.RuleXml)</root>"
                    $ruleXml = [xml]$wrappedXml
                    $hasCopilotConfig = $false

                    # Verificar Copilot no array Workloads dentro dos elementos JSON
                    if ($ruleXml.root) {
                        $valueElements = $ruleXml.root.GetElementsByTagName('value')
                        foreach ($valueElement in $valueElements) {
                            $rawValue = $valueElement.'#text'
                            if (-not [string]::IsNullOrWhiteSpace($rawValue)) {
                                try {
                                    $jsonText = $rawValue.Trim()

                                    # Precisamos apenas de payloads JSON de objeto/array que possam conter Workloads
                                    if ($jsonText -notmatch '^[\{\[]') {
                                        continue
                                    }

                                    $jsonData = $jsonText | ConvertFrom-Json -ErrorAction Stop
                                    if ($jsonData.Workloads -and $jsonData.Workloads -contains 'Copilot') {
                                        $hasCopilotConfig = $true
                                        break
                                    }
                                }
                                catch {
                                        # Ignorar se a análise de JSON falhar
                                }
                            }
                        }
                    }

                    if ($hasCopilotConfig) {
                        # Localizar o nome da política em $allReviewPolicy usando o ID da política
                        $policyId = $rule.Policy
                        $policyName = ($allReviewPolicy | Where-Object { $_.Guid -eq $policyId }).Name

                        $copilotRules += [PSCustomObject]@{
                            RuleName   = $rule.Name
                            PolicyId   = $policyId
                            PolicyName = if ($policyName) { $policyName } else { 'Unknown' }
                        }
                    }
                }
                catch {
                    Write-PSFMessage "Erro ao analisar RuleXml para a regra '$($rule.Name)': $_" -Level Warning
                }
            }

        }
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Falha ao recuperar regras de revisão de supervisão: $_" -Tag Test -Level Warning
    }

    # Q2: Resolve Copilot-targeting policies and verify enabled status
    $enabledCopilotPolicies = @()
    if ($copilotRules -and -not $errorMsg) {
        #Write-ZtProgress -Activity $activity -Status 'Verificando o estado de habilitação da política'

        try {
            $copilotPolicyIdentities = @($copilotRules | Select-Object -ExpandProperty PolicyId -Unique)
            $policies = foreach ($id in $copilotPolicyIdentities) {
                $allReviewPolicy | Where-Object { $_.Guid -eq $id }
            }
            $enabledCopilotPolicies = @($policies | Where-Object { $_ -and $_.Enabled -eq $true })
        }
        catch {
            Write-PSFMessage "Falha ao recuperar políticas de revisão de supervisão: $_" -Tag Test -Level Warning
        }
    }

    # Q3: Verify Copilot capture is active by checking audit logs (optional)
    $policyHits = $null
    if ($enabledCopilotPolicies) {
        Write-ZtProgress -Activity $activity -Status 'Verificando logs de auditoria'

        try {
            $startDate = (Get-Date).AddDays(-30)
            $endDate = Get-Date
            $hits = Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate -Operations SupervisionRuleMatch -ErrorAction Stop

            if ($hits) {
                $policyNamePattern = ($enabledCopilotPolicies.Name | ForEach-Object { [regex]::Escape($_) }) -join '|'
                $policyHits = @($hits | Where-Object { $_.AuditData -match $policyNamePattern -and ($_.AuditData -match 'Copilot') })
            }
        }
        catch {
            Write-PSFMessage "Falha ao verificar logs de auditoria: $_" -Tag Test -Level Warning
        }
    }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $false

    # Lógica de avaliação:
    # 1. Se a Consulta 1 retornar pelo menos 1 regra com Copilot em RuleXml, prossiga para a Consulta 2
    if ($copilotRules.Count -gt 0) {
        # 2. Se a Consulta 2 retornar pelo menos 1 política habilitada com ReviewMailbox configurado, então aprova
        $hasValidPolicies = @($enabledCopilotPolicies | Where-Object { $_.ReviewMailbox }).Count -gt 0
        $passed = $hasValidPolicies
    }
    # 3. Se a Consulta 1 não retornar regras ou a Consulta 2 não retornar políticas habilitadas, então reprova
    else {
        $passed = $false
    }
        # A Consulta 3 (logs de auditoria) é opcional e usada apenas para exibição de evidências
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($passed) {
        $statusIcon = '✅ Aprovado'
        $statusMessage = 'As regras de Comunicação em Conformidade direcionadas ao conteúdo do Copilot estão corretamente configuradas e habilitadas.'
    }
    else {
        $statusIcon = '❌ Reprovado'
        $statusMessage = 'As regras de Comunicação em Conformidade direcionadas ao conteúdo do Copilot não estão corretamente configuradas ou habilitadas.'
    }

    # Copilot-Targeting Rules section
    if ($copilotRules -and $copilotRules.Count -gt 0) {
        $rulesTableRows = ''
        foreach ($rule in $copilotRules | Sort-Object RuleName) {
            $rulesTableRows += "| $($rule.RuleName) | $($rule.PolicyName) |`n"
        }

        $rulesTemplate = @'

### Regras direcionadas ao Copilot

| Nome da regra | Política associada |
| :------ | :---- |
{0}
'@
        $mdInfo += $rulesTemplate -f $rulesTableRows
    }
    else {
        $mdInfo += "`n### Regras direcionadas ao Copilot`n`nNenhuma regra direcionada ao Copilot encontrada.`n"
    }

    # Enabled Policies section
    if ($enabledCopilotPolicies -and $enabledCopilotPolicies.Count -gt 0) {
        $policiesTableRows = ''
        foreach ($policy in $enabledCopilotPolicies | Sort-Object Name) {
            $reviewMailbox = if ($policy.ReviewMailbox) { $policy.ReviewMailbox } else { 'Não configurado' }
            $enabledStatus = if ($policy.Enabled -eq $true) { 'True' } else { 'False' }
            $policiesTableRows += "| $($policy.Name) | $enabledStatus | $reviewMailbox |`n"
        }

        $policiesTemplate = @'

### Políticas habilitadas

| Nome da política | Habilitada | Caixa de correio de revisão |
| :------ | :---- | :---- |
{0}
'@
        $mdInfo += $policiesTemplate -f $policiesTableRows
    }
    else {
        $mdInfo += "`n### Políticas habilitadas`n`nNenhuma política habilitada com regras do Copilot foi encontrada.`n"
    }

    # Activity Evidence section
    $evidenceText = if ($policyHits -and $policyHits.Count -gt 0) {
        "Correspondências recentes do Copilot (30 dias): $($policyHits.Count)"
    }
    elseif ($enabledCopilotPolicies -and $enabledCopilotPolicies.Count -gt 0) {
        "Correspondências recentes do Copilot (30 dias): 0"
    }
    else {
        "Correspondências recentes do Copilot (30 dias): Nenhuma política configurada para revisão de auditoria."
    }

    $mdInfo += "`n### Evidência de atividade`n`n$evidenceText`n"

    # Summary
    $summaryTemplate = @'

**Resumo:**

 Status: {0}

 Total de regras do Copilot encontradas: {1}

 Políticas habilitadas com regras do Copilot: {2}

**Acesso ao portal:**

 [Microsoft Purview Comunicação em Conformidade > Políticas](https://purview.microsoft.com/communicationcompliance/policies)

'@

    $mdInfo += $summaryTemplate -f $statusIcon, $copilotRules.Count, $enabledCopilotPolicies.Count

    $testResultMarkdown = "$statusMessage`n$mdInfo"

    #endregion Report Generation

    $params = @{
        TestId = '35039'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
