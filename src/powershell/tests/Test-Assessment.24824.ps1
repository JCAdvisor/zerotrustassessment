<#
.SYNOPSIS
    Non-compliant Devices are Restricted from Accessing Corporate Data
#>

function Test-Assessment-24824 {
    [ZtTest(
    	Category = 'Dados',
    	ImplementationCost = 'Baixo',
        MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24824,
    	Title = 'Políticas de Acesso Condicional bloqueiam acesso de dispositivos não conformes',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    #region Coleta de Dados
    $activity = "Verificando se dispositivos não conformes estão bloqueados de acessar dados corporativos"
    Write-ZtProgress -Activity $activity

    # Consulta 1: Todos
    $allCompliantDeviceCAPUri = "identity/conditionalAccess/policies?`$filter=state eq 'enabled' and grantControls/builtInControls/any(bc: bc eq 'compliantDevice')&`$select=id,displayName,grantControls,conditions"
    $allCompliantDeviceCAP = Invoke-ZtGraphRequest -RelativeUri $allCompliantDeviceCAPUri -ApiVersion beta

    #endregion Coleta de Dados

    #region Lógica de Avaliação
    $passed = ($allCompliantDeviceCAP.Where{$null -eq $_.conditions.platforms.includePlatforms}.Count -gt 0) -or ( # sem filtro de plataforma
        $allCompliantDeviceCAP.Where{$_.conditions.platforms.includePlatforms -contains 'android'}.Count -gt 0 -and # pelo menos um Android
        $allCompliantDeviceCAP.Where{$_.conditions.platforms.includePlatforms -contains 'iOS'}.Count -gt 0 -and # pelo menos um iOS
        $allCompliantDeviceCAP.Where{$_.conditions.platforms.includePlatforms -contains 'macOS'}.Count -gt 0 -and # pelo menos um macOS
        $allCompliantDeviceCAP.Where{$_.conditions.platforms.includePlatforms -contains 'windows'}.Count -gt 0 # pelo menos um Windows
    )

    if ($passed) {
        $testResultMarkdown = "Pelo menos uma política de Acesso Condicional habilitada com conformidade de dispositivo existe para cada plataforma (Windows, macOS, iOS, Android), ou existe uma política sem seção de plataforma (aplica-se a todas).`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "Nenhuma política de Acesso Condicional com conformidade de dispositivo existe para uma ou mais plataformas, e nenhuma política se aplica a todas as plataformas.`n`n%TestResult%"
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    # Construir as seções detalhadas do markdown

    # Definir variáveis para inserir na string de formato
    $reportTitle = "Políticas de Acesso Condicional com Conformidade de Dispositivo"
    $tableRows = ""

    # Gerar linhas de tabela markdown para cada política
    if ($allCompliantDeviceCAP.Count -gt 0) {
        # Criar uma here-string com placeholders de formatação {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Política | Plataformas |
| :---------- | :-------- |
{1}

'@

        foreach ($policy in $allCompliantDeviceCAP) {
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/Policies'
            $policyName = Get-SafeMarkdown -Text $policy.displayName
$platformFilter = 'Todas as Plataformas'
            if ($null -ne $policy.conditions.platforms.includePlatforms) {
                $platformFilter = ($policy.conditions.platforms.includePlatforms -join ', ')
            }

            $tableRows += @"
| [$policyName]($portalLink) | $platformFilter |
"@
        }

                  # Formatar o template substituindo os placeholders pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

        # Substituir o placeholder no markdown de resultado do teste pelos detalhes gerados
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId             = '24824'
        Title              = "Dispositivos não conformes estão restringidos de acessar dados corporativos"
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
