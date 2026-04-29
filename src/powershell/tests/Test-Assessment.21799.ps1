<#
.SYNOPSIS

#>

function Test-Assessment-21799 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P2'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Acelerar resposta e remediação',
    	TenantType = ('Workforce','External'),
    	TestId = 21799,
    	Title = 'Restringir logons de alto risco',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP2) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP2
        return
    }

    $activity = "Verificando o bloqueio de logons de alto risco"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $authMethodPolicy = Invoke-ZtGraphRequest -RelativeUri "policies/authenticationMethodsPolicy" -ApiVersion 'v1.0'
    $allCAPolicies = Invoke-ZtGraphRequest -RelativeUri "identity/conditionalAccess/policies" -ApiVersion 'v1.0'
    
    $matchedPolicies = $allCAPolicies | Where-Object {
        $_.conditions.signInRiskLevels -contains "high" -and $_.state -eq "enabled"
    }

    $passed = ($matchedPolicies | Measure-Object).Count -gt 0

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: Existem políticas de Acesso Condicional ativas visando logons de alto risco.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ **Falha**: Alguns logons de alto risco não são mitigados adequadamente por políticas de Acesso Condicional.`n`n%TestResult%"
    }

    $reportTitle = "Políticas de Acesso Condicional para Risco de Logon"
    $tableRows = ""

    if ($matchedPolicies.Count -gt 0) {
        $formatTemplate = @'
## {0}

| Nome da Política | Controles de Concessão | Usuários Alvo |
| :---------- | :------------- | :------------- |
{1}
'@
        foreach ($policy in $matchedPolicies) {
            $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/{0}" -f $policy.id
            $grantControls = switch ($policy.grantControls) {
                {$_.builtInControls -contains 'block'} { "Bloquear Acesso" }
                {$_.builtInControls -contains 'mfa'} { "Exigir MFA" }
                {$null -ne $_.authenticationStrength} { "Exigir Força de Autenticação" }
            }

            $targetUsers = if ($policy.conditions.users.includeUsers -contains 'All') { "Todos os Usuários" }
            else { $policy.conditions.users.includeUsers -join ', ' }

            $tableRows += "| [$(Get-SafeMarkdown($policy.displayName))]($portalLink) | $grantControls | $targetUsers |`n"
        }
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    Add-ZtTestResultDetail -TestId '21799' -Status $passed -Result $testResultMarkdown
}
