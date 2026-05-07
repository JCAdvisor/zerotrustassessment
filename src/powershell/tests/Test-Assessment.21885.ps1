<#
.SYNOPSIS
    Verifica se os registros de aplicativos não possuem URLs de resposta contendo *.azurewebsites.net ou outros formatos inseguros.
#>

function Test-Assessment-21885 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Alto',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger sistemas de engenharia',
    	TenantType = ('Workforce','External'),
    	TestId = 21885,
    	Title = 'Registros de aplicativos usam URIs de redirecionamento seguras',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param($Database)

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se os registros de aplicativos usam URIs de redirecionamento seguras"
    Write-ZtProgress -Activity $activity -Status "Analisando políticas"

    $results = Get-ZtAppWithUnsafeRedirectUris -Database $Database -Type 'Application'

    $passed = $results.Passed
    $testResultMarkdown = $results.TestResultMarkdown

    Add-ZtTestResultDetail -TestId '21885' -Title "Registros de aplicativos usam URIs de redirecionamento seguras" `
        -UserImpact Low -Risk High -ImplementationCost High `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown
}
