<#
.SYNOPSIS
    A inspeção de TLS está ativada e configurada corretamente para tráfego de saída no Global Secure Access.
.DESCRIPTION
    Verifica se uma política de Inspeção de TLS está adequadamente configurada. Falhará se nenhuma política de Inspeção de TLS existir, se a política não estiver vinculada a um Perfil de Segurança ou se nenhuma política do Conditional Access atribuindo esse Perfil de Segurança puder ser identificada.
#>

function Test-Assessment-25411 {
    [ZtTest(
    	Category = 'Acesso Seguro Global',
    	ImplementationCost = 'Alto',
    	MinimumLicense = ('Entra_Premium_Internet_Access'),
    	CompatibleLicense = ('Entra_Premium_Internet_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 25411,
    	Title = 'A inspeção TLS está habilitada e corretamente configurada para tráfego de saída',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    # Define constants
    [int]$BASELINE_PROFILE_PRIORITY = 65000

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'A inspeção de TLS está ativada e configurada corretamente para tráfego de saída no Global Secure Access.'
    Write-ZtProgress -Activity $activity -Status 'Consultando políticas de inspeção de TLS'

    # Step 1: Get TLS Inspection policies
    $tlsInspectionPolicies = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/tlsInspectionPolicies' -ApiVersion beta

    # Step 2: List all policies in the Baseline Profile and in each Security Profile
    Write-ZtProgress -Activity $activity -Status 'Consultando perfis de filtragem e políticas'
    $filteringProfiles = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/filteringProfiles' -QueryParameters @{
        '$select' = 'id,name,description,state,version,priority'
        '$expand' = 'policies($select=id,state;$expand=policy($select=id,name,version)),conditionalAccessPolicies($select=id,displayName)'
    } -ApiVersion beta

        # Consulta all Conditional Access policies with details
    Write-ZtProgress -Activity $activity -Status 'Consultando políticas do Conditional Access'
    $allCAPolicies = Get-ZtConditionalAccessPolicy

    #endregion Data Collection

    #region Data Processing
    # Graph responses are automatically unwrapped by Invoke-ZtGraphRequest
    $enabledSecurityProfiles = @()
    $enabledBaseLineProfiles = @()

    # Iterate each TLS inspection policy and find linked profiles using the helper function
    foreach ($tlsPolicy in $tlsInspectionPolicies) {
        $findParams = @{
            PolicyId          = $tlsPolicy.id
            FilteringProfiles = $filteringProfiles
            CAPolicies        = $allCAPolicies
            BaselinePriority  = $BASELINE_PROFILE_PRIORITY
            PolicyLinkType    = 'tlsInspectionPolicyLink'
            PolicyRules       = $tlsPolicy
        }

        $linkedProfiles = Find-ZtProfilesLinkedToPolicy @findParams

        foreach ($policyProfile in $linkedProfiles) {
            if ($policyProfile.ProfileType -eq 'Baseline Profile' -and $policyProfile.PassesCriteria -and $policyProfile.ProfileState -eq 'enabled') {
                $enabledBaseLineProfiles += [PSCustomObject]@{
                    ProfileId          = $policyProfile.ProfileId
                    ProfileName        = $policyProfile.ProfileName
                    ProfileState       = $policyProfile.ProfileState
                    ProfilePriority    = $policyProfile.ProfilePriority
                    TLSPolicyId        = $tlsPolicy.id
                    TLSPolicyName      = $tlsPolicy.name
                    TLSPolicyLinkState = $policyProfile.PolicyLinkState
                }
            }
            elseif ($policyProfile.ProfileType -eq 'Security Profile' -and $policyProfile.PassesCriteria -and $policyProfile.ProfileState -eq 'enabled') {
                $matchedCAPolicies = @()
                if ($null -ne $policyProfile.CAPolicy) {
                    $matchedCAPolicies = @($policyProfile.CAPolicy)
                }

                $enabledSecurityProfiles += [PSCustomObject]@{
                    ProfileId          = $policyProfile.ProfileId
                    ProfileName        = $policyProfile.ProfileName
                    ProfileState       = $policyProfile.ProfileState
                    ProfilePriority    = $policyProfile.ProfilePriority
                    TLSPolicyId        = $tlsPolicy.id
                    TLSPolicyName      = $tlsPolicy.name
                    TLSPolicyLinkState = $policyProfile.PolicyLinkState
                    MatchedCAPolicies  = $matchedCAPolicies
                    CAPolicyCount      = $matchedCAPolicies.Count
                    DefaultAction      = if ($null -ne $tlsPolicy.settings) {
                        $tlsPolicy.settings.defaultAction
                    }
                    else {
                        'unknown'
                    }
                }
            }
        }
    }

    #endregion Data Processing
    #region Assessment logic

    $testResultMarkdown = ''
    $passed = $false
    $mdInfo = ''

    if ($null -eq $tlsInspectionPolicies -or $tlsInspectionPolicies.Count -eq 0) {
        $testResultMarkdown = "❌ A política de Inspeção TLS não foi configurada corretamente.`n`n%TestResult%"
        $passed = $false
    }
    elseif ($enabledBaseLineProfiles.Count -gt 0) {
        $testResultMarkdown = "✅ A política de Inspeção TLS está habilitada e corretamente configurada para inspecionar o tráfego de saída criptografado.`n`n%TestResult%"
        $passed = $true
    }
    elseif ($enabledSecurityProfiles.Count -gt 0) {
        $testResultMarkdown = "✅ A política de Inspeção TLS está habilitada e corretamente configurada para inspecionar o tráfego de saída criptografado.`n`n%TestResult%"
        $passed = $true
    }
    else {
        $testResultMarkdown = "❌ A política de Inspeção TLS não foi configurada corretamente.`n`n%TestResult%"
        $passed = $false
    }

    #endregion Assessment logic

    #region Report Generation

    if ($enabledBaseLineProfiles.Count -gt 0) {

        $mdInfo += "`n## Políticas de Inspeção TLS Vinculadas a Perfis de Linha de Base`n`n"
        $mdInfo += "| Nome do perfil vinculado | Prioridade do perfil | Nome da política vinculada | Estado da política | Estado do perfil |`n"
        $mdInfo += "| :--- | :--- | :--- | :--- | :--- |`n"
        foreach ($policy in $enabledBaseLineProfiles) {
            $baseLineProfilePortalLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditProfileMenuBlade.MenuView/~/basics/profileId/$(($policy.ProfileId))"
            $tlsPolicyPortalLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditTlsInspectionPolicyMenuBlade.MenuView/~/basics/policyId/$(($policy.TLSPolicyId))"
            $profileName = Get-SafeMarkdown -Text $policy.ProfileName
            $profilePriority = $policy.ProfilePriority
            $tlsPolicyName = Get-SafeMarkdown -Text $policy.TLSPolicyName
            $tlsPolicyLinkState = $policy.TLSPolicyLinkState
            $profileState = $policy.ProfileState
            $mdInfo += "| [$profileName]($baseLineProfilePortalLink) | $profilePriority | [$tlsPolicyName]($tlsPolicyPortalLink) | $tlsPolicyLinkState | $profileState |`n"
        }
    }

    if ($enabledSecurityProfiles.Count -gt 0) {
        $mdInfo += "`n## Perfis de Segurança Vinculados a Políticas de Acesso Condicional`n`n"
        $mdInfo += "| Nome do perfil vinculado | Prioridade do perfil | Nomes de políticas de CA | Estado da política de CA | Estado do perfil | Nome da política de Inspeção TLS | Ação padrão |`n"
        $mdInfo += "| :--- | :--- | :--- | :--- | :--- | :--- | :--- |`n"
        foreach ($enabledProfile in $enabledSecurityProfiles) {
            $securityProfilePortalLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditProfileMenuBlade.MenuView/~/basics/profileId/$(($enabledProfile.ProfileId))"
            $tlsPolicyPortalLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditTlsInspectionPolicyMenuBlade.MenuView/~/basics/policyId/$(($enabledProfile.TLSPolicyId))"
            $profileName = Get-SafeMarkdown -Text $enabledProfile.ProfileName
            $profilePriority = $enabledProfile.ProfilePriority
            # Build CA policy links
            $caPolicyLinksMarkdown = @()
            $caPolicyStatesList = @()
            foreach ($caPolicy in $enabledProfile.MatchedCAPolicies) {
                $caPolicyPortalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/$($caPolicy.Id)"
                $safeName = Get-SafeMarkdown -Text $caPolicy.DisplayName
                $caPolicyLinksMarkdown += "[$safeName]($caPolicyPortalLink)"
                $caPolicyStatesList += $caPolicy.State
            }
            $caPolicyNamesLinked = $caPolicyLinksMarkdown -join ', '
            $caPolicyStates = $caPolicyStatesList -join ', '
            $profileState = $enabledProfile.ProfileState
            $tlsPolicyName = Get-SafeMarkdown -Text $enabledProfile.TLSPolicyName
            $defaultAction = $enabledProfile.DefaultAction
            $mdInfo += "| [$profileName]($securityProfilePortalLink) | $profilePriority | $caPolicyNamesLinked | $caPolicyStates | $profileState | [$tlsPolicyName]($tlsPolicyPortalLink) | $defaultAction |`n"
        }
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation


    $params = @{
        TestId = '25411'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
