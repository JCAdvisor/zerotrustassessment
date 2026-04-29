<#
.SYNOPSIS
    Verifica se o atestado de chave de segurança é imposto na política de métodos de autenticação FIDO2.
#>

function Test-Assessment-21840{
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce','External'),
    	TestId = 21840,
    	Title = 'Atestado de chave de segurança é imposto',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando se o atestado de chave de segurança é imposto'
    Write-ZtProgress -Activity $activity -Status 'Obtendo política'

    $fido2Config = Invoke-ZtGraphRequest -RelativeUri 'authenticationMethodsPolicy/authenticationMethodConfigurations/FIDO2' -ApiVersion beta

    $isAttestationEnforced = $fido2Config.isAttestationEnforced
    $keyRestrictions = $fido2Config.keyRestrictions

    $mdInfo = "`n`n- **Atestado imposto** : $isAttestationEnforced`n"

    if ($isAttestationEnforced -eq $true) {
        $passed = $true
        $testResultMarkdown = "O atestado de chave de segurança é imposto corretamente, garantindo que apenas autenticadores de hardware verificados possam ser registrados.$mdInfo"
    } else {
        $passed = $false
        $testResultMarkdown = "O atestado de chave de segurança não é imposto, permitindo o registro de chaves de segurança não verificadas ou potencialmente comprometidas.$mdInfo"
    }

    $params = @{
        TestId             = '21840'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
