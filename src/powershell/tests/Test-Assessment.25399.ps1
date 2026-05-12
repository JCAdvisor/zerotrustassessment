<#
.SYNOPSIS
    Checks that Private DNS is configured for internal name resolution in Entra Private Access (Quick Access)
.DESCRIPTION
    Verifies that a Quick Access application exists, Private DNS resolution is enabled on the Quick Access onPremisesPublishing settings, and that DNS suffix segments are configured for internal domains.

.NOTES
    Test ID: 25399
    Category: Private Access
    Required API: applications (beta), applications/{appId}/onPremisesPublishing, applications/{appId}/onPremisesPublishing/segmentsConfiguration
#>

function Test-Assessment-25399 {
    [ZtTest(
    	Category = 'Global Secure Access',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Entra_Premium_Private_Access'),
    	CompatibleLicense = ('Entra_Premium_Private_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce','External'),
    	TestId = 25399,
     Title = 'O DNS privado está configurado para resolução de nomes internos',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando a configuração do DNS privado para Quick Access (Entra Private Access)'
    Write-ZtProgress -Activity $activity -Status 'Consultando o aplicativo Quick Access'

        # Consulta 1: Find Quick Access application
    $quickAccessApp = Invoke-ZtGraphRequest -RelativeUri "applications" -Filter "tags/any(c:c eq 'NetworkAccessQuickAccessApplication')" -ApiVersion beta
    #endregion Data Collection

    #region Assessment Logic
    # Initialize test variables
    $testResultMarkdown = ''
    $passed = $false
    $appDnsResolutionEnabled = $false
    $appDnsSuffixes = @()
    $appHasValidSegments = $false
    $appDisplayName = $null
    $appId = $null

    # Check if Quick Access application exists
    if (-not $quickAccessApp -or $quickAccessApp.Count -eq 0) {
        $testResultMarkdown = "❌ Nenhum aplicativo Quick Access encontrado com a etiqueta 'NetworkAccessQuickAccessApplication'."
        $passed = $false
    }
    else {
        # Get the Quick Access application
        $app = $quickAccessApp
        $appId = $app.id
        $appDisplayName = $app.displayName

        Write-ZtProgress -Activity $activity -Status "Obtendo onPremisesPublishing para o aplicativo $($appDisplayName)"
            # Consulta 2: Get onPremisesPublishing settings
        $onPrem = Invoke-ZtGraphRequest -RelativeUri "applications/$($appId)/onPremisesPublishing" -ApiVersion beta

        # Check if DNS Resolution is enabled
        if ($null -ne $onPrem -and $onPrem.isDnsResolutionEnabled -eq $true) {
            $appDnsResolutionEnabled = $true
        }
        elseif ($null -eq $onPrem) {
            Write-PSFMessage "Falha ao recuperar as configurações de onPremisesPublishing para o aplicativo $appId" -Level Warning
        }

            # Consulta 3: Get segmentsConfiguration and extract dns suffixes
        Write-ZtProgress -Activity $activity -Status "Obtendo a configuração de segmentos para sufixos DNS em $appDisplayName"
        $segments = Invoke-ZtGraphRequest -RelativeUri "applications/$($appId)/onPremisesPublishing/segmentsConfiguration/microsoft.graph.ipSegmentConfiguration/applicationSegments" -ApiVersion beta

        # Check if at least one segment has recommended settings (destinationType equals dnsSuffix and destinationHost has a value)
        if ($null -ne $segments -and $segments.Count -gt 0) {
            foreach ($seg in $segments) {
                if ($seg.destinationType -eq 'dnsSuffix' -and $seg.destinationHost) {
                    $appDnsSuffixes += $seg.destinationHost
                }
            }
            # Get unique suffixes
            $appDnsSuffixes = $appDnsSuffixes | Sort-Object -Unique

            # At least one valid segment found
            if ($appDnsSuffixes.Count -gt 0) {
                $appHasValidSegments = $true
            }
        }

        # Determine pass/fail per spec: ALL assessments must pass
        if ($appDnsResolutionEnabled -and $appHasValidSegments) {
            $passed = $true
            $testResultMarkdown = "✅ O DNS privado está configurado para resolução de nomes internos no Entra Private Access.`n`n%TestResult%"
        }
        else {
            $passed = $false
            $testResultMarkdown = "❌ O DNS privado não está configurado ou os sufixos DNS estão ausentes.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build detailed markdown information
    $mdInfo = ''

    if ($null -ne $appDisplayName) {
        # Determine status for each component
        $dnsResolutionStatus = if ($appDnsResolutionEnabled) { "🟢 Verdadeiro" } else { "🔴 Falso" }
        $dnsSuffixValue = if ($appHasValidSegments) { $([string]::Join(', ', $appDnsSuffixes)) } else { "None" }
        $appStatus = if ($appDnsResolutionEnabled -and $appHasValidSegments) { "✅ Passou" } else { "❌ Falhou" }

        # Build results table
        $mdInfo += "| Aplicativo Quick Access | DNS habilitado | Sufixos DNS | Status |`n"
        $mdInfo += "|--------------------------|------------------------|--------------|--------|`n"
        $mdInfo += "| $appDisplayName | $dnsResolutionStatus | $dnsSuffixValue | $appStatus |`n"
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25399'
        Title  = 'O DNS privado está configurado para resolução de nomes internos'
        Status = $passed
        Result = $testResultMarkdown
    }
    # Add test result details
    Add-ZtTestResultDetail @params

}
