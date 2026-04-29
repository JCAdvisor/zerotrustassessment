<#
.SYNOPSIS

#>

function Test-Assessment-21773 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21773,
    	Title = 'Aplicativos não possuem certificados com expiração superior a 180 dias',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $sqlApp = @"
    select distinct ON (id) * from
        (select id, appId, displayName, signInAudience,
        try_cast(unnest(keyCredentials).endDateTime as date) as keyEndDateTime,
        current_date + interval 180 day maxExpiryDate
        from Application)
    where keyEndDateTime > maxExpiryDate
    order by displayName, keyEndDateTime DESC
"@

    $sqlSP = @"
    select distinct ON (id) * from
        (select id, appId, displayName, appOwnerOrganizationId, signInAudience,
        try_cast(unnest(keyCredentials).endDateTime as date) as keyEndDateTime,
        current_date + interval 180 day maxExpiryDate
        from ServicePrincipal)
    where keyEndDateTime > maxExpiryDate
    order by displayName, keyEndDateTime DESC
"@

    $resultsApp = Invoke-DatabaseQuery -Database $Database -Sql $sqlApp
    $resultsSP = Invoke-DatabaseQuery -Database $Database -Sql $sqlSP

    $passed = ($resultsApp.Count -eq 0) -and ($resultsSP.Count -eq 0)

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: Nenhum aplicativo ou entidade de serviço com certificados de longa duração (>180 dias) foi encontrado.`n`n"
    }
    else {
        $testResultMarkdown = "❌ **Falha**: Foram encontrados aplicativos ou entidades de serviço com certificados que expiram em mais de 180 dias.`n`n"
    }

    $mdInfo = ""
    if ($resultsApp.Count -gt 0) {
        $mdInfo += "## Registros de Aplicativos com credenciais de longa duração`n`n"
        $mdInfo += "| Aplicativo | Expiração do Certificado |`n"
        $mdInfo += "| :--- | :--- |`n"
        foreach ($item in $resultsApp) {
            $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Credentials/appId/{0}" -f $item.appId
            $mdInfo += "| [$(Get-SafeMarkdown($item.displayName))]($portalLink) | $(Get-FormattedDate($item.keyEndDateTime)) |`n"
        }
    }

    if ($resultsSP.Count -gt 0) {
        $mdInfo += "`n`n## Entidades de serviço com credenciais de longa duração`n`n"
        $mdInfo += "| Entidade de serviço | Tenant proprietário | Expiração do Certificado |`n"
        $mdInfo += "| :--- | :--- | :--- |`n"
        foreach ($item in $resultsSP) {
            $tenant = Get-ZtTenant -tenantId $item.appOwnerOrganizationId
            $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/SignOn/objectId/$($item.id)/appId/$($item.appId)/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/"
            $mdInfo += "| [$(Get-SafeMarkdown($item.displayName))]($portalLink) | $(Get-SafeMarkdown($tenant.displayName)) | $(Get-FormattedDate($item.keyEndDateTime)) |`n"
        }
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21773'
        Title              = 'Aplicativos não possuem certificados com expiração superior a 180 dias'
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
