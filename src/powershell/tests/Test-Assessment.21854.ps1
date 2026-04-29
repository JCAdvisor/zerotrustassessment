<#
.SYNOPSIS
#>

function Test-Assessment-21854{
    [ZtTest(
    	Category = 'Acesso privilegiado',
    	ImplementationCost = 'Médio',
    	MinimumLicense = $null,
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21854,
    	Title = 'Funções privilegiadas não são atribuídas a identidades obsoletas',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se funções privilegiadas não estão atribuídas a identidades obsoletas"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result

    Add-ZtTestResultDetail -TestId '21854' -Title "Funções privilegiadas não são atribuídas a identidades obsoletas" `
        -UserImpact Baixo -Risk Médio -ImplementationCost Médio `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
