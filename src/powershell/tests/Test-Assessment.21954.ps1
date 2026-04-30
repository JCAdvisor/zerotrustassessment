<#
.SYNOPSIS
    Verifica se usuários não administradores estão restritos de recuperar chaves do BitLocker.
#>

function Test-Assessment-21954{
    [ZtTest(
    	Category = 'Dispositivos',
    	ImplementationCost = 'Low',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'High',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce','External'),
    	TestId = 21954,
    	Title = 'Restringir usuários não administradores de recuperar as chaves do BitLocker para seus dispositivos próprios',
    	UserImpact = 'Low'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = 'Verificando restrição de recuperação de chaves do BitLocker por usuários não administradores'
    Write-ZtProgress -Activity $activity -Status 'Obtendo política de autorização'

    $authPolicy = Invoke-ZtGraphRequest -RelativeUri 'policies/authorizationPolicy' -ApiVersion beta

    $passed = $authPolicy.defaultUserRolePermissions.allowedToReadBitlockerKeysForOwnedDevice -eq $false
    $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_Devices/DevicesMenuBlade/~/DeviceSettings/menuId/Overview'
    $testResultMarkdown = if ($passed) {
        "[Usuários não administradores estão restritos de recuperar chaves do BitLocker para seus dispositivos próprios]($portalLink)"
    } else {
        "[Usuários não administradores podem recuperar chaves do BitLocker para seus dispositivos próprios]($portalLink)"
    }

        $params = @{
        TestId             = '21954'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
