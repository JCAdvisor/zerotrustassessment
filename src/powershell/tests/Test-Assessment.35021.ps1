<#
.SYNOPSIS
    As políticas de aplicação automática de rótulos estão habilitadas para o SharePoint e OneDrive

.DESCRIPTION
    Sites do SharePoint e contas do OneDrive são os repositórios primários de conteúdo de arquivo não estruturado no Microsoft 365. Sem políticas de aplicação automática de rótulos direcionadas especificamente a esses locais, as organizações não podem classificar automaticamente os arquivos com base em seu conteúdo ou tipos de informação sensível, deixando dados sensíveis vulneráveis. As políticas de aplicação automática de rótulos implantadas no modo de aplicação (não simulação) para locais do SharePoint e OneDrive verificam ativamente arquivos novos e modificados, aplicando automaticamente rótulos de sensibilidade quando as condições da política são atendidas. Implementar pelo menos uma política de aplicação automática de rótulos no modo de aplicação para o SharePoint e OneDrive garante que dados sensíveis baseados em arquivo sejam consistentemente classificados.

.NOTES
    Test ID: 35021
    Pillar: Data
    Risk Level: High
#>

function Test-Assessment-35021 {
    [ZtTest(
        Category = 'Information Protection',
        ImplementationCost = 'Medium',
        Service = ('SecurityCompliance'),
        CompatibleLicense = ('EXCHANGE_S_ENTERPRISE'),
        Pillar = 'Data',
        RiskLevel = 'High',
        SfiPillar = 'Protect tenants and production systems',
        TenantType = ('Workforce'),
        TestId = 35021,
        Title = 'Auto-labeling policies are enabled for SharePoint and OneDrive',
        UserImpact = 'Low'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando políticas de aplicação automática de rótulos para o SharePoint e OneDrive'
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de aplicação automática de rótulos'

    $errorMsg = $null
    $allPolicies = @()

    try {
        # Get all auto-labeling policies
        $allPolicies = @(Get-AutoSensitivityLabelPolicy -ErrorAction Stop)
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar políticas de aplicação automática de rótulos: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $customStatus = $null
    $spodPolicies = @()
    $enforcementPolicies = @()

    if ($errorMsg) {
        $passed = $false
        $customStatus = 'Investigate'
    }
    else {
        # Filter for policies targeting SharePoint or OneDrive
        foreach ($policy in $allPolicies) {
            if ($policy.Workload) {
                $workloadList = $policy.Workload -split ', ' | ForEach-Object { $_.Trim() }
                if ($workloadList -contains 'SharePoint' -or $workloadList -contains 'OneDriveForBusiness') {
                    $spodPolicies += $policy

                    # Check if enabled AND in enforcement mode
                    if ($policy.Enabled -eq $true -and $policy.Mode -eq 'Enable') {
                        $enforcementPolicies += $policy
                    }
                }
            }
        }

        # Pass if at least one policy is enabled and in enforcement mode
        $passed = $enforcementPolicies.Count -gt 0
    }
    #endregion Assessment Logic

    #region Report Generation
    if ($errorMsg) {
        $testResultMarkdown = "### Investigar`n`n"
        $testResultMarkdown += "Não foi possível determinar o status de aplicação de políticas de aplicação automática de rótulos para o SharePoint/OneDrive devido a erro: $errorMsg"
    }
    else {
        $policyLink = "https://purview.microsoft.com/informationprotection/autolabeling"

        if ($passed) {
            $testResultMarkdown = "✅ $($enforcementPolicies.Count) política$(if ($enforcementPolicies.Count -eq 1) { ' de ' } else { 's de ' })aplicação automática de rótulos$(if ($enforcementPolicies.Count -eq 1) { 'é' } else { 'são' }) habilitada$(if ($enforcementPolicies.Count -eq 1) { '' } else { 's' }) e no modo de aplicação para o SharePoint e/ou OneDrive.`n`n"

            $testResultMarkdown += "### [Políticas de aplicação automática de rótulos para o SharePoint/OneDrive]($policyLink)`n`n"
            $testResultMarkdown += "| Nome da política | Descrição | Habilitada | Modo | Carga de trabalho | Criada | Última modificação |`n"
            $testResultMarkdown += "| :--- | :--- | :---: | :--- | :--- | :--- | :--- |`n"

            foreach ($policy in $spodPolicies) {
                $policyName = Get-SafeMarkdown -Text $policy.Name
                $description = if ($policy.Comment) { Get-SafeMarkdown -Text $policy.Comment } else { '' }
                $enabled = if ($policy.Enabled) { '✅' } else { '❌' }
                $mode = if ($policy.Mode -eq 'Enable') { 'Aplicação' } elseif ($policy.Mode) { $policy.Mode } else { 'Desconhecido' }
                $workload = if ($policy.Workload) { $policy.Workload } else { 'Not specified' }
                $created = if ($policy.WhenCreatedUTC) { $policy.WhenCreatedUTC.ToString('yyyy-MM-dd') } else { 'Unknown' }
                $lastModified = if ($policy.WhenChangedUTC) { $policy.WhenChangedUTC.ToString('yyyy-MM-dd') } else { 'Unknown' }

                $testResultMarkdown += "| $policyName | $description | $enabled | $mode | $workload | $created | $lastModified |`n"
            }

            # Summary section
            $testResultMarkdown += "`n### Summary`n`n"
            $testResultMarkdown += "* **Total Policies Targeting SharePoint/OneDrive:** $($spodPolicies.Count)`n"

            # Count by status
            $disabledCount = ($spodPolicies | Where-Object { $_.Enabled -eq $false }).Count
            $simulationCount = ($spodPolicies | Where-Object { $_.Enabled -eq $true -and $_.Mode -ne 'Enable' }).Count
            $enforcementCount = $enforcementPolicies.Count

            $testResultMarkdown += "* **Policies in Enforcement Mode:** $enforcementCount`n"
            $testResultMarkdown += "* **Policies in Simulation Mode:** $simulationCount`n"
            $testResultMarkdown += "* **Policies Disabled:** $disabledCount`n"

            # Check workload coverage from enforcement policies
            $enforcementWorkloads = @()
            foreach ($policy in $enforcementPolicies) {
                if ($policy.Workload) {
                    $enforcementWorkloads += $policy.Workload -split ', ' | ForEach-Object { $_.Trim() }
                }
            }
            $enforcementWorkloads = $enforcementWorkloads | Select-Object -Unique

            $hasSharePoint = $enforcementWorkloads -contains 'SharePoint'
            $hasOneDrive = $enforcementWorkloads -contains 'OneDriveForBusiness'

            $testResultMarkdown += "* **SharePoint Coverage:** [$(if ($hasSharePoint) { 'Yes' } else { 'No' })]`n"
            $testResultMarkdown += "* **OneDrive Coverage:** [$(if ($hasOneDrive) { 'Yes' } else { 'No' })]`n"

            # Date range for enforcement activation
            $createdDates = $enforcementPolicies.WhenCreatedUTC | Where-Object { $_ } | Sort-Object
            if ($createdDates) {
                $oldest = $createdDates[0].ToString('yyyy-MM-dd')
                $newest = $createdDates[-1].ToString('yyyy-MM-dd')
                $testResultMarkdown += "* **Enforcement Activation Date Range:** $oldest to $newest`n"
            }
        }
        else {
            if ($spodPolicies.Count -eq 0) {
                $testResultMarkdown = "❌ No auto-labeling policies are configured for SharePoint or OneDrive.`n`n"
            }
            else {
                $testResultMarkdown = "❌ $($spodPolicies.Count) auto-labeling $(if ($spodPolicies.Count -eq 1) { 'policy targets' } else { 'policies target' }) SharePoint/OneDrive, but none are enabled and in enforcement mode.`n`n"

                $testResultMarkdown += "### [Auto-Labeling Policies for SharePoint/OneDrive]($policyLink)`n`n"
                $testResultMarkdown += "| Policy Name | Description | Enabled | Mode | Workload | Created | Last Modified |`n"
                $testResultMarkdown += "| :--- | :--- | :---: | :--- | :--- | :--- | :--- |`n"

                foreach ($policy in $spodPolicies) {
                    $policyName = Get-SafeMarkdown -Text $policy.Name
                    $description = if ($policy.Comment) { Get-SafeMarkdown -Text $policy.Comment } else { '' }
                    $enabled = if ($policy.Enabled) { '✅' } else { '❌' }
                    $mode = if ($policy.Mode -eq 'Enable') { 'Enforcement' } elseif ($policy.Mode) { $policy.Mode } else { 'Unknown' }
                    $workload = if ($policy.Workload) { $policy.Workload } else { 'Not specified' }
                    $created = if ($policy.WhenCreatedUTC) { $policy.WhenCreatedUTC.ToString('yyyy-MM-dd') } else { 'Unknown' }
                    $lastModified = if ($policy.WhenChangedUTC) { $policy.WhenChangedUTC.ToString('yyyy-MM-dd') } else { 'Unknown' }

                    $testResultMarkdown += "| $policyName | $description | $enabled | $mode | $workload | $created | $lastModified |`n"
                }

                # Summary section
                $testResultMarkdown += "`n### Summary`n`n"
                $testResultMarkdown += "* **Total Policies Targeting SharePoint/OneDrive:** $($spodPolicies.Count)`n"

                $disabledCount = ($spodPolicies | Where-Object { $_.Enabled -eq $false }).Count
                $simulationCount = ($spodPolicies | Where-Object { $_.Enabled -eq $true -and $_.Mode -ne 'Enable' }).Count

                $testResultMarkdown += "* **Policies in Enforcement Mode:** 0`n"
                $testResultMarkdown += "* **Policies in Simulation Mode:** $simulationCount`n"
                $testResultMarkdown += "* **Policies Disabled:** $disabledCount`n"
                $testResultMarkdown += "* **SharePoint Coverage:** [No]`n"
                $testResultMarkdown += "* **OneDrive Coverage:** [No]`n"
            }

            $testResultMarkdown += "`n### Recommendation`n`n"
            $testResultMarkdown += "Enable at least one auto-labeling policy in enforcement mode for SharePoint and/or OneDrive to automatically classify sensitive files. "
            $testResultMarkdown += "Visit the [Auto-labeling policies portal]($policyLink) to create or configure policies.`n"
        }
    }
    #endregion Report Generation

    $params = @{
        TestId = '35021'
        Title  = 'Auto-Labeling Policies Enabled for SharePoint and OneDrive'
        Status = $passed
        Result = $testResultMarkdown
    }
    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }
    Add-ZtTestResultDetail @params
}
