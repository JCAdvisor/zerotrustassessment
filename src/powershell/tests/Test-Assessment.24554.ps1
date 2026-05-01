<#
.SYNOPSIS
    Testa se uma política de atualização do iOS está criada e atribuída
#>

function Test-Assessment-24554 {
    [ZtTest(
    	Category = 'Dispositivo',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger tenants e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24554,
    	Title = 'Políticas de atualização para iOS/iPadOS são aplicadas para reduzir o risco de vulnerabilidades não corrigidas',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Funções Auxiliares
    function Test-PolicyAssignment {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $false)]
            [array]$Policies
        )
        if (-not $Policies) { return $false }
        $assignedPolicies = $Policies | Where-Object {
            $_.PSObject.Properties.Match("assignments") -and $_.assignments -and $_.assignments.Count -gt 0
        }
        return $assignedPolicies.Count -gt 0
    }
    #endregion Funções Auxiliares

    #region Recolha de Dados
    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    $activity = "A verificar as políticas de atualização do iOS"
    Write-ZtProgress -Activity $activity -Status "A obter políticas"

    $iOSUpdatePolicies = Invoke-ZtGraphRequest -RelativeUri "deviceManagement/applePushNotificationCertificate/appleDeviceFeaturesConfiguration" -ApiVersion v1.0
    $updatePoliciesUri = "deviceManagement/iosUpdateConfigurations?`$expand=assignments"
    $iOSUpdatePolicies = Invoke-ZtGraphRequest -RelativeUri $updatePoliciesUri -ApiVersion beta
    #endregion Recolha de Dados

    #region Lógica de Avaliação
    $passed = Test-PolicyAssignment -Policies $iOSUpdatePolicies
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = ""
    if ($passed) {
        $testResultMarkdown = "✅ Pelo menos uma política de atualização para iOS foi encontrada e atribuída.`n`n"
    }
    else {
        $testResultMarkdown = "❌ Nenhuma política de atualização para iOS foi encontrada ou nenhuma está atribuída.`n`n"
    }

    if ($iOSUpdatePolicies.Count -gt 0) {
        $reportTitle = "Políticas de Atualização do iOS"
        $tableRows = ""
        $formatTemplate = @'

## {0}

| Nome da Política | Estado | Alvo da Atribuição |
| :---------- | :----- | :----------------- |
{1}

'@

        foreach ($policy in $iOSUpdatePolicies) {
            $policyName = $policy.displayName
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/iOSiPadOSUpdate'

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $status = "✅ Atribuída"
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }
            else {
                $status = "❌ Não atribuída"
                $assignmentTarget = "Nenhum"
            }

            $tableRows += "| [$(Get-SafeMarkdown($policyName))]($portalLink) | $status | $assignmentTarget |`n"
        }

        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24554'
        Title  = 'Uma política de atualização do iOS está criada e atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
