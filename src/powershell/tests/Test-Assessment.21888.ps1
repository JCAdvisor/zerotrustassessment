<#
.SYNOPSIS
    Verifica se os registros de aplicativos não possuem URIs de redirecionamento com domínios pendentes ou abandonados.
#>

function Test-Assessment-21888{
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger sistemas de engenharia',
    	TenantType = ('Workforce','External'),
    	TestId = 21888,
    	Title = 'Registros de aplicativos não devem ter URIs de redirecionamento de domínios pendentes ou abandonados',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Database
    )

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se os registros de aplicativos possuem URIs de redirecionamento pendentes"
    Write-ZtProgress -Activity $activity -Status "Analisando políticas"

    $results = Get-ZtAppWithUnsafeRedirectUris -Database $Database -Type 'Application' -DnsCheckOnly

    $passed = $results.Passed
    $testResultMarkdown = $results.TestResultMarkdown


    Add-ZtTestResultDetail -TestId '21888' -Title "Registros de aplicativos não devem ter URIs de redirecionamento de domínios pendentes ou abandonados" `
        -UserImpact Low -Risk High -ImplementationCost Low `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown
}
