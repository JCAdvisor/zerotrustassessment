<#
.SYNOPSIS

#>

function Test-Assessment-21778{
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Alto',
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = '',
    	TenantType = ('Workforce','External'),
    	TestId = 21778,
    	Title = 'Aplicativos de linha de negócio e parceiros usam MSAL',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando se aplicativos de linha de negócio e parceiros usam MSAL"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para uma versão futura."
    $passed = $result

    Add-ZtTestResultDetail -TestId '21778' -Title "Aplicativos de linha de negócio e parceiros usam MSAL" `
        -UserImpact Low -Risk Medium -ImplementationCost High `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
