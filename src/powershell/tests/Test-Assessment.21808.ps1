<#
.SYNOPSIS
    Verifica se o fluxo de código do dispositivo está restrito no locatário.
#>

function Test-Assessment-21808 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21808,
    	Title = 'Restringir o fluxo de código do dispositivo',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    $activity = "Verificando restrição do fluxo de código do dispositivo"
    Write-ZtProgress -Activity $activity -Status "Obtendo políticas de Acesso Condicional"

    $allCAPolicies = Invoke-ZtGraphRequest -RelativeUri "identity/conditionalAccess/policies" -ApiVersion 'beta'

    $enabledPolicies = $allCAPolicies | Where-Object { $_.state -eq 'enabled' }
    
    $deviceCodeFlowPolicies = $enabledPolicies | Where-Object {
        $_.conditions.authenticationFlows.transferMethod -contains 'deviceCodeFlow'
    }

    $passed = $deviceCodeFlowPolicies.Count -gt 0

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: O fluxo de código do dispositivo está restrito por políticas de Acesso Condicional.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ **Falha**: Nenhuma política ativa restringindo o fluxo de código do dispositivo foi encontrada.`n`n%TestResult%"
    }

    $mdInfo = "## Políticas de Acesso Condicional`n`n"
    if ($deviceCodeFlowPolicies.Count -gt 0) {
        $mdInfo += "| Política | Estado | Usuários | Recursos | Controles |`n"
        $mdInfo += "| :--- | :--- | :--- | :--- | :--- |`n"
        foreach ($policy in $deviceCodeFlowPolicies) {
            $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/{0}" -f $policy.id
            $mdInfo += "| [$(Get-SafeMarkdown($policy.displayName))]($portalLink) | Habilitada | Todos | Todos | Bloquear |`n"
        }
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    Add-ZtTestResultDetail -TestId '21808' -Status $passed -Result $testResultMarkdown
}
