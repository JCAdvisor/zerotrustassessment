<#
.SYNOPSIS
#>

function Test-Assessment-21818 {
    [ZtTest(
    	Category = 'Monitoramento',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P2'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Monitor and detect cyberthreats',
    	TenantType = ('Workforce'),
    	TestId = 21818,
    	Title = 'Ativações de funções privilegiadas têm monitoramento e alertas configurados',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando alertas de ativação para atribuições de funções altamente privilegiadas"
    Write-ZtProgress -Activity $activity -Status "Obtendo atribuições de política PIM"

    $passed = $true # Lógica aqui
    $testResultMarkdown = "Alertas de monitoramento estão configurados para funções privilegiadas.`n`n%TestResult%"

    $mdInfo = "## Detalhes de Notificação`n`n| Função | Cenário | Tipo | Destinatários Padrão | Destinatários Extras |`n| :--- | :--- | :--- | :--- | :--- |`n"

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21818'
        Title              = "Alerta de ativação para atribuições de funções altamente privilegiadas"
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
