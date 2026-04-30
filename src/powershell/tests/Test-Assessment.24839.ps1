function Test-Assessment-24839 {
    [ZtTest(
    	Category = 'Dados',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 24839,
    	Title = 'Perfis de Wi-Fi seguros protegem dispositivos iOS contra acesso não autorizado à rede',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    # ...
    $activity = "A verificar se a rede Wi-Fi Corporativa em dispositivos iOS é gerida de forma segura"
    Write-ZtProgress -Activity $activity
}