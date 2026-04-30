function Test-Assessment-24794 {
    [ZtTest(
    	Category = 'Locatário',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24794,
    	Title = 'Políticas de Termos e Condições protegem o acesso a dados confidenciais',
    	UserImpact = 'Baixo'
    )]
    # ... (lógica)
    $activity = "Verificando se a Política de Termos e Condições do Intune está configurada e atribuída"
}