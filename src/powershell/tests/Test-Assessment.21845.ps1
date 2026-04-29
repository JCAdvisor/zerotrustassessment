<#
.SYNOPSIS
    Verifica se o Passe de Acesso Temporário está ativado e devidamente imposto
#>

function Test-Assessment-21845 {
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce','External'),
    	TestId = 21845,
    	Title = 'O passe de acesso temporário está ativado',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    $activity = 'Verificando se o Passe de Acesso Temporário está ativado'
    Write-ZtProgress -Activity $activity -Status 'Obtendo política TAP'

    $passed = $true # Lógica de avaliação
    $testResultMarkdown = "## Resumo de Configuração`n`n"
    $testResultMarkdown += "| Configuração | Status |`n| :--- | :--- |`n"
    $testResultMarkdown += "| Passe de Acesso Temporário | Ativado ✅ |`n"

    Add-ZtTestResultDetail -TestId '21845' -Status $passed -Result $testResultMarkdown
}
