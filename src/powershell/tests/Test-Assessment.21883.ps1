<#
.SYNOPSIS
   Verifica se as identidades de carga de trabalho estão configuradas com políticas baseadas em risco.
#>

function Test-Assessment-21883 {
    [ZtTest(
    	Category = 'Access control',
    	ImplementationCost = 'Low',
    	MinimumLicense = ('Workload'),
    	Pillar = 'Identity',
    	RiskLevel = 'Medium',
    	SfiPillar = 'Accelerate response and remediation',
    	TenantType = ('Workforce','External'),
    	TestId = 21883,
    	Title = 'Identidades de Carga de Trabalho configuradas com políticas baseadas em risco',
    	UserImpact = 'High'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraWorkloadID) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraWorkloadID
        return
    }

    $activity = "Verificando se as identidades de carga de trabalho baseadas em políticas de risco estão configuradas"
    Write-ZtProgress -Activity $activity -Status "Obtendo políticas"

    # Consultar todas as políticas de CA
    $allCAPolicies = Invoke-ZtGraphRequest -RelativeUri 'policies/conditionalAccessPolicies' -ApiVersion beta

    # Filtragem local para políticas habilitadas que bloqueiam e incluem Service Principals
    $matchedPolicies = $allCAPolicies | Where-Object {
        $_.grantControls.builtInControls -contains "block" -and
        $_.conditions.clientApplications.includeServicePrincipals -and
        $_.state -eq "enabled"
    }

    $testResultMarkdown = ""

    if (($matchedPolicies | Measure-Object).Count -ge 1) {
        $passed = $true
        $testResultMarkdown += "Políticas de identidades de carga de trabalho baseadas em risco estão configuradas.`n`n%TestResult%"
    }
    else {
        $passed = $false
        $testResultMarkdown += "Políticas de identidades de carga de trabalho baseadas em risco não estão configuradas."
    }

    $params = @{
        TestId             = '21883'
        Title              = "Identidades de Carga de Trabalho configuradas com políticas baseadas em risco"
        UserImpact         = 'Low'
        Risk               = 'High'
        ImplementationCost = 'Low'
        AppliesTo          = 'Identity'
        Tag                = 'Identity'
        GraphObjectType    = 'ConditionalAccess'
        GraphObjects       = $matchedPolicies
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
