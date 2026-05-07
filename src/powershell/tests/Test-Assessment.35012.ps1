<#
.SYNOPSIS
    Os rótulos de contêiner estão configurados para Teams, grupos e sites

.DESCRIPTION
    Este teste avalia a configuração de rótulo de sensibilidade para garantir que os rótulos de contêiner
    estejam habilitados para Microsoft Teams, Microsoft 365 Groups e sites do SharePoint.
    Os rótulos de contêiner aplicam políticas de segurança consistentes no nível do espaço de trabalho,
    controlando o compartilhamento externo, acesso de convidado e restrições de dispositivo.

.NOTES
    Test ID: 35012
    Category: Sensitivity Labels Configuration
    Required APIs: Get-Label (Exchange PowerShell)
#>

function Test-Assessment-35012 {

    [ZtTest(
        Category = 'Configuração de rótulos de sensibilidade',
        ImplementationCost = 'Médio',
        Service = ('SecurityCompliance'),
        MinimumLicense = ('Microsoft 365 E5'),
        Pillar = 'Dados',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger tenants e sistemas em produção',
        TenantType = 'Workforce',
        TestId = 35012,
        Title = 'Os rótulos de contêiner estão configurados para Teams, grupos e sites',
        UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    #region Helper Functions

    function Get-ContainerLabelSummary {
        <#
        .SYNOPSIS
            Extrai detalhes de rótulo de contêiner de um rótulo de sensibilidade.
        .OUTPUTS
            PSCustomObject com detalhes de rótulo de contêiner por especificação.
        #>
        param(
            [object]$Label
        )

        # Extract content types from label
        $contentType = if ($Label.ContentType) { $Label.ContentType } else { 'Not specified' }

        # Use null-coalescing to provide default values for potentially missing properties
        $labelName = if ($null -ne $Label.Name) { $Label.Name } else { 'Unknown' }
        $displayName = if ($null -ne $Label.DisplayName) { $Label.DisplayName } else { 'Not specified' }
        $isParent = if ($null -ne $Label.IsParent) { $Label.IsParent } else { $false }
        $priority = if ($null -ne $Label.Priority) { $Label.Priority } else { 'N/A' }

        return [PSCustomObject]@{
            LabelName   = $labelName
            ContentType = $contentType
            DisplayName = $displayName
            IsParent    = $isParent
            Priority    = $priority
        }
    }

    function Test-ContainerLabel {
        <#
        .SYNOPSIS
            Testa se um rótulo tem escopos de Site e UnifiedGroup em ContentType.
        .OUTPUTS
            Boolean indicando se o rótulo é um rótulo de contêiner.
        #>
        param([object]$Label)

        if ($null -eq $Label.ContentType -or
            ([string]::IsNullOrWhiteSpace($Label.ContentType) -and $Label.ContentType -isnot [array])) {
            return $false
        }

        # Handle ContentType as both array and string
        # Get-Label may return ContentType as an array or a comma-separated string
        $types = if ($Label.ContentType -is [array]) {
            $Label.ContentType
        } else {
            $Label.ContentType -split ',\s*'
        }

        $hasSite = @($types | Where-Object { $_ -eq 'Site' }).Count -gt 0
        $hasUnifiedGroup = @($types | Where-Object { $_ -eq 'UnifiedGroup' }).Count -gt 0

        return ($hasSite -and $hasUnifiedGroup)
    }

    #endregion Helper Functions

    #region Data Collection

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Avaliando configuração de rótulo de contêiner'
    Write-ZtProgress -Activity $activity -Status 'Recuperando rótulos de sensibilidade'

        # Consulta Q1: Retrieve all sensitivity labels
    $allLabels = $null
    $containerLabels = @()
    $queryError = $false

    try {
        $allLabels = Get-Label -ErrorAction Stop
    }
    catch {
        Write-PSFMessage -Level Warning -Message "Falha ao recuperar rótulos de sensibilidade: $_"
        $queryError = $true
    }

        # Consulta Q2: Filter for container-enabled labels (both Site and UnifiedGroup scopes in ContentType)
    if ($null -ne $allLabels -and $allLabels.Count -gt 0) {

        Write-ZtProgress -Activity $activity -Status 'Filtrando rótulos habilitados para contêiner'

        foreach ($label in $allLabels) {
            $isContainer = Test-ContainerLabel -Label $label
            if ($isContainer) {
                $containerLabels += $label
            }
        }
    }

    #endregion Data Collection

    #region Assessment Logic

    # Initialize evaluation containers
    $passed             = $false
    $customStatus       = $null
    $testResultMarkdown = ''
    $labelResults       = @()

    # Step 1: Check if query execution failed
    if ($queryError) {

        $customStatus = 'Investigate'
        $testResultMarkdown =
            "⚠️ A consulta falha ou não é possível recuperar informações de escopo de rótulo devido a problemas de permissões ou falha na conexão do serviço. Certifique-se de que o módulo do PowerShell de Segurança e Conformidade esteja conectado e que a conta tenha as permissões apropriadas para recuperar propriedades de rótulo."

    }
    # Step 2: Check if container labels exist (count >= 1) - Pass (even if some labels had parse errors)
    elseif ($containerLabels.Count -ge 1) {

        # Container labels are configured - Pass
        $passed = $true
        $testResultMarkdown =
            "✅ Os rótulos de contêiner estão configurados para Teams, grupos e sites do SharePoint.`n`n%TestResult%"

        # Build label results for reporting
        foreach ($label in $containerLabels) {
            $labelResults += Get-ContainerLabelSummary -Label $label
        }

    }
    # Step 3: Count = 0 - Fail
    else {

        # No container labels configured
        # Per spec: "Fail: No container labels are configured (acceptable if Teams/Groups not used; may be a gap if collaboration workspaces exist)"
        $passed = $false
        $testResultMarkdown =
            "❌ Nenhum rótulo de contêiner está configurado (aceitável se Teams/Groups não forem usados; pode ser uma lacuna se houver espaços de trabalho colaborativos).`n`n%TestResult%"

    }

    #endregion Assessment Logic

    #region Report Generation

    $mdInfo  = "`n## Resumo`n`n"
    $mdInfo += "| Métrica | Valor |`n|:---|:---|`n"
    $mdInfo += "| Total de rótulos de sensibilidade | $(if ($allLabels) { $allLabels.Count } else { 0 }) |`n"
    $mdInfo += "| Rótulos habilitados para contêiner | $($containerLabels.Count) |`n`n"

    if ($labelResults.Count -gt 0) {
        $tableRows = ""
        $formatTemplate = @'
## [Detalhes dos rótulos de contêiner](https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels)

| Nome do rótulo | Tipo de conteúdo | Nome de exibição | É pai | Prioridade |
|:---|:---|:---|:---|:---|
{0}
'@
        foreach ($r in $labelResults) {
            $labelLink = "https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels"
            $linkedLabelName = "[{0}]({1})" -f (Get-SafeMarkdown $r.LabelName), $labelLink

            $tableRows += "| $linkedLabelName | $(Get-SafeMarkdown $r.ContentType) | $(Get-SafeMarkdown $r.DisplayName) | $($r.IsParent) | $($r.Priority) |`n"
        }
        $mdInfo += $formatTemplate -f $tableRows
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo

    #endregion Report Generation

    $params = @{
        TestId = '35012'
        Title  = 'Rótulos de contêiner configurados para Teams, grupos e sites'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add CustomStatus if status is 'Investigate'
    if ($null -ne $customStatus) {
        $params.CustomStatus = $customStatus
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
