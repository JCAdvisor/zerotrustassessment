<#
.SYNOPSIS

#>

function Test-Assessment-21895{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Alto',
    	Pillar = 'Identidade',
    	RiskLevel = 'Baixo',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21895,
    	Title = 'As credenciais de certificado de aplicativo são gerenciadas usando HSM',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    $activity = "Verificando se as credenciais de certificado de aplicativo são gerenciadas usando HSM"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result


    Add-ZtTestResultDetail -TestId '21895' -Title "As credenciais de certificado de aplicativo são gerenciadas usando HSM" `
        -UserImpact Low -Risk Low -ImplementationCost High `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
