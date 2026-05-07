<#
.SYNOPSIS
    A política do Intune Windows Update está configurada e atribuída
#>

function Test-Assessment-24553 {
    [ZtTest(
    	Category = 'Dispositivos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger tenants e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24553,
    	Title = 'As políticas do Windows Update são aplicadas para reduzir o risco de vulnerabilidades não corrigidas',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    #region Data Collection
    $activity = 'Verificando se a política do Intune Windows Update está configurada e atribuída'
    Write-ZtProgress -Activity $activity

    # Retrieve all Windows Update Policies and their assignments
    $windowsUpdatePolicy = Invoke-ZtGraphRequest -RelativeUri 'deviceManagement/deviceConfigurations?$expand=assignments' -ApiVersion beta | Where-Object {
        $_.'@odata.type' -eq '#microsoft.graph.windowsUpdateForBusinessConfiguration'
    }
    #endregion Data Collection

    #region Assessment Logic
    # Check if at least one policy has assignments
    $hasAssignments = $false
    foreach ($policy in $windowsUpdatePolicy) {
        if ($policy.assignments -and $policy.assignments.Count -gt 0) {
            $hasAssignments = $true
            break
        }
    }

    $passed = $windowsUpdatePolicy.Count -gt 0 -and $hasAssignments

    if ($passed) {
        $testResultMarkdown = "Política do Windows Update está atribuída e aplicada.`n`n%TestResult%"
    }
    else {
        if ($windowsUpdatePolicy.Count -eq 0) {
            $testResultMarkdown = "Nenhuma política do Windows Update encontrada.`n`n%TestResult%"
        } else {
            $testResultMarkdown = "Política do Windows Update não está atribuída ou não está aplicada.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build the detailed sections of the markdown

    # Generate markdown table rows for each policy
    $mdInfo = ""
    if ($windowsUpdatePolicy.Count -gt 0) {
        # Create a here-string with format placeholder
        $formatTemplate = @'

| Nome da Política | Status | Alvo da Atribuição |
| :--------------- | :----- | :----------------- |
{0}

'@

        $tableRows = ""
        foreach ($policy in $windowsUpdatePolicy) {
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesWindowsMenu/~/windows10Update'
            $status = if ($policy.assignments -and $policy.assignments.count -gt 0) {
                '✅ Atribuída'
            }
            else {
                '❌ Não Atribuída'
            }

            $policyName = Get-SafeMarkdown -Text $policy.displayName
            $assignmentTarget = 'None'

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }

            $tableRows += "| [$policyName]($portalLink) | $status | $assignmentTarget |`n"
        }

         # Format the template by replacing placeholder with table rows
        $mdInfo = $formatTemplate -f $tableRows
    }

    # Replace the placeholder in the test result markdown with the generated details
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Report Generation

    $params = @{
        TestId             = '24553'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
