<#
.SYNOPSIS
    Verifica se há usuários de alto risco sem triagem no Identity Protection.
#>

function Test-Assessment-21861 {
    [ZtTest(
    	Category = 'Monitoramento',
    	ImplementationCost = 'Alto',
    	MinimumLicense = ('P2'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Monitorar e detectar ciberameaças',
    	TenantType = ('Workforce','External'),
    	TestId = 21861,
    	Title = 'Todos os usuários de alto risco passaram por triagem',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se todos os usuários de risco passaram por triagem"
    Write-ZtProgress -Activity $activity -Status "Obtendo usuários de risco"

    $EntraIDPlan = Get-ZtLicenseInformation -Product EntraID
    if ($EntraIDPlan -eq "Free" -or $EntraIDPlan -eq "P1") {
        Write-PSFMessage '🟦 Pulando teste: Requer plano P2 ou de Governança' -Tag Test -Level VeryVerbose
        return
    }

    # Query 1: Get untriaged risky users with high risk level
    $riskyUsersQuery = "identityProtection/riskyUsers"
    $riskyUsers = Invoke-ZtGraphRequest -RelativeUri $riskyUsersQuery -ApiVersion 'v1.0' -Filter "riskState eq 'atRisk' and riskLevel eq 'High'"

    # Determine pass/fail - pass if no untriaged risky users found
    $result = ($riskyUsers.Count -eq 0)
    $passed = $result

    # Prepare the markdown output
    if ($result) {
        $testResultMarkdown = "Todos os usuários de alto risco passaram devidamente pela triagem no Entra ID Protection.%TestResult%"
    }
    else {
        $testResultMarkdown = "Encontrados **$($riskyUsers.Count)** usuários de alto risco sem triagem no Entra ID Protection.%TestResult%"
    }

    # Build the detailed sections of the markdown
    $mdInfo = ""

    if (!$result) {
        $mdInfo += "`n## Usuários de alto risco sem triagem`n`n"
        $mdInfo += "| Usuário | Nível de risco | Última atualização | Detalhes do risco |`n"
        $mdInfo += "| :----------------- | :--------- | :-------------------- | :---------- |`n"

        foreach ($user in $riskyUsers) {
            $userPrincipalName = $user.userPrincipalName ?? $user.id
            $riskLevel = Get-FormattedRiskLevel -RiskLevel $user.riskLevel
            $riskDate = $user.riskLastUpdatedDateTime # ID protection returns us format by default
            $mdInfo += "| $userPrincipalName |  $riskLevel | $riskDate | $($user.riskDetail) |`n"
        }
    }

    # Replace the placeholder with the detailed information
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    Add-ZtTestResultDetail -TestId '21861' -Title "Todos os usuários de risco passaram por triagem" `
        -UserImpact Baixo -Risk Alto -ImplementationCost Alto `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown
}
