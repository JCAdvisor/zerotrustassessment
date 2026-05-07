<#
.SYNOPSIS
    Validates that all Private Network Connectors are running the latest version.

.DESCRIPTION
    This test checks if all Microsoft Entra Private Network Connectors in the tenant
    are running the latest version by comparing installed versions against the
    latest release from Microsoft documentation.

.NOTES
    Test ID: 25392
    Category: Private Access
    Required API: onPremisesPublishingProfiles/applicationProxy/connectors (beta)
#>

function Test-Assessment-25392 {
    [ZtTest(
    	Category = 'Private Access',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Entra_Premium_Private_Access'),
    	CompatibleLicense = ('Entra_Premium_Private_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 25392,
    	Title = 'Os conectores de rede privada estão executando a versão mais recente',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Helper Functions
    function Get-LatestConnectorVersion {
        <#
        .SYNOPSIS
            Gets the latest Microsoft Entra Private Network Connector version from documentation.
        .OUTPUTS
            System.String - The latest version number (e.g., "1.5.4522.0") or $null if retrieval fails.
        #>
        $url = "https://raw.githubusercontent.com/MicrosoftDocs/entra-docs/refs/heads/main/docs/global-secure-access/reference-version-history.md"

        try {
            $content = Invoke-RestMethod -Uri $url -ErrorAction Stop

            if ($content -match '## Version (\d+\.\d+\.\d+\.\d+)') {
                return $matches[1]
            }
            else {
                Write-PSFMessage "Could not parse version from documentation" -Level Warning
                return $null
            }
        }
        catch {
            Write-PSFMessage "Failed to fetch connector version: $_" -Level Warning
            return $null
        }
    }
    #endregion Helper Functions

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando as versões dos conectores de rede privada'
    Write-ZtProgress -Activity $activity -Status 'Obtendo conectores'

        # Consulta Q1: Get all private network connectors
    $connectors = Invoke-ZtGraphRequest -RelativeUri 'onPremisesPublishingProfiles/applicationProxy/connectors' -ApiVersion beta

    # Initialize test variables
    $testResultMarkdown = ''
    $passed = $false
    $outdatedConnectors = @()
    $upToDateConnectors = @()
    $latestVersion = $null

    # Step 1: Check if any connectors exist
    if ($connectors -and $connectors.Count -gt 0) {
        # Step 2: Get the latest version from documentation
        Write-ZtProgress -Activity $activity -Status 'Obtendo a versão mais recente da documentação'
        $latestVersion = Get-LatestConnectorVersion
    }
    #endregion Data Collection

    #region Assessment Logic
    if (-not $connectors -or $connectors.Count -eq 0) {
        $testResultMarkdown = "ℹ️ Nenhum conector de rede privada encontrado neste locatário.`n`n%TestResult%"
        $passed = $true  # No connectors means nothing to check - pass by default
    }
    elseif (-not $latestVersion) {
        $testResultMarkdown = "⚠️ Não foi possível recuperar a versão mais recente do conector na documentação. Verificação manual é necessária.`n`n%TestResult%"
        $passed = $false # Fail if we can't verify
    }
    else {
        # Step 3: Compare versions
        Write-ZtProgress -Activity $activity -Status 'Comparando versões dos conectores'

        foreach ($connector in $connectors) {
            $connectorVersion = $connector.version
            # Use -ge to account for preview versions or documentation lag
            $isUpToDate = [version]$connectorVersion -ge [version]$latestVersion

            $connectorInfo = [PSCustomObject]@{
                Id          = $connector.id
                MachineName = $connector.machineName
                Version     = $connectorVersion
                IsUpToDate  = $isUpToDate
            }

            if ($isUpToDate) {
                $upToDateConnectors += $connectorInfo
            }
            else {
                $outdatedConnectors += $connectorInfo
            }
        }

        # Step 4: Determine pass/fail status
        if ($outdatedConnectors.Count -eq 0) {
            $passed = $true
            $testResultMarkdown = "✅ Todos os conectores de rede privada estão executando a versão mais recente ($latestVersion).`n`n%TestResult%"
        }
        else {
            $passed = $false
            $testResultMarkdown = "❌ Pelo menos um conector de rede privada não está executando a versão mais recente ($latestVersion).`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build detailed markdown information
    $mdInfo = ''

    if ($connectors -and $connectors.Count -gt 0 -and $latestVersion) {
        $reportTitle = "Avaliação de versão dos conectores"
        $tableRows = ""

        $mdInfo += "`n## $reportTitle`n`n"
        $mdInfo += "**Versão disponível mais recente**: $latestVersion`n`n"
        $mdInfo += "**Total de conectores**: $($connectors.Count)`n"
        $mdInfo += "**Atualizados**: $($upToDateConnectors.Count)`n"
        $mdInfo += "**Desatualizados**: $($outdatedConnectors.Count)`n`n"

        # Show outdated connectors first (if any)
        if ($outdatedConnectors.Count -gt 0) {
            $formatTemplate = @'
### ❌ Conectores desatualizados

| ID | Nome da máquina | Versão atual |
| :-- | :----------- | :-------------- |
{0}

'@
            foreach ($connector in ($outdatedConnectors | Sort-Object -Property MachineName)) {
                $tableRows += "| $($connector.Id) | $(Get-SafeMarkdown $connector.MachineName) | $($connector.Version) |`n"
            }
            $mdInfo += $formatTemplate -f $tableRows
        }

        # Show up-to-date connectors
        if ($upToDateConnectors.Count -gt 0) {
            $tableRows = ""
            $formatTemplate = @'
### ✅ Conectores atualizados

| ID | Nome da máquina | Versão atual |
| :-- | :----------- | :-------------- |
{0}

'@
            foreach ($connector in ($upToDateConnectors | Sort-Object -Property MachineName)) {
                $tableRows += "| $($connector.Id) | $(Get-SafeMarkdown $connector.MachineName) | $($connector.Version) |`n"
            }
            $mdInfo += $formatTemplate -f $tableRows
        }
    }
        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25392'
        Title  = 'Os conectores de rede privada estão executando a versão mais recente'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add test result details
    Add-ZtTestResultDetail @params

}
