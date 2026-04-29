<#
.SYNOPSIS
    Teste para verificar se o bloqueio de propriedade de instância de aplicativo está configurado para todos os aplicativos multilocatários.
#>

function Test-Assessment-21777 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce','External'),
    	TestId = 21777,
    	Title = 'O bloqueio de propriedade de instância de aplicativo está configurado para todos os aplicativos multilocatários',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando se o bloqueio de propriedade de instância de aplicativo está configurado para todos os aplicativos multilocatários"
    Write-ZtProgress -Activity $activity -Status "Obtendo aplicativos"

    $sqlCount = "SELECT COUNT(*) ItemCount FROM Application WHERE ID IS NOT NULL"
    $resultCount = Invoke-DatabaseQuery -Database $Database -Sql $sqlCount
    $hasData = $resultCount.ItemCount -gt 0

    if($hasData){
        $sqlApp = @"
        SELECT
            appId,
            displayName,
            signInAudience,
            servicePrincipalLockConfiguration,
            CASE
                WHEN servicePrincipalLockConfiguration IS NULL THEN false
                WHEN servicePrincipalLockConfiguration->>'isEnabled' = 'false' THEN false
                ELSE true
            END as isLockConfigured
        FROM Application
        WHERE signInAudience IN ('AzureADMultipleOrgs', 'AzureADandPersonalMicrosoftAccount')
"@
        $resultsApp = Invoke-DatabaseQuery -Database $Database -Sql $sqlApp
    }

    $failedApps = $resultsApp | Where-Object { $_.isLockConfigured -eq $false }
    $passed = $null -eq $failedApps -or $failedApps.Count -eq 0

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: Todos os aplicativos multilocatários possuem o bloqueio de instância configurado.`n`n"
    }
    else {
        $testResultMarkdown = "❌ **Falha**: Foram encontrados aplicativos multilocatários sem o bloqueio de propriedade de instância configurado.`n`n"
    }

    $reportTitle = "Aplicativos multilocatários e configuração de Bloqueio de Instância"
    $tableRows = ""

    if ($resultsApp.Count -gt 0) {
        $formatTemplate = @'

## {0}

| Aplicativo | ID do Aplicativo | Bloqueio de Instância Configurado |
| :---------- | :------------- | :------------------------------------ |
{1}

'@

        foreach ($app in $resultsApp) {
            $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Authentication/appId/{0}/isMSAApp~/false' -f $app.appId
            $tableRows += "| [$(Get-SafeMarkdown($app.displayName))]($portalLink) | $($app.appId) | $($app.isLockConfigured) |`n"
        }

        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21777'
        Title              = "O bloqueio de propriedade de instância de aplicativo está configurado para todos os aplicativos multilocatários"
        UserImpact         = 'Baixo'
        Risk               = 'Alto'
        ImplementationCost = 'Baixo'
        AppliesTo          = 'Identidade'
        Tag                = 'Identidade'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
