<#
.SYNOPSIS
    Valida que a configuração de OCR para detecção de informação sensível está habilitada.

.DESCRIPTION
    Este teste verifica se o Reconhecimento Ótico de Caracteres (OCR) está configurado no nível do locatário
    e habilitado para pelo menos um local de carga de trabalho suportado. O OCR permite que as políticas do Microsoft Purview detectem
    informações sensíveis contidas em imagens.

.NOTES
    Test ID: 35023
    Category: Information Protection
    Pillar: Data
    Required Module: ExchangeOnlineManagement
    Required Connection: Security & Compliance PowerShell
#>

function Test-Assessment-35023 {
    [ZtTest(
        Category = 'Information Protection',
        ImplementationCost = 'Medium',
        Service = ('SecurityCompliance'),
        CompatibleLicense = ('EXCHANGE_S_ENTERPRISE'),
        Pillar = 'Data',
        RiskLevel = 'Medium',
        SfiPillar = 'Protect tenants and production systems',
        TenantType = ('Workforce'),
        TestId = 35023,
        Title = 'OCR is enabled for sensitive information detection',
        UserImpact = 'Low'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando configuração de OCR'
    Write-ZtProgress -Activity $activity -Status 'Executando Get-OcrConfiguration'

    $ocrConfig = $null
    $errorMsg = $null

    # Q1: Get OCR configuration
    try {
        $ocrConfig = Get-OcrConfiguration -ErrorAction Stop | Select-Object -Property Enabled, ExchangeLocation, SharePointLocation, OneDriveLocation, TeamsLocation, EndpointDlpLocation, IsOcrUsageBlocked, OcrUsageBlockageReason
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Falha ao recuperar configuração de OCR: $_" -Tag Test -Level Error
    }
    # Q2/Q3: Extract detailed properties if configuration exists
    $enabled = $false
    $exchange = $false
    $sharePoint = $false
    $oneDrive = $false
    $teams = $false
    $endpoint = $false
    $isBlocked = $null
    $blockReason = $null
    $billingStatus = $null
    $enabledLocationsCount = 0

    if ($ocrConfig) {
        $blockReason = $ocrConfig.OcrUsageBlockageReason
        $enabled   = $ocrConfig.Enabled
        $exchange   = $ocrConfig.ExchangeLocation.Count -gt 0
        $sharePoint = $ocrConfig.SharePointLocation.Count -gt 0
        $oneDrive   = $ocrConfig.OneDriveLocation.Count -gt 0
        $teams      = $ocrConfig.TeamsLocation.Count -gt 0
        $endpoint   = $ocrConfig.EndpointDlpLocation.Count -gt 0
        $isBlocked  = $ocrConfig.IsOcrUsageBlocked

        if ($exchange)   { $enabledLocationsCount++ }
        if ($sharePoint) { $enabledLocationsCount++ }
        if ($oneDrive)   { $enabledLocationsCount++ }
        if ($teams)      { $enabledLocationsCount++ }
        if ($endpoint)   { $enabledLocationsCount++ }

        $billingStatus = if ($isBlocked) { 'Not Configured' } else { 'Configured' }
    }
    #endregion Data Collection

    #region Assessment Logic
    $customStatus = $null
    $passed = $false

    if ($errorMsg) {
        $passed = $false
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ Não foi possível determinar o status de configuração de OCR devido a problemas de permissões ou falha na consulta. Erro: $errorMsg`n`n%TestResult%"
    }
    else {
        $hasConfig = $null -ne $ocrConfig
        $anyLocationEnabled = $enabledLocationsCount -gt 0

        if (-not $hasConfig) {
            $passed = $false
            $testResultMarkdown = "❌ OCR is not configured.`n`n%TestResult%"
        }
        elseif (-not $enabled) {
            $passed = $false
            $testResultMarkdown = "❌ OCR is configured but disabled at the tenant level.`n`n%TestResult%"
        }
        elseif (-not $anyLocationEnabled) {
            $passed = $false
            $testResultMarkdown = "❌ OCR is enabled but not configured for any locations.`n`n%TestResult%"
        }
        elseif ($isBlocked) {
            $passed = $false
            $testResultMarkdown = "❌ OCR usage is blocked.`n`n%TestResult%"
        }
        else {
            $passed = $true
            $testResultMarkdown = "✅ OCR configuration is enabled at the tenant level for at least one workload, enabling policies to detect sensitive information within images.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if (-not $errorMsg) {
        $reportTitle = 'Status de configuração de OCR'
        $portalLink = 'https://purview.microsoft.com/'
        $portalPathSafe = Get-SafeMarkdown -Text 'Portal do Microsoft Purview > Configurações > Reconhecimento Ótico de Caracteres (OCR)'

        $configurationObjectStatus = if ($null -ne $ocrConfig) { 'Sim' } else { 'Não' }

        $tableRows = "| Objeto de configuração existe | $configurationObjectStatus |`n"
        $tableRows += "| OCR habilitado (nível de locatário) | $enabled |`n"
        $tableRows += "| Local do Exchange habilitado | $exchange |`n"
        $tableRows += "| Local do SharePoint habilitado | $sharePoint |`n"
        $tableRows += "| Local do OneDrive habilitado | $oneDrive |`n"
        $tableRows += "| Local do Teams habilitado | $teams |`n"
        $tableRows += "| Local do endpoint habilitado | $endpoint |`n"
        $tableRows += "| Uso de OCR bloqueado | $(if ($null -eq $isBlocked) { 'N/A' } else { $isBlocked }) |`n"
        $tableRows += "| Motivo do bloqueio | $(if ($blockReason) { $blockReason } else { 'Nenhum' }) |`n"
        $tableRows += "| Status de cobrança do Azure | $(if ($billingStatus) { $billingStatus } else { 'N/A' }) |`n"

        $ocrConfiguredStatus = if ($ocrConfig) { 'Configurado' } else { 'Não configurado' }

        $formatTemplate = @'

### {0}

| Configuração | Valor |
| :------ | :---- |
{1}

**Resumo:**

- Configuração de OCR: {2}
- Locais ativos: {3}

[{4}]({5})

'@
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows, $ocrConfiguredStatus, $enabledLocationsCount, $portalPathSafe, $portalLink
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35023'
        Title = 'OCR is enabled for sensitive information detection'
        Status = $passed
        Result = $testResultMarkdown
    }

    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }
    Add-ZtTestResultDetail @params
}
