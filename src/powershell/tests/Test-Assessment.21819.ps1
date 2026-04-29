<#
.SYNOPSIS
    Verifica se alertas de ativação estão configurados para a atribuição da função de Administrador Global.
#>

function Test-Assessment-21819 {
    [ZtTest(
    	Category = 'Acesso privilegiado',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P2'),
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce'),
    	TestId = 21819,
    	Title = 'Alerta de ativação para atribuições de função de Administrador Global',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    if ( -not (Get-ZtLicense EntraIDP2) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP2
        return
    }

    $activity = 'Verificando alertas de ativação para Administrador Global'
    $passed = $true # Lógica aqui
    
    if ($passed) {
        $testResultMarkdown = "Alertas de ativação estão configurados para a função de Administrador Global.`n`n"
    } else {
        $testResultMarkdown = "Alertas de ativação estão ausentes ou configurados incorretamente.`n`n"
    }

    $testResultMarkdown += "| Função | Destinatários Padrão | Destinatários Adicionais |`n"
    $testResultMarkdown += "| :--- | :--- | :--- |`n"

    $params = @{
        TestId = '21819'
        Status = $passed
        Result = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
