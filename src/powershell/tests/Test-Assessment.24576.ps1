<#
.SYNOPSIS
    A política de análise de pontos de extremidade do Intune está criada e atribuída
#>

function Test-Assessment-24576 {
    [ZtTest(
    	Category = 'Tenant',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Baixo',
    	SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce'),
    	TestId = 24576,
    	Title = 'A análise de pontos de extremidade está ativada para ajudar a identificar riscos em dispositivos Windows',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    #region Recolha de Dados
    $activity = "A verificar se a política de análise de pontos de extremidade do Intune está criada e atribuída"
    Write-ZtProgress -Activity $activity

    $healthPolicies = Invoke-ZtGraphRequest -RelativeUri "deviceManagement/deviceConfigurations?`$expand=assignments" -ApiVersion beta | Where-Object {
        $_.'@odata.type' -eq '#microsoft.graph.windowsHealthMonitoringConfiguration'
    }
    #endregion Recolha de Dados

    #region Lógica de Avaliação
    $passed = $false
    if ($healthPolicies.Count -gt 0) {
        foreach ($policy in $healthPolicies) {
            if ($policy.assignments.Count -gt 0) {
                $passed = $true
                break
            }
        }
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = if ($passed) { "✅ A política de análise de pontos de extremidade foi encontrada e atribuída.`n`n" } else { "❌ Nenhuma política de análise de pontos de extremidade encontrada ou atribuída.`n`n" }

    if ($healthPolicies.Count -gt 0) {
        $reportTitle = "Políticas de Análise de Pontos de Extremidade"
        $tableRows = ""
        $formatTemplate = @'

## {0}

| Nome da Política | Estado | Alvo da Atribuição |
| :---------- | :----- | :---------------- |
{1}

'@
        foreach ($policy in $healthPolicies) {
            $policyName = Get-SafeMarkdown -Text $policy.displayName
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/configuration'
            $status = if ($policy.assignments.Count -gt 0) { "✅ Atribuída" } else { "❌ Não atribuída" }
            $assignmentTarget = if ($policy.assignments.Count -gt 0) { Get-PolicyAssignmentTarget -Assignments $policy.assignments } else { "Nenhum" }
            $tableRows += "| [$policyName]($portalLink) | $status | $assignmentTarget |`n"
        }
        $testResultMarkdown += $formatTemplate -f $reportTitle, $tableRows
    }
    #endregion Geração de Relatório

    $params = @{
        TestId = '24576'
        Title  = 'A política de análise de pontos de extremidade do Intune está criada e atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
