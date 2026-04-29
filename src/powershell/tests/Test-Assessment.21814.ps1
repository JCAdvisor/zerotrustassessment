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

    $onpremUsersFound = $false
    foreach ($role in $privilegedRoles) {
        $roleMembers = Get-ZtRoleMember -RoleId $role.id
        $syncedUsers = $roleMembers | Where-Object { $_.onPremisesSyncEnabled -eq $true }
        if ($syncedUsers) { $onpremUsersFound = $true }
    }

    $passed = -not $onpremUsersFound

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: Todas as contas privilegiadas são identidades nativas da nuvem.`n`n"
    } else {
        $testResultMarkdown = "❌ **Falha**: Foram encontradas contas privilegiadas sincronizadas a partir do ambiente local.`n`n"
    }

    Add-ZtTestResultDetail -TestId '21814' -Status $passed -Result $testResultMarkdown
}
