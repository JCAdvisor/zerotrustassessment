<#
.SYNOPSIS
    Testa se a Política de Firewall do macOS está criada e atribuída
#>

function Test-Assessment-24552 {
    [ZtTest(
        Category = 'Dispositivos',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Intune'),
        Pillar = 'Dispositivos',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 24552,
        Title = 'Políticas de Firewall do macOS protegem contra acesso não autorizado à rede',
        UserImpact = 'Alto'
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

        if (-not $Policies) {
            return $false
        }

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

    $activity = "A verificar se a Política de Firewall do macOS está Criada e Atribuída"
    Write-ZtProgress -Activity $activity -Status "A obter política"

    $sql = @"
    SELECT id, name, description, templateReference, to_json(assignments) as assignments, to_json(settings) as settings
    FROM ConfigurationPolicy
    WHERE templateReference IS NOT NULL
      AND templateReference.templateFamily = 'endpointSecurityFirewall'
      AND platforms LIKE '%macOS%'
"@
    $macOSFirewallPolicies = Invoke-DatabaseQuery -Database $Database -Sql $sql -AsCustomObject

    foreach ($policy in $macOSFirewallPolicies) {
        if ($policy.assignments -is [string]) {
            $policy.assignments = $policy.assignments | ConvertFrom-Json
        }
        if ($policy.settings -is [string]) {
            $policy.settings = $policy.settings | ConvertFrom-Json
        }
    }
    #endregion Recolha de Dados

    #region Lógica de Avaliação
    $passed = Test-PolicyAssignment -Policies $macOSFirewallPolicies
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = ""
    if ($passed) {
        $testResultMarkdown = "✅ As políticas de Firewall do macOS foram encontradas e atribuídas.`n`n"
    }
    else {
        $testResultMarkdown = "❌ Nenhuma política de Firewall do macOS foi encontrada ou nenhuma está atribuída.`n`n"
    }

    if ($macOSFirewallPolicies.Count -gt 0) {
        $reportTitle = "Políticas de Firewall do macOS"
        $tableRows = ""
        $formatTemplate = @'

## {0}

| Nome da Política | Estado | Alvo da Atribuição | Definições de Firewall |
| :---------- | :----- | :----------------- | :----------------- |
{1}

'@

        foreach ($policy in $macOSFirewallPolicies) {
            $policyName = Get-SafeMarkdown -Text $policy.name
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/configuration'

            if ($policy.assignments -and $policy.assignments.Count -gt 0) {
                $status = '✅ Atribuída'
                $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $policy.assignments
            }
            else {
                $status = '❌ Não atribuída'
                $assignmentTarget = 'Nenhum'
            }

            $firewallSettings = '❌ Desativado'
            if ($policy.settings.value -contains 'true') {
                 $firewallSettings = '✅ Ativado'
            }

            $tableRows += "| [$policyName]($portalLink) | $status | $assignmentTarget | $firewallSettings |`n"
        }

        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24552'
        Title  = 'macOS - A política de Firewall está criada e atribuída'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
