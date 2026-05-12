<#
.SYNOPSIS
    Verifica se a filtragem de conteúdo da web do Global Secure Access está ativada e configurada
.DESCRIPTION
    Verifica se as políticas de Filtragem de Conteúdo da Web estão configuradas e aplicadas por meio do Perfil de Linha de Base
    ou por meio de Perfis de Segurança vinculados a políticas ativas do Conditional Access. Isso garante que as organizações
    controlem o acesso aos sites com base em categorias, domínios ou URLs para reduzir a exposição a conteúdo malicioso ou
    inadequado.

.NOTES
    Test ID: 25408
    Category: Global Secure Access
    Required API: networkAccess/filteringPolicies, networkAccess/filteringProfiles, conditionalAccess/policies
#>

function Test-Assessment-25408 {
    [ZtTest(
    	Category = 'Global Secure Access',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Entra_Premium_Internet_Access'),
    	CompatibleLicense = ('Entra_Premium_Internet_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce','External'),
    	TestId = 25408,
    	Title = 'As políticas de filtragem de conteúdo web estão configuradas',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    # Define constants
    [int]$BASELINE_PROFILE_PRIORITY = 65000

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando a configuração de filtragem de conteúdo web do Global Secure Access'
    Write-ZtProgress -Activity $activity -Status 'Consultando políticas de filtragem de conteúdo web'

    # Q1: Get all Web Content Filtering policies (excluding "All Websites")
    $allFilteringPolicies = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/filteringPolicies' -ApiVersion beta
    $wcfPolicies = $allFilteringPolicies | Where-Object { $_.name -ne 'All websites' }

    Write-ZtProgress -Activity $activity -Status 'Consultando perfis de filtragem'

    # Q2: Get all filtering profiles with their policies and priority
    $filteringProfilesQueryParams = @{
        '$select' = 'id,name,description,state,version,priority'
        '$expand' = 'policies($select=id,state;$expand=policy($select=id,name,version))'
    }
    $filteringProfiles = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/filteringProfiles' -QueryParameters $filteringProfilesQueryParams -ApiVersion beta

    Write-ZtProgress -Activity $activity -Status 'Consultando políticas do Conditional Access'

    # Q3: Get all enabled Conditional Access policies with session controls
    $allCAPolicies = Get-ZtConditionalAccessPolicy
    $enabledCAPolicies = $allCAPolicies | Where-Object { $_.state -eq 'enabled' }
    #endregion Data Collection

    #region Assessment Logic
    # Initialize test variables
    $testResultMarkdown = ''
    $passed = $false
    $appliedPolicies = @()

    # Check if any Web Content Filtering policies exist (excluding "All Websites")
    if (-not $wcfPolicies -or $wcfPolicies.Count -eq 0) {
        $testResultMarkdown = '❌ A política de filtragem de conteúdo web não está configurada.'
        $passed = $false
    }
    else {
        # Check if WCF policies are linked to profiles using shared helper
        foreach ($wcfPolicy in $wcfPolicies) {
            $policyId = $wcfPolicy.id
            $policyName = $wcfPolicy.name
            $policyAction = $wcfPolicy.action

            # Use shared helper function to find profiles linked to this policy
            $findParams = @{
                PolicyId          = $policyId
                FilteringProfiles = $filteringProfiles
                CAPolicies        = $enabledCAPolicies
                BaselinePriority  = $BASELINE_PROFILE_PRIORITY
                PolicyLinkType    = 'filteringPolicyLink'
                PolicyRules       = @()
            }
            $linkedProfiles = Find-ZtProfilesLinkedToPolicy @findParams

            # Filter for enabled profiles and policy links, then check pass criteria
            $appliedProfiles = $linkedProfiles | Where-Object {
                $_.PolicyLinkState -eq 'enabled' -and
                $_.ProfileState -eq 'enabled' -and
                $_.PassesCriteria -eq $true
            }

            # If this policy is applied through at least one profile, add it to applied policies
            if ($appliedProfiles) {
                # Convert to format expected by report generation
                $formattedProfiles = @()
                foreach ($profileInfo in $appliedProfiles) {
                    $formattedProfiles += [PSCustomObject]@{
                        ProfileId       = $profileInfo.ProfileId
                        ProfileName     = $profileInfo.ProfileName
                        ProfileType     = $profileInfo.ProfileType
                        ProfileState    = $profileInfo.ProfileState
                        ProfilePriority = $profileInfo.ProfilePriority
                        PolicyLinkState = $profileInfo.PolicyLinkState
                        IsApplied       = $true
                        CAPolicy        = $profileInfo.CAPolicy
                    }
                }

                $appliedPolicies += [PSCustomObject]@{
                    PolicyId       = $policyId
                    PolicyName     = $policyName
                    PolicyAction   = $policyAction
                    LinkedProfiles = $formattedProfiles
                }
            }
        }

        # Determine pass/fail
        if ($appliedPolicies.Count -gt 0) {
            $passed = $true
            \$testResultMarkdown = "✅ A política de filtragem de conteúdo web está habilitada. `n`n%TestResult%"
        }
        else {
            $passed = $false
            \$testResultMarkdown = "❌ A política de filtragem de conteúdo web não está aplicada aos usuários. `n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build detailed markdown information
    $mdInfo = ''

    if ($wcfPolicies -and $wcfPolicies.Count -gt 0) {
        # Check if there are any applied policies to determine table structure
        if ($appliedPolicies.Count -gt 0) {
            # Add table title for applied policies
            $mdInfo += "### Políticas de filtragem de conteúdo web aplicadas`n`n"

            # table for applied policies
            $mdInfo += "| Nome do perfil vinculado | Prioridade do perfil vinculado | Nome da política vinculada | Estado da política | Estado do perfil | Ação da política | Nome da política de CA | Estado da política de CA |`n"
            $mdInfo += "|---------------------|-------------------------|--------------------|--------------|---------------|---------------|----------------|-----------------|`n"

            foreach ($wcfPolicy in $wcfPolicies | Sort-Object -Property name) {
                $safePolicyName = Get-SafeMarkdown $wcfPolicy.name
                $policyAction = $wcfPolicy.action
                $appliedPolicy = $appliedPolicies | Where-Object { $_.PolicyId -eq $wcfPolicy.id }

                if ($appliedPolicy) {
                    # Get applied profiles for this policy
                    $appliedProfiles = $appliedPolicy.LinkedProfiles | Where-Object { $_.IsApplied -eq $true }

                    foreach ($profileInfo in $appliedProfiles) {
                        $safeProfileName = Get-SafeMarkdown $profileInfo.ProfileName
                        $profilePriority = $profileInfo.ProfilePriority
                        $profileState = $profileInfo.ProfileState
                        $policyLinkState = $profileInfo.PolicyLinkState

                        # Create blade links
                        $profileBladeLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditProfileMenuBlade.MenuView/~/basics/profileId/$($profileInfo.ProfileId)"
                        $profileNameWithLink = "[$safeProfileName]($profileBladeLink)"

                        $policyBladeLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/WebFilteringPolicy.ReactView"
                        $policyNameWithLink = "[$safePolicyName]($policyBladeLink)"

                        # If there are CA policies, create a row for each one
                        if ($profileInfo.CAPolicy -and $profileInfo.CAPolicy.Count -gt 0) {
                            foreach ($caPolicy in $profileInfo.CAPolicy) {
                                $caPolicyPortalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/$($caPolicy.id)"
                                $safeCAPolicyName = Get-SafeMarkdown $caPolicy.displayName
                                $caPolicyNameWithLink = "[$safeCAPolicyName]($caPolicyPortalLink)"
                                $caPolicyState = $caPolicy.state

                                $mdInfo += "| $profileNameWithLink | $profilePriority | $policyNameWithLink | $policyLinkState | $profileState | $policyAction | $caPolicyNameWithLink | $caPolicyState |`n"
                            }
                        }
                        else {
                            # Baseline profile or profile without CA policy
                            $mdInfo += "| $profileNameWithLink | $profilePriority | $policyNameWithLink | $policyLinkState | $profileState | $policyAction | Não aplicável | Não aplicável |`n"
                        }
                    }
                }
            }
        }
        else {
            # Add table title with blade link for unapplied policies
            $mdInfo += "### [Web content filtering policies](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/WebFilteringPolicy.ReactView)`n`n"

            # table for unapplied policies
            $mdInfo += "As seguintes políticas de filtragem de conteúdo web estão configuradas, mas não são aplicadas aos usuários.`n`n"
            $mdInfo += "| Nome da política | Ação da política |`n"
            $mdInfo += "|-------------|---------------|`n"

            foreach ($wcfPolicy in $wcfPolicies | Sort-Object -Property name) {
                $safePolicyName = Get-SafeMarkdown $wcfPolicy.name
                $policyAction = $wcfPolicy.action
                $mdInfo += "| $safePolicyName | $policyAction |`n"
            }
        }
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25408'
        Title  = 'A filtragem de conteúdo web do Global Secure Access está habilitada e configurada'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
