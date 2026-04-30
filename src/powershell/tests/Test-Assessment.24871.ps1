function Test-Assessment-24871 {
    [ZtTest(
    	Category = 'Locatário',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24871,
    	Title = 'A inscrição automática no Defender for Endpoint é imposta para reduzir riscos de ameaças Android não gerenciadas'
    )]
    # ...
    $activity = "Verificando se a inscrição automática no Defender está habilitada para dispositivos Android"
    Write-ZtProgress -Activity $activity
}