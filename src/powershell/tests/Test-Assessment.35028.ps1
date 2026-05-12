<#
.SYNOPSIS
    Políticas de retenção de email estão configuradas

.DESCRIPTION
    Email retention policies automatically manage message lifecycle by deleting, archiving,
    or preserving emails based on organizational compliance and legal requirements. Without
    retention policies configured for Exchange Online, organizations have no centralized
    mechanism to enforce record retention schedules or comply with regulatory mandates.
    This test checks that at least one enabled retention policy with Exchange workload
    scope exists.

.NOTES
    Test ID: 35028
    Pillar: Data
    Risk Level: Medium
    Category: Information Protection
#>

function Test-Assessment-35028 {
    [ZtTest(
        Category = 'Proteção de Informações',
       ImplementationCost = 'Médio',
        Service = ('SecurityCompliance'),
        MinimumLicense = ('Microsoft 365 E3'),
        Pillar = 'Dados',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger tenants e sistemas em produção',
        TenantType = ('Workforce', 'External'),
        TestId = 35028,
        Title = 'As políticas de retenção de email estão configuradas',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando configuração de política de retenção de email'

    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas e regras de conformidade de retenção'

    $errorMsg = $null
    $retentionPolicies = $null
    $retentionRules = $null
    try {
        # Q1: Get all retention compliance policies

        Write-PSFMessage "Querying retention compliance policies" -Level Verbose
        # These cmdlets are available only in Security & Compliance PowerShell
        # Reference: https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/get-retentioncompliancepolicy?view=exchange-ps
        # Note: -DistributionDetail is required for accurate ExchangeLocation values
        $retentionPolicies = Get-RetentionCompliancePolicy -DistributionDetail -ErrorAction Stop

        # Q2: Get retention rules associated with policies

        Write-PSFMessage "Querying retention compliance rules" -Level Verbose
        # Reference: https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/get-retentioncompliancerule?view=exchange-ps
        $retentionRules = Get-RetentionComplianceRule -ErrorAction Stop
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar dados de retenção: $errorMsg" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $false
    $customStatus = $null

    if ($errorMsg) {
        Write-PSFMessage "Query failure or connection issue: $errorMsg" -Level Warning
        $testResultMarkdown = "⚠️ Não foi possível determinar a configuração de política de retenção devido a problemas de permissões ou falha na consulta.`n`n%TestResult%"
        $customStatus = 'Investigate'
    }
    else {
        # Filter for enabled retention policies with Exchange workload
        # Note: Workload property always shows all workloads regardless of actual scope.
        # Use ExchangeLocation to determine actual Exchange scope.
        $enabledExchangePolicies = @($retentionPolicies | Where-Object {
            $_.Enabled -eq $true -and
            $null -ne $_.ExchangeLocation -and
            @($_.ExchangeLocation).Count -gt 0
        })

        $passed = $enabledExchangePolicies.Count -gt 0

        if ($passed) {
            $testResultMarkdown = "✅ Políticas de retenção de email estão configuradas e habilitadas para o Exchange Online, gerenciando automaticamente o ciclo de vida da mensagem e aplicando cronogramas de retenção exigidos por conformidade.`n`n%TestResult%"
        }
        else {
            $testResultMarkdown = "❌ Nenhuma política de retenção de email está configurada para o Exchange Online, criando um risco de conformidade e legal onde os emails são retidos indefinidamente e o escopo de descoberta eletrônica não é controlado.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    $exchangePolicies = @($retentionPolicies | Where-Object {
        $null -ne $_.ExchangeLocation -and
        @($_.ExchangeLocation).Count -gt 0
    })

    if ($exchangePolicies.Count -gt 0) {
        $policyRows = ''
        foreach ($pol in $exchangePolicies | Sort-Object -Property Name) {
            $policyName = Get-SafeMarkdown -Text $pol.Name
            $enabledIcon = if ($pol.Enabled) { '✅ Sim' } else { '❌ Não' }
            $exchangeScope = Get-SafeMarkdown -Text (@($pol.ExchangeLocation) -join ', ')
            $mode = if ($pol.Mode) { Get-SafeMarkdown -Text "$($pol.Mode)" } else { 'N/A' }
            $policyRows += "| $policyName | $enabledIcon | $exchangeScope | $mode |`n"
        }

        $ruleRows = ''
        $exchangeRules = @()
        if (@($retentionRules).Count -gt 0) {
            $exchangePolicyGuids = $exchangePolicies | ForEach-Object { $_.Guid.ToString() }
            $exchangeRules = @($retentionRules | Where-Object { $_.Policy -in $exchangePolicyGuids })

            foreach ($rule in $exchangeRules | Sort-Object -Property Name) {
                $ruleName = Get-SafeMarkdown -Text $rule.Name
                $parentPolicy = Get-SafeMarkdown -Text ($exchangePolicies | Where-Object { $_.Guid.ToString() -eq $rule.Policy }).Name
                $ruleEnabled = if ($rule.Disabled) { '❌ Não' } else { '✅ Sim' }
                $retentionAction = if ($rule.RetentionComplianceAction) { Get-SafeMarkdown -Text "$($rule.RetentionComplianceAction)" } else { 'N/A' }
                $retentionDuration = if ($rule.RetentionDuration) { "$($rule.RetentionDuration)" } else { 'Indefinido' }
                if ($rule.RetentionDurationDisplayHint) {
                    $safeRetentionDurationDisplayHint = Get-SafeMarkdown -Text "$($rule.RetentionDurationDisplayHint)"
                    $retentionDuration += " ($safeRetentionDurationDisplayHint)"
                }
                $ruleRows += "| $ruleName | $parentPolicy | $ruleEnabled | $retentionAction | $retentionDuration |`n"
            }
        }

        $activeExchangeRules = @($exchangeRules | Where-Object { -not $_.Disabled })

        $rulesSection = ''
        if ($ruleRows) {
            $rulesSection = @'

### Regras de retenção para políticas do Exchange

| Nome da regra | Política pai | Habilitada | Ação de retenção | Período de retenção |
| :--- | :--- | :--- | :--- | :--- |
{1}
'@ -f $null, $ruleRows
        }

        $formatTemplate = @'

### [Políticas de retenção com escopo do Exchange](https://purview.microsoft.com/datalifecyclemanagement/retention)

| Nome da política | Habilitada | Escopo do Exchange | Modo |
| :--- | :--- | :--- | :--- |
{0}
{1}
### Resumo

| Métrica | Valor |
| :--- | :--- |
| Total de políticas de retenção | {2} |
| Políticas do Exchange habilitadas | {3} |
| Regras de retenção ativas (Exchange) | {4} |
'@

        $mdInfo = $formatTemplate -f $policyRows, $rulesSection, @($retentionPolicies).Count, $enabledExchangePolicies.Count, $activeExchangeRules.Count
    }

    $testResultMarkdown = $testResultMarkdown.Replace('%TestResult%', $mdInfo)
    #endregion Report Generation

    $params = @{
        TestId = '35028'
        Title  = 'As políticas de retenção de email estão configuradas'
        Status = $passed
        Result = $testResultMarkdown
    }

    if ($null -ne $customStatus) {
        $params.CustomStatus = $customStatus
    }

    Add-ZtTestResultDetail @params
}
