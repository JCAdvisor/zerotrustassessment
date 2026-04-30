<#
.SYNOPSIS
    Verifica se as recomendações de alta prioridade do Entra foram tratadas
#>

function Test-Assessment-22124 {
    [ZtTest(
    	Category = 'Monitoramento',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Monitorar e detectar ciberameaças',
    	TenantType = ('Workforce','External'),
    	TestId = 22124,
    	Title = 'Recomendações de alta prioridade do Microsoft Entra foram tratadas',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    $activity = "Verificando recomendações de diretório que são de alta prioridade e estão ativas ou adiadas"
    Write-ZtProgress -Activity $activity

    $recommendations = Invoke-ZtGraphRequest -RelativeUri "directory/recommendations" -ApiVersion beta
    $result = $recommendations | Where-Object { $_.priority -eq 'high' -and $_.status -in @('active', 'postponed') }

    $passed = $result.Count -eq 0

    if ($passed) {
        $testResultMarkdown = "As recomendações de alta prioridade do Entra foram tratadas.`n`n"
    }
    else {
        $testResultMarkdown = "Encontradas $($result.Count) recomendações de alta prioridade do Entra não tratadas.`n`n%TestResult%"
    }

    if ($result.Count -gt 0) {
        $mdInfo = "`n## Recomendações de alta prioridade do Entra não tratadas`n`n"
        $mdInfo += "| Nome de Exibição | Status | Insights |`n"
        $mdInfo += "| :--- | :--- | :--- |`n"
        foreach ($item in $result) {
            $mdInfo += "| $($item.displayName) | $($item.status) | $($item.Insights) |`n"
        }
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    Add-ZtTestResultDetail -TestId '22124' -Title 'Recomendações de alta prioridade do Entra foram tratadas' `
        -UserImpact Medium -Risk High -ImplementationCost Medium `
        -AppliesTo Identity -Tag Application `
        -Status $passed -Result $testResultMarkdown
}