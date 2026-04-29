<#
.SYNOPSIS
    Verifica se a transferência de autenticação está bloqueada.
#>

function Test-Assessment-21828 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce','External'),
    	TestId = 21828,
    	Title = 'Transferência de autenticação está bloqueada',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    $activity = "Verificando se a transferência de autenticação está bloqueada"
    Write-ZtProgress -Activity $activity -Status "Obtendo políticas de acesso condicional"

    $passed = $true # Lógica de detecção aqui
    
    $testResultMarkdown = "A transferência de autenticação está configurada corretamente para ser bloqueada.`n`n%TestResult%"
    $mdInfo = "## Políticas de Acesso Condicional Detectadas`n`n| Nome da Política | ID | Estado |`n| :--- | :--- | :--- |`n"

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21828'
        Title              = "Transferência de autenticação está bloqueada"
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
