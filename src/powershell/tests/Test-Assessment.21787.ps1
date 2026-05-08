<#
.SYNOPSIS

#>

function Test-Assessment-21787 {
    [ZtTest(
    	Category = 'Acesso privilegiado',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce'),
    	TestId = 21787,
    	Title = 'As permissões para criar novos tenants são limitadas à função de Criador de tenant',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando se as permissões para criar novos tenants estão limitadas à função de Criador de tenant"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = Invoke-ZtGraphRequest -RelativeUri "policies/authorizationPolicy" -ApiVersion v1.0
    $passed = -not $result.defaultUserRolePermissions.allowedToCreateTenants

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: Usuários não privilegiados estão restritos de criar novos tenants.`n`n"
    }
    else {
        $testResultMarkdown = "❌ **Falha**: Usuários não privilegiados têm permissão para criar novos tenants.`n`n"
    }

    Add-ZtTestResultDetail -TestId '21787' -Status $passed -Result $testResultMarkdown
}
