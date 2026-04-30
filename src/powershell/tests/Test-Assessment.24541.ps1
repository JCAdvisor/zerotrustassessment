<#
.SYNOPSIS
    Uma política de conformidade para dispositivos Windows existe e está atribuída
#>

function Test-Assessment-24541 {
    [ZtTest(
    	Category = 'Locatário',
    	ImplementationCost = 'Baixo',
        MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24541,
    	Title = 'Políticas de conformidade protegem dispositivos Windows',
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

    $activity = "Verificando se as políticas de conformidade do Windows estão criadas e atribuídas"
    Write-ZtProgress -Activity $activity -Status "Obtendo políticas de conformidade"

    # Consulta 1: Listar todas as políticas de conformidade para Windows no Intune
    $compliancePoliciesUri = 'deviceManagement/deviceCompliancePolicies?$expand=assignments'
    $allCompliancePolicies = Invoke-ZtGraphRequest -RelativeUri $compliancePoliciesUri -ApiVersion v1.0

    # Filtrar para políticas de conformidade do Windows
    $windowsCompliancePolicies = $allCompliancePolicies | Where-Object {
        $_.'@odata.type' -eq '#microsoft.graph.windows10CompliancePolicy' -or
        $_.'@odata.type' -eq '#microsoft.graph.windows81CompliancePolicy'
    }
    #endregion Coleta de Dados

    #region Lógica de Avaliação
    $passed = $false
    $testResultMarkdown = ""

    # Verificar se pelo menos uma política de conformidade do Windows existe e está atribuída
    foreach ($policy in $windowsCompliancePolicies) {
        if ($policy.assignments.Count -gt 0) {
            $passed = $true
            break
        }
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    if ($passed) {
        $testResultMarkdown = "✅ Pelo menos uma política de conformidade para Windows foi encontrada e atribuída.`n`n"
    }
    else {
        $testResultMarkdown = "❌ Nenhuma política de conformidade para Windows foi encontrada ou nenhuma está atribuída.`n`n"
    }

    # Criar informações detalhadas em tabela se as políticas existirem
    if ($windowsCompliancePolicies) {
        $tableRows = ""
        $reportTitle = "Políticas de Conformidade do Windows"

        $formatTemplate = @'

## {0}

| Nome da Política | Status | Atribuição |
| :---------- | :----- | :--------- |
{1}

'@

        foreach ($policy in $windowsCompliancePolicies) {
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/compliance'
            $status = if ($policy.assignments.Count -gt 0) {
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
        $mdInfo = "Nenhuma política de conformidade para Windows existe ou nenhuma está atribuída.`n"
    }

    # Substituir o espaço reservado pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24541'
        Title  = 'A Política de Conformidade do Windows está Criada e Atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}