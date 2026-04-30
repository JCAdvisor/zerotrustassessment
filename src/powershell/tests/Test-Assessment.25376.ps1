function Test-Assessment-25376 {
    [ZtTest(
        Category = 'Segurança de rede',
        ImplementationCost = 'Médio',
        MinimumLicense = 'Entra_Suite',
        CompatibleLicense = ('Entra_Premium_Private_Access','Entra_Premium_Internet_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 25376,
        Title = 'O tráfego do Microsoft 365 está fluindo ativamente pelo Global Secure Access',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Coleta de Dados
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando o tráfego do Microsoft 365 pelo Global Secure Access'
    Write-ZtProgress -Activity $activity -Status 'Verificando o perfil de encaminhamento de tráfego do M365'

    # ... (lógica mantida)
    #endregion

    #region Geração de Relatório
    if ($passed) {
        $testResultMarkdown = "O tráfego do Microsoft 365 está sendo roteado com sucesso pelo Global Secure Access.`n`n"
    } else {
        $testResultMarkdown = "⚠️ Foi detectado tráfego do Microsoft 365 ignorando o Global Secure Access.`n`n"
    }
    # ...
}