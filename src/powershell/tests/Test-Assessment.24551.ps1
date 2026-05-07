<#
.SYNOPSIS
    A Política de Windows Hello para Empresas está configurada e atribuída
#>

function Test-Assessment-24551 {
    [ZtTest(
    	Category = 'Dispositivos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 24551,
    	Title = 'A autenticação no Windows utiliza o Windows Hello para Empresas',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    #region Data Collection
    $activity = "Verificando se a Política do Windows Hello para Empresas está Configurada e Atribuída"
    Write-ZtProgress -Activity $activity

    # Query 1: Retrieve assignment for Tenant wide Windows Hello for Business Configuration Policies
    $windowsHelloTenantConfig = Invoke-ZtGraphRequest -RelativeUri "deviceManagement/deviceEnrollmentConfigurations?`$filter=deviceEnrollmentConfigurationType eq 'windowsHelloForBusiness'" -ApiVersion beta

    # Query 2: Retrieve assignment for Windows Hello for Business related MDM Policies
    $sql = @"
    SELECT id, name, platforms, technologies, to_json(settings) as settings, to_json(assignments) as assignments
    FROM ConfigurationPolicy
    WHERE platforms LIKE '%windows10%'
      AND technologies LIKE '%mdm%'
"@
    $windowsMdmPolicies = Invoke-DatabaseQuery -Database $Database -Sql $sql -AsCustomObject

    # Parse JSON settings field
    foreach ($policy in $windowsMdmPolicies) {
        if ($policy.settings -is [string]) {
            $policy.settings = $policy.settings | ConvertFrom-Json
        }
        if ($policy.assignments -is [string]) {
            $policy.assignments = $policy.assignments | ConvertFrom-Json
        }
    }

    # filter to only Windows Hello for Business related policies
    $windowsHelloMdmPolicies = $windowsMdmPolicies.Where{
        $_.settings.settingInstance.groupSettingCollectionValue.children.SettingDefinitionId -contains 'device_vendor_msft_passportforwork_{tenantid}_policies_usepassportforwork' -or
        $_.settings.settingInstance.groupSettingCollectionValue.children.SettingDefinitionId -contains 'user_vendor_msft_passportforwork_{tenantid}_policies_usepassportforwork'
    }

    #endregion Data Collection

    #region Assessment Logic
    $passed = $windowsHelloTenantConfig.state -eq 'enabled' -or $windowsHelloMdmPolicies.Where{$_.Assignments.target.groupId}.count -ne 0

    if ($passed) {
        $testResultMarkdown = "Política do Windows Hello para Empresas está atribuída e aplicada.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "Política do Windows Hello para Empresas não está atribuída ou não está aplicada.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build the detailed sections of the markdown

    # Define variables to insert into the format string
    $reportTitle = "Política do Windows Hello para Empresas está Configurada e Atribuída"
    $tableRows = ""

    $formatTemplate = @'

## {0}

{2}

| Nome da Política | Status | Alvo da Atribuição |
| :--------------- | :----- | :----------------- |
{1}

'@

    if ($windowsHelloTenantConfig)
    {
        $tenantConfigState = if ($windowsHelloTenantConfig.state -eq 'enabled') {
            'Windows Hello para Empresas ([Tenant Wide Setting]({0}) ): ✅ Ativo.' -f 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesEnrollmentMenu/~/windowsEnrollment'
        }
        elseif ($windowsHelloTenantConfig.state -eq 'disabled') {
            'Windows Hello para Empresas ([Tenant Wide Setting]({0}) ): ❌ Desativado.' -f 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesEnrollmentMenu/~/windowsEnrollment'
        }
        else {
            'Windows Hello para Empresas ([Tenant Wide Setting]({0}) ): ❓ Não Configurado.' -f 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesEnrollmentMenu/~/windowsEnrollment'
        }
    }

    # Generate markdown table rows for each policy
    if ($windowsHelloMdmPolicies.Count -gt 0) {
        # Create a here-string with format placeholders {0}, {1}, etc.
        foreach ($policy in $windowsHelloMdmPolicies) {

            $policyName = Get-SafeMarkdown -Text $policy.name
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/configuration'

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $status = "✅ Atribuída"
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }
            else {
                $status = "❌ Não atribuída"
                $assignmentTarget = 'None'
            }

            $tableRows += "| [$policyName]($portalLink) | $status | $assignmentTarget |`n"
        }
    }

    # Format the template by replacing placeholders with values
    $mdInfo = $formatTemplate -f $reportTitle, $tableRows, $tenantConfigState

    # Replace the placeholder in the test result markdown with the generated details
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Report Generation

    $params = @{
        TestId             = '24551'
        Title              = "Política do Windows Hello para Empresas está Configurada e Atribuída"
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
