<#
.SYNOPSIS

#>

function Test-Assessment-21897{
    [ZtTest(
    	Category = 'Access control',
    	ImplementationCost = 'High',
    	Pillar = 'Identity',
    	RiskLevel = 'Medium',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce','External'),
    	TestId = 21897,
    	Title = 'Toda atribuição de aplicativo e associação de grupo é governada',
    	UserImpact = 'High'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    $activity = "Verificando se toda atribuição de aplicativo e associação de grupo é governada"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result


    Add-ZtTestResultDetail -TestId '21897' -Title "Toda atribuição de aplicativo e associação de grupo é governada" `
        -UserImpact High -Risk Medium -ImplementationCost High `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
