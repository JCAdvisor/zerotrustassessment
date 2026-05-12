<#
.SYNOPSIS
    Validates that traffic forwarding profiles are enabled in Global Secure Access.

.DESCRIPTION
    This test checks if traffic forwarding profiles for Microsoft 365, Private Access,
    and Internet Access are enabled to ensure network traffic is routed through
    Global Secure Access for security policy enforcement.

.NOTES
    Test ID: 25381
    Category: Access control
    Required API: networkAccess/forwardingProfiles (beta)
#>

function Test-Assessment-25381 {
    [ZtTest(
        Category = 'Global Secure Access',
        ImplementationCost = 'Médio',
    	MinimumLicense = ('Entra_Suite','Entra_Premium_Private_Access','Entra_Premium_Internet_Access','P2'),
    	CompatibleLicense = ('Entra_Premium_Private_Access','Entra_Premium_Internet_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 25381,
        Title = 'O tráfego de rede é roteado pelo Global Secure Access para aplicação de políticas de segurança',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando a configuração de perfis de encaminhamento de tráfego'
    Write-ZtProgress -Activity $activity -Status 'Obtendo perfis de encaminhamento de tráfego'

        # Consulta all traffic forwarding profiles
    $forwardingProfiles = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/forwardingProfiles' -ApiVersion beta

    # Initialize test variables
    $testResultMarkdown = ''
    $passed = $false
    $m365TrafficConfig = $null
    $privateTrafficConfig = $null
    $internetTrafficConfig = $null
    #endregion Data Collection

    #region Assessment Logic
    if ($null -eq $forwardingProfiles -or $forwardingProfiles.Count -eq 0) {
        # No profiles found - fail
        $passed = $false
        $testResultMarkdown = "❌ Nenhum perfil de encaminhamento de tráfego foi encontrado. O Global Secure Access não está configurado.`n`n%TestResult%"
    }
    else {
        # Categorize profiles by traffic type for reporting
        $m365TrafficConfig = $forwardingProfiles | Where-Object { $_.trafficForwardingType -eq 'm365' }
        $privateTrafficConfig = $forwardingProfiles | Where-Object { $_.trafficForwardingType -eq 'private' }
        $internetTrafficConfig = $forwardingProfiles | Where-Object { $_.trafficForwardingType -eq 'internet' }

        # Identify enabled and disabled profiles
        $enabledProfiles = $forwardingProfiles | Where-Object { $_.state -eq 'enabled' }
        $disabledProfiles = $forwardingProfiles | Where-Object { $_.state -ne 'enabled' }

        # Determine pass/fail/warning status

        if ($disabledProfiles.Count -eq 0) {
            # All profiles enabled - pass
            $passed = $true
            $testResultMarkdown = "✅ Todos os perfis de encaminhamento de tráfego estão habilitados. O tráfego de rede está sendo capturado e protegido pelo Security Service Edge da Microsoft.`n`n%TestResult%"
        }
        elseif ($enabledProfiles.Count -eq 0) {
            # All profiles disabled - fail
            $passed = $false
            $testResultMarkdown = "❌ Todos os perfis de encaminhamento de tráfego estão desabilitados. O Global Secure Access não está protegendo nenhum tráfego de rede.`n`n%TestResult%"
        }
        else {
            # Some enabled, some disabled - warning (fail)
            $passed = $false
            $testResultMarkdown = "⚠️ Alguns perfis de encaminhamento de tráfego estão desabilitados. Apenas parte do tráfego de rede está protegido.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build detailed markdown information
    $mdInfo = ''

    if ($forwardingProfiles -and $forwardingProfiles.Count -gt 0) {
        $reportTitle = 'Perfis de encaminhamento de tráfego'
        $tableRows = ""

        $mdInfo += "`n## $reportTitle`n`n"
        $mdInfo += "[Abrir perfis de encaminhamento de tráfego no portal Entra](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/ForwardingProfile.ReactView)`n`n"

        # Define profile metadata for consistent reporting
        $trafficTypesMetadata = @(
            @{ Type = 'm365'; Label = 'Microsoft 365'; Object = $m365TrafficConfig }
            @{ Type = 'private'; Label = 'Acesso privado'; Object = $privateTrafficConfig }
            @{ Type = 'internet'; Label = 'Acesso à Internet'; Object = $internetTrafficConfig }
        )

        # Summary of unprotected traffic types (existing but disabled)
        $unprotectedLabels = $trafficTypesMetadata | Where-Object { $_.Object -and $_.Object.state -ne 'enabled' } | Select-Object -ExpandProperty Label
        if ($unprotectedLabels) {
            $mdInfo += "**⚠️ Tipos de tráfego desprotegidos:** $($unprotectedLabels -join ', ')`n`n"
        }

        # Build table rows
        $tableRows = $trafficTypesMetadata | ForEach-Object {
            $trafficItem = $_.Object
            if ($trafficItem) {
                $statusIcon = if ($trafficItem.state -eq 'enabled') { '✅' } else { '❌' }
                "| $($_.Label) | $(Get-SafeMarkdown $trafficItem.name) | $statusIcon $($trafficItem.state) |"
            }
            else {
                "| $($_.Label) | Não encontrado | ❌ Não configurado |"
            }
        }

        $mdInfo += @'
| Tipo de tráfego | Nome | Estado |
| :----------- | :--- | :---- |
{0}

'@ -f ($tableRows -join "`n")
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25381'
        Title  = 'O tráfego de rede é roteado pelo Global Secure Access para aplicação de políticas de segurança'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
