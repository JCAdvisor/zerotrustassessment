function Test-Assessment-25379 {
    [ZtTest(
    	Category = 'Global Secure Access',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('AAD_PREMIUM'),
    	CompatibleLicense = ('AAD_PREMIUM','AAD_PREMIUM_P2'),
    	Pillar = 'Rede',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce','External'),
    	TestId = 25379,
    	Title = 'Políticas de Acesso Condicional usam controles de rede em conformidade',
    	UserImpact = 'Médio'
    )]
    # ...
    $activity = 'Verificando controles de rede em conformidade no Acesso Condicional'
    # ...
}