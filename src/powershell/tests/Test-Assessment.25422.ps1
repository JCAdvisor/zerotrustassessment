<#
.SYNOPSIS
    Os logs de implantação do GSA são preenchidos e revisados

.DESCRIPTION
    Verifica se os logs de implantação do Global Secure Access estão sendo preenchidos e se implantações recentes
    foram bem-sucedidas. Implantações falhadas indicam problemas de configuração que requerem investigação.

.NOTES
    Test ID: 25422
    Pillar: Network
    Risk Level: Medium
    SFI Pillar: Monitor and detect cyberthreats
#>

function Test-Assessment-25422 {
    [ZtTest(
    	Category = 'Acesso Seguro Global',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Entra_Premium_Internet_Access','Entra_Premium_Private_Access'),
    	CompatibleLicense = ('Entra_Premium_Internet_Access','Entra_Premium_Private_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Monitorar e detectar ciberameaças',
    	TenantType = ('Workforce','External'),
    	TestId = 25422,
    	Title = 'Os logs de implantação do Acesso Seguro Global estão preenchidos e revisados',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando se logs de implantação do GSA são preenchidos e revisados'

    # Q1: Check if GSA is enabled (prerequisite check)
    Write-ZtProgress -Activity $activity -Status 'Verificando se o Global Secure Access está ativado'
    $forwardingProfiles = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/forwardingProfiles' -ApiVersion beta

    # Check if GSA is configured
    $gsaEnabled = $false
    if ($forwardingProfiles -and $forwardingProfiles.Count -gt 0) {
        $enabledProfiles = $forwardingProfiles | Where-Object { $_.state -eq 'enabled' }
        $gsaEnabled = $enabledProfiles.Count -gt 0
    }

    # If GSA not configured, skip
    if (-not $gsaEnabled) {
        Write-PSFMessage 'Global Secure Access is not enabled in this tenant.' -Tag Test -Level Verbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable
        return
    }

    # Q2: Retrieve GSA deployment logs
    Write-ZtProgress -Activity $activity -Status 'Recuperando logs de implantação'
    $deployments = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/deployments' -ApiVersion beta

    # Filter deployments from the last 30 days
    $thirtyDaysAgo = (Get-Date).AddDays(-30)
    $recentDeployments = @()

    if ($deployments -and $deployments.Count -gt 0) {
        $recentDeployments = $deployments | Where-Object {
            $deploymentDate = $null
            if ($_.deploymentEndDateTime) {
                $deploymentDate = [datetime]$_.deploymentEndDateTime
            }
            elseif ($_.lastModifiedDateTime) {
                $deploymentDate = [datetime]$_.lastModifiedDateTime
            }
            $deploymentDate -and $deploymentDate -ge $thirtyDaysAgo
        }
    }

    # Calculate deployment statistics
    $totalCount = if ($recentDeployments) { @($recentDeployments).Count } else { 0 }
    $succeededCount = @($recentDeployments | Where-Object { $_.status.deploymentStage -eq 'succeeded' }).Count
    $failedCount = @($recentDeployments | Where-Object { $_.status.deploymentStage -eq 'failed' }).Count
    $inProgressCount = @($recentDeployments | Where-Object { $_.status.deploymentStage -in @('pending', 'inProgress') }).Count
    $failureRate = if ($totalCount -gt 0) { [math]::Round(($failedCount / $totalCount) * 100, 1) } else { 0 }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $false

    # If failedCount = 0 → Pass
    # If failedCount > 0 → Fail
    if ($failedCount -eq 0) {
        $passed = $true
        $testResultMarkdown = "✅ Os logs de implantação do GSA são preenchidos e implantações recentes foram bem-sucedidas.`n`n%TestResult%"
    }
    else {
        $passed = $false
        $testResultMarkdown = "❌ Os logs de implantação do GSA contém implantações falhadas que requerem investigação.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    # Build deployment summary table
    $deploymentLogsLink = 'https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/DeploymentLogs.ReactView'

    $mdInfo += @"

## [Logs de Implantação]($deploymentLogsLink)

**Resumo de Implantação (Últimos 30 Dias):**

| Metric | Value |
| :--- | :--- |
| Total Deployments | $totalCount |
| Succeeded | $succeededCount |
| Failed | $failedCount |
| In Progress | $inProgressCount |
| Failure Rate | $failureRate% |

"@

    # Build recent deployments table
    if ($totalCount -gt 0) {
        # Check if truncation needed
        $displayCount = [math]::Min($totalCount, 10)
        $isTruncated = $totalCount -gt 10

        $truncationMessage = ''
        if ($isTruncated) {
            $truncationMessage = "Showing $displayCount of $totalCount deployments. [View all deployments]($deploymentLogsLink)`n`n"
        }

        $formatTemplate = @'

**Recent Deployments:**

{0}
| Date | Operation | Change Type | Status | Initiated By | Error Message |
| :--- | :--- | :--- | :--- | :--- | :--- |
{1}

'@

        $tableRows = ''

        # Sort by date descending and take first 10
        $sortedDeployments = $recentDeployments | Sort-Object -Property {
            if ($_.deploymentEndDateTime) { [datetime]$_.deploymentEndDateTime }
            elseif ($_.lastModifiedDateTime) { [datetime]$_.lastModifiedDateTime }
            else { [datetime]::MinValue }
        } -Descending | Select-Object -First 10

        foreach ($deployment in $sortedDeployments) {
            $deploymentDate = if ($deployment.deploymentEndDateTime) {
                ([datetime]$deployment.deploymentEndDateTime).ToString('yyyy-MM-dd HH:mm')
            }
            elseif ($deployment.lastModifiedDateTime) {
                ([datetime]$deployment.lastModifiedDateTime).ToString('yyyy-MM-dd HH:mm')
            }
            else {
                'N/A'
            }

            $operationName = if ($deployment.configuration.operationName) {
                Get-SafeMarkdown -Text $deployment.configuration.operationName
            }
            else {
                'N/A'
            }

            $changeType = if ($deployment.configuration.changeType) {
                $deployment.configuration.changeType
            }
            else {
                'N/A'
            }

            $stage = $deployment.status.deploymentStage
            $icon = switch ($stage) {
                'succeeded' { '✅' }
                'failed' { '❌' }
                'inProgress' { '🔄' }
                'pending' { '⏳' }
                default { '' }
            }
            $deploymentStage = switch ($stage) {
                'succeeded' { 'Succeeded' }
                'failed' { 'Failed' }
                'inProgress' { 'In Progress' }
                'pending' { 'Pending' }
                default { $stage }
            }
            $resultText = if ($icon) { "$icon $deploymentStage" } else { $deploymentStage }

            $initiatedBy = if ($deployment.initiatedBy) {
                Get-SafeMarkdown -Text $deployment.initiatedBy
            }
            else {
                'N/A'
            }

            $errorMessage = if ($deployment.status.message) {
                Get-SafeMarkdown -Text $deployment.status.message
            }
            else {
                'N/A'
            }

            $tableRows += "| $deploymentDate | $operationName | $changeType | $resultText | $initiatedBy | $errorMessage |`n"
        }

        if ($isTruncated) {
            $tableRows += "| ... | | | | | |`n"
        }

        $mdInfo += $formatTemplate -f $truncationMessage, $tableRows
    }
    else {
        $mdInfo += "`n**Implantações recentes:**`n`nNenhuma implantação encontrada nos últimos 30 dias.`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25422'
        Title  = 'Logs de implantação do GSA estão preenchidos e revisados'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
