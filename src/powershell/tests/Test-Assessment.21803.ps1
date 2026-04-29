<#
.SYNOPSIS

#>

function Test-Assessment-21803 {
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21803,
    	Title = 'Migrar das políticas legadas de MFA e SSPR',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = 'Verificando migração de políticas legadas'
    Write-ZtProgress -Activity $activity -Status 'Obtendo política'

    $result = Invoke-ZtGraphRequest -RelativeUri 'policies/authenticationMethodsPolicy' -ApiVersion beta
    
    if ($result.policyMigrationState -eq 'migrationComplete' -or $null -eq $result.policyMigrationState) {
        $passed = $true
        $testResultMarkdown = if ($null -eq $result.policyMigrationState) { "Nenhuma política legada para migrar. Este locatário já usa métodos modernos.`n`n" }
        else { "✅ Migração concluída. O registro combinado está habilitado.`n`n" }
    }
    else {
        $passed = $false
        $testResultMarkdown = "❌ O registro combinado não está habilitado ou a migração está pendente.`n`n"
    }

    Add-ZtTestResultDetail -TestId '21803' -Status $passed -Result $testResultMarkdown
}
