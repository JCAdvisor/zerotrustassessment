<#
.SYNOPSIS
#>

function Test-Assessment-21821{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Médio',
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce'),
    	TestId = 21821,
    	Title = 'O acesso de convidados está restrito',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se o acesso de convidados está restrito"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $false

    Add-ZtTestResultDetail -TestId '21821' -Title "O acesso de convidados está restrito" `
        -UserImpact Medium -Risk Medium -ImplementationCost Medium `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
