function Test-Assessment-25371 {
    [ZtTest(
    	Category = 'Global Secure Access',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('AAD_PREMIUM'),
    	CompatibleLicense = ('Entra_Premium_Private_Access','Entra_Premium_Internet_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 25371,
    	Title = 'O acesso à rede é validado em tempo real por meio da Avaliação de Acesso Contínuo Universal'
    )]
    # ...
    $activity = "Validando se a Avaliação de Acesso Contínuo Universal (Universal CAE) está habilitada para acesso à rede"
    Write-ZtProgress -Activity $activity
}