<#
.SYNOPSIS

#>

function Test-Assessment-21890{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21890,
    	Title = 'Exigir notificações de redefinição de senha para funções de usuário',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se notificações de redefinição de senha são exigidas para funções de usuário"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para lançamento futuro."
    $passed = $result


    Add-ZtTestResultDetail -TestId '21890' -Title "Exigir notificações de redefinição de senha para funções de usuário" `
        -UserImpact Medium -Risk Medium -ImplementationCost Low `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
