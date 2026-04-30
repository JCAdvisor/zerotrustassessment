function Test-Assessment-24840 {
    [ZtTest(
    	Category = 'Dados',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 24840,
    	Title = 'Perfis de Wi-Fi seguros protegem dispositivos Android contra acesso não autorizado à rede',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    # ...
    $activity = 'A verificar se a rede Wi-Fi Corporativa em dispositivos Android totalmente geridos é gerida de forma segura'
    Write-ZtProgress -Activity $activity
}