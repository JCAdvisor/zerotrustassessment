function Test-Assessment-25383 {
    [ZtTest(
    	Category = 'Global Secure Access',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('AAD_PREMIUM'),
    	CompatibleLicense = ('AAD_PREMIUM','AAD_PREMIUM_P2'),
    	Pillar = 'Rede',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 25383,
    	Title = 'Privilégios de administrador Global e GSA são estritamente limitados para evitar comprometimento do tenant',
    	UserImpact = 'Baixo'
    )]
    # ...
    $activity = 'Verificando atribuições de função de Administrador Global e GSA'
}
