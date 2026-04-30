function Test-Assessment-25381 {
    [ZtTest(
    	Category = 'Global Secure Access',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Entra_Suite','Entra_Premium_Private_Access','Entra_Premium_Internet_Access','P2'),
    	CompatibleLicense = ('Entra_Premium_Private_Access','Entra_Premium_Internet_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 25381,
    	Title = 'O tráfego de rede é roteado pelo Global Secure Access para imposição de política de segurança',
    	UserImpact = 'Baixo'
    )]
    # ...
    $activity = 'Verificando a configuração dos perfis de encaminhamento de tráfego'
    Write-ZtProgress -Activity $activity -Status 'Obtendo perfis de encaminhamento de tráfego'
}