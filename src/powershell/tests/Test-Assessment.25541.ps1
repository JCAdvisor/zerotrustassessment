<#
.SYNOPSIS
    Valida que todas as políticas WAF do Application Gateway estão configuradas em modo Prevenção.

.DESCRIPTION
    Este teste verifica se todas as políticas de Firewall de Aplicativo Web (WAF) do Azure Application Gateway
    no inquilino estão sendo executadas em modo Prevenção para bloquear ativamente o tráfego malicioso.
    As políticas WAF em modo Detecção apenas registram ameaças sem bloqueá-las, deixando os aplicativos
    vulneráveis a exploração.

.NOTES
    Test ID: 25541
    Category: Azure Network Security
    Required API: Azure Management API - ApplicationGatewayWebApplicationFirewallPolicies
#>

function Test-Assessment-25541 {
    [ZtTest(
        Category = 'Segurança de rede do Azure',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Azure WAF', 'Azure Application Gateway Standard SKU'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 25541,
        Title = 'O WAF do Application Gateway está Habilitado em Modo Prevenção',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando configuração de políticas WAF do Application Gateway'

    # Check if connected to Azure
    Write-ZtProgress -Activity $activity -Status 'Verificando conexão com Azure'

    $azContext = Get-AzContext -ErrorAction SilentlyContinue
    if (-not $azContext) {
        Write-PSFMessage 'Não conectado ao Azure.' -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedAzure
        return
    }

    Write-ZtProgress -Activity $activity -Status 'Consultando o Azure Resource Graph'

        # Consulta all Application Gateway WAF policies using Azure Resource Graph
    $argQuery = @"
    resources
    | where type =~ 'microsoft.network/ApplicationGatewayWebApplicationFirewallPolicies'
    | join kind=leftouter (resourcecontainers | where type =~ 'microsoft.resources/subscriptions' | project subscriptionName=name, subscriptionId) on subscriptionId
    | project PolicyName=name, SubscriptionName=subscriptionName, SubscriptionId=subscriptionId, EnabledState=tostring(properties.policySettings.state), Mode=tostring(properties.policySettings.mode), PolicyId=id
"@

    $policies = @()
    try {
        $policies = @(Invoke-ZtAzureResourceGraphRequest -Query $argQuery)
        Write-PSFMessage "Consulta ARG retornou $($policies.Count) registros" -Tag Test -Level VeryVerbose
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
        Write-PSFMessage 'Nenhuma política WAF do Application Gateway encontrada.' -Tag Test -Level Verbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable
        return
    }

    # Check if all policies are enabled and in Prevention mode
    $passed = ($policies | Where-Object { $_.EnabledState -ne 'Enabled' -or $_.Mode -ne 'Prevention' }).Count -eq 0

    if ($passed) {
        $testResultMarkdown = "✅ Todas as políticas WAF do Application Gateway estão habilitadas em modo **Prevenção**.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ Uma ou mais políticas WAF do Application Gateway estão em estado **Desabilitado** ou em modo **Detecção**.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    # Table title
    $reportTitle = 'Políticas WAF do Application Gateway'
    $portalLink = 'https://portal.azure.com/#view/Microsoft_Azure_HybridNetworking/FirewallManagerMenuBlade/~/wafMenuItem'

    # Prepare table rows
    $tableRows = ''
    foreach ($item in $policies | Sort-Object SubscriptionName, PolicyName) {
        $policyLink = "https://portal.azure.com/#resource$($item.PolicyId)"
        $subLink = "https://portal.azure.com/#resource/subscriptions/$($item.SubscriptionId)"
        $policyMd = "[$(Get-SafeMarkdown $item.PolicyName)]($policyLink)"
        $subMd = "[$(Get-SafeMarkdown $item.SubscriptionName)]($subLink)"

        # Calculate status indicators
        $policyStatus = if ($item.EnabledState -eq 'Enabled' -and $item.Mode -eq 'Prevention') { '✅' } else { '❌' }
        $modeDisplay = if ($item.Mode -eq 'Prevention') { '✅ Prevenção' } else { '❌ Detecção' }
        $enabledStateDisplay = if ($item.EnabledState -eq 'Enabled') { '✅ Habilitado' } else { '❌ Desabilitado' }

        $tableRows += "| $policyMd | $subMd | $enabledStateDisplay | $modeDisplay | $policyStatus |`n"
    }

    $formatTemplate = @'


## [{0}]({1})

| Nome da Política | Nome da Assinatura | Estado da Política | Modo | Status |
| :---------- | :---------------- | :----------: | :--: | :----: |
{2}

'@

    $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $tableRows

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25541'
        Title  = 'O WAF do Application Gateway está Habilitado em Modo Prevenção'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
