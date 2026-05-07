<#
.SYNOPSIS
    O licenciamento do Gerenciamento de Direitos do Azure está habilitado

.DESCRIPTION
    O serviço de Gerenciamento de Direitos do Azure (Azure RMS) é a tecnologia fundamental de criptografia e controle de acesso
    subjacente à Proteção de Informações da Microsoft. Sem o Azure RMS habilitado, as organizações não podem
    implementar rótulos de sensibilidade com criptografia, proteger emails com criptografia de mensagem do Office 365 (OME),
    aplicar políticas de gerenciamento de direitos de informação (IRM) ou implantar proteção de direitos por meio de regras de fluxo de email.
    O Azure RMS deve ser explicitamente ativado no nível do locatário antes que recursos de proteção downstream possam funcionar.

.NOTES
    Test ID: 35024
    Pillar: Data
    Risk Level: High
    Category: Rights Management Service (RMS)
#>

function Test-Assessment-35024 {
    [ZtTest(
    	Category = 'Rights Management Service',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Microsoft 365 E3'),
    	Service = ('ExchangeOnline'),
    	Pillar = 'Dados',
    	RiskLevel = 'High',
    	SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce'),
    	TestId = 35024,
    	Title = 'Azure Rights Management service is enabled',
    	UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando status de licenciamento do RMS do Azure'
    Write-ZtProgress -Activity $activity -Status 'Obtendo configuração de IRM'

    $irmConfig = $null
    $errorMsg = $null

    try {
            # Consulta Q1: Get IRM configuration status
        $irmConfig = Get-IRMConfiguration -ErrorAction Stop | Select-Object -Property AzureRMSLicensingEnabled, SimplifiedClientAccessEnabled, InternalLicensingEnabled, ExternalLicensingEnabled, WhenCreatedUTC
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar configuração de IRM: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $false
    $investigateFlag = $false

    if ($errorMsg) {
        $investigateFlag = $true
        $testResultMarkdown = "⚠️ Unable to retrieve Azure RMS licensing status. Please verify connectivity and permissions.`n`n%TestResult%"
    }
    else {
        $passed = $irmConfig.AzureRMSLicensingEnabled -eq $true

        if ($passed) {
            $testResultMarkdown = "✅ O Azure RMS está habilitado no nível do locatário, habilitando todos os recursos de criptografia e gerenciamento de direitos downstream.`n`n%TestResult%"
        }
        else {
            $testResultMarkdown = "❌ O Azure RMS não está habilitado ou está desabilitado para o locatário.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($investigateFlag) {
        $azureRMSEnabledStatus = '⚠️ Desconhecido'
        $mdInfo = "**Resumo:**`n`n Serviço do Azure RMS: $azureRMSEnabledStatus`n"
    }
    else {
        $reportTitle = 'Status do Azure RMS'
        $whenCreatedDate = if ($null -eq $irmConfig.WhenCreatedUTC) { 'N/A' } else { $irmConfig.WhenCreatedUTC }

        if ($passed) {
            $azureRMSEnabledStatus = '✅ Habilitado'
        }
        else {
            $azureRMSEnabledStatus = '❌ Desabilitado'
        }

        $formatTemplate = @'

### {0}

| Configuração | Valor |
| :------ | :---- |
{1}

**Resumo:**

 Serviço do Azure RMS: {2}

'@

        $tableRows = "| AzureRMSLicensingEnabled | $($irmConfig.AzureRMSLicensingEnabled) |`n"
        $tableRows += "| SimplifiedClientAccessEnabled | $($irmConfig.SimplifiedClientAccessEnabled) |`n"
        $tableRows += "| InternalLicensingEnabled | $($irmConfig.InternalLicensingEnabled) |`n"
        $tableRows += "| ExternalLicensingEnabled | $($irmConfig.ExternalLicensingEnabled) |`n"
        $tableRows += "| Configuração criada | $whenCreatedDate |`n"

        $mdInfo = $formatTemplate -f $reportTitle, $tableRows, $azureRMSEnabledStatus
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35024'
        Title  = 'Azure RMS Licensing Enabled'
        Status = $passed
        Result = $testResultMarkdown
    }

    if ($investigateFlag -eq $true) {
        $params.CustomStatus = 'Investigate'
    }

    Add-ZtTestResultDetail @params
}
