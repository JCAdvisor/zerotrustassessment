<#
.SYNOPSIS
    Os usuários devem fornecer justificativa para reduzir rótulos de sensibilidade

.DESCRIPTION
    As políticas de rótulo de sensibilidade devem exigir que os usuários fornecer justificativa ao remover ou rebaixar rótulos. Quando a justificativa de rebaixamento não é necessária, os usuários podem silenciosamente reduzir o nível de classificação do conteúdo sensível sem criar uma trilha de auditoria, criando riscos de conformidade e auditoria.

.NOTES
    Test ID: 35018
    Pillar: Data
    Risk Level: Medium
#>

function Test-Assessment-35018 {
    [ZtTest(
        Category = 'Proteção de Informações',
        ImplementationCost = 'Baixo',
        Service = ('SecurityCompliance'),
        MinimumLicense = ('Microsoft 365 E3'),
        Pillar = 'Dados',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger tenants e sistemas em produção',
        TenantType = ('Workforce'),
        TestId = 35018,
        Title = 'Os usuários devem fornecer justificativa para rebaixar rótulos de sensibilidade',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando se justificativa de rebaixamento é necessária para rótulos de sensibilidade'
    Write-ZtProgress -Activity $activity -Status 'Verificando justificativa de rebaixamento'

    $enabledPolicies = @()
    $errorMsg = $null

    try {
        $enabledPolicies = Get-LabelPolicy -WarningAction SilentlyContinue -ErrorAction Stop | Where-Object { $_.Enabled -eq $true }
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar políticas de rótulo: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $policyResults = @()
    $policiesWithDowngradeJustification = @()
    $xmlParseErrors = @()
    $passed = $false
    $customStatus = $null

    if ($errorMsg) {
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ Não foi possível determinar o status de justificativa de rebaixamento devido a erro: $errorMsg`n`n"
    }
    else {
        foreach ($policy in $enabledPolicies) {

            $requireDowngradeJustification = $false

            if (-not [string]::IsNullOrWhiteSpace($policy.PolicySettingsBlob)) {
                try {
                    $xmlSettings = [xml]$policy.PolicySettingsBlob

                    if ($xmlSettings.settings -and $xmlSettings.settings.setting) {
                        foreach ($setting in $xmlSettings.settings.setting) {

                            if (-not $setting.key -or -not $setting.value) { continue }

                            if ($setting.key.ToLower() -eq 'requiredowngradejustification') {
                                $requireDowngradeJustification = ($setting.value.ToLower() -eq 'true')
                            }
                        }
                    }
                }
                catch {
                    $xmlParseErrors += [PSCustomObject]@{
                        PolicyName = $policy.Name
                        Error      = $_.Exception.Message
                    }
                }
            }

            # Determine scope
            # - Global if any location is set to "All"
            # - Scoped if specific users/groups are defined
            $allLocationNames = @(
                    $policy.ExchangeLocation.Name
                    $policy.ModernGroupLocation.Name
                    $policy.SharePointLocation.Name
                    $policy.OneDriveLocation.Name
                    $policy.SkypeLocation.Name
                    $policy.PublicFolderLocation.Name
                ) | Where-Object { $_ }

                $isGlobal = $allLocationNames -contains 'All'

            # Determine workloads
            $workloads = @()
            if ($policy.ExchangeLocation)       { $workloads += 'Exchange' }
            if ($policy.SharePointLocation)     { $workloads += 'SharePoint' }
            if ($policy.OneDriveLocation)       { $workloads += 'OneDrive' }
            if ($policy.ModernGroupLocation)    { $workloads += 'M365 Groups' }
            if ($policy.PowerBILocation)        { $workloads += 'Power BI' }

            $policyResult = [PSCustomObject]@{
                PolicyName                    = $policy.Name
                PolicyGuid                    = $policy.Guid
                Enabled                       = $policy.Enabled
                RequireDowngradeJustification = $requireDowngradeJustification
                Scope                         =  if ($isGlobal) { 'Global' } else { 'Com escopo' }
                LabelsCount                   = $policy.Labels.Count
                Workloads                     = ($workloads -join ', ')
            }

            $policyResults += $policyResult

            if ($requireDowngradeJustification) {
                $policiesWithDowngradeJustification += $policyResult
            }
        }

        if ($policiesWithDowngradeJustification.Count -gt 0) {
            $passed = $true
            $testResultMarkdown = "✅ A justificativa de rebaixamento é aplicada em pelo menos uma política de rótulo de sensibilidade habilitada.`n`n%TestResult%"
        }
        else {
            $passed = $false
            $testResultMarkdown = "❌ Nenhuma política de rótulo de sensibilidade habilitada exige justificativa de rebaixamento.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = "`n`n### Configuração de Justificativa de Rebaixamento`n"

    if ($policyResults.Count -gt 0) {
        $mdInfo += "| Nome da política | Justificativa de rebaixamento | Escopo | Rótulos | Cargas de trabalho |`n"
        $mdInfo += "| :--- | :--- | :--- | :--- | :--- |`n"

        foreach ($policy in $policyResults) {
            $policyName = Get-SafeMarkdown -Text $policy.PolicyName
            $policyUrl  = "https://purview.microsoft.com/informationprotection/labelpolicies"
            $icon = if ($policy.RequireDowngradeJustification) { '✅' } else { '❌' }

            $mdInfo += "| [$policyName]($policyUrl) | $icon | $($policy.Scope) | $($policy.LabelsCount) | $($policy.Workloads) |`n"
        }

        $percentage = if ($policyResults.Count -gt 0) {
            [Math]::Round(($policiesWithDowngradeJustification.Count / $policyResults.Count) * 100, 2)
        }
        else { 0 }

        $mdInfo += "`n### Resumo`n"
        $mdInfo += "| Métrica | Contagem |`n"
        $mdInfo += "| :--- | :--- |`n"
        $mdInfo += "| Total de políticas de rótulo habilitadas | $($policyResults.Count) |`n"
        $mdInfo += "| Políticas que exigem justificativa de rebaixamento | $($policiesWithDowngradeJustification.Count) |`n"
        $mdInfo += "| Políticas que NÃO exigem justificativa de rebaixamento | $($policyResults.Count - $policiesWithDowngradeJustification.Count) |`n"
        $mdInfo += "| Percentual com justificativa de rebaixamento | $percentage% |"
    }

    if ($xmlParseErrors.Count -gt 0) {
        $mdInfo += "`n`n### ⚠️ Erros de análise de XML`n"
        $mdInfo += "| Nome da política | Erro |`n"
        $mdInfo += "| :--- | :--- |`n"
        foreach ($err in $xmlParseErrors) {
            $mdInfo += "| $(Get-SafeMarkdown $err.PolicyName) | $(Get-SafeMarkdown $err.Error) |`n"
        }
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35018'
        Title  = 'Justificativa de rebaixamento necessária para rótulos de sensibilidade'
        Status = $passed
        Result = $testResultMarkdown
    }

    if ($null -ne $customStatus) {
        $params.CustomStatus = $customStatus
    }

    Add-ZtTestResultDetail @params
}
