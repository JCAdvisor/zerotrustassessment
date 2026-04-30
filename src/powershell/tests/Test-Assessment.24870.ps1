function Test-Assessment-24870 {
    [ZtTest(
    	Category = 'Dados',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger inquilinos e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24870,
    	Title = 'Perfis de Wi-Fi seguros protegem dispositivos macOS contra acesso não autorizado à rede',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    # ...
    $activity = "A verificar se a rede Wi-Fi Corporativa em dispositivos macOS é gerida de forma segura"
    Write-ZtProgress -Activity $activity
}