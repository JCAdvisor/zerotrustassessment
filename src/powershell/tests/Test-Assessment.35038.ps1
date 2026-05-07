<#
.SYNOPSIS
    As políticas de Insider Risk Management estão habilitadas para uso arriscado de IA

.DESCRIPTION
    As políticas de Insider Risk Management (IRM) com Proteção Adaptativa permitem que as organizações detectem e previnam comportamentos de risco envolvendo dados sensíveis, incluindo compartilhamento não autorizado com partes externas, downloads em massa, padrões incomuns de acesso a dados e tentativas de exfiltração de dados. Sem políticas de IRM configuradas e habilitadas com integração de Proteção Adaptativa (`OptInDrpForDlp`), as organizações não conseguem identificar ameaças internas ou agentes mal-intencionados que abusam do acesso legítimo para exfiltrar dados. As políticas de IRM que se integram com Data Loss Prevention (DLP) criam um sistema abrangente de detecção que combina indicadores comportamentais (padrões incomuns de acesso) com detecção de conteúdo baseada em política (tipos de dados sensíveis), permitindo resposta rápida a ameaças internas antes que os dados sejam comprometidos. As organizações devem habilitar pelo menos uma política de IRM com Proteção Adaptativa ativada para detectar e mitigar risco interno, incluindo cenários de uso arriscado de IA em que os usuários tentam expor dados sensíveis a grandes modelos de linguagem ou serviços de IA em nuvem não autorizados. Sem políticas de IRM, as organizações não conseguem atender aos requisitos de gerenciamento de ameaças internas nem demonstrar aos reguladores recursos proativos de detecção de ameaças.

.NOTES
    Test ID: 35038
    Pillar: Data
    Risk Level: High
    Category: Data Security Posture Management
#>

function Test-Assessment-35038 {
    [ZtTest(
        Category = 'Gerenciamento de postura de segurança de dados',
       ImplementationCost = 'Médio',
        Service = ('SecurityCompliance'),
        CompatibleLicense = ('EXCHANGE_S_ENTERPRISE'),
        Pillar = 'Dados',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger tenants e sistemas em produção',
        TenantType = ('Workforce'),
        TestId = 35038,
        Title = 'Políticas de Insider Risk Management habilitadas para uso arriscado de IA',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Start' -Tag Test -Level VeryVerbose

    $activity = 'Obtendo todas as políticas de Insider Risk Management'
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de Insider Risk Management'

    $irmPolicies = $null
    $adaptiveProtectionEnabledPolicies = $null

    try {
        $irmPolicies = Get-InsiderRiskPolicy -ErrorAction Stop | Select-Object -Property Name, Enabled, OptInDrpForDlp, WhenCreatedUTC

        $adaptiveProtectionEnabledPolicies = $irmPolicies | Where-Object { $_.Enabled -eq $true -and $_.OptInDrpForDlp -eq $true } | Select-Object -Property Name, Enabled, OptInDrpForDlp
    }
    catch {
        Write-PSFMessage "Erro ao consultar as políticas de Insider Risk Management: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $false

    if($adaptiveProtectionEnabledPolicies -and $adaptiveProtectionEnabledPolicies.Count -gt 0){
        $passed = $true
    }
    #endregion Assessment Logic

    #region Report Generation
    if ($passed) {
        $testResultMarkdown = "✅ As políticas de Insider Risk Management estão HABILITADAS com Proteção Adaptativa integrada, permitindo a detecção de comportamentos de risco e ameaças internas, incluindo exposição não autorizada de dados a serviços de IA.`n"
    }
    else{
        $testResultMarkdown = "❌ Nenhuma política de Insider Risk Management está habilitada com Proteção Adaptativa, criando uma lacuna crítica na detecção de ameaças internas e na prevenção de uso arriscado de IA.`n"
    }

    $testResultMarkdown += "## Resumo`n`n"
    $testResultMarkdown += "- **Total de políticas IRM:** $($irmPolicies.Count)`n"
    $testResultMarkdown += "- **Políticas habilitadas com Proteção Adaptativa:** $($adaptiveProtectionEnabledPolicies.Count)`n"

    if($irmPolicies.Count -gt 0){
        $testResultMarkdown += "## [Políticas de IRM](https://purview.microsoft.com/insiderriskmgmt/policiespage)`n`n"
        $testResultMarkdown += "| Nome da política | Habilitada | Proteção Adaptativa (OptInDrpForDlp) | Data de criação |`n"
        $testResultMarkdown += "|:---|:---|:---|:---|`n"

        foreach ($policy in $irmPolicies) {
            $policyName = $policy.Name
            $enabled = if ($policy.Enabled) { "✅ Habilitada" } else { "❌ Desabilitada" }
            $adaptiveProtection = if ($policy.OptInDrpForDlp) { "✅ Habilitada" } else { "❌ Desabilitada" }
            $createdDate = if ($policy.WhenCreatedUTC) { $policy.WhenCreatedUTC.ToString("yyyy-MM-dd") } else { "N/A" }

            $testResultMarkdown += "| $policyName | $enabled | $adaptiveProtection | $createdDate |`n"
        }
    }
    else{
        $testResultMarkdown += "`n[Microsoft Purview Insider Risk Management > Políticas](https://purview.microsoft.com/insiderriskmgmt/policiespage)`n"
    }
    #endregion Report Generation

    $params = @{
        TestId = '35038'
        Title  = 'Políticas de Insider Risk Management habilitadas para uso arriscado de IA'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
