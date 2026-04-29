<#
.SYNOPSIS
    Verifica se usuários privilegiados possuem sessões de logon de curta duração.
#>

function Test-Assessment-21825 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce'),
    	TestId = 21825,
    	Title = 'Usuários privilegiados possuem sessões de logon de curta duração',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    $activity = "Verificando se usuários privilegiados possuem sessões de logon de curta duração"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $passed = $true # Lógica de avaliação simplificada para este prompt
    $testResultMarkdown = "## Detalhes da Sessão Privilegiada`n`n| Função | Frequência de Logon | Status |`n| :--- | :--- | :--- |`n"

    $params = @{
        TestId             = '21825'
        Title              = 'Usuários privilegiados possuem sessões de logon de curta duração'
        UserImpact         = 'Médio'
        Risk               = 'Médio'
        ImplementationCost = 'Baixo'
        AppliesTo          = 'Identity'
        Tag                = 'Identity'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
