<#
.SYNOPSIS
#>

function Test-Assessment-21842 {
    [ZtTest(
    	Category = 'Gerenciamento de credenciais, Acesso privilegiado',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce'),
    	TestId = 21842,
    	Title = 'Bloquear administradores de usar o SSPR',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando se administradores estão bloqueados de usar o SSPR'
    Write-ZtProgress -Activity $activity -Status 'Obtendo política'

    $authorizationPolicy = Invoke-ZtGraphRequest -RelativeUri 'policies/authorizationPolicy' -ApiVersion beta
    $allowedToUseSspr = $authorizationPolicy.allowedToUseSspr

    $passed = $false
    $userMessage = ""

    if ($null -ne $allowedToUseSspr -and $allowedToUseSspr -eq $false) {
        $passed = $true
        $userMessage = '✅ Administradores estão devidamente bloqueados de usar o Autoatendimento para Redefinição de Senha.'
    } else {
        $userMessage = '❌ Administradores têm acesso ao Autoatendimento para Redefinição de Senha, o que contorna controles de segurança.'
    }

    $testResultMarkdown = @"
$userMessage
"@

    Add-ZtTestResultDetail -TestId '21842' -Status $passed -Result $testResultMarkdown
}
