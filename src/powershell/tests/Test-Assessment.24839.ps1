<#
.SYNOPSIS
    Corporate Wi-Fi network on iOS devices is securely managed
#>

function Test-Assessment-24839 {
    [ZtTest(
    	Category = 'Dados',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 24839,
    	Title = 'Perfis de Wi-Fi seguros protegem dispositivos iOS contra acesso de rede não autorizado',
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
    $activity = "Verificando se a rede Wi-Fi corporativa em dispositivos iOS está gerenciada de forma segura"
    Write-ZtProgress -Activity $activity

    # Consulta 1: Todos os perfis de configuração Wi-Fi para iOS
    $iOSWifiConfProfilesUri = "deviceManagement/deviceConfigurations?`$filter=isof('microsoft.graph.iosWiFiConfiguration')&`$expand=assignments"
    $iOSWifiConfProfiles = Invoke-ZtGraphRequest -RelativeUri $iOSWifiConfProfilesUri -ApiVersion beta
    $compliantIosWifiConfProfiles = $iOSWifiConfProfiles.Where{$_.WifiSecurityType -in @('wpa2Enterprise','wpaEnterprise')}
    #region Lógica de Avaliação
    $passed = $compliantIosWifiConfProfiles.Count -gt 0 -and $compliantIosWifiConfProfiles.Assignments.count -gt 0

    if ($passed) {
        $testResultMarkdown = "Pelo menos um perfil de Wi-Fi Empresarial para iOS existe e está atribuído.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "Nenhum perfil de Wi-Fi Empresarial para iOS existe ou nenhum está atribuído.`n`n%TestResult%"
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    # Construir as seções detalhadas do markdown

    # Definir variáveis para inserir na string de formato
    $reportTitle = "Perfis de Configuração de Wi-Fi para iOS"
    $tableRows = ""

    # Gerar linhas de tabela markdown para cada política
    if ($iOSWifiConfProfiles.Count -gt 0) {
        # Criar uma here-string com placeholders de formatação {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Política | Tipo de Segurança Wi-Fi | Status | Atribuição |
| :---------- | :----- | :--------- | :--------- |
{1}

'@
        foreach ($policy in $iOSWifiConfProfiles) {
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesIosMenu/~/configuration'
            $status = if ($policy.assignments.count -gt 0) {
                '✅ Atribuído'
            }
            else {
                '❌ Não Atribuído'
            }

            $wifiType = Get-WifiSecurityType -SecurityType $policy.wiFiSecurityType

            $policyName = Get-SafeMarkdown -Text $policy.displayName
            $assignmentTarget = "Nenhum"

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }

            $tableRows += "| [$policyName]($portalLink) | $wifiType | $status | $assignmentTarget |`n"
        }

         # Formatar o template substituindo os placeholders pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    # Substituir o placeholder no markdown de resultado do teste pelos detalhes gerados
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId             = '24839'
        Title              = "A rede Wi-Fi corporativa em dispositivos iOS é gerenciada de forma segura"
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
