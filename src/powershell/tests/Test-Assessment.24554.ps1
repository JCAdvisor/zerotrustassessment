<#
.SYNOPSIS
    Testa se uma política de atualização do iOS está criada e atribuída
#>

function Test-Assessment-24554 {
    [ZtTest(
    	Category = 'Dispositivos',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger tenants e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24554,
    	Title = 'Políticas de atualização para iOS/iPadOS são aplicadas para reduzir o risco de vulnerabilidades não corrigidas',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Funções Auxiliares
   function Test-PolicyAssignment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [array]$Policies
    )

    # Return false if $Policies is null or empty
    if (-not $Policies) {
        return $false
    }

    # Check if at least one policy has assignments
    $assignedPolicies = $Policies | Where-Object {
        $_.PSObject.Properties.Match("assignments") -and $_.assignments -and $_.assignments.Count -gt 0
    }

    return $assignedPolicies.Count -gt 0
}
    #endregion Helper Functions

    #region Data Collection
    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    $activity = "Verificando se políticas de atualização do iOS estão criadas e atribuídas"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    # Retrieve all iOS update policies and their potential assignments
    # MDM iOS Update Policies
    $iOSUpdatePolicies_MDMUri = "deviceManagement/deviceConfigurations?`$filter=isof('microsoft.graph.iosUpdateConfiguration')&`$expand=assignments"
    $iOSUpdatePolicies_MDM_assignments = Invoke-ZtGraphRequest -RelativeUri $iOSUpdatePolicies_MDMUri -ApiVersion beta

    # DDM iOS Update Policies
    $iOSPolicies_DDMUri = "deviceManagement/configurationPolicies?&`$filter=(platforms has 'iOS') and (technologies has 'mdm' and technologies has 'appleRemoteManagement')&`$expand=settings"
    $iOSPolicies_DDM = Invoke-ZtGraphRequest -RelativeUri $iOSPolicies_DDMUri -ApiVersion beta

    $iOSUpdatePolicies_DDM = @()
    foreach ($iOSPolicy_DDM in $iOSPolicies_DDM) {
        $validSettingIds = @('ddm-latestsoftwareupdate_enforcelatestsoftwareupdateversion', 'enforcement_targetosversion')

        # Get all setting definition IDs from the policy (handle both single values and arrays)
        $policySettingIds = $iOSPolicy_DDM.settings.settingInstance.groupSettingCollectionValue.Children.settingDefinitionId

        # Convert to array if it's a single value to ensure consistent handling
        if ($policySettingIds -isnot [array]) {
            $policySettingIds = @($policySettingIds)
        }

        # Check if any of the policy's setting IDs match our valid setting IDs
        $hasValidSetting = $false
        foreach ($settingId in $policySettingIds) {
            if ($validSettingIds -contains $settingId) {
                $hasValidSetting = $true
                break
            }
        }

        if ($hasValidSetting) {
            $iOSUpdatePolicies_DDM += $iOSPolicy_DDM
        }
    }

    # Get assignments for DDM policies
    $iOSUpdatePolicies_DDM_assignments = @()
    foreach ($iOSUpdatePolicy_DDM in $iOSUpdatePolicies_DDM) {
        $assignments = Invoke-ZtGraphRequest -RelativeUri "deviceManagement/configurationPolicies('$($iOSUpdatePolicy_DDM.id)')/assignments" -ApiVersion beta
        $iOSUpdatePolicy_DDM | Add-Member -MemberType NoteProperty -Name assignments -Value $assignments -Force
        $iOSUpdatePolicies_DDM_assignments += $iOSUpdatePolicy_DDM
    }

    $iOSUpdatePolicies = @($iOSUpdatePolicies_MDM_assignments) + @($iOSUpdatePolicies_DDM_assignments)

    #endregion Data Collection

    #region Assessment Logic
    $passed = $false
    $testResultMarkdown = ""

    # Test both MDM and DDM policy assignments
    $passed_MDM = Test-PolicyAssignment -Policies $iOSUpdatePolicies_MDM_assignments
    $passed_DDM = Test-PolicyAssignment -Policies $iOSUpdatePolicies_DDM_assignments

    # Pass if either MDM or DDM policies are assigned
    $passed = $passed_MDM -or $passed_DDM

    if ($passed) {
        $testResultMarkdown = "Uma política de atualização do iOS está configurada e atribuída.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "Nenhuma política de atualização do iOS está configurada ou aplicada.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build the detailed sections of the markdown

    # Define variables to insert into the format string
    $reportTitle = "Políticas de Atualização do iOS"
    $tableRows = ""

    if ($iOSUpdatePolicies.Count -gt 0) {
        # Create a here-string with format placeholders {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Política | Status | Alvo da Atribuição |
| :--------------- | :----- | :----------------- |
{1}

'@

        foreach ($policy in $iOSUpdatePolicies) {


            if ($policy.'@odata.type' -eq '#microsoft.graph.iosUpdateConfiguration') {
                $policyName = $policy.displayName
                $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/iOSiPadOSUpdate'
            }
            else {
                $policyName = $policy.Name
                $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/configuration'
            }

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $status = "✅ Atribuída"
            }
            else {
                $status = "❌ Não atribuída"
            }

            # Get assignment details for this specific policy
            $assignmentTarget = "Nenhum"

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }

            $tableRows += @"
| [$(Get-SafeMarkdown($policyName))]($portalLink) | $status | $assignmentTarget |`n
"@
        }

        # Format the template by replacing placeholders with values
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }
    else {
        $mdInfo = "Nenhuma política de atualização do iOS encontrada neste locatário.`n"
    }

    # Replace the placeholder with the detailed information
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '24554'
        Title  = 'Uma política de atualização do iOS está criada e atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
