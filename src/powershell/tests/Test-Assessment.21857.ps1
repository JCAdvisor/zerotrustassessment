<#
.SYNOPSIS
#>

function Test-Assessment-21857{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Médio',
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21857,
    	Title = 'Identidades de convidados têm o ciclo de vida gerenciado com revisões de acesso',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se identidades de convidados têm o ciclo de vida gerenciado com revisões de acesso"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result

    Add-ZtTestResultDetail -TestId '21857' -Title "Identidades de convidados têm o ciclo de vida gerenciado com revisões de acesso" `
        -UserImpact Baixo -Risk Médio -ImplementationCost Médio `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
