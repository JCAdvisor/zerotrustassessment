<#
.SYNOPSIS
    Verifica a proporção de atribuições de Administrador Global em relação ao total de atribuições de funções privilegiadas no locatário.
#>

function Test-Assessment-21813{
    [ZtTest(
    	Category = 'Acesso privilegiado',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 21813,
    	Title = 'Proporção alta de Administrador Global em relação aos usuários privilegiados',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param($Database)

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

 $sql = @"
SELECT principalId, principalDisplayName, userPrincipalName, roleDisplayName, roleDefinitionId, privilegeType, isPrivileged, "@odata.type"
FROM vwRole
WHERE isPrivileged = 1 AND "@odata.type" = '#microsoft.graph.user'
"@

    $roleAssignments = Invoke-DatabaseQuery -Database $Database -Sql $sql

    $gaRoleAssignments = $roleAssignments | Where-Object { $_.roleDefinitionId -eq '62e90394-69f5-4237-9190-012177145e10' }
    $gaCount = $gaRoleAssignments.Count
    $totalPrivilegedCount = ($roleAssignments | Select-Object -Unique principalId).Count

    $gaPercentage = ($gaCount / $totalPrivilegedCount) * 100
    $hasHealthyRatio = $gaPercentage -lt 30

    if ($hasHealthyRatio) {
        $passed = $true
        $testResultMarkdown = "✅ **Passou**: Menos de 30% dos usuários privilegiados são Administradores Globais.`n`n"
    } else {
        $passed = $false
        $testResultMarkdown = "❌ **Falha**: Mais de 30% dos usuários privilegiados possuem a função de Administrador Global.`n`n"
    }

    Add-ZtTestResultDetail -TestId '21813' -Status $passed -Result $testResultMarkdown
}
