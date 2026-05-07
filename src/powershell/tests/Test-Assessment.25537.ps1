
<#
 .SYNOPSIS
     Valida se a inteligência de ameaça está Ativada no Modo Negar no Azure Firewall.
 .DESCRIPTION
     Este teste valida que as Políticas de Firewall do Azure tão a Inteligência de Ameaça ativada no modo Negar.
     Verifica todas as políticas de firewall na assinatura e relata seu status de inteligência de ameaça.
     Category: Azure Network Security
     Required API: Azure Firewall Policies
 #>

function Test-Assessment-25537 {
    [ZtTest(
        Category = 'Segurança de rede do Azure',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Azure_Firewall_Standard', 'Azure_Firewall_Premium'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 25537,
        Title = 'A inteligência de ameaça está Ativada no Modo Negar no Azure Firewall',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    #region Data Collection
    $activity = 'Inteligência de Ameaça do Azure Firewall'
    Write-ZtProgress  -Activity $activity -Status 'Enumerando Políticas de Firewall'

    $context = Get-AzContext
    if (($context).Environment.name -ne 'AzureCloud') {
        Write-PSFMessage "Este teste é aplicável apenas para o ambiente Global." -Tag Test -Level VeryVerbose
        Add-ZtTestResultDetail -SkippedBecause NotSupported
        return
    }

    try {
        $accessToken = Get-AzAccessToken -AsSecureString -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }
    catch {
        Write-PSFMessage $_.Exception.Message -Tag Test -Level Error
    }

    if (-not $accessToken) {
        Write-PSFMessage "Token de autenticação do Azure não encontrado." -Tag Test -Level Warning
        Add-ZtTestResultDetail -SkippedBecause 'NotConnectedAzure'
        return
    }

    $argQuery = @"
Resources
| where type =~ 'microsoft.network/firewallpolicies'
| where tostring(properties.sku.tier) in ('Standard', 'Premium')
| join kind=leftouter (ResourceContainers | where type =~ 'microsoft.resources/subscriptions' | project subscriptionName=name, subscriptionId) on subscriptionId
| project PolicyName=name, SubscriptionName=subscriptionName, SubscriptionId=subscriptionId, ThreatIntelMode=tostring(properties.threatIntelMode), PolicyID=id
"@

    $results = @()
    try {
        Write-ZtProgress -Activity $activity -Status "Consultando o Gráfico de Recursos do Azure"
        $results = @(Invoke-ZtAzureResourceGraphRequest -Query $argQuery)

        Write-PSFMessage "Consulta ARG retornou $($results.Count) registros" -Tag Test -Level VeryVerbose

        # Normalize null/empty ThreatIntelMode to "Unknown"
        foreach ($row in $results) {
            if ([string]::IsNullOrWhiteSpace($row.ThreatIntelMode)) { $row.ThreatIntelMode = 'Unknown' }
        }
    }
    catch {
        Write-PSFMessage "Consulta do Gráfico de Recursos do Azure falhou: $($_.Exception.Message)" -Tag Test -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotSupported
        return
    }

    if ($results.Count -eq 0) {
        Write-PSFMessage "Nenhuma política de firewall encontrada." -Tag Test -Level VeryVerbose
        Add-ZtTestResultDetail -SkippedBecause NotSupported
        return
    }
    #endregion Data Collection

    #region Assessment Logic

    $passed = ($results | Where-Object { $_.ThreatIntelMode -ne 'Deny' }).Count -eq 0
    $allAlert = ($results | Where-Object { $_.ThreatIntelMode -ne 'Alert' }).Count -eq 0

    if ($passed) {
        $testResultMarkdown = "✅ Inteligência de Ameaça ativada no modo **Alerta e Negar**.`n`n%TestResult%"
    }
    elseif ($allAlert) {
        $testResultMarkdown = "✅ Inteligência de Ameaça ativada no modo **Alerta**.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "A inteligência de ameaça não está ativada no modo **Alerta e Negar** para todas as políticas de firewall.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    $reportTitle = "Políticas de firewall"
    $tableRows = ""

    $formatTemplate = @'

## {0}

| Nome da política | Nome da assinatura | Modo de inteligência de ameaça | Resultado |
| :---------- | :---------------- | :---------------- | :----- |
{1}

'@

    foreach ($item in $results | Sort-Object PolicyName) {

        $policyLink = "https://portal.azure.com/#resource$($item.PolicyID)"
        $subLink = "https://portal.azure.com/#resource/subscriptions/$($item.SubscriptionId)"

        $policyName = Get-SafeMarkdown -Text $item.PolicyName
        $subName = Get-SafeMarkdown -Text $item.SubscriptionName

        if ($item.ThreatIntelMode -eq 'Deny') {
            $icon = '✅'
        }
        else {
            $icon = '❌'
        }

        $tableRows += "| [$policyName]($policyLink) | [$subName]($subLink) | $($item.ThreatIntelMode) | $icon |`n"
    }

    $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25537'
        Title  = 'A inteligência de ameaça está Ativada no Modo Negar no Azure Firewall'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
