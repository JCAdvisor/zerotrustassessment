<#
.SYNOPSIS
    Validates that external collaboration is governed by explicit Cross-Tenant Access Policies.

.DESCRIPTION
    This test checks if default outbound B2B collaboration settings block all users and all applications,
    requiring explicit cross-tenant access policies for external collaboration.

.NOTES
    Test ID: 25378
    Category: External Identities
    Required API: policies/crossTenantAccessPolicy/default
#>

function Test-Assessment-25378 {
    [ZtTest(
        Category = 'Identidades externas',
        ImplementationCost = 'Médio',
        MinimumLicense = 'AAD_PREMIUM',
        CompatibleLicense = ('AAD_PREMIUM','AAD_PREMIUM_P2'),
	    Pillar = 'Rede',
	    RiskLevel = 'Alto',
	    SfiPillar = 'Proteger identidades e segredos',
        TenantType = ('Workforce'),
        TestId = 25378,
        Title = 'A colaboração externa é governada por políticas explícitas de acesso entre locatários',
	    UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando a configuração da política de acesso entre locatários'
    Write-ZtProgress -Activity $activity -Status 'Recuperando a política padrão de acesso entre locatários'

        # Consulta 1: Retrieve the default cross-tenant access policy configuration
    $crossTenantAccessPolicy = $null
    try {
        $crossTenantAccessPolicy = Invoke-ZtGraphRequest -RelativeUri 'policies/crossTenantAccessPolicy/default' -ApiVersion beta
    } catch {
        Write-PSFMessage "Não foi possível recuperar a política de acesso entre locatários: $_" -Level Warning
    }
    # Initialize variables
    $isServiceDefault = $null
    $usersAndGroupsAccessType = $null
    $usersAndGroupsTargets = @()
    $usersAndGroupsTargetTypes = @()
    $applicationsAccessType = $null
    $applicationsTargets = @()
    $applicationsTargetTypes = @()

    # Extract data
    if ($null -ne $crossTenantAccessPolicy) {
        $isServiceDefault = $crossTenantAccessPolicy.isServiceDefault
        $b2bOutbound = $crossTenantAccessPolicy.b2bCollaborationOutbound

        if ($null -ne $b2bOutbound) {
            # Extract users and groups settings
            if ($b2bOutbound.usersAndGroups) {
                $usersAndGroupsAccessType = $b2bOutbound.usersAndGroups.accessType
                if ($b2bOutbound.usersAndGroups.targets.Count -gt 0) {
                    $usersAndGroupsTargets = @($b2bOutbound.usersAndGroups.targets.target)
                    $usersAndGroupsTargetTypes = @($b2bOutbound.usersAndGroups.targets.targetType)
                }
            }

            # Extract applications settings
            if ($b2bOutbound.applications) {
                $applicationsAccessType = $b2bOutbound.applications.accessType
                if ($b2bOutbound.applications.targets.Count -gt 0) {
                    $applicationsTargets = @($b2bOutbound.applications.targets.target)
                    $applicationsTargetTypes = @($b2bOutbound.applications.targets.targetType)
                }
            }
        }
    }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $false
    $customStatus = $null

    if ($null -eq $crossTenantAccessPolicy) {
        $testResultMarkdown = "❌ Não foi possível recuperar a configuração da política de acesso entre locatários.`n`n%TestResult%"
    }
    else {
        # Define evaluation conditions
        $fullAllowCondition = $usersAndGroupsAccessType -eq 'allowed' -and
                              $usersAndGroupsTargets -contains 'AllUsers' -and
                              $usersAndGroupsTargetTypes -contains 'user' -and
                              $applicationsAccessType -eq 'allowed' -and
                              $applicationsTargets -contains 'AllApplications' -and
                              $applicationsTargetTypes -contains 'application'

        $fullBlockCondition = $usersAndGroupsAccessType -eq 'blocked' -and
                              $usersAndGroupsTargets -contains 'AllUsers' -and
                              $usersAndGroupsTargetTypes -contains 'user' -and
                              $applicationsAccessType -eq 'blocked' -and
                              $applicationsTargets -contains 'AllApplications' -and
                              $applicationsTargetTypes -contains 'application'

        # Evaluate and set test result
        if ($isServiceDefault -or $fullAllowCondition) {
            $passed = $false
            $testResultMarkdown = "❌ Default outbound B2B collaboration allows all users to access all applications in external organizations without governance.`n`n%TestResult%"
        }
        elseif ($fullBlockCondition) {
            $passed = $true
            $testResultMarkdown = "✅ Default outbound B2B collaboration is blocked for all users and all applications, requiring explicit cross-tenant access policies for external collaboration.`n`n%TestResult%"
        }
        else {
            $passed = $false
            $customStatus = 'Investigate'
            $testResultMarkdown = "⚠️ A colaboração B2B de saída padrão tem restrições parciais configuradas; revise as configurações para garantir que estejam alinhadas com as políticas de segurança da organização.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($null -ne $crossTenantAccessPolicy) {
        $reportTitle = 'Configurações padrão de acesso entre locatários — colaboração B2B de saída'
        $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/CompanyRelationshipsMenuBlade/~/CrossTenantAccessSettings'

        # Prepare display values
        $isServiceDefaultStr = if ($null -eq $isServiceDefault) { 'N/A' } elseif ($isServiceDefault) { 'true' } else { 'false' }
        $usersAndGroupsAccessTypeDisplay = if ([string]::IsNullOrEmpty($usersAndGroupsAccessType)) { 'N/A' } else { $usersAndGroupsAccessType }
        $applicationsAccessTypeDisplay = if ([string]::IsNullOrEmpty($applicationsAccessType)) { 'N/A' } else { $applicationsAccessType }

        # Resolve and display users and groups (first 5)
        $displayUserTarget = 'N/A'
        if ($b2bOutbound.usersAndGroups.targets.Count -gt 0) {
            $targets = $b2bOutbound.usersAndGroups.targets | Select-Object -First 5

            $userTargets = $targets | Where-Object { $_.targetType -eq 'user' } | Select-Object -ExpandProperty target
            $groupTargets = $targets | Where-Object { $_.targetType -eq 'group' } | Select-Object -ExpandProperty target

            # Resolve all user and group targets at once
            $resolvedNames = @()

            if ($userTargets.Count -gt 0) {
                $resolvedUsers = Get-UserNameFromId -TargetsArray $userTargets -Database $Database
                $resolvedNames += $resolvedUsers
            }

            if ($groupTargets.Count -gt 0) {
                $resolvedGroups = Get-GroupNameFromId -TargetsArray $groupTargets
                $resolvedNames += $resolvedGroups
            }

            $displayUserTarget = $resolvedNames -join ', '
            if ($b2bOutbound.usersAndGroups.targets.Count -gt 5) {
                $displayUserTarget += ', ...'
            }
        }

        # Resolve and display applications (first 5)
        $displayAppTarget = 'N/A'
        if ($b2bOutbound.applications.targets.Count -gt 0) {
            $targets = $b2bOutbound.applications.targets | Select-Object -First 5
            $resolvedApps = Get-ApplicationNameFromId -TargetsArray $targets.target -Database $Database

            $displayAppTarget = $resolvedApps -join ', '
            if ($b2bOutbound.applications.targets.Count -gt 5) {
                $displayAppTarget += ', ...'
            }
        }

        # Calculate status indicators
        $isServiceDefaultStatus = if ($isServiceDefaultStr -eq 'false') { '✅' } else { '❌' }
        $usersAccessStatus = if ($usersAndGroupsAccessTypeDisplay -eq 'blocked') { '✅' } else { '❌' }
        $usersTargetStatus = if ($usersAndGroupsTargets -contains 'AllUsers' -and $usersAndGroupsTargetTypes -contains 'user') { '✅' } else { '❌' }
        $appsAccessStatus = if ($applicationsAccessTypeDisplay -eq 'blocked') { '✅' } else { '❌' }
        $appsTargetStatus = if ($applicationsTargets -contains 'AllApplications' -and $applicationsTargetTypes -contains 'application') { '✅' } else { '❌' }

        $formatTemplate = @'

## [{0}]({1})

| Setting | Configured value | Expected value | Status |
| :------ | :--------------- | :------------- | :----: |
{2}

'@

        $tableRows = "| É serviço padrão | $isServiceDefaultStr | false | $isServiceDefaultStatus |`n"
        $tableRows += "| Tipo de acesso de usuários e grupos | $usersAndGroupsAccessTypeDisplay | blocked | $usersAccessStatus |`n"
        $tableRows += "| Destino de usuários e grupos | $displayUserTarget | AllUsers | $usersTargetStatus |`n"
        $tableRows += "| Tipo de acesso de aplicações | $applicationsAccessTypeDisplay | blocked | $appsAccessStatus |`n"
        $tableRows += "| Destino de aplicações | $displayAppTarget | AllApplications | $appsTargetStatus |"

        $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $tableRows
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25378'
        Title  = 'A colaboração externa é governada por políticas explícitas de acesso entre locatários'
        Status = $passed
        Result = $testResultMarkdown
    }

    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }

    Add-ZtTestResultDetail @params
}
