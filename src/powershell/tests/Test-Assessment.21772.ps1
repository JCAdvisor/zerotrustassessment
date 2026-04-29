<#
.SYNOPSIS

#>

function Test-Assessment-21772 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Free'),
        Service = ('Graph'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21772,
    	Title = 'Aplicativos não possuem segredos de cliente configurados',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $sqlApp = @"
select distinct ON (id) appId, displayName, signInAudience,
    try_cast(unnest(passwordCredentials).endDateTime as date) as keyEndDateTime
from Application
where passwordCredentials != '[]'
order by displayName, keyEndDateTime DESC
"@

    $sqlSP = @"
select distinct ON (id) appId, displayName, appOwnerOrganizationId, signInAudience,
    try_cast(unnest(passwordCredentials).endDateTime as date) as keyEndDateTime
from ServicePrincipal
where passwordCredentials != '[]'
order by displayName, keyEndDateTime DESC
"@

    $resultsApp = Invoke-DatabaseQuery -Database $Database -Sql $sqlApp
    $resultsSP = Invoke-DatabaseQuery -Database $Database -Sql $sqlSP

    $passed = ($resultsApp.Count -eq 0) -and ($resultsSP.Count -eq 0)

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: Nenhum aplicativo ou entidade de serviço com segredos de cliente configurados foi encontrado.`n`n"
    }
    else {
        $testResultMarkdown = "❌ **Falha**: Foram encontrados aplicativos ou entidades de serviço utilizando segredos de cliente. Recomenda-se o uso de certificados ou identidades gerenciadas.`n`n"
    }

    $mdInfo = ""
    if ($resultsApp.Count -gt 0) {
        $mdInfo += "## Registros de Aplicativos com segredos de cliente`n`n"
        $mdInfo += "| Aplicativo | Expiração do Segredo |`n"
        $mdInfo += "| :--- | :--- |`n"
        foreach ($item in $resultsApp) {
            $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Credentials/appId/{0}" -f $item.appId
            $mdInfo += "| [$(Get-SafeMarkdown($item.displayName))]($portalLink) | $(Get-FormattedDate($item.keyEndDateTime)) |`n"
        }
    }

    if ($resultsSP.Count -gt 0) {
        $mdInfo += "`n`n## Entidades de Serviço com segredos de cliente`n`n"
        $mdInfo += "| Entidade de Serviço | Tenant proprietário | Expiração do Segredo |`n"
        $mdInfo += "| :--- | :--- | :--- |`n"
        foreach ($item in $resultsSP) {
            $tenant = Get-ZtTenant -tenantId $item.appOwnerOrganizationId
            $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/SignOn/objectId/$($item.id)/appId/$($item.appId)/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/"
            $mdInfo += "| [$(Get-SafeMarkdown($item.displayName))]($portalLink) | $(Get-SafeMarkdown($tenant.displayName)) | $(Get-FormattedDate($item.keyEndDateTime)) |`n"
        }
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21772'
        Title              = 'Aplicativos não possuem segredos de cliente configurados'
        UserImpact         = 'Médio'
        Risk               = 'Alto'
        ImplementationCost = 'Médio'
        AppliesTo          = 'Identidade'
        Tag                = 'Identidade'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
