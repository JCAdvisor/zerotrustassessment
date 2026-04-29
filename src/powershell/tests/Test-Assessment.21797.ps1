<#
.SYNOPSIS
    Verifica se as políticas para restringir acesso a usuários de alto risco estão implementadas corretamente.
#>

function Test-Assessment-21797{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P2'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Acelerar resposta e remediação',
    	TenantType = ('Workforce','External'),
    	TestId = 21797,
    	Title = 'Restringir acesso a usuários de alto risco',
    	UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP2) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP2
        return
    }

    $activity = "Verificando restrição de acesso a usuários de alto risco"
    Write-ZtProgress -Activity $activity -Status "Obtendo políticas"

    $allCAPolicies = Invoke-ZtGraphRequest -RelativeUri "identity/conditionalAccess/policies" -ApiVersion 'v1.0'

    $enabledHighRiskPolicies = $allCAPolicies | Where-Object {
        $_.state -eq "enabled" -and 
        $_.conditions.userRiskLevels -contains "high" -and 
        ($_.grantControls.builtInControls -contains "passwordChange" -or $_.grantControls.builtInControls -contains "block")
    }

    $passed = ($enabledHighRiskPolicies | Measure-Object).Count -gt 0
    
    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: Existem políticas ativas para usuários de alto risco.`n`n%TestResult%"
    } else {
        $testResultMarkdown = "❌ **Falha**: Não foram encontradas políticas habilitadas para restringir acesso de usuários de alto risco.`n`n%TestResult%"
    }

    $mdInfo = "### Detalhes das Políticas`n`n"
    foreach ($policy in $enabledHighRiskPolicies) {
        $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/{0}" -f $policy.id
        $mdInfo += "| [$(Get-SafeMarkdown($policy.displayName))]($portalLink) | Habilitada |`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    Add-ZtTestResultDetail -TestId '21797' -Status $passed -Result $testResultMarkdown
}
