<#
.SYNOPSIS

#>

function Test-Assessment-21804 {
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21804,
    	Title = 'Métodos de autenticação SMS e Chamada de Voz estão desabilitados',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando se métodos de autenticação fracos estão desabilitados"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $authMethodsPolicy = Invoke-ZtGraphRequest -RelativeUri "policies/authenticationMethodsPolicy" -ApiVersion 'v1.0'
    $matchedMethods = $authMethodsPolicy.authenticationMethodConfigurations | Where-Object { $_.id -eq 'Sms' -or $_.id -eq 'Voice' }

    $testResultMarkdown = ""

    if ($matchedMethods.state -contains 'enabled') {
        $passed = $false
        $testResultMarkdown += "Foram encontrados métodos de autenticação fracos que ainda estão habilitados.`n`n%TestResult%"
    }
    else {
        $passed = $true
        $testResultMarkdown += "Os métodos de autenticação SMS e chamadas de voz estão desabilitados no locatário.`n`n%TestResult%"
    }

    $reportTitle = "Métodos de autenticação fracos"
    $tableRows = ""

    $formatTemplate = @'
## {0}
| ID do Método | O método é fraco? | Estado |
| :-------- | :-------------- | :---- |
{1}
'@

    foreach ($method in $matchedMethods) {
        $tableRows += "| $($method.id) | Sim | $((Get-Culture).TextInfo.ToTitleCase($method.state.ToLower())) |`n"
    }

    $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21804'
        Title              = "Métodos de autenticação fracos estão desabilitados"
        UserImpact         = 'Médio'
        Risk               = 'Alto'
        ImplementationCost = 'Médio'
        AppliesTo          = 'Identidade'
        Tag                = 'Identidade'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
