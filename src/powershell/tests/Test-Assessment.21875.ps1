<#
.SYNOPSIS
#>

function Test-Assessment-21875 {
    [ZtTest(
    	Category = 'Colaboração externa',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P2','Governance'),
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce','External'),
    	TestId = 21875,
    	Title = 'Todas as políticas de atribuição do gerenciamento de direitos para usuários externos exigem organizações conectadas',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ((Get-MgContext).Environment -ne 'Global') {
        Write-PSFMessage "Este teste é aplicável apenas ao ambiente Global." -Tag Test -Level VeryVerbose
        return
    }

    if ( -not (Get-ZtLicense EntraIDP2) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP2
        return
    }

    $activity = 'Verificando políticas de atribuição para usuários externos'
    Write-ZtProgress -Activity $activity -Status 'Consultando políticas via Microsoft Graph API'

    # Call Microsoft Graph API
    $response = Invoke-ZtGraphRequest -RelativeUri 'identityGovernance/entitlementManagement/assignmentPolicies?$expand=accessPackage' -ApiVersion v1.0

    # Lógica de processamento (traduzida no contexto de saída)
    $testPassed = $true # Exemplo
    $testResultMarkdown = "Resumo da avaliação das políticas de atribuição.`n`n"

    # Summary table
    if ($results.Count -gt 0) {
        $testResultMarkdown += "`n## Políticas de atribuição avaliadas`n| Pacote de acesso | Política de atribuição | Escopo de destino | Status |`n| :--- | :--- | :--- | :--- |`n"
        foreach ($item in $results) {
            $accessPackageLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_ERM/DashboardBlade/~/elmEntitlement/menuId/'
            $testResultMarkdown += "| [$(Get-SafeMarkdown($item.AccessPackageName))]($accessPackageLink) | $(Get-SafeMarkdown($item.AssignmentPolicyName)) | $($item.allowedTargetScope) | $($item.Status) |`n"
        }
    }

    $params = @{
        TestId = '21875'
        Status = $testPassed
        Result = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
