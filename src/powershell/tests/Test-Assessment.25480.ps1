<#
.SYNOPSIS
    Verifica se o Quick Access tem usuários ou grupos atribuídos
.DESCRIPTION
    Verifica se o aplicativo Quick Access tem pelo menos um usuário ou grupo atribuído a ele por meio do appRoleAssignedTo.

.NOTES
    Test ID: 25480
    Category: Global Secure Access
    Required API: servicePrincipals with appRoleAssignedTo expansion
#>

function Test-Assessment-25480 {
    [ZtTest(
    	Category = 'Acesso Seguro Global',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Entra_Private_Access'),
    	CompatibleLicense = ('Entra_Premium_Private_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce','External'),
    	TestId = 25480,
    	Title = 'O Quick Access tem atribuições de usuários ou grupos',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando atribuições de usuário e grupo do Quick Access'
    Write-ZtProgress -Activity $activity -Status 'Consultando aplicação Quick Access e usuários/grupos atribuídos'

        # Consulta 1: Find Quick Access application with appRoleAssignedTo expansion
    # executing the original query in graph explorer ignores $select and returns complete entity. A Q&A thread mentions no support for nested $select on expanded directory object relationships [known-issues](https://developer.microsoft.com/en-us/graph/known-issues/?search=13635)
    $app = Invoke-ZtGraphRequest -RelativeUri "servicePrincipals?`$filter=tags/any(c:c eq 'NetworkAccessQuickAccessApplication')&`$expand=appRoleAssignedTo" -ApiVersion beta
    #endregion Data Collection

    #region Assessment Logic
    # Initialize test variables
    $testResultMarkdown = ''
    $passed = $false
    $appRoleAssignments = @()
    $customStatus = $null

    # Check if Quick Access application exists
    if (-not $app -or $app.Count -eq 0) {
        # Quick Access app not configured - Investigate status
        $testResultMarkdown = '⚠️ O aplicativo Quick Access não está configurado no tenant. Os clientes devem revisar a documentação sobre como ativar o Quick Access.'
        $customStatus = 'Investigate'
    }
    else {
        # Check appRoleAssignedTo
        if ($null -ne $app.appRoleAssignedTo -and $app.appRoleAssignedTo.Count -gt 0) {
            $appRoleAssignments = $app.appRoleAssignedTo
            $passed = $true
            $testResultMarkdown = "✅ O aplicativo Quick Access tem usuários ou grupos atribuídos. `n`n%TestResult%"
        }
        else {
            # appRoleAssignedTo is empty, null, or contains no entries
            $passed = $false
            $testResultMarkdown = "❌ O aplicativo Quick Access não tem atribuições de usuário ou grupo. `n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build detailed markdown information
    $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/QuickAccessMenuBlade/~/GlobalSecureAccess'

    $mdInfo = ''

    if ($appRoleAssignments.Count -gt 0) {
        # Build results table with link to Users blade
        $reportTitleLink = "[Atribuições do aplicativo Quick Access]($portalLink)"
        $mdInfo += "`n## $reportTitleLink`n`n"
        $mdInfo += "| Tipo de membro | Nome de exibição |`n"
        $mdInfo += "|-------------|--------------|`n"
        foreach ($assignment in $appRoleAssignments) {
            $memberType = $assignment.principalType
            $displayName = $assignment.principalDisplayName
            $mdInfo += "| $memberType | $displayName |`n"
        }
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25480'
        Title  = 'O Quick Access tem usuários ou grupos atribuídos'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add CustomStatus if Investigate is needed
    if ($null -ne $customStatus) {
        $params.CustomStatus = $customStatus
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
