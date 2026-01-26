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
        Category = 'Traffic Acquisition',
        ImplementationCost = 'Medium',
        MinimumLicense = ('P1','E3'),
        Pillar = 'Network',
        RiskLevel = 'High',
        SfiPillar = 'Protect networks',
        TenantType = ('Workforce'),
        TestId = 25376,
        Title = 'Microsoft 365 traffic is actively flowing through Global Secure Access',
        UserImpact = 'Low'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Start' -Tag Test -Level VeryVerbose

    $activity = 'Checking Microsoft 365 traffic through Global Secure Access'
    Write-ZtProgress -Activity $activity -Status 'Verifying M365 traffic forwarding profile'

    # Define evaluation time window (last 7 days)
    $endDateTime = (Get-Date).ToUniversalTime()
    $startDateTime = $endDateTime.AddDays(-7)
    $startDateTimeStr = $startDateTime.ToString('yyyy-MM-ddTHH:mm:ssZ')
    $endDateTimeStr = $endDateTime.ToString('yyyy-MM-ddTHH:mm:ssZ')

    # Query 3: Verify Microsoft 365 traffic forwarding profile is enabled
    $m365Profile = $null
    try {
        $allProfiles = Invoke-ZtGraphRequest -RelativeUri "networkAccess/forwardingProfiles" -ApiVersion beta
        $m365Profile = $allProfiles | Where-Object { $_.trafficForwardingType -eq 'm365' }
    } catch {
        Write-PSFMessage "Unable to retrieve M365 forwarding profile: $_" -Level Warning
    }

    # Query 1 & 2: Execute in parallel conceptually, but sequentially due to tool constraints
    Write-ZtProgress -Activity $activity -Status 'Retrieving traffic statistics'

    # Query 1: Get transaction summaries
    $transactionSummary = $null
    try {
        $transactionSummary = Invoke-ZtGraphRequest -RelativeUri "networkAccess/reports/transactionSummaries(startDateTime=$startDateTimeStr,endDateTime=$endDateTimeStr)" -ApiVersion beta
    } catch {
        Write-PSFMessage "Unable to retrieve transaction summaries: $_" -Level Warning
    }

    # Query 2: Get Dispositivos usage summary
    $DispositivosUsage = $null
    try {
        $DispositivosUsage = Invoke-ZtGraphRequest -RelativeUri "networkAccess/reports/getDispositivosUsageSummary(startDateTime=$startDateTimeStr,endDateTime=$endDateTimeStr)" -ApiVersion beta
    } catch {
        Write-PSFMessage "Unable to retrieve Dispositivos usage summary: $_" -Level Warning
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

    # Extract Dispositivos usage data
    $totalDispositivosCount = 0
    $activeDispositivosCount = 0
    $inactiveDispositivosCount = 0
    if ($DispositivosUsage) {
        $totalDispositivosCount = [int]$DispositivosUsage.totalDispositivosCount
        $activeDispositivosCount = [int]$DispositivosUsage.activeDispositivosCount
        $inactiveDispositivosCount = [int]$DispositivosUsage.inactiveDispositivosCount
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
        $warnings.Add("Low Microsoft 365 transaction count ($m365TotalCount) may indicate deployment issues")
    }

    if ($activeDispositivosCount -eq 0 -and $totalDispositivosCount -gt 0) {
        $warnings.Add("No active Dispositivos detected despite $totalDispositivosCount total Dispositivos registered")
    }

    if ($activeDispositivosCount -lt 10 -and $profileEnabled) {
        $warnings.Add("Low active Dispositivos count ($activeDispositivosCount) - verify client deployment across endpoints")
    }

    # Generate result message
    if ($passed -and $warnings.Count -eq 0) {
        $testResultMarkdown = "✅ Microsoft 365 traffic forwarding is enabled and a healthy volume of Microsoft 365 traffic is flowing through Global Secure Access.`n`n%TestResult%"
    }
    elseif ($passed -and $warnings.Count -gt 0) {
        $testResultMarkdown = "⚠️ Microsoft 365 traffic is flowing through Global Secure Access, but some concerns were detected.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ Microsoft 365 traffic forwarding is disabled or no Microsoft 365 traffic is being tunneled through Global Secure Access.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    # Summary Section
    $mdInfo += "`n## Summary`n`n"
    $mdInfo += "| Metric | Value |`n"
    $mdInfo += "| :--- | ---: |`n"
    $mdInfo += "| Profile Enabled | $(if ($profileEnabled) { '✅ Yes' } else { '❌ No' }) |`n"

    # Only show transaction and Dispositivos counts if profile is enabled
    if ($profileEnabled) {
        $mdInfo += "| M365 Transactions (7 days) | $($m365TotalCount.ToString('N0')) |`n"
        $mdInfo += "| M365 Blocked Transactions | $($m365BlockedCount.ToString('N0')) |`n"
        $mdInfo += "| Active Dispositivos | $activeDispositivosCount |`n"
        $mdInfo += "| Total Dispositivos | $totalDispositivosCount |`n"
    }
    $mdInfo += "`n"

    # Traffic Forwarding Profile Section
    $mdInfo += "`n## Traffic Forwarding Profile`n`n"
    $mdInfo += "| Property | Value |`n"
    $mdInfo += "| :--- | :--- |`n"
    $mdInfo += "| Profile Name | $(Get-SafeMarkdown -Text $profileName) |`n"
    $mdInfo += "| State | $profileState |`n"
    $mdInfo += "| Traffic Type | m365 |`n`n"

    # Only show transaction and Dispositivos data if profile is enabled
    if ($profileEnabled) {
        # Transaction Summary Section
        $mdInfo += "`n## Transaction Summary`n`n"
        $mdInfo += "| Traffic Type | Total Count | Blocked Count |`n"
        $mdInfo += "| :--- | ---: | ---: |`n"
        if ($transactionSummary) {
            foreach ($entry in $transactionSummary | Sort-Object trafficType) {
                $total = [int]$entry.totalCount
                $blocked = [int]$entry.blockedCount
                $mdInfo += "| $($entry.trafficType) | $($total.ToString('N0')) | $($blocked.ToString('N0')) |`n"
            }
        } else {
            $mdInfo += "| - | No data available | - |`n"
        }
        $mdInfo += "`n"
        $mdInfo += "*Evaluation Period: $($startDateTime.ToString('yyyy-MM-dd')) to $($endDateTime.ToString('yyyy-MM-dd'))*`n`n"

        # Dispositivos Usage Section
        $mdInfo += "`n## Dispositivos Usage`n`n"
        $mdInfo += "| Metric | Count |`n"
        $mdInfo += "| :--- | ---: |`n"
        $mdInfo += "| Total Dispositivos | $totalDispositivosCount |`n"
        $mdInfo += "| Active Dispositivos | $activeDispositivosCount |`n"
        $mdInfo += "| Inactive Dispositivos | $inactiveDispositivosCount |`n`n"
    }

    # Warnings Section
    if ($warnings.Count -gt 0) {
        $mdInfo += "`n## ⚠️ Warnings`n`n"
        foreach ($warning in $warnings) {
            $mdInfo += "- $warning`n"
        }
        $mdInfo += "`n"
    }

    # Portal Link
    $portalLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/ForwardingProfile.ReactView"
    $mdInfo += "`n[$(Get-SafeMarkdown -Text 'View in Entra Portal: Traffic forwarding')]($portalLink)"

    # Replace placeholder with detailed information
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25376'
        Title  = 'Microsoft 365 traffic is actively flowing through Global Secure Access'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
