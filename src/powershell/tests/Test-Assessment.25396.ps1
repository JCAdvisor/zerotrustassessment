<#
.SYNOPSIS
    Validates that Conditional Access policies enforce strong authentication for Private Access applications.

.DESCRIPTION
    This test checks if all Private Access applications (Per-app and Quick Access) are protected
    by Conditional Access policies requiring strong authentication (MFA or authentication strength).

.NOTES
    Test ID: 25396
    Category: Global Secure Access
    Required API: applications, servicePrincipals, identity/conditionalAccess/policies, authenticationStrength/policies
#>

function Test-Assessment-25396 {
    [ZtTest(
        Category = 'Global Secure Access',
        ImplementationCost = 'Médio',
        MinimumLicense = ('Entra_Premium_Private_Access', 'AAD_PREMIUM'),
        CompatibleLicense = ('Entra_Premium_Private_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger identidades e segredos',
        TenantType = ('Workforce'),
        TestId = 25396,
        Title = 'Políticas de Conditional Access aplicam autenticação forte para aplicativos privados',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando controles de autenticação do Private Access'
    Write-ZtProgress -Activity $activity -Status 'Obtendo aplicativos do Private Access'

        # Consulta Q1: Get all Private Access service principals with tags and CSAs
    $privateAccessApps = Invoke-ZtGraphRequest -RelativeUri 'servicePrincipals' -Filter "(tags/any(t:t eq 'PrivateAccessNonWebApplication') or tags/any(t:t eq 'NetworkAccessQuickAccessApplication'))" -Select 'id,displayName,appId,tags,customSecurityAttributes' -ApiVersion v1.0 -ConsistencyLevel eventual -QueryParameters @{ '$count' = 'true' }

    # Initialize test variables
    $testResultMarkdown = ''
    $passed = $false
    $allAppDetails = @()
    $totalApps = 0
    $phishingResistantApps = 0
    $passwordlessMfaApps = 0
    $mfaApps = 0
    $unprotectedApps = 0
    $manualReviewApps = 0
    $appsWithoutCSA = 0
    $filterPoliciesCount = 0

    # Built-in authentication strength IDs
    $builtInAuthStrengthIds = @{
        'MFA'               = '00000000-0000-0000-0000-000000000002'
        'PasswordlessMFA'   = '00000000-0000-0000-0000-000000000003'
        'PhishingResistant' = '00000000-0000-0000-0000-000000000004'
    }

    # Authentication level priority for comparison
    $authLevelPriority = @{
        'PhishingResistant' = 4
        'PasswordlessMFA'   = 3
        'MFA'               = 2
        'None'              = 1
    }

    # Status sort order for reporting
    $statusSortOrder = @{
        'Protegido'     = 3
        'Revisão manual' = 2
        'Não protegido'   = 1
    }

    # Phishing-resistant methods
    $phishingResistantMethods = @('windowsHelloForBusiness', 'fido2', 'x509CertificateMultiFactor')
    #endregion Data Collection

    #region Assessment Logic
    if (-not $privateAccessApps -or $privateAccessApps.Count -eq 0) {
        $passed = $false
        $testResultMarkdown = @"
⚠️ Nenhum aplicativo Private Access está configurado.

## Links do portal

- [Global Secure Access > Aplicativos > Aplicativos corporativos](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/EnterpriseApplicationListBladeV3/fromNav/globalSecureAccess/applicationType/GlobalSecureAccessApplication)
- [Conditional Access > Políticas](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/Overview/menuId//fromNav/Identity)
- [Métodos de autenticação > Forças de autenticação](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/AuthStrengths)
"@
    }
    else {
        $totalApps = $privateAccessApps.Count

        Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de Conditional Access'

            # Consulta Q2: Get all enabled CA policies
        $caPolicies = Get-ZtConditionalAccessPolicy | Where-Object { $_.state -eq 'enabled' }

        # Count policies with applicationFilter
        $filterPolicies = $caPolicies | Where-Object { $_.conditions.applications.applicationFilter }
        $filterPoliciesCount = if ($filterPolicies) { $filterPolicies.Count } else { 0 }

        # Cache for authentication strength policies
        $authStrengthCache = @{}

        Write-ZtProgress -Activity $activity -Status 'Avaliando controles de autenticação para cada aplicativo'

        foreach ($app in $privateAccessApps) {
            $appId = $app.appId
            $displayName = $app.displayName

            # Determine app type
            $appType = if ($app.tags -contains 'NetworkAccessQuickAccessApplication') { 'Quick Access' } else { 'Per-App' }

            # Check CSA presence
            $hasCSA = $null -ne $app.customSecurityAttributes -and ($app.customSecurityAttributes.PSObject.Properties.Count -gt 0)

            # Find CA policies targeting this app
            $targetingPolicies = @()
            foreach ($policy in $caPolicies) {
                $includeApps = $policy.conditions.applications.includeApplications
                $excludeApps = $policy.conditions.applications.excludeApplications

                # Check if explicitly excluded
                if ($excludeApps -contains $appId) {
                    continue
                }

                # Check direct targeting or "All"
                if (($includeApps -contains $appId) -or ($includeApps -contains 'All')) {
                    $targetingPolicies += $policy
                }
            }

            # Determine authentication strength level
            $authLevel = 'None'
            $authStrengthName = 'N/A'
            $allPolicyDetails = @()
            $status = 'Unprotected'

            if ($targetingPolicies.Count -gt 0) {
                # Evaluate all targeting policies and collect details
                foreach ($policy in $targetingPolicies) {
                    $currentLevel = 'None'
                    $currentStrengthName = 'N/A'

                    # Check for authentication strength (Q3)
                    if ($policy.grantControls.authenticationStrength -and $policy.grantControls.authenticationStrength.id) {
                        $authStrengthId = $policy.grantControls.authenticationStrength.id

                        # Retrieve auth strength policy details if not cached
                        if (-not $authStrengthCache.ContainsKey($authStrengthId)) {
                            $authStrengthUri = "identity/conditionalAccess/authenticationStrength/policies/$authStrengthId"
                            $authStrengthPolicy = Invoke-ZtGraphRequest -RelativeUri $authStrengthUri -ApiVersion v1.0
                            $authStrengthCache[$authStrengthId] = $authStrengthPolicy
                        }

                        $authStrengthPolicy = $authStrengthCache[$authStrengthId]
                        $currentStrengthName = $authStrengthPolicy.displayName

                        # Classify authentication strength
                        if ($authStrengthPolicy.policyType -eq 'builtIn') {
                            if ($authStrengthId -eq $builtInAuthStrengthIds['PhishingResistant']) {
                                $currentLevel = 'PhishingResistant'
                            }
                            elseif ($authStrengthId -eq $builtInAuthStrengthIds['PasswordlessMFA']) {
                                $currentLevel = 'PasswordlessMFA'
                            }
                            elseif ($authStrengthId -eq $builtInAuthStrengthIds['MFA']) {
                                $currentLevel = 'MFA'
                            }
                        }
                        elseif ($authStrengthPolicy.policyType -eq 'custom') {
                            # Check if ALL combinations contain at least one phishing-resistant method
                            $allPhishingResistant = $true
                            foreach ($combination in $authStrengthPolicy.allowedCombinations) {
                                $methods = $combination -split ','
                                $combinationIsPhishingResistant = $false
                                foreach ($method in $methods)
                                {
                                    if ($phishingResistantMethods -contains $method.Trim()) {
                                        $combinationIsPhishingResistant = $true
                                        break
                                    }
                                }
                                # If this combination doesn't have a phishing-resistant method, fail
                                if (-not $combinationIsPhishingResistant) {
                                    $allPhishingResistant = $false
                                    break
                                }
                            }
                            $currentLevel = if ($allPhishingResistant) { 'PhishingResistant' } else { 'MFA' }
                        }
                    }
                    # Check for MFA in builtInControls
                    elseif ($policy.grantControls.builtInControls -contains 'mfa') {
                        $currentLevel = 'MFA'
                        $currentStrengthName = 'MFA (integrada)'
                    }

                    # Collect policy details
                    $allPolicyDetails += [PSCustomObject]@{
                        PolicyName   = $policy.displayName
                        AuthStrength = $currentStrengthName
                        Level        = $currentLevel
                        Priority     = $authLevelPriority[$currentLevel]
                    }
                }

                # Sort by strongest auth level and get the overall strongest
                $sortedPolicies = $allPolicyDetails | Sort-Object -Property Priority -Descending
                $strongestPolicy = $sortedPolicies | Select-Object -First 1
                $authLevel = $strongestPolicy.Level
                $authStrengthName = $strongestPolicy.AuthStrength

                # Get all policies with the strongest auth level
                $strongestPolicies = $allPolicyDetails | Where-Object { $_.Level -eq $authLevel }
                $strongestPolicyNames = ($strongestPolicies | ForEach-Object { $_.PolicyName }) -join ', '
            }

            # Determine status
            if ($authLevel -ne 'None') {
                $status = 'Protegido'

                # Update counters
                switch ($authLevel) {
                    'PhishingResistant' { $phishingResistantApps++ }
                    'PasswordlessMFA' { $passwordlessMfaApps++ }
                    'MFA' { $mfaApps++ }
                }
            }
            elseif ($hasCSA -and $filterPoliciesCount -gt 0) {
                $status = 'Revisão manual'
                $manualReviewApps++
            }
            else {
                $status = 'Não protegido'
                $unprotectedApps++
            }

            if (-not $hasCSA) {
                $appsWithoutCSA++
            }

            # Add to results
            $allAppDetails += [PSCustomObject]@{
                AppName         = $displayName
                AppId           = $appId
                AppType         = $appType
                HasCSA          = if ($hasCSA) { 'Sim' } else { 'Não' }
                CAPolicies      = if ($allPolicyDetails.Count -gt 0) { $strongestPolicyNames } else { 'Nenhuma' }
                AuthStrength    = $authStrengthName
                Level           = $authLevel
                Status          = $status
                StatusSort      = $statusSortOrder[$status]
            }
        }

        if ($unprotectedApps -eq 0 -and $manualReviewApps -eq 0) {
            $passed = $true
            $testResultMarkdown = "✅ Todos os aplicativos Private Access são direcionados por pelo menos uma política de CA habilitada que requer força de autenticação ou MFA.`n`n%TestResult%"
        }
        elseif ($unprotectedApps -eq 0 -and $manualReviewApps -gt 0) {
            # Investigate state
            $passed = $false
            $testResultMarkdown = "⚠️ Os aplicativos Private Access têm Custom Security Attributes atribuídos, mas não possuem cobertura direta de política de CA. As políticas de CA usam direcionamento por applicationFilter. Revisão manual necessária para verificar se esses aplicativos estão protegidos por políticas com direcionamento por applicationFilter.`n`n%TestResult%"
        }
        else {
            # Fail state
            $passed = $false
            $testResultMarkdown = "❌ Um ou mais aplicativos Private Access não estão protegidos por políticas de Conditional Access que exigem autenticação forte.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($totalApps -gt 0) {
        $portalAppsLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/EnterpriseApplicationListBladeV3/fromNav/globalSecureAccess/applicationType/GlobalSecureAccessApplication'
        $portalCaLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/Overview/menuId//fromNav/Identity'
        $portalAuthStrengthLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/AuthStrengths'

        $mdInfo += @"

## Resumo

- **Total de aplicativos Private Access:** $totalApps
- **Aplicativos com MFA resistente a phishing:** $phishingResistantApps
- **Aplicativos com MFA sem senha:** $passwordlessMfaApps
- **Aplicativos com MFA (padrão):** $mfaApps
- **Aplicativos sem autenticação forte:** $unprotectedApps
- **Aplicativos que exigem revisão manual:** $manualReviewApps
- **Aplicativos sem CSAs:** $appsWithoutCSA
- **Políticas de CA usando applicationFilter:** $filterPoliciesCount

## [Detalhes do aplicativo](${portalAppsLink})

| Nome do aplicativo | App id | Tipo de aplicativo | Possui CSAs | Política de CA | Força de autenticação | Nível | Status |
| :------- | :----- | :------- | :------- | :-------- | :------------ | :---- | :----- |

"@

        foreach ($app in ($allAppDetails | Sort-Object StatusSort, AppName)) {
            $statusIcon = switch ($app.Status) {
                'Protegido' { '✅' }
                'Não protegido' { '❌' }
                'Revisão manual' { '⚠️' }
                default { '' }
            }
            $mdInfo += "| $($app.AppName) | $($app.AppId) | $($app.AppType) | $($app.HasCSA) | $($app.CAPolicies) | $($app.AuthStrength) | $($app.Level) | $statusIcon $($app.Status) |`n"
        }

        $mdInfo += @"
## Links do portal
- [Políticas de Conditional Access](${portalCaLink})
- [Forças de autenticação](${portalAuthStrengthLink})
"@
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25396'
        Title  = 'Políticas de Conditional Access aplicam autenticação forte para aplicativos privados'
        Status = $passed
        Result = $testResultMarkdown
    }

    if ($unprotectedApps -eq 0 -and $manualReviewApps -gt 0) {
        $params.CustomStatus = 'Investigate'
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
