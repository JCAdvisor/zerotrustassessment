<#
.SYNOPSIS
    Aplicações de IA generativa corporativa são protegidas contra ataques de injeção de prompt por meio do AI Gateway.
.DESCRIPTION
    Verifica se o Prompt Shield (AI Gateway) está configurado corretamente para proteger contra ataques de injeção de prompt.
    O teste passa se políticas de prompt existem e são impostas através do Perfil de Linha de Base ou através de
    Perfis de Segurança atribuídos a políticas do Conditional Access.
#>

function Test-Assessment-25415 {
    [ZtTest(
    	Category = 'Acesso Seguro Global',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Entra_Premium_Internet_Access'),
    	CompatibleLicense = ('Entra_Premium_Internet_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 25415,
    	Title = 'O AI Gateway protege aplicativos de IA generativa empresariais contra ataques de injeção de prompt',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    # Define constants
    [int]$BASELINE_PROFILE_PRIORITY = 65000

    #region Data Collection
    Write-PSFMessage '🟦 Avaliação inicial do Prompt Shield' -Tag Test -Level VeryVerbose

    $activity = 'Verificando configuração do Prompt Shield para proteção do AI Gateway'
    Write-ZtProgress -Activity $activity -Status 'Consultando políticas de prompt'

    # Q1: Get prompt policies
    $promptPolicies = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/promptPolicies' -QueryParameters @{
        '$expand' = 'policyRules'
    } -ApiVersion beta

    # Q2: Get filtering profiles with linked policies and Conditional Access policies
    Write-ZtProgress -Activity $activity -Status 'Consultando perfis de segurança e políticas vinculadas'
    $filteringProfiles = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/filteringProfiles' -QueryParameters @{
        '$expand' = 'policies($expand=policy),conditionalAccessPolicies'
    } -ApiVersion beta

    # Get all Conditional Access policies
    Write-ZtProgress -Activity $activity -Status 'Consultando políticas do Conditional Access'
    $allCAPolicies = Get-ZtConditionalAccessPolicy

    #endregion Data Collection

    #region Assessment Logic
    $enabledSecurityProfiles = @()
    $enabledBaselineProfiles = @()
    $allPromptPolicyIds = @()

    # Collect all prompt policy IDs from Q1
    if ($promptPolicies) {
        $allPromptPolicyIds = $promptPolicies | ForEach-Object { $_.id }
    }

    # Find profiles linked to each prompt policy
    foreach ($promptPolicy in $promptPolicies) {
        $findParams = @{
            PolicyId          = $promptPolicy.id
            FilteringProfiles = $filteringProfiles
            CAPolicies        = $allCAPolicies
            BaselinePriority  = $BASELINE_PROFILE_PRIORITY
            PolicyLinkType    = 'promptPolicyLink'
            PolicyRules       = $promptPolicy.policyRules
        }

        $linkedProfiles = Find-ZtProfilesLinkedToPolicy @findParams

        foreach ($profileLink in $linkedProfiles) {
            if ($profileLink.ProfileType -eq 'Baseline Profile' -and $profileLink.PassesCriteria -and $profileLink.ProfileState -eq 'enabled') {
                $enabledBaselineProfiles += [PSCustomObject]@{
                    ProfileId            = $profileLink.ProfileId
                    ProfileName          = $profileLink.ProfileName
                    ProfileState         = $profileLink.ProfileState
                    ProfilePriority      = $profileLink.ProfilePriority
                    PromptPolicyId       = $promptPolicy.id
                    PromptPolicyName     = $promptPolicy.name
                    PromptPolicyAction   = $promptPolicy.action
                    RulesCount           = if ($promptPolicy.policyRules) { @($promptPolicy.policyRules).Count } else { 0 }
                    LastModified         = $promptPolicy.lastModifiedDateTime
                    PromptPolicyLinkState = $profileLink.PolicyLinkState
                }
            }
            elseif ($profileLink.ProfileType -eq 'Security Profile' -and $profileLink.PassesCriteria -and $profileLink.ProfileState -eq 'enabled') {
                $matchedCAPolicies = @()
                if ($null -ne $profileLink.CAPolicy) {
                    $matchedCAPolicies = @($profileLink.CAPolicy)
                }

                $enabledSecurityProfiles += [PSCustomObject]@{
                    ProfileId            = $profileLink.ProfileId
                    ProfileName          = $profileLink.ProfileName
                    ProfileState         = $profileLink.ProfileState
                    ProfilePriority      = $profileLink.ProfilePriority
                    PromptPolicyId       = $promptPolicy.id
                    PromptPolicyName     = $promptPolicy.name
                    PromptPolicyAction   = $promptPolicy.action
                    RulesCount           = if ($promptPolicy.policyRules) { @($promptPolicy.policyRules).Count } else { 0 }
                    LastModified         = $promptPolicy.lastModifiedDateTime
                    PromptPolicyLinkState = $profileLink.PolicyLinkState
                    MatchedCAPolicies    = $matchedCAPolicies
                    CAPolicyCount        = $matchedCAPolicies.Count
                }
            }
        }
    }
    $testResultMarkdown = ''
    $passed = $false
    $mdInfo = ''

    # Evaluation logic per spec
    if ($null -eq $promptPolicies -or $promptPolicies.Count -eq 0) {
        # No prompt policies configured
        $testResultMarkdown = "❌ O Prompt Shield não está configurado adequadamente - nenhuma política de prompt existe.`n`n%TestResult%"
        $passed = $false
    }
    elseif ($enabledBaselineProfiles.Count -gt 0) {
        # Condition B: Baseline Profile has prompt policies (applies to all traffic)
        $testResultMarkdown = "✅ As políticas do Prompt Shield estão configuradas e aplicadas por meio do Perfil de Linha de Base, que se aplica a todo o tráfego de internet.`n`n%TestResult%"
        $passed = $true
    }
    elseif ($enabledSecurityProfiles.Count -gt 0) {
        # Condition A: Security profiles with prompt policies AND CA policy assignment
        $testResultMarkdown = "✅ As políticas do Prompt Shield estão configuradas e aplicadas por meio de perfis de segurança atribuídos a políticas do Conditional Access.`n`n%TestResult%"
        $passed = $true
    }
    else {
        # Prompt policies exist but are not enforced
        $testResultMarkdown = "❌ O Prompt Shield não está configurado adequadamente - as políticas não estão vinculadas a perfis de segurança, ou os perfis de segurança com políticas de prompt não são impostos (nenhuma atribuição de política de CA e não usando Perfil de Linha de Base).`n`n%TestResult%"
        $passed = $false
    }

    #endregion Assessment Logic

    #region Report Generation

    if ($passed) {
        # Build detailed report only when test passes
        $formatTemplate = @'

## Políticas de Prompt (AI Gateway)

| Policy Name | Action | Rules Count | Last Modified |
| :---------- | :----- | :---------- | :------------ |
{0}
{1}
{2}
'@

        # Table 1: Prompt Policies
        $promptPoliciesRows = ''
        if ($promptPolicies -and $promptPolicies.Count -gt 0) {
            foreach ($policy in $promptPolicies) {
                $policyPortalLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditPromptPolicyMenuBlade.MenuView/~/basics/policyId/$($policy.id)"
                $policyName = Get-SafeMarkdown -Text $policy.name
                $action = if ($policy.action) { $policy.action } else { 'Not specified' }
                $rulesCount = if ($policy.policyRules) { @($policy.policyRules).Count } else { 0 }
                $lastModified = if ($policy.lastModifiedDateTime) { $policy.lastModifiedDateTime } else { 'N/A' }
                $promptPoliciesRows += "| [$policyName]($policyPortalLink) | $action | $rulesCount | $lastModified |`n"
            }
        }

        # Table 2: Baseline Profiles with Prompt Policies
        $baselineProfilesSection = ''
        if ($enabledBaselineProfiles.Count -gt 0) {
            $baselineProfilesSection += "`n## Políticas de Prompt Vinculadas ao Perfil de Linha de Base`n`n"
            $baselineProfilesSection += "| Profile Name | Priority | State | Prompt Policy | Policy Link State | Rules Count |`n"
            $baselineProfilesSection += "| :----------- | :------- | :---- | :------------ | :---------------- | :---------- |`n"
            foreach ($profile in $enabledBaselineProfiles) {
                $profilePortalLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditProfileMenuBlade.MenuView/~/basics/profileId/$($profile.ProfileId)"
                $policyPortalLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditPromptPolicyMenuBlade.MenuView/~/basics/policyId/$($profile.PromptPolicyId)"
                $profileName = Get-SafeMarkdown -Text $profile.ProfileName
                $policyName = Get-SafeMarkdown -Text $profile.PromptPolicyName
                $baselineProfilesSection += "| [$profileName]($profilePortalLink) | $($profile.ProfilePriority) | $($profile.ProfileState) | [$policyName]($policyPortalLink) | $($profile.PromptPolicyLinkState) | $($profile.RulesCount) |`n"
            }
        }

        # Table 3: Security Profiles with Prompt Policies and CA Assignments
        $securityProfilesSection = ''
        if ($enabledSecurityProfiles.Count -gt 0) {
            $securityProfilesSection += "`n## Perfis de Segurança com Políticas Vinculadas`n`n"
            $securityProfilesSection += "| Profile Name | State | Priority | Prompt Policy | CA Policies Assigned | Is Baseline |`n"
            $securityProfilesSection += "| :----------- | :---- | :------- | :------------ | :------------------- | :---------- |`n"
            foreach ($profile in $enabledSecurityProfiles) {
                $profilePortalLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditProfileMenuBlade.MenuView/~/basics/profileId/$($profile.ProfileId)"
                $policyPortalLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditPromptPolicyMenuBlade.MenuView/~/basics/policyId/$($profile.PromptPolicyId)"
                $profileName = Get-SafeMarkdown -Text $profile.ProfileName
                $policyName = Get-SafeMarkdown -Text $profile.PromptPolicyName
                $isBaseline = if ($profile.ProfilePriority -eq $BASELINE_PROFILE_PRIORITY) { 'Yes' } else { 'No' }
                $caCount = $profile.CAPolicyCount
                $securityProfilesSection += "| [$profileName]($profilePortalLink) | $($profile.ProfileState) | $($profile.ProfilePriority) | [$policyName]($policyPortalLink) | $caCount | $isBaseline |`n"
            }

            # Table 4: Conditional Access Policies
            $securityProfilesSection += "`n## Políticas do Conditional Access Atribuídas a Perfis de Segurança`n`n"
            $securityProfilesSection += "| CA Policy Name | Security Profile | CA Policy ID |`n"
            $securityProfilesSection += "| :------------- | :--------------- | :----------- |`n"
            foreach ($profile in $enabledSecurityProfiles) {
                foreach ($caPolicy in $profile.MatchedCAPolicies) {
                    $caPolicyPortalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/$($caPolicy.Id)"
                    $profileName = Get-SafeMarkdown -Text $profile.ProfileName
                    $caPolicyName = Get-SafeMarkdown -Text $caPolicy.DisplayName
                    $securityProfilesSection += "| [$caPolicyName]($caPolicyPortalLink) | $profileName | $($caPolicy.Id) |`n"
                }
            }
        }

        $mdInfo = $formatTemplate -f $promptPoliciesRows, $baselineProfilesSection, $securityProfilesSection
    }
    else {
        # For failed states, just show the portal link
        $mdInfo = "[View Prompt Shield Configuration](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/PromptPolicy.ReactView)`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo

    #endregion Report Generation

    $params = @{
        TestId = '25415'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
