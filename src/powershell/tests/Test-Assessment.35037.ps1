<#
.SYNOPSIS
    O registro de auditoria do Purview está habilitado
#>

function Test-Assessment-35037 {
    [ZtTest(
        Category = 'Gerenciamento de postura de segurança de dados',
        ImplementationCost = 'Low',
        Service = ('ExchangeOnline'),
        MinimumLicense = ('Microsoft 365 E3'),
        Pillar = 'Dados',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger locatários e sistemas de produção',
        TenantType = ('Workforce','External'),
        TestId = 35037,
        Title = 'Registro de auditoria do Purview habilitado',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Start' -Tag Test -Level VeryVerbose
    $activity = 'Verificando a configuração do registro de auditoria do Purview'

        # Consulta Q1: Get unified audit logging configuration
    Write-ZtProgress -Activity $activity -Status 'Obtendo a configuração do log de auditoria'

    $errorMsg = $null
    $auditConfig = $null

    try {
        $auditConfig = Get-AdminAuditLogConfig -ErrorAction Stop
        Write-PSFMessage "Configuração do log de auditoria recuperada" -Level Verbose
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar a configuração do log de auditoria: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    if ($errorMsg -or -not $auditConfig) {
        Write-PSFMessage 'Não conectado ao Exchange Online.' -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedExchange
        return
    }

    $passed = $false

    if ($auditConfig.UnifiedAuditLogIngestionEnabled -eq $true) {
        $passed = $true
        $testResultMarkdown = "✅ O registro de auditoria do Purview está HABILITADO e todas as atividades nos serviços do Microsoft 365 estão sendo capturadas e registradas para fins de investigação e conformidade.`n`n%TestResult%"
    }
    else {
        $passed = $false
        $testResultMarkdown = "❌ O registro de auditoria do Purview está DESABILITADO, criando uma lacuna crítica de visibilidade em que acessos não autorizados, violações de política e incidentes de segurança não podem ser detectados ou investigados.`n`n%TestResult%"
    }

    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    # Show audit configuration only if we have data
    if ($null -ne $auditConfig) {
        $mdInfo += "`n`n### [Status do registro de auditoria](https://purview.microsoft.com/audit)`n"
        $mdInfo += "| Propriedade de configuração | Valor |`n"
        $mdInfo += "| :--- | :--- |`n"

        $auditStatus = $auditConfig.UnifiedAuditLogIngestionEnabled
        $ageLimit = if ($auditConfig.AdminAuditLogAgeLimit) { $auditConfig.AdminAuditLogAgeLimit } else { 'Não configurado' }
        $organizationId = if ($auditConfig.OrganizationId) { Get-SafeMarkdown -Text $auditConfig.OrganizationId } else { 'N/A' }

        $mdInfo += "| Ingestão unificada do log de auditoria habilitada | $auditStatus |`n"
        $mdInfo += "| Limite de idade do log de auditoria | $ageLimit |`n"
        $mdInfo += "| ID da organização | $organizationId |"
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35037'
        Title  = 'Registro de auditoria do Purview habilitado'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
