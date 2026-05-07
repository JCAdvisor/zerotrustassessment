<#
.SYNOPSIS
    Checks if Microsoft 365 traffic is actively flowing through Global Secure Access.

.DESCRIPTION
    This test validates that the Microsoft 365 traffic forwarding profile is enabled and
    that Microsoft 365 traffic is actively being tunneled through Global Secure Access.

.NOTES
    Test ID: 25376
    Category: Traffic Acquisition
    Required API: networkAccess/reports (beta)
#>

function Test-Assessment-25376 {
    [ZtTest(
        Category = 'Segurança de rede',
        ImplementationCost = 'Médio',
        MinimumLicense = 'Entra_Suite',
        CompatibleLicense = ('Entra_Premium_Private_Access','Entra_Premium_Internet_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 25376,
        Title = 'O tráfego do Microsoft 365 está fluindo ativamente pelo Global Secure Access',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando o tráfego do Microsoft 365 pelo Global Secure Access'
    Write-ZtProgress -Activity $activity -Status 'Verificando o perfil de encaminhamento do M365'

    # Define evaluation time window (last 7 days)
    $endDateTime = (Get-Date).ToUniversalTime()
    $startDateTime = $endDateTime.AddDays(-7)
    $startDateTimeStr = $startDateTime.ToString('yyyy-MM-ddTHH:mm:ssZ')
    $endDateTimeStr = $endDateTime.ToString('yyyy-MM-ddTHH:mm:ssZ')
    $activityPivotDateTime = $endDateTime.AddDays(-1)
    $activityPivotDateTimeStr = $activityPivotDateTime.ToString('yyyy-MM-ddTHH:mm:ssZ')

        # Consulta 3: Verify Microsoft 365 traffic forwarding profile is enabled
    $m365Profile = $null
    try {
        $m365Profile = Invoke-ZtGraphRequest -RelativeUri "networkAccess/forwardingProfiles?`$filter=trafficForwardingType eq 'm365'" -ApiVersion beta
    } catch {
        Write-PSFMessage "Não foi possível recuperar o perfil de encaminhamento do M365: $_" -Level Warning
    }

        # Consulta 1 & 2: Execute in parallel conceptually, but sequentially due to tool constraints
    Write-ZtProgress -Activity $activity -Status 'Obtendo estatísticas de tráfego'

        # Consulta 1: Get transaction summaries
    $transactionSummary = $null
    try {
        $transactionSummary = Invoke-ZtGraphRequest -RelativeUri "networkAccess/reports/transactionSummaries(startDateTime=$startDateTimeStr,endDateTime=$endDateTimeStr)" -ApiVersion beta
    } catch {
        Write-PSFMessage "Não foi possível recuperar os resumos de transações: $_" -Level Warning
    }

        # Consulta 2: Get device usage summary
    $deviceUsage = $null
    try {
        $deviceUsage = Invoke-ZtGraphRequest `
            -RelativeUri "networkAccess/reports/getDeviceUsageSummary(startDateTime=$startDateTimeStr,endDateTime=$endDateTimeStr,activityPivotDateTime=$activityPivotDateTimeStr)" `
            -ApiVersion beta
    } catch {
        Write-PSFMessage "Não foi possível recuperar o resumo de uso de dispositivos: $_" -Level Warning
    }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $true
    $warnings = [System.Collections.Generic.List[string]]::new()

    # Extract M365 profile state
    $profileEnabled = $false
    $profileState = 'Not found'
    $profileName = 'N/A'
    if ($m365Profile -and $m365Profile.Count -gt 0) {
        $m365ProfileData = $m365Profile | Select-Object -First 1
        $profileName = $m365ProfileData.name
        $profileState = $m365ProfileData.state
        $profileEnabled = ($m365ProfileData.state -eq 'enabled')
    }

    # Extract M365 transaction data
    $m365TotalCount = 0
    $m365BlockedCount = 0
    if ($transactionSummary) {
        $m365Entry = $transactionSummary | Where-Object { $_.trafficType -eq 'microsoft365' } | Select-Object -First 1
        if ($m365Entry) {
            $m365TotalCount = [int]$m365Entry.totalCount
            $m365BlockedCount = [int]$m365Entry.blockedCount
        }
    }

    # Extract device usage data
    $totalDeviceCount = 0
    $activeDeviceCount = 0
    $inactiveDeviceCount = 0
    if ($deviceUsage) {
        $totalDeviceCount = [int]$deviceUsage.totalDeviceCount
        $activeDeviceCount = [int]$deviceUsage.activeDeviceCount
        $inactiveDeviceCount = [int]$deviceUsage.inactiveDeviceCount
    }

    # Evaluation logic
    if (-not $profileEnabled) {
        $passed = $false
    }

    if ($m365TotalCount -eq 0) {
        $passed = $false
    }

    # Warning conditions
    if ($profileEnabled -and $m365TotalCount -gt 0 -and $m365TotalCount -lt 1000) {
        $warnings.Add("A baixa contagem de transações do Microsoft 365 ($m365TotalCount) pode indicar problemas de implantação")
    }

    if ($activeDeviceCount -eq 0 -and $totalDeviceCount -gt 0) {
        $warnings.Add("Nenhum dispositivo ativo detectado apesar de $totalDeviceCount dispositivos registrados")
    }

    if ($activeDeviceCount -lt 10 -and $profileEnabled -and $totalDeviceCount -gt 0) {
        $warnings.Add("A baixa contagem de dispositivos ativos ($activeDeviceCount) - verifique a implantação do cliente em todos os endpoints")
    }

    # Generate result message
    if ($passed -and $warnings.Count -eq 0) {
        $testResultMarkdown = "✅ O encaminhamento de tráfego do Microsoft 365 está habilitado e um volume saudável de tráfego do Microsoft 365 está fluindo pelo Global Secure Access.`n`n%TestResult%"
    }
    elseif ($passed -and $warnings.Count -gt 0) {
        $testResultMarkdown = "⚠️ O tráfego do Microsoft 365 está fluindo pelo Global Secure Access, mas algumas preocupações foram detectadas.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ O encaminhamento de tráfego do Microsoft 365 está desabilitado ou nenhum tráfego do Microsoft 365 está sendo roteado pelo Global Secure Access.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    # Summary Section
    $mdInfo += "`n## Resumo`n`n"
    $mdInfo += "| Métrica | Valor |`n"
    $mdInfo += "| :--- | ---: |`n"
    $mdInfo += "| Perfil habilitado | $(if ($profileEnabled) { '✅ Sim' } else { '❌ Não' }) |`n"

    # Only show transaction and device counts if profile is enabled
    if ($profileEnabled) {
        $mdInfo += "| Transações do M365 (7 dias) | $($m365TotalCount.ToString('N0')) |`n"
        $mdInfo += "| Transações bloqueadas do M365 | $($m365BlockedCount.ToString('N0')) |`n"
        $mdInfo += "| Dispositivos ativos | $activeDeviceCount |`n"
        $mdInfo += "| Dispositivos totais | $totalDeviceCount |`n"
    }
    $mdInfo += "`n"

    # Traffic Forwarding Profile Section
    $mdInfo += "`n## Perfil de encaminhamento de tráfego`n`n"
    $mdInfo += "| Propriedade | Valor |`n"
    $mdInfo += "| :--- | :--- |`n"
    $mdInfo += "| Nome do perfil | $(Get-SafeMarkdown -Text $profileName) |`n"
    $mdInfo += "| Estado | $profileState |`n"
    $mdInfo += "| Tipo de tráfego | m365 |`n`n"

    # Only show transaction and device data if profile is enabled
    if ($profileEnabled) {
        # Transaction Summary Section
        $mdInfo += "`n## Resumo de transações`n`n"
        $mdInfo += "| Tipo de tráfego | Total | Bloqueado |`n"
        $mdInfo += "| :--- | ---: | ---: |`n"
        if ($transactionSummary) {
            foreach ($entry in $transactionSummary | Sort-Object trafficType) {
                $total = [int]$entry.totalCount
                $blocked = [int]$entry.blockedCount
                $mdInfo += "| $($entry.trafficType) | $($total.ToString('N0')) | $($blocked.ToString('N0')) |`n"
            }
        } else {
            $mdInfo += "| - | Nenhum dado disponível | - |`n"
        }
        $mdInfo += "`n"
        $mdInfo += "*Período de Avaliação: $($startDateTime.ToString('yyyy-MM-dd')) a $($endDateTime.ToString('yyyy-MM-dd'))*`n`n"

        # Device Usage Section (only shown when API returned data)
        if ($deviceUsage) {
            $mdInfo += "`n## Uso de Dispositivos`n`n"
            $mdInfo += "| Métrica | Contagem |`n"
            $mdInfo += "| :--- | ---: |`n"
            $mdInfo += "| Total de dispositivos | $totalDeviceCount |`n"
            $mdInfo += "| Dispositivos ativos | $activeDeviceCount |`n"
            $mdInfo += "| Dispositivos inativos | $inactiveDeviceCount |`n`n"
        }
    }

    # Warnings Section
    if ($warnings.Count -gt 0) {
        $mdInfo += "`n## ⚠️ Avisos`n`n"
        foreach ($warning in $warnings) {
            $mdInfo += "- $warning`n"
        }
        $mdInfo += "`n"
    }

    # Portal Link
    $portalLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/ForwardingProfile.ReactView"
    $mdInfo += "`n[$(Get-SafeMarkdown -Text 'Ver no portal do Entra: encaminhamento de tráfego')]($portalLink)"

    # Replace placeholder with detailed information
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25376'
        Title  = 'O tráfego do Microsoft 365 está fluindo ativamente pelo Global Secure Access'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
