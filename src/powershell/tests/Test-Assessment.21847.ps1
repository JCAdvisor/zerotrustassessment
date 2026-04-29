<#
.SYNOPSIS

#>

function Test-Assessment-21847 {

    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 21847,
    	Title = 'A proteção de senha para ambientes locais está habilitada',
    	UserImpact = 'Baixo'
    )]

    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se a proteção de senha para ambientes locais está habilitada"
    Write-ZtProgress -Activity $activity -Status "Obtendo detalhes da organização"

    # Q1: Verifica se o locatário possui sincronização local
    $orgResponse = Invoke-ZtGraphRequest -RelativeUri "organization?`$select=id,displayName,onPremisesSyncEnabled,onPremisesLastSyncDateTime" -ApiVersion v1.0

    if ($orgResponse.onPremisesSyncEnabled -ne $true) {
        $passed = $true
        $testResultMarkdown = "✅ **Passou**: Este locatário não está sincronizado com um ambiente local.%TestResult%"
    }
    else {
        # Q2: Verifica as configurações de proteção de senha
        Write-ZtProgress -Activity $activity -Status "Verificando configurações de proteção de senha"

        $pwdSettings = Invoke-ZtGraphRequest -RelativeUri "groupSettings" -ApiVersion v1.0 | Where-Object { $_.displayName -eq "Password Rule Settings" }
        
        $mdInfo = ""
        if ($null -eq $pwdSettings) {
             $passed = $false
             $testResultMarkdown = "❌ **Falha**: Configurações de regra de senha não encontradas.%TestResult%"
        }
        else {
            $enabledSetting = $pwdSettings.values | Where-Object { $_.name -eq "EnableBannedPasswordCheckOnPremises" }
            $modeSetting = $pwdSettings.values | Where-Object { $_.name -eq "ProxyMode" }

            $passwordProtectionStatus = if ($enabledSetting.value -eq $true) { "Habilitado ✅" } else { "Desabilitado ❌" }
            $modeStatus = if ($modeSetting.value -eq "Enforce") { "Imposto (Enforce) ✅" } else { "Auditoria (Audit) ⚠️" }

            $mdInfo = "`n| Configuração | Status |`n| :--- | :--- |`n"
            $mdInfo += "| Proteção de Senha para Active Directory Domain Services | $passwordProtectionStatus |`n"
            $mdInfo += "| Modo Habilitado (Auditoria/Imposição) | $($modeStatus) |`n"

            if ($enabledSetting.value -eq $true -and $modeSetting.value -eq "Enforce") {
                $passed = $true
                $testResultMarkdown = "✅ **Passou**: A proteção de senha do Entra está habilitada e imposta.`n%TestResult%"
            }
            else {
                $passed = $false
                if ($enabledSetting.value -ne $true) {
                    $testResultMarkdown = "`n❌ **Falha**: A proteção de senha para ambientes locais não está habilitada.`n%TestResult%"
                }
                else {
                    if ($modeSetting.value -ne "Enforce") {
                        $testResultMarkdown = "`n❌ **Falha**: A proteção de senha para ambientes locais não está definida para o modo 'Impor' (Enforce).`n%TestResult%"
                    }
                    else {
                        $testResultMarkdown = "`n❌ **Falha**: A proteção de senha do Entra não está configurada corretamente.`n%TestResult%"
                    }
                }
            }
        }
    }

    # Substitui o marcador pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21847'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
