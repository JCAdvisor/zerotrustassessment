<#
.SYNOPSIS
    A rede Wi-Fi corporativa em dispositivos Android totalmente gerenciados é gerenciada de forma segura
#>

function Test-Assessment-24840 {
    [ZtTest(
    	Category = 'Dados',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 24840,
    	Title = 'Perfis de Wi-Fi seguros protegem dispositivos Android contra acesso de rede não autorizado',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    #region Coleta de Dados
    $activity = 'Verificando se a rede Wi-Fi corporativa em dispositivos Android totalmente gerenciados está gerenciada de forma segura'
    Write-ZtProgress -Activity $activity

    # Consulta 1: Todos os perfis de configuração Wi-Fi para Android
    $androidWifiConfProfilesUri = "deviceManagement/deviceConfigurations?`$expand=assignments"
    $androidWifiConfProfiles = Invoke-ZtGraphRequest -RelativeUri $androidWifiConfProfilesUri -Filter "isof('microsoft.graph.androidDeviceOwnerEnterpriseWiFiConfiguration')" -ApiVersion beta
    $compliantAndroidWifiConfProfiles = $androidWifiConfProfiles.Where{$_.WifiSecurityType -eq 'wpaEnterprise'}
    #region Lógica de Avaliação
    $passed = $compliantAndroidWifiConfProfiles.Count -gt 0 -and $compliantAndroidWifiConfProfiles.Assignments.count -gt 0

    if ($passed) {
        $testResultMarkdown = "Pelo menos um perfil de Wi-Fi Empresarial para Android existe e está atribuído.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "Nenhum perfil de Wi-Fi Empresarial para Android existe ou nenhum está atribuído.`n`n%TestResult%"
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    # Construir as seções detalhadas do markdown

    # Definir variáveis para inserir na string de formato
    $reportTitle = 'Perfis de Configuração de Wi-Fi para Android'
    $tableRows = ""

    # Gerar linhas de tabela markdown para cada política
    if ($compliantAndroidWifiConfProfiles.Count -gt 0) {
        # Criar uma here-string com placeholders de formatação {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Política | Tipo de Segurança Wi-Fi | Status | Atribuição |
| :---------- | :---------------- | :----- | :--------- |
{1}

'@

        foreach ($policy in $compliantAndroidWifiConfProfiles) {
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesandroidMenu/~/configuration'
            $status = if ($policy.assignments.count -gt 0) {
                '✅ Atribuído'
            }
            else {
                '❌ Não Atribuído'
            }

            $policyName = Get-SafeMarkdown -Text $policy.displayName
            $wifiSecurityType = Get-SafeMarkdown -Text $policy.WifiSecurityType
            $assignmentTarget = "Nenhum"

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }

            $tableRows += @"
| [$policyName]($portalLink) | $wifiSecurityType | $status | $assignmentTarget |
"@
        }

                  # Formatar o template substituindo os placeholders pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

        # Substituir o placeholder no markdown de resultado do teste pelos detalhes gerados
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId             = '24840'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
