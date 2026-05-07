<#
.SYNOPSIS
    Testa se a política de SSO de plataforma para macOS foi criada e atribuída
#>

function Test-Assessment-24568 {
    [ZtTest(
        Category = 'Tenant',
        ImplementationCost = 'Médio',
        MinimumLicense = ('Intune'),
        Pillar = 'Dispositivos',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger tenants e isolar sistemas de produção',
        TenantType = ('Workforce'),
        TestId = 24568,
        Title = 'O SSO de plataforma está configurado para fortalecer a autenticação em dispositivos macOS',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param($Database)

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if ( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    #region Coleta de Dados
    $activity = "Verificando se a política de SSO de plataforma para macOS foi criada e atribuída"
    Write-ZtProgress -Activity $activity -Status "Obtendo políticas"

    $sql = @"
    SELECT id, name, to_json(assignments) as assignments, to_json(settings) as settings
    FROM ConfigurationPolicy
    WHERE platforms LIKE '%macOS%'
      AND technologies LIKE '%mdm%'
"@
    $macOSPolicies = Invoke-DatabaseQuery -Database $Database -Sql $sql -AsCustomObject
    #endregion Coleta de Dados

    #region Lógica de Avaliação
    $passed = $false
    $ssoPolicies = @()
    foreach ($policy in $macOSPolicies) {
        if ($policy.settings -match "com.microsoft.CompanyPortalMac.ssoextension") {
            $ssoPolicies += $policy
            $policyAssignments = $policy.assignments | ConvertFrom-Json
            if ($policyAssignments.Count -gt 0) {
                $passed = $true
            }
        }
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = if ($passed) { "✅ Políticas de SSO de plataforma para macOS foram encontradas e atribuídas.`n`n" } else { "❌ Nenhuma política de SSO de plataforma encontrada ou atribuída.`n`n" }

    if ($ssoPolicies.Count -gt 0) {
        $reportTitle = "Políticas de SSO de plataforma macOS"
        $tableRows = ""
        $formatTemplate = @'

## {0}

| Nome da Política | Status | Alvo de Atribuição |
| :---------- | :----- | :---------------- |
{1}

'@
        foreach ($policy in $ssoPolicies) {
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
        TestId = '24568'
        Title  = 'macOS - O SSO de plataforma está configurado e atribuído'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
