<#
.SYNOPSIS
    Valida que a Inspeção de Corpo da Solicitação está habilitada no WAF do Application Gateway.

.DESCRIPTION
    Este teste valida que as políticas de Firewall de Aplicativo da Web do Azure Application Gateway
    têm inspeção de corpo de solicitação habilitada para analisar corpos de solicitação HTTP POST, PUT e PATCH
    para padrões maliciosos.

.NOTES
    Test ID: 26879
    Category: Azure Network Security
    Pillar: Network
    Required API: Azure Resource Graph - ApplicationGatewayWebApplicationFirewallPolicies
#>

function Test-Assessment-26879 {
    [ZtTest(
        Category = 'Segurança de rede do Azure',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Azure WAF'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 26879,
        Title = 'A inspeção do corpo da solicitação está habilitada no WAF do Application Gateway',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando configuração de inspeção de corpo de solicitação do WAF do Application Gateway'

    # Check if connected to Azure
    Write-ZtProgress -Activity $activity -Status 'Verificando conexão do Azure'

    $azContext = Get-AzContext -ErrorAction SilentlyContinue
    if (-not $azContext) {
        Write-PSFMessage 'Não conectado ao Azure.' -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedAzure
        return
    }

    Write-ZtProgress -Activity $activity -Status 'Consultando o Azure Resource Graph'

    # Inner join with Application Gateways filters out orphaned WAF policies (not attached to any gateway).
    # summarize collapses to one row per policy, collecting gateway names into a list.
    # leftouter join adds subscription name on the already-reduced result set.
    $argQuery = @"
resources
| where type =~ 'microsoft.network/ApplicationGatewayWebApplicationFirewallPolicies'
| extend wafPolicyId = tolower(id)
| join kind=inner (
    resources
    | where type =~ 'microsoft.network/applicationgateways'
    | where isnotempty(properties.firewallPolicy.id)
    | extend wafPolicyId = tolower(tostring(properties.firewallPolicy.id))
    | project wafPolicyId, GatewayName=name
) on wafPolicyId
| summarize ApplicationGateways=make_list(GatewayName), PolicyName=any(name), subscriptionId=any(subscriptionId), PolicyId=any(id), RequestBodyCheck=any(tobool(properties.policySettings.requestBodyCheck)), EnabledState=any(tostring(properties.policySettings.state)), Mode=any(tostring(properties.policySettings.mode)) by wafPolicyId
| join kind=leftouter (
    resourcecontainers
    | where type =~ 'microsoft.resources/subscriptions'
    | project subscriptionId, SubscriptionName=name
) on subscriptionId
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
    # Skip test if no policies found
    if ($policies.Count -eq 0) {
        Write-PSFMessage 'Nenhuma política de WAF do Application Gateway encontrada.' -Tag Test -Level Verbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable -Result 'No Application Gateway WAF policies attached to Application Gateways found across subscriptions.'
        return
    }

    # Check if all policies meet all three conditions: Enabled state, Prevention mode, and Request Body Check
    $passed = ($policies | Where-Object {
        $_.EnabledState -ne 'Enabled' -or
        $_.Mode -ne 'Prevention' -or
        $_.RequestBodyCheck -ne $true
    }).Count -eq 0

    if ($passed) {
        $testResultMarkdown = "✅ Todas as políticas de WAF do Application Gateway anexadas aos Application Gateways estão habilitadas, executando no modo Prevenção e têm inspeção de corpo de solicitação habilitada.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ Uma ou mais políticas de WAF do Application Gateway anexadas aos Application Gateways estão desabilitadas, executando no modo Detecção ou têm inspeção de corpo de solicitação desabilitada, deixando aplicativos vulneráveis a ataques baseados em corpo que contornam a avaliação de regras do WAF.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    # Table title
    $reportTitle = 'Políticas de WAF do Application Gateway'
    $portalLink = "https://portal.azure.com/#view/Microsoft_Azure_HybridNetworking/FirewallManagerMenuBlade/~/wafMenuItem"

    # Prepare table rows
    $tableRows = ''
    foreach ($item in $policies | Sort-Object SubscriptionName, PolicyName) {
        $policyLink = "https://portal.azure.com/#resource$($item.PolicyId)"
        $subLink = "https://portal.azure.com/#resource/subscriptions/$($item.SubscriptionId)"
        $policyMd = "[$(Get-SafeMarkdown $item.PolicyName)]($policyLink)"
        $subMd = "[$(Get-SafeMarkdown $item.SubscriptionName)]($subLink)"

        # Extract Application Gateway names from the ARG make_list array and sanitize for Markdown
        $appGwMd = @($item.ApplicationGateways | ForEach-Object { Get-SafeMarkdown $_ }) -join ', '

        # Calculate status indicators
        $requestBodyCheckDisplay = if ($item.RequestBodyCheck -eq $true) { '✅ Enabled' } else { '❌ Disabled' }
        $enabledStateDisplay = if ($item.EnabledState -eq 'Enabled') { '✅ Enabled' } else { '❌ Disabled' }
        $modeDisplay = if ($item.Mode -eq 'Prevention') { '✅ Prevention' } else { "⚠️ $($item.Mode)" }
        $status = if ($item.EnabledState -eq 'Enabled' -and $item.Mode -eq 'Prevention' -and $item.RequestBodyCheck -eq $true) { '✅ Pass' } else { '❌ Fail' }

        $tableRows += "| $policyMd | $subMd | $appGwMd | $enabledStateDisplay | $modeDisplay | $requestBodyCheckDisplay | $status |`n"
    }

    $formatTemplate = @'


## [{0}]({1})

| Nome da política | Nome da assinatura | Application Gateways anexados | Estado habilitado | Modo WAF | Inspeção de corpo de solicitação | Status |
| :---------- | :---------------- | :---------------------------- | :-----------: | :------: | :----------------: | :----: |
{2}

'@

    $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $tableRows

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '26879'
        Title  = 'Inspeção de Corpo da Solicitação está habilitada no WAF do Application Gateway'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
