<#
.SYNOPSIS

#>

function Test-Assessment-21898{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Alto',
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21898,
    	Title = 'Todos os recursos de ciclo de vida de acesso suportados são gerenciados com pacotes de gerenciamento de direitos',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando todos os recursos de ciclo de vida de acesso suportados gerenciados com pacotes de gerenciamento de direitos"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para lançamento futuro."
    $passed = $result


    Add-ZtTestResultDetail -TestId '21898' -Title "Todos os recursos de ciclo de vida de acesso suportados são gerenciados com pacotes de gerenciamento de direitos" `
        -UserImpact Medium -Risk Medium -ImplementationCost High `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
