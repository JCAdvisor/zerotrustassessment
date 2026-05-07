<#
.SYNOPSIS

#>

function Test-Assessment-21894{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Médio',
    	Pillar = 'Identidade',
    	RiskLevel = 'Baixo',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21894,
    	Title = 'Todos os certificados de Registros de Aplicativos e Entidades de Serviço do Microsoft Entra devem ser emitidos por uma autoridade de certificação aprovada',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    $activity = "Verificando se todos os certificados de Registros de Aplicativos e Entidades de Serviço do Microsoft Entra são emitidos por uma autoridade de certificação aprovada"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result


    Add-ZtTestResultDetail -TestId '21894' -Title "Todos os certificados de Registros de Aplicativos e Entidades de Serviço do Microsoft Entra devem ser emitidos por uma autoridade de certificação aprovada" `
        -UserImpact Low -Risk Low -ImplementationCost Medium `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
