<#
.SYNOPSIS
    Valida que os logs de acesso de rede são retidos para análise de segurança
    e requisitos de conformidade.

.DESCRIPTION
    Este teste avalia as configurações de diagnóstico do Microsoft Entra para garantir que
    as categorias de log do Global Secure Access estão ativadas com períodos de retenção apropriados
    (mínimo de 90 dias) nos espaços de trabalho do Log Analytics.

.NOTES
    Test ID: 25420
    Category: Global Secure Access
    Required APIs: Azure Management REST API (diagnostic settings, workspaces)
#>

function Test-Assessment-25420 {

    [ZtTest(
        Category = 'Acesso Seguro Global',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('AAD_PREMIUM', 'Entra_Premium_Internet_Access', 'Entra_Premium_Private_Access'),
        CompatibleLicense = ('Entra_Premium_Private_Access','Entra_Premium_Internet_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Monitorar e detectar ciberameaças',
        TenantType = ('Workforce'),
        TestId = 25420,
        Title = 'Os logs de acesso à rede são retidos para análise de segurança e conformidade',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    # Minimum retention period in days for compliance
    $MINIMUM_RETENTION_DAYS = 90

    # Required Global Secure Access log categories
    $REQUIRED_LOG_CATEGORIES = @(
        'AuditLogs',                          # Audit logs for configuration changes to Global Secure Access
        'NetworkAccessTrafficLogs',           # Network traffic logs
        'EnrichedOffice365AuditLogs',         # Enriched Office 365 audit logs with network context
        'RemoteNetworkHealthLogs',            # Remote network health logs
        'NetworkAccessAlerts',                # Security alerts
        'NetworkAccessConnectionEvents',     # Connection event logs
        'NetworkAccessGenerativeAIInsights'  # AI-generated insights and security recommendations
    )

    #region Data Collection

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Avaliando configuração de retenção de log de acesso de rede'

    # Check if connected to Azure
    Write-ZtProgress -Activity $activity -Status 'Verificando conexão do Azure'

    $azContext = Get-AzContext -ErrorAction SilentlyContinue
    if (-not $azContext) {
        Write-PSFMessage 'Not connected to Azure.' -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedAzure
        return
    }

    # Check the supported environment, 'AzureCloud' in (Get-AzContext).Environment.Name maps to 'Global' in (Get-MgContext).Environment
    Write-ZtProgress -Activity $activity -Status 'Verificando ambiente do Azure'

    if ($azContext.Environment.Name -ne 'AzureCloud') {
        Write-PSFMessage 'This test is only applicable to the AzureCloud environment.' -Tag Test -Level VeryVerbose
        Add-ZtTestResultDetail -SkippedBecause NotSupported
        return
    }

        # Consulta diagnostic settings for Microsoft Entra
    Write-ZtProgress -Activity $activity -Status 'Consultando configurações de diagnóstico'

    $resourceManagementUrl = $azContext.Environment.ResourceManagerUrl
    $diagnosticSettingsUri = $resourceManagementUrl + 'providers/microsoft.aadiam/diagnosticsettings?api-version=2017-04-01-preview'

    $diagnosticSettings = $null
    try {
        $result = Invoke-AzRestMethod -Method GET -Uri $diagnosticSettingsUri -ErrorAction Stop

        if ($result.StatusCode -eq 403) {
            Write-PSFMessage 'O usuário conectado não tem acesso para verificar as configurações de diagnóstico.' -Level Verbose
            Add-ZtTestResultDetail -SkippedBecause NoAzureAccess
            return
        }

        if ($result.StatusCode -ge 400) {
            throw "Falha na solicitação de configurações de diagnóstico com código de status $($result.StatusCode)"
        }

        $diagnosticSettings = ($result.Content | ConvertFrom-Json).value
    }
    catch {
        # Only catches actual exceptions (network errors, etc.), not HTTP status codes
        throw
    }

        # Consulta Q2: Retrieve Log Analytics workspace retention settings for each configured workspace
    $workspaceDetails = @{}

    if ($null -ne $diagnosticSettings -and $diagnosticSettings.Count -gt 0) {

        Write-ZtProgress -Activity $activity -Status 'Verificando configurações de retenção de espaço de trabalho'

        $workspaceIds = $diagnosticSettings |
            Where-Object { $_.properties.workspaceId } |
            Select-Object -ExpandProperty properties |
            Select-Object -ExpandProperty workspaceId -Unique

        foreach ($workspaceId in $workspaceIds) {
            try {
                $workspaceUri = $resourceManagementUrl.TrimEnd('/') + $workspaceId + '?api-version=2023-09-01'
                $workspaceResponse = Invoke-AzRestMethod -Method GET -Uri $workspaceUri -ErrorAction Stop

                if ($workspaceResponse.StatusCode -ge 400) {
                    Write-PSFMessage "Failed to query workspace $workspaceId with status code $($workspaceResponse.StatusCode)" -Level Warning
                    $workspaceDetails[$workspaceId] = $null
                }
                else {
                    $workspaceDetails[$workspaceId] = ($workspaceResponse.Content | ConvertFrom-Json)
                }
            }
            catch {
                Write-PSFMessage "Error querying workspace $workspaceId : $_" -Level Warning
                $workspaceDetails[$workspaceId] = $null
            }
        }
    }

    #endregion Data Collection

    #region Assessment Logic

    # Initialize evaluation containers
    $passed              = $false
    $testResultMarkdown  = ''
    $diagResults         = @()
    $logCategoryStatus   = @{}
    $hasAdequateRetention      = $false
    $hasAllRequiredCategories  = $false
    $passingSettingFound       = $false

    # Step 1: Check if any diagnostic settings exist
    if ($null -eq $diagnosticSettings -or $diagnosticSettings.Count -eq 0) {

        $passed = $false
        $testResultMarkdown = "❌ Nenhuma configuração de diagnóstico está definida para o Microsoft Entra. Os logs do Acesso Seguro Global são retidos por apenas 30 dias (retenção padrão no portal), o que é insuficiente para investigações de segurança.`n`n%TestResult%"

    }
    else {

        Write-ZtProgress -Activity $activity -Status 'Avaliando categorias de log e retenção'

        # Initialize log category tracking
        foreach ($category in $REQUIRED_LOG_CATEGORIES) {
            $logCategoryStatus[$category] = @{
                Enabled         = $false
                DestinationType = 'None'
                RetentionDays   = $null
                MeetsMinimum    = $false
            }
        }

        foreach ($setting in $diagnosticSettings) {

            $workspaceId      = $setting.properties.workspaceId
            $storageAccountId = $setting.properties.storageAccountId
            $logs             = $setting.properties.logs

            # Step 2: Determine destination type (Workspace, Storage, or both)
            $destinationType = 'None'
            if ($workspaceId -and $storageAccountId) {
                $destinationType = 'Workspace & Storage'
            }
            elseif ($workspaceId) {
                $destinationType = 'Workspace'
            }
            elseif ($storageAccountId) {
                $destinationType = 'Storage'
            }

            # Step 3: Get workspace retention if applicable
            $retentionDays  = $null
            $workspaceName  = $null
            if ($workspaceId -and $workspaceDetails.ContainsKey($workspaceId) -and $workspaceDetails[$workspaceId]) {
                $workspace     = $workspaceDetails[$workspaceId]
                $retentionDays = $workspace.properties.retentionInDays
                $workspaceName = $workspace.name
            }

            # Step 4: Evaluate if this setting meets minimum retention criteria
            $meetsMinimum = $false
            if ($retentionDays -ge $MINIMUM_RETENTION_DAYS) {
                $meetsMinimum = $true
            }
            elseif ($storageAccountId) {
                # Storage account retention cannot be queried via this API; assume meets minimum, flag for manual review
                $meetsMinimum = $true
            }

            $enabledCategories = @()

            # Step 5: Process log categories for this setting and track best configuration
            foreach ($log in $logs) {
                $categoryName = $log.category
                $isEnabled    = $log.enabled

                if ($categoryName -in $REQUIRED_LOG_CATEGORIES -and $isEnabled) {
                    $enabledCategories += $categoryName

                    # Update global category status if this is a better configuration
                    # Prioritize: 1) configs that meet minimum, 2) higher retention days
                    $currentStatus = $logCategoryStatus[$categoryName]
                    $shouldUpdate = $false

                    if (-not $currentStatus.Enabled) {
                        $shouldUpdate = $true
                    }
                    elseif ($meetsMinimum -and -not $currentStatus.MeetsMinimum) {
                        # New config meets minimum but current doesn't - always prefer
                        $shouldUpdate = $true
                    }
                    elseif ($meetsMinimum -eq $currentStatus.MeetsMinimum) {
                        # Both meet or both don't meet minimum - compare retention days
                        if ($retentionDays -and (-not $currentStatus.RetentionDays -or $retentionDays -gt $currentStatus.RetentionDays)) {
                            $shouldUpdate = $true
                        }
                    }

                    if ($shouldUpdate) {
                        $logCategoryStatus[$categoryName] = @{
                            Enabled         = $true
                            DestinationType = $destinationType
                            RetentionDays   = $retentionDays
                            MeetsMinimum    = $meetsMinimum
                        }
                    }
                }
            }

            # Step 6: Check if this setting has all required categories AND meets retention criteria
            $settingHasAllCategories = ($enabledCategories.Count -eq $REQUIRED_LOG_CATEGORIES.Count)
            if ($settingHasAllCategories -and $meetsMinimum) {
                $passingSettingFound = $true
            }

            # Determine per-setting status
            # Storage-only settings require manual review since retention policies cannot be queried via this API
            $settingStatus = if ($storageAccountId -and -not $workspaceId) {
                'Manual review'
            } elseif ($settingHasAllCategories -and $meetsMinimum) {
                'Adequate'
            } else {
                'Insufficient'
            }

            $diagResults += [PSCustomObject]@{
                SettingName       = $setting.name
                WorkspaceId       = $workspaceId
                WorkspaceName     = $workspaceName
                StorageAccountId  = $storageAccountId
                DestinationType   = $destinationType
                RetentionDays     = $retentionDays
                MeetsMinimum      = $meetsMinimum
                EnabledCategories = $enabledCategories
                Status            = $settingStatus
            }
        }

        # Step 7: Verify all required Global Secure Access log categories are enabled (across all settings)
        $enabledCategoryCount = ($logCategoryStatus.GetEnumerator() | Where-Object { $_.Value.Enabled }).Count
        $hasAllRequiredCategories = ($enabledCategoryCount -eq $REQUIRED_LOG_CATEGORIES.Count)

        # Step 8: Check if any category meets minimum retention (used for summary reporting)
        # Note: Pass/fail is determined by $passingSettingFound which requires ALL categories in ONE setting
        $hasAdequateRetention = ($logCategoryStatus.GetEnumerator() | Where-Object { $_.Value.MeetsMinimum }).Count -gt 0

        # Step 9: Determine overall test result
        if ($passingSettingFound) {

            $passed = $true
            $testResultMarkdown = "✅ Os logs do Acesso Seguro Global são retidos por pelo menos $MINIMUM_RETENTION_DAYS dias, atendendo aos requisitos de análise de segurança e conformidade.`n`n%TestResult%"

        }
        else {

            $passed = $false
            $testResultMarkdown = "❌ Os logs do Acesso Seguro Global não são retidos por tempo suficiente para suportar investigações de segurança e obrigações de conformidade.`n`n%TestResult%"

        }
    }

    #endregion Assessment Logic

    #region Report Generation

    # Calculate summary metrics
    $settingsWithLongTermDest = ($diagResults | Where-Object { $_.WorkspaceId -or $_.StorageAccountId }).Count
    $workspaceRetentions = $diagResults | Where-Object { $_.RetentionDays } | Select-Object -ExpandProperty RetentionDays
    $avgRetention = if ($workspaceRetentions.Count -gt 0) {
        [math]::Round(($workspaceRetentions | Measure-Object -Average).Average, 0) # Round to whole days for compliance reporting
    } else { $null }
    $minRetention = if ($workspaceRetentions.Count -gt 0) {
        ($workspaceRetentions | Measure-Object -Minimum).Minimum
    } else { $null }

    $mdInfo = "`n## [Configuração de diagnóstico](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/DiagnosticSettings)`n`n"

    # Log Retention Status table
    if ($logCategoryStatus.Count -gt 0) {
        $tableRows = ""
        $formatTemplate = @'
### Status de retenção de log

| Categoria de log | Habilitado | Tipo de destino | Período de retenção | Atende ao mínimo (90 dias) |
| :--- | :--- | :--- | :--- | :--- |
{0}

'@
        foreach ($category in $REQUIRED_LOG_CATEGORIES) {
            $status       = $logCategoryStatus[$category]
            $enabledText  = if ($status.Enabled) { 'Sim' } else { 'Não' }
            $destType     = if ($status.Enabled) { $status.DestinationType } else { 'Nenhum' }

            # For storage-only destinations, retention cannot be queried via API
            $isStorageOnly = $status.DestinationType -eq 'Storage'
            $retention = if ($status.RetentionDays) {
                "$($status.RetentionDays) dias"
            } elseif ($isStorageOnly) {
                'Verificação manual necessária'
            } else {
                'Não configurado'
            }
            $meetsMinText = if ($status.MeetsMinimum) { 'Sim' } else { 'Não' }

            $tableRows   += "| $category | $enabledText | $destType | $retention | $meetsMinText |`n"
        }
        $mdInfo += $formatTemplate -f $tableRows
    }

    # Destination Details table
    if ($diagResults.Count -gt 0) {
        $tableRows = ""
        $formatTemplate = @'
### Detalhes do destino

| Tipo de destino | Nome do recurso | Retenção padrão | Status |
| :--- | :--- | :--- | :--- |
{0}

'@
        foreach ($diag in $diagResults) {
            # Add hyperlink to destination type based on type
            $destType = if ($diag.WorkspaceName -and $diag.StorageAccountId) {
                "[Log Analytics workspace](https://portal.azure.com/?feature.msaljs=true#browse/Microsoft.OperationalInsights%2Fworkspaces) & [Storage Account](https://portal.azure.com/?feature.msaljs=true#view/Microsoft_Azure_StorageHub/StorageHub.MenuView/~/StorageAccountsBrowse)"
            }
            elseif ($diag.WorkspaceName) {
                "[Log Analytics workspace](https://portal.azure.com/?feature.msaljs=true#browse/Microsoft.OperationalInsights%2Fworkspaces)"
            }
            elseif ($diag.StorageAccountId) {
                "[Storage account](https://portal.azure.com/?feature.msaljs=true#view/Microsoft_Azure_StorageHub/StorageHub.MenuView/~/StorageAccountsBrowse)"
            }
            else { 'None' }
            $resourceName = if ($diag.WorkspaceName) { Get-SafeMarkdown $diag.WorkspaceName }
                           elseif ($diag.StorageAccountId) { Get-SafeMarkdown ($diag.StorageAccountId.Split('/')[-1]) }
                           else { 'N/A' }
            $retention = if ($diag.RetentionDays) { "$($diag.RetentionDays) dias" }
                        elseif ($diag.StorageAccountId) { 'Verificação manual necessária' }
                        else { 'N/A' }
            $tableRows += "| $destType | $resourceName | $retention | $($diag.Status) |`n"
        }
        $mdInfo += $formatTemplate -f $tableRows
    }

    # Summary table (per spec format)
    $mdInfo += "### Resumo`n`n"
    $mdInfo += "| Métrica | Valor |`n| :--- | :--- |`n"
    $mdInfo += "| Total de configurações de diagnóstico | $($diagnosticSettings.Count) |`n"
    $mdInfo += "| Configurações com destino de longo prazo | $settingsWithLongTermDest |`n"
    $mdInfo += "| Período médio de retenção | $(if ($avgRetention) { "$avgRetention dias" } else { 'N/A' }) |`n"
    $mdInfo += "| Retenção mínima encontrada | $(if ($minRetention) { "$minRetention dias" } else { 'N/A' }) |`n"
    $mdInfo += "| Atende ao mínimo de 90 dias | $(if ($hasAdequateRetention) { 'Sim' } else { 'Não' }) |`n"

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo

    #endregion Report Generation

    $params = @{
        TestId = '25420'
        Title  = 'Logs de acesso à rede retidos para análise de segurança e conformidade'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
