<#
.SYNOPSIS
    As políticas de rótulo de sensibilidade são publicadas para os usuários

.DESCRIPTION
    Criar rótulos de sensibilidade é o primeiro passo na implantação de proteção de informações.
    Labels must be published through label policies before users can apply them to content.
    Label policies define which users or groups receive which labels, determine default labeling behavior,
    and enforce mandatory labeling requirements.

.NOTES
    Test ID: 35004
    Pillar: Data
    Risk Level: Low
#>

function Test-Assessment-35004 {
    [ZtTest(
        Category = 'Rótulos de sensibilidade',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Microsoft 365 E3'),
    	Service = ('SecurityCompliance'),
        Pillar = 'Dados',
        RiskLevel = 'Baixo',
        SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce'),
    	TestId = 35004,
        Title = 'As políticas de rótulos de sensibilidade são publicadas para os usuários',
        UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando Políticas de Rótulo Publicadas'
    Write-ZtProgress -Activity $activity -Status 'Obtendo Políticas de Rótulo'

    $policies = @()
    $errorMsg = $null

    try {
            # Consulta: Get all label policies
        $policies = Get-LabelPolicy -WarningAction SilentlyContinue -ErrorAction Stop
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar Políticas de Rótulo: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $enabledPolicies = @()
    $totalUsersGroupsDisplay = "0"
    $customStatus = $null

    if ($errorMsg) {
        $testResultMarkdown = "### Investigate`n`nNão foi possível consultar políticas de rótulo devido a erro: $errorMsg`n`n%TestResult%"
        $customStatus = 'Investigate'
        $passed = $false
    }
    else {
        $enabledPolicies = $policies | Where-Object { $_.Enabled -eq $true }
        $passed = $enabledPolicies.Count -ge 1

        $allUsersTargeted = $false
        $uniqueTargets = New-Object System.Collections.Generic.HashSet[string]

        foreach ($policy in $enabledPolicies) {
            $allLocationNames = @(
                $policy.ExchangeLocation.Name
                $policy.ModernGroupLocation.Name
                $policy.SharePointLocation.Name
                $policy.OneDriveLocation.Name
            ) | Where-Object { $_ }

            if ($allLocationNames -contains 'All') {
                $allUsersTargeted = $true
                break
            }

            if ($policy.ExchangeLocation) {
                foreach ($target in $policy.ExchangeLocation) { $null = $uniqueTargets.Add([string]$target.Name) }
            }
            if ($policy.ModernGroupLocation) {
                foreach ($target in $policy.ModernGroupLocation) { $null = $uniqueTargets.Add([string]$target.Name) }
            }
        }

        $totalUsersGroupsDisplay = if ($allUsersTargeted) { "All Users" } else { $uniqueTargets.Count }

        if ($passed) {
            $testResultMarkdown = "✅ Pelo menos uma política de rótulo habilitada é publicada para os usuários.`n`n%TestResult%"
        }
        else {
            $testResultMarkdown = "❌ Nenhuma política de rótulo habilitada existe ou todas as políticas estão desabilitadas.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''
    $mdInfo += "### Resumo da Política de Rótulo`n`n"
    $mdInfo += "* Total de Políticas Configuradas: $($policies.Count)`n"
    $mdInfo += "* Políticas Habilitadas: $($enabledPolicies.Count)`n"
    $mdInfo += "* Políticas Desabilitadas: $($policies.Count - $enabledPolicies.Count)`n"
    $mdInfo += "* Total de Usuários/Grupos com Acesso a Rótulo: $totalUsersGroupsDisplay`n"

    if ($policies.Count -gt 0) {
        $mdInfo += "`n**Políticas:**`n"
        $mdInfo += "| Nome da política | Habilitado | Rótulos incluíos | Publicado para |`n"
        $mdInfo += "|:---|:---|:---|:---|`n"

        foreach ($policy in $policies) {
            $policyName = Get-SafeMarkdown -Text $policy.Name
            $enabled = if ($policy.Enabled) { "True" } else { "False" }

            # Labels property usually contains the list of label names or GUIDs
            $labelsIncluded = 0
            if ($policy.Labels) {
                $labelsIncluded = ($policy.Labels).Count
            } elseif ($policy.ScopedLabels) {
                $labelsIncluded = ($policy.ScopedLabels).Count
            }

            # Determine publication scope
            $publishedTo = "Specific Users/Groups"
            $allLocationNames = @(
                $policy.ExchangeLocation.Name
                $policy.ModernGroupLocation.Name
                $policy.SharePointLocation.Name
                $policy.OneDriveLocation.Name
            ) | Where-Object { $_ }

            if ($allLocationNames -contains 'All') {
                $publishedTo = "All Users/Groups"
            }

            $mdInfo += "| $policyName | $enabled | $labelsIncluded | $publishedTo |`n"
        }
    }

    $mdInfo += "`n[Gerenciar Políticas de Rótulo no Microsoft Purview](https://purview.microsoft.com/informationprotection/labelpolicies)`n"

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $testResultDetail = @{
        TestId             = '35004'
        Title              = 'Políticas de Rótulo Publicadas'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    if ($null -ne $customStatus) {
        $testResultDetail.CustomStatus = $customStatus
    }

    Add-ZtTestResultDetail @testResultDetail
}
