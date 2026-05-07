<#
.SYNOPSIS
    Valida que as regras de Comunicação em Conformidade estão configuradas para monitorar interações de aplicativos de IA corporativa.

.DESCRIPTION
    Este teste verifica se as Políticas de Coleta estão configuradas para ingestão de dados, se as regras de Comunicação em Conformidade
    direcionadas a aplicativos de IA corporativa (ConnectedAIApp e/ou UnifiedGenAIWorkloads) estão corretamente configuradas,
    e se existe pelo menos uma política habilitada com ReviewMailbox para processamento de alertas.

.NOTES
    Test ID: 35040
    Category: Data Security Posture Management
    Pillar: Data
    Required Module: ExchangeOnlineManagement
    Required Connection: Security & Compliance PowerShell
#>

function Test-Assessment-35040 {
    [ZtTest(
        Category = 'Gerenciamento de postura de segurança de dados',
       ImplementationCost = 'Médio',
        Service = ('SecurityCompliance'),
        CompatibleLicense = ('EXCHANGE_S_ENTERPRISE'),
        Pillar = 'Dados',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger tenants e sistemas em produção',
        TenantType = ('Workforce'),
        TestId = 35040,
        Title = 'Monitoramento de conformidade de comunicação configurado para ferramentas de IA corporativa',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Start' -Tag Test -Level VeryVerbose

    $activity = 'Verificando Comunicação em Conformidade para aplicativos de IA corporativa'

    # Q1: Verify Collection Policies are configured for enterprise AI app data ingestion
    Write-ZtProgress -Activity $activity -Status 'Verificando Políticas de Coleta'

    $collectionPolicies = @()
    $errorMsg = $null

    try {
        $featureConfig = Get-FeatureConfiguration -FeatureScenario KnowYourData -ErrorAction Stop

        if ($featureConfig) {
            foreach ($config in $featureConfig) {
                $activities = @()
                $enforcementPlanes = @()

                if ($config.ScenarioConfig) {
                    try {
                        $scenarioData = $config.ScenarioConfig | ConvertFrom-Json -ErrorAction Stop
                        if ($scenarioData.Activities) {
                            $activities = $scenarioData.Activities
                        }
                        if ($scenarioData.EnforcementPlanes) {
                            $enforcementPlanes = $scenarioData.EnforcementPlanes
                        }
                    }
                    catch {
                        Write-PSFMessage "Erro ao analisar o JSON de ScenarioConfig: $_" -Level Warning
                    }
                }

                $collectionPolicies += [PSCustomObject]@{
                    PolicyName        = $config.Name
                    Enabled           = $config.Enabled
                    Mode              = $config.Mode
                    Workload          = $config.Workload
                    Activities        = $activities
                    EnforcementPlanes = $enforcementPlanes
                    CreatedBy         = $config.CreatedBy
                    ModifiedTime      = $config.ModificationTimeUtc.ToString("yyyy-MM-ddTHH:mm:ss")
                    PolicyCategory    = "ApplicableToAI"
                }
            }
        }
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Falha ao recuperar Políticas de Coleta: $_" -Tag Test -Level Warning
    }

    # Q2: Get all Communication Compliance rules and identify those targeting enterprise AI apps
    Write-ZtProgress -Activity $activity -Status 'Analisando regras de Comunicação em Conformidade'

    $enterpriseAIRules = @()

    if ($collectionPolicies -and -not $errorMsg) {
        try {
            $allRules = Get-SupervisoryReviewRule -IncludeRuleXml -ErrorAction Stop
            $allReviewPolicy = Get-SupervisoryReviewPolicyV2 -ErrorAction Stop

            $policyMap = @{}
            if ($allReviewPolicy) {
                $allReviewPolicy | ForEach-Object { $policyMap[$_.Guid] = $_.Name }
            }

            foreach ($rule in $allRules) {
                if (-not [string]::IsNullOrWhiteSpace($rule.RuleXml)) {
                    try {
                        # Wrap RuleXml in a root element to handle multiple rule elements
                        $wrappedXml = "<root>$($rule.RuleXml)</root>"
                        $ruleXml = [xml]$wrappedXml
                        $hasEnterpriseAIConfig = $false
                        $detectedWorkloads = @()
                        $detectedUnifiedGenAIWorkloads = @()

                        # Check for ConnectedAIApp and UnifiedGenAIWorkloads in JSON value elements
                        if ($ruleXml.root) {
                            $valueElements = $ruleXml.root.GetElementsByTagName('value')
                            foreach ($valueElement in $valueElements) {
                                $rawValue = $valueElement.'#text'
                                if (-not [string]::IsNullOrWhiteSpace($rawValue)) {
                                    try {
                                        $jsonText = $rawValue.Trim()

                                        # Precisamos apenas de payloads JSON de objeto/array
                                        if ($jsonText -notmatch '^[\{\[]') {
                                            continue
                                        }

                                        $jsonData = $jsonText | ConvertFrom-Json -ErrorAction Stop

                                        # Verificar ConnectedAIApp em Workloads
                                        if ($jsonData.Workloads -and $jsonData.Workloads -contains 'ConnectedAIApp') {
                                            $hasEnterpriseAIConfig = $true
                                            $detectedWorkloads = $jsonData.Workloads
                                        }

                                        # Verificar as palavras-chave "ChatGPT.Enterprise", "EntraApp" e "AzureAI" em UnifiedGenAIWorkloads
                                        $targetWorkloads = @('ChatGPT.Enterprise', 'EntraApp', 'AzureAI')
                                        if ($jsonData.UnifiedGenAIWorkloads -and ($jsonData.UnifiedGenAIWorkloads | Where-Object { $targetWorkloads -contains $_ })) {
                                            $hasEnterpriseAIConfig = $true
                                            $detectedUnifiedGenAIWorkloads = $jsonData.UnifiedGenAIWorkloads
                                        }

                                        if ($hasEnterpriseAIConfig) {
                                            break
                                        }
                                    }
                                    catch {
                                        # Ignorar se a análise de JSON falhar
                                    }
                                }
                            }
                        }

                        if ($hasEnterpriseAIConfig) {
                            # Extrair nomes de regra da estrutura RuleXml
                            $ruleNames = @()
                            $ruleElements = $ruleXml.root.GetElementsByTagName('rule')
                            foreach ($ruleElement in $ruleElements) {
                                if ($ruleElement.name) {
                                    $ruleNames += $ruleElement.name
                                }
                            }
                            $ruleNameDisplay = if ($ruleNames.Count -gt 0) { $ruleNames -join ', ' } else { $rule.Name }

                            # Lookup policy name from $allReviewPolicy using Policy ID
                            $policyId = $rule.Policy
                            $policyName = if ($policyMap.ContainsKey($policyId)) { $policyMap[$policyId] } else { 'Unknown' }

                            $enterpriseAIRules += [PSCustomObject]@{
                                RuleName             = $ruleNameDisplay
                                PolicyId             = $policyId
                                PolicyName           = $policyName
                                Workloads            = $detectedWorkloads
                                UnifiedGenAIWorkloads = $detectedUnifiedGenAIWorkloads
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
            Write-PSFMessage "Falha ao recuperar regras de revisão de supervisão: $_" -Tag Test -Level Warning
        }
    }

    # Q3: Get enabled Communication Compliance policies with ReviewMailbox configured
    Write-ZtProgress -Activity $activity -Status 'Verificando políticas habilitadas'

    $enabledPoliciesWithReviewMailbox = @()

    if ($enterpriseAIRules -and -not $errorMsg) {
        $enabledPoliciesWithReviewMailbox = $allReviewPolicy | Where-Object {
            $_.Enabled -eq $true -and $null -ne $_.ReviewMailbox
        }
    }

    #endregion Data Collection

    #region Assessment Logic
    $passed = $false
    $customStatus = $null

    # Lógica de avaliação:
    # - Investigar se houve erro durante a coleta de dados
    # - Reprovar se nenhuma Política de Coleta estiver configurada ou se as políticas estiverem desabilitadas
    # - Reprovar se nenhuma regra de Comunicação em Conformidade direcionar aplicativos de IA corporativa
    # - Reprovar se não houver políticas habilitadas com ReviewMailbox
    # - Aprovar se as Políticas de Coleta estiverem configuradas, as regras direcionarem aplicativos de IA corporativa e existir pelo menos uma política habilitada com ReviewMailbox

    if ($errorMsg) {
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ Não foi possível determinar o status de monitoramento de IA corporativa devido ao erro:`n`n$errorMsg`n`n%TestResult%"
    }
    else {
        $hasActiveCollectionPolicies = ($collectionPolicies | Where-Object { $_.Enabled -eq $true -and $_.Activities.Count -ge 1 }).Count -ge 1
        $hasEnterpriseAIRules = $enterpriseAIRules.Count -ge 1
        $hasEnabledPoliciesWithReviewMailbox = $enabledPoliciesWithReviewMailbox.Count -ge 1

        if (-not $hasActiveCollectionPolicies) {
            $passed = $false
            $testResultMarkdown = "❌ Nenhuma política de coleta habilitada foi encontrada para ingestão de dados.`n`n%TestResult%"
        }
        elseif (-not $hasEnterpriseAIRules) {
            $passed = $false
            $testResultMarkdown = "❌ Nenhuma regra de Comunicação em Conformidade direcionada a aplicativos de IA corporativa foi encontrada.`n`n%TestResult%"
        }
        elseif (-not $hasEnabledPoliciesWithReviewMailbox) {
            $passed = $false
            $testResultMarkdown = "❌ Nenhuma política de Comunicação em Conformidade está habilitada com ReviewMailbox configurado, criando uma lacuna em que a exposição de dados de IA corporativa e as violações de política não podem ser detectadas e investigadas.`n`n%TestResult%"
        }
        else {
            $passed = $true
            $testResultMarkdown = "✅ As Políticas de Coleta estão configuradas para ingestão de dados, as regras de Comunicação em Conformidade estão configuradas para direcionar aplicativos de IA corporativa (ConnectedAIApp e/ou UnifiedGenAIWorkloads identificados em RuleXml) e PELO MENOS uma política de Comunicação em Conformidade está HABILITADA com ReviewMailbox configurado, permitindo que a organização detecte e investigue compartilhamento não autorizado de dados e violações de política por meio de interações com IA corporativa.`n`n%TestResult%"
        }
    }

    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''
    if(-not $errorMsg){

        # Portal Links
        $tenantId = (Get-MgContext).TenantId
        $collectionPoliciesLink = "https://purview.microsoft.com/cc/dataclassification/dataandactivitydiscovery?tid=$tenantId"
        $compliancePoliciesLink = "https://purview.microsoft.com/cc/policies?tid=$tenantId"

        # Build Collection Policies table rows
        $collectionTableRows = ''
        if ($collectionPolicies.Count -gt 0) {
            foreach ($policy in $collectionPolicies | Sort-Object PolicyName) {
                $enabledStatus = if ($policy.Enabled) { '✅ Verdadeiro' } else { '❌ Falso' }
                $modeStatus = if ($policy.Mode -eq 'Enable') { '✅ Habilitar' } else { '❌ Desabilitar' }
                $activitiesDisplay = if ($policy.Activities.Count -gt 0) { ($policy.Activities -join ', ') } else { 'Nenhum' }
                $enforcementDisplay = if ($policy.EnforcementPlanes.Count -gt 0) { ($policy.EnforcementPlanes -join ', ') } else { 'Nenhum' }
                $modifiedDisplay = Get-FormattedDate -DateString $policy.ModifiedTime

                $collectionTableRows += "| $($policy.PolicyName) | $enabledStatus | $modeStatus | $($policy.Workload) | $activitiesDisplay | $enforcementDisplay | $($policy.CreatedBy) | $modifiedDisplay | $($policy.PolicyCategory) |`n"
            }
        }

        # Build Enterprise AI Rules table rows
        $rulesTableRows = ''
        if ($enterpriseAIRules.Count -gt 0) {
            foreach ($rule in $enterpriseAIRules | Sort-Object RuleName) {
                $workloadsDisplay = if ($rule.Workloads.Count -gt 0) { $rule.Workloads -join ', ' } else { 'Nenhum' }
                $unifiedGenAIDisplay = if ($rule.UnifiedGenAIWorkloads.Count -gt 0) { $rule.UnifiedGenAIWorkloads -join ', ' } else { 'Nenhum' }

                $rulesTableRows += "| $($rule.RuleName) | $($rule.PolicyName) | $workloadsDisplay | $unifiedGenAIDisplay |`n"
            }
        }

        # Build Enabled Policies table rows
        $policiesTableRows = ''
        if ($enabledPoliciesWithReviewMailbox.Count -gt 0) {
            foreach ($policy in $enabledPoliciesWithReviewMailbox | Sort-Object Name) {
                $enabledStatus = if ($policy.Enabled -eq $true) { '✅ Verdadeiro' } else { '❌ Falso' }
                $reviewMailbox = if ($policy.ReviewMailbox) { "✅ $($policy.ReviewMailbox)" } else { '❌ Não configurado' }

                $policiesTableRows += "| $($policy.Name) | $enabledStatus | $reviewMailbox |`n"
            }
        }

        # Build Collection Policies section
        $collectionSection = ''
        if ($collectionPolicies.Count -gt 0) {
            $collectionSection = @"

### [Camada de ingestão de dados (Políticas de Coleta)]($collectionPoliciesLink)

| Nome da política | Habilitada | Modo | Carga de trabalho | Atividades | Planos de imposição | Criado por | Última modificação | Categoria da política |
| :---------- | :------ | :--- | :------- | :--------- | :----------------- | :--------- | :------------ | :-------------- |
$collectionTableRows
"@
        }

        # Build Enterprise AI Rules section
        # Always show this section when Q2 ran (no error and collection policies exist)
        $rulesSection = ''
        if ($collectionPolicies.Count -gt 0) {
            if ($enterpriseAIRules.Count -gt 0) {
                $rulesSection = @"

### [Regras de Comunicação em Conformidade direcionadas a aplicativos de IA corporativa]($compliancePoliciesLink)

| Nome da regra | Política associada | Cargas de trabalho | UnifiedGenAIWorkloads |
| :-------- | :---------------- | :-------- | :-------------------- |
$rulesTableRows
"@
        } else {
            $rulesSection = @"

### [Regras de Comunicação em Conformidade direcionadas a aplicativos de IA corporativa]($compliancePoliciesLink)

Nenhuma regra de IA corporativa encontrada.
"@
        }
    }

        # Build Enabled Policies section
        $policiesSection = ''
        if ($enabledPoliciesWithReviewMailbox.Count -gt 0) {
            $policiesSection = @"

### [Políticas habilitadas com caixa de correio de revisão]($compliancePoliciesLink)

| Nome da política | Habilitada | Caixa de correio de revisão |
| :---------- | :------ | :------------- |
$policiesTableRows
"@
    } else {
            $policiesSection = @"

### [Políticas habilitadas com caixa de correio de revisão]($compliancePoliciesLink)

Nenhuma política habilitada com caixa de correio de revisão configurada foi encontrada.
"@
        }

        $formatTemplate = @'
{0}{1}{2}

**Summary:**
**Resumo:**
- Políticas de Coleta configuradas: {3}
- Regras de IA corporativa detectadas (com ConnectedAIApp ou UnifiedGenAIWorkloads): {4}
- Políticas habilitadas com ReviewMailbox: {5}
'@

        $mdInfo = $formatTemplate -f $collectionSection, $rulesSection, $policiesSection, $collectionPolicies.Count, $enterpriseAIRules.Count, $enabledPoliciesWithReviewMailbox.Count
    }
    # Replace placeholder with generated markdown
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo

    #endregion Report Generation

    $params = @{
        TestId = '35040'
        Title  = 'Communication compliance monitoring is configured for enterprise AI tools'
        Status = $passed
        Result = $testResultMarkdown
    }

    if ($null -ne $customStatus) {
        $params.CustomStatus = $customStatus
    }

    Add-ZtTestResultDetail @params
}
