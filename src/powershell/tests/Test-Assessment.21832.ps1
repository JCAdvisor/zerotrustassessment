<#
.SYNOPSIS
#>

function Test-Assessment-21832 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
        MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce'),
    	TestId = 21832,
    	Title = 'Todos os grupos em políticas de Acesso Condicional pertencem a uma unidade administrativa de gerenciamento restrito',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    $activity = "Verificando se grupos em políticas de Acesso Condicional pertencem a UA restrita"
    Write-ZtProgress -Activity $activity -Status "Obtendo políticas"

    $passed = $false
    $testResultMarkdown = "Planejado para uma versão futura."

    Add-ZtTestResultDetail -TestId '21832' -Title "Todos os grupos em políticas de Acesso Condicional pertencem a uma unidade administrativa de gerenciamento restrito" `
        -UserImpact Low -Risk Medium -ImplementationCost Low `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
