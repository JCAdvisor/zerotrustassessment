function Test-Assessment-25372 {
    [ZtTest(
        Category = 'Global Secure Access',
        ImplementationCost = 'Médio',
        MinimumLicense = ('AAD_PREMIUM', 'Entra_Premium_Internet_Access', 'Entra_Premium_Private_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 25372,
        Title = 'O cliente Global Secure Access está implantado em todos os endpoints gerenciados'
    )]
    # ...
    $activity = 'Verificando a implantação do cliente Global Secure Access'
    Write-ZtProgress -Activity $activity -Status 'Obtendo resumo de uso de dispositivos GSA'
}