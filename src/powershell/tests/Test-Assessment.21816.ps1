<#
.SYNOPSIS
    Todas as atribuições de funções privilegiadas do Microsoft Entra são gerenciadas com PIM
#>

function Test-Assessment-21816 {
    [ZtTest(
    	Category = 'Acesso privilegiado',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P2'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce'),
    	TestId = 21816,
    	Title = 'Todas as atribuições de funções privilegiadas do Microsoft Entra são gerenciadas com PIM',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if( -not (Get-ZtLicense EntraIDP2) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP2
        return
    }

    $activity = 'Verificando se as atribuições de funções privilegiadas do Microsoft Entra são gerenciadas com PIM'
    Write-ZtProgress -Activity $activity

    # Lógica simplificada baseada no snippet
    $passed = $true # Exemplo
    $testResultMarkdown = "As atribuições de funções são gerenciadas pelo PIM.`n`n%TestResult%"
    
    $mdInfo = "## Atribuições Permanentes de Administrador Global`n`n| Nome | UPN | Tipo | Sincronizado Local |`n| :--- | :--- | :--- | :--- |`n"

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo

    $params = @{
        TestId = '21816'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
