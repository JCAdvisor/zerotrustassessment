<#
.SYNOPSIS
    Verifica se o método de autenticação por Passkey (FIDO2) está ativado e configurado para usuários no locatário.
#>

function Test-Assessment-21839 {
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce','External'),
    	TestId = 21839,
    	Title = 'Método de autenticação por Passkey ativado',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando se o método de autenticação por Passkey está ativado'
    Write-ZtProgress -Activity $activity -Status 'Obtendo política'

    $fido2Config = Invoke-ZtGraphRequest -RelativeUri 'authenticationMethodsPolicy/authenticationMethodConfigurations/FIDO2' -ApiVersion beta

    $state = $fido2Config.state
    $includeTargets = $fido2Config.includeTargets
    $isAttestationEnforced = $fido2Config.isAttestationEnforced
    $keyRestrictions = $fido2Config.keyRestrictions

    $fido2Enabled = $state -eq 'enabled'
    $hasIncludeTargets = $includeTargets -and $includeTargets.Count -gt 0

    $mdInfo = "`n`n### Detalhes da Configuração de Passkey`n`n"
    $mdInfo += "- **Status** : $state`n"
    $mdInfo += "- **Alvos incluídos** : "
    if ($hasIncludeTargets) {
        $mdInfo += ($includeTargets | ForEach-Object { Get-ZtAuthenticatorFeatureSettingTarget -Target $_ }) -join ', '
    } else {
        $mdInfo += 'Nenhum'
    }
    $mdInfo += "`n- **Impor atestado** : $isAttestationEnforced`n"

    if ($fido2Enabled -and $hasIncludeTargets) {
        $passed = $true
        $testResultMarkdown = "O método de autenticação por Passkey está ativado e configurado para usuários em seu locatário.$mdInfo"
    } else {
        $passed = $false
        $testResultMarkdown = "O método de autenticação por Passkey não está ativado ou não está configurado para nenhum usuário em seu locatário.$mdInfo"
    }

    $params = @{
        TestId = '21839'
        Status = $passed
        Result = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
