<#
.SYNOPSIS
#>

function Test-Assessment-21838 {
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce','External'),
    	TestId = 21838,
    	Title = 'Método de autenticação de chave de segurança ativado',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando se o método de autenticação de chave de segurança está ativado'
    Write-ZtProgress -Activity $activity -Status 'Obtendo política de método de autenticação FIDO2'

    # Consulta a configuração do método de autenticação FIDO2
    $fido2Config = Invoke-ZtGraphRequest -RelativeUri 'authenticationMethodsPolicy/authenticationMethodConfigurations/FIDO2' -ApiVersion beta

    # Verifica se o método de autenticação FIDO2 está ativado
    $fido2Enabled = $fido2Config.state -eq 'enabled'

    if ($fido2Enabled) {
        $passed = $true
        $testResultMarkdown = "O método de autenticação por chave de segurança está ativado em seu locatário, fornecendo autenticação resistente a phishing baseada em hardware.`n`n%TestResult%"
        $statusEmoji = '✅'
    } else {
        $passed = $false
        $testResultMarkdown = "O método de autenticação por chave de segurança não está ativado; os usuários não podem registrar chaves de segurança FIDO2 para autenticação forte.`n`n%TestResult%"
        $statusEmoji = '❌'
    }

    # Gera os detalhes do relatório
    $reportTitle = 'Configurações do método de autenticação de chave de segurança FIDO2'

    $formatTemplate = @"

## {0}

$statusEmoji **Método de autenticação FIDO2**
- Status: $((Get-Culture).TextInfo.ToTitleCase($fido2Config.state.ToLower()))
- Alvos incluídos: $(if ($fido2Config.includeTargets -is [array] -and $fido2Config.includeTargets.Count -gt 0) { ($fido2Config.includeTargets | ForEach-Object { Get-ZtAuthenticatorFeatureSettingTarget -Target $_ }) -join ', ' } else { 'Nenhum' })
- Alvos excluídos: $(if ($fido2Config.excludeTargets -is [array] -and $fido2Config.excludeTargets.Count -gt 0) { ($fido2Config.excludeTargets | ForEach-Object { Get-ZtAuthenticatorFeatureSettingTarget -Target $_ }) -join ', ' } else { 'Nenhum' })
"@

    $mdInfo = $formatTemplate -f $reportTitle
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21838'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
