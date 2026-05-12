<#
.SYNOPSIS
    Internet Access security profiles are applied to users via Conditional Access policies.
#>

function Test-Assessment-25407 {
    [ZtTest(
    	Category = 'Global Secure Access',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Entra_Premium_Internet_Access'),
    	CompatibleLicense = ('Entra_Premium_Internet_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce','External'),
    	TestId = 25407,
    	Title = 'A filtragem de conteúdo web integra-se ao Conditional Access',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Iniciar avaliação de Conditional Access do GSA (perfis de segurança via CA)' -Tag Test -Level VeryVerbose

    # Q1: Retrieve all Conditional Access policies
    $policies = Get-ZtConditionalAccessPolicy

    # Q2: Retrieve all Global Secure Access filtering/security profiles
    $filteringProfiles = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/filteringProfiles' -ApiVersion beta

    # Process CA policies to find those with enabled GSA security profiles linked to enabled filtering profiles

    $gsaPolicies = $policies | Where-Object { ($_.state -eq 'enabled' )-and ($null -ne $_.sessionControls.globalSecureAccessFilteringProfile) }
    $gsaPolicyDetails = @()

    foreach ($policy in $gsaPolicies) {
        $profileId = $policy.sessionControls.globalSecureAccessFilteringProfile.profileId
        $caLinkageEnabled = $policy.sessionControls.globalSecureAccessFilteringProfile.isEnabled
        $matchedProfile = $filteringProfiles | Where-Object { $_.id -eq $profileId }
        $gsaPolicyDetails += [PSCustomObject]@{
            PolicyId          = $policy.id
            PolicyDisplayName = $policy.displayName
            PolicyState       = $policy.state
            ProfileId         = $profileId
            CALinkageEnabled  = $caLinkageEnabled
            ProfileName       = $matchedProfile.name
            ProfileState      = $matchedProfile.state
        }
    }
    $caPolicyWithGsaProfilesEnabled = $gsaPolicyDetails | Where-Object { $_.ProfileState -eq 'enabled' -and $_.CALinkageEnabled -eq $true }
    $caPolicyWithGsaProfilesDisabled = $gsaPolicyDetails | Where-Object { $_.ProfileState -ne 'enabled' -or $_.CALinkageEnabled -ne $true }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $caPolicyWithGsaProfilesEnabled.Count -ge 1
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''
    $testResultMarkdown = ''
    # Generate markdown table for policies with Global Secure Access filtering profiles
    if ($passed) {
        $testResultMarkdown = "✅ A política de acesso à Internet está sendo aplicada por meio do Conditional Access.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ A política de acesso à Internet não está sendo aplicada por meio do Conditional Access.`n`n%TestResult%"
        if ($gsaPolicyDetails) {
            $mdInfo = "`n## Políticas de Conditional Access com perfis de segurança do Global Secure Access`n`n"
            $mdInfo += "| Nome da política de CA | Estado da política de CA | ID do perfil de segurança | Vinculação de CA habilitada | Nome do perfil de segurança | Estado do perfil de segurança |`n"
            $mdInfo += "| :--- | :--- | :--- | :--- | :--- | :--- |`n"
            foreach ($item in $caPolicyWithGsaProfilesDisabled) {
                $policyPortalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/$($item.PolicyId)"
                $caStateIcon = '✅ Enabled'
                $linkageIcon = if ($item.CALinkageEnabled) {
                    '✅ Enabled'
                }
                else {
                    '❌ Disabled'
                }
                $profileStateIcon = if ($item.ProfileState -eq 'enabled') {
                    '✅ Enabled'
                }
                else {
                    '❌ Disabled'
                }
                $mdInfo += "| [$(Get-SafeMarkdown $item.PolicyDisplayName)]($policyPortalLink) | $caStateIcon | $($item.ProfileId) | $linkageIcon | $(Get-SafeMarkdown $item.ProfileName) | $profileStateIcon |`n"
            }
        }
    }

    #endregion Report Generation

    $params = @{
        TestId = '25407'
        Status = $passed
        Result = $testResultMarkdown -replace '%TestResult%', $mdInfo
    }

    Add-ZtTestResultDetail @params
}
