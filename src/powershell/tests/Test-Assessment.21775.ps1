<#
.SYNOPSIS
    Valida se a política de gerenciamento de aplicativos do tenant está configurada com restrições de credenciais.
#>

function Test-Assessment-21775{
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21775,
    	Title = 'Impor padrões para segredos e certificados de aplicativos',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = 'Verificando se a política de gerenciamento de aplicativos está configurada'
    Write-ZtProgress -Activity $activity -Status 'Obtendo política'

    $policy = Invoke-ZtGraphRequest -RelativeUri 'policies/defaultAppManagementPolicy' -ApiVersion v1.0

    $testResultMarkdown = ''
    $passed = $false
    $mdInfo = ""

    if ($null -ne $policy -and $policy.isEnabled -eq $true) {
        $passed = $true
        $testResultMarkdown = "✅ **Passou**: A política de gerenciamento de aplicativos está habilitada e configurada.`n`n"
        $mdInfo += "### Detalhes da Política`n`n- **Nome**: $($policy.displayName)`n- **Status**: Habilitada`n"
    }
    else {
        $testResultMarkdown = "❌ **Falha**: A política de gerenciamento de aplicativos padrão não está configurada ou habilitada.`n`n"
        $mdInfo += "A política de gerenciamento de aplicativos permite controlar o ciclo de vida das credenciais e impor padrões de segurança.`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo

    Add-ZtTestResultDetail -TestId '21775' -Status $passed -Result $testResultMarkdown
}
