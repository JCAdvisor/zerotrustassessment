function Test-Assessment-25382 {
    [ZtTest(
        Category = 'Global Secure Access',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Entra_Premium_Private_Access', 'Entra_Premium_Internet_Access'),
        CompatibleLicense = ('Entra_Premium_Internet_Access','Entra_Premium_Private_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 25382,
        Title = 'Perfis de encaminhamento de tráfego estão com escopo definido para usuários e grupos apropriados para implementação controlada',
        UserImpact = 'Baixo'
    )]
    # ...
    $activity = 'Verificando a configuração dos perfis de encaminhamento de tráfego'
    Write-ZtProgress -Activity $activity -Status 'Obtendo perfis de encaminhamento de tráfego'
}