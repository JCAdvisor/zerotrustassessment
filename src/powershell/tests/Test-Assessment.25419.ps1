<#
.SYNOPSIS
    Verifica se os logs do Global Secure Access estão integrados com um espaço de trabalho do Log Analytics para monitoramento de segurança.

.DESCRIPTION
    Verifica se as configurações de diagnóstico estão configuradas para enviar categorias de log do Global Secure Access
    (NetworkAccessTrafficLogs, EnrichedOffice365AuditLogs, RemoteNetworkHealthLogs, NetworkAccessAlerts,
    NetworkAccessConnectionEvents, NetworkAccessGenerativeAIInsights) para um espaço de trabalho do Log Analytics
    para integração do Microsoft Sentinel e detecção de ameaças.

.NOTES
    Test ID: 25419
    Category: Global Secure Access
    Required API: Azure Monitor Diagnostic Settings API (management.azure.com)
#>

function Test-Assessment-25419 {
    [ZtTest(
        Category = 'Global Secure Access',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('AAD_PREMIUM', 'Entra_Premium_Internet_Access', 'Entra_Premium_Private_Access'),
        CompatibleLicense = ('Entra_Premium_Private_Access','Entra_Premium_Internet_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Médio',
        SfiPillar = 'Monitorar e detectar ciberameaças',
        TenantType = ('Workforce'),
        TestId = 25419,
        Title = 'A atividade de acesso à rede está visível para operações de segurança para detecção e resposta a ameaças',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando configurações de diagnóstico do Global Secure Access para monitoramento de segurança'

    # Check if connected to Azure
    Write-ZtProgress -Activity $activity -Status 'Verificando conexão do Azure'

    $azContext = Get-AzContext -ErrorAction SilentlyContinue
    if (-not $azContext) {
        Write-PSFMessage 'Not connected to Azure.' -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedAzure
        return
    }

    # Check the supported environment, 'AzureCloud' in (Get-AzContext).Environment.Name maps to 'Global' in (Get-MgContext).Environment
    Write-ZtProgress -Activity $activity -Status 'Verificando ambiente do Azure'

    if ($azContext.Environment.Name -ne 'AzureCloud') {
        Write-PSFMessage 'This test is only applicable to the AzureCloud environment.' -Tag Test -Level VeryVerbose
        Add-ZtTestResultDetail -SkippedBecause NotSupported
        return
    }

        # Consulta diagnostic settings for Microsoft Entra
    Write-ZtProgress -Activity $activity -Status 'Consultando configurações de diagnóstico do Microsoft Entra'

    $resourceManagementUrl = $azContext.Environment.ResourceManagerUrl
    $diagnosticSettingsUri = $resourceManagementUrl + 'providers/microsoft.aadiam/diagnosticsettings?api-version=2017-04-01-preview'

    try {
        $result = Invoke-AzRestMethod -Method GET -Uri $diagnosticSettingsUri -ErrorAction Stop

        if ($result.StatusCode -eq 403) {
            Write-PSFMessage 'O usuário conectado não tem acesso para verificar as configurações de diagnóstico.' -Level Verbose
            Add-ZtTestResultDetail -SkippedBecause NoAzureAccess
            return
        }

        if ($result.StatusCode -ge 400) {
            throw "Falha na solicitação de configurações de diagnóstico com código de status $($result.StatusCode)"
        }
    }
    catch {
        # Only catches actual exceptions (network errors, etc.), not HTTP status codes
        throw
    }

    $diagnosticSettings = ($result.Content | ConvertFrom-Json).value
    #endregion Data Collection

    #region Assessment Logic
    # Define required Global Secure Access log categories
    $requiredLogCategories = @(
        'NetworkAccessTrafficLogs',
        'EnrichedOffice365AuditLogs',
        'RemoteNetworkHealthLogs',
        'NetworkAccessAlerts',
        'NetworkAccessConnectionEvents',
        'NetworkAccessGenerativeAIInsights'
    )

    $passed = $false
    $testResultMarkdown = ''

    if ($null -eq $diagnosticSettings -or $diagnosticSettings.Count -eq 0) {
        $testResultMarkdown = "❌ Nenhuma configuração de diagnóstico está configurada para o Microsoft Entra. Os logs do Global Secure Access não estão sendo exportados para nenhum destino.`n`n%TestResult%"
    }
    else {
        # Find settings that have all required categories enabled and sent to a workspace
        $settingsWithAllCategories = @()
        foreach ($setting in $diagnosticSettings) {
            $hasWorkspace = -not [string]::IsNullOrEmpty($setting.properties.workspaceId)
            $enabledLogs = $setting.properties.logs | Where-Object { $_.enabled -eq $true } | Select-Object -ExpandProperty category
            $hasAllCategories = ($requiredLogCategories | Where-Object { $_ -in $enabledLogs }).Count -eq $requiredLogCategories.Count

            if ($hasWorkspace -and $hasAllCategories) {
                $settingsWithAllCategories += $setting
            }
        }

        $passed = $settingsWithAllCategories.Count -gt 0

        if ($passed) {
            $testResultMarkdown = "✅ Todas as categorias de log do Global Secure Access necessárias são integradas a um espaço de trabalho do Log Analytics para monitoramento de segurança e detecção de ameaças.`n`n%TestResult%"
        }
        else {
            $testResultMarkdown = "❌ Os logs do Global Secure Access não estão adequadamente integrados a um espaço de trabalho do Log Analytics para visibilidade das operações de segurança.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($diagnosticSettings.Count -gt 0) {
    $mdInfo += "`n## [Configurações de diagnóstico](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/DiagnosticSettings)`n`n"

        # Build pivoted table: Log Categories as rows, Diagnostic Settings as columns
        # Header row with diagnostic setting names
        $headerRow = '| Categoria de log |'
        $separatorRow = '| :--- |'
        foreach ($setting in $diagnosticSettings) {
            $headerRow += " $(Get-SafeMarkdown $setting.name) |"
            $separatorRow += ' :---: |'
        }
        $mdInfo += "$headerRow`n"
        $mdInfo += "$separatorRow`n"

        # One row per log category
        foreach ($category in $requiredLogCategories) {
            $row = "| $category |"
            foreach ($setting in $diagnosticSettings) {
                $enabledLogs = $setting.properties.logs | Where-Object { $_.enabled -eq $true } | Select-Object -ExpandProperty category
                $isEnabled = $category -in $enabledLogs
                $statusValue = if ($isEnabled) { '✅ Habilitado' } else { '❌ Desabilitado' }
                $row += " $statusValue |"
            }
            $mdInfo += "$row`n"
        }

        # Workspace row at the bottom
        $workspaceRow = '| Workspace |'
        foreach ($setting in $diagnosticSettings) {
            $workspaceId = $setting.properties.workspaceId
            $hasWorkspace = -not [string]::IsNullOrEmpty($workspaceId)
            if ($hasWorkspace) {
                $workspaceName = ($workspaceId -split '/')[-1]
                $workspaceLink = "https://portal.azure.com/#resource$($workspaceId)/overview"
                $workspaceValue = "✅ [$(Get-SafeMarkdown $workspaceName)]($workspaceLink)"
            }
            else {
                $workspaceValue = '❌ Não configurado'
            }
            $workspaceRow += " $workspaceValue |"
        }
        $mdInfo += "$workspaceRow`n"

        # Summary section
        $mdInfo += "`n**Resumo:**`n`n"

        $mdInfo += "- Total de configurações de diagnóstico: $($diagnosticSettings.Count)`n"
        $mdInfo += "- Configurações de diagnóstico que atendem aos critérios (todas as seis categorias + workspace): $($settingsWithAllCategories.Count)`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25419'
        Title  = 'Atividade de acesso à rede visível para operações de segurança'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
