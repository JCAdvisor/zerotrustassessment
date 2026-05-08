<#
.SYNOPSIS
    A atribuição de política de conformidade para dispositivos Android Enterprise totalmente gerenciados está configurada e atribuída
#>

function Test-Assessment-24545 {
    [ZtTest(
    	Category = 'Tenant',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce'),
    	TestId = 24545,
    	Title = 'Políticas de conformidade protegem dispositivos Android totalmente gerenciados e de propriedade corporativa',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    #region Coleta de Dados
    $activity = "Verificando se a atribuição da política de conformidade para dispositivos Android Enterprise totalmente gerenciados está configurada e atribuída"
    Write-ZtProgress -Activity $activity

    # Consulta 1: Recuperar todas as Políticas de Conformidade de Proprietário de Dispositivo Android e suas atribuições
    $androidDeviceOwnerPolicies = Invoke-ZtGraphRequest -RelativeUri "deviceManagement/deviceCompliancePolicies?`$filter=isOf('microsoft.graph.androidDeviceOwnerCompliancePolicy')&`$expand=assignments" -ApiVersion beta

    #region Lógica de Avaliação
    $passed = $androidDeviceOwnerPolicies.Count -ne 0 -and $androidDeviceOwnerPolicies.Assignments.count -ne 0

    if ($passed) {
        $testResultMarkdown = "✅ Pelo menos uma política de conformidade para Android Enterprise foi encontrada e atribuída.`n`n"
    }
    else {
        $testResultMarkdown = "❌ Nenhuma política de conformidade para Android Enterprise foi encontrada ou nenhuma está atribuída.`n`n"
    }

    # Criar informações detalhadas em tabela se as políticas existirem
    if ($androidDeviceOwnerPolicies) {
        $tableRows = ""
        $reportTitle = "Políticas de Conformidade do Android Enterprise"

        $formatTemplate = @'

## {0}

| Nome da Política | Status | Alvo de Atribuição |
| :---------- | :----- | :---------------- |
{1}

'@

        foreach ($policy in $androidDeviceOwnerPolicies) {
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesComplianceMenu/~/policies'
            $status = if ($policy.assignments.count -gt 0) {
                '✅ Atribuída'
            }
            else {
                '❌ Não Atribuída'
            }

            $policyName = Get-SafeMarkdown -Text $policy.displayName
            $assignmentTarget = "Nenhum"

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }

            $tableRows += @'
| [{0}]({1}) | {2} | {3} |
'@ -f $policyName, $portalLink, $status, $assignmentTarget
            $tableRows += "`n"
        }

         # Formatar o modelo substituindo os espaços reservados pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }
    else {
        $mdInfo = "`nNenhuma política de conformidade para Android Enterprise existe ou nenhuma está atribuída.`n"
    }

    # Substituir o espaço reservado no markdown do resultado do teste pelos detalhes gerados
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId             = '24545'
        Title              = "Atribuição de política de conformidade para dispositivos Android Enterprise totalmente gerenciados está configurada e atribuída"
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
