<#
.SYNOPSIS

#>

function Test-Assessment-24543 {
    [ZtTest(
    	Category = 'tenant',
    	ImplementationCost = 'Baixo',
        MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger tenants e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24543,
    	Title = 'Políticas de conformidade protegem dispositivos iOS/iPadOS',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Coleta de Dados
    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    $activity = "Verificando a atribuição de políticas de conformidade para dispositivos iOS/iPadOS"
    Write-ZtProgress -Activity $activity -Status "Obtendo políticas de conformidade"

    # Consulta 1: Listar todas as políticas de conformidade para iOS/iPadOS no Intune
    $compliancePoliciesUri = "deviceManagement/deviceCompliancePolicies"
    $allCompliancePolicies = Invoke-ZtGraphRequest -RelativeUri $compliancePoliciesUri -ApiVersion v1.0

    # Filtrar para políticas de conformidade do iOS/iPadOS
    $iOSCompliancePolicies = $allCompliancePolicies | Where-Object { $_.'@odata.type' -eq '#microsoft.graph.iosCompliancePolicy' -or $_.'@odata.type' -eq '#microsoft.graph.iosDeviceCompliancePolicy' }
    #endregion Coleta de Dados

    #region Lógica de Avaliação
    $passed = $false
    $testResultMarkdown = ""

    # Verificar se pelo menos uma política de conformidade do iOS/iPadOS existe e está atribuída
    $policiesWithAssignments = @()
    foreach ($policy in $iOSCompliancePolicies) {
        $assignmentsUri = "deviceManagement/deviceCompliancePolicies/$($policy.id)/assignments"
        $assignments = Invoke-ZtGraphRequest -RelativeUri $assignmentsUri -ApiVersion v1.0

        $isAssigned = $assignments.Count -gt 0
        if ($isAssigned) {
            $passed = $true
        }

        $policiesWithAssignments += [PSCustomObject]@{
            displayName = $policy.displayName
            isAssigned  = $isAssigned
            assignments = $assignments
        }
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    if ($passed) {
        $testResultMarkdown = "✅ Pelo menos uma política de conformidade para iOS/iPadOS foi encontrada e atribuída.`n`n"
    }
    else {
        $testResultMarkdown = "❌ Nenhuma política de conformidade para iOS/iPadOS foi encontrada ou nenhuma está atribuída.`n`n"
    }

    # Criar informações detalhadas em tabela se as políticas existirem
    if ($policiesWithAssignments) {
        $tableRows = ""
        $reportTitle = "Políticas de Conformidade do iOS/iPadOS"

        $formatTemplate = @'

## {0}

| Nome da Política | Status | Alvo de Atribuição |
| :---------- | :----- | :---------------- |
{1}

'@

        foreach ($policyWithAssignments in $policiesWithAssignments) {

            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/compliance'

            $status = if ($policyWithAssignments.isAssigned) {
                "✅ Atribuída"
            }
            else {
                "❌ Não atribuída"
            }

            $assignmentTarget = 'Nenhum'

            if ($policyWithAssignments.assignments -and $policyWithAssignments.assignments.Count -gt 0) {
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policyWithAssignments.assignments
            }

            $tableRows += @'
| [{0}]({1}) | {2} | {3} |
'@ -f (Get-SafeMarkdown -Text $policyWithAssignments.displayName), $portalLink, $status, $assignmentTarget
            $tableRows += "`n"
        }

        # Formatar o modelo substituindo os espaços reservados pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }
    else {
        $mdInfo = "Nenhuma política de conformidade para iOS/iPadOS encontrada neste tenant.`n"
    }

    # Substituir o espaço reservado pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24543'
        Title  = 'Atribuição de política de conformidade para dispositivos iOS/iPadOS'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
