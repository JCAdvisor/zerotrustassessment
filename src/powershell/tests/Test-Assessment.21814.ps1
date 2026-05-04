<#
.SYNOPSIS
    Verifica se os administradores não são sincronizados a partir do ambiente local (on-prem).
#>

function Test-Assessment-21814 {
    [ZtTest(
    	Category = 'Acesso privilegiado',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 21814,
    	Title = 'Contas privilegiadas são identidades nativas da nuvem',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $roles = Get-ZTRole -IncludePrivilegedRoles
    $privilegedRoles = $roles | Where-Object { $_.displayName -in @('Global Administrator', 'Global Reader') }


    foreach ($role in $privilegedRoles) {
        Write-ZtProgress -Activity $activity -Status "Buscando membros com a função: $($role.displayName)"
        $roleMembers = Get-ZtRoleMember -RoleId $role.id
        # TODO : For groups get transitive members
        $roleUsers = $roleMembers | Where-Object { $_.'@odata.type' -eq "#microsoft.graph.user" }

        $ztUsers = @()
        foreach ($user in $roleUsers) {
            $ztUsers += Invoke-ZtGraphRequest -RelativeUri "users" -UniqueId $user.id -Select id, displayName, onPremisesSyncEnabled
        }
        # Add a new property to the role object to store the users
        $role | Add-Member -MemberType NoteProperty -Name "ZtUsers" -Value $ztUsers
    }

    $passed = $privilegedRoles.ZtUsers.onPremisesSyncEnabled -notcontains $true

    if ($passed) {
        $testResultMarkdown += "Contas privilegiadas fixas ou elegíveis são apenas contas da nuvem.`n`n%TestResult%"
    }
    else {
        $onpremUserCount = ($privilegedRoles.ZtUsers | Where-Object { $_.onPremisesSyncEnabled }).Count
        $testResultMarkdown += "Este tenant tem $onpremUserCount usuários privilegiados que são sincronizados do ambiente local.`n`n%TestResult%"
    }

    #TODO: Make user names clickable
    $mdInfo = "## Funções Privilegiadas`n`n"
    $mdInfo += "| Nome da Função | Nome do Usuário | Fonte | Status |`n"
    $mdInfo += "| :--- | :--- | :--- | :---: |`n"
    foreach ($role in $privilegedRoles | Sort-Object displayName) {
        foreach ($user in $role.ZtUsers) {
            if ($user.onPremisesSyncEnabled) {
                $type = "Sincronizada do ambiente local"
                $status = "❌"
            }
            else {
                $type = "Identidade nativa da nuvem"
                $status = "✅"
            }

            $userLink = "https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/AdministrativeRole/userId/{0}" -f $user.id
            $mdInfo += "| $($role.displayName) | [$($user.displayName)]($userLink) | $type | $status |`n"
        }
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    Add-ZtTestResultDetail -TestId '21814' -Title 'Contas privilegiadas são identidades nativas da nuvem' `
        -UserImpact Medium -Risk Medium -ImplementationCost Low `
        -AppliesTo Identity -Tag PrivilegedIdentity `
        -Status $passed -Result $testResultMarkdown
}
