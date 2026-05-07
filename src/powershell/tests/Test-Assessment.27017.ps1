<#
.SYNOPSIS
    Valida que o Desafio de JavaScript está habilitado nas regras personalizadas do WAF do Application Gateway.

.DESCRIPTION
    Este teste verifica se todas as políticas de WAF do Azure Application Gateway anexadas aos Application Gateways
    have at least one custom rule configured with the JSChallenge action and state set to Enabled.
    JavaScript challenge verifies that clients can execute JavaScript, blocking automated bots and
    headless browsers that cannot complete the challenge.

.NOTES
    Test ID: 27017
    Category: Azure Network Security
    Required API: Azure Resource Graph - ApplicationGatewayWebApplicationFirewallPolicies
#>

function Test-Assessment-27017 {
    [ZtTest(
        Category = 'Segurança de rede do Azure',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Azure WAF'),
        Pillar = 'Rede',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 27017,
        Title = 'O desafio JavaScript está habilitado no WAF do Application Gateway',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando configuração de políticas do WAF do Application Gateway'

    # Check if connected to Azure
    Write-ZtProgress -Activity $activity -Status 'Verificando conexão do Azure'

    $azContext = Get-AzContext -ErrorAction SilentlyContinue
    if (-not $azContext) {
        Write-PSFMessage 'Não conectado ao Azure.' -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedAzure
        return
    }

    Write-ZtProgress -Activity $activity -Status 'Consultando o Azure Resource Graph'

        # Consulta all Application Gateway WAF policies attached to Application Gateways using Azure Resource Graph
    $argQuery = @"
resources
| where type =~ 'microsoft.network/applicationgatewaywebapplicationfirewallpolicies'
| where coalesce(array_length(properties.applicationGateways), 0) >= 1
| join kind=leftouter (
    resourcecontainers
    | where type =~ 'microsoft.resources/subscriptions'
    | project subscriptionName=name, subscriptionId)
    on subscriptionId
| project
    PolicyName = name,
    PolicyId = id,
    SubscriptionName = subscriptionName,
    SubscriptionId = subscriptionId,
    EnabledState = tostring(properties.policySettings.state),
    Mode = tostring(properties.policySettings.mode),
    JsChallengeCookieExpirationInMins = toint(properties.policySettings.jsChallengeCookieExpirationInMins),
    CustomRules = properties.customRules
"@

    $policies = @()
    try {
        $policies = @(Invoke-ZtAzureResourceGraphRequest -Query $argQuery)
        Write-PSFMessage "ARG Query returned $($policies.Count) records" -Tag Test -Level VeryVerbose
    }
    catch {
        Write-PSFMessage "Falha na consulta do Azure Resource Graph: $($_.Exception.Message)" -Tag Test -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotSupported
        return
    }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $false

    # Skip test if no policies found
    if ($policies.Count -eq 0) {
        Write-PSFMessage 'Nenhuma política de WAF do Application Gateway encontrada anexada aos Application Gateways.' -Tag Test -Level Verbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable -Result 'Nenhuma política de WAF do Application Gateway encontrada anexada aos Application Gateways.'
        return
    }

    # Fail if any policy is disabled, not in Prevention mode, or has no enabled JSChallenge custom rule
    $failingPolicies = $policies | Where-Object {
        $_.EnabledState -ne 'Enabled' -or
        $_.Mode -ne 'Prevention' -or
        @($_.CustomRules | Where-Object { $_.action -eq 'JSChallenge' -and $_.state -eq 'Enabled' }).Count -eq 0
    }

    $passed = $failingPolicies.Count -eq 0

    if ($passed) {
        $testResultMarkdown = "✅ Todas as políticas de WAF do Application Gateway anexadas aos Application Gateways estão habilitadas, executando no modo Prevenção e têm pelo menos uma regra de desafio de JavaScript configurada e habilitada.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ Uma ou mais políticas de WAF do Application Gateway anexadas aos Application Gateways estão desabilitadas, executando no modo Detecção, não têm regras de desafio de JavaScript configuradas ou têm regras de desafio de JavaScript configuradas mas todas definidas como Desabilitado, deixando aplicativos sem verificação de navegador contra bots automatizados.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    $reportTitle = 'Políticas de WAF do Application Gateway'
    $portalLink = 'https://portal.azure.com/#browse/Microsoft.Network%2FapplicationGatewayWebApplicationFirewallPolicies'

    $tableRows = ''
    foreach ($policy in $policies | Sort-Object SubscriptionName, PolicyName) {
        $policyLink = "https://portal.azure.com/#resource$($policy.PolicyId)"
        $subLink = "https://portal.azure.com/#resource/subscriptions/$($policy.SubscriptionId)"
        $policyMd = "[$(Get-SafeMarkdown $policy.PolicyName)]($policyLink)"
        $subMd = "[$(Get-SafeMarkdown $policy.SubscriptionName)]($subLink)"

        $allJsRules = @($policy.CustomRules | Where-Object { $_.action -eq 'JSChallenge' })
        $enabledJsRules = @($allJsRules | Where-Object { $_.state -eq 'Enabled' })
        $jsRuleCountDisplay = if ($allJsRules.Count -gt 0) { "✅ $($allJsRules.Count)" } else { '❌ 0' }
        $ruleStateDisplay = if ($allJsRules.Count -eq 0) {
            'N/A'
        }
        elseif ($enabledJsRules.Count -ge 1) {
            '✅ Enabled'
        }
        else {
            '❌ Disabled'
        }
        $cookieExpiry = if ($policy.JsChallengeCookieExpirationInMins) { $policy.JsChallengeCookieExpirationInMins } else { 'N/A' }
        $enabledStateDisplay = if ($policy.EnabledState -eq 'Enabled') { '✅ Enabled' } else { '❌ Disabled' }
        $modeDisplay = if ($policy.Mode -eq 'Prevention') { '✅ Prevention' } else { '❌ Detection' }
        $statusDisplay = if ($policy.EnabledState -eq 'Enabled' -and $policy.Mode -eq 'Prevention' -and $enabledJsRules.Count -ge 1) { '✅' } else { '❌' }

        $tableRows += "| $policyMd | $subMd | $enabledStateDisplay | $modeDisplay | $jsRuleCountDisplay | $ruleStateDisplay | $cookieExpiry | $statusDisplay |`n"
    }

    $formatTemplate = @'

## [{0}]({1})

| Nome da política | Nome da assinatura | Estado da política | Modo | Contagem de regras de desafio JS | Estado da regra | Expiração do Desafio de JavaScript (min) | Status |
| :---------- | :---------------- | :----------- | :--- | :----------------------- | :--------- | :------------------------------------- | :----- |
{2}

'@

    $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $tableRows
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '27017'
        Title  = 'Desafio de JavaScript está habilitado no WAF do Application Gateway'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
