<#
.SYNOPSIS

#>

function Test-Assessment-21887{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Médio',
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21887,
    	Title = 'URIs de redirecionamento registradas devem ter registros DNS e propriedades adequadas',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se URIs de redirecionamento registradas possuem registros DNS e propriedades adequadas"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para lançamento futuro."
    $passed = $result


    Add-ZtTestResultDetail -TestId '21887' -Title "URIs de redirecionamento registradas devem ter registros DNS e propriedades adequadas" `
        -UserImpact Low -Risk Medium -ImplementationCost Medium `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
