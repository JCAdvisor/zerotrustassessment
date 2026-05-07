<#
.SYNOPSIS
    Os rótulos de sensibilidade estão habilitados no SharePoint Online

.DESCRIPTION
    SharePoint Online e OneDrive for Business requerem habilitação explícita da integração de rótulo de sensibilidade to allow users to apply Microsoft Information Protection labels to files stored in these services. When EnableAIPIntegration is disabled, organizations lose the ability to classify and protect documents at rest in their primary collaboration platform. The contant is opaque to SharePoint capabilities and Purview services like eDiscovery is not available.

.NOTES
    Test ID: 35005
    Pillar: Data
    Risk Level: High
#>

function Test-Assessment-35005 {
    [ZtTest(
    	Category = 'SharePoint Online',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('MIP_P1'),
    	Service = ('SharePointOnline'),
        Pillar = 'Dados',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce'),
    	TestId = 35005,
        Title = 'Os rótulos de sensibilidade estão habilitados para SharePoint e OneDrive',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando Rótulos de Sensibilidade no SharePoint Online'
    Write-ZtProgress -Activity $activity -Status 'Obtendo Configurações de Locaário do SharePoint'

    $spoTenant = $null
    $errorMsg = $null

    try {
            # Consulta: Retrieve SharePoint Online tenant sensitivity label integration status
        $spoTenant = Get-SPOTenant -ErrorAction Stop
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar Configurações de Locaário do SharePoint: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    if ($errorMsg) {
        $passed = $false
    }
    else {
        if ($null -ne $spoTenant -and $spoTenant.EnableAIPIntegration -eq $true) {
            $passed = $true
        }
        else {
            $passed = $false
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    if ($errorMsg) {
        $testResultMarkdown = "### Investigate`n`n"
        $testResultMarkdown += "Não foi possível consultar Configurações de Locaário do SharePoint devido a erro: $errorMsg"
    }
    else {
        if ($passed) {
            $testResultMarkdown = "✅ Os rótulos de sensibilidade estão habilitados no SharePoint Online e OneDrive, permitindo que os usuários classifiquem e protejam documentos armazenados nesses serviços.`n`n"
        }
        else {
            $testResultMarkdown = "❌ Os rótulos de sensibilidade NÃO estão habilitados no SharePoint Online e OneDrive. Os documentos não podem ser rotulados ou protegidos com controles de criptografia/acesso.`n`n"
        }

        $testResultMarkdown += "### Resumo da Configuração do SharePoint Online`n`n"
        $testResultMarkdown += "**Configurações de Locaário:**`n"

        $enableAIPIntegration = if ($spoTenant.EnableAIPIntegration) { "True" } else { "False" }
        $testResultMarkdown += "* EnableAIPIntegration: $enableAIPIntegration`n"

        $testResultMarkdown += "`n[Gerenciar Proteção de Informações no Centro de Administração do SharePoint](https://admin.microsoft.com/sharepoint?page=classicSettings&modern=true)`n"
    }
    #endregion Report Generation

    $params = @{
        TestId             = '35005'
        Title              = 'Rótulos de Sensibilidade Habilitados no SharePoint Online'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
