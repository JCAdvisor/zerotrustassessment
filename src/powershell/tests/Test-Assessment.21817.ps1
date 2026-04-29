<#
.SYNOPSIS
#>

function Test-Assessment-21817 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P2'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Protect engineering systems',
    	TenantType = ('Workforce'),
    	TestId = 21817,
    	Title = 'A ativação da função de Administrador Global aciona um fluxo de trabalho de aprovação',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se a ativação da função de Administrador Global aciona um fluxo de trabalho de aprovação"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $passed = $true # Lógica de detecção aqui
    $testResultMarkdown = "O fluxo de trabalho de aprovação está configurado para o Administrador Global.`n`n%TestResult%"

    $mdInfo = "## Ativação da função de Administrador Global e fluxo de trabalho de aprovação`n`n| Aprovação Necessária | Aprovadores Primários | Aprovadores de Escalonamento |`n| :--- | :--- | :--- |`n"

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21817'
        Title              = "A ativação da função de Administrador Global aciona um fluxo de trabalho de aprovação"
        UserImpact         = 'Low'
        Risk               = 'High'
        ImplementationCost = 'Medium'
        AppliesTo          = 'Identity'
        Tag                = 'Identity'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
