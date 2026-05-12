<#
.SYNOPSIS
    Data loss prevention policies are enabled

.DESCRIPTION
    Data Loss Prevention (DLP) policies protect sensitive information by monitoring, detecting, and preventing the sharing of confidential data across Microsoft 365 workloads including Exchange Online, SharePoint Online, OneDrive, and Microsoft Teams.
    When DLP policies are not enabled or configured, organizations lack automated controls to prevent accidental or intentional disclosure of sensitive information such as credit card numbers, social security numbers, financial data, or proprietary information. Without active DLP policies, employees can freely share sensitive content through email, file uploads, or team communications without organizational oversight, increasing the risk of data breaches, regulatory violations (GDPR, HIPAA, PCI-DSS), and reputational damage. Enabling and configuring at least one DLP policy ensures organizations have automated detection and response capabilities for sensitive data, reducing the risk of unauthorized data exfiltration and demonstrating compliance readiness to regulators and auditors.

.NOTES
    Test ID: 35030
    Pillar: Data
    Risk Level: High
#>

function Test-Assessment-35030 {
    [ZtTest(
        Category = 'Prevenção contra Perda de Dados (DLP)',
       ImplementationCost = 'Médio',
        Service = ('SecurityCompliance'),
        CompatibleLicense = ('EXCHANGE_S_ENTERPRISE'),
        Pillar = 'Dados',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger tenants e sistemas em produção',
        TenantType = ('Workforce'),
        TestId = 35030,
        Title = 'As políticas de prevenção contra perda de dados estão habilitadas',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando políticas de prevenção contra perda de dados'
    Write-ZtProgress -Activity $activity -Status 'Consultando políticas DLP do centro de conformidade'

    $dlpPolicies = $null
    $dlpPoliciesDetailed = $null
    $enabledPoliciesCount = 0
    $errorMsg = $null

    try {
        # Q1: Get all DLP policies in the organization
        $dlpPolicies = Get-DlpCompliancePolicy -ErrorAction Stop

        # Q2: Get details on DLP policy status and rule count
        $dlpPoliciesDetailed = $dlpPolicies | Select-Object -Property Name, Enabled, WhenCreatedUTC, WhenChangedUTC

        # Q3: Count enabled vs disabled DLP policies
        $enabledPoliciesCount = @($dlpPolicies | Where-Object Enabled).Count
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar políticas DLP: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $investigateFlag = $false
    $passed = $false

    if ($errorMsg) {
        $investigateFlag = $true
    }
    else {
        # If enabled policy count >= 1, the test passes
        if ($enabledPoliciesCount -ge 1) {
            $passed = $true
        }
        else {
            # No policies exist or all policies are disabled
            $passed = $false
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    $testResultMarkdown = ""

    if ($investigateFlag) {
        $testResultMarkdown = "⚠️ Não foi possível determinar o status das políticas DLP devido a problemas de permissões ou falha na conexão de serviço.`n`n"
    }
    else {
        if ($passed) {
            $testResultMarkdown = "✅ Uma ou mais políticas DLP estão habilitadas e configuradas, fornecendo proteção automatizada contra divulgação de dados sensíveis.`n`n"
        }
        else {
            $testResultMarkdown = "❌ Nenhuma política DLP está habilitada ou não existem políticas DLP na organização.`n`n"
        }

        $testResultMarkdown += "## Resumo das políticas de prevenção contra perda de dados`n`n"
        $testResultMarkdown += "**Total de políticas DLP:** $($dlpPolicies.Count)`n`n"
        $testResultMarkdown += "**Políticas habilitadas:** $enabledPoliciesCount`n`n"

        if ($dlpPoliciesDetailed.Count -gt 0) {
            $testResultMarkdown += "### Configuração das políticas DLP`n`n"
            $testResultMarkdown += "| Nome da política | Status habilitado | Data de criação | Data da última modificação |`n"
            $testResultMarkdown += "| :--- | :--- | :--- | :--- |`n"

            foreach ($policy in $dlpPoliciesDetailed) {
                $enabledStatus = if ($policy.Enabled) { "✅ Sim" } else { "❌ Não" }
                $createdDate = if ($policy.WhenCreatedUTC) { $policy.WhenCreatedUTC.ToString('yyyy-MM-dd') } else { "N/A" }
                $modifiedDate = if ($policy.WhenChangedUTC) { $policy.WhenChangedUTC.ToString('yyyy-MM-dd') } else { "N/A" }
                $testResultMarkdown += "| $($policy.Name) | $enabledStatus | $createdDate | $modifiedDate |`n"
            }
            $testResultMarkdown += "`n"
        }
    }

    $testResultMarkdown += "[Visualizar políticas DLP no portal do Microsoft Purview](https://purview.microsoft.com/datalossprevention/policies)`n"
    #endregion Report Generation

    $params = @{
        TestId = '35030'
        Title  = 'As políticas de prevenção contra perda de dados estão habilitadas'
        Status = $passed
        Result = $testResultMarkdown
    }
    if ($investigateFlag -eq $true) {
        $params.CustomStatus = 'Investigate'
    }
    Add-ZtTestResultDetail @params
}
