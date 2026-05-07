<#
.SYNOPSIS
    A rotulagem de PDF está habilitada no SharePoint Online

.DESCRIPTION
    Os arquivos PDF armazenados no SharePoint Online e no OneDrive for Business exigem habilitação separada de suporte a rótulos de sensibilidade além da integração de arquivo do Office base. Quando EnableSensitivityLabelforPDF está desabilitado, as organizações criam uma lacuna de proteção onde os documentos PDF permanecem não classificados e desprotegidos apesar de políticas de rótulo de sensibilidade estarem ativas para arquivos do Office.

.NOTES
    Test ID: 35006
    Pillar: Data
    Risk Level: Medium
#>

function Test-Assessment-35006 {
    [ZtTest(
    	Category = 'SharePoint Online',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('MIP_P1'),
    	Service = ('SharePointOnline'),
        Pillar = 'Dados',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce'),
    	TestId = 35006,
        Title = 'A rotulagem de PDF está habilitada no SharePoint',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando suporte de rotulagem de PDF no SharePoint Online'
    Write-ZtProgress -Activity $activity -Status 'Obtendo configurações de locatário do SharePoint'

    $spoTenant = $null
    $errorMsg = $null

    try {
            # Consulta: Retrieve SharePoint Online tenant PDF labeling support status
        $spoTenant = Get-SPOTenant -ErrorAction Stop
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar as configurações de locatário do SharePoint: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    if ($errorMsg) {
        $passed = $false
    }
    else {
        $passed = $null -ne $spoTenant -and $spoTenant.EnableSensitivityLabelforPDF -eq $true
    }
    #endregion Assessment Logic

    #region Report Generation
    if ($errorMsg) {
        $testResultMarkdown = "### Investigar`n`n"
        $testResultMarkdown += "Não foi possível consultar as configurações de locatário do SharePoint devido a erro: $errorMsg"
    }
    else {
        if ($passed) {
            $testResultMarkdown = "✅ O suporte de rotulagem de PDF está habilitado no SharePoint Online e OneDrive, permitindo que os usuários classifiquem e protejam arquivos PDF.`n`n"
        }
        else {
            $testResultMarkdown = "❌ O suporte de rotulagem de PDF NÃO está habilitado. Os arquivos PDF não podem ser rotulados ou protegidos no SharePoint e OneDrive.`n`n"
        }

        $testResultMarkdown += "### Resumo de configuração do SharePoint Online`n`n"
        $testResultMarkdown += "**Configurações de locatário:**`n"

        $enableSensitivityLabelForPDF = if ($null -ne $spoTenant -and $spoTenant.EnableSensitivityLabelforPDF -eq $true) { "True" } else { "False" }
        $testResultMarkdown += "* EnableSensitivityLabelforPDF: $enableSensitivityLabelForPDF`n"

        $testResultMarkdown += "`n[Gerenciar proteção de informações no Centro de Administração do SharePoint](https://admin.microsoft.com/sharepoint?page=classicSettings&modern=true)`n"
    }
    #endregion Report Generation

    $params = @{
        TestId             = '35006'
        Title              = 'Suporte de rotulagem de PDF no SharePoint Online'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
