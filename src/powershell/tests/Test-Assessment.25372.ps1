<#
.SYNOPSIS
    Validates that Global Secure Access client is deployed on all managed endpoints.

.DESCRIPTION
    This test compares the count of devices connected to Global Secure Access with the total
    count of Entra ID managed devices (joined and hybrid joined) to determine deployment coverage.
    Endpoints without the GSA client operate outside the organization's Security Service Edge controls.

.NOTES
    Test ID: 25372
    Category: Global Secure Access
    Required API: networkAccess/reports/getDeviceUsageSummary (beta), devices (v1.0)
#>

function Test-Assessment-25372 {
    [ZtTest(
        Category = 'Global Secure Access',
        ImplementationCost = 'Médio',
        MinimumLicense = ('AAD_PREMIUM', 'Entra_Premium_Internet_Access', 'Entra_Premium_Private_Access'),
        CompatibleLicense = ('Entra_Premium_Private_Access','Entra_Premium_Internet_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 25372,
        Title = 'O cliente do Global Secure Access está implantado em todos os endpoints gerenciados',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando a implantação do cliente do Global Secure Access'
    Write-ZtProgress -Activity $activity -Status 'Obtendo resumo de uso de dispositivos do GSA'

    # Set evaluation time window (last 7 days)
    $endDateTime = (Get-Date).ToUniversalTime()
    $startDateTime = $endDateTime.AddDays(-7)
    $activityPivotDateTime = $endDateTime.AddDays(-1)

    $startDateTimeStr = $startDateTime.ToString('yyyy-MM-ddTHH:mm:ssZ')
    $endDateTimeStr = $endDateTime.ToString('yyyy-MM-ddTHH:mm:ssZ')
    $activityPivotDateTimeStr = $activityPivotDateTime.ToString('yyyy-MM-ddTHH:mm:ssZ')

    $gsaCmdletFailed = $false
    $deviceQueryFailed = $false

        # Consulta Q1: Retrieve Global Secure Access device usage summary
    $gsaDeviceSummary = $null
    try {
        $gsaDeviceSummary = Invoke-ZtGraphRequest `
            -RelativeUri "networkAccess/reports/getDeviceUsageSummary(startDateTime=$startDateTimeStr,endDateTime=$endDateTimeStr,activityPivotDateTime=$activityPivotDateTimeStr)" `
            -ApiVersion beta `
            -ErrorAction Stop
    }
    catch {
        $gsaCmdletFailed = $true
        Write-PSFMessage "Falha ao obter o resumo de uso de dispositivos do GSA: $_" -Tag Test -Level Warning
    }

    Write-ZtProgress -Activity $activity -Status 'Obtendo a contagem de dispositivos ingressados e híbridos do Entra ID'

        # Consulta Q2: Count Entra ID joined and hybrid joined devices from database
    $entraDeviceCount = 0
    try {
        $sql = "SELECT COUNT(*) as DeviceCount FROM Device WHERE trustType == 'AzureAd' OR trustType == 'ServerAd'"
        $result = Invoke-DatabaseQuery -Database $Database -Sql $sql -ErrorAction Stop
        $entraDeviceCount = if ($result) { $result.DeviceCount } else { 0 }
    }
    catch {
        $deviceQueryFailed = $true
        Write-PSFMessage "Falha ao consultar a contagem de dispositivos no banco de dados: $_" -Tag Test -Level Warning
    }

    # Extract values
    $totalGsaDevices = if ($gsaDeviceSummary) { $gsaDeviceSummary.totalDeviceCount } else { 0 }
    $activeGsaDevices = if ($gsaDeviceSummary) { $gsaDeviceSummary.activeDeviceCount } else { 0 }
    $inactiveGsaDevices = if ($gsaDeviceSummary) { $gsaDeviceSummary.inactiveDeviceCount } else { 0 }
    $totalManagedDevices = if ($entraDeviceCount) { $entraDeviceCount } else { 0 }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $false
    $customStatus = $null

    # Handle any query failure - cannot determine deployment status
    if ($gsaCmdletFailed -or $deviceQueryFailed) {
        Write-PSFMessage "Não foi possível recuperar os dados de implantação do GSA devido a falha na consulta" -Tag Test -Level Warning
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ Não foi possível determinar a cobertura de implantação do cliente do GSA devido a falha na consulta, problemas de conexão ou permissões insuficientes.`n`n"
    }
    # Edge case: GSA devices > Entra ID devices (data inconsistency; GSA has more devices than Entra ID)
    # Per spec: Still calculate percentage and gap to help diagnose the issue
    elseif ($totalGsaDevices -gt $totalManagedDevices -and $totalManagedDevices -gt 0) {
        $customStatus = 'Investigate'
        $deploymentPercentage = [math]::Round(($totalGsaDevices / $totalManagedDevices) * 100, 1)
        $gap = [math]::Abs($totalManagedDevices - $totalGsaDevices)
        $testResultMarkdown = "⚠️ A contagem de dispositivos do Global Secure Access excede a contagem de dispositivos gerenciados do Entra ID. Isso indica registros de GSA obsoletos, dispositivos removidos do Entra ID ou problemas de sincronização de dados entre sistemas. Revise ambas as fontes de dados para reconciliar as contagens.`n`n%TestResult%"
    }
    # Edge case: No devices at all (both = 0) - Fail per spec
    elseif ($totalManagedDevices -eq 0 -and $totalGsaDevices -eq 0) {
        $deploymentPercentage = 0
        $gap = 0
        $testResultMarkdown = "❌ A implantação do cliente do Global Secure Access é insuficiente ou não pode ser verificada. A cobertura de implantação está abaixo de 70%, nenhum dispositivo foi detectado ou os serviços podem não estar no escopo deste ambiente.`n`n%TestResult%"
    }
    # Edge case: No managed devices but GSA devices exist (cannot calculate percentage; Entra ID baseline unavailable)
    elseif ($totalManagedDevices -eq 0 -and $totalGsaDevices -gt 0) {
        $customStatus = 'Investigate'
        $deploymentPercentage = 'N/A'
        $gap = 'N/A'
        $testResultMarkdown = "⚠️ Dispositivos do Global Secure Access foram detectados, mas nenhum dispositivo ingressado ou híbrido no Entra ID foi encontrado. A cobertura de implantação não pode ser calculada. Isso pode indicar que os dados de registro de dispositivos estão inacessíveis ou que as permissões necessárias estão ausentes.`n`n%TestResult%"
    }
    # Normal scenario: Calculate deployment percentage and assess
    else {
        $deploymentPercentage = [math]::Round(($totalGsaDevices / $totalManagedDevices) * 100, 1)
        $gap = $totalManagedDevices - $totalGsaDevices

        # Pass: Deployment percentage >= 90%
        if ($deploymentPercentage -ge 90) {
            $passed = $true
            $testResultMarkdown = "✅ O cliente do Global Secure Access está implantado na maioria dos endpoints gerenciados.`n`n%TestResult%"
        }
        # Investigate: Deployment percentage between 70% and 90%
        elseif ($deploymentPercentage -ge 70) {
            $customStatus = 'Investigate'
            $testResultMarkdown = "⚠️ A cobertura de implantação do cliente do Global Secure Access está entre 70% e 90% dos dispositivos gerenciados. Revise a distribuição por plataforma de dispositivo para mais detalhes.`n`n%TestResult%"
        }
        # Fail: Deployment percentage < 70%
        else {
            $testResultMarkdown = "❌ A implantação do cliente do Global Secure Access é insuficiente ou não pode ser verificada. A cobertura de implantação está abaixo de 70%, nenhum dispositivo é detectado ou os serviços podem não estar no escopo deste ambiente.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    # Only generate report table if we have data (not in error state)
    if (-not ($gsaCmdletFailed -or $deviceQueryFailed)) {
        $reportTitle = 'Resumo de implantação'
        $portalLink = 'https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/AdminDashboard.ReactView'
        $deploymentPercentageDisplay = if ($deploymentPercentage -ne 'N/A') { "$deploymentPercentage%" } else { $deploymentPercentage }
        $evaluationPeriod = "$(Get-FormattedDate -DateString $startDateTime.ToString()) a $(Get-FormattedDate -DateString $endDateTime.ToString())"

        $formatTemplate = @'

## [{0}]({1})

| Métrica | Valor |
| :----- | ----: |
{2}

'@

        $tableRows = "| Total de dispositivos GSA | $totalGsaDevices |`n"
        $tableRows += "| Dispositivos ativos | $activeGsaDevices |`n"
        $tableRows += "| Dispositivos inativos | $inactiveGsaDevices |`n"
        $tableRows += "| Contagem total de dispositivos gerenciados | $totalManagedDevices |`n"
        $tableRows += "| Percentual de implantação | $deploymentPercentageDisplay |`n"
        $tableRows += "| Lacuna | $gap |`n"
        $tableRows += "| Período de avaliação | $evaluationPeriod |`n"

        $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $tableRows

        $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    }
    #endregion Report Generation

    $params = @{
        TestId = '25372'
        Title  = 'O cliente do Global Secure Access está implantado em todos os endpoints gerenciados'
        Status = $passed
        Result = $testResultMarkdown
    }
    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }
    Add-ZtTestResultDetail @params
}
