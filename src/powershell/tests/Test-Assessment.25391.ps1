function Test-Assessment-25391 {
    [ZtTest(
    	Category = 'Global Secure Access',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Entra_Premium_Private_Access'),
    	CompatibleLicense = ('Entra_Premium_Private_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 25391,
    	Title = 'Conectores de rede privada estão ativos e saudáveis para manter o acesso Zero Trust aos recursos internos',
    	UserImpact = 'Médio'
    )]
    # ...
    $activity = 'Verificando as versões dos Conectores de Rede Privada'
    Write-ZtProgress -Activity $activity -Status 'Obtendo conectores'
}