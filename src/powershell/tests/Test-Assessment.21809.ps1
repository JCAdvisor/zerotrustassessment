<#
.SYNOPSIS

#>

function Test-Assessment-21809 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21809,
    	Title = 'Fluxo de trabalho de consentimento do administrador está habilitado',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando se o fluxo de trabalho de consentimento do administrador está habilitado"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = Invoke-ZtGraphRequest -RelativeUri "policies/adminConsentRequestPolicy" -ApiVersion v1.0
    $passed = $result.isEnabled

    if ($passed) {
        $testResultMarkdown = "O fluxo de trabalho de consentimento do administrador está habilitado.`n`n"
    }
    else {
        $testResultMarkdown = "O fluxo de trabalho de consentimento do administrador está desabilitado.`n`n%TestResult%"
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", "A propriedade adminConsentRequestPolicy.isEnabled está definida como false."

    Add-ZtTestResultDetail -TestId '21809' -Status $passed -Result $testResultMarkdown
}
