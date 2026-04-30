function Test-Assessment-25378 {
    [ZtTest(
        Category = 'Identidades Externas',
        ImplementationCost = 'Médio',
        MinimumLicense = 'AAD_PREMIUM',
        CompatibleLicense = ('AAD_PREMIUM','AAD_PREMIUM_P2'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger identidades e segredos',
        TenantType = ('Workforce'),
        TestId = 25378,
        Title = 'A colaboração externa é governada por Políticas de Acesso Entre Locatários explícitas',
        UserImpact = 'Alto'
    )]
    # ...
}