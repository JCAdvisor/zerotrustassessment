<#
.SYNOPSIS
    Verifica se as Scope Tags do Intune estão configuradas para Administração Delegada
#>

function Test-Assessment-24555 {
    [ZtTest(
    	Category = 'Locatário',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24555,
    	Title = 'A configuração de etiquetas de âmbito é aplicada para apoiar a administração delegada e o acesso com o menor privilégio',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Funções Auxiliares
    function Test-PolicyAssignment {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $false)]
            [array]$Policies
        )
        if (-not $Policies) { return $false }
        $assignedPolicies = $Policies | Where-Object {
            $_.PSObject.Properties.Match("assignments") -and $_.assignments -and $_.assignments.Count -gt 0
        }
        return $assignedPolicies.Count -gt 0
    }
    #endregion Funções Auxiliares

    #region Recolha de Dados
    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    $activity = "A verificar as Scope Tags do Intune"
    Write-ZtProgress -Activity $activity -Status "A obter etiquetas"

    $scopeTagsUri = "deviceManagement/roleScopeTags?`$expand=assignments"
    $allScopeTags = Invoke-ZtGraphRequest -RelativeUri $scopeTagsUri -ApiVersion beta
    #endregion Recolha de Dados

    #region Lógica de Avaliação
    $customScopeTags = $allScopeTags | Where-Object { $_.isBuiltIn -eq $false }
    $passed = Test-PolicyAssignment -Policies $customScopeTags
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = ""
    if ($passed) {
        $testResultMarkdown = "✅ Etiquetas de âmbito personalizadas foram encontradas e atribuídas.`n`n"
    }
    else {
        $testResultMarkdown = "❌ Nenhuma etiqueta de âmbito personalizada foi encontrada ou nenhuma está atribuída.`n`n"
    }

    if ($customScopeTags.Count -gt 0) {
        $reportTitle = "Scope Tags do Intune"
        $tableRows = ""
        $formatTemplate = @'

## {0}

| Nome da Etiqueta | Estado | Alvo da Atribuição |
| :------------- | :----- | :----------------- |
{1}

'@

        foreach ($tag in $customScopeTags) {
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/RolesLandingMenuBlade/~/scopeTags'
            $status = if ($tag.assignments.Count -gt 0) { "✅ Atribuída" } else { "❌ Não atribuída" }
            $assignmentTarget = if ($tag.assignments.Count -gt 0) { Get-PolicyAssignmentTarget -Assignments $tag.assignments } else { "Nenhum" }

            $tableRows += "| [$(Get-SafeMarkdown($tag.displayName))]($portalLink) | $status | $assignmentTarget |`n"
        }
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24555'
        Title  = 'Scope Tags do Intune estão configuradas para Administração Delegada'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}