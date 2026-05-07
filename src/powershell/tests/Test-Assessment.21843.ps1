<#
.SYNOPSIS
#>

function Test-Assessment-21843 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Alto',
    	Pillar = 'Identidade',
    	RiskLevel = 'Baixo',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 21843,
    	Title = 'Bloquear o módulo legado Microsoft Online PowerShell',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando o bloqueio do módulo legado Microsoft Online PowerShell"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $passed = $false
    $testResultMarkdown = "Planejado para uma versão futura."

    Add-ZtTestResultDetail -TestId '21843' -Title "Bloquear o módulo legado Microsoft Online PowerShell" `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
