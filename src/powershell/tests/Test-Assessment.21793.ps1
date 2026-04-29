<#
.SYNOPSIS

#>

function Test-Assessment-21793 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce','External'),
    	TestId = 21793,
    	Title = 'A política de Restrições de Locatário v2 está configurada',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando se as Restrições de Locatário v2 estão configuradas"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    if((Get-MgContext).Environment -ne 'Global')
    {
        Write-PSFMessage "Este teste é aplicável apenas ao ambiente Global." -Tag Test -Level VeryVerbose
        return
    }

    $crossTenantAccessPolicy = Invoke-ZtGraphRequest -RelativeUri 'policies/crossTenantAccessPolicy' -ApiVersion v1.0
    $guid = [System.Guid]::Empty
    $isGuid = [System.Guid]::TryParse($crossTenantAccessPolicy.id, [ref]$guid)

    if ($isGuid) {
        $defaultCrossTenantAccessPolicy = Invoke-ZtGraphRequest -RelativeUri 'policies/crossTenantAccessPolicy/default' -ApiVersion v1.0
        $result = $defaultCrossTenantAccessPolicy.tenantRestrictions
    }

    $passed = $null -ne $result

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: A política de Restrições de Locatário v2 foi encontrada.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ **Falha**: Nenhuma política de Restrições de Locatário v2 foi encontrada.`n`n"
    }

    $reportTitle = "Configuração de Restrições de Locatário v2"
    $tableRows = ""

    if ($passed) {
        $formatTemplate = @'
## {0}

| Configurado | Usuários e Grupos Alvo | Aplicativos Alvo |
| :---------- | :--------------------- | :--------------- |
{1}
'@
        $configured = "Sim"
        $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/TenantRestrictions.ReactView/isDefault~/true/name//id/'

        $targetUsersAndGroup = if ($result.usersAndGroups.targets -and $result.usersAndGroups.targets[0].target -eq 'AllUsers') { "Todos os usuários e grupos externos" }
        else { ($result.usersAndGroups.targets | ForEach-Object { $_.target }) -join ', ' }

        $targetApplications = if ($result.applications.targets -and $result.applications.targets[0].target -eq 'AllApplications') { "Todos os aplicativos externos" }
        else { ($result.applications.targets | ForEach-Object { $_.target }) -join ', ' }

        $tableRows += "| [$($configured)]($portalLink) | $targetUsersAndGroup | $targetApplications |`n"
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    Add-ZtTestResultDetail -TestId '21793' -Status $passed -Result $testResultMarkdown
}
