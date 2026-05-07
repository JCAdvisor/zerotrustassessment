<#
.SYNOPSIS
    Coincidência Exata de Dados está configurada para detecção de informação sensível

.DESCRIPTION
    This test checks if EDM schemas are configured by querying:
    1. All EDM schemas in the organization
    2. Schema details including name, description, version, and dates
    3. Total count of configured schemas

.NOTES
    Test ID: 35034
    Category: Advanced Classification
    Required Module: ExchangeOnlineManagement v3.5.1+
    Required Connection: Connect-IPPSSession
#>

function Test-Assessment-35034 {
    [ZtTest(
        Category = 'Classificação Avançada',
       ImplementationCost = 'Médio',
        Service = ('SecurityCompliance'),
        CompatibleLicense = ('EXCHANGE_S_ENTERPRISE'),
        Pillar = 'Dados',
        RiskLevel = 'High',
        SfiPillar = 'Proteger tenants e sistemas em produção',
        TenantType = ('Workforce', 'External'),
        TestId = 35034,
        Title = 'Exact Data Match is configured for sensitive information detection',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando configuração de Coincidência Exata de Dados (EDM)'
    Write-ZtProgress -Activity $activity -Status 'Consultando esquemas de EDM'

    $errorMsg = $null
    $edmSchemas = $null

        # Consulta: Get all EDM schemas with detailed properties
    try {
        $edmSchemas = Get-DlpEdmSchema -ErrorAction Stop | Select-Object -Property Name, Description, Version, CreatedDate, ModifiedDate
    }
    catch {
        $errorMsg = "Failed to retrieve EDM schemas: $_"
        Write-PSFMessage $errorMsg -Tag Test -Level Warning
    }
    #endregion Data Collection

    #region Assessment Logic
    $testResultMarkdown = ''
    $passed = $false
    $customStatus = $null

    # Check if query failed
    if ($null -ne $errorMsg) {
        $testResultMarkdown = "⚠️ Não foi possível determinar a configuração de esquema de EDM devido a problemas de permissões ou falha na conexão de serviço.`n`n%TestResult%"
        $passed = $false
        $customStatus = 'Investigate'
    }
    # Check schema count
    elseif ($null -eq $edmSchemas -or @($edmSchemas).Count -eq 0) {
        $testResultMarkdown = "❌ Nenhum esquema de EDM está configurado; dependendo apenas de padrões SIT internos para detecção de dados sensíveis.`n`n%TestResult%"
        $passed = $false
    }
    else {
        $testResultMarkdown = "✅ Esquemas de Coincidência Exata de Dados (EDM) estão configurados, habilitando detecção de padrões de dados sensíveis específicos da organização.`n`n%TestResult%"
        $passed = $true
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($null -ne $edmSchemas -and @($edmSchemas).Count -gt 0) {
        $formatTemplate = @'

## [{0}]({1})

| Schema name | Description | Version | Created date | Modified date |
| :---------- | :---------- | :------ | :----------- | :------------ |
{2}

'@

        $reportTitle = 'Exact Data Match Schemas'
        $portalLink = 'https://purview.microsoft.com/informationprotection/dataclassification/exactdatamatch'

        $tableRows = ''

        # Build table rows
        foreach ($schema in $edmSchemas) {
            $name = if ($schema.Name) { $schema.Name } else { 'N/A' }
            $description = if ($schema.Description) { $schema.Description } else { 'N/A' }
            $version = if ($schema.Version) { $schema.Version } else { 'N/A' }
            $created = if ($schema.CreatedDate) { $schema.CreatedDate } else { 'N/A' }
            $modified = if ($schema.ModifiedDate) { $schema.ModifiedDate } else { 'N/A' }

            $safeName = Get-SafeMarkdown -Text $name
            $safeDescription = Get-SafeMarkdown -Text $description
            $safeVersion = Get-SafeMarkdown -Text $version
            $safeCreated = Get-SafeMarkdown -Text $created
            $safeModified = Get-SafeMarkdown -Text $modified
            $tableRows += "| $safeName | $safeDescription | $safeVersion | $safeCreated | $safeModified |`n"
        }

        $tableRows += "`n**Summary:**`n"
        $tableRows += "* Total EDM Schemas: $(@($edmSchemas).Count)"

        $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $tableRows
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35034'
        Title  = 'Exact Data Match (EDM) Configurations'
        Status = $passed
        Result = $testResultMarkdown
    }

    if ($null -ne $customStatus) {
        $params['CustomStatus'] = $customStatus
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
