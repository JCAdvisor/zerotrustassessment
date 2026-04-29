<#
.SYNOPSIS

#>

function Test-Assessment-21863{
    [ZtTest(
    	Category = 'Monitoramento',
    	ImplementationCost = 'Alto',
    	MinimumLicense = ('P2'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Monitorar e detectar ciberameaças',
    	TenantType = ('Workforce','External'),
    	TestId = 21863,
    	Title = 'Todos os logins de alto risco passaram por triagem',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Todos os logins de alto risco passaram por triagem"
    Write-ZtProgress -Activity $activity -Status "Obtendo logins de risco."

    $EntraIDPlan = Get-ZtLicenseInformation -Product EntraID
    if ($EntraIDPlan -eq "Free" -or $EntraIDPlan -eq "P1") {
        Write-PSFMessage '🟦 Pulando teste: Requer plano P2 ou de Governança' -Tag Test -Level VeryVerbose
        return
    }

    $filter = "riskState eq 'atRisk' and riskLevel eq 'high'"

    $riskDetections = Invoke-ZtGraphRequest -RelativeUri 'identityProtection/riskDetections' -Filter $filter

    # Determine pass/fail - pass if no untriaged risky users found
    $result = ($riskDetections.value.Count -eq 0)
    $passed = $result

    # Prepare the markdown output
    if ($result) {
        $testResultMarkdown = "Não há logins de risco sem triagem no locatário.%TestResult%"
    }
    else {
        $testResultMarkdown = "Encontrados **$($riskDetections.Count)** logins de alto risco sem triagem.%TestResult%"
    }

    # Build the detailed sections of the markdown
    $mdInfo = ""

    if (!$result) {
        $mdInfo += "`n## Logins de alto risco sem triagem`n`n"
        $mdInfo += "| Data | Nome Principal do Usuário (UPN) | Tipo | Nível de Risco |`n"
        $mdInfo += "| :---- | :---- | :---- | :---- |`n"

        foreach ($risk in $riskDetections) {
            $userPrincipalName = $risk.userPrincipalName
            $riskLevel = Get-FormattedRiskLevel -RiskLevel $risk.riskLevel
            $riskEventType = $risk.riskEventType
            $riskDate = $risk.detectedDateTime # ID protection returns us format by default
            $mdInfo += "| $riskDate | $userPrincipalName |  $riskEventType | $riskLevel |`n"
        }
    }

    # Replace the placeholder with the detailed information
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    Add-ZtTestResultDetail -TestId '21863' -Title "Todos os logins de alto risco passaram por triagem" `
        -UserImpact Baixo -Risk Alto -ImplementationCost Alto `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown
}
