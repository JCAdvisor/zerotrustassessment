<#
.SYNOPSIS
    Verifica se não há recomendações ativas do Entra com prioridade Média.
#>

function Test-Assessment-21983{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21983,
    	Title = 'Nenhuma recomendação do Entra de prioridade Média ativa encontrada',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando se existem recomendações do Entra com prioridade Média ativas"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result


    Add-ZtTestResultDetail -TestId '21983' -Title "Nenhuma recomendação do Entra de prioridade Média ativa encontrada" `
        -UserImpact Low -Risk Medium -ImplementationCost Low `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}