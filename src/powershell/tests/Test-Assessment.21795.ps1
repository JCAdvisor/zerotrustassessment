<#
.SYNOPSIS

#>

function Test-Assessment-21795{
    [ZtTest(
    	Category = 'Monitoramento',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Monitorar e detectar ciberameaças',
    	TenantType = ('Workforce'),
    	TestId = 21795,
    	Title = 'Nenhuma atividade de logon por autenticação legada',
    	UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando ausência de atividade de logon por autenticação legada"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result

    Add-ZtTestResultDetail -TestId '21795' -Title "Nenhuma atividade de logon por autenticação legada" `
        -UserImpact High -Risk Medium -ImplementationCost Low `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
