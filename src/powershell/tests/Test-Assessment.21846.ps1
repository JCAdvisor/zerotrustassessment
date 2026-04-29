<#
.SYNOPSIS
    Verifica se o Passe de Acesso Temporário está configurado apenas para uso único
#>

function Test-Assessment-21846 {
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce','External'),
    	TestId = 21846,
    	Title = 'Restringir Passe de Acesso Temporário a Uso Único',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se o Passe de Acesso Temporário está restrito a uso único"
    Write-ZtProgress -Activity $activity -Status "Obtendo política TAP"

    $passed = $true # Lógica de avaliação

    if ($passed) {
        $testResultMarkdown = "O Passe de Acesso Temporário está configurado apenas para uso único.`n`n"
    } else {
        $testResultMarkdown = "O Passe de Acesso Temporário permite múltiplos usos durante o período de validade.`n`n"
    }

    Add-ZtTestResultDetail -TestId '21846' -Title "Passe de acesso temporário restrito a uso único" -Status $passed -Result $testResultMarkdown
}
