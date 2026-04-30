<#
.SYNOPSIS

#>

function Test-Assessment-21984{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	Pillar = 'Identidade',
    	RiskLevel = 'Baixo',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21984,
    	Title = 'Nenhuma recomendação do Entra de baixa prioridade ativa encontrada',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    $activity = "Verificando se há recomendações do Entra de baixa prioridade ativas"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result


    Add-ZtTestResultDetail -TestId '21984' -Title "Nenhuma recomendação do Entra de baixa prioridade ativa encontrada" `
        -UserImpact Low -Risk Low -ImplementationCost Low `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}