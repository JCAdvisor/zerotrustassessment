<#
.SYNOPSIS

#>

function Test-Assessment-21790 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Alto',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce','External'),
    	TestId = 21790,
    	Title = 'As configurações de acesso entre locatários de saída estão definidas',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando as configurações de acesso entre locatários de saída'
    Write-ZtProgress -Activity $activity -Status 'Obtendo política'

    # Query the default cross-tenant access policy
    $result = Invoke-ZtGraphRequest -RelativeUri 'policies/crossTenantAccessPolicy/default' -ApiVersion v1.0

    # Helper function to process targets
    function Get-TargetDescription {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory)]
            [object]$TargetConfig
        )

        if ($TargetConfig.targets[0].target -eq "AllUsers") {
            return "Todos os usuários"
        }
        elseif ($TargetConfig.targets[0].target -eq "AllApplications") {
            return "Todos os aplicativos externos"
        }
        else {
            $users = 0
            $groups = 0
            $applications = 0

            foreach ($target in $TargetConfig.targets) {
                if ($target.targetType -eq "user") {
                    $users++
                }
                elseif ($target.targetType -eq "group") {
                    $groups++
                }
                else {
                    $applications++
                }
            }

            if ($applications -gt 0) {
                return "Aplicativos externos selecionados ($applications aplicativos)"
            }
            else {
                return "Usuários e grupos selecionados ($users usuários, $groups grupos)"
            }
        }
    }

    # Evaluate B2B Collaboration outbound settings
    $b2bCollaborationOutbound = $result.b2bCollaborationOutbound.usersAndGroups.accessType -eq "blocked" -and
    $result.b2bCollaborationOutbound.usersAndGroups.targets[0].target -eq "AllUsers" -and
    $result.b2bCollaborationOutbound.applications.accessType -eq "blocked" -and
    $result.b2bCollaborationOutbound.applications.targets[0].target -eq "AllApplications"

    # Evaluate B2B Direct Connect outbound settings
    $b2bDirectConnectOutbound = $result.b2bDirectConnectOutbound.usersAndGroups.accessType -eq "blocked" -and
    $result.b2bDirectConnectOutbound.usersAndGroups.targets[0].target -eq "AllUsers" -and
    $result.b2bDirectConnectOutbound.applications.accessType -eq "blocked" -and
    $result.b2bDirectConnectOutbound.applications.targets[0].target -eq "AllApplications"

    $testResultMarkdown = ""

    if ($b2bCollaborationOutbound -and $b2bDirectConnectOutbound) {
        $passed = $true
        $testResultMarkdown += "✅ O locatário possui uma política de acesso entre locatários de saída padrão que bloqueia o acesso.%TestResult%"
    }
    else {
        $passed = $false
        $testResultMarkdown += "❌ O locatário possui uma política de acesso entre locatários de saída padrão com acesso irrestrito.%TestResult%"
    }

    # Portal link for the report
    $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/OutboundAccessSettings.ReactView/isDefault~/true/name//id/'

    # Get user/group target descriptions
    $b2bColUsersTargetDesc = Get-TargetDescription -TargetConfig $result.b2bCollaborationOutbound.usersAndGroups
    $b2bColAppsTargetDesc = Get-TargetDescription -TargetConfig $result.b2bCollaborationOutbound.applications
    $b2bDirUsersTargetDesc = Get-TargetDescription -TargetConfig $result.b2bDirectConnectOutbound.usersAndGroups
    $b2bDirAppsTargetDesc = Get-TargetDescription -TargetConfig $result.b2bDirectConnectOutbound.applications

    # Create a here-string with the report details
    $mdInfo = @"

## [Configurações de acesso de saída - Configurações padrão]($portalLink)
### B2B Collaboration
Usuários e grupos
- Status de acesso: $($result.b2bCollaborationOutbound.usersAndGroups.accessType)
- Aplica-se a: $b2bColUsersTargetDesc

Aplicativos externos
- Status de acesso: $($result.b2bCollaborationOutbound.applications.accessType)
- Aplica-se a: $b2bColAppsTargetDesc

### B2B Direct Connect
Usuários e grupos
- Status de acesso: $($result.b2bDirectConnectOutbound.usersAndGroups.accessType)
- Aplica-se a: $b2bDirUsersTargetDesc

Aplicativos externos
- Status de acesso: $($result.b2bDirectConnectOutbound.applications.accessType)
- Aplica-se a: $b2bDirAppsTargetDesc

"@

    # Replace the placeholder with the detailed information
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21790'
        Title              = 'As configurações de acesso entre locatários de saída estão definidas'
        UserImpact         = 'Medium'
        Risk               = 'High'
        ImplementationCost = 'High'
        AppliesTo          = 'Identity'
        Tag                = 'Identity'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
