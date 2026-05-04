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

    $activity = "Verificando autenticação resistente a phishing para usuário"
    Write-ZtProgress -Activity $activity -Status "Obtendo métodos de autenticação"

    if( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    $EntraIDPlan = Get-ZtLicenseInformation -Product EntraID
    if ($EntraIDPlan -eq "Free") {
        Write-PSFMessage '🟦 Ignorando: Esse teste exige uma Licensa Premium' -Tag Test -Level VeryVerbose
        return
    }


    $sql = @"
select distinct u.id, u.displayName, list_has_any(['passKeyDeviceBound', 'passKeyDeviceBoundAuthenticator', 'windowsHelloForBusiness'], methodsRegistered) as phishResistantAuthMethod,
    u.signInActivity.lastSuccessfulSignInDateTime
from User u
    inner join UserRegistrationDetails ur on u.id = ur.id
where u.accountEnabled
"@
    $results = Invoke-DatabaseQuery -Database $Database -Sql $sql

    $totalUserCount = $results.Length
    $phishResistantUsers = $results | Where-Object { $_.phishResistantAuthMethod }
    $phishableUsers = $results | Where-Object { !$_.phishResistantAuthMethod }

    $phishResistantUserCount = $phishResistantPrivUsers.Length

    $passed = $totalUserCount -eq $phishResistantUserCount

    if ($passed) {
        $testResultMarkdown += "Todos os usuários têm métodos de autenticação resistente a phishing registrados.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown += "Encontrados usuários que não registraram métodos de autenticação resistente a phishing.`n`n%TestResult%"
    }

    $mdInfo = "## Métodos de autenticação resistente a phishing`n`n"

    if ($passed) {
        $mdInfo += "Todos os usuários têm métodos de autenticação resistente a phishing registrados.`n`n"
    }
    else{
        $mdInfo += "Encontrados usuários que não registraram métodos de autenticação resistente a phishing.`n`n"
    }


    $mdInfo += "Usuário | Último acesso | Método resistente a phishing registrado |`n"
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

    Add-ZtTestResultDetail -TestId '21801' -Title 'Usuários têm métodos de autenticação fortes configurados' `
        -UserImpact Medium -Risk Medium -ImplementationCost Medium `
        -AppliesTo Identity -Tag Credential `
        -Status $passed -Result $testResultMarkdown
}
