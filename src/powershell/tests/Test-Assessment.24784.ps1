<#
.SYNOPSIS
    Uma política do Microsoft Defender Antivirus é criada e atribuída no Intune para macOS
#>

function Test-Assessment-24784 {
    [ZtTest(
        Category = 'Dispositivos',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Intune'),
        Pillar = 'Dispositivos',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 24784,
        Title = 'Políticas do Defender Antivirus protegem dispositivos macOS contra malware',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    #region Coleta de Dados
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    if ( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    $activity = "Verificando se uma política do Microsoft Defender Antivirus está criada e atribuída no Intune para macOS"
    Write-ZtProgress -Activity $activity -Status "Obtendo políticas de conformidade"

        # Consulta: Recuperar todas as políticas macOS com tecnologias mdm e microsoftSense
    $sql = @"
    SELECT id, name, platforms, technologies, templateReference, to_json(settings) as settings, to_json(assignments) as assignments
    FROM ConfigurationPolicy
    WHERE platforms LIKE '%macOS%'
      AND technologies LIKE '%mdm%'
      AND technologies LIKE '%microsoftSense%'
"@
    $mdmMacOSSense = Invoke-DatabaseQuery -Database $Database -Sql $sql -AsCustomObject

    # Parse JSON settings field
    foreach ($policy in $mdmMacOSSense) {
        if ($policy.settings -is [string]) {
            $policy.settings = $policy.settings | ConvertFrom-Json
        }
        if ($policy.assignments -is [string]) {
            $policy.assignments = $policy.assignments | ConvertFrom-Json
        }
    }

    $avPolicies = $mdmMacOSSense.Where{ $_.templateReference.templateFamily -eq 'endpointSecurityAntivirus' }

    #endregion Data Collection

    #region Lógica de Avaliação
    $passed = $false

    # Verificar se ao menos uma política de notificação existe e está atribuída
    Write-ZtProgress -Activity $activity -Status "Verificando políticas do Defender Antivirus para macOS"
    $passed = $avPolicies.Count -gt 0 -and $avPolicies.assignments.Count -gt 0

    if ($passed) {
        $testResultMarkdown = "Políticas do Defender Antivirus estão configuradas e atribuídas no Intune para macOS.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "Nenhuma política relevante do Defender Antivirus está configurada ou atribuída para macOS.`n`n%TestResult%"
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    # Construir as seções detalhadas do markdown

    # Definir variáveis para inserir na string de formato
    $reportTitle = "Uma política do Microsoft Defender Antivirus é criada e atribuída no Intune para macOS"
    $tableRows = ""

    if ($avPolicies.Count -gt 0) {
        # Criar uma here-string com placeholders de formatação {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Política | Status | Atribuição |
| :---------- | :----- | :--------- |
{1}

'@

        foreach ($policy in $avPolicies) {

            $policyName = Get-SafeMarkdown -Text $policy.name
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_Workflows/SecurityManagementMenu/~/antivirus'

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $status = '✅ Atribuída'
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }
            else {
                $status = '❌ Não atribuída'
                $assignmentTarget = 'Nenhuma'
            }

            $tableRows += "| [$policyName]($portalLink) | $status | $assignmentTarget |`n"
        }

        # Formatar o template substituindo os placeholders pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24784'
        Title  = 'Uma política do Microsoft Defender Antivirus é criada e atribuída no Intune para macOS'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
