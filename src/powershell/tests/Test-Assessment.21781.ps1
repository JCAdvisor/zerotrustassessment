<#
.SYNOPSIS
    Verifica se os administradores são obrigados a usar autenticação resistente a phishing.
#>

function Test-Assessment-21781 {
    [ZtTest(
    	Category = 'Acesso privilegiado',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Monitorar e detectar ciberameaças',
    	TenantType = ('Workforce'),
    	TestId = 21781,
    	Title = 'Usuários privilegiados fazem logon com métodos resistentes a phishing',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()
    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $passed = $false

    if ($passed) {
        $testResultMarkdown += "Validado que as seguintes contas possuem métodos resistentes a phishing registrados"
    }
    else {
        $testResultMarkdown += "Encontradas contas que não registraram métodos resistentes a phishing`n`n%TestResult%"
    }

    Add-ZtTestResultDetail -TestId '21781' -Title 'Usuários privilegiados fazem logon com métodos resistentes a phishing' `
        -UserImpact Low -Risk High -ImplementationCost Medium `
        -AppliesTo Identity -Tag Authentication `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
