<#
.SYNOPSIS

#>

function Test-Assessment-21789{
    [ZtTest(
    	Category = 'Monitoramento',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = $null,
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Monitorar e detectar ciberameaças',
    	TenantType = ('Workforce'),
    	TestId = 21789,
    	Title = 'Eventos de criação de locatário são triados',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando se eventos de criação de locatário são triados"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result

    Add-ZtTestResultDetail -TestId '21789' -Title "Eventos de criação de locatário são triados" `
        -UserImpact Low -Risk Medium -ImplementationCost Low `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
