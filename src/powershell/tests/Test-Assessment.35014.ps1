<#
.SYNOPSIS
    As políticas de rótulo de email herdam sensibilidade de anexos

.DESCRIPTION
    Este teste verifica se as políticas de rótulo de sensibilidade têm a configuração de ação de anexo habilitada
    para herdar automaticamente rótulos de anexos de arquivo para mensagens de email e verifica
    que os rótulos estão devidamente escopo tanto para arquivos quanto para emails para participar da herança.

.NOTES
    Test ID: 35014
    Category: Label Policy Configuration
    Pillar: Data
    Risk Level: Medium
#>

function Test-Assessment-35014 {
    [ZtTest(
        Category = 'Configuração de política de rótulos',
        ImplementationCost = 'Baixo',
        Service = ('SecurityCompliance'),
        MinimumLicense = ('Microsoft 365 E3'),
        Pillar = 'Dados',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger locatários e sistemas de produção',
        TenantType = ('Workforce'),
        TestId = 35014,
        Title = 'As políticas de rótulo de email herdam sensibilidade de anexos',
        UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando configuração de herança de rótulo de email'
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de rótulo habilitadas'

    $errorMsg = $null
    $enabledPolicies = @()
    $allLabels = @()

    try {
        # Q1: Retrieve all enabled sensitivity label policies to check attachmentaction setting
        $enabledPolicies = Get-LabelPolicy -WarningAction SilentlyContinue -ErrorAction Stop | Where-Object { $_.Enabled -eq $true }

        # Q2: Retrieve all labels to check for Files & Emails scope
        Write-ZtProgress -Activity $activity -Status 'Obtendo rótulos de sensibilidade'
        $allLabels = Get-Label -ErrorAction Stop
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar políticas de rótulo ou rótulos: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $policiesWithInheritance = @()
    $dualScopedLabels = @()
    $xmlParseErrors = @()
    $passed = $false
    $customStatus = $null

    if ($errorMsg) {
        $testResultMarkdown = "⚠️ Não foi possível consultar políticas de rótulo ou rótulos de sensibilidade, portanto a configuração ``attachmentaction`` não pôde ser avaliada. Verifique as configurações de política de rótulo no portal do Purview para confirmar que a herança está explicitamente habilitada e verifique o acesso do PowerShell às políticas de rótulo e rótulos. Erro capturado: $($errorMsg)`n`n%TestResult%"
        $customStatus = 'Investigate'
    }
    else {
        try {
            # Step 1: Check policies for attachmentaction setting
            foreach ($policy in $enabledPolicies) {
                # Use common function to parse PolicySettingsBlob XML
                $parsedSettings = Get-LabelPolicySettings -PolicySettingsBlob $policy.PolicySettingsBlob -PolicyName $policy.Name

                # Track XML parsing errors
                if ($parsedSettings.ParseError) {
                    $xmlParseErrors += [PSCustomObject]@{
                        PolicyName = $policy.Name
                        Error      = $parsedSettings.ParseError
                    }
                }

                # Check if attachmentaction is set to 'automatic' or 'recommended'
                $hasInheritance = $parsedSettings.AttachmentAction -in @('automatic', 'recommended')

                if ($hasInheritance) {
                    $policiesWithInheritance += [PSCustomObject]@{
                        PolicyName       = $policy.Name
                        AttachmentAction = $parsedSettings.AttachmentAction
                    }
                }
            }

            # Step 2: Check labels for Files & Emails scope
            # ContentType contains comma-separated values like 'File, Email' or 'File, Email, Site, UnifiedGroup'
            foreach ($label in $allLabels) {
                $contentType = $label.ContentType
                $hasFileScope = $contentType -like '*File*'
                $hasEmailScope = $contentType -like '*Email*'

                if ($hasFileScope -and $hasEmailScope) {
                    $dualScopedLabels += [PSCustomObject]@{
                        DisplayName = $label.DisplayName
                        Name        = $label.Name
                        ContentType = 'Files & Emails'
                        Priority    = $label.Priority
                    }
                }
            }
        }
        catch {
            Write-PSFMessage "Erro ao analisar configurações de política de rótulo: $_" -Level Error
            $testResultMarkdown = "⚠️ Não foi possível determinar o status de herança de rótulo de email devido à estrutura inesperada das configurações de política: $_`n`n%TestResult%"
            $customStatus = 'Investigate'
        }

        # Step 3: Determine pass/fail status and message (only if no error occurred)
        if ($null -eq $customStatus){
            if ($policiesWithInheritance.Count -gt 0 -and $dualScopedLabels.Count -gt 0) {
                $passed = $true
                $testResultMarkdown = "✅ A herança de rótulo de email de anexos está configurada. Pelo menos uma política de rótulo tem a configuração ``attachmentaction`` habilitada e os rótulos com escopo de Arquivos e Emails estão disponíveis para herdar de anexos para mensagens de email.`n`n%TestResult%"
            }
            else {
                $passed = $false
                $testResultMarkdown = "❌ A herança de rótulo de email não está configurada. Nenhuma política de rótulo tem a configuração ``attachmentaction`` habilitada ou nenhum rótulo está escopo tanto para arquivos quanto para emails para participar da herança.`n`n%TestResult%"
            }
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    # Portal Links
    $labelPoliciesLink = 'https://purview.microsoft.com/informationprotection/labelpolicies'
    $labelsLink = 'https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels'

    # Build policy table rows
    $policyTableRows = ''
    if ($policiesWithInheritance.Count -gt 0) {
        foreach ($policy in $policiesWithInheritance) {
            $policyTableRows += "| $($policy.PolicyName) | $($policy.AttachmentAction) |`n"
        }
    }

    # Build label table rows
    $labelTableRows = ''
    if ($dualScopedLabels.Count -gt 0) {
        # Sort by priority (lower number = higher priority)
        $sortedLabels = $dualScopedLabels | Sort-Object -Property Priority
        foreach ($label in $sortedLabels) {
            $labelTableRows += "| $($label.DisplayName) | $($label.ContentType) | $($label.Priority) |`n"
        }
    }

    # Build XML parsing error rows
    $errorTableRows = ''
    if ($xmlParseErrors.Count -gt 0) {
        foreach ($parseError in $xmlParseErrors) {
            $errorTableRows += "| $($parseError.PolicyName) | $($parseError.Error) |`n"
        }
    }

    $inheritanceSetting = if($passed) {'Sim'} elseif ($customStatus -eq 'Investigate') {'Desconhecido'} else {'Não'}

    # Build report using format template
    $formatTemplate = @'
{0}{1}
**Resumo:**

- Políticas com attachmentaction habilitado: {2}
- Rótulos com escopo de Arquivos e Emails: {3}
- Configuração de herança encontrada: {4}
{5}
'@

    # Build policies section
    $policiesSection = ''
    if ($policiesWithInheritance.Count -gt 0) {
        $policiesSection = @"

### [Políticas com configuração attachmentaction]($labelPoliciesLink)

| Nome da política | Herdar rótulo de anexos |
| :---------- | :----------------------------- |
$policyTableRows
"@
    }

    # Build labels section
    $labelsSection = ''
    if ($dualScopedLabels.Count -gt 0) {
        $labelsSection = @"

### [Rótulos com duplo escopo (prontos para herança)]($labelsLink)

| Nome do rótulo | Tipo de conteúdo | Prioridade |
| :--------- | :----------- | :------- |
$labelTableRows
"@
    }

    # Build error section
    $errorSection = ''
    if ($xmlParseErrors.Count -gt 0) {
        $errorSection = @"

### ⚠️ Erros de análise de XML

As políticas a seguir não puderam ser analisadas e foram excluídas da análise:

| Nome da política | Erro |
| :---------- | :---- |
$errorTableRows

**Nota**: Essas políticas foram tratadas como não tendo ``attachmentaction`` configurado.
"@
    }

    $mdInfo = $formatTemplate -f $policiesSection, $labelsSection, $policiesWithInheritance.Count, $dualScopedLabels.Count, $inheritanceSetting, $errorSection

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35014'
        Title  = 'Herança de rótulo de email de anexos configurada'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add CustomStatus if status is 'Investigate'
    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
