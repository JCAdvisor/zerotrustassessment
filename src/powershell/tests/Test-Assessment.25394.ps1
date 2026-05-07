<#
.SYNOPSIS
    Checks that Quick Access is bound to a Conditional Access policy.

.DESCRIPTION
    Verifies that the Quick Access application in Entra Private Access is protected by at least one enabled
    Conditional Access policy with meaningful security controls (MFA, device compliance, or authentication strength).
    Quick Access without Conditional Access enforcement allows compromised credentials to access private resources
    without additional verification, creating security risks for internal resources.

.NOTES
    Test ID: 25394
    Category: Global Secure Access
    Required API: servicePrincipals (beta), identity/conditionalAccess/policies (beta), applications/{AppID}/onPremisesPublishing (beta)
#>

function Test-Assessment-25394 {
    [ZtTest(
        Category = 'Acesso Seguro Global',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Entra_Premium_Private_Access', 'AAD_PREMIUM'),
        CompatibleLicense = ('Entra_Premium_Private_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce', 'External'),
        TestId = '25394',
        Title = 'O Quick Access está vinculado a uma política de Conditional Access',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando a proteção de política de Conditional Access do Quick Access'
    Write-ZtProgress -Activity $activity -Status 'Consultando o aplicativo Quick Access'

    # Q1: Get Quick Access application
    $quickAccessApp = Invoke-ZtGraphRequest -RelativeUri 'servicePrincipals' -Filter "tags/any(c:c eq 'NetworkAccessQuickAccessApplication')" -Select 'appId,displayName,id' -ApiVersion beta
    $quickAccessAppId = $null
    if ($quickAccessApp -and $quickAccessApp.Count -gt 0) {
        $quickAccessAppId = $quickAccessApp.appId
    }

    # Q2: Get all enabled Conditional Access policies
    $caPolicies = $null
    if ($null -ne $quickAccessApp -and $quickAccessApp.Count -gt 0) {
        Write-ZtProgress -Activity $activity -Status 'Verificando políticas de Conditional Access para Quick Access'
        $allCAPolicies = Get-ZtConditionalAccessPolicy
        $caPolicies = $allCAPolicies | Where-Object { $_.state -eq 'enabled' }
    }

    #endregion Data Collection

    #region Assessment Logic
    # Initialize test variables
    $testResultMarkdown = ''
    $passed = $false
    $applicablePolicies = @()

    # Check if Quick Access application exists
    if (-not $quickAccessApp -or $quickAccessApp.Count -eq 0) {
        $testResultMarkdown = "⚠️ Nenhum aplicativo Quick Access está configurado. Revise a documentação para habilitar o Quick Access se necessário.`n`n%TestResult%"
    }
    else {
        # Check Conditional Access policy coverage
        if ($null -eq $caPolicies -or $caPolicies.Count -eq 0) {
            Write-PSFMessage 'Falha ao recuperar políticas de Conditional Access ou nenhuma política está habilitada' -Level Warning
            $passed = $false
            $testResultMarkdown = "❌ Aplicativo Quick Access encontrado sem aplicação de política de Conditional Access.`n`n%TestResult%"
        }
        else {
            foreach ($policy in $caPolicies) {
                $policyTargetsQuickAccess = $false
                # Check if "All" apps are targeted
                if ($policy.conditions.applications.includeApplications -contains 'All') {
                    $policyTargetsQuickAccess = $true
                }
                # Check if Quick Access appId is explicitly included
                elseif ($policy.conditions.applications.includeApplications -contains $quickAccessAppId) {
                    $policyTargetsQuickAccess = $true
                }

                if ($policyTargetsQuickAccess) {
                    # Verify meaningful grant controls
                    $hasMeaningfulControls = $false
                    $grantControlsList = @()

                    if ($null -ne $policy.grantControls) {
                        # Check for meaningful built-in controls
                        if ($null -ne $policy.grantControls.builtInControls -and $policy.grantControls.builtInControls.Count -gt 0) {
                            foreach ($control in $policy.grantControls.builtInControls) {
                                if ($control -in @('mfa', 'compliantDevice', 'domainJoinedDevice', 'approvedApplication')) {
                                    $hasMeaningfulControls = $true
                                }
                                $grantControlsList += $control
                            }
                        }

                        # Check for authentication strength
                        if ($null -ne $policy.grantControls.authenticationStrength) {
                            $hasMeaningfulControls = $true
                            if ($null -ne $policy.grantControls.authenticationStrength.displayName) {
                                $grantControlsList += "AuthenticationStrength: $($policy.grantControls.authenticationStrength.displayName)"
                            }
                        }
                    }

                    if ($hasMeaningfulControls) {
                        $policyInfo = [PSCustomObject]@{
                            DisplayName = $policy.displayName
                            Id = $policy.id
                            GrantControls = $grantControlsList
                        }
                        $applicablePolicies += $policyInfo
                    }
                }
            }
        }

        # Determine pass/fail status
        if ($applicablePolicies.Count -gt 0) {
            $passed = $true
            $testResultMarkdown = "✅ O aplicativo Quick Access está protegido por políticas de Conditional Access com controles de autenticação.`n`n%TestResult%"
        }
        else {
            $passed = $false
            $testResultMarkdown = "❌ Aplicativo Quick Access encontrado sem aplicação de política de Conditional Access.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build detailed markdown information
    $mdInfo = ''

    if ($null -ne $quickAccessApp -and $quickAccessApp.Count -gt 0) {
        $appPortalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/overview/appId/$($quickAccessApp.appId)"
        $mdInfo += "**Nome do aplicativo Quick Access:** [$(Get-SafeMarkdown -Text $quickAccessApp.displayName)]($appPortalLink)`n`n"

        # Show applicable policies if any
        if ($applicablePolicies.Count -gt 0) {
            $mdInfo += "### [Políticas de Conditional Access aplicáveis](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/QuickAccessMenuBlade/~/GlobalSecureAccess)`n`n"
            $mdInfo += "| Nome da política | Controles de concessão configurados |`n"
            $mdInfo += "| :---------- | :------------------------ |`n"

            foreach ($policy in $applicablePolicies) {
                $grantControlsStr = $([string]::Join(', ', $policy.GrantControls))
                # blade link for Conditional Access policy (fixed: no ~/ before policyId)
                $policyPortalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/$($policy.Id)"
                $mdInfo += "| [$(Get-SafeMarkdown -Text $policy.DisplayName)]($policyPortalLink) | $grantControlsStr |`n"
            }
            $mdInfo += "`n"
        }
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25394'
        Title  = 'Quick Access está protegido por políticas de Conditional Access'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add Investigate status if Quick Access is not configured
    if (-not $quickAccessApp -or $quickAccessApp.Count -eq 0) {
        $params.CustomStatus = 'Investigate'
    }

    # Add test result details
    Add-ZtTestResultDetail @params

}
