<#
.SYNOPSIS
    Um rótulo de sensibilidade padrão está configurado nas políticas de rótulo

.DESCRIPTION
    Este teste verifica se as políticas de rótulo de sensibilidade têm rótulos padrão configurados
    para várias cargas de trabalho, incluindo documentos/emails, Outlook, Power BI,
    sites do SharePoint e Microsoft 365 Groups.

.NOTES
    Test ID: 35017
    Category: Information Protection
    Pillar: Data
    Risk Level: Medium
#>

function Test-Assessment-35017 {
    [ZtTest(
        Category = 'Proteção de Informações',
        ImplementationCost = 'Baixo',
        Service = ('SecurityCompliance'),
        MinimumLicense = ('Microsoft 365 E3'),
        Pillar = 'Dados',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger tenants e sistemas em produção',
        TenantType = ('Workforce'),
        TestId = 35017,
        Title = 'Um rótulo de sensibilidade padrão está configurado nas políticas de rótulo',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando configuração de rótulo padrão para políticas de rótulo de sensibilidade'
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de rótulo habilitadas'

    $errorMsg = $null
    $enabledPolicies = @()

    try {
        # Q1: Retrieve all enabled sensitivity label policies to assess default label configuration
        $enabledPolicies = Get-LabelPolicy -WarningAction SilentlyContinue -ErrorAction Stop | Where-Object { $_.Enabled -eq $true }
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar políticas de rótulo: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $allPolicySettings = @()
    $policiesWithDefaults = @()
    $xmlParseErrors = @()
    $passed = $false
    $customStatus = $null

    if ($errorMsg) {
        $testResultMarkdown = "⚠️ Não foi possível determinar se os rótulos padrão estão configurados devido a erro: $errorMsg`n`n%TestResult%"
        $customStatus = 'Investigate'
    }
    else {
        Write-PSFMessage "Encontradas $($enabledPolicies.Count) políticas de rótulo habilitadas" -Level Verbose

        try {
            # Examine label policy settings for default labels
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

                # Validate label IDs (TryParse handles $null and empty strings)
                $guid = [System.Guid]::Empty
                $hasDocumentDefault = [System.Guid]::TryParse($parsedSettings.DefaultLabelId, [ref]$guid)
                $hasOutlookDefault = [System.Guid]::TryParse($parsedSettings.OutlookDefaultLabel, [ref]$guid)
                $hasPowerBIDefault = [System.Guid]::TryParse($parsedSettings.PowerBIDefaultLabelId, [ref]$guid)
                $hasSiteGroupDefault = [System.Guid]::TryParse($parsedSettings.SiteAndGroupDefaultLabelId, [ref]$guid)

                $hasAnyDefault = $hasDocumentDefault -or $hasOutlookDefault -or $hasPowerBIDefault -or $hasSiteGroupDefault

                # Q2: Determine policy scope (Global vs User/Group-Scoped)
                # A policy is Global if ANY location property contains "All"
                $allLocationNames = @(
                    $policy.ExchangeLocation.Name
                    $policy.ModernGroupLocation.Name
                    $policy.SharePointLocation.Name
                    $policy.OneDriveLocation.Name
                    $policy.SkypeLocation.Name
                    $policy.PublicFolderLocation.Name
                ) | Where-Object { $_ }
                $isGlobal = $allLocationNames -contains 'All'

                $policyInfo = [PSCustomObject]@{
                    PolicyName           = $policy.Name
                    Guid                 = $policy.Guid
                    Enabled              = $policy.Enabled
                    DefaultLabelId       = $parsedSettings.DefaultLabelId
                    OutlookDefaultLabel  = $parsedSettings.OutlookDefaultLabel
                    PowerBIDefaultLabelId = $parsedSettings.PowerBIDefaultLabelId
                    SiteAndGroupDefaultLabel = $parsedSettings.SiteAndGroupDefaultLabelId
                    HasDocumentDefault   = $hasDocumentDefault
                    HasOutlookDefault    = $hasOutlookDefault
                    HasPowerBIDefault    = $hasPowerBIDefault
                    HasSiteGroupDefault  = $hasSiteGroupDefault
                    HasAnyDefault        = $hasAnyDefault
                    Scope                = if ($isGlobal) { 'Global' } else { 'Usuário/Grupo' }
                    LabelsCount          = $policy.Labels.Count
                }

                $allPolicySettings += $policyInfo

                if ($hasAnyDefault) {
                    $policiesWithDefaults += $policyInfo
                }
            }
        }
        catch {
            Write-PSFMessage "Error parsing label policy settings: $_" -Level Error
            $testResultMarkdown = "⚠️ Não foi possível determinar o status de rótulo padrão devido à estrutura inesperada das configurações de política: $_`n`n%TestResult%"
            $customStatus = 'Investigate'
        }

        # Determine pass/fail status and message (only if no error occurred)
        if ($null -eq $customStatus) {
            if ($policiesWithDefaults.Count -gt 0) {
                $passed = $true
                $testResultMarkdown = "✅ Rótulos padrão estão configurados para pelo menos uma carga de trabalho (Outlook, Teams/OneDrive, SharePoint/Grupos Microsoft 365 ou Power BI) em pelo menos uma política de rótulo de sensibilidade ativa.`n`n%TestResult%"
            }
            else {
                $passed = $false

                if ($enabledPolicies.Count -eq 0) {
                    $testResultMarkdown = "❌ Nenhuma política de rótulo de sensibilidade habilitada foi encontrada no locatário.`n`n%TestResult%"
                }
                else {
                    $testResultMarkdown = "❌ Nenhuma política de rótulo de sensibilidade tem rótulos padrão configurados para qualquer carga de trabalho.`n`n%TestResult%"
                }
            }
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    # Show table whenever we have policy settings
    if ($allPolicySettings.Count -gt 0) {
        # Build policy table
        $mdInfo += "`n`n### [Políticas de rótulo habilitadas](https://purview.microsoft.com/informationprotection/labelpolicies)`n"
        $mdInfo += "| Nome da política | Documentos/Emails | Outlook | Power BI | SharePoint/Grupos | Escopo | Rótulos |`n"
        $mdInfo += "| :--- | :--- | :--- | :--- | :--- | :--- | :--- |`n"

        foreach ($policy in $allPolicySettings) {
            $policyName = Get-SafeMarkdown -Text $policy.PolicyName
            $docIcon = if ($policy.HasDocumentDefault) { '✅' } else { '❌' }
            $outlookIcon = if ($policy.HasOutlookDefault) { '✅' } else { '❌' }
            $powerBIIcon = if ($policy.HasPowerBIDefault) { '✅' } else { '❌' }
            $siteGroupIcon = if ($policy.HasSiteGroupDefault) { '✅' } else { '❌' }
            $mdInfo += "| $policyName | $docIcon | $outlookIcon | $powerBIIcon | $siteGroupIcon | $($policy.Scope) | $($policy.LabelsCount) |`n"
        }

        # Build summary metrics
        $docDefaultCount = ($policiesWithDefaults | Where-Object { $_.HasDocumentDefault }).Count
        $outlookDefaultCount = ($policiesWithDefaults | Where-Object { $_.HasOutlookDefault }).Count
        $powerBIDefaultCount = ($policiesWithDefaults | Where-Object { $_.HasPowerBIDefault }).Count
        $siteGroupDefaultCount = ($policiesWithDefaults | Where-Object { $_.HasSiteGroupDefault }).Count

        $mdInfo += "`n`n### Resumo`n"
        $mdInfo += "| Métrica | Contagem |`n"
        $mdInfo += "| :--- | :--- |`n"
        $mdInfo += "| Total de políticas de rótulo habilitadas | $($allPolicySettings.Count) |`n"
        $mdInfo += "| Políticas com rótulos padrão | $($policiesWithDefaults.Count) |`n"
        $mdInfo += "| Padrão de Documentos/Emails | $docDefaultCount |`n"
        $mdInfo += "| Padrão do Outlook | $outlookDefaultCount |`n"
        $mdInfo += "| Padrão do Power BI | $powerBIDefaultCount |`n"
        $mdInfo += "| Padrão do SharePoint/Grupos | $siteGroupDefaultCount |"
    }

    # Report XML parsing errors if any occurred
    if ($xmlParseErrors.Count -gt 0) {
        $mdInfo += "`n`n### ⚠️ Erros de análise de XML`n"
        $mdInfo += "As políticas a seguir não puderam ser analisadas e foram excluídas da análise:`n`n"
        $mdInfo += "| Nome da política | Erro |`n"
        $mdInfo += "| :--- | :--- |`n"
        foreach ($parseError in $xmlParseErrors) {
            $errorMessage = Get-SafeMarkdown -Text $parseError.Error
            $policyName = Get-SafeMarkdown -Text $parseError.PolicyName
            $mdInfo += "| $policyName | $errorMessage |`n"
        }
        $mdInfo += "`n**Nota**: Essas políticas foram tratadas como não tendo rótulos padrão configurados.`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35017'
        Title  = 'Rótulo padrão configurado para rótulos de sensibilidade'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add CustomStatus if status is 'Investigate'
    if ($null -ne $customStatus) {
        $params.CustomStatus = $customStatus
    }

    # Add test result details
    Add-ZtTestResultDetail @params

}
