<#
.SYNOPSIS
    Verifica se a duração do Bloqueio Inteligente está definida para um mínimo de 60 segundos.
#>

function Test-Assessment-21849 {
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21849,
    	Title = 'A duração do bloqueio inteligente está definida para um mínimo de 60 segundos',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando se a duração do Bloqueio Inteligente está definida para no mínimo 60'
    Write-ZtProgress -Activity $activity -Status 'Obtendo configurações de regra de senha'

    $groupSettings = Invoke-ZtGraphRequest -RelativeUri 'Settings' -ApiVersion beta
    $passwordRuleSettings = $groupSettings | Where-Object { $_.displayName -eq 'Password Rule Settings' }

    $passed = $true
    $testResultMarkdown = ""
    $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/AuthenticationMethodsMenuBlade/~/PasswordProtection/fromNav/'

    if ($null -eq $passwordRuleSettings) {
        $passed = $true
        $mdInfo = "`n## Configurações do Bloqueio Inteligente`n`n| Configuração | Valor |`n| :---- | :---- |`n| [Duração do Bloqueio (segundos)]($portalLink) | 60 (Padrão) |`n"
        $testResultMarkdown = "A duração do Bloqueio Inteligente está configurada para 60 segundos ou mais.$mdInfo"
    }
    else {
        $lockoutDurationSetting = $passwordRuleSettings.values | Where-Object { $_.name -eq 'LockoutDurationInSeconds' }

        if ($null -eq $lockoutDurationSetting) {
            $passed = $true
            $mdInfo = "`n## Configurações do Bloqueio Inteligente`n`n| Configuração | Valor |`n| :---- | :---- |`n| [Duração do Bloqueio (segundos)]($portalLink) | 60 (Padrão) |`n"
            $testResultMarkdown = "A duração do Bloqueio Inteligente está configurada para 60 segundos ou mais.$mdInfo"
        }
        else {
            $lockoutDuration = [int]$lockoutDurationSetting.value
            $mdInfo = "`n## Configurações do Bloqueio Inteligente`n`n| Configuração | Valor |`n| :---- | :---- |`n| [Duração do Bloqueio (segundos)]($portalLink) | $lockoutDuration |`n"

            if ($lockoutDuration -ge 60) {
                $passed = $true
                $testResultMarkdown = "A duração do Bloqueio Inteligente está configurada para 60 segundos ou mais.$mdInfo"
            }
            else {
                $passed = $false
                $testResultMarkdown = "A duração do Bloqueio Inteligente está configurada abaixo de 60 segundos.$mdInfo"
            }
        }
    }

    $params = @{
        TestId = '21849'
        Status = $passed
        Result = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
