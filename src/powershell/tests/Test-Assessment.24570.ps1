<#
.SYNOPSIS
    O Entra Connect Sync está configurado com credenciais de Service Principal
#>

function Test-Assessment-24570 {
    [ZtTest(
    	Category = 'Infraestrutura híbrida',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 24570,
    	Title = 'O Entra Connect Sync está configurado com credenciais de Service Principal',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    #region Coleta de Dados
    $activity = "Verificando se o Entra Connect Sync está configurado com credenciais de Service Principal"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $dirSyncRoleUri = "directoryRoles?`$filter=roleTemplateId eq 'd29b2b05-8046-44ba-8758-1e26182fcf32'&`$expand=members"
    $dirSyncRole = Invoke-ZtGraphRequest -RelativeUri $dirSyncRoleUri -ApiVersion v1.0
    #endregion Coleta de Dados

    #region Lógica de Avaliação
    $passed = $true
    foreach ($member in $dirSyncRole.value.members) {
        if ($member.'@odata.type' -eq '#microsoft.graph.user') {
            $passed = $false
        }
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = if ($passed) { "✅ O Entra Connect Sync está usando Service Principals para sincronização.`n`n" } else { "❌ Foram encontradas contas de usuário legadas na função de sincronização.`n`n" }
    #endregion Geração de Relatório

    $params = @{
        TestId = '24570'
        Title  = 'O Entra Connect Sync está configurado com credenciais de Service Principal'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}