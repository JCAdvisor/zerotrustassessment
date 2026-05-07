<#
.SYNOPSIS

#>

function Test-Assessment-21881{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Médio',
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21881,
    	Title = 'Assinaturas do Azure usadas pela Governança de Identidade são protegidas consistentemente com as funções da Governança de Identidade',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se as assinaturas do Azure usadas pela Governança de Identidade são protegidas consistentemente com as funções da Governança de Identidade"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para lançamento futuro."
    $passed = $result


    Add-ZtTestResultDetail -TestId '21881' -Title "Assinaturas do Azure usadas pela Governança de Identidade são protegidas consistentemente com as funções da Governança de Identidade" `
        -UserImpact Low -Risk High -ImplementationCost Medium `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
