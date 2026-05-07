<#
.SYNOPSIS
    As políticas de Acesso Condicional não excluem cargas de trabalho do Gerenciamento de Direitos
#>

function Test-Assessment-35001 {
    [ZtTest(
        Category = 'Entra',
        ImplementationCost = 'Baixo',
        Service = ('Graph'),
        MinimumLicense = ('Microsoft 365 E5'),
        Pillar = 'Dados',
        RiskLevel = 'Alto',
        SfiPillar = '',
        TenantType = ('Workforce','External'),
        TestId = 35001,
        Title = 'As políticas de Acesso Condicional não excluem cargas de trabalho do Gerenciamento de Direitos',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando exclusões de RMS de Acesso Condicional'
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de Acesso Condicional'

    $rmsAppId = '00000012-0000-0000-c000-000000000000'
    $blockingPolicies = @()
    $policies = @()
    $errorMsg = $null

    try {
            # Query: Get all enabled Conditional Access policies
        $policies = Get-ZtConditionalAccessPolicy | Where-Object { $_.state -eq 'enabled' }
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar políticas de Acesso Condicional: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    if ($errorMsg) {
        $passed = $false
    }
    else {
        foreach ($policy in $policies) {
            $includedApps = $policy.conditions.applications.includeApplications
            $excludedApps = $policy.conditions.applications.excludeApplications

            $isRmsIncluded = ($includedApps -contains 'All') -or ($includedApps -contains $rmsAppId)
            $isRmsExcluded = $excludedApps -contains $rmsAppId

            if ($isRmsIncluded -and -not $isRmsExcluded) {
                $blockingPolicies += $policy
            }
        }

        $passed = $blockingPolicies.Count -eq 0
    }
    #endregion Assessment Logic

    #region Report Generation
    if ($errorMsg) {
        $testResultMarkdown = "❌ Não foi possível determinar o status de exclusão de RMS devido a erro: $errorMsg"
    }
    elseif ($passed) {
        $testResultMarkdown = "✅ O Microsoft Rights Management Service (RMS) está excluído das políticas de Acesso Condicional que aplicam controles de autenticação."
    }
    else {
        $testResultMarkdown = "❌ O Microsoft Rights Management Service (RMS) está bloqueado ou restrito por uma ou mais políticas de Acesso Condicional.`n`n"
        $testResultMarkdown += "**Políticas que afetam o RMS:**`n`n"
        $testResultMarkdown += "| Nome da Política | Estado | RMS Direcionado | RMS Excluído | Controles de Concessão | Controles de Sessão |`n"
        $testResultMarkdown += "| :--- | :--- | :--- | :--- | :--- | :--- |`n"

        foreach ($policy in $blockingPolicies) {
            $policyLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/$($policy.id)"

            # Grant Controls
            $grantControls = @()
            if ($policy.grantControls) {
                if ($policy.grantControls.builtInControls) { $grantControls += $policy.grantControls.builtInControls }
                if ($policy.grantControls.termsOfUse) { $grantControls += "Terms of Use" }
            }
            $grantDisplay = if ($grantControls.Count -gt 0) { $grantControls -join ', ' } else { 'None' }

            # Session Controls
            $sessionControls = @()
            if ($policy.sessionControls) {
                foreach ($prop in $policy.sessionControls.PSObject.Properties) {
                    $name = $prop.Name
                    $value = $prop.Value

                    if ($null -eq $value) { continue }

                    $isSet = $false
                    if ($value -is [bool]) {
                        $isSet = $value
                    }
                    else {
                        if ($value.PSObject.Properties.Match('isEnabled')) {
                            $isSet = $value.isEnabled
                        }
                        else {
                            $isSet = $true
                        }
                    }

                    if ($isSet) {
                        $displayName = $name -replace '([a-z])([A-Z])', '$1 $2'
                        $displayName = $displayName.Substring(0,1).ToUpper() + $displayName.Substring(1)

                        switch ($name) {
                            'disableResilienceDefaults' { $displayName = 'Disable Resilience Defaults' }
                            'cloudAppSecurity' { $displayName = 'Cloud App Security' }
                            'signInFrequency' { $displayName = 'Sign-in Frequency' }
                            'persistentBrowser' { $displayName = 'Persistent Browser' }
                            'continuousAccessEvaluation' { $displayName = 'Customize Continuous Access Evaluation' }
                            'globalSecureAccessFilteringProfile' { $displayName = 'Global Secure Access Security Profile' }
                            'secureSignInSession' { $displayName = 'Secure Sign-in Session' }
                            'applicationEnforcedRestrictions' { $displayName = 'App Enforced Restrictions' }
                            'networkAccessSecurity' { $displayName = 'Network Access Security' }
                        }
                        $sessionControls += $displayName
                    }
                }
            }
            $sessionDisplay = if ($sessionControls.Count -gt 0) { $sessionControls -join ', ' } else { 'None' }

            $policyName = Get-SafeMarkdown -Text $policy.displayName

            $testResultMarkdown += "| [$policyName]($policyLink) | $($policy.state) | Yes | No | $grantDisplay | $sessionDisplay |`n"
        }
    }
    #endregion Report Generation

    $testResultDetail = @{
        TestId             = '35001'
        Title              = 'Exclusões de RMS de Acesso Condicional'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @testResultDetail
}
