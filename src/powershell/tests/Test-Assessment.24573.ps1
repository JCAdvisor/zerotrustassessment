<#
.SYNOPSIS
    A linha de base de segurança do Windows está configurada e atribuída
#>

function Test-Assessment-24573 {
    [ZtTest(
    	Category = 'Locatário',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24573,
    	Title = 'Linhas de base de segurança são aplicadas a dispositivos Windows para reforçar a postura de segurança',
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
    $activity = "A verificar se uma linha de base de segurança do Windows está configurada e atribuída"
    Write-ZtProgress -Activity $activity -Status "A obter intenções de segurança"

    $baselinesUri = 'deviceManagement/intents?$expand=assignments'
    $allBaselines = Invoke-ZtGraphRequest -RelativeUri $baselinesUri -ApiVersion beta
    #endregion Recolha de Dados

    #region Lógica de Avaliação
    $passed = $false
    if ($allBaselines.value.Count -gt 0) {
        foreach ($policy in $allBaselines.value) {
            if ($policy.assignments.Count -gt 0) {
                $passed = $true
                break
            }
        }
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = if ($passed) { "✅ Linhas de base de segurança do Windows foram encontradas e atribuídas.`n`n" } else { "❌ Nenhuma linha de base de segurança encontrada ou atribuída.`n`n" }

    if ($allBaselines.value.Count -gt 0) {
        $reportTitle = "Linhas de Base de Segurança do Windows"
        $tableRows = ""
        $formatTemplate = @'

## {0}

| Nome da Política | Estado | Alvo da Atribuição |
| :---------- | :----- | :---------------- |
{1}

'@
        foreach ($policy in $allBaselines.value) {
            $policyName = Get-SafeMarkdown -Text $policy.displayName
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_Workflows/SecurityManagementMenu/~/securityBaselines'
            $status = if ($policy.assignments.Count -gt 0) { "✅ Atribuída" } else { "❌ Não atribuída" }
            $assignmentTarget = if ($policy.assignments.Count -gt 0) { Get-PolicyAssignmentTarget -Assignments $policy.assignments } else { "Nenhum" }
            $tableRows += "| [$policyName]($portalLink) | $status | $assignmentTarget |`n"
        }
        $testResultMarkdown += $formatTemplate -f $reportTitle, $tableRows
    }
    #endregion Geração de Relatório

    $params = @{
        TestId = '24573'
        Title  = 'A Linha de Base de Segurança do Windows está Configurada e Atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}