<#
.SYNOPSIS
    Verifica se a organização reduziu a superfície de exposição de senhas ao habilitar múltiplos métodos de autenticação sem senha (passwordless).
#>

function Test-Assessment-21889{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Médio',
        MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21889,
    	Title = 'Reduzir a superfície de exposição de senhas visível ao usuário',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando configuração de autenticação sem senha'
    Write-ZtProgress -Activity $activity -Status 'Obtendo política de métodos de autenticação'

    # Get authentication methods policy
    $authMethodsPolicy = Invoke-ZtGraphRequest -RelativeUri 'policies/authenticationMethodsPolicy' -ApiVersion beta

    if (-not $authMethodsPolicy) {
        $testResultMarkdown = 'Não foi possível obter a política de métodos de autenticação.'
        $params = @{
            TestId = '21889'
            Status = $false
            Result = $testResultMarkdown
        }
        Add-ZtTestResultDetail @params
        return
    }

    # Extract FIDO2 and Microsoft Authenticator configurations
    $fido2Config = $authMethodsPolicy.authenticationMethodConfigurations | Where-Object { $_.id -eq 'Fido2' }
    $authenticatorConfig = $authMethodsPolicy.authenticationMethodConfigurations | Where-Object { $_.id -eq 'MicrosoftAuthenticator' }

    # Check FIDO2 configuration
    $fido2Enabled = $fido2Config.state -eq 'enabled'
    $fido2HasTargets = $fido2Config.includeTargets.Count -gt 0
    $fido2Valid = $fido2Enabled -and $fido2HasTargets

    # Check Microsoft Authenticator configuration
    $authEnabled = $authenticatorConfig.state -eq 'enabled'
    $authHasTargets = $authenticatorConfig.includeTargets.Count -gt 0
    $authMode = $authenticatorConfig.includeTargets.authenticationMode
    # Handle null or empty authMode
    if ([string]::IsNullOrEmpty($authMode)) {
        $authMode = 'Not configured'
        $authModeValid = $false
    } else {
        $authModeValid = ($authMode -eq 'any') -or ($authMode -eq 'deviceBasedPush')
    }
    $authValid = $authEnabled -and $authHasTargets -and $authModeValid

    # Determine pass/fail
    $passed = $fido2Valid -and $authValid

    # Build result message
    if ($passed) {
        $testResultMarkdown = 'Sua organização implementou múltiplos métodos de autenticação sem senha, reduzindo a exposição de senhas.%TestResult%'
    } else {
        $testResultMarkdown = 'Sua organização depende fortemente da autenticação baseada em senha, criando vulnerabilidades de segurança.%TestResult%'
    }

    # Build detailed markdown table
    $mdInfo = "`n## Métodos de autenticação sem senha`n`n"
    $mdInfo += "| Método | Estado | Alvos Incluídos | Modo de Autenticação | Status |`n"
    $mdInfo += "| :----- | :---- | :-------------- | :------------------ | :----- |`n"

    # FIDO2 row
    $fido2State = if ($fido2Enabled) { '✅ Ativo' } else { '❌ Desativado' }
    $fido2TargetsDisplay = if ($fido2Config.includeTargets -is [array] -and $fido2Config.includeTargets.Count -gt 0) {
        ($fido2Config.includeTargets | ForEach-Object { Get-ZtAuthenticatorFeatureSettingTarget -Target $_ }) -join ', '
    } else {
        'Nenhum'
    }
    $fido2Status = if ($fido2Valid) { '✅ Aprovado' } else { '❌ Reprovado' }
    $mdInfo += "| FIDO2 Security Keys | $fido2State | $fido2TargetsDisplay | N/A | $fido2Status |`n"

    # Microsoft Authenticator row
    $authState = if ($authEnabled) { '✅ Ativo' } else { '❌ Desativado' }
    $authTargetsDisplay = if ($authenticatorConfig.includeTargets -is [array] -and $authenticatorConfig.includeTargets.Count -gt 0) {
        ($authenticatorConfig.includeTargets | ForEach-Object { Get-ZtAuthenticatorFeatureSettingTarget -Target $_ }) -join ', '
    } else {
        'None'
    }
    $authModeDisplay = if ($authModeValid) { "✅ $authMode" } else { "❌ $authMode" }
    $authStatus = if ($authValid) { '✅ Aprovado' } else { '❌ Reprovado' }
    $mdInfo += "| Microsoft Authenticator | $authState | $authTargetsDisplay | $authModeDisplay | $authStatus |`n"

    # Replace placeholder
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo

    # Add test result
    $params = @{
        TestId = '21889'
        Status = $passed
        Result = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
