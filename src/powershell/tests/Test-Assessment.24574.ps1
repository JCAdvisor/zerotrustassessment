<#
.SYNOPSIS
    Implementar políticas de Redução da Superfície de Ataque (ASR) para dispositivos Windows
#>

function Test-Assessment-24574 {
    [ZtTest(
    	Category = 'Dispositivos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 24574,
    	Title = 'Regras de Redução da Superfície de Ataque são aplicadas para prevenir a exploração de componentes vulneráveis',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param($Database)

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    #region Recolha de Dados
    $activity = "A verificar se uma política de ASR para Windows está criada e atribuída"
    Write-ZtProgress -Activity $activity

    $sql = @"
    SELECT id, name, platforms, technologies, to_json(settings) as settings, to_json(assignments) as assignments
    FROM ConfigurationPolicy
    WHERE platforms LIKE '%windows10%'
      AND technologies LIKE '%mdm%'
      AND technologies LIKE '%microsoftSense%'
"@
    $asrPolicies = Invoke-DatabaseQuery -Database $Database -Sql $sql -AsCustomObject
    #endregion Recolha de Dados

    #region Lógica de Avaliação
    $passed = $false
    if ($asrPolicies.Count -gt 0) {
        foreach ($policy in $asrPolicies) {
            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $passed = $true
                break
            }
        }
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = if ($passed) { "✅ Políticas de ASR para Windows foram encontradas e atribuídas.`n`n" } else { "❌ Nenhuma política de ASR encontrada ou atribuída.`n`n" }

    if ($asrPolicies.Count -gt 0) {
        $reportTitle = "Regras de Redução da Superfície de Ataque"
        $tableRows = ""
        $formatTemplate = @'

## {0}

| Nome da Política | Estado | Alvo da Atribuição |
| :---------- | :----- | :---------------- |
{1}

'@
        foreach ($policy in $asrPolicies) {
            $policyName = Get-SafeMarkdown -Text $policy.name
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_Workflows/SecurityManagementMenu/~/asr'
            $status = if ($policy.assignments.Count -gt 0) { "✅ Atribuída" } else { "❌ Não atribuída" }
            $tableRows += "| [$policyName]($portalLink) | $status | Vários |`n"
        }
        $testResultMarkdown += $formatTemplate -f $reportTitle, $tableRows
    }
    #endregion Geração de Relatório

    $params = @{
        TestId = '24574'
        Title  = 'Políticas de Redução da Superfície de Ataque (ASR) estão configuradas'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
