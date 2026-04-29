<#
.SYNOPSIS
#>

function Test-Assessment-21810 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Protect engineering systems',
    	TenantType = ('Workforce','External'),
    	TestId = 21810,
    	Title = 'O consentimento específico do recurso está restrito',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se o Consentimento Específico do Recurso está restrito"
    Write-ZtProgress -Activity $activity -Status "Obtendo status do consentimento específico do recurso"

    $result = Get-MgBetaTeamRscConfiguration

    $testResultMarkdown = ""

    if ($result.State -eq 'EnabledForPreApprovedAppsOnly' -or $result.State -eq 'DisabledForAllApps') {
        $passed = $true
        $testResultMarkdown += "O Consentimento Específico do Recurso está restrito.`n`n%TestResult%"
    }
    else {
        $passed = $false
        $testResultMarkdown += "O Consentimento Específico do Recurso não está restrito.`n`n%TestResult%"
    }

    $mdInfo = "O estado atual é {0}.`n" -f $result.State

    # Substitui o espaço reservado pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21810'
        Title              = "O consentimento específico do recurso está restrito"
        UserImpact         = 'Médio'
        Risk               = 'Médio'
        ImplementationCost = 'Médio'
        AppliesTo          = 'Identity'
        Tag                = 'Identity'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
