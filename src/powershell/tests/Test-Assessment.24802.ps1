function Test-Assessment-24802 {
    [ZtTest(
    	Category = 'Locatário',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Baixo',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24802,
    	Title = 'Regras de limpeza de dispositivos mantêm a higiene do locatário ocultando dispositivos inativos',
    	UserImpact = 'Baixo'
    )]
    # ...
    $activity = "Verificando se a Regra de Limpeza de Dispositivo foi Criada"
}