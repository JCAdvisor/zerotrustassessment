<#
.SYNOPSIS
    Verifica se um usuário convidado não pode convidar outros convidados.
#>

function Test-Assessment-21791{
    [ZtTest(
    	Category = 'Colaboração externa',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 21791,
    	Title = 'Convidados não podem convidar outros convidados',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $result = Invoke-ZtGraphRequest -RelativeUri "policies/authorizationPolicy" -ApiVersion v1.0
    $passed = $result.allowInvitesFrom -ne "everyone"

    if ($passed) {
        $testResultMarkdown = "O locatário restringe quem pode convidar convidados.`n`n"
    } else {
        $testResultMarkdown = "O locatário permite que qualquer usuário (incluindo outros convidados) convide novos convidados."
    }

    Add-ZtTestResultDetail -TestId '21791' -Status $passed -Result $testResultMarkdown
}
