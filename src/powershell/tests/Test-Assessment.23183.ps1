<#
.SYNOPSIS
    Verifica se os registros de aplicativos não possuem URLs de resposta contendo *.azurewebsites.net
#>

function Test-Assessment-23183 {
    [ZtTest(
    	Category = 'Gestão de aplicativos',
    	ImplementationCost = 'Alto',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger sistemas de engenharia',
    	TenantType = ('Workforce','External'),
    	TestId = 23183,
    	Title = 'Principais de serviço usam URIs de redirecionamento seguros',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param($Database)

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    $activity = "Verificando se principais de serviço usam URIs de redirecionamento seguros"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"


    $results = Get-ZtAppWithUnsafeRedirectUris -Database $Database -Type 'ServicePrincipal'

    $passed = $results.Passed
    $testResultMarkdown = $results.TestResultMarkdown

    Add-ZtTestResultDetail -TestId '23183' -Title "Principais de serviço usam URIs de redirecionamento seguros" `
        -UserImpact Low -Risk High -ImplementationCost High `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown
}