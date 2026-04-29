<#
.SYNOPSIS
    O autoatendimento para inscrição de convidados via fluxo de usuário está desativado
#>

function Test-Assessment-21823{
    [ZtTest(
    	Category = 'Colaboração externa',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Protect tenants and isolate production systems',
    	TenantType = ('Workforce'),
    	TestId = 21823,
    	Title = 'O autoatendimento para inscrição de convidados via fluxo de usuário está desativado',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se o autoatendimento para inscrição de convidados via fluxo de usuário está desativado"
    Write-ZtProgress -Activity $activity

    $passed = $true # Lógica aqui

    if ($passed) {
        $testResultMarkdown = "O autoatendimento para inscrição de convidados via fluxo de usuário está desativado.`n"
    } else {
        $testResultMarkdown = "O autoatendimento para inscrição de convidados via fluxo de usuário está ativado.`n"
    }

    $params = @{
        TestId = '21823'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
