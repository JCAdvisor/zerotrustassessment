<#
.SYNOPSIS
    O licenciamento interno de Gerenciamento de Direitos está habilitado

.DESCRIPTION
    Este teste verifica se o licenciamento interno de RMS está habilitado, o que permite que usuários e serviços
    dentro da organização licenciem conteúdo protegido para distribuição interna e compartilhamento. Sem o licenciamento
    interno de RMS habilitado, os usuários não podem compartilhar conteúdo protegido por direitos com destinatários internos.

.NOTES
    Test ID: 35025
    Category: Rights Management Service (RMS)
    Pillar: Data
    Required Module: ExchangeOnlineManagement
    Required Connection: Exchange Online
#>

function Test-Assessment-35025 {
    [ZtTest(
        Category = 'Rights Management Service (RMS)',
        ImplementationCost = 'Low',
        Service = ('ExchangeOnline'),
        MinimumLicense = ('Microsoft 365 E3'),
        Pillar = 'Data',
        RiskLevel = 'High',
        SfiPillar = 'Protect tenants and production systems',
        TenantType = ('Workforce'),
        TestId = 35025,
        Title = 'Internal Rights Management licensing is enabled',
        UserImpact = 'High'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando status de licenciamento interno de RMS'
    Write-ZtProgress -Activity $activity -Status 'Obtendo configuração de IRM'

    # Get IRM licensing configuration
    $irmConfig = $null
    $errorMsg = $null

    try {
        $irmConfig = Get-IRMConfiguration -ErrorAction Stop
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Falha ao recuperar configuração de IRM: $_" -Tag Test -Level Warning
    }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $false
    $customStatus = $null

    if ($errorMsg) {
        # Investigate: Cannot query IRM configuration
        $passed = $false
        $customStatus = 'Investigate'
    }
    elseif ($null -eq $irmConfig.InternalLicensingEnabled) {
        # Investigate: Cannot determine licensing status
        $passed = $false
        $customStatus = 'Investigate'
    }
    elseif ($irmConfig.InternalLicensingEnabled -eq $true) {
        # Pass: Internal RMS licensing is enabled
        $passed = $true
    }
    else {
        # Fail: Internal RMS licensing is not enabled
        $passed = $false
    }
    #endregion Assessment Logic

    #region Report Generation
    if ($customStatus -eq 'Investigate') {
        $testResultMarkdown = "### Investigar`n`n"
        $testResultMarkdown += "Não foi possível determinar o status de licenciamento de RMS interno devido a problemas de permissões ou dados de configuração incompletos."
    }
    else {
        if ($passed) {
            $testResultMarkdown = "✅ O licenciamento interno de RMS está habilitado, permitindo que usuários internos licenciem e compartilhem conteúdo protegido dentro da organização.`n`n"
        }
        else {
            $testResultMarkdown = "❌ O licenciamento interno de RMS não está habilitado ou os pontos de extremidade de licenciamento não estão configurados.`n`n"
        }

        # Build detailed information if we have data
        if ($irmConfig) {
            # Prepare values first
            $internalLicensingValue = if ($null -eq $irmConfig.InternalLicensingEnabled) {
                'Unknown'
            } else {
                $irmConfig.InternalLicensingEnabled
            }

            $externalLicensingValue = if ($null -eq $irmConfig.ExternalLicensingEnabled) {
                'Unknown'
            } else {
                $irmConfig.ExternalLicensingEnabled
            }

            $azureRMSLicensingValue = if ($null -eq $irmConfig.AzureRMSLicensingEnabled) {
                'Unknown'
            } else {
                $irmConfig.AzureRMSLicensingEnabled
            }

            $licensingLocationValue = if ($irmConfig.LicensingLocation) {
                ($irmConfig.LicensingLocation | ForEach-Object { Get-SafeMarkdown $_ }) -join ', '
            } else {
                'Not configured'
            }

            $internalLicensingConfig = if ($irmConfig.InternalLicensingEnabled -eq $true) {
                '✅ Enabled'
            } elseif ($irmConfig.InternalLicensingEnabled -eq $false) {
                '❌ Disabled'
            } else {
                '⚠️ Incomplete'
            }

            $licensingEndpoints = if ($irmConfig.LicensingLocation) {
                '✅ Configured'
            } else {
                '❌ Not Configured'
            }

            # Build table
            $testResultMarkdown += "**[Status de licenciamento de RMS interno](https://purview.microsoft.com/settings/encryption)**`n"
            $testResultMarkdown += "| Configuração | Status |`n"
            $testResultMarkdown += "| :--- | :--- |`n"
            $testResultMarkdown += "| InternalLicensingEnabled | $internalLicensingValue |`n"
            $testResultMarkdown += "| ExternalLicensingEnabled | $externalLicensingValue |`n"
            $testResultMarkdown += "| AzureRMSLicensingEnabled | $azureRMSLicensingValue |`n"
            $testResultMarkdown += "| LicensingLocation | $licensingLocationValue |`n`n"

            # Summary section
            $testResultMarkdown += "`n### Resumo`n"
            $testResultMarkdown += "* Configuração de licenciamento interno: $internalLicensingConfig`n"
            $testResultMarkdown += "* Pontos de extremidade de licenciamento: $licensingEndpoints`n"
        }
    }
    #endregion Report Generation

    $params = @{
        TestId = '35025'
        Title  = 'Internal RMS Licensing Enabled'
        Status = $passed
        Result = $testResultMarkdown
    }
    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }
    Add-ZtTestResultDetail @params
}
