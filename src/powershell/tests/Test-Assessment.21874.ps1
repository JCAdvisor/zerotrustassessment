<#
.SYNOPSIS
#>

function Test-Assessment-21874 {
    [ZtTest(
    	Category = 'Colaboração externa',
    	ImplementationCost = 'Alto',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce','External'),
    	TestId = 21874,
    	Title = 'O acesso de convidados é limitado a locatários aprovados',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se listas de permissão/bloqueio de domínios estão configuradas"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $policies = Invoke-ZtGraphRequest -RelativeUri 'legacy/policies' -ApiVersion beta

    $passed = $false
    foreach ($policy in $policies) {
        if ( $policy.definition -and ($null -ne ($policy.definition | ConvertFrom-Json).B2BManagementPolicy.InvitationsAllowedAndBlockedDomainsPolicy.AllowedDomains) ) {
            $passed = $true
            $testResultMarkdown = "Listas de permissão/bloqueio de domínios para restringir colaboração externa estão configuradas."
            break
        }
        else {
            $passed = $false
            $testResultMarkdown = "Listas de permissão/bloqueio de domínios para restringir colaboração externa não estão configuradas."
        }
    }

    $params = @{
        TestId             = '21874'
        Title              = "O acesso de convidados é limitado a locatários aprovados"
        UserImpact         = 'Médio'
        Risk               = 'Médio'
        ImplementationCost = 'Alto'
        AppliesTo          = 'Identity'
        Tag                = 'Identity'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
