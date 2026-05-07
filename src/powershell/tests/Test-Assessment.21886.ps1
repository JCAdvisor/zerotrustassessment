<#
.SYNOPSIS
    Verifica se os aplicativos que usam Microsoft Entra para autenticação e suportam provisionamento estão devidamente configurados.
#>

function Test-Assessment-21886 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21886,
    	Title = 'Aplicativos configurados para provisionamento automático de usuários',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando aplicativos que usam Microsoft Entra para autenticação e suportam provisionamento"
    Write-ZtProgress -Activity $activity -Status "Obtendo todos os service principals que têm SSO configurado"

    $sql = @"
SELECT
    id,
    appId,
    displayName,
    preferredSingleSignOnMode,
    accountEnabled
FROM ServicePrincipal
WHERE preferredSingleSignOnMode IS NOT NULL AND preferredSingleSignOnMode IN ('password', 'saml', 'oidc')
    AND accountEnabled = true
ORDER BY LOWER(displayName) ASC
"@

    $matchedServicePrincipals = Invoke-DatabaseQuery -Database $Database -Sql $sql

    $apps = @()
    foreach ($servicePrincipal in $matchedServicePrincipals) {
        $app = [PSCustomObject]@{
            Id                    = $servicePrincipal.id
            AppId                 = $servicePrincipal.appId
            DisplayName           = Get-SafeMarkdown $servicePrincipal.displayName
            PreferredSingleSignOn = $servicePrincipal.preferredSingleSignOnMode
            AccountEnabled        = $servicePrincipal.accountEnabled
            Templates             = Invoke-ZtGraphRequest -RelativeUri "servicePrincipals/$($servicePrincipal.id)/synchronization/templates" -ApiVersion 'v1.0'
            Jobs                  = Invoke-ZtGraphRequest -RelativeUri "servicePrincipals/$($servicePrincipal.id)/synchronization/jobs" -ApiVersion 'v1.0'
        }
        $apps += $app
    }

    $unconfiguredApps = @()
    $configuredApps = @()
    foreach ($app in $apps) {
        if (($app.Templates | Measure-Object).Count -gt 0 -and ($app.Jobs.value | Measure-Object).Count -eq 0) {
            $unconfiguredApps += $app
        }
    else {
        $configuredApps += $app
    }
}

    if ($unconfiguredApps.Count -eq 0) {
        $passed = $true
        $testResultMarkdown = "Aplicações configuradas para uso de SSO e suporte ao provisionamento estão também configuradas para provisionamento automático."
    }
    else {
        $passed = $false
        $testResultMarkdown = "Aplicações que estão configuradas para SSO e suportam provisionamento NÃO estão configuradas para provisionamento.`n`n%TestResult%"
    }

    # Build the detailed sections of the markdown

    # Define variables to insert into the format string
    $reportTitle = "Aplicações que não estão configuradas para provisionamento"
    $tableRows = ""

    if ($unconfiguredApps.Count -gt 0) {
        # Create a here-string with format placeholders {0}, {1}, etc.
        $formatTemplate = @'

## {0}


| Nome da Aplicação | ID do Objeto | ID da Aplicação |
| :--------------- | :-------- | :------------- |
{1}

'@

        foreach ($app in $unconfiguredApps) {
            $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/{0}/appId/{1}/preferredSingleSignOnMode/{2}/servicePrincipalType/Application/fromNav/" -f $app.Id, $app.AppId, $app.PreferredSingleSignOn
            $tableRows += @"
| [$($app.displayName)]($portalLink) | $($app.Id) | $($app.AppId) |`n
"@
        }

        # Format the template by replacing placeholders with values
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows

        # Replace the placeholder with the detailed information
        $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    }

    $params = @{
        TestId             = '21886'
        Title              = 'Aplicações que usam o Microsoft Entra para autenticação e suportam provisionamento estão configuradas'
        UserImpact         = 'Low'
        Risk               = 'Medium'
        ImplementationCost = 'Médio'
        AppliesTo          = 'Identity'
        Tag                = 'Identity'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
