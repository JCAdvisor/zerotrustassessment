<#
.SYNOPSIS
    Mail flow rules apply rights protection to sensitive messages

.DESCRIPTION
    Mail flow rules (transport rules) in Exchange Online allow organizations to automatically apply information protection policies to email messages based on conditions such as sender, recipient, content patterns, or organizational attributes. When mail flow rules with rights protection are not configured, organizations must rely solely on users to manually apply sensitivity labels or encrypt messages—an approach that is inconsistent, error-prone, and does not scale. Without automated rights protection rules, sensitive emails are frequently sent unencrypted, allowing unauthorized access, forwarding, and printing of confidential information. Rights protection rules automatically apply encryption, restriction labels, and permissions to messages matching specific criteria (e.g., emails to external domains, messages containing credit card numbers, emails from finance departments). Configuring at least one mail flow rule with rights protection for high-risk email scenarios ensures sensitive information is automatically protected at the message transport layer, reducing the risk of data exfiltration, unauthorized access, and compliance violations.

.NOTES
    Test ID: 35029
    Pillar: Data
    Risk Level: Medium
#>

function Test-Assessment-35029 {
    [ZtTest(
        Category = 'Proteção de Informações',
       ImplementationCost = 'Médio',
        Service = ('ExchangeOnline'),
        MinimumLicense = ('Microsoft 365 E5'),
        Pillar = 'Dados',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger tenants e sistemas em produção',
        TenantType = ('Workforce'),
        TestId = 35029,
        Title = 'Regras de fluxo de email aplicam proteção de direitos a mensagens sensíveis',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando regras de fluxo de email com proteção de direitos'
    Write-ZtProgress -Activity $activity -Status 'Consultando regras de transporte do Exchange Online'

    $protectionRules = @()
    $allProtectionRulesDetailed = @()
    $enabledRulesCount = 0
    $errorMsg = $null

    try {
        # Q1: Get all mail flow rules with encryption or rights management actions
        $allRules = Get-TransportRule -ErrorAction Stop
        $protectionRules = $allRules | Where-Object {
            $_.ApplyOME -eq $true -or
            $_.ApplyRightsProtectionTemplate -or
            $_.ApplyClassification
        }

        # Q2: Get detailed configuration of each protection rule
        foreach ($rule in $protectionRules) {
            $ruleDetails = [PSCustomObject]@{
                Name                          = $rule.Name
                State                         = $rule.State
                Priority                      = $rule.Priority
                ApplyOME                      = $rule.ApplyOME
                ApplyRightsProtectionTemplate = $rule.ApplyRightsProtectionTemplate
                ApplyClassification           = $rule.ApplyClassification
                SentToScope                   = $rule.SentToScope
                WhenChanged                   = $rule.WhenChanged
            }
            $allProtectionRulesDetailed += $ruleDetails
        }

        # Q3: Count enabled vs disabled rules
        $enabledRulesCount = @($protectionRules | Where-Object { $_.State -eq 'Enabled' }).Count
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar regras de transporte: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    if ($errorMsg) {
        Write-PSFMessage 'Not connected to Exchange Online.' -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedExchange
        return
    }

    $passed = $false

    # Pass if at least one enabled rule with protection actions exists
    if ($enabledRulesCount -ge 1) {
        $passed = $true
    }
    #endregion Assessment Logic

    #region Report Generation
    $testResultMarkdown = ''

    if ($passed) {
        $testResultMarkdown = "✅ Regras de fluxo de email com proteção de direitos estão configuradas, protegendo automaticamente emails sensíveis através de políticas de criptografia e restrição.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ Nenhuma regra de fluxo de email com proteção de direitos está configurada; emails sensíveis não são automaticamente protegidos em trânsito.`n`n%TestResult%"
    }

    # Build detailed content
    $mdInfo = ''

    # Build summary section
    $totalRulesCount = $protectionRules.Count
    $disabledRulesCount = $totalRulesCount - $enabledRulesCount

    # Count by protection type
    $omeRulesCount = @($protectionRules | Where-Object { $_.ApplyOME -eq $true }).Count
    $rmsRulesCount = @($protectionRules | Where-Object { $_.ApplyRightsProtectionTemplate }).Count
    $classificationRulesCount = @($protectionRules | Where-Object { $_.ApplyClassification }).Count

    # Check common protection scenarios
    $hasExternalProtection = @($protectionRules | Where-Object { $_.SentToScope -eq 'NotInOrganization' }).Count -gt 0

    if ($allProtectionRulesDetailed.Count -gt 0) {
        $mdInfo += "### [Configuração das regras de proteção](https://admin.exchange.microsoft.com/#/transportrules)`n`n"
        $mdInfo += "| Nome da regra | Estado | Prioridade | OME | Modelo RMS | Classificação | Última modificação |`n"
        $mdInfo += "| :--- | :--- | :--- | :--- | :--- | :--- | :--- |`n"

        foreach ($rule in $allProtectionRulesDetailed | Sort-Object -Property Priority) {
            $ruleName = Get-SafeMarkdown -Text $rule.Name
            $ruleLink = "[$ruleName](https://admin.exchange.microsoft.com/#/transportrules)"
            $stateIcon = if ($rule.State -eq 'Enabled') { '✅' } else { '❌' }
            $stateDisplay = if ($rule.State -eq 'Enabled') { 'Habilitado' } else { 'Desabilitado' }
            $omeStatus = if ($rule.ApplyOME) { 'Sim' } else { 'Não' }
            $rmsTemplate = if ($rule.ApplyRightsProtectionTemplate) { Get-SafeMarkdown -Text $rule.ApplyRightsProtectionTemplate } else { 'N/A' }
            $classificationStatus = if ($rule.ApplyClassification) { Get-SafeMarkdown -Text $rule.ApplyClassification } else { 'N/A' }
            $modifiedDate = if ($rule.WhenChanged) { $rule.WhenChanged.ToString('yyyy-MM-dd') } else { 'N/A' }

            $mdInfo += "| $ruleLink | $stateIcon $stateDisplay | $($rule.Priority) | $omeStatus | $rmsTemplate | $classificationStatus | $modifiedDate |`n"
        }
        $mdInfo += "`n"
    }

    $mdInfo += "### Regras por tipo de ação`n`n"
    $mdInfo += "| Tipo de ação | Contagem |`n"
    $mdInfo += "| :--- | :--- |`n"
    $mdInfo += "| Regras de criptografia OME | $omeRulesCount |`n"
    $mdInfo += "| Aplicação de modelo RMS | $rmsRulesCount |`n"
    $mdInfo += "| Regras de classificação | $classificationRulesCount |`n"

    $externalProtectionStatus = if ($hasExternalProtection) { '✅ Sim' } else { '❌ Não' }

    $mdInfo += "`n### Resumo`n`n"
    $mdInfo += "| Métrica | Contagem |`n"
    $mdInfo += "| :--- | :--- |`n"
    $mdInfo += "| Total de regras de proteção | $totalRulesCount |`n"
    $mdInfo += "| Regras habilitadas | $enabledRulesCount |`n"
    $mdInfo += "| Regras desabilitadas | $disabledRulesCount |`n"
    $mdInfo += "| Proteção de email externo | $externalProtectionStatus |"

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35029'
        Title  = 'Regras de fluxo de email aplicam proteção de direitos a mensagens sensíveis'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
