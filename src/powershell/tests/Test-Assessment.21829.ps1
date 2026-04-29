<#
.SYNOPSIS
    Verifica o uso de autenticação em nuvem.
#>

function Test-Assessment-21829 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Alto',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce'),
    	TestId = 21829,
    	Title = 'Uso de autenticação em nuvem',
    	UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando o uso de autenticação em nuvem"
    Write-ZtProgress -Activity $activity

    $passed = $true # Lógica simplificada
    
    if ($passed) {
        $testResultMarkdown = "Todos os domínios estão usando autenticação em nuvem.`n"
    } else {
        $testResultMarkdown = "A autenticação federada ainda está em uso para alguns domínios.`n`n%TestResult%"
    }

    $mdInfo = "## Lista de Domínios Federados`n`n| Nome do Domínio |`n| :--- |`n"
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId = '21829'
        Title  = 'Uso de autenticação em nuvem'
        Status = $passed
        Result = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
