<#
.SYNOPSIS
    Valida que as regras de Limitação de Taxa estão habilitadas nas regras personalizadas do WAF do Application Gateway.

.DESCRIPTION
    Este teste verifica se todas as políticas de WAF do Azure Application Gateway anexadas aos Application Gateways
    have at least one custom rule configured with the RateLimitRule rule type and state set to Enabled.
    Rate limiting protects applications from brute force attacks, credential stuffing, API abuse,
    and volumetric denial of service attacks by throttling clients that exceed defined request thresholds.

.NOTES
    Test ID: 27016
    Category: Azure Network Security
    Required API: Azure Resource Graph - ApplicationGatewayWebApplicationFirewallPolicies
#>

function Test-Assessment-27016 {
    [ZtTest(
        Category = 'Segurança de rede do Azure',
        ImplementationCost = 'Médio',
        MinimumLicense = ('Azure WAF'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 27016,
        Title = 'A limitação de taxa está habilitada no WAF do Application Gateway',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando configuração de limitação de taxa do WAF do Application Gateway'

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

    # Fail if any policy is disabled, not in Prevention mode, or has no enabled RateLimitRule custom rule
    $failingPolicies = $policies | Where-Object {
        $_.EnabledState -ne 'Enabled' -or
        $_.Mode -ne 'Prevention' -or
        @($_.CustomRules | Where-Object { $_.ruleType -eq 'RateLimitRule' -and $_.state -eq 'Enabled' }).Count -eq 0
    }

    $passed = $failingPolicies.Count -eq 0

    if ($passed) {
        $testResultMarkdown = "✅ Todas as políticas de WAF do Application Gateway anexadas aos Application Gateways estão habilitadas, executando no modo Prevenção e têm pelo menos uma regra de limitação de taxa configurada e habilitada.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ Uma ou mais políticas de WAF do Application Gateway anexadas aos Application Gateways estão desabilitadas, executando no modo Detecção, não têm regras de limitação de taxa configuradas ou têm regras de limitação de taxa configuradas mas todas definidas como Desabilitado, deixando aplicativos vulneráveis a ataques de força bruta e volumétricos.`n`n%TestResult%"
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

        $allRateLimitRules = @($policy.CustomRules | Where-Object { $_.ruleType -eq 'RateLimitRule' })
        $enabledRateLimitRules = @($allRateLimitRules | Where-Object { $_.state -eq 'Enabled' })
        $rateLimitRuleCountDisplay = if ($allRateLimitRules.Count -gt 0) { "✅ $($allRateLimitRules.Count)" } else { '❌ 0' }
        $ruleStateDisplay = if ($allRateLimitRules.Count -eq 0) {
            'N/A'
        }
        elseif ($enabledRateLimitRules.Count -ge 1) {
            '✅ Enabled'
        }
        else {
            '❌ Disabled'
        }
        $enabledStateDisplay = if ($policy.EnabledState -eq 'Enabled') { '✅ Enabled' } else { '❌ Disabled' }
        $modeDisplay = if ($policy.Mode -eq 'Prevention') { '✅ Prevention' } else { '❌ Detection' }
        $statusDisplay = if ($policy.EnabledState -eq 'Enabled' -and $policy.Mode -eq 'Prevention' -and $enabledRateLimitRules.Count -ge 1) { '✅' } else { '❌' }

        $tableRows += "| $policyMd | $subMd | $enabledStateDisplay | $modeDisplay | $rateLimitRuleCountDisplay | $ruleStateDisplay | $statusDisplay |`n"
    }

    $formatTemplate = @'

## [{0}]({1})

| Nome da política | Nome da assinatura | Estado da política | Modo | Contagem de regras de limitação de taxa | Estado da regra | Status |
| :---------- | :---------------- | :----------- | :--- | :--------------------- | :--------- | :----- |
{2}

'@

    $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $tableRows
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '27016'
        Title  = 'Limitação de Taxa está habilitada no WAF do Application Gateway'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
