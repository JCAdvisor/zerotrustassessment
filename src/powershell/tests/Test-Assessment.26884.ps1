<#
.SYNOPSIS
    Validates that bot protection ruleset is enabled and assigned in Azure Front Door WAF.

.DESCRIPTION
    This test evaluates Azure Front Door Premium profiles to ensure the Bot Manager rule set
    is enabled in the associated WAF policy and properly assigned via security policies.

.NOTES
    Test ID: 26884
    Category: Azure Network Security
    Required APIs: Azure Management REST API (subscriptions, Front Door profiles, WAF policies, security policies)
#>

function Test-Assessment-26884 {

    [ZtTest(
        Category = 'Segurança de rede do Azure',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Azure_Front_Door_Premium'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 26884,
        Title = 'O conjunto de regras de proteção contra bots está habilitado e atribuído no WAF do Azure Front Door',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Avaliando a configuração de proteção contra bots do WAF do Azure Front Door'

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

    # Q1 & Q2: Query Azure Front Door Premium profiles using Azure Resource Graph
    Write-ZtProgress -Activity $activity -Status 'Consultando perfis do Azure Front Door via Resource Graph'

    $argQuery = @"
resources
| where type =~ 'microsoft.cdn/profiles'
| where properties.provisioningState =~ 'Succeeded'
| where sku.name in~ ('Premium_AzureFrontDoor', 'Standard_AzureFrontDoor')
| join kind=leftouter (
    resourcecontainers
    | where type =~ 'microsoft.resources/subscriptions'
    | project subscriptionName=name, subscriptionId
) on subscriptionId
| project
    ProfileName=name,
    ProfileId=id,
    Location=location,
    SkuName=tostring(sku.name),
    ResourceGroup=resourceGroup,
    SubscriptionId=subscriptionId,
    SubscriptionName=subscriptionName
"@

    $allFrontDoorProfiles = @()
    try {
        $allFrontDoorProfiles = @(Invoke-ZtAzureResourceGraphRequest -Query $argQuery)
        Write-PSFMessage "ARG Query returned $($allFrontDoorProfiles.Count) Azure Front Door profile(s)" -Tag Test -Level VeryVerbose
    }
    catch {
        Write-PSFMessage "Azure Resource Graph query failed: $($_.Exception.Message)" -Tag Test -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotSupported
        return
    }

    # Check if any Azure Front Door profiles exist
    if ($allFrontDoorProfiles.Count -eq 0) {
        Write-PSFMessage 'No Azure Front Door profiles found.' -Tag Test -Level VeryVerbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable
        return
    }

    # Filter Premium profiles for evaluation (Standard profiles will be marked as skipped)
    $premiumProfiles = $allFrontDoorProfiles | Where-Object { $_.SkuName -eq 'Premium_AzureFrontDoor' }
    $standardProfiles = $allFrontDoorProfiles | Where-Object { $_.SkuName -eq 'Standard_AzureFrontDoor' }

    # If no Premium profiles exist, skip the test
    if ($premiumProfiles.Count -eq 0) {
        Write-PSFMessage 'No Azure Front Door Premium profiles found. Bot protection is only available in Premium SKU.' -Tag Test -Level VeryVerbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable
        return
    }

    # Q3: Query all WAF policies in all subscriptions
    Write-ZtProgress -Activity $activity -Status 'Consultando políticas de WAF'

    $wafPoliciesArgQuery = @"
resources
| where type =~ 'microsoft.network/frontdoorwebapplicationfirewallpolicies'
| project
    PolicyId=id,
    PolicyName=name,
    SkuName=tostring(sku.name),
    EnabledState=tostring(properties.policySettings.enabledState),
    ManagedRuleSets=properties.managedRules.managedRuleSets,
    SecurityPolicyLinks=properties.securityPolicyLinks,
    SubscriptionId=subscriptionId
"@

    $allWafPolicies = @()
    try {
        $allWafPolicies = @(Invoke-ZtAzureResourceGraphRequest -Query $wafPoliciesArgQuery)
        Write-PSFMessage "ARG Query returned $($allWafPolicies.Count) WAF policy(ies)" -Tag Test -Level VeryVerbose
    }
    catch {
        Write-PSFMessage "WAF policies query failed: $($_.Exception.Message)" -Tag Test -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotSupported
        return
    }

    # Build a hashtable for quick WAF policy lookup by ID
    $wafPolicyLookup = @{}
    foreach ($wafPolicy in $allWafPolicies) {
        $wafPolicyLookup[$wafPolicy.PolicyId.ToLower()] = $wafPolicy
    }

    # Evaluate each Premium Front Door profile
    Write-ZtProgress -Activity $activity -Status 'Avaliando configuração de proteção contra bots'

    $evaluationResults = @()

    foreach ($fdProfile in $premiumProfiles) {
        $profileId = $fdProfile.ProfileId
        $profileName = $fdProfile.ProfileName

        # Q4: Query security policies for this Front Door profile
        $securityPoliciesPath = "$profileId/securityPolicies?api-version=2024-02-01"

        $securityPolicies = @()
        try {
            $securityPolicies = @(Invoke-ZtAzureRequest -Path $securityPoliciesPath)
        }
        catch {
            Write-PSFMessage "Error querying security policies for $profileName : $_" -Level Warning
        }

        # Evaluate security policies and associated WAF policies
        $hasValidBotProtection = $false
        $associatedWafPolicyName = 'None'
        $associatedWafPolicyId = $null
        $botManagerEnabled = 'No'
        $ruleSetVersion = 'N/A'
        $ruleSetAction = 'N/A'
        $domainsProtected = 0
        $securityPolicyConfigured = 'No'
        $wafEnabled = 'N/A'

        if ($securityPolicies.Count -gt 0) {
            $securityPolicyConfigured = 'Yes'

            foreach ($secPolicy in $securityPolicies) {
                # Reset domain count for each security policy to avoid accumulation
                $currentPolicyDomainCount = 0
                $wafPolicyRef = $secPolicy.properties.parameters.wafPolicy.id

                if ($wafPolicyRef) {
                    $associatedWafPolicyId = $wafPolicyRef.ToLower()

                    # Count domains protected by this security policy
                    $associations = $secPolicy.properties.parameters.associations
                    if ($associations) {
                        foreach ($assoc in $associations) {
                            if ($assoc.domains) {
                                $currentPolicyDomainCount += $assoc.domains.Count
                            }
                        }
                    }

                    # Look up the WAF policy
                    if ($wafPolicyLookup.ContainsKey($associatedWafPolicyId)) {
                        $wafPolicy = $wafPolicyLookup[$associatedWafPolicyId]
                        $associatedWafPolicyName = $wafPolicy.PolicyName
                        $wafEnabled = $wafPolicy.EnabledState
                        $wafIsPremium = $wafPolicy.SkuName -eq 'Premium_AzureFrontDoor'

                        # Check for Bot Manager rule set
                        $managedRuleSets = $wafPolicy.ManagedRuleSets
                        if ($managedRuleSets) {
                            foreach ($ruleSet in $managedRuleSets) {
                                if ($ruleSet.ruleSetType -eq 'Microsoft_BotManagerRuleSet') {
                                    $botManagerEnabled = 'Yes'
                                    $ruleSetVersion = $ruleSet.ruleSetVersion
                                    if ($ruleSet.ruleSetAction) {
                                        $ruleSetAction = $ruleSet.ruleSetAction
                                    }
                                    else {
                                        $ruleSetAction = 'Per-rule defaults'
                                    }

                                    # Check if WAF policy is enabled and Bot Manager is present
                                    if ($wafIsPremium -and $wafEnabled -eq 'Enabled') {
                                        $hasValidBotProtection = $true
                                        # Only count domains from security policy with valid bot protection
                                        $domainsProtected = $currentPolicyDomainCount
                                    }
                                    break
                                }
                            }
                        }
                    }
                }

                # Stop iterating if valid bot protection is found to preserve the correct WAF policy details
                if ($hasValidBotProtection) {
                    break
                }
            }
        }

        $status = if ($hasValidBotProtection) { 'Pass' } else { 'Fail' }

        $evaluationResults += [PSCustomObject]@{
            SubscriptionId           = $fdProfile.SubscriptionId
            SubscriptionName         = $fdProfile.SubscriptionName
            ProfileName              = $profileName
            ProfileId                = $profileId
            SkuName                  = $fdProfile.SkuName
            WAFPolicyName            = $associatedWafPolicyName
            WAFEnabled               = $wafEnabled
            SecurityPolicyConfigured = $securityPolicyConfigured
            BotManagerEnabled        = $botManagerEnabled
            RuleSetVersion           = $ruleSetVersion
            RuleSetAction            = $ruleSetAction
            DomainsProtected         = $domainsProtected
            Status                   = $status
        }
    }

    # Add Standard SKU profiles as skipped
    $skippedResults = @()
    foreach ($fdProfile in $standardProfiles) {
        $skippedResults += [PSCustomObject]@{
            SubscriptionId           = $fdProfile.SubscriptionId
            SubscriptionName         = $fdProfile.SubscriptionName
            ProfileName              = $fdProfile.ProfileName
            ProfileId                = $fdProfile.ProfileId
            SkuName                  = $fdProfile.SkuName
            WAFPolicyName            = 'N/A'
            WAFEnabled               = 'N/A'
            SecurityPolicyConfigured = 'N/A'
            BotManagerEnabled        = 'N/A'
            RuleSetVersion           = 'N/A'
            RuleSetAction            = 'N/A'
            DomainsProtected         = 0
            Status                   = 'Skipped'
        }
    }

    #endregion Data Collection

    #region Assessment Logic

    $passedItems = $evaluationResults | Where-Object { $_.Status -eq 'Pass' }
    $failedItems = $evaluationResults | Where-Object { $_.Status -eq 'Fail' }

    $passed = ($failedItems.Count -eq 0) -and ($passedItems.Count -gt 0)

    if ($passed) {
        $testResultMarkdown = "✅ O conjunto de regras de proteção contra bots está habilitado e atribuído ao WAF do Azure Front Door, fornecendo proteção contra tráfego de bots maliciosos.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ O conjunto de regras de proteção contra bots não está habilitado ou não está atribuído ao WAF do Azure Front Door, deixando as aplicações web vulneráveis a ataques automatizados e bots maliciosos.`n`n%TestResult%"
    }

    #endregion Assessment Logic

    #region Report Generation

    # Portal link variables
    $portalFrontDoorBrowseLink = 'https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.Cdn%2Fprofiles'
    $portalSubscriptionBaseLink = 'https://portal.azure.com/#resource/subscriptions'
    $portalResourceBaseLink = 'https://portal.azure.com/#resource'

    $mdInfo = "`n## [Status de proteção contra bots do WAF do Azure Front Door]($portalFrontDoorBrowseLink)`n`n"

    # Premium profiles table
    if ($evaluationResults.Count -gt 0) {
        $tableRows = ""
        $formatTemplate = @'
| Assinatura | Nome do perfil | SKU | Política de WAF | Proteção contra bots habilitada | Versão do conjunto de regras | Ação do conjunto de regras | Domínios protegidos | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
{0}

'@

        foreach ($result in $evaluationResults) {
            $subscriptionLink = "[$(Get-SafeMarkdown $result.SubscriptionName)]($portalSubscriptionBaseLink/$($result.SubscriptionId)/overview)"
            $profileLink = "[$(Get-SafeMarkdown $result.ProfileName)]($portalResourceBaseLink$($result.ProfileId)/securityPolicies)"
            $statusText = if ($result.Status -eq 'Pass') { '✅ Aprovado' } else { '❌ Reprovado' }

            $tableRows += "| $subscriptionLink | $profileLink | $($result.SkuName) | $(Get-SafeMarkdown $result.WAFPolicyName) | $($result.BotManagerEnabled) | $($result.RuleSetVersion) | $($result.RuleSetAction) | $($result.DomainsProtected) | $statusText |`n"
        }

        $mdInfo += $formatTemplate -f $tableRows
    }

    # Standard SKU profiles table (if any)
    if ($skippedResults.Count -gt 0) {
        $mdInfo += "`n### Perfis com SKU Standard (Ignorados — proteção contra bots não disponível)`n`n"

        $skippedTableRows = ""
        $skippedFormatTemplate = @'
| Assinatura | Nome do perfil | SKU | Status |
| :--- | :--- | :--- | :--- |
{0}

'@

        foreach ($result in $skippedResults) {
            $subscriptionLink = "[$(Get-SafeMarkdown $result.SubscriptionName)]($portalSubscriptionBaseLink/$($result.SubscriptionId)/overview)"
            $profileLink = "[$(Get-SafeMarkdown $result.ProfileName)]($portalResourceBaseLink$($result.ProfileId)/overview)"

            $skippedTableRows += "| $subscriptionLink | $profileLink | $($result.SkuName) | Ignorado — SKU Standard |`n"
        }

        $mdInfo += $skippedFormatTemplate -f $skippedTableRows
    }

    # Summary
    $mdInfo += "**Resumo:**`n`n"
    $mdInfo += "- Total de perfis Premium do Azure Front Door avaliados: $($evaluationResults.Count)`n"
    $mdInfo += "- Perfis com proteção contra bots habilitada: $($passedItems.Count)`n"
    $mdInfo += "- Perfis sem proteção contra bots: $($failedItems.Count)`n"
    $mdInfo += "- Perfis com SKU Standard (ignorados): $($skippedResults.Count)`n"

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo

    #endregion Report Generation

    $params = @{
        TestId = '26884'
        Title  = 'O conjunto de regras de proteção contra bots está habilitado e atribuído no WAF do Azure Front Door'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
