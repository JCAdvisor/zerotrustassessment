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

    $passed = $false
    $testResultMarkdown = ""

    if ($globalAdmins.Count -gt 8) {
        $passed = $false
    }
    else {
        $passed = $true
    }

    if ($passed) {
        $testResultMarkdown = "O número máximo de Administradores Globais não excede oito usuários.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "O número de Administradores Globais excede o limite recomendado de oito.`n`n%TestResult%"
    }

 $reportTitle = "Global Administrators"
    $tableRows = ""

    if ($globalAdmins.Count -gt 0) {
        # Create a here-string with format placeholders {0}, {1}, etc.
        $formatTemplate = @'

## {0}

### Número Total de Administradores Globais: {1}

| Nome de Exibição | Tipo de Objeto | Nome Principal do Usuário |
| :--------------- | :------------ | :------------------------ |
{2}

'@

        foreach ($globalAdmin in $globalAdmins) {
            $displayName = $globalAdmin.DisplayName

            $objectType = switch ($globalAdmin.'@odata.type') {
                '#microsoft.graph.user' { 'User' }
                '#microsoft.graph.servicePrincipal' { 'Service Principal' }
                default { 'Unknown' }
            }

            $userPrincipalName = if ($globalAdmin.UserPrincipalName) { $globalAdmin.UserPrincipalName } else { 'N/A' }

            # Create portal link based on object type
            $portalLink = switch ($objectType) {
                'User' { "https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/AdministrativeRole/userId/$($globalAdmin.Id)" }
                'Service Principal' { "https://entra.microsoft.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Overview/appId/$($globalAdmin.AppId)" }
                default { "https://entra.microsoft.com" }
            }

            $tableRows += @"
| [$(Get-SafeMarkdown($displayName))]($portalLink) | $objectType | $userPrincipalName |`n
"@
        }

        # Format the template by replacing placeholders with values
        $mdInfo = $formatTemplate -f $reportTitle, $globalAdmins.Count, $tableRows
    }

    # Replace the placeholder with the detailed information
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId = '21812'
        Title  = "O número máximo de Administradores Globais não excede oito usuários"
        Status = $passed
        Result = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
