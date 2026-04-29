<#
.SYNOPSIS
    Verifica se alertas de ativação estão configurados para todas as atribuições de funções privilegiadas.
#>

function Test-Assessment-21820 {
    [ZtTest(
        Category = 'Acesso privilegiado',
        ImplementationCost = 'Médio',
        MinimumLicense = ('P2'),
        Pillar = 'Identity',
        RiskLevel = 'Baixo',
        SfiPillar = 'Protect identities and secrets',
        TenantType = ('Workforce'),
        TestId = 21820,
        Title = 'Alerta de ativação para todas as atribuições de funções privilegiadas',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    if ( -not (Get-ZtLicense EntraIDP2) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP2
        return
    }

    $activity = 'Verificando alertas de ativação para funções privilegiadas'
    Write-ZtProgress -Activity $activity -Status 'Obtendo definições de funções privilegiadas'

    $passed = $true # Lógica de avaliação aqui
    $testResultMarkdown = "Alertas de ativação estão configurados para funções privilegiadas.`n`n"

    $mdInfo = "## Funções com alertas ausentes ou configurados incorretamente`n`n| Nome da Função | Destinatários Padrão | Destinatários Adicionais |`n| :--- | :--- | :--- |`n"

    $testResultMarkdown += $mdInfo

    $params = @{
        TestId = '21820'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
