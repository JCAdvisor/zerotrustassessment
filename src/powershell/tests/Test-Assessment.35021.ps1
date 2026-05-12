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
        Category = 'Proteção de Informações',
       ImplementationCost = 'Médio',
        Service = ('SecurityCompliance'),
        CompatibleLicense = ('EXCHANGE_S_ENTERPRISE'),
        Pillar = 'Dados',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger tenants e sistemas em produção',
        TenantType = ('Workforce'),
        TestId = 35021,
        Title = 'As políticas de aplicação automática de rótulos estão habilitadas para o SharePoint e OneDrive',
        UserImpact = 'Baixo'
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
                $workload = if ($policy.Workload) { $policy.Workload } else { 'Não especificado' }
                $created = if ($policy.WhenCreatedUTC) { $policy.WhenCreatedUTC.ToString('yyyy-MM-dd') } else { 'Desconhecido' }
                $lastModified = if ($policy.WhenChangedUTC) { $policy.WhenChangedUTC.ToString('yyyy-MM-dd') } else { 'Desconhecido' }

                $testResultMarkdown += "| $policyName | $description | $enabled | $mode | $workload | $created | $lastModified |`n"
            }

            # Summary section
            $testResultMarkdown += "`n### Resumo`n`n"
            $testResultMarkdown += "* **Total de políticas para o SharePoint/OneDrive:** $($spodPolicies.Count)`n"

            # Count by status
            $disabledCount = ($spodPolicies | Where-Object { $_.Enabled -eq $false }).Count
            $simulationCount = ($spodPolicies | Where-Object { $_.Enabled -eq $true -and $_.Mode -ne 'Enable' }).Count
            $enforcementCount = $enforcementPolicies.Count

            $testResultMarkdown += "* **Políticas no modo de aplicação:** $enforcementCount`n"
            $testResultMarkdown += "* **Políticas no modo de simulação:** $simulationCount`n"
            $testResultMarkdown += "* **Políticas desabilitadas:** $disabledCount`n"

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

            $testResultMarkdown += "* **Cobertura do SharePoint:** [$(if ($hasSharePoint) { 'Sim' } else { 'Não' })]`n"
            $testResultMarkdown += "* **Cobertura do OneDrive:** [$(if ($hasOneDrive) { 'Sim' } else { 'Não' })]`n"

            # Date range for enforcement activation
            $createdDates = $enforcementPolicies.WhenCreatedUTC | Where-Object { $_ } | Sort-Object
            if ($createdDates) {
                $oldest = $createdDates[0].ToString('yyyy-MM-dd')
                $newest = $createdDates[-1].ToString('yyyy-MM-dd')
                $testResultMarkdown += "* **Intervalo de datas de ativação de aplicação:** $oldest a $newest`n"
            }
        }
        else {
            if ($spodPolicies.Count -eq 0) {
                $testResultMarkdown = "❌ Nenhuma política de aplicação automática de rótulos está configurada para o SharePoint ou OneDrive.`n`n"
            }
            else {
                $testResultMarkdown = "❌ $($spodPolicies.Count) $(if ($spodPolicies.Count -eq 1) { 'política de aplicação automática de rótulos está direcionada ao' } else { 'políticas de aplicação automática de rótulos estão direcionadas ao' }) SharePoint/OneDrive, mas nenhuma está habilitada e no modo de aplicação.`n`n"

                $testResultMarkdown += "### [Políticas de aplicação automática de rótulos para o SharePoint/OneDrive]($policyLink)`n`n"
                $testResultMarkdown += "| Nome da política | Descrição | Habilitada | Modo | Carga de trabalho | Criada | Última modificação |`n"
                $testResultMarkdown += "| :--- | :--- | :---: | :--- | :--- | :--- | :--- |`n"

                foreach ($policy in $spodPolicies) {
                    $policyName = Get-SafeMarkdown -Text $policy.Name
                    $description = if ($policy.Comment) { Get-SafeMarkdown -Text $policy.Comment } else { '' }
                    $enabled = if ($policy.Enabled) { '✅' } else { '❌' }
                    $mode = if ($policy.Mode -eq 'Enable') { 'Aplicação' } elseif ($policy.Mode) { $policy.Mode } else { 'Desconhecido' }
                    $workload = if ($policy.Workload) { $policy.Workload } else { 'Não especificado' }
                    $created = if ($policy.WhenCreatedUTC) { $policy.WhenCreatedUTC.ToString('yyyy-MM-dd') } else { 'Desconhecido' }
                    $lastModified = if ($policy.WhenChangedUTC) { $policy.WhenChangedUTC.ToString('yyyy-MM-dd') } else { 'Desconhecido' }

                    $testResultMarkdown += "| $policyName | $description | $enabled | $mode | $workload | $created | $lastModified |`n"
                }

                # Summary section
                $testResultMarkdown += "`n### Resumo`n`n"
                $testResultMarkdown += "* **Total de políticas para o SharePoint/OneDrive:** $($spodPolicies.Count)`n"

                $disabledCount = ($spodPolicies | Where-Object { $_.Enabled -eq $false }).Count
                $simulationCount = ($spodPolicies | Where-Object { $_.Enabled -eq $true -and $_.Mode -ne 'Enable' }).Count

                $testResultMarkdown += "* **Políticas no modo de aplicação:** 0`n"
                $testResultMarkdown += "* **Políticas no modo de simulação:** $simulationCount`n"
                $testResultMarkdown += "* **Políticas desabilitadas:** $disabledCount`n"
                $testResultMarkdown += "* **Cobertura do SharePoint:** [Não]`n"
                $testResultMarkdown += "* **Cobertura do OneDrive:** [Não]`n"
            }

            $testResultMarkdown += "`n### Recomendação`n`n"
            $testResultMarkdown += "Habilite pelo menos uma política de aplicação automática de rótulos no modo de aplicação para o SharePoint e/ou OneDrive para classificar automaticamente arquivos sensíveis. "
            $testResultMarkdown += "Acesse o [portal de políticas de aplicação automática de rótulos]($policyLink) para criar ou configurar políticas.`n"
        }
    }
    #endregion Report Generation

    $params = @{
        TestId = '35021'
        Title  = 'As políticas de aplicação automática de rótulos estão habilitadas para o SharePoint e OneDrive'
        Status = $passed
        Result = $testResultMarkdown
    }
    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }
    Add-ZtTestResultDetail @params
}
