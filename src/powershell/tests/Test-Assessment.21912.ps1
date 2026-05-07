<#
.SYNOPSIS

#>

function Test-Assessment-21912{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21912,
    	Title = 'Os recursos do Azure usados pelo Microsoft Entra permitem acesso somente a partir de funções privilegiadas',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se os recursos do Azure usados pelo Microsoft Entra permitem acesso somente a partir de funções privilegiadas"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para lançamento futuro."
    $passed = $result


    Add-ZtTestResultDetail -TestId '21912' -Title "Os recursos do Azure usados pelo Microsoft Entra permitem acesso somente a partir de funções privilegiadas" `
        -UserImpact Low -Risk High -ImplementationCost Low `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
