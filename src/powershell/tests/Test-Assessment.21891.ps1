<#
.SYNOPSIS

#>

function Test-Assessment-21891{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21891,
    	Title = 'Exigir notificações de redefinição de senha para funções de administrador',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se notificações de redefinição de senha são exigidas para funções de administrador"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para lançamento futuro."
    $passed = $result


    Add-ZtTestResultDetail -TestId '21891' -Title "Exigir notificações de redefinição de senha para funções de administrador" `
        -UserImpact Low -Risk High -ImplementationCost Low `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
