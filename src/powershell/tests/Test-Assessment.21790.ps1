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
    	Title = 'Configurações de acesso de saída entre locatários estão configuradas',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando se as configurações de acesso de saída entre locatários estão configuradas"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = Invoke-ZtGraphRequest -RelativeUri 'policies/crossTenantAccessPolicy/default' -ApiVersion v1.0

    function Get-TargetDescription {
        [CmdletBinding()]
        param ([Parameter(Mandatory)][object]$TargetConfig)
        if ($TargetConfig.targets[0].target -eq "AllUsers") { return "Todos os usuários" }
        elseif ($TargetConfig.targets[0].target -eq "AllApplications") { return "Todos os aplicativos externos" }
        else { return "Personalizado" }
    }

    $passed = $result.b2bCollaborationOutbound.usersAndGroups.accessType -eq 'block' -and $result.b2bCollaborationOutbound.applications.accessType -eq 'block'

    $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_IAM/CompanyRelationshipsMenuBlade/~/CrossTenantAccessSettings"
    $mdInfo = @"
## [Configurações de acesso de saída - Padrão]($portalLink)
### Colaboração B2B
Usuários e grupos: $($result.b2bCollaborationOutbound.usersAndGroups.accessType) ($($result.b2bCollaborationOutbound.usersAndGroups.accessType))
Aplicativos externos: $($result.b2bCollaborationOutbound.applications.accessType)
### Conexão Direta B2B
Usuários e grupos: $($result.b2bDirectConnectOutbound.usersAndGroups.accessType)
Aplicativos externos: $($result.b2bDirectConnectOutbound.applications.accessType)
"@

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    Add-ZtTestResultDetail -TestId '21790' -Status $passed -Result $testResultMarkdown
}
