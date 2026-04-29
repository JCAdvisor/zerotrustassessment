<#
.SYNOPSIS

#>

function Test-Assessment-21792 {
    [ZtTest(
    	Category = 'Colaboração externa',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 21792,
    	Title = 'Convidados possuem acesso restrito a objetos do diretório',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $guestRestrictedRoleId = "2af84b1e-32c8-42b7-82bc-daa82404023b"
    $result = Invoke-ZtGraphRequest -RelativeUri "policies/authorizationPolicy"
    $passed = $result.guestUserRoleId -eq $guestRestrictedRoleId

    if ($passed) {
        $testResultMarkdown = "✅ Validado que o acesso de usuários convidados está restrito."
    }
    else {
        $testResultMarkdown = "❌ O acesso de usuários convidados não está restrito."
    }

    Add-ZtTestResultDetail -TestId '21792' -Status $passed -Result $testResultMarkdown
}
