<#
.SYNOPSIS
    Valida que o Ruleset Padrão está atribuído no WAF do Azure Front Door.

.DESCRIPTION
    Este teste avalia políticas de WAF do Azure Front Door anexadas ao Azure Front Door
    para garantir que tenham um ruleset gerenciado de linha de base (Microsoft_DefaultRuleSet) habilitado para proteção
    application protection against OWASP Top 10 vulnerabilities.

.NOTES
    Test ID: 26883
    Category: Azure Network Security
    Pillar: Network
    Required API: Azure Resource Graph - FrontDoorWebApplicationFirewallPolicies
#>

function Test-Assessment-26883 {

    [ZtTest(
        Category = 'Segurança de rede do Azure',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Azure WAF'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 26883,
        Title = 'O conjunto de regras padrão está atribuído no WAF do Azure Front Door',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Avaliando configuração de ruleset padrão do WAF do Azure Front Door'

    # Check if connected to Azure
    Write-ZtProgress -Activity $activity -Status 'Verificando conexão do Azure'

    $azContext = Get-AzContext -ErrorAction SilentlyContinue
    if (-not $azContext) {
        Write-PSFMessage 'Não conectado ao Azure.' -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedAzure
        return
    }

    Write-ZtProgress -Activity $activity -Status 'Consultando o Azure Resource Graph'

        # Consulta Front Door WAF policies attached to Front Door (Classic or Standard/Premium)
    # - frontendEndpointLinks: Classic Front Door attachments
    # - securityPolicyLinks: Standard/Premium Front Door attachments
    # Uses string-contains check to avoid mv-expand dropping policies with empty managedRuleSets
    $argQuery = @"
resources
| where type =~ 'microsoft.network/frontdoorwebapplicationfirewallpolicies'
| where array_length(properties.frontendEndpointLinks) > 0 or array_length(properties.securityPolicyLinks) > 0
| extend ManagedRuleSetsStr = tostring(properties.managedRules.managedRuleSets)
| extend EnabledState = tostring(properties.policySettings.enabledState)
| extend WafMode = tostring(properties.policySettings.mode)
| extend SkuName = tostring(sku.name)
| extend HasDefaultRuleset = ManagedRuleSetsStr contains 'Microsoft_DefaultRuleSet'
| extend DefaultRulesetVersion = extract('"ruleSetType":"Microsoft_DefaultRuleSet","ruleSetVersion":"([^"]+)"', 1, ManagedRuleSetsStr)
| join kind=leftouter (
    resourcecontainers
    | where type =~ 'microsoft.resources/subscriptions'
    | project subscriptionId, SubscriptionName = name
) on subscriptionId
| project PolicyName=name, PolicyId=id, subscriptionId, SubscriptionName, SkuName, EnabledState, WafMode, HasDefaultRuleset, DefaultRulesetVersion
"@

    $policies = @()
    try {
        $policies = @(Invoke-ZtAzureResourceGraphRequest -Query $argQuery)
        Write-PSFMessage "ARG Query returned $($policies.Count) records" -Tag Test -Level VeryVerbose
    }
    catch {
        Write-PSFMessage "Falha na consulta do Azure Resource Graph: $($_.Exception.Message)" -Tag Test -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotSupported
        return
    }
    #endregion Data Collection

    #region Assessment Logic
    # Skip test if no policies found
    if ($policies.Count -eq 0) {
        Write-PSFMessage 'Nenhuma política de WAF do Azure Front Door anexada ao Azure Front Door encontrada.' -Tag Test -Level Verbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable -Result 'Nenhuma política de WAF do Azure Front Door anexada ao Azure Front Door encontrada em todas as assinaturas.'
        return
    }

    # Check if all policies have default ruleset enabled
    $passedItems = @($policies | Where-Object { $_.HasDefaultRuleset -eq $true })
    $failedItems = @($policies | Where-Object { $_.HasDefaultRuleset -ne $true })

    if ($failedItems.Count -eq 0) {
        $passed = $true
        $testResultMarkdown = "✅ Todas as políticas de WAF do Azure Front Door anexadas ao Azure Front Door têm um ruleset gerenciado padrão (Microsoft_DefaultRuleSet) habilitado.`n`n%TestResult%"
    }
    else {
        $passed = $false
        $testResultMarkdown = "❌ Uma ou mais políticas de WAF do Azure Front Door anexadas ao Azure Front Door não têm um ruleset gerenciado padrão configurado.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    # Table title
    $reportTitle = 'Políticas de WAF do Azure Front Door'
    $portalLink = 'https://portal.azure.com/#browse/Microsoft.Network%2FfrontdoorWebApplicationFirewallPolicies'

    # Prepare table rows
    $tableRows = ''
    foreach ($item in $policies | Sort-Object SubscriptionName, PolicyName) {
        $policyLink = "https://portal.azure.com/#resource$($item.PolicyId)"
        $subLink = "https://portal.azure.com/#resource/subscriptions/$($item.subscriptionId)"
        $policyMd = "[$(Get-SafeMarkdown $item.PolicyName)]($policyLink)"
        $subMd = "[$(Get-SafeMarkdown $item.SubscriptionName)]($subLink)"

        # Calculate status indicators
        $enabledStateDisplay = if ($item.EnabledState -eq 'Enabled') { '✅ Enabled' } else { '❌ Disabled' }
        $modeDisplay = if ($item.WafMode -eq 'Prevention') { '✅ Prevention' } else { "⚠️ $($item.WafMode)" }
        $rulesetType = if ($item.HasDefaultRuleset -eq $true) { 'Microsoft_DefaultRuleSet' } else { 'None' }
        $rulesetVersion = if ($item.HasDefaultRuleset -eq $true -and $item.DefaultRulesetVersion) { $item.DefaultRulesetVersion } else { 'N/A' }
        $status = if ($item.HasDefaultRuleset -eq $true) { '✅ Pass' } else { '❌ Fail' }

        $tableRows += "| $policyMd | $subMd | Yes | $enabledStateDisplay | $modeDisplay | $rulesetType | $rulesetVersion | $status |`n"
    }

    $formatTemplate = @'


## [{0}]({1})

| Nome da política | Nome da assinatura | Anexada ao AFD | Estado habilitado | Modo WAF | Tipo de ruleset padrão | Versão do ruleset | Status |
| :---------- | :---------------- | :-------------: | :-----------: | :------: | :------------------- | :-------------- | :----: |
{2}

'@

    $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $tableRows

    # Summary
    $mdInfo += "`n**Resumo:**`n`n"
    $mdInfo += "- Total de políticas de WAF do Azure Front Door avaliadas: $($policies.Count)`n"
    $mdInfo += "- Políticas com ruleset padrão habilitado: $($passedItems.Count)`n"
    $mdInfo += "- Políticas sem ruleset padrão: $($failedItems.Count)`n"

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '26883'
        Title  = 'Ruleset Padrão está atribuído no WAF do Azure Front Door'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
