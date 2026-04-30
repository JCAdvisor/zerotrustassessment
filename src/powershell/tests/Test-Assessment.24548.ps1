<#
.SYNOPSIS
    Existe uma política de proteção de aplicativos para dispositivos iOS
#>

function Test-Assessment-24548 {
    [ZtTest(
    	Category = 'Dados',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 24548,
    	Title = 'Dados no iOS/iPadOS estão protegidos por políticas de proteção de aplicativos',
    	UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    #region Recolha de Dados
    $activity = "A verificar se existe uma política de proteção de aplicativos para dispositivos iOS"
    Write-ZtProgress -Activity $activity

    # Consulta 1: Obter todas as Políticas de Proteção de Aplicações iOS e as suas atribuições
    $iosAppProtectionPolicies = Invoke-ZtGraphRequest -RelativeUri 'deviceAppManagement/iosManagedAppProtections?$expand=assignments' -ApiVersion v1.0
    #endregion Recolha de Dados

    #region Lógica de Avaliação
    $passed = $iosAppProtectionPolicies.Count -ne 0 -and $iosAppProtectionPolicies.Where{$_.IsAssigned -eq $true}.count -ne 0

    if ($passed) {
        $testResultMarkdown = "✅ Pelo menos uma política de proteção de aplicativos para iOS foi encontrada e atribuída.`n`n"
    }
    else {
        $testResultMarkdown = "❌ Nenhuma política de proteção de aplicativos para iOS foi encontrada ou nenhuma está atribuída.`n`n"
    }

    # Gerar linhas da tabela markdown para cada política
    if ($iosAppProtectionPolicies.Count -gt 0) {
        $reportTitle = "Políticas de Proteção de Aplicações iOS"
        $tableRows = ""

        # Criar uma here-string com marcadores de formato {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Política | Estado | Atribuição |
| :---------- | :----- | :--------- |
{1}

'@

        foreach ($policy in $iosAppProtectionPolicies) {
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/AppsMenu/~/protection'
            $status = if ($policy.IsAssigned) {
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
| [$policyName]($portalLink) | $status | $assignmentTarget |`n
"@
        }

        # Formatar o modelo substituindo os marcadores pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    # Substituir o marcador no markdown do resultado do teste pelos detalhes gerados
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId             = '24548'
        Title              = "Existe uma política de proteção de aplicativos para dispositivos iOS"
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}