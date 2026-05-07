<#
    .SYNOPSIS
    Verifica se as Entidades de Serviço possuem certificados ou credenciais associadas a elas

#>

function Test-Assessment-21896 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21896,
    	Title = 'Entidades de serviço não possuem certificados ou credenciais associadas a elas',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    $activity = 'Verificando se as Entidades de Serviço possuem certificados ou credenciais associadas a elas'
    Write-ZtProgress -Activity $activity -Status 'Obtendo Entidades de Serviço'

    # Iniciar teste como aprovado
    $passed = $true

    # Q2: Obter entidades de serviço com quaisquer credenciais usando uma única consulta SQL
    $sqlPassCreds = @"
    SELECT distinct ON (id)
        id,
        appId,
        displayName,
        appOwnerOrganizationId,
        try_cast(unnest(passwordCredentials).endDateTime as date) as keyEndDateTime
    FROM ServicePrincipal
    WHERE passwordCredentials != '[]' and appOwnerOrganizationId != 'f8cdef31-a31e-4b4a-93e4-5f571e91255a'
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
    WHERE keyCredentials != '[]' and appOwnerOrganizationId != 'f8cdef31-a31e-4b4a-93e4-5f571e91255a'
    ORDER BY displayName, keyEndDateTime DESC
"@

    $resultsPassCreds = Invoke-DatabaseQuery -Database $Database -Sql $sqlPassCreds
    $resultsKeyCreds = Invoke-DatabaseQuery -Database $Database -Sql $sqlKeyCreds

    if ($resultsPassCreds.Count -eq 0 -and $resultsKeyCreds.Count -eq 0) {
        $passed = $true
        $testResultMarkdown = "As entidades de serviço não possuem credenciais associadas a elas."
    }
    else {
        $passed = $false
        $testResultMarkdown = "Foram encontradas Entidades de Serviço com credenciais configuradas no tenant, o que representa um risco de segurança.`n`n%TestResult%"
    }

    # Construir as seções detalhadas do markdown

    # Definir variáveis para inserir na string de formato
    $reportTitle = 'Entidades de Serviço com credenciais configuradas no tenant'
    $tableRows = ""

    if ($resultsPassCreds.Count -gt 0 -or $resultsKeyCreds.Count -gt 0) {
        $formatTemplate = @'

## {0}


| Nome da Entidade de Serviço | Tipo de Credencial | Data de Expiração da Credencial | Status de Expiração |
| :-------------------------- | :----------------- | :------------------------------ | :------------------ |
{1}

'@

        foreach ($sp in $resultsPassCreds) {
            $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/{0}/appId/{1}' -f $sp.id, $sp.appId
            $expiryDate = $sp.keyEndDateTime.ToDateTime([TimeOnly]::MinValue)
            $expiryStatus = if ( (Get-Date) -gt $expiryDate) {
                '❗ Expirado'
            }
            else {
                '✅ Atual'
            }

            $tableRows += @"
| [$(Get-SafeMarkdown($sp.displayName))]($portalLink) | Credenciais de Senha | $(Get-FormattedDate($sp.keyEndDateTime)) | $expiryStatus |`n
"@
        }

        foreach ($sp in $resultsKeyCreds) {
            $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/{0}/appId/{1}' -f $sp.id, $sp.appId
            $expiryDate = $sp.keyEndDateTime.ToDateTime([TimeOnly]::MinValue)
            $expiryStatus = if ( (Get-Date) -gt $expiryDate) {
                '❗ Expirado'
            }
            else {
                '✅ Atual'
            }

            $tableRows += @"
| [$(Get-SafeMarkdown($sp.displayName))]($portalLink) | Credenciais de Chave | $(Get-FormattedDate($sp.keyEndDateTime)) | $expiryStatus |`n
"@
        }

        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21896'
        Title              = "Entidades de serviço não possuem certificados ou credenciais associadas a elas"
        UserImpact         = 'Low'
        Risk               = 'Medium'
        ImplementationCost = 'Médio'
        AppliesTo          = 'Identity'
        Tag                = 'Identity'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    if (!$passed) {
        $params.CustomStatus = 'Investigar'
    }

    Add-ZtTestResultDetail @params
}
