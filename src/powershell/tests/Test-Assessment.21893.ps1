<#
.SYNOPSIS

#>

function Test-Assessment-21893{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P2'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Baixo',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21893,
    	Title = 'Todos os usuários devem se registrar para MFA',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    $activity = "Verificando a ativação da política do Microsoft Entra ID Protection para exigir o registro de autenticação multifator"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result


    Add-ZtTestResultDetail -TestId '21893' -Title "Habilitar política do Microsoft Entra ID Protection para exigir o registro de autenticação multifator" `
        -UserImpact Medium -Risk Low -ImplementationCost Medium `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
