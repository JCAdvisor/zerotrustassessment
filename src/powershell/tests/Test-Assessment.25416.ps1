<#
.SYNOPSIS
    O tráfego de internet do escritório de filial é protegido por políticas de Cloud Firewall através do Global Secure Access

.DESCRIPTION
    Avalia se o tráfego de internet do escritório de filial é protegido por políticas de firewall em nuvem por meio do Global Secure Access.
    Sem políticas de firewall em nuvem impostas no tráfego de rede remota, o tráfego de internet do escritório de filial flui através
    do Global Secure Access sem filtragem de saída, expondo a organização a exfiltração de dados, comunicações de comando e controle
    e conexões de saída maliciosas de ativos de filial comprometidos.

.NOTES
    Test ID: 25416
    Pillar: Network
    Risk Level: High
    SFI Pillar: Protect networks
#>

function Test-Assessment-25416 {
    [ZtTest(
    	Category = 'Acesso Seguro Global',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Entra_Premium_Internet_Access'),
    	CompatibleLicense = ('Entra_Premium_Internet_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce','External'),
    	TestId = 25416,
    	Title = 'O firewall de nuvem do Acesso Seguro Global protege o tráfego de internet das filiais',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    # Define constants
    [int]$BASELINE_PROFILE_PRIORITY = 65000

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando se o tráfego de internet do escritório de filial é protegido por políticas de Cloud Firewall por meio do Global Secure Access'
    Write-ZtProgress -Activity $activity -Status 'Consultando redes remotas'

    # Q1: Get all configured remote networks (branch sites)
    $remoteNetworks = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/connectivity/branches' -ApiVersion beta

    $remoteNetworkCount = if ($remoteNetworks) { $remoteNetworks.Count } else { 0 }

    # If Q1 returns no remote networks → Skipped
    if ($remoteNetworkCount -eq 0) {
        Write-PSFMessage 'No remote networks are configured. Cloud Firewall policies for remote networks are not applicable.' -Tag Test -Level Verbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable
        return
    }

    # Q2: Get filtering profiles with cloud firewall policy links
    $baselineProfileWithCloudFirewall = @()
    Write-ZtProgress -Activity $activity -Status 'Consultando perfil de segurança de linha de base'
    $filteringProfiles = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/filteringProfiles' -QueryParameters @{
        '$select' = 'id,name,description,state,version,priority'
        '$expand' = 'policies($select=id,state;$expand=policy)'
    } -ApiVersion beta

    if ($filteringProfiles -and $remoteNetworkCount -gt 0) {
        $baselineProfile = $filteringProfiles | Where-Object { $_.priority -eq $BASELINE_PROFILE_PRIORITY }

        if ($null -ne $baselineProfile -and $null -ne $baselineProfile.policies) {

            # Check if baseline profile has enabled cloud firewall policy links
            $enabledCloudFirewallPolicies = @()
            $policyLinks = $baselineProfile.policies | Where-Object { $_.'@odata.type' -eq '#microsoft.graph.networkAccess.cloudFirewallPolicyLink' }

            # Iterate over each cloud firewall policy link
            foreach ($policyLink in $policyLinks) {
                # Q3: Retrieve the actual cloud firewall policy rules using policy.id
                $policyId = if ($policyLink.policy) {
                    $policyLink.policy.id
                }
                else {
                    $null
                }
                $policyRulesData = @()
                $enabledRulesCount = 0

                if ($policyId) {
                    $policyDisplayName = if ($policyLink.policy.name) {
                        $policyLink.policy.name
                    }
                    else {
                        'Unknown'
                    }
                    Write-ZtProgress -Activity $activity -Status "Retrieving policy rules for $policyDisplayName"
                    try {
                        # Q3: GET https://graph.microsoft.com/beta/networkAccess/cloudfirewallpolicies/{policyId}?$expand=policyRules
                        $policyWithRules = Invoke-ZtGraphRequest -RelativeUri "networkAccess/cloudfirewallpolicies/$policyId" -QueryParameters @{
                            '$expand' = 'policyRules'
                        } -ApiVersion beta

                        if ($policyWithRules -and $policyWithRules.policyRules) {
                            $policyRulesData = $policyWithRules.policyRules
                            # Count enabled rules where settings.status = 'enabled'
                            $enabledRulesCount = ($policyRulesData | Where-Object { $_.settings.status -eq 'enabled' }).Count
                        }
                    }
                    catch {
                        Write-PSFMessage "Error retrieving policy rules for policy $policyId`: $_" -Tag Test -Level Warning
                    }
                }

                $enabledCloudFirewallPolicies += [PSCustomObject]@{
                    PolicyLinkId      = $policyLink.id
                    PolicyLinkState   = $policyLink.state
                    PolicyId          = $policyId
                    PolicyName        = if ($policyLink.policy) {
                        $policyLink.policy.name
                    }
                    else {
                        'Unknown'
                    }
                    PolicyRules       = $policyRulesData
                    TotalRulesCount   = $policyRulesData.Count
                    EnabledRulesCount = $enabledRulesCount
                }
            }


            if ($enabledCloudFirewallPolicies.Count -gt 0) {
                # Create an array with one object per cloud firewall policy
                foreach ($cloudFirewallPolicy in $enabledCloudFirewallPolicies) {
                    $baselineProfileWithCloudFirewall += [PSCustomObject]@{
                        ProfileId         = $baselineProfile.id
                        ProfileName       = $baselineProfile.name
                        ProfileState      = $baselineProfile.state
                        ProfilePriority   = $baselineProfile.priority
                        PolicyLinkId      = $cloudFirewallPolicy.PolicyLinkId
                        PolicyLinkState   = $cloudFirewallPolicy.PolicyLinkState
                        PolicyId          = $cloudFirewallPolicy.PolicyId
                        PolicyName        = $cloudFirewallPolicy.PolicyName
                        PolicyRules       = $cloudFirewallPolicy.PolicyRules
                        TotalRulesCount   = $cloudFirewallPolicy.TotalRulesCount
                        EnabledRulesCount = $cloudFirewallPolicy.EnabledRulesCount
                    }
                }
            }

        }
    }
    #endregion Data Collection

    #region Assessment Logic


    $passed = $false

    # If Q2 baseline profile has no linked cloud firewall policies OR all linked cloud firewall policies have state="disabled" → Fail
    if ($baselineProfileWithCloudFirewall.Count -eq 0) {
        $passed = $false
    }
    else {
        # Check if at least one policy has state="enabled"
        $enabledPolicies = $baselineProfileWithCloudFirewall | Where-Object { $_.PolicyLinkState -eq 'enabled' }

        if ($enabledPolicies.Count -eq 0) {
            # All linked cloud firewall policies have state="disabled" → Fail
            $passed = $false
        }
        else {
            # Check Q3: If no rules OR all rules have settings.status="disabled" → Fail
            # If at least one enabled policy has at least one enabled rule → Pass
            $hasEnabledRules = ($enabledPolicies | Where-Object { $_.EnabledRulesCount -gt 0 }).Count -gt 0
            $passed = $hasEnabledRules
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($passed) {
        $testResultMarkdown = "✅ O Cloud Firewall está habilitado e configurado para redes remotas. O tráfego de internet das filiais é protegido por políticas de firewall por meio do perfil de segurança de linha de base.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ O Cloud Firewall não está configurado corretamente para redes remotas. O tráfego de internet da rede remota não está protegido por políticas de cloud firewall.`n`n%TestResult%"
    }

    # Build remote network table rows
    $remoteNetworkTableRows = ''
    $totalEnabledRulesCount = 0
    $enabledPoliciesCount = 0

    if ($baselineProfileWithCloudFirewall.Count -gt 0) {
        $totalEnabledRulesCount = ($baselineProfileWithCloudFirewall | Measure-Object -Property EnabledRulesCount -Sum).Sum
        $enabledPoliciesCount = ($baselineProfileWithCloudFirewall | Where-Object { $_.PolicyLinkState -eq 'enabled' }).Count
    }

    foreach ($network in $remoteNetworks | Sort-Object -Property name) {
        $networkName = Get-SafeMarkdown -Text $network.name
        $encodedNetworkName = [System.Uri]::EscapeDataString($network.name)
        $networkPortalLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditBranchMenuBlade.MenuView/~/basics/branchId/$($network.id)/title/$encodedNetworkName/defaultMenuItemId/Basics"
        $policyLinked = if ($baselineProfileWithCloudFirewall.Count -gt 0) {
            'Sim'
        }
        else {
            'Não'
        }
        $policyState = if ($enabledPoliciesCount -gt 0) {
            '✅ Habilitado'
        }
        elseif ($baselineProfileWithCloudFirewall.Count -gt 0) {
            '❌ Desabilitado'
        }
        else {
            'N/A'
        }
        $rulesCount = if ($baselineProfileWithCloudFirewall.Count -gt 0) {
            $totalEnabledRulesCount
        }
        else {
            0
        }

        $remoteNetworkTableRows += "| [$networkName]($networkPortalLink) | $policyLinked | $policyState | $rulesCount |`n"
    }

    $remoteNetworkTemplate = @"

## Configuração do Cloud Firewall para Redes Remotas

| Nome da rede remota | Política do perfil de linha de base vinculada | Estado da política | Regras configuradas |
| :--- | :--- | :--- | :--- |
{0}
"@
    $mdInfo += $remoteNetworkTemplate -f $remoteNetworkTableRows

    # Build baseline profile table
    if ($baselineProfileWithCloudFirewall.Count -gt 0) {
        $baselineProfileTableRows = ''

        foreach ($policyEntry in $baselineProfileWithCloudFirewall) {
            $profileName = Get-SafeMarkdown -Text $policyEntry.ProfileName
            $profilePriority = $policyEntry.ProfilePriority
            $policyName = Get-SafeMarkdown -Text $policyEntry.PolicyName
            $policyState = if ($policyEntry.PolicyLinkState -eq 'enabled') {
                '✅ Habilitado'
            }
            else {
                '❌ Desabilitado'
            }
            $enabledRulesCount = $policyEntry.EnabledRulesCount

            $baselineProfileTableRows += "| $profileName | $profilePriority | $policyName | $policyState | $enabledRulesCount |`n"
        }

        $baselineProfileTemplate = @"

## Detalhes do Perfil de Linha de Base

| Nome do perfil | Prioridade | Nome da política vinculada | Estado da política | Qtd. de regras habilitadas |
| :--- | :--- | :--- | :--- | :--- |
{0}
"@
        $mdInfo += $baselineProfileTemplate -f $baselineProfileTableRows
    }
    else {
        $mdInfo += "`n## Detalhes do Perfil de Linha de Base`n`nNenhum perfil de linha de base com políticas de cloud firewall configurado.`n"
    }

    $mdInfo += "`n**Total de redes remotas:** $remoteNetworkCount`n"

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25416'
        Title  = 'O tráfego de internet das filiais é protegido por políticas de Firewall de Nuvem pelo Acesso Seguro Global'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
