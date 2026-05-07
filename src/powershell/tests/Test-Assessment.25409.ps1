<#
.SYNOPSIS
    Valida que as políticas de filtragem de conteúdo web baseadas em categorias de sites estão configuradas no Global Secure Access.

.DESCRIPTION
    Este teste verifica se as políticas de filtragem de conteúdo web usando categorias de sites (tipo de regra webCategory) estão configuradas
    e aplicadas através do Perfil de Linha de Base ou através de perfis de segurança vinculados a políticas de Acesso Condicional ativas.

.NOTES
    Test ID: 25409
    Category: Global Secure Access
    Required API: networkAccess/filteringProfiles, networkAccess/filteringPolicies, conditionalAccess/policies (beta)
#>

function Test-Assessment-25409 {
    [ZtTest(
        Category = 'Acesso Seguro Global',
        ImplementationCost = 'Médio',
        MinimumLicense = ('Entra_Premium_Internet_Access'),
        CompatibleLicense = ('Entra_Premium_Internet_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce','External'),
        TestId = 25409,
        Title = 'O filtro de conteúdo web usa regras baseadas em categorias',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    # Define constants
    [int]$BASELINE_PROFILE_PRIORITY = 65000

    #region Data Collection
    Write-PSFMessage 'ƒƒª Start' -Tag Test -Level VeryVerbose
    $activity = 'Verificando filtragem de conteúdo web do Global Secure Access por categorias de sites'
    Write-ZtProgress -Activity $activity -Status 'Consultando políticas de Filtragem de Conteúdo Web'

    # Q1: Get all Web Content Filtering policies (excluding "All Websites")
    try {
        $allFilteringPolicies = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/filteringPolicies' -ApiVersion beta -ErrorAction Stop
        $wcfPolicies = $allFilteringPolicies | Where-Object { $_.name -ne 'All websites' }
    }
    catch {
        Write-PSFMessage "Falha ao recuperar políticas de filtragem: $_" -Tag Test -Level Warning
        $wcfPolicies = @()
    }

    Write-ZtProgress -Activity $activity -Status 'Consultando perfis de filtragem'

    # Q2: Get all filtering profiles with their policies and priority
    try {
        $filteringProfilesQueryParams = @{
            '$select' = 'id,name,description,state,version,priority'
            '$expand' = 'policies($select=id,state;$expand=policy($select=id,name,version))'
        }
        $filteringProfiles = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/filteringProfiles' -QueryParameters $filteringProfilesQueryParams -ApiVersion beta -ErrorAction Stop
    }
    catch {
        Write-PSFMessage "Falha ao recuperar perfis de filtragem: $_" -Tag Test -Level Warning
        $filteringProfiles = @()
    }

    Write-ZtProgress -Activity $activity -Status 'Consultando políticas de Acesso Condicional'

    # Q3 prep: Get all Conditional Access policies with session controls
    $caPolicies = Get-ZtConditionalAccessPolicy
    #endregion Data Collection

    #region Assessment Logic
    # Initialize test variables
    $testResultMarkdown = ''
    $passed = $false
    $policiesWithWebCategory = @()

    # Check if any Web Content Filtering policies exist (excluding "All Websites")
    if (-not $wcfPolicies -or $wcfPolicies.Count -eq 0) {
        $testResultMarkdown = '❌ Política de Filtragem de Conteúdo Web não está configurada.'
        $passed = $false
    }
    else {
        # Per spec: Check if webCategory policies exist in Baseline Profile or Security Profiles with enabled CA
        foreach ($wcfPolicy in $wcfPolicies) {
            $policyId = $wcfPolicy.id
            $policyName = $wcfPolicy.name

            # Get full policy details with rules to check for webCategory
            $policyDetails = Invoke-ZtGraphRequest -RelativeUri "networkAccess/filteringPolicies/$policyId`?`$select=id,name,version&`$expand=policyRules" -ApiVersion beta
            $webCategoryRules = @($policyDetails.policyRules) | Where-Object { $_.ruleType -eq 'webCategory' }

            # Skip if no webCategory rules
            if (-not $webCategoryRules) {
                continue
            }

            # Find profiles that have this policy linked using shared helper function
            $findParams = @{
                PolicyId          = $policyId
                FilteringProfiles = $filteringProfiles
                CAPolicies        = $caPolicies
                BaselinePriority  = $BASELINE_PROFILE_PRIORITY
                PolicyLinkType    = 'filteringPolicyLink'
                PolicyRules       = $webCategoryRules
            }
            $linkedProfiles = Find-ZtProfilesLinkedToPolicy @findParams

            # Check if any linked profile passes criteria
            $profilePasses = $linkedProfiles | Where-Object { $_.PassesCriteria -eq $true }
            if ($profilePasses) {
                $passed = $true
            }

            # Add policy with its linked profiles to collection
            if ($linkedProfiles.Count -gt 0) {
                $policiesWithWebCategory += [PSCustomObject]@{
                    PolicyId         = $policyId
                    PolicyName       = $policyName
                    LinkedProfiles   = $linkedProfiles
                }
            }
        }

        # Determine status message based on pass/fail
        if ($passed) {
            $testResultMarkdown = "✅ Filtragem de conteúdo web com controles de categoria de site está configurada e aplicada através do Perfil de Linha de Base ou de um perfil de segurança vinculado a uma política de Acesso Condicional ativa. `n`n%TestResult%"
        }
        else {
            $testResultMarkdown = "❌ Nenhuma política usando filtragem por categoria de site foi encontrada no Perfil de Linha de Base ou em perfis de segurança vinculados a políticas de Acesso Condicional ativas. `n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build detailed markdown information
    $mdInfo = ''

    if ($policiesWithWebCategory.Count -gt 0) {
        # Table 1: Filtering Policies with Web Category Rules
        $mdInfo += "`n## Políticas de Filtragem com Regras de Categoria de Site`n`n"
        $mdInfo += "| Tipo de Perfil | Nome do Perfil | Nome da Política | Nome da Regra | Categorias de Web | Estado |`n"
        $mdInfo += "| :--- | :--- | :--- | :--- | :--- | :--- |`n"

        foreach ($wcfPolicy in $policiesWithWebCategory | Sort-Object -Property PolicyName) {
            $safePolicyName = Get-SafeMarkdown $wcfPolicy.PolicyName

            foreach ($profileInfo in $wcfPolicy.LinkedProfiles) {
                $safeProfileName = Get-SafeMarkdown $profileInfo.ProfileName
                $policyLinkState = $profileInfo.PolicyLinkState

                # Create blade links
                $profileBladeLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditProfileMenuBlade.MenuView/~/basics/profileId/$($profileInfo.ProfileId)"
                $profileNameWithLink = "[$safeProfileName]($profileBladeLink)"

                $encodedPolicyName = [System.Uri]::EscapeDataString($wcfPolicy.PolicyName)
                $policyBladeLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditFilteringPolicyMenuBlade.MenuView/~/Basics/policyId/$($wcfPolicy.PolicyId)/title/$encodedPolicyName/defaultMenuItemId/Basics"
                $policyNameWithLink = "[$safePolicyName]($policyBladeLink)"

                # Process each webCategory rule
                foreach ($rule in $profileInfo.PolicyRules) {
                    $safeRuleName = Get-SafeMarkdown $rule.name
                    $webCategories = ($rule.destinations | ForEach-Object { $_.displayName }) -join ', '
                    $safeWebCategories = Get-SafeMarkdown $webCategories

                    # Show state with indicator
                    $stateDisplay = if ($policyLinkState -eq 'enabled') { '✅ Habilitado' } else { '❌ Desabilitado' }

                    $mdInfo += "| $($profileInfo.ProfileType) | $profileNameWithLink | $policyNameWithLink | $safeRuleName | $safeWebCategories | $stateDisplay |`n"
                }
            }
        }

        # Table 2: Conditional Access Linkages (for Security Profiles only)
        $securityProfiles = $policiesWithWebCategory.LinkedProfiles | Where-Object { $_.ProfileType -eq 'Security Profile' -and $null -ne $_.CAPolicy }
        if ($securityProfiles.Count -gt 0) {
            $mdInfo += "`n## Vinculações de Acesso Condicional (apenas para Perfis de Segurança)`n`n"
            $mdInfo += "| Nome da Política CA | Nome do Perfil de Segurança | Estado da Política CA |`n"
            $mdInfo += "| :--- | :--- | :--- |`n"

            # Build unique CA linkages
            $uniqueCALinks = @{}
            foreach ($policy in $policiesWithWebCategory) {
                foreach ($profileInfo in $policy.LinkedProfiles) {
                    if ($profileInfo.ProfileType -eq 'Security Profile' -and $null -ne $profileInfo.CAPolicy -and $profileInfo.CAPolicy.Count -gt 0) {
                        foreach ($caPolicy in $profileInfo.CAPolicy) {
                            $key = "$($profileInfo.ProfileId)|$($caPolicy.id)"
                            if (-not $uniqueCALinks.ContainsKey($key)) {
                                $uniqueCALinks[$key] = [PSCustomObject]@{
                                    ProfileName   = $profileInfo.ProfileName
                                    ProfileId     = $profileInfo.ProfileId
                                    CAPolicyName  = $caPolicy.displayName
                                    CAPolicyId    = $caPolicy.id
                                    CAPolicyState = $caPolicy.state
                                }
                            }
                        }
                    }
                }
            }

            foreach ($item in $uniqueCALinks.Values | Sort-Object CAPolicyName, ProfileName) {
                $safeProfileName = Get-SafeMarkdown $item.ProfileName
                $safeCAPolicyName = Get-SafeMarkdown $item.CAPolicyName

                $caPolicyPortalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/$($item.CAPolicyId)"
                $caPolicyNameWithLink = "[$safeCAPolicyName]($caPolicyPortalLink)"

                $profilePortalLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditProfileMenuBlade.MenuView/~/basics/profileId/$($item.ProfileId)"
                $profileNameWithLink = "[$safeProfileName]($profilePortalLink)"

                # Show actual state with indicator
                $caPolicyState = if ($item.CAPolicyState -eq 'enabled') { '✅ Habilitado' } else { '❌ Desabilitado' }

                $mdInfo += "| $caPolicyNameWithLink | $profileNameWithLink | $caPolicyState |`n"
            }
        }

        # Add portal links at the end
        $mdInfo += "`n### Links do Portal`n`n"
        $mdInfo += "- [Políticas de filtragem de conteúdo web](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/WebFilteringPolicy.ReactView)`n"
        $mdInfo += "- [Perfis de segurança](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/FilteringPolicyProfiles.ReactView)`n"
    }

    # Replace the placeholder with detailed information
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25409'
        Title  = 'Filtragem de conteúdo web com categorias de sites configurada'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
