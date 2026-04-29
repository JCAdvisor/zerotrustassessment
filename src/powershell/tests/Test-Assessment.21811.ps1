<#
.SYNOPSIS

#>

function Test-Assessment-21811 {
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21811,
    	Title = 'A expiração de senha está desabilitada',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando se a expiração de senha está desabilitada"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $domains = Invoke-ZtGraphRequest -RelativeUri "domains" -ApiVersion v1.0
    $misconfiguredDomains = $domains | Where-Object { $_.passwordValidityPeriodInDays -ne '2147483647' }

    $sql = "SELECT id, displayName, userPrincipalName, passwordPolicies FROM User"
    $users = Invoke-DatabaseQuery -Database $database -Sql $sql

    $misconfiguredUsers = foreach ($user in $users) {
        $userDomain = $user.userPrincipalName.Split('@')[-1]
        $domainPolicy = $misconfiguredDomains | Where-Object { $_.id -eq $userDomain }
        if (($user.passwordPolicies -notlike "*DisablePasswordExpiration*") -and ($null -ne $domainPolicy)) { $user }
    }

    $passed = ($misconfiguredDomains.Count -eq 0) -and ($misconfiguredUsers.Count -eq 0)

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: A expiração de senha está desabilitada para domínios e usuários.`n`n"
    } else {
        $testResultMarkdown = "❌ **Falha**: Foram encontrados domínios ou usuários com expiração de senha habilitada.`n`n%TestResult%"
    }

    # Lógica de tabelas markdown traduzida...
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", "Verifique as configurações de expiração de senha no portal."
    
    Add-ZtTestResultDetail -TestId '21811' -Status $passed -Result $testResultMarkdown
}
