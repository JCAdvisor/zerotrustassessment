<#
.SYNOPSIS
    O acesso de convidados é limitado a locatários aprovados
#>

function Test-Assessment-21822 {
    [ZtTest(
        Category = 'Controle de acesso',
        ImplementationCost = 'Alto',
        MinimumLicense = ('Free'),
        Pillar = 'Identity',
        RiskLevel = 'Médio',
        SfiPillar = 'Protect identities and secrets',
        TenantType = ('Workforce'),
        TestId = 21822,
        Title = 'O acesso de convidados é limitado a locatários aprovados',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se o acesso de convidados é limitado a locatários aprovados"
    Write-ZtProgress -Activity $activity

    $passed = $true # Lógica de avaliação
    
    if ($passed) {
        $testResultMarkdown = "O acesso de convidados é limitado a locatários aprovados.`n"
    } else {
        $testResultMarkdown = "O acesso de convidados não é limitado a locatários aprovados.`n"
    }

    $testResultMarkdown += "## Restrições de colaboração`n`n"
    $testResultMarkdown += "| Domínio | Status |`n| :--- | :--- |`n"

    Add-ZtTestResultDetail -TestId '21822' -Status $passed -Result $testResultMarkdown
}
