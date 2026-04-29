<#
.SYNOPSIS

#>

function Test-Assessment-21779{
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Médio',
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = '',
    	TenantType = ('Workforce','External'),
    	TestId = 21779,
    	Title = 'Usar versões recentes de Aplicativos Microsoft',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando o uso de versões recentes de Aplicativos Microsoft"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result

    Add-ZtTestResultDetail -TestId '21779' -Title "Usar versões recentes de Aplicativos Microsoft" `
        -UserImpact Low -Risk Medium -ImplementationCost Medium `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
