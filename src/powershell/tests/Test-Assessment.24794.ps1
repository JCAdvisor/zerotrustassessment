<#
.SYNOPSIS

#>

function Test-Assessment-24794 {
    [ZtTest(
    	Category = 'Tenant',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce'),
    	TestId = 24794,
    	Title = 'Políticas de Termos e Condições protegem o acesso a dados sensíveis',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Helper Functions
    function Test-PolicyAssignment {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $false)]
            [array]$Policies
        )

        # Return false if $Policies is null or empty
        if (-not $Policies) {
            return $false
        }

        # Verifica se pelo menos uma política possui atribuições
        # Verificar se pelo menos uma política possui atribuições
        $assignedPolicies = $Policies | Where-Object {
            $_.PSObject.Properties.Match("assignments") -and $_.assignments -and $_.assignments.Count -gt 0
        }

        return $assignedPolicies.Count -gt 0
    }

    #endregion Helper Functions

    #region Coleta de Dados
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    $activity = "Verificando se a política de Termos e Condições do Intune está configurada e atribuída"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    # Recuperar todas as políticas de Termos e Condições configuradas no Intune
    $termsAndConditionsUri = "deviceManagement/termsAndConditions"
    $termsAndConditionsPolicies = @(Invoke-ZtGraphRequest -RelativeUri $termsAndConditionsUri -ApiVersion 'beta')

    # Inicializar como array vazio para evitar problemas com variável não inicializada
    $termsAndConditionsPoliciesWithAssignments = @()

    # Verificar se pelo menos uma política de Termos e Condições existe
    if ($termsAndConditionsPolicies.Count -gt 0) {
        Write-ZtProgress -Activity $activity -Status "Verificando atribuições de política"

        # Para cada política de Termos e Condições, recuperar suas atribuições
        foreach ($policy in $termsAndConditionsPolicies) {
            $assignmentsUri = "deviceManagement/termsAndConditions/$($policy.id)/assignments"

            $assignments = @(Invoke-ZtGraphRequest -RelativeUri $assignmentsUri -ApiVersion 'beta')

            $termsAndConditionsPolicyWithAssignments = $null

            if ($assignments -and $assignments.Count -gt 0) {
                $isAssigned = $true
            }
            else {
                $isAssigned = $false
            }

            # Adicionar informações de atribuição ao objeto da política de Termos e Condições
            $termsAndConditionsPolicyWithAssignments = $policy |
                Add-Member -NotePropertyName 'assignments' -NotePropertyValue $assignments -Force -PassThru |
                    Add-Member -NotePropertyName 'isAssigned' -NotePropertyValue $isAssigned -Force -PassThru

            $termsAndConditionsPoliciesWithAssignments += $termsAndConditionsPolicyWithAssignments
        }
    }

    #endregion Coleta de Dados

    #region Lógica de Avaliação
    $passed = $false
    $testResultMarkdown = ""

    # Testar atribuições de políticas de Termos e Condições
    $passed = Test-PolicyAssignment -Policies $termsAndConditionsPoliciesWithAssignments

    if ($passed) {
        $testResultMarkdown = "Pelo menos uma política de Termos e Condições existe e está atribuída.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "Nenhuma política de Termos e Condições existe ou nenhuma está atribuída.`n`n%TestResult%"
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    # Construir as seções detalhadas do markdown

    # Definir variáveis para inserir na string de formato
    $reportTitle = "Políticas de Termos e Condições"
    $tableRows = ""

    if ($termsAndConditionsPolicies.Count -gt 0) {
        # Criar uma here-string com placeholders de formatação {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Política | Status | Alvo de Atribuição |
| :---------- | :----- | :---------------- |
{1}

'@

        foreach ($termsAndConditionsPolicyWithAssignments in $termsAndConditionsPoliciesWithAssignments) {

            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/TenantAdminMenu/~/termsAndConditions'

            $status = if ($termsAndConditionsPolicyWithAssignments.isAssigned) {
                "✅ Atribuída"
            }
            else {
                "❌ Não atribuída"
            }

            $assignmentTarget = "Nenhuma"

            if ($termsAndConditionsPolicyWithAssignments.assignments -and $termsAndConditionsPolicyWithAssignments.assignments.Count -gt 0) {
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $termsAndConditionsPolicyWithAssignments.assignments
            }

$tableRows += @"
| [$(Get-SafeMarkdown($termsAndConditionsPolicyWithAssignments.displayName))]($portalLink) | $status | $assignmentTarget |`n
"@
        }

        # Formatar o template substituindo os placeholders pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24794'
        Title  = 'A política de Termos e Condições do Intune está configurada e atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
