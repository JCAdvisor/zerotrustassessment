<#
.SYNOPSIS

#>

function Test-Assessment-21992{
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Alto',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21992,
    	Title = 'Certificados de aplicativos devem ser rotacionados regularmente',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )
    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose
    $sqlApp = @"
    select distinct ON (id) * from
        (select id, appId, displayName, signInAudience,
        try_cast(unnest(keyCredentials).startDateTime as date) as keyStartDateTime,
        current_date - interval 180 day minStartDate
        from Application)
    where keyStartDateTime < minStartDate
    order by displayName, keyStartDateTime DESC
"@
    $sqlSP = @"
    select distinct ON (id) * from
        (select id, appId, displayName, appOwnerOrganizationId, signInAudience,
        try_cast(unnest(keyCredentials).startDateTime as date) as keyStartDateTime,
        current_date - interval 180 day minStartDate
        from ServicePrincipal)
    where keyStartDateTime < minStartDate
    order by displayName, keyStartDateTime DESC
"@
    $resultsApp = Invoke-DatabaseQuery -Database $Database -Sql $sqlApp
    $resultsSP = Invoke-DatabaseQuery -Database $Database -Sql $sqlSP

    $passed = ($resultsApp.Count -eq 0) -and ($resultsSP.Count -eq 0)
    if ($passed) {
        $testResultMarkdown += "Certificados para aplicativos em seu tenant (tenant) foram emitidos nos últimos 180 dias."
    }
    else {
        $testResultMarkdown += "Encontrados $($resultsApp.Count) aplicativos e $($resultsSP.Count) entidades de serviço em seu tenant com certificados que não foram rotacionados nos últimos 180 dias.`n`n%TestResult%"
    }
    if ($resultsApp.Count -gt 0) {
        $mdInfo = "`n## Aplicativos com certificados que não foram rotacionados nos últimos 180 dias`n`n"
        $mdInfo += "| Aplicativo | Data de Início do Certificado |`n"
        $mdInfo += "| :--- | :--- |`n"
        foreach ($item in $resultsApp) {
            $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Credentials/appId/{0}" -f $item.appId
            $mdInfo += "| [$(Get-SafeMarkdown($item.displayName))]($portalLink) | $(Get-FormattedDate($item.keyStartDateTime)) |`n"
        }
    }
    if ($resultsSP.Count -gt 0) {
        $mdInfo += "`n`n## Entidades de serviço com certificados que não foram rotacionados nos últimos 180 dias`n`n"
        $mdInfo += "| Entidade de serviço | tenant proprietário | Data de Início do Certificado |`n"
        $mdInfo += "| :--- | :--- | :--- |`n"
        foreach ($item in $resultsSP) {
            $tenant = Get-ZtTenant -tenantId $item.appOwnerOrganizationId
            $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/SignOn/objectId/$($item.id)/appId/$($item.appId)/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/"
            $mdInfo += "| [$(Get-SafeMarkdown($item.displayName))]($portalLink) | $(Get-SafeMarkdown($tenant.displayName)) | $(Get-FormattedDate($item.keyStartDateTime)) |`n"
        }
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21992'
        Title              = 'Certificados de aplicativos precisam ser rotacionados regularmente'
        UserImpact         = 'Low'
        Risk               = 'High'
        ImplementationCost = 'Alto'
        AppliesTo          = 'Identity'
        Tag                = 'Identity'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
