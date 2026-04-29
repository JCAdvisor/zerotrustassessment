<#
.SYNOPSIS

#>

function Test-Assessment-21780 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Alto',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21780,
    	Title = 'Nenhum uso de ADAL no locatário',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando se não há uso de ADAL no locatário"
    Write-ZtProgress -Activity $activity -Status "Obtendo recomendações"

    $adalRecommendations = Invoke-ZtGraphRequest -RelativeUri "directory/recommendations" -filter "recommendationType eq 'adalToMsalMigration'" -ApiVersion beta

    $mdInfo = ""

    if ($adalRecommendations.Count -gt 0) {
        $passed = $false
        $testResultMarkdown = "Aplicativos ADAL encontrados no locatário.%TestResult%"

        $mdInfo = "`n## Aplicativos ADAL Encontrados`n`n"
        $mdInfo += "| Aplicativo |`n"
        $mdInfo += "| :---- |`n"

        foreach ($recommendation in $adalRecommendations) {
            $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Branding/appId/{0}" -f $recommendation.subjectId
            $mdInfo += "| [$(Get-SafeMarkdown($recommendation.displayName))]($portalLink) |`n"
        }
    }
    else {
        $passed = $true
        $testResultMarkdown = "Nenhum aplicativo ADAL encontrado no locatário.%TestResult%"
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21780'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
