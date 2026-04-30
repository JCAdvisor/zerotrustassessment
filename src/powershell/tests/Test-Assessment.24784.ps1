<#
.SYNOPSIS
    Uma política do Microsoft Defender Antivírus é criada e atribuída no Intune para macOS
#>

function Test-Assessment-24784 {
    [ZtTest(
        Category = 'Dispositivo',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Intune'),
        Pillar = 'Dispositivos',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 24784,
        Title = 'Políticas do Defender Antivírus protegem dispositivos macOS contra malware',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param($Database)

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    # ... (lógica mantida)
    $activity = "Verificando se uma política do Microsoft Defender Antivírus foi criada e atribuída no Intune para macOS"
    Write-ZtProgress -Activity $activity -Status "Obtendo políticas"
}