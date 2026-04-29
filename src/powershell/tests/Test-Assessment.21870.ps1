<#
.SYNOPSIS
#>

function Test-Assessment-21870{
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21870,
    	Title = 'Habilitar redefinição de senha de autoatendimento (SSPR)',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se o SSPR está habilitado"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result

    Add-ZtTestResultDetail -TestId '21870' -Title "Habilitar SSPR" `
        -UserImpact Baixo -Risk Baixo -ImplementationCost Baixo `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
