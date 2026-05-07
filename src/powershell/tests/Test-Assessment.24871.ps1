<#
.SYNOPSIS
    A inscrição automática no Defender para dispositivos Android está aplicada para reduzir riscos de ameaças não gerenciadas
#>

function Test-Assessment-24871 {
    [ZtTest(
    	Category = 'Locatário',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce'),
    	TestId = 24871,
    	Title = 'A inscrição automática no Defender para Endpoint é aplicada para reduzir riscos de ameaças Android não gerenciadas',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Coleta de Dados
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    if ( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    $activity = "Verificando se a inscrição automática no Defender está habilitada para dispositivos Android"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    # Recuperar detalhes do Conector de Defesa contra Ameaças Móveis
    $mobileThreatDefenseUri = 'deviceManagement/mobileThreatDefenseConnectors'
    $mobileThreatDefenseConnectors = Invoke-ZtGraphRequest -RelativeUri $mobileThreatDefenseUri -ApiVersion 'beta'

    if ($mobileThreatDefenseConnectors -and $null -ne $mobileThreatDefenseConnectors) {
        $defender = $mobileThreatDefenseConnectors | Where-Object { $_.id -eq 'fc780465-2017-40d4-a0c5-307022471b92' }
    }
    else {
        $defender = $null
    }

    #endregion Data Collection

    #region Assessment Logic
    $passed = $false
    $testResultMarkdown = ""

    if ($null -ne $defender) {
        if ($defender.partnerState -eq 'enabled' -and
            $defender.androidEnabled -eq $true) {
            $passed = $true
            $testResultMarkdown = "O Conector de Defesa contra Ameaças Móveis está habilitado e a inscrição do Android está ativa.`n`n%TestResult%"
        }
        else {
            $passed = $false
            $testResultMarkdown = "O Conector de Defesa contra Ameaças Móveis está desabilitado ou a inscrição do Android não está habilitada.`n`n%TestResult%"
        }
    }
    else {
        $passed = $false
        $testResultMarkdown = "Nenhum Conector do Microsoft Defender for Endpoint foi encontrado no locatário.`n`n%TestResult%"
    }

    #endregion Assessment Logic

    #region Geração de Relatório
    # Construir as seções detalhadas do markdown

    # Definir variáveis para inserir na string de formato
    $reportTitle = "Inscrição no Microsoft Defender for Endpoint para dispositivos Android"
    $tableRows = ""

    if ($null -ne $defender) {
        # Criar uma here-string com placeholders de formatação {0}, {1}, etc.
        $formatTemplate = @'

## [{0}]({1})

| Status | Android Enrollment |
| :----- | :----------------- |
{2}

'@

        $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_Workflows/SecurityManagementMenu/~/atp'

        $status = Get-SafeMarkdown -Text (Get-Culture).TextInfo.ToTitleCase($defender.partnerState.ToLower())
        $enrollment = Get-SafeMarkdown -Text $defender.androidEnabled

        $tableRows += @"
| $status | $enrollment |`n
"@

        # Formatar o template substituindo os placeholders pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $tableRows
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24871'
        Title  = 'A inscrição automática no Defender está habilitada para dispositivos Android'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
