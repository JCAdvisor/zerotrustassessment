<#
.SYNOPSIS
    Adaptive Protection is enabled in data loss prevention policies

.DESCRIPTION
    Adaptive Protection in DLP integrates Microsoft Purview Insider Risk Management with Data Loss Prevention policies.
    This feature uses machine learning to identify users exhibiting risky behaviors (classified as elevated, moderate, or minor risk levels)
    and automatically applies appropriate DLP controls. Rather than applying uniform DLP policies to all users, Adaptive Protection
    allows organizations to dynamically enforce stronger protections for high-risk users while maintaining flexibility for normal operations.
    Without Adaptive Protection, DLP policies apply the same rules uniformly regardless of user risk profile, missing opportunities
    to prevent insider threats based on behavioral indicators.

.NOTES
    Test ID: 35032
    Pillar: Data
    Risk Level: Medium
    Category: Data Loss Prevention (DLP)
    Required Module: ExchangeOnlineManagement
    Required Connection: Connect-IPPSSession
#>

function Test-Assessment-35032 {
    [ZtTest(
        Category = 'Prevenção contra Perda de Dados (DLP)',
        ImplementationCost = 'Baixo',
        Service = ('SecurityCompliance'),
        CompatibleLicense = ('EXCHANGE_S_ENTERPRISE'),
        Pillar = 'Dados',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger tenants e sistemas em produção',
        TenantType = ('Workforce'),
        TestId = 35032,
        Title = 'A Proteção Adaptativa está habilitada nas políticas de prevenção contra perda de dados',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection

    # Risk Level GUIDs for Adaptive Protection
    $ElevatedRiskGuid = 'FCB9FA93-6269-4ACF-A756-832E79B36A2A'
    $ModerateRiskGuid = '797C4446-5C73-484F-8E58-0CCA08D6DF6C'
    $MinorRiskGuid = '75A4318B-94A2-4323-BA42-2CA6DB29AAFE'

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando Proteção Adaptativa nas políticas DLP'
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas DLP'

    $dlpRules = $null
    $adaptiveRules = $null
    $errorMsg = $null

    try {
        # Q1/Q2: Get all DLP compliance rules
        $dlpRules = Get-DlpComplianceRule -ErrorAction Stop

        # Q3: Filter for rules with Adaptive Protection (SharedByIRMUserRisk condition)
        $adaptiveRules = $dlpRules | Where-Object { $_.AdvancedRule -match 'SharedByIRMUserRisk' }
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Error querying DLP compliance rules: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $customStatus = $false
    $passed = $false

    if ($errorMsg) {
        $customStatus = $true
    }
    else {
        # If at least 1 DLP rule contains SharedByIRMUserRisk condition, the test passes
        # Returns $true if $adaptiveRules contains any items
        # Returns $false if it's $null or empty
        $passed = [bool]$adaptiveRules
    }
    #endregion Assessment Logic

    #region Report Generation
    $testResultMarkdown = ""

    if ($customStatus) {
        $testResultMarkdown = "⚠️ Não foi possível determinar a configuração da Proteção Adaptativa devido a problemas de permissão ou falha na conexão com o serviço.`n`n%TestResult%"
    }
    elseif ($passed) {
        $testResultMarkdown = "✅ A Proteção Adaptativa está configurada nas políticas DLP, habilitando a proteção de dados baseada em risco e comportamento por meio da integração com o gerenciamento de risco interno.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ Nenhuma política DLP utiliza Proteção Adaptativa; as políticas não possuem regras baseadas em risco interno configuradas.`n`n%TestResult%"
    }

    $mdInfo = ''

    if ($customStatus) {
        $mdInfo = "[Ver políticas DLP no Portal do Microsoft Purview](https://purview.microsoft.com/datalossprevention/policies)`n"
    }
    elseif ($passed) {
        # Summary counts
        $totalRules = @($dlpRules).Count
        $adaptiveRulesCount = @($adaptiveRules).Count

        # Count rules by risk level
        $elevatedRiskCount = 0
        $moderateRiskCount = 0
        $minorRiskCount = 0

        foreach ($rule in $adaptiveRules) {
            if ($rule.AdvancedRule -match $ElevatedRiskGuid) { $elevatedRiskCount++ }
            if ($rule.AdvancedRule -match $ModerateRiskGuid) { $moderateRiskCount++ }
            if ($rule.AdvancedRule -match $MinorRiskGuid) { $minorRiskCount++ }
        }

        # Get unique parent policies with Adaptive Protection
        $adaptivePolicies = @($adaptiveRules | Select-Object -ExpandProperty ParentPolicyName -Unique)

        $formatTemplate = @'

### {0}

| Métrica | Contagem |
| :----- | :---- |
{1}

### Regras DLP com Proteção Adaptativa

| Nome da regra | Política pai | Habilitada | Níveis de risco |
| :-------- | :------------ | :------ | :---------- |
{2}

[Ver políticas DLP no Portal do Microsoft Purview](https://purview.microsoft.com/datalossprevention/policies)

'@

        $summaryRows = "| Total de regras DLP | $totalRules |`n"
        $summaryRows += "| Regras com Proteção Adaptativa | $adaptiveRulesCount |`n"
        $summaryRows += "| Políticas com Proteção Adaptativa | $($adaptivePolicies.Count) |`n"
        $summaryRows += "| Regras com nível de risco elevado | $elevatedRiskCount |`n"
        $summaryRows += "| Regras com nível de risco moderado | $moderateRiskCount |`n"
        $summaryRows += "| Regras com nível de risco baixo | $minorRiskCount |`n"

        $ruleRows = ''
        foreach ($rule in $adaptiveRules) {
            $ruleName = $rule.Name
            $parentPolicy = $rule.ParentPolicyName
            $enabledStatus = if ($rule.Disabled -eq $false) { "✅ Sim" } else { "❌ Não" }

            # Determine which risk levels are in the rule
            $riskLevels = @()
            if ($rule.AdvancedRule -match $ElevatedRiskGuid) { $riskLevels += "Elevado" }
            if ($rule.AdvancedRule -match $ModerateRiskGuid) { $riskLevels += "Moderado" }
            if ($rule.AdvancedRule -match $MinorRiskGuid) { $riskLevels += "Baixo" }
            $riskLevelStr = if ($riskLevels.Count -gt 0) { $riskLevels -join ", " } else { "Desconhecido" }

            $ruleRows += "| $ruleName | $parentPolicy | $enabledStatus | $riskLevelStr |`n"
        }

        $reportTitle = 'Resumo da Proteção Adaptativa'
        $mdInfo = $formatTemplate -f $reportTitle, $summaryRows, $ruleRows
    }
    else {
        $mdInfo = "[Ver políticas DLP no Portal do Microsoft Purview](https://purview.microsoft.com/datalossprevention/policies)`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35032'
        Title  = 'Proteção Adaptativa nas políticas DLP'
        Status = $passed
        Result = $testResultMarkdown
    }
    if ($customStatus -eq $true) {
        $params.CustomStatus = 'Investigate'
    }
    Add-ZtTestResultDetail @params
}
