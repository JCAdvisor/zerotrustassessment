<#
.SYNOPSIS
    Validates that Private Access Sensors are deployed on domain controllers and enforcing strong authentication policies.

.DESCRIPTION
    This test checks if Microsoft Entra Private Access Sensors are deployed to domain controllers
    and configured to enforce strong authentication policies (status active and not in audit mode).

.NOTES
    Test ID: 25403
    Category: Private Access
    Required API: onPremisesPublishingProfiles/privateAccess/sensors (beta)
#>

function Test-Assessment-25403 {
    [ZtTest(
    	Category = 'Global Secure Access',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Entra_Suite','Entra_Premium_Private_Access'),
    	CompatibleLicense = ('Entra_Premium_Private_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 25403,
    	Title = 'Os sensores de Private Access estão impondo políticas de autenticação forte nos controladores de domínio',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando os sensores do Private Access em controladores de domínio'
    Write-ZtProgress -Activity $activity -Status 'Obtendo sensores do Private Access'

        # Consulta all Private Access Sensors
    $sensors = Invoke-ZtGraphRequest -RelativeUri 'onPremisesPublishingProfiles/privateAccess/sensors' -ApiVersion beta
    #endregion Data Collection

    #region Assessment Logic
    # Initialize test variables
    $testResultMarkdown = ''
    $passed = $false

    if ($null -eq $sensors -or $sensors.Count -eq 0) {
        # No sensors found - fail
        $passed = $false
        $testResultMarkdown = "❌ Os sensores do Microsoft Entra Private Access para controladores de domínio não estão implantados.`n`n%TestResult%"
    }
    else {
        # Identify sensors that are active and enforcing (not in audit mode)
        $enforcingSensors = $sensors | Where-Object { $_.status -eq 'active' -and $_.isAuditMode -eq $false }
        $nonEnforcingSensors = $sensors | Where-Object { $_.status -ne 'active' -or $_.isAuditMode -eq $true }

        # Determine pass/fail status
        if ($enforcingSensors.Count -gt 0 -and $nonEnforcingSensors.Count -eq 0) {
            # All sensors are active and enforcing - pass
            $passed = $true
            $testResultMarkdown = "✅ O Microsoft Entra Private Access para controladores de domínio está implantado e impondo políticas de autenticação forte.`n`n%TestResult%"
        }
        elseif ($enforcingSensors.Count -eq 0) {
            # No sensors are enforcing - fail
            $passed = $false
            $testResultMarkdown = "❌ Os sensores do Microsoft Entra Private Access estão implantados, mas as políticas de autenticação forte não estão configuradas.`n`n%TestResult%"
        }
        else {
            # Some sensors enforcing, some not - partial deployment warning (fail)
            $passed = $false
            $testResultMarkdown = "⚠️ Os sensores do Microsoft Entra Private Access estão parcialmente configurados. Alguns controladores de domínio não estão impondo políticas de autenticação forte.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build detailed markdown information
    $mdInfo = ''

    if ($sensors -and $sensors.Count -gt 0) {
        $reportTitle = "Sensores do Private Access"

        $mdInfo += "`n## $reportTitle`n`n"
        $mdInfo += "[Abrir Private Access no portal Entra](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/PrivateAccessOverview.ReactView)`n`n"

        # Summary statistics
        $mdInfo += "- **Total de sensores**: $($sensors.Count)`n"
        $mdInfo += "- **Ativos e impondo**: $($enforcingSensors.Count)`n"
        $mdInfo += "- **Não impondo**: $($nonEnforcingSensors.Count)`n`n"

        # Show warning for sensors not enforcing
        if ($nonEnforcingSensors.Count -gt 0) {
            $mdInfo += "**⚠️ Sensores não impondo políticas:** $($nonEnforcingSensors.Count)`n`n"
        }

        # Build table rows - show problematic sensors first
        $allSensors = @()
        $allSensors += $nonEnforcingSensors | ForEach-Object { $_ | Add-Member -NotePropertyName 'Priority' -NotePropertyValue 1 -PassThru -Force }
        $allSensors += $enforcingSensors | ForEach-Object { $_ | Add-Member -NotePropertyName 'Priority' -NotePropertyValue 2 -PassThru -Force }

        $tableRows = $allSensors | Sort-Object -Property Priority, machineName | ForEach-Object {
            $statusIcon = if ($_.status -eq 'active') { '✅ Ativo' } else { '❌ Inativo' }
            $auditModeIcon = if ($_.isAuditMode) { '⚠️ Sim' } else { '✅ Não' }
            $machineName = Get-SafeMarkdown $_.machineName
            $version = Get-SafeMarkdown $_.version
            $externalIp = Get-SafeMarkdown $_.externalIp

            "| $machineName | $statusIcon $($_.status) | $auditModeIcon | $version | $externalIp |"
        }

        $mdInfo += @'
| Machine name | Status | Audit mode | Version | External IP |
| :----------- | :----- | :--------- | :------ | :---------- |
{0}

'@ -f ($tableRows -join "`n")
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25403'
        Title  = 'O agente de DC está implantado e impondo políticas de autenticação forte'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
