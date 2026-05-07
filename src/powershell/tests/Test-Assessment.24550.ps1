<#
.SYNOPSIS

#>

function Test-Assessment-24550 {
    [ZtTest(
        Category = 'Dispositivos',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Intune'),
        Pillar = 'Dispositivos',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger identidades e segredos',
        TenantType = ('Workforce'),
        TestId = 24550,
        Title = 'Dados no Windows estão protegidos pela criptografia do BitLocker',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    #region Funções Auxiliares
    function Test-PolicyAssignment {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $false)]
            [array]$Policies
        )

        # Retornar falso se $Policies for nulo ou vazio
        if (-not $Policies) {
            return $false
        }

        # Verificar se pelo menos uma política tem atribuições
        $assignedPolicies = $Policies | Where-Object {
            $_.PSObject.Properties.Match("assignments") -and $_.assignments -and $_.assignments.Count -gt 0
        }

        return $assignedPolicies.Count -gt 0
    }
    #endregion Funções Auxiliares

    #region Recolha de Dados
    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if ( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    $activity = "A verificar se a política BitLocker do Windows está configurada e atribuída"
    Write-ZtProgress -Activity $activity -Status "A obter política"

    # Consulta 1: Obter todas as políticas de configuração BitLocker para Windows e as suas atribuições
    $sql = @"
    SELECT id, name, description, templateReference, to_json(assignments) as assignments
    FROM ConfigurationPolicy
    WHERE templateReference IS NOT NULL
      AND templateReference.templateFamily = 'endpointSecurityDiskEncryption'
"@
    $windowsBitLockerPolicies = Invoke-DatabaseQuery -Database $Database -Sql $sql -AsCustomObject

    # Processar campo de atribuições JSON
    foreach ($policy in $windowsBitLockerPolicies) {
        if ($policy.assignments -is [string]) {
            $policy.assignments = $policy.assignments | ConvertFrom-Json
        }
    }
    #endregion Recolha de Dados

    #region Lógica de Avaliação
    $passed = Test-PolicyAssignment -Policies $windowsBitLockerPolicies
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $passed = $passed
    $testResultMarkdown = ""

    if ($passed) {
        $testResultMarkdown = "✅ As políticas BitLocker para Windows foram encontradas e atribuídas.`n`n"
    }
    else {
        $testResultMarkdown = "❌ Nenhuma política BitLocker para Windows foi encontrada ou nenhuma está atribuída.`n`n"
    }

    # Gerar informações detalhadas se as políticas existirem
    $reportTitle = "Políticas BitLocker do Windows"
    $tableRows = ""
    $mdInfo = ""

    if ($windowsBitLockerPolicies.Count -gt 0) {
        # Criar uma here-string com marcadores de formato {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Política | Estado | Alvo da Atribuição |
| :---------- | :----- | :---------------- |
{1}

'@

        foreach ($policy in $windowsBitLockerPolicies) {

            $policyName = Get-SafeMarkdown -Text $policy.name
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/configuration'

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $status = "✅ Atribuída"
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }
            else {
                $status = "❌ Não atribuída"
                $assignmentTarget = 'Nenhum'
            }

            $tableRows += "| [$policyName]($portalLink) | $status | $assignmentTarget |`n"
        }

        # Formatar o modelo substituindo os marcadores pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    # Substituir o marcador pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24550'
        Title  = 'A política BitLocker do Windows está configurada e atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
