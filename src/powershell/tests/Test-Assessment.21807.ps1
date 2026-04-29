<#
.SYNOPSIS
    Verifica se o usuário comum não consegue registrar aplicativos.
#>

function Test-Assessment-21807 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger sistemas de engenharia',
    	TenantType = ('Workforce'),
    	TestId = 21807,
    	Title = 'Criação de novos aplicativos e entidades de serviço é restrita a usuários privilegiados',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando política de registro de aplicativos por usuários"
    Write-ZtProgress -Activity $activity

    $result = Invoke-ZtGraphRequest -RelativeUri "policies/authorizationPolicy" -ApiVersion v1.0

    $passed = $result.defaultUserRolePermissions.allowedToCreateApps -eq $false

    if ($passed) {
        $testResultMarkdown = "O locatário está configurado para impedir que usuários comuns registrem aplicativos.`n`n**[Usuários podem registrar aplicativos](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserManagementMenuBlade/~/UserSettings/menuId/UserSettings)** → **Não** ✅"
    }
    else {
        $testResultMarkdown = "O locatário permite que todos os usuários não privilegiados registrem aplicativos.`n`n**[Usuários podem registrar aplicativos](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserManagementMenuBlade/~/UserSettings/menuId/UserSettings)** → **Sim** ❌"
    }

    Add-ZtTestResultDetail -TestId '21807' -Title 'A criação de novos aplicativos e entidades de serviço é restrita a usuários privilegiados' `
        -UserImpact Medium -Risk Medium -ImplementationCost Low `
        -AppliesTo Identity -Tag Application `
        -Status $passed -Result $testResultMarkdown
}
