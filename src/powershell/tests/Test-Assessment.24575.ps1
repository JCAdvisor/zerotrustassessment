<#
.SYNOPSIS
    Uma política do Microsoft Defender Antivírus está criada e atribuída
#>

function Test-Assessment-24575 {
    [ZtTest(
        Category = 'Dispositivo',
        ImplementationCost = 'Médio',
        MinimumLicense = ('Intune'),
        Pillar = 'Dispositivos',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 24575,
        Title = 'Políticas do Defender Antivírus protegem dispositivos Windows contra malware',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param($Database)

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if ( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    #region Recolha de Dados
    $activity = "A verificar se uma política do Microsoft Defender Antivírus está criada e atribuída"
    Write-ZtProgress -Activity $activity

    $sql = @"
    SELECT id, name, platforms, technologies, templateReference, to_json(settings) as settings, to_json(assignments) as assignments
    FROM ConfigurationPolicy
    WHERE platforms LIKE '%windows10%'
      AND technologies LIKE '%mdm%'
      AND technologies LIKE '%microsoftSense%'
"@
    $avPolicies = Invoke-DatabaseQuery -Database $Database -Sql $sql -AsCustomObject
    #endregion Recolha de Dados

    #region Lógica de Avaliação
    $passed = $false
    if ($avPolicies.Count -gt 0) {
        foreach ($policy in $avPolicies) {
            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $passed = $true
                break
            }
        }
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = if ($passed) { "✅ Políticas do Microsoft Defender Antivírus foram encontradas e atribuídas.`n`n" } else { "❌ Nenhuma política de Antivírus encontrada ou atribuída.`n`n" }

    if ($avPolicies.Count -gt 0) {
        $reportTitle = "Políticas do Microsoft Defender Antivírus"
        $tableRows = ""
        $formatTemplate = @'

## {0}

| Nome da Política | Estado | Alvo da Atribuição |
| :---------- | :----- | :---------------- |
{1}

'@
        foreach ($policy in $avPolicies) {
            $policyName = Get-SafeMarkdown -Text $policy.name
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_Workflows/SecurityManagementMenu/~/antivirus'
            $status = if ($policy.assignments.Count -gt 0) { "✅ Atribuída" } else { "❌ Não atribuída" }
            $tableRows += "| [$policyName]($portalLink) | $status | Vários |`n"
        }
        $testResultMarkdown += $formatTemplate -f $reportTitle, $tableRows
    }
    #endregion Geração de Relatório

    $params = @{
        TestId = '24575'
        Title  = 'A política do Microsoft Defender Antivírus está criada e atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}