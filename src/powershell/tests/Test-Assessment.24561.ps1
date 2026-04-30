<#
.SYNOPSIS
    Uma política de LAPS na nuvem para macOS foi criada e atribuída
#>

function Test-Assessment-24561 {
    [ZtTest(
    	Category = 'Dispositivo',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 24561,
    	Title = 'Credenciais de administrador local no macOS são protegidas durante o registro pelo LAPS para macOS',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    #region Coleta de Dados
    $activity = "Verificando se uma política de LAPS na nuvem para macOS foi criada e atribuída"
    Write-ZtProgress -Activity $activity -Status "Obtendo tokens DEP"

    # Recuperar todos os Tokens do Programa de Registro do macOS
    $depTokensUri = "deviceManagement/depOnboardingSettings?`$expand=enrollmentProfiles&`$select=id,appleIdentifier,tokenName"
    $depTokens = Invoke-ZtGraphRequest -RelativeUri $depTokensUri -ApiVersion beta

    $profilesWithLAPS = @()
    #endregion Coleta de Dados

    #region Lógica de Avaliação
    $passed = $false
    if ($depTokens -and $depTokens.Count -gt 0) {
        foreach ($token in $depTokens) {
            foreach ($profile in $token.enrollmentProfiles) {
                $hasLAPS = $null -ne $profile.adminAccountUserName -and $profile.adminAccountUserName -ne ""
                if ($hasLAPS) {
                    $passed = $true
                }
                $profilesWithLAPS += [PSCustomObject]@{
                    TokenName            = $token.tokenName
                    ProfileName          = $profile.displayName
                    HasLAPS              = $hasLAPS
                    AdminAccountUserName = $profile.adminAccountUserName
                }
            }
        }
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = ""
    if ($passed) {
        $testResultMarkdown = "✅ O LAPS para macOS está configurado em pelo menos um perfil de registro.`n`n"
    }
    else {
        $testResultMarkdown = "❌ O LAPS para macOS não está configurado em nenhum perfil de registro.`n`n"
    }

    $mdInfo = ""
    if ($profilesWithLAPS.Count -gt 0) {
        $reportTitle = "Perfis de Registro com LAPS para macOS"
        $tableRows = ""
        $formatTemplate = @'

## {0}

| Nome do Token | Nome do Perfil | Conta de Admin | LAPS Ativo |
| :---------- | :---------- | :------------- | :--------- |
{1}

'@
        foreach ($profileData in $profilesWithLAPS) {
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_Enrollment/DepTokensPaging.ReactView'
            $adminStatus = if ($profileData.HasLAPS) { "✅ Ativado ($($profileData.AdminAccountUserName))" } else { "❌ Desativado" }
            $tableRows += "| [$(Get-SafeMarkdown -Text $profileData.TokenName)]($portalLink) | $($profileData.ProfileName) | $($profileData.AdminAccountUserName) | $adminStatus |`n"
        }
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24561'
        Title  = 'Uma Política de LAPS na Nuvem para macOS foi Criada e Atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}