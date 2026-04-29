<#
.SYNOPSIS
#>

function Test-Assessment-21841{
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce','External'),
    	TestId = 21841,
    	Title = 'Configuração de relatar atividade suspeita no app Microsoft Authenticator está ativada',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se relatar atividade suspeita no app Authenticator está ativado"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $authMethodPolicy = Invoke-ZtGraphRequest -RelativeUri "policies/authenticationMethodsPolicy" -ApiVersion 'beta'

    $result = $false
    $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/AuthenticationMethodsMenuBlade/~/AuthMethodsSettings'

    if($authMethodPolicy -and $authMethodPolicy.PSObject.Properties['reportSuspiciousActivitySettings']) {
        $reportSettings = $authMethodPolicy.reportSuspiciousActivitySettings
        $stateEnabled = $reportSettings.state -eq "enabled"
        
        $targetAllUsers = $false
        if($reportSettings.includeTarget) {
            $targetAllUsers = $reportSettings.includeTarget.id -eq "all_users"
        }

        if($stateEnabled -and $targetAllUsers) {
            $result = $true
            $testResultMarkdown = "O recurso de relatar atividade suspeita no app Authenticator está [ativado para todos os usuários]($portalLink)."
        }
        else {
            if(-not $stateEnabled) {
                $testResultMarkdown = "O recurso de relatar atividade suspeita no app Authenticator [não está ativado]($portalLink)."
            }
            elseif(-not $targetAllUsers) {
                $testResultMarkdown = "O recurso de relatar atividade suspeita no app Authenticator [não está configurado para todos os usuários]($portalLink)."
            }
        }
    }
    else {
        $testResultMarkdown = "O recurso de relatar atividade suspeita no app Authenticator [não está ativado]($portalLink)."
    }

    $passed = $result

    $params = @{
        TestId             = '21841'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
