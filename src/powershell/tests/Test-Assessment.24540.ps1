<#
.SYNOPSIS

#>

function Test-Assessment-24540 {
    [ZtTest(
        Category = 'Dispositivo',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Intune'),
        Pillar = 'Dispositivos',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 24540,
        Title = 'Políticas do Firewall do Windows protegem contra acesso não autorizado à rede',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    #region Coleta de Dados
    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if ( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    $activity = "Verificando se as políticas do Firewall do Windows estão criadas e atribuídas"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    # Consulta: Recuperar todas as políticas de configuração do Firewall do Windows e suas atribuições
    $sql = @"
    SELECT id, name, description, templateReference, to_json(assignments) as assignments
    FROM ConfigurationPolicy
    WHERE templateReference IS NOT NULL
      AND templateReference.templateFamily = 'endpointSecurityFirewall'
"@
    $firewallPoliciesWithAssignments = Invoke-DatabaseQuery -Database $Database -Sql $sql -AsCustomObject

    # região Geração de Relatório
    $passed = $firewallPoliciesWithAssignments.Count -gt 0
    $testResultMarkdown = ''
    if ($passed) {
        $testResultMarkdown = "✅ Políticas do Firewall do Windows foram encontradas e atribuídas."
    } else {
        $testResultMarkdown = "❌ Nenhuma política de configuração do Firewall do Windows encontrada neste tenant."
    }

    # Criar informações detalhadas em tabela se houver políticas
    $mdInfo = ''
    if ($firewallPoliciesWithAssignments) {
        $tableRows = ''
        $reportTitle = "Políticas de Firewall do Windows"

        # Criar uma here-string com espaços reservados para formato {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Política | Status | Alvo de Atribuição |
| :---------- | :----- | :---------------- |
{1}

'@

        foreach ($policy in $firewallPoliciesWithAssignments) {

            $policyName = Get-SafeMarkdown -Text $policy.name
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_Workflows/SecurityManagementMenu/~/firewall'

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $status = "✅ Atribuída"
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }
            else {
                $status = "❌ Não atribuída"
                $assignmentTarget = 'Nenhum'
            }

            $tableRows += "| [$policyName]($portalLink) | $status | $assignmentTarget |`n"
        }

        # Formatar o modelo substituindo os espaços reservados pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }
    else {
        $mdInfo = "Nenhuma política de configuração do Firewall do Windows encontrada neste tenant.`n"
    }

    # Substituir o espaço reservado pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24540'
        Title  = 'A Política do Firewall do Windows está Criada e Atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
