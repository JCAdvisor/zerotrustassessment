<#
.SYNOPSIS
    Avaliação 21892 – Verifica se toda a atividade de logon está restrita a dispositivos gerenciados.
#>

function Test-Assessment-21892 {
    [ZtTest(
        Category = 'Controle de acesso',
        ImplementationCost = 'Alto',
        MinimumLicense = ('P1'),
        Pillar = 'Identidade',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger identidades e segredos',
        TenantType = ('Workforce', 'External'),
        TestId = 21892,
        Title = 'Toda a atividade de logon provém de dispositivos gerenciados',
        UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

        $activity = 'Verificando se toda a atividade de logon provém de dispositivos gerenciados'
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de Acesso Condicional'

    # Get all enabled Conditional Access policies
    $policies = Invoke-ZtGraphRequest -RelativeUri "identity/conditionalAccess/policies" -ApiVersion v1.0

    $matchingPolicies = @()

    foreach ($policy in $policies) {
        $appliesToAllUsers = ($policy.conditions.users.includeUsers -contains "All")
        $appliesToAllApps = ($policy.conditions.applications.includeApplications -contains "All")
        $compliantDevice = ($policy.grantControls.builtInControls -contains "compliantDevice")
        $hybridJoinedDevice = ($policy.grantControls.builtInControls -contains "domainJoinedDevice")
        $enabled = $policy.state -eq "enabled"

        if ($compliantDevice -or $hybridJoinedDevice) {
            $status = $enabled -and $appliesToAllUsers -and $appliesToAllApps -and ($compliantDevice -or $hybridJoinedDevice)
            $detail = [PSCustomObject]@{
                PolicyId           = $policy.id
                PolicyState        = $policy.state
                DisplayName        = $policy.displayName
                AllUsers           = $appliesToAllUsers
                AllApps            = $appliesToAllApps
                CompliantDevice    = $compliantDevice
                HybridJoinedDevice = $hybridJoinedDevice
                Status             = $status
            }
            $matchingPolicies += $detail
        }
    }

    $passed = ($matchingPolicies.where{ $_.Status -eq $true } | Measure-Object).Count -gt 0

    $testResultMarkdown = ""
    if ($passed) {
        $testResultMarkdown += "✅ Toda a atividade de logon provém de dispositivos gerenciados.`n"
    }
    else {
        $testResultMarkdown += "❌ Nem toda a atividade de logon provém de dispositivos gerenciados.`n"
    }

    if ( -not $matchingPolicies) {
        $testResultMarkdown += "`nNenhuma política de Acesso Condicional foi encontrada que exija um dispositivo em conformidade ou um dispositivo ingressado híbrido. Isso significa que a atividade de logon não está restrita a dispositivos gerenciados.`n"
    }
    else {
        $testResultMarkdown += "`n### Resumo das políticas de Acesso Condicional para dispositivos gerenciados`n"
        $testResultMarkdown += "`nA tabela abaixo lista todas as políticas de Acesso Condicional que exigem um dispositivo em conformidade ou um dispositivo ingressado híbrido.`n"

        $testResultMarkdown += "| Nome | Todos os usuários | Todos os aplicativos | Dispositivo em conformidade | Dispositivo ingressado híbrido | Estado da política | Status |`n"
        $testResultMarkdown += "| :--- | :---:  | :---: | :---: | :---: | :--- | :--- |`n"

        $matchingPolicies = $matchingPolicies | Sort-Object -Property @{ Expression = { -not $_.Status } }, DisplayName

        foreach ($item in $matchingPolicies) {
            $status = Get-ZtPassFail -Condition $item.Status -IncludeText
            $policyState = Get-ZtCaPolicyState -State $item.PolicyState
            $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/$($item.PolicyId)"
            $testResultMarkdown += "| [$(Get-SafeMarkdown $item.DisplayName)]($portalLink) | $(Get-ZtPassFail $item.AllUsers -EmojiType 'Bubble') | $(Get-ZtPassFail $item.AllApps -EmojiType 'Bubble') | $(Get-ZtPassFail $item.CompliantDevice -EmojiType 'Bubble') | $(Get-ZtPassFail $item.HybridJoinedDevice -EmojiType 'Bubble') | $policyState | $status |`n"
        }
    }

    $testResultParams = @{
        TestId = '21892'
        Title  = 'Toda a atividade de logon provém de dispositivos gerenciados'
        Status = $passed
        Result = $testResultMarkdown
    }
    Add-ZtTestResultDetail @testResultParams
}
