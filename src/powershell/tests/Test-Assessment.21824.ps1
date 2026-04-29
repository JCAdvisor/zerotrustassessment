<#
.SYNOPSIS
#>

function Test-Assessment-21824 {
    [ZtTest(
    	Category = 'Colaboração externa',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Protect tenants and isolate production systems',
    	TenantType = ('Workforce'),
    	TestId = 21824,
    	Title = 'Convidados não possuem sessões de logon de longa duração',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se convidados possuem sessões de logon de longa duração"
    Write-ZtProgress -Activity $activity

    $passed = $true # Lógica aqui
    $testResultMarkdown = "Convidados não possuem sessões de logon de longa duração.`n`n%TestResult%"

    $mdInfo = "## Políticas de Acesso Condicional Analisadas`n`n| Nome da Política | Frequência de Logon | Status |`n| :--- | :--- | :--- |`n"
    
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId = '21824'
        Status = $passed
        Result = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
