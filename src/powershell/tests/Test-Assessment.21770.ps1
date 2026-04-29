<#
.SYNOPSIS

#>

function Test-Assessment-21770 {
	[ZtTest(
		Category = 'Controle de acesso',
		ImplementationCost = 'Baixo',
		CompatibleLicense = ('AAD_PREMIUM'),
        Service = ('Graph'),
		Pillar = 'Identidade',
		RiskLevel = 'Médio',
		SfiPillar = 'Proteger sistemas de engenharia',
		TenantType = ('Workforce','External'),
		TestId = 21770,
		Title = 'Aplicativos inativos não possuem permissões da API Microsoft Graph altamente privilegiadas',
		UserImpact = 'Alto'
	)]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    # Obtém todos os aplicativos com permissões usando uma função comum
    $results = Get-ApplicationsWithPermissions -Database $Database

    # Filtra para mostrar apenas aplicativos de risco Alto e Não Classificado (exclui Médio e Baixo)
    $results = $results | Where-Object { $_.Risk -in @('High', 'Unranked') }

    $inactiveRiskyApps = @()
    $otherApps = @()

    foreach($item in $results) {
        if([string]::IsNullOrEmpty($item.lastSignInDateTime) -and $item.IsRisky) {
            $inactiveRiskyApps += $item
        }
        else {
            $otherApps += $item
        }
    }

    $passed = $inactiveRiskyApps.Count -eq 0

    if ($passed) {
        $testResultMarkdown += "Nenhum aplicativo inativo com altos privilégios foi encontrado`n`n%TestResult%"
    }
    else {
        $testResultMarkdown += "Aplicativo(s) inativo(s) com altos privilégios foram encontrados`n`n%TestResult%"
    }

    $mdInfo = "`n## Aplicativos com permissões privilegiadas do Graph`n`n"
    $mdInfo += "| | Nome | Risco | Permissão Delegada | Permissão de Aplicativo | Tenant proprietário | Último logon|`n"
    $mdInfo += "| :--- | :--- | :--- | :--- | :--- | :--- | :--- |`n"
    $mdInfo += Get-AppList -Apps $inactiveRiskyApps -Icon "❌"
    $mdInfo += Get-AppList -Apps $otherApps -Icon "✅"


    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId = '21770'
        Title = 'Aplicativos inativos não possuem permissões altamente privilegiadas'
        Status = $passed
        Result = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
