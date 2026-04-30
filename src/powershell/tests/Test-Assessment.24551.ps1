<#
.SYNOPSIS
    A Política de Windows Hello para Empresas está configurada e atribuída
#>

function Test-Assessment-24551 {
    [ZtTest(
    	Category = 'Dispositivo',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 24551,
    	Title = 'A autenticação no Windows utiliza o Windows Hello para Empresas',
    	UserImpact = 'Médio'
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
    $activity = "A verificar se a Política de Windows Hello para Empresas está configurada e atribuída"
    Write-ZtProgress -Activity $activity

    # Consulta 1: Obter atribuição para Políticas de Configuração de Windows Hello para Empresas ao nível do locatário
    $windowsHelloTenantConfig = Invoke-ZtGraphRequest -RelativeUri "deviceManagement/deviceEnrollmentConfigurations?`$filter=deviceEnrollmentConfigurationType eq 'windowsHelloForBusiness'" -ApiVersion beta

    # Consulta 2: Obter atribuição para Políticas MDM relacionadas com Windows Hello para Empresas
    $sql = @"
    SELECT id, name, platforms, technologies, to_json(settings) as settings, to_json(assignments) as assignments
    FROM ConfigurationPolicy
    WHERE templateReference IS NOT NULL
      AND templateReference.templateFamily = 'endpointSecurityAccountProtection'
"@
    $windowsHelloMdmPolicies = Invoke-DatabaseQuery -Database $Database -Sql $sql -AsCustomObject

    # Processar campo de configurações e atribuições JSON
    foreach ($policy in $windowsHelloMdmPolicies) {
        if ($policy.settings -is [string]) { $policy.settings = $policy.settings | ConvertFrom-Json }
        if ($policy.assignments -is [string]) { $policy.assignments = $policy.assignments | ConvertFrom-Json }
    }

    # Filtrar apenas políticas que configuram WHfB
    $windowsHelloMdmPolicies = $windowsHelloMdmPolicies | Where-Object {
        $_.settings.value.Match("PassportForWork") -or $_.settings.value.Match("WindowsHelloForBusiness")
    }
    #endregion Recolha de Dados

    #region Lógica de Avaliação
    $tenantConfigState = $windowsHelloTenantConfig.priority -eq 0
    $mdmPolicyAssigned = $windowsHelloMdmPolicies | Where-Object { $_.assignments.Count -gt 0 }

    $passed = $tenantConfigState -or ($null -ne $mdmPolicyAssigned)
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    if ($passed) {
        $testResultMarkdown = "✅ O Windows Hello para Empresas está configurado através de políticas ao nível do locatário ou MDM.`n`n"
    }
    else {
        $testResultMarkdown = "❌ O Windows Hello para Empresas não parece estar configurado ou atribuído.`n`n"
    }

    # Gerar informações detalhadas
    $reportTitle = "Configurações de Windows Hello para Empresas"
    $tableRows = ""
    $formatTemplate = @'

## {0}

Estado da Configuração do Locatário: **{2}**

| Nome da Política | Estado | Alvo da Atribuição |
| :---------- | :----- | :---------------- |
{1}

'@

    $tenantConfigState = if ($tenantConfigState) { "✅ Ativado por Defeito" } else { "❌ Não Ativado por Defeito" }

    # Gerar linhas da tabela markdown para cada política
    if ($windowsHelloMdmPolicies.Count -gt 0) {
        foreach ($policy in $windowsHelloMdmPolicies) {
            $policyName = Get-SafeMarkdown -Text $policy.name
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/configuration'

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $status = "✅ Atribuída"
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }
            else {
                $status = "❌ Não atribuída"
                $assignmentTarget = 'Nenhum'
            }

            $tableRows += "| [$policyName]($portalLink) | $status | $assignmentTarget |`n"
        }
    }

    # Formatar o modelo substituindo os marcadores pelos valores
    $mdInfo = $formatTemplate -f $reportTitle, $tableRows, $tenantConfigState

    # Substituir o marcador no markdown do resultado do teste pelos detalhes gerados
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId             = '24551'
        Title              = "A Política de Windows Hello para Empresas está configurada e atribuída"
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}