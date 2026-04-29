<#
.SYNOPSIS
    Verifica se o Aplicativo Corporativo Azure Active Directory PowerShell está bloqueado
#>

function Test-Assessment-21844 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce'),
    	TestId = 21844,
    	Title = 'Bloquear o módulo legado Azure AD PowerShell',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando o bloqueio do módulo legado Azure AD PowerShell'
    Write-ZtProgress -Activity $activity -Status 'Consultando principal de serviço do Azure AD PowerShell'

    $azureADPowerShellAppId = '1b730954-1685-4b74-9bfd-dac224a7b894'
    $sp = Invoke-ZtGraphRequest -RelativeUri 'servicePrincipals' -ApiVersion 'v1.0' -Filter "appId eq '$azureADPowerShellAppId'"

    $passed = $false
    if ($sp.accountEnabled -eq $false) {
        $passed = $true
        $testResultMarkdown = "O Azure AD PowerShell está bloqueado no locatário desativando o logon do usuário no Aplicativo Corporativo."
    } else {
        $testResultMarkdown = "O Azure AD PowerShell não foi bloqueado pela organização."
    }

    Add-ZtTestResultDetail -TestId '21844' -Status $passed -Result $testResultMarkdown
}
