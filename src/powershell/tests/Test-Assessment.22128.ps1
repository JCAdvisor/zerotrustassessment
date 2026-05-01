<#
.SYNOPSIS

#>

function Test-Assessment-22128 {
    [ZtTest(
        Category = 'Gestão de aplicativos',
        ImplementationCost = 'Médio',
        MinimumLicense = ('Free'),
        Pillar = 'Identidade',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger tenants e isolar sistemas de produção',
        TenantType = ('Workforce', 'External'),
        TestId = 22128,
        Title = 'Usuários convidados não possuem funções de diretório altamente privilegiadas atribuídas',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    $activity = "Verificando se usuários convidados não possuem funções de diretório altamente privilegiadas atribuídas"
    Write-ZtProgress -Activity $activity -Status "Obtendo funções de diretório altamente privilegiadas"

    # Consulta SQL para encontrar entidades de serviço com credenciais de senha
    $sqlPrivilegedRoles = @"
    SELECT
        vr.roleDefinitionId,
        vr.roleDisplayName,
        vr.isPrivileged,
        vr.principalId,
        vr.principalDisplayName,
        vr.userPrincipalName,
        u.userType as userType,  -- Tipo de Usuário Adicionado
        vr.privilegeType as assignmentType
    FROM vwRole vr
    LEFT JOIN "User" u ON vr.principalId = u.id  -- Join com a tabela User
    WHERE vr.isPrivileged = true AND u.userType = 'Guest'
    AND vr."@odata.type" = '#microsoft.graph.user'  -- Filtrar apenas para usuários
    ORDER BY vr.roleDisplayName, vr.principalDisplayName
"@
    $resultsPrivilegedRoles = Invoke-DatabaseQuery -Database $Database -Sql $sqlPrivilegedRoles

    $passed = $resultsPrivilegedRoles.Count -eq 0

    $testResultMarkdown = ''
    if ($passed) {
        $testResultMarkdown = "Nenhum usuário convidado foi encontrado em funções de diretório altamente privilegiadas.`n`n"
    }
    else {
        $testResultMarkdown = "Encontrados $($resultsPrivilegedRoles.Count) usuários convidados em funções de diretório altamente privilegiadas.`n`n%TestResult%"
    }

    # Gerar informações detalhadas se houver funções privilegiadas
    $mdInfo = ''
    if ($resultsPrivilegedRoles) {
        $tableRows = ''
        $reportTitle = "Usuários Convidados em Funções Privilegiadas"

        # Criar uma here-string com espaços reservados para formato {0}, {1}, etc.
        $formatTemplate = @'

## {0}


| Nome da Função | Nome do Usuário | Nome Principal do Usuário (UPN) | Tipo de Usuário | Tipo de Atribuição |
| :-------- | :-------- | :------------------ | :-------- | :-------------- |
{1}

'@

        foreach ($role in $resultsPrivilegedRoles) {
            if ($role.userType -ne 'Guest') {
                continue
            }

            $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/overview/userId/{0}/hidePreviewBanner~/true' -f $role.principalId
            $tableRows += @'
| {0} | [{1}]({2}) | {3} | {4} | {5} |
'@ -f $role.roleDisplayName, (Get-SafeMarkdown -Text $role.principalDisplayName), $portalLink, $role.userPrincipalName, $role.userType, $role.assignmentType
            $tableRows += "`n"
        }

        # Formatar o modelo substituindo os espaços reservados pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }
    # Substituir o espaço reservado pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo


    $params = @{
        TestId             = '22128'
        Title              = "Usuários convidados não possuem funções de diretório altamente privilegiadas atribuídas"
        UserImpact         = 'Low'
        Risk               = 'High'
        ImplementationCost = 'Low'
        AppliesTo          = 'Identity'
        Tag                = 'Identity'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
