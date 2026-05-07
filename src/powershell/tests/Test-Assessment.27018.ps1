<#
.SYNOPSIS
    Valida que a limitação de taxa está habilitada nas políticas de WAF do Azure Front Door.

.DESCRIPTION
    Este teste avalia políticas de WAF do Azure Front Door em todas as assinaturas para verificar
    that at least one rate limiting custom rule (RateLimitRule) is configured and enabled.
    Only policies attached to an Azure Front Door are evaluated.

.NOTES
    Test ID: 27018
    Category: Azure Network Security
    Required APIs: Azure Management REST API (subscriptions, Front Door WAF policies)
#>

function Test-Assessment-27018 {

    [ZtTest(
        Category = 'Segurança de rede do Azure',
        ImplementationCost = 'Médio',
        MinimumLicense = 'Azure_WAF',
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 27018,
        Title = 'A limitação de taxa está habilitada no WAF do Azure Front Door',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando configuração de limitação de taxa do WAF do Azure Front Door'

    # Check if connected to Azure
    Write-ZtProgress -Activity $activity -Status 'Verificando conexão do Azure'

    $azContext = Get-AzContext -ErrorAction SilentlyContinue
    if (-not $azContext) {
        Write-PSFMessage 'Não conectado ao Azure.' -Tag Test -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedAzure
        return
    }

    # Check the supported environment
    Write-ZtProgress -Activity $activity -Status 'Verificando ambiente do Azure'

    if ($azContext.Environment.Name -ne 'AzureCloud') {
        Write-PSFMessage 'Este teste é aplicável apenas ao ambiente AzureCloud.' -Tag Test -Level VeryVerbose
        Add-ZtTestResultDetail -SkippedBecause NotSupported
        return
    }

        # Consulta all Front Door WAF policies attached to an Azure Front Door via Azure Resource Graph
    Write-ZtProgress -Activity $activity -Status 'Consultando políticas de WAF do Azure Front Door'

    $argQuery = @"
resources
| where type =~ 'microsoft.network/frontdoorwebapplicationfirewallpolicies'
| where array_length(properties.frontendEndpointLinks) > 0 or array_length(properties.securityPolicyLinks) > 0
| join kind=leftouter (
    resourcecontainers
    | where type =~ 'microsoft.resources/subscriptions'
    | project subscriptionId, subscriptionName=name
) on subscriptionId
| project
    PolicyName = name,
    PolicyId = id,
    SubscriptionName = subscriptionName,
    SubscriptionId = subscriptionId,
    EnabledState = tostring(properties.policySettings.enabledState),
    WafMode = tostring(properties.policySettings.mode),
    CustomRules = properties.customRules.rules
"@

    $policies = @()
    try {
        $policies = @(Invoke-ZtAzureResourceGraphRequest -Query $argQuery)
        Write-PSFMessage "ARG Query returned $($policies.Count) records" -Tag Test -Level VeryVerbose
    }
    catch {
        Write-PSFMessage "Falha ao consultar políticas de WAF do Azure Front Door via Resource Graph: $($_.Exception.Message)" -Tag Test -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotSupported
        return
    }

    #endregion Data Collection

    #region Assessment Logic

    # Skip test if no policies found
    if ($policies.Count -eq 0) {
        Write-PSFMessage 'Nenhuma política de WAF do Azure Front Door anexada ao Azure Front Door encontrada.' -Tag Test -Level Verbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable -Result 'Nenhuma política de WAF do Azure Front Door anexada ao Azure Front Door encontrada.'
        return
    }

    # Fail if any policy is disabled, not in Prevention mode, or has no enabled rate limiting custom rule
    $failingPolicies = $policies | Where-Object {
        $_.EnabledState -ne 'Enabled' -or
        $_.WafMode -ne 'Prevention' -or
        @($_.CustomRules | Where-Object { $_.ruleType -eq 'RateLimitRule' -and $_.enabledState -eq 'Enabled' }).Count -eq 0
    }

    $passed = $failingPolicies.Count -eq 0

    if ($passed) {
        $testResultMarkdown = "✅ Todas as políticas de WAF do Azure Front Door anexadas ao Azure Front Door estão habilitadas, executando no modo Prevenção e têm pelo menos uma regra de limitação de taxa configurada e habilitada.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ Uma ou mais políticas de WAF do Azure Front Door anexadas ao Azure Front Door estão desabilitadas, não estão no modo Prevenção ou não têm regras de limitação de taxa configuradas e habilitadas, deixando aplicativos vulneráveis a ataques de força bruta e volumétricos na borda global.`n`n%TestResult%"
    }

    #endregion Assessment Logic

    #region Report Generation

    $portalWafBrowseLink = 'https://portal.azure.com/#browse/Microsoft.Network%2FfrontdoorWebApplicationFirewallPolicies'
    $portalResourceBaseLink = 'https://portal.azure.com/#resource'
    $portalSubscriptionBaseLink = 'https://portal.azure.com/#resource/subscriptions'

    $mdInfo = "`n## [Políticas de WAF do Azure Front Door]($portalWafBrowseLink)`n`n"

    $tableRows = ''
    $formatTemplate = @'
| Nome da política | Nome da assinatura | Estado da regra | Estado habilitado | Modo WAF | Contagem de regras de limitação de taxa | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
{0}

'@

    foreach ($policy in ($policies | Sort-Object SubscriptionName, PolicyName)) {
        $policyLink = "[$(Get-SafeMarkdown $policy.PolicyName)]($portalResourceBaseLink$($policy.PolicyId))"
        $subscriptionLink = "[$(Get-SafeMarkdown $policy.SubscriptionName)]($portalSubscriptionBaseLink/$($policy.SubscriptionId)/overview)"

        $allRateRules = @($policy.CustomRules | Where-Object { $_.ruleType -eq 'RateLimitRule' })
        $enabledRateRules = @($allRateRules | Where-Object { $_.enabledState -eq 'Enabled' })

        $rateRuleCountDisplay = if ($enabledRateRules.Count -gt 0) {
            "✅ $($enabledRateRules.Count)"
        }
        elseif ($allRateRules.Count -gt 0) {
            "⚠️ $($allRateRules.Count) (disabled)"
        }
        else {
            '❌ 0'
        }
        $ruleStateDisplay = if ($allRateRules.Count -eq 0) {
            'N/A'
        }
        elseif ($enabledRateRules.Count -ge 1) {
            '✅ Enabled'
        }
        else {
            '❌ Disabled'
        }

        $enabledStateDisplay = if ($policy.EnabledState -eq 'Enabled') { '✅ Enabled' } else { '❌ Disabled' }
        $wafModeDisplay = if ($policy.WafMode -eq 'Prevention') { '✅ Prevention' } else { '❌ Detection' }
        $statusText = if ($policy.EnabledState -eq 'Enabled' -and $policy.WafMode -eq 'Prevention' -and $enabledRateRules.Count -ge 1) { '✅ Pass' } else { '❌ Fail' }

        $tableRows += "| $policyLink | $subscriptionLink | $ruleStateDisplay | $enabledStateDisplay | $wafModeDisplay | $rateRuleCountDisplay | $statusText |`n"
    }

    $mdInfo += $formatTemplate -f $tableRows


    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo

    #endregion Report Generation

    $params = @{
        TestId = '27018'
        Title  = 'Limitação de Taxa está habilitada no WAF do Azure Front Door'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
