<#
.SYNOPSIS

#>

function Test-Assessment-21850 {
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21850,
    	Title = 'O limite do bloqueio inteligente está definido para 10 ou menos',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se o limite do Bloqueio Inteligente não é superior a 10"
    Write-ZtProgress -Activity $activity -Status 'Obtendo configurações de regra de senha'

    $allSettings = Invoke-ZtGraphRequest -RelativeUri 'settings' -ApiVersion beta
    $passwordRuleSettings = $allSettings | Where-Object { $_.displayName -eq "Password Rule Settings" }

    $mdInfo = ""
    if ($null -eq $passwordRuleSettings) {
        $passed = $false
        $testResultMarkdown = "Modelo de configurações de regra de senha não encontrado.%TestResult%"
    }
    else {
        $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/AuthenticationMethodsMenuBlade/~/PasswordProtection/fromNav/'
        $lockoutThresholdSetting = $passwordRuleSettings.values | Where-Object { $_.name -eq "LockoutThreshold" }
        
        if ($null -eq $lockoutThresholdSetting) {
            $passed = $false
            $testResultMarkdown = "Configuração de limite de bloqueio não encontrada nas [regras de senha]($portalLink).%TestResult%"
        }
        else {
            $lockoutThreshold = [int]$lockoutThresholdSetting.Value
            $mdInfo = "`n## Configuração do Bloqueio Inteligente`n`n| Configuração | Valor |`n| :---- | :---- |`n| [Limite de bloqueio]($portalLink) | $(Get-SafeMarkdown($lockoutThreshold)) tentativas|`n"

            if ($lockoutThreshold -le 10) {
                $passed = $true
                $testResultMarkdown = "O limite do bloqueio inteligente está definido para 10 ou abaixo.%TestResult%"
            }
            else {
                $passed = $false
                $testResultMarkdown = "O limite do bloqueio inteligente está configurado acima de 10.%TestResult%"
            }
        }
    }
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21850'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
