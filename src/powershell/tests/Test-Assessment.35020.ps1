<#
.SYNOPSIS
    As políticas de aplicação automática de rótulos estão no modo de aplicação
#>

function Test-Assessment-35020 {
    [ZtTest(
        Category = 'Proteção de Informações',
        ImplementationCost = 'Baixo',
        Service = ('SecurityCompliance'),
        CompatibleLicense = ('EXCHANGE_S_ENTERPRISE'),
        Pillar = 'Dados',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger tenants e sistemas em produção',
        TenantType = ('Workforce','External'),
        TestId = 35020,
        Title = 'As políticas de aplicação automática de rótulos estão no modo de aplicação',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando configuração do modo de aplicação de políticas de aplicação automática de rótulos'

    # Q1: Get all auto-labeling policies
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de aplicação automática de rótulos'

    $errorMsg = $null
    $allPolicies = @()

    try {
        $allPolicies = Get-AutoSensitivityLabelPolicy -ErrorAction Stop
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar políticas de aplicação automática de rótulos: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $enforcementPolicies = @()
    $simulationPolicies = @()
    $disabledPolicies = @()
    $passed = $false
    $customStatus = $null

    if ($errorMsg) {
        $testResultMarkdown = "⚠️ Não foi possível determinar o status do modo de aplicação de aplicação automática de rótulos devido a problemas de permissões ou falha na consulta.`n`n"
        $customStatus = 'Investigate'
    }
    else {
        Write-PSFMessage "Encontradas $($allPolicies.Count) políticas de aplicação automática de rótulos" -Level Verbose

        # Categorize policies by status and mode
        foreach ($policy in $allPolicies) {
            # Categorize policies by Mode property
            # Possible Mode values per documentation: Enable, TestWithNotifications, TestWithoutNotifications, Disable
            # Reference: https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/set-autosensitivitylabelpolicy?view=exchange-ps#-mode

            if ($policy.Enabled -eq $true -and $policy.Mode -eq 'Enable') {
                $enforcementPolicies += $policy
            }
            elseif ($policy.Enabled -eq $true -and ($policy.Mode -eq 'TestWithoutNotifications' -or $policy.Mode -eq 'TestWithNotifications')) {
                $simulationPolicies += $policy
            }
            elseif ($policy.Enabled -eq $false) {
                $disabledPolicies += $policy
            }
        }

        # Determine pass/fail status
        if ($enforcementPolicies.Count -gt 0) {
            $passed = $true
            $testResultMarkdown = "✅ Pelo menos uma política de aplicação automática de rótulos está habilitada e rotulando ativamente o conteúdo no modo de aplicação.`n`n%TestResult%"
        }
        else {
            $passed = $false

            if ($allPolicies.Count -eq 0) {
                $testResultMarkdown = "❌ Nenhuma política de aplicação automática de rótulos foi encontrada em seu locatário.`n`n%TestResult%"
            }
            else {
                $testResultMarkdown = "❌ Nenhuma política de aplicação automática de rótulos está no modo de aplicação. Todas as políticas estão desabilitadas ou no modo de simulação.`n`n%TestResult%"
            }
        }
    }

    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    # Show enforcement policies table if any exist
    if ($enforcementPolicies.Count -gt 0) {
        $mdInfo += "`n`n### [Políticas de aplicação automática de rótulos no modo de aplicação](https://purview.microsoft.com/informationprotection/autolabeling)`n"
        $mdInfo += "| Nome da política | Status habilitado | Modo | Cargas de trabalho direcionadas | Descrição da política | Data de ativação | Última modificação |`n"
        $mdInfo += "| :--- | :--- | :--- | :--- | :--- | :--- | :--- |`n"

        foreach ($policy in $enforcementPolicies) {
            $policyName = Get-SafeMarkdown -Text $policy.Name
            $enabledStatus = $policy.Enabled
            $workload = if ($policy.Workload) { $policy.Workload } else { 'N/A' }
            $description = if ($policy.Comment) { Get-SafeMarkdown -Text $policy.Comment } else { 'N/A' }
            $created = if ($policy.WhenCreatedUTC) { $policy.WhenCreatedUTC.ToString('yyyy-MM-dd') } else { 'N/A' }
            $modified = if ($policy.WhenChangedUTC) { $policy.WhenChangedUTC.ToString('yyyy-MM-dd') } else { 'N/A' }
            $mdInfo += "| $policyName | $enabledStatus | $($policy.Mode) | $workload | $description | $created | $modified |`n"
        }
    }

    # Build summary metrics
    if ($allPolicies.Count -gt 0) {
        # Calculate aggregated workload coverage across all enforcement policies
        $allWorkloads = ($enforcementPolicies | ForEach-Object { $_.Workload }) -join ' '
        $exchangeCovered = if ($allWorkloads -match 'Exchange') { 'Sim' } else { 'Não' }
        $sharepointCovered = if ($allWorkloads -match 'SharePoint') { 'Sim' } else { 'Não' }
        $onedriveCovered = if ($allWorkloads -match 'OneDrive') { 'Sim' } else { 'Não' }
        $teamsCovered = if ($allWorkloads -match 'Teams') { 'Sim' } else { 'Não' }
        $powerbiCovered = if ($allWorkloads -match 'PowerBI') { 'Sim' } else { 'Não' }

        $mdInfo += "`n`n### Resumo:`n`n"
        $mdInfo += "- **Total de políticas no modo de aplicação:** $($enforcementPolicies.Count)`n"
        $mdInfo += "- **Total de políticas no modo de simulação:** $($simulationPolicies.Count)`n"
        $mdInfo += "- **Total de políticas desabilitadas:** $($disabledPolicies.Count)`n"
        $mdInfo += "- **Cargas de trabalho cobertas por políticas de aplicação:**`n"
        $mdInfo += "  - **Exchange/Outlook:** $exchangeCovered`n"
        $mdInfo += "  - **SharePoint:** $sharepointCovered`n"
        $mdInfo += "  - **OneDrive:** $onedriveCovered`n"
        $mdInfo += "  - **Teams:** $teamsCovered`n"
        $mdInfo += "  - **Power BI:** $powerbiCovered`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35020'
        Title  = 'As políticas de aplicação automática de rótulos estão no modo de aplicação'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add CustomStatus if status is 'Investigate'
    if ($null -ne $customStatus) {
        $params.CustomStatus = $customStatus
    }

    Add-ZtTestResultDetail @params
}
