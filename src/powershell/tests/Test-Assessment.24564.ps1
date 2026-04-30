<#
.SYNOPSIS
    Testa se a política de Usuários e Grupos Locais do Intune foi criada e atribuída
#>

function Test-Assessment-24564 {
    [ZtTest(
        Category = 'Dispositivo',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Intune'),
        Pillar = 'Dispositivos',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger identidades e segredos',
        TenantType = ('Workforce'),
        TestId = 24564,
        Title = 'O uso de contas locais no Windows é restrito para reduzir o acesso não autorizado',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if ( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    #region Coleta de Dados
    $activity = "Verificando se a política de Usuários e Grupos Locais do Intune foi criada e atribuída"
    Write-ZtProgress -Activity $activity -Status "Obtendo políticas"

    $sql = @"
    SELECT id, name, description, to_json(assignments) as assignments
    FROM ConfigurationPolicy
    WHERE templateReference IS NOT NULL
      AND templateReference.templateFamily = 'endpointSecurityAccountProtection'
      AND platforms LIKE '%windows10%'
"@
    $windowsLocalPolicies = Invoke-DatabaseQuery -Database $Database -Sql $sql -AsCustomObject
    #endregion Coleta de Dados

    #region Lógica de Avaliação
    $passed = $false
    foreach ($policy in $windowsLocalPolicies) {
        $policyAssignments = $policy.assignments | ConvertFrom-Json
        if ($policyAssignments -and $policyAssignments.Count -gt 0) {
            $passed = $true
            break
        }
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = if ($passed) { "✅ Políticas de Usuários e Grupos Locais foram encontradas e atribuídas.`n`n" } else { "❌ Nenhuma política de Usuários e Grupos Locais encontrada ou atribuída.`n`n" }

    if ($windowsLocalPolicies.Count -gt 0) {
        $reportTitle = "Políticas de Usuários e Grupos Locais"
        $tableRows = ""
        $formatTemplate = @'

## {0}

| Nome da Política | Status | Alvo de Atribuição |
| :---------- | :----- | :---------------- |
{1}

'@
        foreach ($policy in $windowsLocalPolicies) {
            $policyName = Get-SafeMarkdown -Text $policy.name
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/configuration'
            $policyAssignments = $policy.assignments | ConvertFrom-Json
            $status = if ($policyAssignments.Count -gt 0) { "✅ Atribuída" } else { "❌ Não atribuída" }
            $tableRows += "| [$policyName]($portalLink) | $status | Vários |`n"
        }
        $testResultMarkdown += $formatTemplate -f $reportTitle, $tableRows
    }
    #endregion Geração de Relatório

    $params = @{
        TestId = '24564'
        Title  = 'A política de Usuários e Grupos Locais do Intune foi criada e atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}