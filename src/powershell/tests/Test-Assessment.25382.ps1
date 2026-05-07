<#
.SYNOPSIS
    Validates that traffic forwarding profiles are scoped to appropriate users and groups for controlled deployment.

.DESCRIPTION
    This test checks if enabled traffic forwarding profiles for Microsoft 365, Private Access,
    and Internet Access have proper user/group assignments to ensure controlled rollout
    and prevent security gaps.

.NOTES
    Test ID: 25382
    Category: Global Secure Access
    Required API: networkAccess/forwardingProfiles (beta), servicePrincipals (v1.0)
#>

function Test-Assessment-25382 {
    [ZtTest(
        Category = 'Acesso Seguro Global',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Entra_Premium_Private_Access', 'Entra_Premium_Internet_Access'),
        CompatibleLicense = ('Entra_Premium_Internet_Access','Entra_Premium_Private_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 25382,
        Title = 'Perfis de encaminhamento de tráfego são direcionados a usuários e grupos apropriados para implantação controlada',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando a configuração de perfis de encaminhamento de tráfego'
    Write-ZtProgress -Activity $activity -Status 'Obtendo perfis de encaminhamento de tráfego'

        # Consulta Q1: Get all traffic forwarding profiles with associations and service principal
    $forwardingProfiles = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/forwardingProfiles' -Select "id,name,state,trafficForwardingType,associations,servicePrincipal" -ApiVersion beta

    # Initialize test variables
    $testResultMarkdown = ''
    $passed = $false
    $profileResults = @()
    $hasDisabledProfiles = $false
    $hasEnabledProfileWithoutAssignments = $false
    #endregion Data Collection

    #region Assessment Logic
    # Check each profile's assignments
    if($forwardingProfiles -and $forwardingProfiles.Count -gt 0){
        foreach ($forwardingProfile in $forwardingProfiles) {
                $profileInfo = @{
                    Name = $forwardingProfile.name
                    Type = $forwardingProfile.trafficForwardingType
                    State = $forwardingProfile.state
                    RemoteNetworkCount = ($forwardingProfile.associations ?? @()).Count
                    ServicePrincipalId = $null
                    AppId = $null
                    AssignmentType = 'Not checked'
                    TotalAssignments = 0
                    UserCount = 0
                    GroupCount = 0
                }

                # Handle disabled profiles
                if ($forwardingProfile.state -ne 'enabled') {
                    $hasDisabledProfiles = $true
                    $profileInfo.AssignmentType = 'N/A'
                    $profileResults += $profileInfo
                    continue
                }

                # Handle enabled profiles
                try {
                    $sp = $forwardingProfile.servicePrincipal
                    if (-not $sp) {
                        $profileInfo.AssignmentType = 'Error'
                        $hasEnabledProfileWithoutAssignments = $true
                        $profileResults += $profileInfo
                        continue
                    }

                    $profileInfo.ServicePrincipalId = $sp.id
                    $profileInfo.AppId = $sp.appId

                    Write-ZtProgress -Activity $activity -Status "Verificando atribuições para $($forwardingProfile.name)"

                        # Consulta Q2: Get service principal details with app role assignments
                    $servicePrincipal = Invoke-ZtGraphRequest -RelativeUri "servicePrincipals/$($sp.id)" -Select "appRoleAssignmentRequired" -ApiVersion v1.0 -QueryParameters @{ '$expand' = "appRoleAssignedTo(`$select=principalType)" }

                    if (-not $servicePrincipal.appRoleAssignmentRequired) {
                        # All users assigned - this is valid
                        $profileInfo.AssignmentType = 'All Users'
                        $profileInfo.TotalAssignments = 'All Users'
                    }
                    elseif ($servicePrincipal.appRoleAssignedTo -and $servicePrincipal.appRoleAssignedTo.Count -gt 0) {
                        # Specific assignments exist - count users and groups in single pass
                        $grouped = $servicePrincipal.appRoleAssignedTo | Group-Object -Property principalType -AsHashTable
                        $profileInfo.AssignmentType = 'Specific'
                        $profileInfo.UserCount = ($grouped['User'] ?? @()).Count
                        $profileInfo.GroupCount = ($grouped['Group'] ?? @()).Count
                        $profileInfo.TotalAssignments = $servicePrincipal.appRoleAssignedTo.Count
                    }
                    else {
                        # Assignment required but no assignments found - FAIL
                        $profileInfo.AssignmentType = 'None'
                        $hasEnabledProfileWithoutAssignments = $true
                    }
                }
                catch {
                    Write-PSFMessage "Falha ao verificar atribuições para o perfil $($forwardingProfile.name): $_" -Level Warning
                    $profileInfo.AssignmentType = 'Error'
                    $hasEnabledProfileWithoutAssignments = $true
                }

            $profileResults += $profileInfo
        }
    }
    else {
        # No profiles found or empty - FAIL
        $hasEnabledProfileWithoutAssignments = $true
    }

    # Determine pass/fail/investigate
    if ($hasEnabledProfileWithoutAssignments) {
        $passed = $false
        $testResultMarkdown = "A delimitação dos perfis de encaminhamento de tráfego não pôde ser validada. Um ou mais perfis habilitados não têm atribuições de usuário/grupo.`n`n%TestResult%"
    }
    elseif ($hasDisabledProfiles) {
        $passed = $false
        $testResultMarkdown = "Alguns dos perfis de encaminhamento de tráfego estão desabilitados; revise sua configuração se isso for intencional.`n`n%TestResult%"
    }
    else {
        $passed = $true
        $testResultMarkdown = "Os perfis de encaminhamento de tráfego estão direcionados adequadamente.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($profileResults.Count -gt 0) {
        $portalLink = 'https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/ForwardingProfile.ReactView'

        $enabledCount = ($profileResults | Where-Object { $_.State -eq 'enabled' }).Count
        $totalCount = $profileResults.Count

        $mdInfo += "`n## Resumo dos perfis de encaminhamento de tráfego`n`n"
        $mdInfo += "- **Perfis totais:** $totalCount`n"
        $mdInfo += "- **Perfis habilitados:** $enabledCount`n"
        $mdInfo += "- **Perfis desabilitados:** $($totalCount - $enabledCount)`n`n"
        $mdInfo += "## [Perfis de encaminhamento de tráfego]($portalLink)`n`n"
        $mdInfo += "| Nome do perfil | Tipo | Estado | Contagem de redes remotas | Usuários | Grupos | Escopo de atribuição |`n"
        $mdInfo += "| :----------- | :--- | :---- | :-------------- | :---- | :----- | :--------------- |`n"

        foreach ($profile in $profileResults) {
            $isEnabled = $profile.State -eq 'enabled'
            $stateDisplay = if ($isEnabled) { '✅ Habilitado' } else { '❌ Desabilitado' }

            $typeLabel = switch ($profile.Type) {
                'm365' { 'Microsoft 365' }
                'internet' { 'Internet' }
                'private' { 'Acesso privado' }
                default { $profile.Type }
            }

            $usersDisplay = if ($isEnabled -and $profile.AssignmentType -eq 'All Users') { 'All' }
                           elseif ($isEnabled) { $profile.UserCount }
                           else { 'N/A' }

            $groupsDisplay = if ($isEnabled -and $profile.AssignmentType -eq 'All Users') { 'All' }
                            elseif ($isEnabled) { $profile.GroupCount }
                            else { 'N/A' }

            $assignmentScopeDisplay = if (-not $isEnabled) { 'N/A' }
                                     elseif ($profile.AssignmentType -eq 'All Users') { '✅ Todos os usuários' }
                                     elseif ($profile.AssignmentType -eq 'Specific') { "Específico ($($profile.TotalAssignments))" }
                                     elseif ($profile.AssignmentType -eq 'None') { '❌ Nenhum' }
                                     else { $profile.AssignmentType }

            # Create hyperlink for assignment scope if service principal exists
            if ($profile.ServicePrincipalId -and $profile.AppId -and $isEnabled) {
                $assignmentLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Users/objectId/{0}/appId/{1}/preferredSingleSignOnMode~/null/servicePrincipalType/Application/fromNav/' -f $profile.ServicePrincipalId, $profile.AppId
                $assignmentScopeDisplayLink = "[$(Get-SafeMarkdown($assignmentScopeDisplay))]($assignmentLink)"
            } else {
                $assignmentScopeDisplayLink = $assignmentScopeDisplay
            }

            $mdInfo += "| $($profile.Name) | $typeLabel | $stateDisplay | $($profile.RemoteNetworkCount) | $usersDisplay | $groupsDisplay | $assignmentScopeDisplayLink |`n"
        }
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25382'
        Title  = 'Perfis de encaminhamento de tráfego são direcionados a usuários e grupos apropriados para implantação controlada'
        Status = $passed
        Result = $testResultMarkdown
    }

    if ($hasDisabledProfiles -and -not $hasEnabledProfileWithoutAssignments) {
        $params.CustomStatus = 'Investigate'
    }

    Add-ZtTestResultDetail @params
}
