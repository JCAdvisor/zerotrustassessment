<#
.SYNOPSIS

#>

function Test-Assessment-24802 {
    [ZtTest(
    	Category = 'Tenant',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Baixo',
    	SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce'),
    	TestId = 24802,
    	Title = 'Regras de limpeza de dispositivos mantêm a higiene do locatário ocultando dispositivos inativos',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Coleta de Dados
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    $activity = "Verificando se a Regra de Limpeza de Dispositivos está criada"
    Write-ZtProgress -Activity $activity -Status "Obtendo regras"

    # Recuperar todas as regras de limpeza de dispositivos configuradas no Intune
    $cleanupRulesUri = 'deviceManagement/managedDeviceCleanupRules'
    $cleanupRules = Invoke-ZtGraphRequest -RelativeUri $cleanupRulesUri -ApiVersion 'beta'

    #endregion Data Collection

    #region Lógica de Avaliação
    $passed = $false
    $testResultMarkdown = ""

    # Verificar se ao menos uma regra de limpeza de dispositivos existe
    $passed = $cleanupRules -and $cleanupRules.Count -gt 0

    if ($passed) {
        $testResultMarkdown = "Pelo menos uma regra de limpeza de dispositivos existe.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "Nenhuma regra de limpeza de dispositivo existe.`n`n%TestResult%"
    }

    #endregion Lógica de Avaliação

    #region Geração de Relatório
    # Construir as seções detalhadas do markdown

    # Definir variáveis para inserir na string de formato
    $reportTitle = "Regras de Limpeza de Dispositivos"
    $tableRows = ""


    if ($cleanupRules -and $cleanupRules.Count -gt 0) {
        # Criar uma here-string com placeholders de formatação {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Regra | Plataforma ou SO |
| :-------- | :------------- |
{1}

'@

        foreach ($cleanupRule in $cleanupRules) {
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/deviceCleanUp'

            $ruleName = Get-SafeMarkdown -Text $cleanupRule.displayName

            $platformType = $cleanupRule.deviceCleanupRulePlatformType

            $tableRows += @"
| [$ruleName]($portalLink) | $platformType |`n
"@
        }

                 # Formatar o template substituindo os placeholders pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24802'
        Title  = 'Uma Regra de Limpeza de Dispositivos está criada'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
