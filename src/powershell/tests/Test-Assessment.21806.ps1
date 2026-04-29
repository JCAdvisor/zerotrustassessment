<#
.SYNOPSIS

#>

function Test-Assessment-21806 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21806,
    	Title = 'Proteger a página de registro de MFA (Minhas Informações de Segurança)',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    $activity = "Verificando proteção da página de registro de informações de segurança"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $allCAPolicies = Invoke-ZtGraphRequest -RelativeUri 'identity/conditionalAccess/policies' -ApiVersion 'v1.0'

    $matchedPolicies = $allCAPolicies | Where-Object {
        ($_.conditions.applications.includeUserActions -contains 'urn:user:registersecurityinfo') -and
        ($_.conditions.users.includeUsers -contains 'All') -and
        $_.state -eq 'enabled'
    }

    $passed = $matchedPolicies.Count -gt 0

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: Foram encontradas políticas de Acesso Condicional ativas protegendo o registro de informações de segurança.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ **Falha**: Nenhuma política de Acesso Condicional ativa protegendo o registro de informações de segurança foi encontrada.`n`n%TestResult%"
    }

    $reportTitle = "Políticas de Acesso Condicional para Registro de Informações de Segurança"
    $tableRows = ""

    if ($matchedPolicies.Count -gt 0) {
        $formatTemplate = @'
## {0}

| Nome da Política | Ações de Usuário | Controles de Concessão |
| :---------- | :-------------------- | :--------------------- |
{1}
'@
        foreach ($policy in $matchedPolicies) {
            $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/{0}" -f $policy.id
            $tableRows += "| [$(Get-SafeMarkdown($policy.displayName))]($portalLink) | $($policy.conditions.applications.includeUserActions) | $($policy.grantControls.builtInControls -join ', ') |`n"
        }
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }
    else {
        $mdInfo = "Nenhuma política de Acesso Condicional visando o registro de informações de segurança foi encontrada.`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    Add-ZtTestResultDetail -TestId '21806' -Status $passed -Result $testResultMarkdown
}
