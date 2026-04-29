<#
.SYNOPSIS

#>

function Test-Assessment-21866 {
    [ZtTest(
    	Category = 'Monitoramento',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Monitorar e detectar ciberameaças',
    	TenantType = ('Workforce','External'),
    	TestId = 21866,
    	Title = 'Todas as recomendações do Microsoft Entra foram atendidas',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se todas as recomendações do Microsoft Entra foram atendidas"
    Write-ZtProgress -Activity $activity

    $recommendations = Invoke-ZtGraphRequest -RelativeUri "directory/recommendations" -ApiVersion beta
    $result = $recommendations | Where-Object { $_.status -in @('active', 'postponed') }

    $passed = $result.Count -eq 0
    if ($passed) {
        $testResultMarkdown = "Todas as recomendações do Entra foram atendidas.`n`n"
    }
    else {
        $testResultMarkdown = "Encontradas $($result.Count) recomendações do Entra não atendidas.`n`n%TestResult%"
    }

    $mdInfo = ""
    if ($result.Count -gt 0) {
        $mdInfo = "`n## Recomendações do Entra não atendidas`n`n"
        $mdInfo += "| Nome de exibição | Status | Insights | Prioridade |`n"
        $mdInfo += "| :--- | :--- | :--- | :--- |`n"
        foreach ($item in $result) {
            $mdInfo += "| $($item.displayName) | $($item.status) | $($item.Insights) | $($item.priority) |`n"
        }
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    Add-ZtTestResultDetail -TestId '21866' -Title "Todas as recomendações do Entra foram atendidas" `
        -UserImpact Baixo -Risk Médio -ImplementationCost Médio `
        -AppliesTo Identidade -Tag Identidade `
        -Status $passed -Result $testResultMarkdown
}
