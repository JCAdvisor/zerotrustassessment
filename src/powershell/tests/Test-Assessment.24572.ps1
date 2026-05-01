<#
.SYNOPSIS
    A notificação de registo de dispositivos está configurada e atribuída
#>

function Test-Assessment-24572 {
    [ZtTest(
    	Category = 'tenant',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger tenants e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24572,
    	Title = 'Notificações de registo de dispositivos são impostas para garantir a consciencialização do utilizador',
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
    $activity = "A verificar se a notificação de registo de dispositivos está configurada e atribuída"
    Write-ZtProgress -Activity $activity -Status "A obter configurações"

    $enrollmentNotificationsUri = "deviceManagement/deviceEnrollmentConfigurations?`$expand=assignments&`$filter=deviceEnrollmentConfigurationType eq 'EnrollmentNotificationsConfiguration'"
    $enrollmentNotifications = Invoke-ZtGraphRequest -RelativeUri $enrollmentNotificationsUri -ApiVersion beta
    #endregion Recolha de Dados

    #region Lógica de Avaliação
    $passed = $false
    if ($enrollmentNotifications.value.Count -gt 0) {
        foreach ($policy in $enrollmentNotifications.value) {
            if ($policy.assignments.Count -gt 0) {
                $passed = $true
                break
            }
        }
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = if ($passed) { "✅ Notificações de registo de dispositivos foram encontradas e atribuídas.`n`n" } else { "❌ Nenhuma notificação de registo de dispositivos encontrada ou atribuída.`n`n" }

    if ($enrollmentNotifications.value.Count -gt 0) {
        $reportTitle = "Configurações de Notificação de Registo"
        $tableRows = ""
        $formatTemplate = @'

## {0}

| Nome da Política | Estado | Alvo da Atribuição |
| :---------- | :----- | :---------------- |
{1}

'@
        foreach ($policy in $enrollmentNotifications.value) {
            $policyName = Get-SafeMarkdown -Text $policy.displayName
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/enrollment'
            $status = if ($policy.assignments.Count -gt 0) { "✅ Atribuída" } else { "❌ Não atribuída" }
            $assignmentTarget = if ($policy.assignments.Count -gt 0) { Get-PolicyAssignmentTarget -Assignments $policy.assignments } else { "Nenhum" }
            $tableRows += "| [$policyName]($portalLink) | $status | $assignmentTarget |`n"
        }
        $testResultMarkdown += $formatTemplate -f $reportTitle, $tableRows
    }
    #endregion Geração de Relatório

    $params = @{
        TestId = '24572'
        Title  = 'A notificação de registo de dispositivos está configurada e atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
