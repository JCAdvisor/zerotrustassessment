<#
.SYNOPSIS
    Validates that all Private Network Connectors are active and healthy.

.DESCRIPTION
    This test checks if all Microsoft Entra Private Network Connectors in the tenant
    are active by checking their status via Microsoft Graph API.

.NOTES
    Test ID: 25391
    Category: Private Access
    Required API: onPremisesPublishingProfiles/applicationProxy/connectors (beta)
#>

function Test-Assessment-25391 {
    [ZtTest(
        Category = 'Acesso Seguro Global',
        ImplementationCost = 'Baixo',
    	MinimumLicense = ('Entra_Premium_Private_Access'),
    	CompatibleLicense = ('Entra_Premium_Private_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 25391,
     Title = 'Os conectores de rede privada estão ativos e saudáveis para manter o acesso Zero Trust a recursos internos',
     UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando as versões dos conectores de rede privada'
    Write-ZtProgress -Activity $activity -Status 'Obtendo conectores'
        # Consulta Q1: Get all private network connectors
    $connectors = Invoke-ZtGraphRequest -RelativeUri 'onPremisesPublishingProfiles/applicationProxy/connectors' -ApiVersion beta

    # Initialize test variables
    $testResultMarkdown = ''
    $passed = $false
    $allConnectors = @()
    #endregion Data Collection

    #region Assessment Logic
    if (-not $connectors -or $connectors.Count -eq 0) {
        $passed = $false
        $testResultMarkdown = "⚠️ Nenhum conector de rede privada está configurado.`n`n[Para configurar conectores de rede privada: Acesso Seguro Global > Conectar > Conectores](https://entra.microsoft.com/#view/Microsoft_Entra_GSA_Connect/Connectors.ReactView/fromNav/globalSecureAccess)"
    }
    else {
        # Step 2: Check for statuses
        Write-ZtProgress -Activity $activity -Status 'Verificando status dos conectores'

        # Transform connectors to result objects with status display
        $allConnectors = $connectors | ForEach-Object {
            [PSCustomObject]@{
                MachineName = $_.machineName
                ExternalIp  = $_.externalIp
                Version     = $_.version
                Status      = if ($_.status -eq 'active') { '✅ Ativo' } else { '❌ Inativo' }
                IsActive    = $_.status -eq 'active'
            }
        }

        # Calculate connector statistics
        $totalConnectors = $allConnectors.Count
        $inactiveConnectors = ($allConnectors | Where-Object { -not $_.IsActive }).Count
        $activeConnectors = $allConnectors.Count - $inactiveConnectors

        # Determine pass/fail - all connectors must be active
        $passed = $inactiveConnectors -eq 0

        $testResultMarkdown = if ($passed) {
            "Todos os conectores de Private Network Access estão ativos e saudáveis.`n`n%TestResult%"
        } else {
            "Um ou mais conectores de Private Network Access estão inativos ou não saudáveis.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build detailed markdown information
    $mdInfo = ''

    if($allConnectors.Count -gt 0)
    {
        $portalLink = 'https://entra.microsoft.com/#view/Microsoft_Entra_GSA_Connect/Connectors.ReactView/fromNav/globalSecureAccess'

    $formatTemplate = @"

## Resumo dos conectores de Private Access

[Link do portal: Acesso Seguro Global > Conectar > Conectores]($portalLink)

- **Total de conectores:** $totalConnectors
- **Conectores ativos:** $activeConnectors
- **Conectores inativos:** $inactiveConnectors

## Status dos conectores de Private Access

| Nome da máquina | Status | IP externo | Versão |
| :----------- | :------------ | :---------- | :------ |
{0}
"@

        $tableRows = ''
        foreach ($connector in ($allConnectors | Sort-Object IsActive, MachineName)) {
            $tableRows += "| $($connector.MachineName) | $($connector.Status) | $($connector.ExternalIp) | $($connector.Version) |`n"
        }
        $mdInfo += $formatTemplate -f $tableRows
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25391'
        Title  = 'Os conectores de Private Access estão ativos e saudáveis'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
