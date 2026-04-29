<#
.SYNOPSIS

#>

function Test-Assessment-21774 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21774,
    	Title = 'Aplicativos de serviços da Microsoft não possuem credenciais configuradas',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando se aplicativos de serviços da Microsoft não possuem credenciais configuradas"
    Write-ZtProgress -Activity $activity -Status "Obtendo entidades de serviço"

    # Consulta SQL para encontrar entidades de serviço com credenciais de senha
    $sqlPassCreds = @"
    SELECT distinct ON (id)
        id,
        appId,
        displayName,
        appOwnerOrganizationId,
        try_cast(unnest(passwordCredentials).endDateTime as date) as keyEndDateTime
    FROM ServicePrincipal
    WHERE passwordCredentials != '[]' and appOwnerOrganizationId = 'f8cdef31-a31e-4b4a-93e4-5f571e91255a'
    ORDER BY displayName, keyEndDateTime DESC
"@

    # Consulta SQL para encontrar entidades de serviço com credenciais de chave
    $sqlKeyCreds = @"
    SELECT distinct ON (id)
        id,
        appId,
        displayName,
        appOwnerOrganizationId,
        try_cast(unnest(keyCredentials).endDateTime as date) as keyEndDateTime
    FROM ServicePrincipal
    WHERE keyCredentials != '[]' and appOwnerOrganizationId = 'f8cdef31-a31e-4b4a-93e4-5f571e91255a'
    ORDER BY displayName, keyEndDateTime DESC
"@

    $resultsPassCreds = Invoke-DatabaseQuery -Database $Database -Sql $sqlPassCreds
    $resultsKeyCreds = Invoke-DatabaseQuery -Database $Database -Sql $sqlKeyCreds

    $passed = ($resultsPassCreds.Count -eq 0) -and ($resultsKeyCreds.Count -eq 0)

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: Nenhuma credencial personalizada foi encontrada nos aplicativos de serviços da Microsoft.`n`n"
        $mdInfo = "Nenhum aplicativo de serviço da Microsoft com credenciais configuradas foi encontrado."
    }
    else {
        $testResultMarkdown = "❌ **Falha**: Foram encontradas credenciais configuradas em aplicativos de serviços da Microsoft. Isso deve ser investigado.`n`n"
        
        $reportTitle = "Aplicativos de serviços da Microsoft com credenciais"
        $formatTemplate = @"
## {0}

| Aplicativo | Tipo de Credencial | Expiração |
| :--- | :--- | :--- |
{1}
"@
        $tableRows = ""
        foreach ($sp in $resultsPassCreds) {
            $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/{0}/appId/{1}' -f $sp.id, $sp.appId
            $tableRows += "| [$(Get-SafeMarkdown($sp.displayName))]($portalLink) | Segredo de Senha | $(Get-FormattedDate($sp.keyEndDateTime)) |`n"
        }

        foreach ($sp in $resultsKeyCreds) {
            $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/{0}/appId/{1}' -f $sp.id, $sp.appId
            $tableRows += "| [$(Get-SafeMarkdown($sp.displayName))]($portalLink) | Certificado/Chave | $(Get-FormattedDate($sp.keyEndDateTime)) |`n"
        }

        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21774'
        Title              = "Aplicativos de serviços da Microsoft não possuem credenciais configuradas"
        UserImpact         = 'Baixo'
        Risk               = 'Alto'
        ImplementationCost = 'Baixo'
        AppliesTo          = 'Identidade'
        Tag                = 'Identidade'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
