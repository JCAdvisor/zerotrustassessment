<#
.SYNOPSIS
    O Criptografia de Mensagens do Microsoft Purview está configurado com acesso de cliente simplificado

.DESCRIPTION
    Este teste verifica se SimplifiedClientAccessEnabled está habilitado para OME, o que controla se o
    botão Proteger está disponível no Outlook na web, permitindo que os usuários apliquem rapidamente proteções de criptografia
    às suas mensagens. SimplifiedClientAccessEnabled requer que AzureRMSLicensingEnabled esteja ativo, pois o Gerenciamento de Direitos do Azure é a
    base de criptografia subjacente.

.NOTES
    Test ID: 35026
    Category: Office 365 Message Encryption (OME)
    Pillar: Data
    Required Module: ExchangeOnlineManagement
    Required Connection: Exchange Online
#>

function Test-Assessment-35026 {
    [ZtTest(
    	Category = 'Criptografia de Mensagens do Purview',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Microsoft 365 E3'),
    	Service = ('ExchangeOnline'),
    	Pillar = 'Dados',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce','External'),
    	TestId = 35026,
    	Title = 'O Criptografia de Mensagens do Microsoft Purview está configurado com acesso de cliente simplificado',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando configuração SimplifiedClientAccess de OME'
    Write-ZtProgress -Activity $activity -Status 'Obtendo configuração de IRM'

    # Get IRM configuration for OME settings
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
    elseif ($null -eq $irmConfig) {
        # Investigate: Cannot determine OME status
        $passed = $false
        $customStatus = 'Investigate'
    }
    elseif ($null -eq $irmConfig.SimplifiedClientAccessEnabled) {
        # Investigate: Property not available (OME not configured)
        $passed = $false
        $customStatus = 'Investigate'
    }
    elseif ($null -eq $irmConfig.AzureRMSLicensingEnabled) {
        # Investigate: AzureRMSLicensingEnabled property not available (incomplete configuration)
        $passed = $false
        $customStatus = 'Investigate'
    }
    # Check AzureRMSLicensingEnabled first (prerequisite for encryption foundation)
    elseif ($irmConfig.AzureRMSLicensingEnabled -ne $true) {
        # Fail: Encryption foundation is explicitly disabled
        $passed = $false
    }
    elseif ($irmConfig.SimplifiedClientAccessEnabled -eq $true) {
        # Pass: Both SimplifiedClientAccessEnabled and AzureRMSLicensingEnabled are true
        $passed = $true
    }
    else {
        # Fail: SimplifiedClientAccessEnabled is false
        $passed = $false
    }
    #endregion Assessment Logic

    #region Report Generation
    $testResultMarkdown = ''

    if ($customStatus -eq 'Investigate') {
        $testResultMarkdown = "⚠️ Não foi possível determinar o status de SimplifiedClientAccessEnabled devido a problemas de permissões ou OME não configurado.`n`n%TestResult%"
    }
    elseif ($passed) {
        $testResultMarkdown = "✅ SimplifiedClientAccessEnabled é true (botão Proteger habilitado) e AzureRMSLicensingEnabled é true (base de criptografia ativa).`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ SimplifiedClientAccessEnabled é false ou AzureRMSLicensingEnabled é false (base de criptografia ou botão Proteger desabilitado).`n`n%TestResult%"
    }

    # Build detailed information if we have data
    $mdInfo = ''

    if ($irmConfig) {
        $reportTitle = 'Status do SimplifiedClientAccess de OME'

        $protectButtonStatus = if (($irmConfig.SimplifiedClientAccessEnabled -eq $true) -and ($irmConfig.AzureRMSLicensingEnabled -eq $true)) {
            '✅ Habilitado'
        } else {
            '❌ Desabilitado'
        }

        $formatTemplate = @'

### {0}

| Configuração | Valor |
| :------ | :---- |
{1}

**Resumo:**

* Status do botão Proteger: {2}

'@

        $tableRows = "| SimplifiedClientAccessEnabled | $($irmConfig.SimplifiedClientAccessEnabled) |`n"
        $tableRows += "| AzureRMSLicensingEnabled | $($irmConfig.AzureRMSLicensingEnabled) |`n"
        $tableRows += "| InternalLicensingEnabled | $($irmConfig.InternalLicensingEnabled) |`n"

        $mdInfo = $formatTemplate -f $reportTitle, $tableRows, $protectButtonStatus
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35026'
        Title  = 'O Criptografia de Mensagens do Microsoft Purview está configurado com acesso de cliente simplificado'
        Status = $passed
        Result = $testResultMarkdown
    }
    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }
    Add-ZtTestResultDetail @params
}
