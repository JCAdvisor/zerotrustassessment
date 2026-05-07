<#
.SYNOPSIS
    Checks if Intelligent Local Access is enabled and configured by verifying private networks exist.

.DESCRIPTION
    This test validates that at least one private network is configured in the tenant
    to enable Intelligent Local Access functionality in Global Secure Access.

.NOTES
    Test ID: 25405
    Category: Access control
    Required API: networkaccess/privateNetworks (beta)
#>

function Test-Assessment-25405 {
    [ZtTest(
    	Category = 'Acesso Seguro Global',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Rede',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 25405,
     Title = 'O Intelligent Local Access está habilitado e configurado',
     UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()


    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando a configuração do Intelligent Local Access'
    Write-ZtProgress -Activity $activity -Status 'Obtendo redes privadas'
        # Consulta private networks from Global Secure Access
    $privateNetworks = Invoke-ZtGraphRequest -RelativeUri 'networkaccess/privateNetworks' -ApiVersion beta
    #endregion Data Collection

    #region Assessment Logic
    $testResultMarkdown = ''
    $passed = $false
    $networkCount = 0

    if ($null -eq $privateNetworks -or $privateNetworks.Count -eq 0) {
        # No private networks configured - test fails
        $passed = $false
        $testResultMarkdown = "❌ Nenhuma rede privada está configurada em seu locatário.`n`n%TestResult%"
    }
    else {
        # At least one private network exists - test passes
        $networkCount = $privateNetworks.Count
        $passed = $true
        $testResultMarkdown = "✅ Pelo menos uma rede privada está configurada em seu locatário.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build detailed markdown information
    $mdInfo = ''

    if ($passed) {
        $reportTitle = "Redes privadas"
        $tableRows = ""

        $mdInfo += "`n## $reportTitle`n`n"
        $mdInfo += "Encontradas $networkCount rede(s) privada(s) configuradas para o Intelligent Local Access.`n`n"

        $formatTemplate = @'
| Nome da rede | Id |
| :--- | :--- |
{0}

'@
        foreach ($network in ($privateNetworks | Sort-Object name)) {
            $portalLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/PrivateNetworks.ReactView"
            $networkName = Get-SafeMarkdown -Text $network.name
            $tableRows += "| [$networkName]($portalLink) | $($network.id) |`n"
        }
        $mdInfo += $formatTemplate -f $tableRows
    }
    else {
        $mdInfo += "`n## Redes privadas`n`n"
        $mdInfo += "Nenhuma rede privada está configurada no momento. Para habilitar o Intelligent Local Access, você precisa configurar pelo menos uma rede privada no Global Secure Access.`n"
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25405'
        Title  = 'O Intelligent Local Access está habilitado e configurado'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
