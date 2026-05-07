<#
.SYNOPSIS
    Checks that Global Secure Access source IP restoration (Conditional Access signaling) is enabled.
.DESCRIPTION
    Ensures that user source IP addresses are preserved for Conditional Access and risk detection by verifying that Global Secure Access signaling is enabled in Microsoft Entra.
#>

function Test-Assessment-25370 {
    [ZtTest(
    	Category = 'Rede',
    	ImplementationCost = 'Baixo',
    	CompatibleLicense = ('Entra_Premium_Private_Access','Entra_Premium_Internet_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce','External'),
    	TestId = 25370,
    	Title = 'A restauração do IP de origem está habilitada',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando a restauração de IP de origem do Global Secure Access (sinalização do Conditional Access)'
    Write-ZtProgress -Activity $activity -Status 'Consultando status de sinalização do Global Secure Access'

        # Consulta Q1: Get Global Secure Access Conditional Access signaling settings
    $settings = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/settings/conditionalAccess' -ApiVersion beta

    # Initialize test variables
    $testResultMarkdown = ''
    $passed = $false
    #endregion Data Collection

    #region Assessment Logic
    if ($null -eq $settings) {
        $testResultMarkdown = 'Não foi possível recuperar as configurações de sinalização de Conditional Access do Global Secure Access.'
        $passed = $false
    }
    elseif ($settings.signalingStatus -eq 'enabled') {
        $testResultMarkdown = '✅ A sinalização do Global Secure Access está habilitada.'
        $passed = $true
    }
    else {
        $testResultMarkdown = '❌ A sinalização do Global Secure Access está desabilitada.'
        $passed = $false
    }
    #endregion Assessment Logic


    $params = @{
        TestId = '25370'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
