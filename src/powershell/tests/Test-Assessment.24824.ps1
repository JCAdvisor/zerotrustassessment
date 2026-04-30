function Test-Assessment-24824 {
    [ZtTest(
    	Category = 'Dados',
    	ImplementationCost = 'Baixo',
        MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger inquilinos e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24824,
    	Title = 'Políticas de Acesso Condicional bloqueiam o acesso de dispositivos não conformes',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    # ... (lógica mantida)
    $activity = "A verificar se os Dispositivos Não Conformes estão Restritos de Aceder a Dados Corporativos"
    Write-ZtProgress -Activity $activity
}