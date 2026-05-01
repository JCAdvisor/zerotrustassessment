<#
.SYNOPSIS
    A Política de Conformidade para o Perfil de Trabalho de Propriedade Pessoal do Android Enterprise está configurada e atribuída
#>

function Test-Assessment-24547 {
    [ZtTest(
    	Category = 'tenant',
    	ImplementationCost = 'Baixo',
        MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger tenants e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24547,
    	Title = 'Políticas de conformidade protegem dispositivos Android de propriedade pessoal',
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
    $activity = "A verificar se a política de conformidade para o Perfil de Trabalho de Propriedade Pessoal do Android Enterprise está configurada e atribuída"
    Write-ZtProgress -Activity $activity

    # Consulta 1: Obter todas as Políticas de Conformidade de Perfil de Trabalho Android e as suas atribuições
    $androidDeviceWorkProfilePolicies = Invoke-ZtGraphRequest -RelativeUri 'deviceManagement/deviceCompliancePolicies?$filter=isOf(''microsoft.graph.androidWorkProfileCompliancePolicy'')&$expand=assignments' -ApiVersion beta

    #region Lógica de Avaliação
    $passed = $androidDeviceWorkProfilePolicies.Count -ne 0 -and $androidDeviceWorkProfilePolicies.Assignments.count -ne 0

    if ($passed) {
        $testResultMarkdown = "✅ Pelo menos uma política de conformidade para o Perfil de Trabalho Android foi encontrada e atribuída.`n`n"
    }
    else {
        $testResultMarkdown = "❌ Nenhuma política de conformidade para o Perfil de Trabalho Android foi encontrada ou nenhuma está atribuída.`n`n"
    }

    # Gerar linhas da tabela markdown para cada política
    if ($androidDeviceWorkProfilePolicies) {
        $reportTitle = "Políticas de Conformidade de Perfil de Trabalho Android"
        $tableRows = ""

        # Criar uma here-string com marcadores de formato {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Política | Estado | Atribuição |
| :---------- | :----- | :--------- |
{1}

'@

        foreach ($policy in $androidDeviceWorkProfilePolicies) {
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

            $tableRows += @"
| [$policyName]($portalLink) | $status | $assignmentTarget |
"@
        }

         # Formatar o modelo substituindo os marcadores pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    # Substituir o marcador no markdown do resultado do teste pelos detalhes gerados
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId             = '24547'
        Title              = "A Política de Conformidade para o Perfil de Trabalho de Propriedade Pessoal do Android Enterprise está configurada e atribuída"
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
