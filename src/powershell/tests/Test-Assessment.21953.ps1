<#
.SYNOPSIS
    Verifica se a Solução de Senha de Administrador Local (LAPS) está implantada no tenant.
#>

function Test-Assessment-21953{
    [ZtTest(
    	Category = 'Dispositivos',
    	ImplementationCost = 'Medium',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'High',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21953,
    	Title = 'A Solução de Senha de Administrador Local (LAPS) está implantada',
    	UserImpact = 'Low'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = 'Verificando se a Solução de Senha de Administrador Local (LAPS) está implantada'
    Write-ZtProgress -Activity $activity -Status 'Obtendo configurações do LAPS'

    $lapsSettings = Invoke-ZtGraphRequest -RelativeUri 'policies/deviceRegistrationPolicy' -ApiVersion beta

    $passed = $true
    $testResultMarkdown = ""

    if ($null -eq $lapsSettings) {
        $passed = $false
        $testResultMarkdown = 'As configurações da Política de Registro de Dispositivo não foram encontradas na configuração do tenant.'
    }
    else {
        Write-ZtProgress -Activity $activity -Status 'Verificando configuração do LAPS'

        $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_Devices/DevicesMenuBlade/~/DeviceSettings/menuId/Overview'

        $lapsEnabled = ${lapsSettings}?.localAdminPassword?.isEnabled -eq $true
        $lapsStatus = if ($lapsEnabled) { 'Habilitado' } else { 'Desabilitado' }

        $mdInfo = "`n## Configurações da Solução de Senha de Administrador Local (LAPS)`n`n"
        $mdInfo += "| Configuração | Status |`n"
        $mdInfo += "| :---- | :---- |`n"
        $mdInfo += "|[Habilitar Microsoft Entra Local Administrator Password Solution (LAPS)]($portalLink) | $lapsStatus`n"

        if ($lapsEnabled) {
            $passed = $true
            $testResultMarkdown = "A Solução de Senha de Administrador Local (LAPS) está implantada.$mdInfo"
        }
        else {
            $passed = $false
            $testResultMarkdown = "A Solução de Senha de Administrador Local (LAPS) não está implantada.$mdInfo"
        }
    }

    $params = @{
        TestId = '21953'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}