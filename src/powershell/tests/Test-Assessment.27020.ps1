<#
.SYNOPSIS
    Valida que o desafio CAPTCHA está habilitado no WAF do Azure Front Door.

.DESCRIPTION
    Este teste avalia políticas de WAF do Azure Front Door para garantir que pelo menos uma regra personalizada
    with CAPTCHA challenge action is configured and enabled. CAPTCHA challenge provides
    interactive human verification against sophisticated automated bots at the global edge.

.NOTES
    Test ID: 27020
    Category: Azure Network Security
    Required APIs: Azure Resource Graph (microsoft.network/frontdoorwebapplicationfirewallpolicies)
#>

function Test-Assessment-27020 {

    [ZtTest(
        Category = 'Segurança de rede do Azure',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Azure WAF'),
        Pillar = 'Rede',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 27020,
        Title = 'O desafio CAPTCHA está habilitado no WAF do Azure Front Door',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Avaliando configuração de desafio CAPTCHA do WAF do Azure Front Door'

    # Check Azure connection
    Write-ZtProgress -Activity $activity -Status 'Verificando conexão do Azure'

    $azContext = Get-AzContext -ErrorAction SilentlyContinue
    if (-not $azContext) {
        Write-PSFMessage 'Não conectado ao Azure.' -Tag Test -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedAzure
        return
    }

    # Check supported environment (Global cloud only)
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
    CaptchaExpirationInMins = toint(properties.policySettings.captchaExpirationInMinutes),
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

    if ($policies.Count -eq 0) {
        Write-PSFMessage 'Nenhuma política de WAF do Azure Front Door anexada ao Azure Front Door encontrada.' -Tag Test -Level Verbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable -Result 'Nenhuma política de WAF do Azure Front Door anexada ao Azure Front Door encontrada.'
        return
    }

    # Fail if any policy is disabled, not in Prevention mode, or has no enabled CAPTCHA custom rule
    $failingPolicies = $policies | Where-Object {
        $_.EnabledState -ne 'Enabled' -or
        $_.WafMode -ne 'Prevention' -or
        @($_.CustomRules | Where-Object { $_.action -eq 'Captcha' -and $_.enabledState -eq 'Enabled' }).Count -eq 0
    }

    $passed = $failingPolicies.Count -eq 0

    if ($passed) {
        $testResultMarkdown = "✅ Todas as políticas de WAF do Azure Front Door anexadas ao Azure Front Door estão habilitadas, executando no modo Prevenção e têm pelo menos uma regra de Desafio CAPTCHA configurada e habilitada.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ Uma ou mais políticas de WAF do Azure Front Door anexadas ao Azure Front Door estão desabilitadas, não estão no modo Prevenção ou não têm regras de desafio CAPTCHA configuradas e habilitadas, deixando aplicativos sem verificação interativa de humanos contra bots automatizados sofisticados na borda global.`n`n%TestResult%"
    }

    #endregion Assessment Logic

    #region Report Generation

    $portalWafBrowseLink = 'https://portal.azure.com/#browse/Microsoft.Network%2FfrontdoorWebApplicationFirewallPolicies'
    $portalResourceBaseLink = 'https://portal.azure.com/#resource'
    $portalSubscriptionBaseLink = 'https://portal.azure.com/#resource/subscriptions'

    $mdInfo = "`n## [Políticas de WAF do Azure Front Door]($portalWafBrowseLink)`n`n"

    $tableRows = ''
    $formatTemplate = @'
| Nome da política | Nome da assinatura | Estado habilitado | Modo WAF | Contagem de regras de desafio CAPTCHA | Estado da regra | Expiração de CAPTCHA (min) | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
{0}

'@

    foreach ($policy in ($policies | Sort-Object SubscriptionName, PolicyName)) {
        $policyLink = "[$(Get-SafeMarkdown $policy.PolicyName)]($portalResourceBaseLink$($policy.PolicyId))"
        $subscriptionLink = "[$(Get-SafeMarkdown $policy.SubscriptionName)]($portalSubscriptionBaseLink/$($policy.SubscriptionId)/overview)"

        $allCaptchaRules = @($policy.CustomRules | Where-Object { $_.action -eq 'Captcha' })
        $enabledCaptchaRules = @($allCaptchaRules | Where-Object { $_.enabledState -eq 'Enabled' })

        $captchaRuleCountDisplay = if ($enabledCaptchaRules.Count -gt 0) {
            "✅ $($enabledCaptchaRules.Count)"
        }
        elseif ($allCaptchaRules.Count -gt 0) {
            "⚠️ $($allCaptchaRules.Count) (disabled)"
        }
        else {
            '❌ 0'
        }
        $ruleStateDisplay = if ($allCaptchaRules.Count -eq 0) {
            'N/A'
        }
        elseif ($enabledCaptchaRules.Count -ge 1) {
            '✅ Enabled'
        }
        else {
            '❌ Disabled'
        }

        $captchaExpiration = if ($policy.CaptchaExpirationInMins) { $policy.CaptchaExpirationInMins } else { 'N/A' }
        $enabledStateDisplay = if ($policy.EnabledState -eq 'Enabled') { '✅ Enabled' } else { '❌ Disabled' }
        $wafModeDisplay = if ($policy.WafMode -eq 'Prevention') { '✅ Prevention' } else { '❌ Detection' }
        $statusText = if ($policy.EnabledState -eq 'Enabled' -and $policy.WafMode -eq 'Prevention' -and $enabledCaptchaRules.Count -ge 1) { '✅ Pass' } else { '❌ Fail' }

        $tableRows += "| $policyLink | $subscriptionLink | $enabledStateDisplay | $wafModeDisplay | $captchaRuleCountDisplay | $ruleStateDisplay | $captchaExpiration | $statusText |`n"
    }

    $mdInfo += $formatTemplate -f $tableRows

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo

    #endregion Report Generation

    $params = @{
        TestId = '27020'
        Title  = 'Desafio CAPTCHA está habilitado no WAF do Azure Front Door'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
