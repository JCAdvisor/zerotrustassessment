<#
.SYNOPSIS
    Checks if all entitlement management packages that apply to guests have expirations or access reviews configured in their assignment policies.
#>

function Test-Assessment-21929{
    [ZtTest(
    	Category = 'Governança de identidade',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P2','Governance'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger tenants e isolar sistemas de produção',
    	TenantType = ('Workforce','External'),
    	TestId = 21929,
    	Title = 'Todos os pacotes de gerenciamento de direitos aplicáveis a convidados têm expirações ou revisões de acesso configuradas em suas políticas de atribuição',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if( -not (Get-ZtLicense EntraIDP2) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP2
        return
    }

    $activity = 'Verificando se os pacotes de gerenciamento de direitos para usuários externos possuem controles adequados'
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de atribuição'

    # Query 1: Get all assignment policies with expanded access package information
    $assignmentPolicies = Invoke-ZtGraphRequest -RelativeUri 'identityGovernance/entitlementManagement/assignmentPolicies' -QueryParameters @{'$expand' = 'accessPackage'} -ApiVersion v1.0

    # Handle case where no policies exist or API returns null
    if ($null -eq $assignmentPolicies -or $assignmentPolicies.Count -eq 0) {
        Write-PSFMessage 'Nenhuma política de atribuição encontrada no tenant' -Level Verbose
        $assignmentPolicies = @()
    }

    # Client-side filter for policies that apply to external users
    $externalUserPolicies = @()

    foreach ($policy in $assignmentPolicies) {
        # Skip if requestorSettings is null or missing
        if ($null -eq $policy.requestorSettings) {
            Write-PSFMessage "Pulando política $($policy.id) - sem requestorSettings" -Level Debug
            continue
        }

        $requestorSettings = $policy.requestorSettings

        # Check if policy allows self-service or on-behalf requests
        $allowsSelfService = $requestorSettings.enableTargetsToSelfAddAccess -eq $true -or
                           $requestorSettings.enableTargetsToSelfRemoveAccess -eq $true -or
                           $requestorSettings.enableTargetsToSelfUpdateAccess -eq $true -or
                           $requestorSettings.enableOnBehalfRequestorsToAddAccess -eq $true -or
                           $requestorSettings.enableOnBehalfRequestorsToRemoveAccess -eq $true -or
                           $requestorSettings.enableOnBehalfRequestorsToUpdateAccess -eq $true

        if($allowsSelfService){
            # Check if policy applies to external users using allowedTargetScope property
            $appliesToExternal = Test-ZtExternalUserScope -TargetScope $policy.allowedTargetScope

            # Include policy if it allows requests AND applies to external users
            if ($appliesToExternal) {
                $externalUserPolicies += $policy
            }
        }

    }

    Write-PSFMessage "Encontradas $($externalUserPolicies.Count) políticas de atribuição que se aplicam a usuários externos" -Level Verbose

    # Query 2: Evaluate expiration and access review controls for each policy
    $policiesWithoutControls = @()
    $allPoliciesData = @()

    foreach ($policy in $externalUserPolicies) {
        # Check expiration configuration - handle null expiration object
        $hasExpiration = $null -ne $policy.expiration -and $policy.expiration.type -ne 'noExpiration'

        # Check access review configuration
        # Review settings must be enabled AND have a schedule with recurrence pattern configured
        $hasAccessReview = $false
        if ($null -ne $policy.reviewSettings -and $policy.reviewSettings.isEnabled -eq $true) {
            # Check if schedule exists with proper recurrence pattern
            if ($null -ne $policy.reviewSettings.schedule -and
                $null -ne $policy.reviewSettings.schedule.recurrence -and
                $null -ne $policy.reviewSettings.schedule.recurrence.pattern) {
                $hasAccessReview = $true
            }
        }

        # Skip policies with missing access package information
        if ($null -eq $policy.accessPackage) {
            Write-PSFMessage "Pulando política $($policy.id) - sem informações de pacote de acesso" -Level Verbose
            continue
        }

        # Create policy data for reporting
        $policyData = [PSCustomObject]@{
            AccessPackageId = $policy.accessPackage.id
            AccessPackageName = $policy.accessPackage.displayName
            AssignmentPolicyId = $policy.id
            AssignmentPolicyName = $policy.displayName
            HasExpiration = $hasExpiration
            HasAccessReview = $hasAccessReview
            HasControls = $hasExpiration -or $hasAccessReview
        }

        $allPoliciesData += $policyData

        # Track policies without proper controls
        if (-not ($hasExpiration -or $hasAccessReview)) {
            $policiesWithoutControls += $policyData
        }
    }

    # Assessment logic
    $passed = $policiesWithoutControls.Count -eq 0

    # Build report markdown
    $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_ERM/DashboardBlade/~/elmEntitlement'

    if ($passed) {
        $testResultMarkdown = "Todas as políticas de atribuição de pacotes de acesso para usuários externos incluem expiração ou revisões de acesso.`n`n%PolicyDetails%"
    } else {
        $testResultMarkdown = "Foram encontradas políticas de atribuição de pacotes de acesso sem expiração e sem revisões de acesso para usuários externos.`n`n%PolicyDetails%"
    }

    # Build policy details table
    $mdInfo = "## [Políticas de atribuição de pacotes de acesso para usuários externos]($portalLink)`n`n"

    if ($allPoliciesData.Count -gt 0) {
        $mdInfo += "| Pacote de acesso | Política de atribuição | Expiração configurada | Revisão de acesso configurada | Status |`n"
        $mdInfo += "| :------------- | :---------------- | :------------------ | :--------------------- | :----- |`n"

        # Sort to show non-compliant policies first, then by access package and policy name
        foreach ($policyData in ($allPoliciesData | Sort-Object HasControls, AccessPackageName, AssignmentPolicyName)) {
            $packageName = $policyData.AccessPackageName
            $policyName = $policyData.AssignmentPolicyName

            $expirationStatus = if ($policyData.HasExpiration) { 'Sim' } else { 'Não' }
            $reviewStatus = if ($policyData.HasAccessReview) { 'Sim' } else { 'Não' }
            $overallStatus = if ($policyData.HasControls) { '✅ Conforme' } else { '❌ Não conforme' }

            $mdInfo += "| $packageName | $policyName | $expirationStatus | $reviewStatus | $overallStatus |`n"
        }
    } else {
        $mdInfo += "Nenhuma política de atribuição de pacotes de acesso encontrada para usuários externos.`n"
    }

    # Replace placeholder in test result markdown
    $testResultMarkdown = $testResultMarkdown -replace "%PolicyDetails%", $mdInfo

    $params = @{
        TestId = '21929'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
