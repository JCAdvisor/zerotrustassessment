
<#
.SYNOPSIS

#>



function Test-Assessment-24690 {
    [ZtTest(
    	Category = 'Dispositivo',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24690,
    	Title = 'As políticas de atualização do macOS são impostas para reduzir o risco de vulnerabilidades não corrigidas',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Funções Auxiliares

    function Test-PolicyAssignment {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [AllowNull()]
            $Policies
        )

        # Verificar se existe pelo menos uma política
        if ($Policies.Count -gt 0) {
            # Verificar se pelo menos uma política tem atribuições
            $assignedPolicies = $Policies | Where-Object {
                $_.assignments -and $_.assignments.Count -gt 0
            }

            return $assignedPolicies.Count -gt 0
        }

        return $false
    }
    #endregion Funções Auxiliares

    #region Coleta de Dados
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    $activity = "Verificando se a política de atualização do macOS está configurada e atribuída "
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    # Recuperar todas as políticas de atualização do macOS e suas possíveis atribuições
    # Políticas de Atualização do macOS MDM
    $macOSUpdatePolicies_MDMUri = "deviceManagement/deviceConfigurations?`$filter=isof('microsoft.graph.macOSSoftwareUpdateConfiguration')&`$expand=assignments"
    $macOSUpdatePolicies_MDM_assignments = Invoke-ZtGraphRequest -RelativeUri $macOSUpdatePolicies_MDMUri -ApiVersion beta

    # Políticas de Atualização do macOS DDM
    $macOSPolicies_DDMUri = "deviceManagement/configurationPolicies?&`$filter=(platforms has 'macOS') and (technologies has 'mdm' or technologies has 'appleRemoteManagement')&`$expand=settings"
    $macOSPolicies_DDM = Invoke-ZtGraphRequest -RelativeUri $macOSPolicies_DDMUri -ApiVersion beta

    $macOSUpdatePolicies_DDM = @()
    foreach ($macOSPolicy_DDM in $macOSPolicies_DDM) {
        $validSettingIds = @('ddm-latestsoftwareupdate_enforcelatestsoftwareupdateversion', 'enforcement_targetosversion')

        # Obter todos os IDs de definição de configuração da política (manipular valores únicos e arrays)
        $policySettingIds = $macOSPolicy_DDM.settings.settingInstance.groupSettingCollectionValue.Children.settingDefinitionId

        # Converter para array se for um único valor para garantir manipulação consistente
        if ($policySettingIds -isnot [array]) {
            $policySettingIds = @($policySettingIds)
        }

        # Verificar se algum ID de configuração da política corresponde aos IDs de configuração válidos
        $hasValidSetting = $false
        foreach ($settingId in $policySettingIds) {
            if ($validSettingIds -contains $settingId) {
                $hasValidSetting = $true
                break
            }
        }

        if ($hasValidSetting) {
            $macOSUpdatePolicies_DDM += $macOSPolicy_DDM
        }
    }

    # Obter atribuições para políticas DDM
    $macOSUpdatePolicies_DDM_assignments = @()
    foreach ($macOSUpdatePolicy_DDM in $macOSUpdatePolicies_DDM) {
        $assignments = Invoke-ZtGraphRequest -RelativeUri "deviceManagement/configurationPolicies('$($macOSUpdatePolicy_DDM.id)')/assignments" -ApiVersion beta
        $macOSUpdatePolicy_DDM | Add-Member -MemberType NoteProperty -Name assignments -Value $assignments -Force
        $macOSUpdatePolicies_DDM_assignments += $macOSUpdatePolicy_DDM
    }

    $macOSUpdatePolicies = @($macOSUpdatePolicies_MDM_assignments) + @($macOSUpdatePolicies_DDM_assignments)

    #endregion Coleta de Dados

    #region Lógica de Avaliação
    $passed = $false
    $testResultMarkdown = ""

    # Testar atribuições de políticas MDM e DDM
    $passed_MDM = Test-PolicyAssignment -Policies $macOSUpdatePolicies_MDM_assignments
    $passed_DDM = Test-PolicyAssignment -Policies $macOSUpdatePolicies_DDM_assignments

    # Aprovar se alguma das políticas MDM ou DDM estiver atribuída
    $passed = $passed_MDM -or $passed_DDM

    if ($passed) {
        $testResultMarkdown = "Pelo menos uma política de atualização do macOS está atribuída a um grupo.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "Nenhuma política de atualização do macOS foi criada, ou as políticas criadas não estão atribuídas.`n`n%TestResult%"
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    # Construir as seções detalhadas do markdown

    # Definir variáveis para inserir na string de formato
    $reportTitle = "Políticas de Atualização do macOS"
    $tableRows = ""

    if ($macOSUpdatePolicies.Count -gt 0) {
        # Criar uma here-string com placeholders de formatação {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Política | Status | Alvo de Atribuição |
| :---------- | :----- | :---------------- |
{1}

'@

        foreach ($policy in $macOSUpdatePolicies) {


            if ($policy.'@odata.type' -eq '#microsoft.graph.macOSSoftwareUpdateConfiguration') {
                $policyName = $policy.displayName
                $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/iOSiPadOSUpdate'
            }
            else {
                $policyName = $policy.Name
                $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/configuration'
            }

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $status = "✅ Atribuída"
            }
            else {
                $status = "❌ Não atribuída"
            }

            # Obter detalhes de atribuição para esta política específica
            $assignmentTarget = "Nenhuma"

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }

            $tableRows += @"
| [$(Get-SafeMarkdown($policyName))]($portalLink) | $status | $assignmentTarget |`n
"@
        }

        # Formatar o modelo substituindo placeholders pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }
    else {
        $mdInfo = "Nenhuma política de atualização do macOS encontrada neste locatário.`n"
    }

    # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24690'
        Title  = 'A política de atualização do macOS está configurada e atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
