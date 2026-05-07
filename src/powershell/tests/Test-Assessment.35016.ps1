<#
.SYNOPSIS
    A rotulagem obrigatória está habilitada nas políticas de rótulo de sensibilidade
#>

function Test-Assessment-35016 {
    [ZtTest(
        Category = 'Proteção de Informações',
        ImplementationCost = 'Médio',
        Service = ('SecurityCompliance'),
        MinimumLicense = ('Microsoft 365 E3'),
        Pillar = 'Dados',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger tenants e sistemas em produção',
        TenantType = ('Workforce','External'),
        TestId = 35016,
        Title = 'A rotulagem obrigatória está habilitada nas políticas de rótulo de sensibilidade',
        UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando configuração de rotulagem obrigatória'

    # Q1: Retrieve all enabled sensitivity label policies to assess mandatory labeling configuration
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de rótulo de sensibilidade'
    $errorMsg = $null
    $enabledPolicies = @()

    try {
        $enabledPolicies = Get-LabelPolicy -WarningAction SilentlyContinue -ErrorAction Stop | Where-Object { $_.Enabled -eq $true }
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar políticas de rótulo: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $allPolicySettings = @()
    $mandatoryPolicies = @()
    $xmlParseErrors = @()
    $passed = $false
    $customStatus = $null

    if ($errorMsg) {
        $testResultMarkdown = "⚠️ Não foi possível determinar o status do modo de aplicação automática de rotulagem devido a problemas de permissões ou falha na consulta.`n`n"
        $customStatus = 'Investigate'
    }
    else {
        Write-PSFMessage "Found $($enabledPolicies.Count) enabled label policies" -Level Verbose

        try {
            # Examine label policy settings for mandatory labeling
            foreach ($policy in $enabledPolicies) {
                # Determine policy scope:
                # - Global if any location is set to "All"
                # - Scoped if specific users/groups are defined
                $allLocationNames = @(
                    $policy.ExchangeLocation.Name
                    $policy.ModernGroupLocation.Name
                    $policy.SharePointLocation.Name
                    $policy.OneDriveLocation.Name
                    $policy.SkypeLocation.Name
                    $policy.PublicFolderLocation.Name
                ) | Where-Object { $_ }

                $isGlobal = $allLocationNames -contains 'All'

                $policySettings = @{
                    PolicyName = $policy.Name
                    Guid = $policy.Guid
                    Enabled = $policy.Enabled
                    EmailMandatory = $false
                    TeamworkMandatory = $false
                    SiteGroupMandatory = $false
                    PowerBIMandatory = $false
                    EmailOverride = $false
                    Scope = if ($isGlobal) { 'Global' } else { 'Usuário/Grupo' }
                    LabelsCount = $policy.Labels.Count
                }

                # Parse PolicySettingsBlob XML for mandatory labeling flags
                if (-not [string]::IsNullOrWhiteSpace($policy.PolicySettingsBlob)) {
                    try {
                        $xmlSettings = [xml]$policy.PolicySettingsBlob

                        # Validate XML structure before accessing properties
                        if ($xmlSettings.settings -and $xmlSettings.settings.setting) {
                            # Access settings as XML elements for direct property lookup
                            foreach ($setting in $xmlSettings.settings.setting) {
                                # Add null safety for key and value attributes
                                if (-not $setting.key -or -not $setting.value) {
                                    Write-PSFMessage "Skipping setting with null key or value in policy '$($policy.Name)'" -Level Verbose
                                    continue
                                }

                                $key = $setting.key.ToLower()
                                $value = $setting.value.ToLower()

                                switch ($key) {
                                    'mandatory' {
                                        $policySettings.EmailMandatory = ($value -eq 'true')
                                    }
                                    'teamworkmandatory' {
                                        $policySettings.TeamworkMandatory = ($value -eq 'true')
                                    }
                                    'siteandgroupmandatory' {
                                        $policySettings.SiteGroupMandatory = ($value -eq 'true')
                                    }
                                    'powerbimandatory' {
                                        $policySettings.PowerBIMandatory = ($value -eq 'true')
                                    }
                                    'disablemandatoryinoutlook' {
                                        $policySettings.EmailOverride = ($value -eq 'true')
                                    }
                                    default {
                                        Write-PSFMessage "Unknown setting key '$key' in policy '$($policy.Name)'" -Level Verbose
                                    }
                                }
                            }
                        }
                        else {
                            Write-PSFMessage "Policy '$($policy.Name)' has PolicySettingsBlob but no settings elements found" -Level Verbose
                        }
                    }
                    catch {
                        # Track parsing errors for reporting
                        $xmlParseErrors += [PSCustomObject]@{
                            PolicyName = $policy.Name
                            Error = $_.Exception.Message
                        }
                        Write-PSFMessage "Error parsing PolicySettingsBlob XML for policy '$($policy.Name)': $_" -Level Warning
                    }
                }

                # Per Microsoft documentation, disablemandatoryinoutlook can be set to explicitly
                # disable mandatory labeling in Outlook even when the 'mandatory' setting is true.
                # This provides an exception path for organizations that need mandatory labeling
                # for files but not emails. Apply the override logic:
                if ($policySettings.EmailMandatory -and $policySettings.EmailOverride) {
                    $policySettings.EmailMandatory = $false
                }

                # Store all policy settings
                $allPolicySettings += [PSCustomObject]$policySettings

                # Determine if this policy has ANY mandatory setting enabled (after applying overrides)
                $hasMandatory = $policySettings.EmailMandatory -or
                                $policySettings.TeamworkMandatory -or
                                $policySettings.SiteGroupMandatory -or
                                $policySettings.PowerBIMandatory

                if ($hasMandatory) {
                    $mandatoryPolicies += [PSCustomObject]$policySettings
                }
            }
        }
        catch {
            Write-PSFMessage "Error parsing label policy settings: $_" -Level Error
            $testResultMarkdown = "⚠️ Não foi possível determinar o status de rotulagem obrigatória devido à complexidade da política ou estrutura de configurações inesperada.`n`n"
            $customStatus = 'Investigate'
        }

        # Determine pass/fail status and message (only if no error occurred)
        if ($null -eq $customStatus) {
            if ($mandatoryPolicies.Count -gt 0) {
                $passed = $true
                $testResultMarkdown = "✅ A rotulagem obrigatória está configurada e aplicada por meio de pelo menos uma política de rótulo de sensibilidade ativa em uma ou mais cargas de trabalho (Outlook, Teams/OneDrive, SharePoint/Grupos Microsoft 365 ou Power BI).`n`n%TestResult%"
            }
            else {
                $passed = $false

                if ($enabledPolicies.Count -eq 0) {
                    $testResultMarkdown = "❌ Nenhuma política de rótulo de sensibilidade habilitada foi encontrada no locatário.`n`n%TestResult%"
                }
                else {
                    $testResultMarkdown = "❌ Nenhuma política de rótulo de sensibilidade exige que os usuários apliquem rótulos em qualquer carga de trabalho (emails, arquivos, sites, grupos ou conteúdo do Power BI).`n`n%TestResult%"
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
        $mdInfo += "| Nome da política | Email | Arquivos/Colaboração | Sites/Grupos | Power BI | Substituição de email | Escopo | Rótulos |`n"
        $mdInfo += "| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |`n"

        foreach ($policy in $allPolicySettings) {
            $policyName = Get-SafeMarkdown -Text $policy.PolicyName
            $emailIcon = if ($policy.EmailMandatory) { '✅' } else { '❌' }
            $teamworkIcon = if ($policy.TeamworkMandatory) { '✅' } else { '❌' }
            $siteGroupIcon = if ($policy.SiteGroupMandatory) { '✅' } else { '❌' }
            $powerBIIcon = if ($policy.PowerBIMandatory) { '✅' } else { '❌' }
            $overrideIcon = if ($policy.EmailOverride) { 'Sim' } else { 'Não' }
            $mdInfo += "| $policyName | $emailIcon | $teamworkIcon | $siteGroupIcon | $powerBIIcon | $overrideIcon | $($policy.Scope) | $($policy.LabelsCount) |`n"
        }

        # Build summary metrics
        $emailCount = ($mandatoryPolicies | Where-Object { $_.EmailMandatory }).Count
        $teamworkCount = ($mandatoryPolicies | Where-Object { $_.TeamworkMandatory }).Count
        $siteGroupCount = ($mandatoryPolicies | Where-Object { $_.SiteGroupMandatory }).Count
        $powerBICount = ($mandatoryPolicies | Where-Object { $_.PowerBIMandatory }).Count

        $mdInfo += "`n`n### Resumo`n"
        $mdInfo += "| Métrica | Contagem |`n"
        $mdInfo += "| :--- | :--- |`n"
        $mdInfo += "| Total de políticas de rótulo habilitadas | $($allPolicySettings.Count) |`n"
        $mdInfo += "| Total de políticas de rótulo habilitadas com rotulagem obrigatória | $($mandatoryPolicies.Count) |`n"
        $mdInfo += "| Rotulagem obrigatória de email | $emailCount |`n"
        $mdInfo += "| Rotulagem obrigatória de arquivo/colaboração | $teamworkCount |`n"
        $mdInfo += "| Rotulagem obrigatória de site/grupo | $siteGroupCount |`n"
        $mdInfo += "| Rotulagem obrigatória do Power BI | $powerBICount |"
    }

    # Report XML parsing errors if any occurred
    if ($xmlParseErrors.Count -gt 0) {
        $mdInfo += "`n`n### ⚠️ Erros de análise de XML`n"
        $mdInfo += "As políticas a seguir não puderam ser analisadas e foram excluídas da análise:`n`n"
        $mdInfo += "| Nome da política | Erro |`n"
        $mdInfo += "| :--- | :--- |`n"
        foreach ($xmlParseError in $xmlParseErrors) {
            $errorMsg = Get-SafeMarkdown -Text $xmlParseError.Error
            $policyName = Get-SafeMarkdown -Text $xmlParseError.PolicyName
            $mdInfo += "| $policyName | $errorMsg |`n"
        }
        $mdInfo += "`n**Nota**: Essas políticas foram tratadas como não tendo rotulagem obrigatória configurada.`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35016'
        Title  = 'Rotulagem obrigatória habilitada para rótulos de sensibilidade'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add CustomStatus if status is 'Investigate'
    if ($null -ne $customStatus) {
        $params.CustomStatus = $customStatus
    }

    Add-ZtTestResultDetail @params
}
