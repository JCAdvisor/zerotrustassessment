<#
.SYNOPSIS

#>

function Test-Assessment-21782 {
    [ZtTest(
    	Category = 'Acesso privilegiado',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 21782,
    	Title = 'Contas privilegiadas possuem métodos resistentes a phishing registrados',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando autenticação resistente a phishing para funções privilegiadas"
    Write-ZtProgress -Activity $activity -Status "Obtendo métodos de autenticação"

    $sql = @"
select distinct id, userDisplayName, roleDisplayName, methodsRegistered, list_has_any(['passKeyDeviceBound', 'passKeyDeviceBoundAuthenticator', 'windowsHelloForBusiness'], methodsRegistered) as phishResistantAuthMethod
from UserRegistrationDetails u
    inner join vwRole r on u.id = r.principalId
"@
    $results = Invoke-DatabaseQuery -Database $Database -Sql $sql

    $totalUserCount = $results.Length
    $phishResistantPrivUsers = $results | Where-Object { $_.phishResistantAuthMethod }
    $phishablePrivUsers = $results | Where-Object { !$_.phishResistantAuthMethod }

    $passed = $phishablePrivUsers.Count -eq 0

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: Todas as contas privilegiadas possuem métodos resistentes a phishing registrados.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ **Falha**: Foram encontrados usuários privilegiados que ainda não registraram métodos de autenticação resistentes a phishing.`n`n%TestResult%"
    }

    $mdInfo = "## Usuários Privilegiados`n`n"

    if ($passed) {
        $mdInfo += "Todos os usuários privilegiados registraram métodos de autenticação resistentes a phishing.`n`n"
    }
    else{
        $mdInfo += "Usuários privilegiados abaixo não registraram métodos resistentes a phishing.`n`n"
    }

    $mdInfo += "| Usuário | Nome da Função | Método resistente a phishing registrado |`n"
    $mdInfo += "| :--- | :--- | :---: |`n"

    $userLinkFormat = "https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/{0}/hidePreviewBanner~/true"

    foreach ($user in $phishablePrivUsers | Sort-Object userDisplayName) {
        $userLink = $userLinkFormat -f $user.id
        $mdInfo += "|[$($user.userDisplayName)]($userLink)| $($user.roleDisplayName) | ❌ |`n"
    }

    foreach ($user in $phishResistantPrivUsers | Sort-Object userDisplayName) {
        $userLink = $userLinkFormat -f $user.id
        $mdInfo += "|[$($user.userDisplayName)]($userLink)| $($user.roleDisplayName) | ✅ |`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    Add-ZtTestResultDetail -TestId '21782' -Title 'Contas privilegiadas possuem métodos resistentes a phishing registrados' `
        -UserImpact Low -Risk High -ImplementationCost Medium `
        -AppliesTo Identity -Tag Authentication `
        -Status $passed -Result $testResultMarkdown
}
