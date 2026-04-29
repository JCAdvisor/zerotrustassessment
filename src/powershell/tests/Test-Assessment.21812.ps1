<#
.SYNOPSIS
#>

function Test-Assessment-21812 {
    [ZtTest(
    	Category = 'Acesso privilegiado',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Baixo',
    	SfiPillar = 'Protect engineering systems',
    	TenantType = ('Workforce'),
    	TestId = 21812,
    	Title = 'O número máximo de Administradores Globais não excede oito usuários',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se o número máximo de Administradores Globais não excede oito usuários"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $allGlobalAdmins = Get-ZtRoleMember -Role GlobalAdministrator
    $globalAdmins = @($allGlobalAdmins | Where-Object { $_.'@odata.type' -in @('#microsoft.graph.user', '#microsoft.graph.servicePrincipal') })

    $passed = $globalAdmins.Count -le 8
    $testResultMarkdown = ""

    if ($passed) {
        $testResultMarkdown = "O número máximo de Administradores Globais não excede oito usuários.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "O número de Administradores Globais excede o limite recomendado de oito.`n`n%TestResult%"
    }

    $mdInfo = "## Administradores Globais ($($globalAdmins.Count))`n`n| Nome | Tipo | UPN |`n| :--- | :--- | :--- |`n"
    foreach ($admin in $globalAdmins) {
        $type = if ($admin.'@odata.type' -eq '#microsoft.graph.user') { 'Usuário' } else { 'Principal de Serviço' }
        $upn = if ($admin.userPrincipalName) { $admin.userPrincipalName } else { 'N/A' }
        $mdInfo += "| $($admin.displayName) | $type | $upn |`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId = '21812'
        Title  = "O número máximo de Administradores Globais não excede oito usuários"
        Status = $passed
        Result = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
