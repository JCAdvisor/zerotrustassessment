<#
.SYNOPSIS
    A política do Intune Windows Update está configurada e atribuída
#>

function Test-Assessment-24553 {
    [ZtTest(
    	Category = 'Dispositivo',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger tenants e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24553,
    	Title = 'As políticas do Windows Update são aplicadas para reduzir o risco de vulnerabilidades não corrigidas',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    #region Recolha de Dados
    $activity = 'A verificar se a política do Intune Windows Update está configurada e atribuída'
    Write-ZtProgress -Activity $activity

    $windowsUpdatePolicy = Invoke-ZtGraphRequest -RelativeUri 'deviceManagement/deviceConfigurations?$expand=assignments' -ApiVersion beta | Where-Object {
        $_.'@odata.type' -eq '#microsoft.graph.windowsUpdateForBusinessConfiguration'
    }
    #endregion Recolha de Dados

    #region Lógica de Avaliação
    $hasAssignments = $false
    foreach ($policy in $windowsUpdatePolicy) {
        if ($policy.assignments.Count -gt 0) {
            $hasAssignments = $true
            break
        }
    }
    $passed = $hasAssignments
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = ""
    if ($passed) {
        $testResultMarkdown = "✅ Pelo menos uma política de anéis de atualização do Windows (Update Rings) foi encontrada e atribuída.`n`n"
    }
    else {
        $testResultMarkdown = "❌ Nenhuma política de anéis de atualização do Windows foi encontrada ou nenhuma está atribuída.`n`n"
    }

    if ($windowsUpdatePolicy.Count -gt 0) {
        $formatTemplate = @'

| Nome da Política | Estado | Atribuição |
| :---------- | :------------- | :--------- |
{0}

'@

        $tableRows = ""
        foreach ($policy in $windowsUpdatePolicy) {
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesWindowsMenu/~/windows10Update'
            $status = if ($policy.assignments -and $policy.assignments.count -gt 0) {
                '✅ Atribuída'
            }
            else {
                '❌ Não Atribuída'
            }

            $policyName = Get-SafeMarkdown -Text $policy.displayName
            $assignmentTarget = 'Nenhum'

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }

            $tableRows += "| [$policyName]($portalLink) | $status | $assignmentTarget |`n"
        }

        $mdInfo = $formatTemplate -f $tableRows
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId             = '24553'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
