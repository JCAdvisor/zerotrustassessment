<#
.SYNOPSIS
    Validates that diagnostic logging is enabled for Azure Front Door WAF.

.DESCRIPTION
    This test evaluates diagnostic settings for Azure Front Door profiles to ensure
    WAF log categories are enabled with a valid destination configured (Log Analytics,
    Storage Account, or Event Hub).

.NOTES
    Test ID: 26889
    Category: Azure Network Security
    Required APIs: Azure Resource Graph (profiles, WAF policies), Azure Management REST API (diagnostic settings)
#>

function Test-Assessment-26889 {

    [ZtTest(
        Category = 'Segurança de rede do Azure',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Azure_FrontDoor_Standard', 'Azure_FrontDoor_Premium'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Monitorar e detectar ciberameaças',
        TenantType = ('Workforce'),
        TestId = 26889,
        Title = 'O registro de diagnóstico está habilitado no WAF do Azure Front Door',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    # Required log categories for comprehensive Azure Front Door WAF monitoring
    $REQUIRED_LOG_CATEGORIES = @(
        'FrontDoorAccessLog',
        'FrontDoorWebApplicationFirewallLog',
        'FrontDoorHealthProbeLog'
    )

    # WAF log category to check for pass/fail criteria (per spec)
    $WAF_LOG_CATEGORY = 'FrontDoorWebApplicationFirewallLog'

    #region Data Collection

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Avaliando a configuração de logs de diagnóstico do WAF do Azure Front Door'

    # Check if connected to Azure
    Write-ZtProgress -Activity $activity -Status 'Verificando conexão com o Azure'

    $azContext = Get-AzContext -ErrorAction SilentlyContinue
    if (-not $azContext) {
        Write-PSFMessage 'Not connected to Azure.' -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedAzure
        return
    }

    # Check the supported environment
    Write-ZtProgress -Activity $activity -Status 'Verificando ambiente do Azure'

    if ($azContext.Environment.Name -ne 'AzureCloud') {
        Write-PSFMessage 'This test is only applicable to the AzureCloud environment.' -Tag Test -Level VeryVerbose
        Add-ZtTestResultDetail -SkippedBecause NotSupported
        return
    }

    # Check Azure access token
    try {
        $accessToken = Get-AzAccessToken -AsSecureString -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }
    catch {
        Write-PSFMessage $_.Exception.Message -Tag Test -Level Error
    }

    if (-not $accessToken) {
        Write-PSFMessage 'Azure authentication token not found.' -Tag Test -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedAzure
        return
    }

    # Q1, Q2, Q3: Query Azure Front Door profiles with WAF associations using Azure Resource Graph
    Write-ZtProgress -Activity $activity -Status 'Consultando perfis do Azure Front Door via Resource Graph'

    # ARG query to get Front Door Standard/Premium profiles with their associated WAF policies
    # Uses securityPolicyLinks from WAF policies to correlate with Front Door profiles
    $argQuery = @"
resources
| where type =~ 'microsoft.cdn/profiles'
| where sku.name in~ ('Standard_AzureFrontDoor', 'Premium_AzureFrontDoor')
| project
    FrontDoorId = tolower(id),
    FrontDoorName = name,
    SkuName = tostring(sku.name),
    subscriptionId
| join kind=inner (
    resources
    | where type =~ 'microsoft.network/frontdoorwebapplicationfirewallpolicies'
    | mv-expand securityPolicyLink = properties.securityPolicyLinks
    | extend LinkedProfileId = tostring(securityPolicyLink.id)
    | extend LinkedProfileIdLower = tolower(extract('(.+/providers/Microsoft.Cdn/profiles/[^/]+)', 1, LinkedProfileId))
    | project WafPolicyName = name, LinkedProfileIdLower
) on `$left.FrontDoorId == `$right.LinkedProfileIdLower
| join kind=leftouter (
    resourcecontainers
    | where type =~ 'microsoft.resources/subscriptions'
    | project subscriptionId, SubscriptionName = name
) on subscriptionId
| summarize WafPolicyNames = make_set(WafPolicyName) by FrontDoorId, FrontDoorName, SkuName, subscriptionId, SubscriptionName
| project FrontDoorId, FrontDoorName, SkuName, subscriptionId, SubscriptionName, WafPolicyName = strcat_array(WafPolicyNames, ', ')
"@

    $profilesWithWaf = @()
    try {
        $profilesWithWaf = @(Invoke-ZtAzureResourceGraphRequest -Query $argQuery)
        Write-PSFMessage "ARG Query returned $($profilesWithWaf.Count) Azure Front Door profile(s) with WAF" -Tag Test -Level VeryVerbose
    }
    catch {
        Write-PSFMessage "Azure Resource Graph query failed: $($_.Exception.Message)" -Tag Test -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotSupported
        return
    }

    # Skip if no Azure Front Door profiles with WAF exist (per spec step 6)
    if ($profilesWithWaf.Count -eq 0) {
        Write-PSFMessage 'No Azure Front Door profiles with WAF found.' -Tag Test -Level VeryVerbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable
        return
    }

    # Q4: Get diagnostic settings for each Front Door resource
    Write-ZtProgress -Activity $activity -Status 'Consultando configurações de diagnóstico'

    $evaluationResults = @()

    # Iterate only over profiles with WAF (from ARG query above)
    foreach ($fdItem in $profilesWithWaf) {
        $frontDoorId = $fdItem.FrontDoorId
        $frontDoorName = $fdItem.FrontDoorName
        $wafPolicyName = $fdItem.WafPolicyName

        # Q4: Query diagnostic settings using Invoke-ZtAzureRequest
        $diagPath = $frontDoorId + '/providers/Microsoft.Insights/diagnosticSettings?api-version=2021-05-01-preview'

        $diagSettings = @()
        try {
            $diagSettings = @(Invoke-ZtAzureRequest -Path $diagPath)
        }
        catch {
            Write-PSFMessage "Error querying diagnostic settings for $frontDoorName : $_" -Level Warning
        }

        # Fallback: If WAF policy name not found via ARG, query security policies endpoint
        if (-not $wafPolicyName -or $wafPolicyName -eq 'None') {
            $securityPoliciesPath = $frontDoorId + '/securityPolicies?api-version=2024-02-01'

            try {
                $securityPolicies = @(Invoke-ZtAzureRequest -Path $securityPoliciesPath)
                # Get WAF policy references from security policies
                $wafPolicyIds = $securityPolicies | ForEach-Object {
                    $_.properties.parameters.wafPolicy.id
                } | Where-Object { $_ }

                if ($wafPolicyIds) {
                    # Extract WAF policy names and join if multiple
                    $wafPolicyNames = $wafPolicyIds | ForEach-Object {
                        ($_ -split '/')[-1]
                    }
                    $wafPolicyName = ($wafPolicyNames | Select-Object -Unique) -join ', '
                }
            }
            catch {
                Write-PSFMessage "Error querying security policies for $frontDoorName : $_" -Level Warning
            }
        }

        # Evaluate diagnostic settings
        $hasValidDiagSetting = $false
        $destinationType = 'None'
        $enabledCategories = @()
        $diagSettingNames = @()

        foreach ($setting in $diagSettings) {
            $workspaceId = $setting.properties.workspaceId
            $storageAccountId = $setting.properties.storageAccountId
            $eventHubAuthRuleId = $setting.properties.eventHubAuthorizationRuleId

            # Check if destination is configured
            $hasDestination = $workspaceId -or $storageAccountId -or $eventHubAuthRuleId

            if ($hasDestination) {
                $hasValidDiagSetting = $true
                $diagSettingNames += $setting.name

                # Determine destination type
                $destTypes = @()
                if ($workspaceId) { $destTypes += 'Log Analytics' }
                if ($storageAccountId) { $destTypes += 'Storage' }
                if ($eventHubAuthRuleId) { $destTypes += 'Event Hub' }
                $destinationType = $destTypes -join ', '

                # Collect all enabled log categories
                $logs = $setting.properties.logs
                foreach ($log in $logs) {
                    if ($log.enabled) {
                        if ($log.categoryGroup -eq 'allLogs' -or $log.categoryGroup -eq 'audit') {
                            # categoryGroup covers all categories in the group
                            $enabledCategories += $REQUIRED_LOG_CATEGORIES
                        }
                        elseif ($log.category) {
                            $enabledCategories += $log.category
                        }
                    }
                }
            }
        }

        # Join diagnostic setting names after evaluating all settings
        $diagSettingName = if ($diagSettingNames.Count -gt 0) { ($diagSettingNames | Select-Object -Unique) -join ', ' } else { 'None' }

        # Check which required log categories are enabled and if WAF log is enabled for pass criteria
        $enabledCategories = $enabledCategories | Select-Object -Unique
        $missingRequiredCategories = $REQUIRED_LOG_CATEGORIES | Where-Object { $_ -notin $enabledCategories }
        $wafLogEnabled = $WAF_LOG_CATEGORY -in $enabledCategories

        $status = if ($hasValidDiagSetting -and $wafLogEnabled) { 'Pass' } else { 'Fail' }

        $evaluationResults += [PSCustomObject]@{
            SubscriptionId        = $fdItem.subscriptionId
            SubscriptionName      = $fdItem.SubscriptionName
            FrontDoorName         = $frontDoorName
            FrontDoorId           = $frontDoorId
            Sku                   = $fdItem.SkuName
            WafPolicy             = $wafPolicyName
            DiagnosticSettingCount = $diagSettings.Count
            DiagnosticSettingName = $diagSettingName
            DestinationType       = $destinationType
            EnabledCategories     = $enabledCategories -join ', '
            MissingRequiredCategories = $missingRequiredCategories -join ', '
            WafLogEnabled         = $wafLogEnabled
            Status                = $status
        }
    }

    #endregion Data Collection

    #region Assessment Logic

    $passedItems = $evaluationResults | Where-Object { $_.Status -eq 'Pass' }
    $failedItems = $evaluationResults | Where-Object { $_.Status -eq 'Fail' }

    $passed = ($failedItems.Count -eq 0) -and ($passedItems.Count -gt 0)

    if ($passed) {
        $testResultMarkdown = "✅ O registro de diagnóstico está habilitado no WAF do Azure Front Door com coleta de logs ativa configurada.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ O registro de diagnóstico não está habilitado no WAF do Azure Front Door, impedindo o monitoramento de segurança e a detecção de ameaças na borda.`n`n%TestResult%"
    }

    #endregion Assessment Logic

    #region Report Generation

    $mdInfo = "`n## [Status do registro de diagnóstico do WAF do Azure Front Door](https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.Cdn%2Fprofiles)`n`n"

    # Front Door Status table
    if ($evaluationResults.Count -gt 0) {
        $tableRows = ""
        $formatTemplate = @'
| Assinatura | Nome do perfil | SKU | Política de WAF | Contagem de configurações de diagnóstico | Destino configurado | Categorias de log habilitadas | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
{0}

'@
        foreach ($result in $evaluationResults) {
            $subscriptionLink = "[$(Get-SafeMarkdown $result.SubscriptionName)](https://portal.azure.com/#resource/subscriptions/$($result.SubscriptionId)/overview)"
            $profileLink = "[$(Get-SafeMarkdown $result.FrontDoorName)](https://portal.azure.com/#resource$($result.FrontDoorId)/diagnostics)"
            $diagCount = $result.DiagnosticSettingCount
            $destConfigured = if ($result.DestinationType -eq 'None') { 'No' } else { 'Yes' }
            $enabledCategories = if ($result.DiagnosticSettingCount -eq 0) {
                'Sem configurações de diagnóstico'
            } elseif ($result.EnabledCategories) {
                $result.EnabledCategories
            } else {
                'None'
            }
            $statusText = if ($result.Status -eq 'Pass') { '✅ Aprovado' } else { '❌ Reprovado' }

            $tableRows += "| $subscriptionLink | $profileLink | $($result.Sku) | $(Get-SafeMarkdown $result.WafPolicy) | $diagCount | $destConfigured | $enabledCategories | $statusText |`n"
        }
        $mdInfo += $formatTemplate -f $tableRows
    }

    # Summary
    $mdInfo += "**Resumo:**`n`n"
    $mdInfo += "- Total de perfis do Azure Front Door com WAF avaliados: $($evaluationResults.Count)`n"
    $mdInfo += "- Perfis com registro de diagnóstico habilitado: $($passedItems.Count)`n"
    $mdInfo += "- Perfis sem registro de diagnóstico: $($failedItems.Count)`n"

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo

    #endregion Report Generation

    $params = @{
        TestId = '26889'
        Title  = 'O registro de diagnóstico está habilitado no WAF do Azure Front Door'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
