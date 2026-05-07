<#
.SYNOPSIS
    Verifica se todos os aplicativos do Private Access têm usuários ou grupos atribuídos
.DESCRIPTION
    Verifica se cada aplicativo do Private Access tem pelo menos um usuário ou grupo atribuído a ele por meio do appRoleAssignedTo.

.NOTES
    Test ID: 25481
    Category: Global Secure Access
    Required API: servicePrincipals with appRoleAssignedTo expansion
#>

function Test-Assessment-25481 {
    [ZtTest(
    	Category = 'Acesso Seguro Global',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Entra_Private_Access'),
    	CompatibleLicense = ('Entra_Premium_Private_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce','External'),
    	TestId = 25481,
    	Title = 'Todos os aplicativos de Private Access têm atribuições de usuários ou grupos',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando atribuições de usuário e grupo dos aplicativos do Private Access'
    Write-ZtProgress -Activity $activity -Status 'Consultando todos os aplicativos do Private Access'

        # Consulta Q1: Single optimized query for all Private Access applications with assignments
    $privateAccessApps = Invoke-ZtGraphRequest -RelativeUri "servicePrincipals?`$filter=tags/any(c:c eq 'IsAccessibleViaZTNAClient')&`$expand=appRoleAssignedTo&`$select=id,appId,displayName,accountEnabled,appRoleAssignmentRequired" -ApiVersion beta
    #endregion Data Collection

    #region Assessment Logic
    # Initialize test variables
    $testResultMarkdown = ''
    $passed = $false
    $customStatus = $null

    # Check if any Private Access applications exist
    if (-not $privateAccessApps -or $privateAccessApps.Count -eq 0) {
        $testResultMarkdown = '⚠️ Nenhum aplicativo do Private Access está configurado no tenant, revise a documentação sobre como ativar os aplicativos do Private Access.'
        $customStatus = 'Investigate'
    }
    else {
        # Check each application for assignments and determine pass/fail
        $appsWithoutAssignments = $privateAccessApps | Where-Object { -not $_.appRoleAssignedTo -or $_.appRoleAssignedTo.Count -eq 0 }

        if ($appsWithoutAssignments.Count -eq 0) {
            $passed = $true
            $testResultMarkdown = "✅ Todos os aplicativos do Private Access têm usuários ou grupos atribuídos. `n`n%TestResult%"
        }
        else {
            $passed = $false
            $testResultMarkdown = "❌ Encontrados aplicativos do Private Access sem usuários ou grupos atribuídos. `n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build detailed markdown information
    $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/EnterpriseApplicationListBladeV3/fromNav/globalSecureAccess/applicationType/GlobalSecureAccessApplication'
    $mdInfo = ''

    if ($privateAccessApps -and $privateAccessApps.Count -gt 0) {
        # Sort applications alphabetically for better readability
        $sortedApps = $privateAccessApps | Sort-Object displayName

        # Build comprehensive table with all information
        $mdInfo += "## [Aplicativos do Private Access]($portalLink)`n`n"
        $mdInfo += "| Nome do aplicativo | Número de atribuições | Principal atribuído | Tipo de principal |`n"
        $mdInfo += "|------------------|---------------|--------------------|----------------|`n"

        foreach ($app in $sortedApps) {
            $appName = $app.displayName
            $appId = $app.appId
            $objectId = $app.id
            $hasAssignments = $null -ne $app.appRoleAssignedTo -and $app.appRoleAssignedTo.Count -gt 0
            $assignmentCount = if ($hasAssignments) { $app.appRoleAssignedTo.Count } else { 0 }
            $statusIcon = if ($hasAssignments) { "✅" } else { "❌" }
            $appBladeLink = "https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/$objectId/appId/$appId"
            $safeAppName = Get-SafeMarkdown $appName
            $appNameWithIcon = "$statusIcon [$safeAppName]($appBladeLink)"

            if ($hasAssignments) {
                # Add a row for each assignment
                $firstAssignment = $true
                foreach ($assignment in $app.appRoleAssignedTo) {
                    $principalName = $assignment.principalDisplayName
                    $principalType = $assignment.principalType

                    # Show app name and count only in the first row for each app
                    if ($firstAssignment) {
                        $mdInfo += "| $appNameWithIcon | $assignmentCount | $principalName | $principalType |`n"
                        $firstAssignment = $false
                    } else {
                        $mdInfo += "| | | $principalName | $principalType |`n"
                    }
                }
            } else {
                # No assignments - show single row with empty principal columns
                $mdInfo += "| $appNameWithIcon | $assignmentCount | | |`n"
            }
        }
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25481'
        Title  = 'Todos os aplicativos de Private Access têm usuários ou grupos atribuídos'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add CustomStatus if status is 'Investigate'
    if ($null -ne $customStatus) {
        $params.CustomStatus = $customStatus
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
