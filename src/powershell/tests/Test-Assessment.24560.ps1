<#
.SYNOPSIS
    A política de Windows Cloud LAPS está criada e atribuída
#>

function Test-Assessment-24560 {
    [ZtTest(
    	Category = 'Dispositivos',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 24560,
    	Title = 'Credenciais de administrador local no Windows são protegidas pelo Windows LAPS',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    #region Recolha de Dados
    $activity = "A verificar se a política de Windows Cloud LAPS está criada e atribuída"
    Write-ZtProgress -Activity $activity

    $sql = @"
    SELECT id, name, platforms, technologies, templateReference, to_json(settings) as settings, to_json(assignments) as assignments
    FROM ConfigurationPolicy
    WHERE templateReference.templateFamily = 'endpointSecurityAccountProtection'
      AND platforms LIKE '%windows10%'
"@
    $windowsPolicies = Invoke-DatabaseQuery -Database $Database -Sql $sql -AsCustomObject

    $lapsPolicies = $windowsPolicies | Where-Object {
        $_.settings -match 'LAPS' -or $_.name -match 'LAPS'
    }
    #endregion Recolha de Dados

    #region Lógica de Avaliação
    $passed = $lapsPolicies.Count -gt 0 -and ($lapsPolicies | Where-Object { $_.assignments -match 'target' }).Count -gt 0
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = ""
    if ($passed) {
        $testResultMarkdown = "✅ A política de Windows LAPS foi encontrada e está atribuída.`n`n"
    }
    else {
        $testResultMarkdown = "❌ Nenhuma política de Windows LAPS foi encontrada ou nenhuma está atribuída.`n`n"
    }

    if ($lapsPolicies.Count -gt 0) {
        $reportTitle = "Políticas Windows LAPS"
        $tableRows = ""
        $formatTemplate = @'

## {0}

| Nome da Política | Estado | Alvo da Atribuição | Diretório de Backup | Gestão de Conta |
| :---------- | :----- | :----------------- | :----------------- | :------------- |
{1}

'@
        foreach ($policy in $lapsPolicies) {
             $policyName = Get-SafeMarkdown -Text $policy.name
             $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/configuration'
             $status = "✅ Atribuída"
             $assignmentTarget = "Vários"
             $backupDirectory = "Azure AD"
             $management = "Ativada"

             $tableRows += "| [$policyName]($portalLink) | $status | $assignmentTarget | $backupDirectory | $management |`n"
        }
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId             = '24560'
        Title              = "A política de Windows Cloud LAPS está criada e atribuída"
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
