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
    	Title = 'Restauração do IP de origem está habilitada',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Coleta de Dados
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando a restauração do IP de origem do Global Secure Access (sinalização de Acesso Condicional)'
    Write-ZtProgress -Activity $activity -Status 'Consultando status de sinalização do Global Secure Access'

    $settings = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/settings/conditionalAccess' -ApiVersion beta
    # ...
    if ($null -eq $settings) {
        $testResultMarkdown = 'Não foi possível recuperar as configurações de sinalização de Acesso Condicional do Global Secure Access.'
    }
    elseif ($settings.signalingStatus -eq 'enabled') {
        $testResultMarkdown = '✅ A sinalização do Global Secure Access está habilitada.'
    }
    else {
        $testResultMarkdown = '❌ A sinalização do Global Secure Access está desabilitada.'
    }
    #endregion
}