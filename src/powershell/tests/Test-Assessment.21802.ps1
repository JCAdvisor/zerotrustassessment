<#
.SYNOPSIS

#>

function Test-Assessment-21802 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21802,
    	Title = 'O aplicativo Microsoft Authenticator exibe contexto de logon',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = 'Verificando se o Authenticator exibe contexto de logon'
    Write-ZtProgress -Activity $activity -Status 'Obtendo política'

    $authenticatorConfig = Invoke-ZtGraphRequest -RelativeUri 'authenticationMethodsPolicy/authenticationMethodConfigurations/MicrosoftAuthenticator' -ApiVersion 'beta'

    $appInfoEnabled = $authenticatorConfig.featureSettings.displayAppInformationRequiredState.state -eq 'enabled'
    $locationInfoEnabled = $authenticatorConfig.featureSettings.displayLocationInformationRequiredState.state -eq 'enabled'
    
    $passed = $appInfoEnabled -and $locationInfoEnabled

    $reportTitle = "Configurações de Contexto do Microsoft Authenticator"
    $appEmoji = if ($appInfoEnabled) { "✅" } else { "❌" }
    $locationEmoji = if ($locationInfoEnabled) { "✅" } else { "❌" }

    $formatTemplate = @"
## {0}

Configurações de Recursos:

$appEmoji **Nome do Aplicativo**
- Status: $((Get-Culture).TextInfo.ToTitleCase($authenticatorConfig.featureSettings.displayAppInformationRequiredState.state.ToLower()))
- Alvo Incluído: $(Get-ztAuthenticatorFeatureSettingTarget -Target $authenticatorConfig.featureSettings.displayAppInformationRequiredState.includeTarget)

$locationEmoji **Localização Geográfica**
- Status: $((Get-Culture).TextInfo.ToTitleCase($authenticatorConfig.featureSettings.displayLocationInformationRequiredState.state.ToLower()))
- Alvo Incluído: $(Get-ztAuthenticatorFeatureSettingTarget -Target $authenticatorConfig.featureSettings.displayLocationInformationRequiredState.includeTarget)
"@

    $mdInfo = $formatTemplate -f $reportTitle
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    Add-ZtTestResultDetail -TestId '21802' -Status $passed -Result $testResultMarkdown
}
