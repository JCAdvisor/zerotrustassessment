function Test-Assessment-25384 {
    [ZtTest(
    	Category = 'Gerenciamento de funções',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	CompatibleLicense = ('Entra_Premium_Private_Access','Entra_Premium_Internet_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 25384,
    	Title = 'Direitos de administrador de aplicativos são restritos a aplicativos de Acesso Privado específicos',
    	UserImpact = 'Baixo'
    )]
    # ...
    $activity = 'Verificando atribuições de função de Administrador de Aplicativos'
}