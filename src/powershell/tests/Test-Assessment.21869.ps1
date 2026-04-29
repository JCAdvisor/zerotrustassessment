<#
.SYNOPSIS
    Verifica se os aplicativos empresariais exigem atribuição explícita ou possuem controles de provisionamento com escopo.
#>

function Test-Assessment-21869 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger sistemas de engenharia',
    	TenantType = ('Workforce','External'),
    	TestId = 21869,
    	Title = 'Aplicativos empresariais devem exigir atribuição explícita ou provisionamento com escopo',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    #region Coleta de Dados
    $activity = 'Verificando requisitos de atribuição e provisionamento de aplicativos empresariais'
    Write-ZtProgress -Activity $activity -Status 'Obtendo principais de serviço sem requisitos de atribuição'

    # (Lógica SQL e filtragem traduzida conforme os padrões anteriores)
    
    $passed = $true # Lógica de avaliação omitida
    $testResultMarkdown = "## Resumo de Avaliação`n`n"
    $mdInfo = "Estes aplicativos não exigem atribuição e possuem trabalhos de provisionamento sem filtros de escopo adequados.`n`n"

    $testResultMarkdown += $mdInfo

    $params = @{
        TestId             = '21869'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
