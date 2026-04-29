<#
.SYNOPSIS

#>

function Test-Assessment-21851 {
    [ZtTest(
    	Category = 'Colaboração externa',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 21851,
    	Title = 'O acesso de convidados é protegido por métodos de autenticação forte',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result

    Add-ZtTestResultDetail -TestId '21851' -Title 'Todos os convidados usam métodos de autenticação forte' `
        -UserImpact Médio -Risk Médio -ImplementationCost Médio `
        -AppliesTo Identidade -Tag Aplicativo `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
