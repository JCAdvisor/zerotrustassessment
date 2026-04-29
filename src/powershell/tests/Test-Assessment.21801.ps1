<#
.SYNOPSIS
    Obtém os métodos de autenticação registrados por todos os usuários.
#>

function Test-Assessment-21801 {
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21801,
    	Title = 'Usuários possuem métodos de autenticação fortes configurados',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    $activity = "Verificando autenticação resistente a phishing para usuários"
    Write-ZtProgress -Activity $activity -Status "Obtendo métodos de autenticação"

    $sql = @"
select distinct u.id, u.displayName, list_has_any(['passKeyDeviceBound', 'passKeyDeviceBoundAuthenticator', 'windowsHelloForBusiness'], methodsRegistered) as phishResistantAuthMethod,
    u.signInActivity.lastSuccessfulSignInDateTime
from UserRegistrationDetails u
"@
    $results = Invoke-DatabaseQuery -Database $Database -Sql $sql

    $phishResistantUsers = $results | Where-Object { $_.phishResistantAuthMethod }
    $phishableUsers = $results | Where-Object { !$_.phishResistantAuthMethod }

    $passed = $phishableUsers.Count -eq 0

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: Todos os usuários possuem métodos resistentes a phishing registrados.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ **Falha**: Foram encontrados usuários que ainda não registraram métodos fortes de autenticação.`n`n%TestResult%"
    }

    $mdInfo = "## Status de Autenticação dos Usuários`n`n"
    $mdInfo += "| Usuário | Último Logon | Resistente a Phishing |`n"
    $mdInfo += "| :--- | :--- | :---: |`n"

    $userLinkFormat = "https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/{0}/hidePreviewBanner~/true"

    foreach ($user in $phishableUsers | Sort-Object displayName) {
        $userLink = $userLinkFormat -f $user.id
        $lastSignInDate = Get-FormattedDate -Date $user.lastSuccessfulSignInDateTime
        $mdInfo += "|[$($user.displayName)]($userLink)| $lastSignInDate | ❌ |`n"
    }

    foreach ($user in $phishResistantUsers | Sort-Object displayName) {
        $userLink = $userLinkFormat -f $user.id
        $lastSignInDate = Get-FormattedDate -Date $user.lastSuccessfulSignInDateTime
        $mdInfo += "|[$($user.displayName)]($userLink)| $lastSignInDate | ✅ |`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    Add-ZtTestResultDetail -TestId '21801' -Status $passed -Result $testResultMarkdown
}
