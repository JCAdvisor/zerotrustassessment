<#
.SYNOPSIS
#>

function Test-Assessment-21834 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	Pillar = 'Identity',
    	RiskLevel = 'Baixo',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce'),
    	TestId = 21834,
    	Title = 'Conta de sincronização do diretório restrita a um local nomeado específico',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se a conta de sincronização está restrita por local"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $passed = $false
    $testResultMarkdown = "Planejado para uma versão futura."

    Add-ZtTestResultDetail -TestId '21834' -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
