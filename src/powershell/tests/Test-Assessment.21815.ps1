<#
.SYNOPSIS
#>

function Test-Assessment-21815 {
    [ZtTest(
    	Category = 'Acesso privilegiado',
    	ImplementationCost = 'Alto',
    	MinimumLicense = ('P2'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce'),
    	TestId = 21815,
    	Title = 'Todas as atribuições de funções privilegiadas são ativadas just-in-time e não permanentemente ativas',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP2) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP2
        return
    }

    $activity = "Verificando se todas as atribuições de funções privilegiadas são ativadas just-in-time e não permanentemente ativas"
    Write-ZtProgress -Activity $activity -Status "Obtendo atribuições de funções privilegiadas"

    $sql = @"
select distinct principalDisplayName, userPrincipalName, roleDisplayName, privilegeType, isPrivileged
from vwRole
"@
    $roleAssignments = Invoke-DatabaseQuery -Database $Database -Sql $sql

    $results = $roleAssignments | Where-Object { $_.isPrivileged -eq $true -and $_.privilegeType -eq 'Permanent' }

    $testResultMarkdown = ""
    $passed = $results.Count -eq 0

    if ($passed) {
        $testResultMarkdown = "Todas as atribuições de funções privilegiadas são ativadas just-in-time e não são permanentemente ativas.`n`n%TestResult%"
    } else {
        $testResultMarkdown = "Existem $($results.Count) atribuições de funções privilegiadas permanentes.`n`n%TestResult%"
    }

    $mdInfo = "## Usuários privilegiados com atribuições permanentes`n`n| Usuário | UPN | Função | Tipo de Atribuição |`n| :--- | :--- | :--- | :--- |`n"
    foreach ($res in $results) {
        $mdInfo += "| $($res.principalDisplayName) | $($res.userPrincipalName) | $($res.roleDisplayName) | $($res.privilegeType) |`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21815'
        Title              = "Todas as atribuições de funções privilegiadas são ativadas just-in-time e não permanentemente ativas"
        UserImpact         = 'Baixo'
        Risk               = 'Alto'
        ImplementationCost = 'Alto'
        AppliesTo          = 'Identity'
        Tag                = 'Identity'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
