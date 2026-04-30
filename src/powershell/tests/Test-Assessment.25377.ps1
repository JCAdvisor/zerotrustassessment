function Test-Assessment-25377 {
    [ZtTest(
    	Category = 'Global Secure Access',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('AAD_PREMIUM','Entra_Premium_Internet_Access'),
    	CompatibleLicense = ('Entra_Premium_Internet_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce','External'),
    	TestId = 25377,
    	Title = 'Restrições universais de locatário bloqueiam o acesso não autorizado a locatários externos',
    	UserImpact = 'Baixo'
    )]
    # ...
    $reportTitle = 'Configuração de Restrições Universais de Locatário'
    $tableRows = "| Status de Marcação de Pacotes de Rede | $networkPacketDisplay | enabled | $networkPacketIcon |`n"
    # ...
}