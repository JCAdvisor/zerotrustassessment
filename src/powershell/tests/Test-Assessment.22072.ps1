<#
.SYNOPSIS

#>

function Test-Assessment-22072{
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 22072,
    	Title = 'Redefinição de senha por autoatendimento não usa perguntas de segurança',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    $activity = "Verificando se a Redefinição de Senha por Autoatendimento não utiliza Perguntas e Respostas"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result


    Add-ZtTestResultDetail -TestId '22072' -Title "Redefinição de Senha por Autoatendimento não utiliza Perguntas e Respostas" `
        -UserImpact Medium -Risk Medium -ImplementationCost Medium `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}