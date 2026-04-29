<#
.SYNOPSIS
#>

function Test-Assessment-21837{
    [ZtTest(
    	Category = 'Dispositivos',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Protect engineering systems',
    	TenantType = ('Workforce'),
    	TestId = 21837,
    	Title = 'Limitar o número máximo de dispositivos por usuário para 10',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando o limite máximo de dispositivos por usuário'
    Write-ZtProgress -Activity $activity -Status 'Obtendo política'

    # Recupera a política de registro de dispositivos
    Write-ZtProgress -Activity $activity -Status 'Recuperando política de registro de dispositivos'
    $policy = Invoke-ZtGraphRequest -RelativeUri 'policies/deviceRegistrationPolicy' -ApiVersion 'beta'
    $userQuota = $null
    if ($policy) { $userQuota = $policy.userDeviceQuota }

    # Avalia a conformidade
    $passed = $false
    $customStatus = $null
    $entraDeviceSettingsLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_Devices/DevicesMenuBlade/~/DeviceSettings/menuId/Overview'

    if ($null -eq $userQuota -or $userQuota -le 10) {
        # O padrão é 10
        $passed = $true
        $testResultMarkdown = "O [número máximo de dispositivos por usuário]($entraDeviceSettingsLink) está definido como $userQuota"
    }
    elseif ($userQuota -gt 10 -and $userQuota -le 20) {
        $customStatus = 'Investigar'
        $testResultMarkdown = "O [número máximo de dispositivos por usuário]($entraDeviceSettingsLink) está definido como $userQuota. Considere reduzir para 10 ou menos."
    }
    else {
        $testResultMarkdown = "O [número máximo de dispositivos por usuário]($entraDeviceSettingsLink) está definido como $userQuota. Considere reduzir para 10 ou menos."
    }

    $params = @{
        TestId = '21837'
        Status = $passed
        Result = $testResultMarkdown
    }

    if ($customStatus) { $params.CustomStatus = $customStatus }
    Add-ZtTestResultDetail @params
}
