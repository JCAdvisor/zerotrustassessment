function Test-Assessment-24827 {
    [ZtTest(
    	Category = 'Dados',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger inquilinos e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24827,
    	Title = 'Políticas de Acesso Condicional bloqueiam o acesso de aplicações não geridas',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    # ...
    $activity = "A verificar se aplicações não geridas e desprotegidas estão restritas de aceder a Dados Corporativos"
    Write-ZtProgress -Activity $activity
}