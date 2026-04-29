<#
.SYNOPSIS

#>

function Test-Assessment-21786 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21786,
    	Title = 'A atividade de logon do usuário utiliza proteção de token',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    $activity = "Verificando se a atividade de logon do usuário utiliza proteção de token"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $allCAPolicies = Invoke-ZtGraphRequest -RelativeUri "identity/conditionalAccess/policies" -ApiVersion beta

    $matchedPolicies = $allCAPolicies | Where-Object {
        ($_.conditions.clientAppTypes.Count -eq 1 -and $_.conditions.clientAppTypes[0] -eq "mobileAppsAndDesktopClients") -and
        ($_.conditions.applications.includeApplications -contains "00000002-0000-0000-c000-000000000000")
    }

    $passed = $matchedPolicies.Count -gt 0

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: Foram encontradas políticas de Acesso Condicional exigindo proteção de token.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ **Falha**: Nenhuma política de Acesso Condicional exigindo proteção de token foi encontrada.`n`n%TestResult%"
    }

    $reportTitle = "Políticas de Acesso Condicional visando proteção de token"
    $tableRows = ""

    if ($matchedPolicies.Count -gt 0) {
        $formatTemplate = @'
## {0}

| Nome da Política | ID da Política |
| :---------- | :-------- |
{1}
'@
        foreach ($policy in $matchedPolicies) {
            $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/{0}" -f $policy.id
            $tableRows += "| [$(Get-SafeMarkdown($policy.displayName))]($portalLink) | $($policy.id) |`n"
        }
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }
    else {
        $mdInfo = "Nenhuma política de Acesso Condicional visando proteção de token foi encontrada.`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    Add-ZtTestResultDetail -TestId '21786' -Status $passed -Result $testResultMarkdown
}
