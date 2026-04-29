<#
.SYNOPSIS
    Verifica se Identidades de Carga de Trabalho não possuem funções privilegiadas atribuídas
#>

function Test-Assessment-21836 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Protect engineering systems',
    	TenantType = ('Workforce','External'),
    	TestId = 21836,
    	Title = 'Identidades de Carga de Trabalho não possuem funções privilegiadas atribuídas',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando identidades de carga de trabalho com funções privilegiadas"
    Write-ZtProgress -Activity $activity -Status "Obtendo identidades"

    $passed = $true # Lógica aqui
    $testResultMarkdown = "## Identidades de Carga de Trabalho com Funções Privilegiadas`n`n| Nome | Função | Tipo de Atribuição |`n| :--- | :--- | :--- |`n"

    Add-ZtTestResultDetail -Status $passed -Result $testResultMarkdown
}
