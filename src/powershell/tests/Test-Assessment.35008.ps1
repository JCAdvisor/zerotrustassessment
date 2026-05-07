<#
.SYNOPSIS
    Um rótulo de sensibilidade padrão está configurado para bibliotecas de documentos do SharePoint

.DESCRIPTION
    As bibliotecas de documentos do SharePoint suportam a configuração de rótulos de sensibilidade padrão que aplicam automaticamente proteção de linha de base a arquivos novos ou editados que carecem de rótulos existentes ou têm rótulos de prioridade mais baixa. Quando a funcionalidade em nível de locatário DisableDocumentLibraryDefaultLabeling está habilitada (definida como $true), as organizações impedem que administradores de site estabeleçam classificação de linha de base automática para bibliotecas de documentos.

.NOTES
    Test ID: 35008
    Pillar: Data
    Risk Level: Medium
#>

function Test-Assessment-35008 {
    [ZtTest(
    	Category = 'SharePoint Online',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Microsoft 365 E5'),
    	Service = ('SharePointOnline'),
        Pillar = 'Dados',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce'),
    	TestId = 35008,
        Title = 'Os rótulos de sensibilidade padrão estão configurados para bibliotecas de documentos do SharePoint',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando capacidade de rótulo padrão de biblioteca de documentos SPO'
    Write-ZtProgress -Activity $activity -Status 'Obtendo configurações de locatário do SharePoint'

    $spoTenant = $null
    $errorMsg = $null

    try {
            # Consulta: Retrieve SharePoint tenant setting for document library default labeling capability
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
        if ($null -ne $spoTenant -and $spoTenant.DisableDocumentLibraryDefaultLabeling -eq $true) {
            $passed = $false
        }
        else {
            $passed = $true
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    if ($errorMsg) {
        $testResultMarkdown = "### Investigar`n`n"
        $testResultMarkdown += "Não foi possível consultar as configurações de locatário do SharePoint devido a erro: $errorMsg"
    }
    else {
        if ($passed) {
            $testResultMarkdown = "✅ A capacidade de rótulo de sensibilidade padrão está habilitada para as bibliotecas de documentos do SharePoint, permitindo rotulagem de linha de base automática.`n`n"
        }
        else {
            $testResultMarkdown = "❌ A capacidade de rótulo de sensibilidade padrão está DESABILITADA. Os administradores de site não podem configurar rótulos padrão em nível de biblioteca.`n`n"
        }

        $testResultMarkdown += "### Resumo de configuração do SharePoint Online`n`n"
        $testResultMarkdown += "**Configurações de locatário:**`n"

        $disableDocumentLibraryDefaultLabeling = if ($spoTenant.DisableDocumentLibraryDefaultLabeling) { "True" } else { "False" }
        $testResultMarkdown += "* DisableDocumentLibraryDefaultLabeling: $disableDocumentLibraryDefaultLabeling`n"
    }
    #endregion Report Generation

    $testResultDetail = @{
        TestId             = '35008'
        Title              = 'Rótulo padrão de biblioteca de documentos SPO (em todo o locatário)'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @testResultDetail
}
