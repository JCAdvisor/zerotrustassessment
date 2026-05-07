<#
.SYNOPSIS
    A rede Wi-Fi corporativa em dispositivos macOS é gerenciada de forma segura
#>

function Test-Assessment-24870 {
    [ZtTest(
    	Category = 'Dados',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24870,
    	Title = 'Perfis de Wi-Fi seguros protegem dispositivos macOS contra acesso de rede não autorizado',
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
    $activity = "Verificando se a rede Wi-Fi corporativa em dispositivos macOS está gerenciada de forma segura"
    Write-ZtProgress -Activity $activity

    # Consulta 1: Todos os perfis de configuração Wi-Fi para macOS
    $macOSWifiConfProfilesUri = "deviceManagement/deviceConfigurations?`$filter=isof('microsoft.graph.macOSWiFiConfiguration')&`$expand=assignments"
    $macOSWifiConfProfiles = Invoke-ZtGraphRequest -RelativeUri $macOSWifiConfProfilesUri -ApiVersion beta
    $compliantMacOSWifiConfProfiles = $macOSWifiConfProfiles.Where{$_.WifiSecurityType -eq 'wpaEnterprise'}
    #region Assessment Logic
    $passed = $compliantMacOSWifiConfProfiles.Count -gt 0 -and $compliantMacOSWifiConfProfiles.Assignments.count -gt 0

    if ($passed) {
        $testResultMarkdown = "Pelo menos um perfil de Wi-Fi Empresarial para macOS existe e está atribuído.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "Nenhum perfil de Wi-Fi Empresarial para macOS existe ou nenhum está atribuído.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Geração de Relatório
    # Construir as seções detalhadas do markdown

    # Definir variáveis para inserir na string de formato
    $reportTitle = "macOS WiFi Configuration Profiles"
    $tableRows = ""

    # Gerar linhas de tabela markdown para cada política
    if ($compliantMacOSWifiConfProfiles.Count -gt 0) {
        # Criar uma here-string com placeholders de formatação {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Política | Status | Atribuição |
| :---------- | :----- | :--------- |
{1}

'@

        foreach ($policy in $compliantMacOSWifiConfProfiles) {
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMacOsMenu/~/macOsDevices'
            $status = if ($policy.assignments.count -gt 0) {
                '✅ Atribuído'
            }
            else {
                '❌ Não Atribuído'
            }

            $policyName = Get-SafeMarkdown -Text $policy.displayName
            $assignmentTarget = "Nenhum"

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }

            $tableRows += @"
| [$policyName]($portalLink) | $status | $assignmentTarget |
"@
        }

         # Formatar o template substituindo os placeholders pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    # Substituir o placeholder no markdown de resultado do teste pelos detalhes gerados
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId             = '24870'
        Title              = "A rede Wi-Fi corporativa em dispositivos macOS é gerenciada de forma segura"
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
