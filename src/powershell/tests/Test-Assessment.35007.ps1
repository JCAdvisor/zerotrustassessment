<#
.SYNOPSIS
    O Gerenciamento de Direitos de Informação está habilitado no SharePoint Online

.DESCRIPTION
    A integração do Gerenciamento de Direitos de Informação (IRM) em bibliotecas do SharePoint Online é um recurso legado que foi substituído por Permissões Aprimoradas do SharePoint (ESP). Qualquer biblioteca que usa essa funcionalidade legada deve ser sinalizada para mover para recursos mais recentes.

.NOTES
    Test ID: 35007
    Pillar: Data
    Risk Level: Low
#>

function Test-Assessment-35007 {
    [ZtTest(
        Category = 'SharePoint Online',
        ImplementationCost = 'Baixo',
        Service = ('SharePointOnline'),
        MinimumLicense = ('Microsoft 365 E3'),
        Pillar = 'Dados',
        RiskLevel = 'Baixo',
        SfiPillar = '',
        TenantType = ('Workforce'),
        TestId = 35007,
        Title = 'O Gerenciamento de Direitos de Informação está habilitado no SharePoint Online',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando status do Gerenciamento de Direitos de Informação (IRM) no SharePoint Online'
    Write-ZtProgress -Activity $activity -Status 'Obtendo configurações de locatário do SharePoint'

    $spoTenant = $null
    $errorMsg = $null

    try {
            # Consulta: Retrieve SharePoint Online tenant IRM enablement status
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
        $passed = $null -ne $spoTenant -and $spoTenant.IrmEnabled -ne $true
    }
    #endregion Assessment Logic

    #region Report Generation
    if ($errorMsg) {
        $testResultMarkdown = "### Investigar`n`n"
        $testResultMarkdown += "Não foi possível consultar as configurações de locatário do SharePoint devido a erro: $errorMsg"
    }
    else {
        if ($passed) {
            $testResultMarkdown = "✅ O recurso de IRM legado está desabilitado. As organizações devem usar rótulos de sensibilidade modernos para proteção de documentos.`n`n"
        }
        else {
            $testResultMarkdown = "❌ O recurso de IRM legado ainda está habilitado. As bibliotecas podem estar usando mecanismos de proteção desatualizados.`n`n"
        }

        $testResultMarkdown += "### Resumo de configuração do SharePoint Online`n`n"
        $testResultMarkdown += "**Configurações de locatário:**`n"

        $irmEnabled = if ($null -ne $spoTenant -and $spoTenant.IrmEnabled -eq $true) { "True" } else { "False" }
        $testResultMarkdown += "* IrmEnabled: $irmEnabled`n"

        $testResultMarkdown += "`n[Gerenciar o Gerenciamento de Direitos de Informação (IRM) no Centro de Administração do SharePoint](https://admin.microsoft.com/sharepoint?page=classicSettings&modern=true)`n"
    }
    #endregion Report Generation

    $params = @{
        TestId             = '35007'
        Title              = 'Gerenciamento de Direitos de Informação (IRM) habilitado no SharePoint Online'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
