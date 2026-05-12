<#
.SYNOPSIS
    Validates that Universal Continuous Access Evaluation (Universal CAE) is enabled for network access.

.DESCRIPTION
    This test checks if Universal Continuous Access Evaluation (Universal CAE) is enabled in the tenant
    through Global Secure Access with Conditional Access signaling. Universal CAE ensures network access
    tokens are validated in real-time every time a connection to a new application resource is established.

    Without Universal CAE enabled, GSA tokens remain valid for 60-90 minutes regardless of changes to user state,
    allowing threat actors who obtain a GSA token to continue accessing all GSA-protected network resources even
    after the user's account is disabled, password is reset, or sessions are revoked.

    When critical security events occur (user account deletion, password change, MFA enablement, session revocation,
    or high user risk detection), Universal CAE communicates these signals to Global Secure Access in near real-time,
    prompting immediate reauthentication and blocking unauthorized access.

.NOTES
#>

function Test-Assessment-25371 {
    [ZtTest(
    	Category = 'Global Secure Access',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('AAD_PREMIUM'),
    	CompatibleLicense = ('Entra_Premium_Private_Access','Entra_Premium_Internet_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 25371,
    	Title = 'A validação de rede é configurada por meio da Avaliação Contínua de Acesso Universal',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando a configuração do Universal CAE'
    Write-ZtProgress -Activity $activity -Status 'Obtendo configurações do Global Secure Access'

    # Q1: Check if Global Secure Access is enabled and configured
    # Determine if the organization is using Global Secure Access with Conditional Access signaling enabled
    $gsaSettings = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/settings/conditionalAccess' -ApiVersion beta

    # Q2: Check traffic forwarding profiles status (Prerequisite)
    # Determine which GSA traffic forwarding profiles are active
    Write-ZtProgress -Activity $activity -Status 'Obtendo perfis de encaminhamento de tráfego'
    $forwardingProfiles = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/forwardingProfiles' -ApiVersion beta

    # Q3: Check for Conditional Access policies that disable CAE for GSA traffic
        # Consulta enabled Conditional Access policies to identify any that explicitly disable CAE
    Write-ZtProgress -Activity $activity -Status 'Checking Conditional Access policies'
    $caePolicies = Get-ZtConditionalAccessPolicy | Where-Object { $_.state -eq 'enabled' }

    # Initialize test variables
    $CAPolicyDetails = @()

    if ($caePolicies -and $caePolicies.Count -gt 0) {
        foreach ($policy in $caePolicies) {
            $appCondition = $policy.conditions.applications
            # Primary check: Check if policy targets All applications
            $targetsAllApps = $appCondition.includeApplications -contains "All"

            $CAPolicyDetails += [PSCustomObject]@{
                Id                         = $policy.id
                DisplayName                = $policy.displayName
                State                      = $policy.state
                TargetsAllApps             = $targetsAllApps
                ContinuousAccessEvaluation = $policy.sessionControls.continuousAccessEvaluation.mode
            }
        }
    }
    # Flag policies where CAE is explicitly disabled for all apps
    $ContinuousAccessEvaluationDisabledPolicies = $CAPolicyDetails | Where-Object {
        ($_.TargetsAllApps -eq $true) -and ($_.ContinuousAccessEvaluation -eq 'disabled')
    }

    #endregion Data Collection

    #region Assessment Logic
    # Prerequisite Check: If Q1 shows signalingStatus is not enabled, the check is Not Applicable

    $passed = $true
    $testResultMarkdown = ''
    if (-not $gsaSettings -or $gsaSettings.signalingStatus -ne 'enabled') {
        $passed = $false
        $testResultMarkdown = "ℹ️ O Global Secure Access com sinalização de Conditional Access não está configurado neste locatário. O Universal CAE não se aplica.`n`n%TestResult%"
    }
    else {
        $passed = $ContinuousAccessEvaluationDisabledPolicies.Count -eq 0

        # Set result message based on findings
        if (-not $passed) {
            $testResultMarkdown = "❌ O Universal CAE está desabilitado no nível do locatário ou por meio de políticas de Conditional Access.`n`n%TestResult%"
        }
        else {
            $testResultMarkdown = "✅ O Universal CAE está habilitado para o Global Secure Access.`n`n%TestResult%"
        }
    }

    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($gsaSettings) {
        $mdInfo += "`n## [Status do Global Secure Access](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/Welcome.ReactView)`n`n"
        $mdInfo += "**Status de sinalização**: $(if ($gsaSettings.signalingStatus -eq 'enabled') { '✅ Habilitado' } else { '❌ ' + $gsaSettings.signalingStatus })`n"
    }
    else {
        $mdInfo += "`n## [Status do Global Secure Access](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/Welcome.ReactView)`n`n"
        $mdInfo += "**Status**: ℹ️ Não configurado`n`n"
    }

    # Informational: Record enabled traffic forwarding profiles
    if ($null -ne $forwardingProfiles) {
        $mdInfo += "`n## [Perfis de tráfego ativos](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/TrafficForwarding.ReactView)`n`n"
        $mdInfo += "| Nome | Status | Tipo de Tráfego |`n"
        $mdInfo += "| :--- | :--- | :--- |`n"
        foreach ($forwardingProfile in ($forwardingProfiles | Sort-Object -Property name)) {
            $mdInfo += "| $(Get-SafeMarkdown $forwardingProfile.name) | $(Get-FormattedPolicyState $forwardingProfile.state) | $($forwardingProfile.trafficForwardingType) |`n"
        }
    }
    else {
        $mdInfo += "`n## [Perfis de tráfego ativos](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/TrafficForwarding.ReactView)`n`n"
        $mdInfo += "Nenhum perfil de tráfego ativo encontrado.`n`n"
    }

    # Report CAE-disabling policies
    if ($ContinuousAccessEvaluationDisabledPolicies.Count -gt 0) {
        $mdInfo += "`n## Políticas que desabilitam a Avaliação Contínua de Acesso`n`n"
        $mdInfo += "| Nome da política | ID da política | Modo de Avaliação Contínua de Acesso |`n"
        $mdInfo += "| :--- | :--- | :--- |`n"
        foreach ($policy in ($ContinuousAccessEvaluationDisabledPolicies | Sort-Object -Property DisplayName)) {
            $ContinuousAccessEvalIcon = "❌ Desabilitado"
            $policyLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/$($policy.Id)"
            $mdInfo += "| [$(Get-SafeMarkdown $policy.DisplayName)]($policyLink) | $($policy.Id) | $ContinuousAccessEvalIcon |`n"
        }
        $mdInfo += "`n"
    }
    else {
        $mdInfo += "`n## [Políticas que desabilitam a Avaliação Contínua de Acesso](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/Policies)`n`n"
        $mdInfo += "Nenhuma política de Conditional Access que desabilite a Avaliação Contínua de Acesso foi encontrada.`n`n"
    }
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25371'
        Title  = 'O acesso à rede é validado em tempo real por meio da Avaliação Contínua de Acesso Universal'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
