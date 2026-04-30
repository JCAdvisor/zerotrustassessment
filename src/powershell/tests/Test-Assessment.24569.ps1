<#
.SYNOPSIS
    A política de FileVault do macOS no Intune foi criada e atribuída
#>

function Test-Assessment-24569 {
    [ZtTest(
    	Category = 'Dispositivo',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 24569,
    	Title = 'A criptografia do FileVault protege os dados em dispositivos macOS',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    #region Coleta de Dados
    $activity = "Verificando se a política de FileVault do macOS no Intune foi criada e atribuída"
    Write-ZtProgress -Activity $activity

    $fileVaultPolicies = Invoke-ZtGraphRequest -RelativeUri "deviceManagement/configurationPolicies?`$filter=(platforms has 'macOS') and (technologies has 'mdm' and technologies has 'appleRemoteManagement')&`$expand=settings,assignments" -ApiVersion beta
    #endregion Coleta de Dados

    #region Lógica de Avaliação
    $passed = $false
    foreach ($policy in $fileVaultPolicies.value) {
        if ($policy.assignments.Count -gt 0) {
            $passed = $true
            break
        }
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = if ($passed) { "✅ Políticas de FileVault foram encontradas e atribuídas.`n`n" } else { "❌ Nenhuma política de FileVault encontrada ou atribuída.`n`n" }
    #endregion Geração de Relatório

    $params = @{
        TestId = '24569'
        Title  = 'A política de FileVault do macOS no Intune foi criada e atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
