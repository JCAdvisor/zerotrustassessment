<#
.SYNOPSIS
    Valida se as políticas de filtragem de conteúdo da web estão configuradas e aplicadas no Global Secure Access.

.DESCRIPTION
    Este teste verifica se as políticas de filtragem de conteúdo da web existem e estão adequadamente vinculadas a perfis de segurança
    que são atribuídos a políticas do Conditional Access ou configurados no Perfil de Linha de Base, que
    se aplica a todo o tráfego de internet. A filtragem de conteúdo da web fornece proteção contra sites maliciosos,
    sites de phishing e categorias de conteúdo inadequado na borda da rede.

.NOTES
    Test ID: 25410
    Category: Global Secure Access
    Pillar: Network
    Required API: networkAccess/filteringPolicies (beta), networkAccess/filteringProfiles (beta)
#>

function Test-Assessment-25410 {
    [ZtTest(
    	Category = 'Global Secure Access',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Entra_Premium_Internet_Access'),
    	CompatibleLicense = ('Entra_Premium_Internet_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce','External'),
    	TestId = 25410,
    	Title = 'As políticas de filtragem de conteúdo web estão vinculadas a perfis de segurança',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    # Define constants
    [int]$BASELINE_PROFILE_PRIORITY = 65000

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando filtragem de conteúdo da web do Global Secure Access'
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de filtragem'

        # Consulta Q1: List all web content filtering policies
    $filteringPolicies = $null
    $errorMsg = $null
    try {
        $filteringPolicies = Invoke-ZtGraphRequest `
            -RelativeUri 'networkAccess/filteringPolicies?$expand=policyRules' `
            -ApiVersion beta `
            -ErrorAction Stop
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Falha ao obter políticas de filtragem: $_" -Tag Test -Level Warning
    }

    Write-ZtProgress -Activity $activity -Status 'Obtendo perfis de segurança'

        # Consulta Q2: List all security profiles with linked policies and CA policies
    $securityProfiles = $null
    try {
        $securityProfiles = Invoke-ZtGraphRequest `
            -RelativeUri 'networkAccess/filteringProfiles?$expand=policies($expand=policy),conditionalAccessPolicies' `
            -ApiVersion beta `
            -ErrorAction Stop
    }
    catch {
        if (-not $errorMsg) {
            $errorMsg = $_
        }
        Write-PSFMessage "Falha ao obter perfis de segurança: $_" -Tag Test -Level Warning
    }

    # Extract values
    $policies = if ($filteringPolicies) { $filteringPolicies } else { @() }
    $profiles = if ($securityProfiles) { $securityProfiles } else { @() }

    # Collect all filtering policy IDs for use in assessment and reporting
    $q1PolicyIds = @($policies | ForEach-Object { $_.id })
    #endregion Data Collection

    #region Assessment Logic
    $passed = $false
    $customStatus = $null
    $testResultMarkdown = ''

    # Check if API calls failed
    if ($errorMsg) {
        # Investigate: Cannot query API
        $passed = $false
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ Não foi possível determinar o status da filtragem de conteúdo web devido a falha na conexão com a API ou permissões insuficientes.`n`n%TestResult%"
    }
    # Check if both policies and profiles exist
    elseif ($policies.Count -gt 0 -and $profiles.Count -gt 0) {
        # Find Baseline Profile (priority = 65000)
        $baselineProfile = $profiles | Where-Object { $_.priority -eq $BASELINE_PROFILE_PRIORITY }

        # Check Condition B: Baseline Profile has filtering policy linked
        $baselineHasWCF = $false
        if ($baselineProfile) {
            $filteringPolicyLinks = $baselineProfile.policies | Where-Object {
                $_.'@odata.type' -eq '#microsoft.graph.networkaccess.filteringPolicyLink' -and
                $_.policy.id -in $q1PolicyIds
            }
            $baselineHasWCF = ($filteringPolicyLinks.Count -gt 0)
        }

        # Check Condition A: Non-Baseline profiles with filtering policy AND CA policy
        $nonBaselineProfilesWithWCFandCA = $profiles | Where-Object {
            $_.priority -ne $BASELINE_PROFILE_PRIORITY -and
            ($_.policies | Where-Object {
                $_.'@odata.type' -eq '#microsoft.graph.networkaccess.filteringPolicyLink' -and
                $_.policy.id -in $q1PolicyIds
            }).Count -gt 0 -and
            $_.conditionalAccessPolicies.Count -gt 0
        }

        # Determine pass/fail
        if ($baselineHasWCF -or $nonBaselineProfilesWithWCFandCA.Count -gt 0) {
            $passed = $true
            $testResultMarkdown = "✅ As políticas de filtragem de conteúdo web estão configuradas e aplicadas — seja por meio de perfis de segurança atribuídos a políticas de Acesso Condicional ou pelo Perfil de Linha de Base que se aplica a todo o tráfego de internet.`n`n%TestResult%"
        }
    }

    # Default failure message (if not API error and not passed)
    if (-not $errorMsg -and -not $passed) {
        $testResultMarkdown = "❌ A filtragem de conteúdo web não está configurada corretamente — não existem políticas, as políticas não estão vinculadas a perfis de segurança, ou perfis de segurança com políticas de filtragem não estão aplicados (sem atribuição de política de CA e sem uso do Perfil de Linha de Base).`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    # Table 1: Web Content Filtering Policies
    if ($policies.Count -gt 0) {
        $table1Title = 'Políticas de filtragem de conteúdo web'
        $table1Link = 'https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/WebFilteringPolicy.ReactView'

        $table1Template = @'

## [{0}]({1})

| Nome da política | Ação | Qtd. de regras | Última modificação |
| :---------- | :----- | ----------: | :------------ |
{2}
'@

        $table1Rows = ''
        foreach ($policy in $policies) {
            $policyName = $policy.name
            $policyId = $policy.id
            $action = $policy.action
            $rulesCount = if ($policy.policyRules) { $policy.policyRules.Count } else { 0 }
            $lastModified = if ($policy.lastModifiedDateTime) {
                ([DateTime]$policy.lastModifiedDateTime).ToString('yyyy-MM-dd HH:mm')
            } else { 'N/A' }

            # Create policy blade link
            $safePolicyName = Get-SafeMarkdown $policyName
            $encodedPolicyName = [System.Uri]::EscapeDataString($policyName)
            $policyBladeLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditFilteringPolicyMenuBlade.MenuView/~/Basics/policyId/$policyId/title/$encodedPolicyName/defaultMenuItemId/Basics"
            $policyNameWithLink = "[$safePolicyName]($policyBladeLink)"

            $table1Rows += "| $policyNameWithLink | $action | $rulesCount | $lastModified |`n"
        }

        $mdInfo += $table1Template -f $table1Title, $table1Link, $table1Rows
    }

    # Table 2: Security Profiles with Linked Policies
    if ($profiles.Count -gt 0) {
        $table2Title = 'Perfis de segurança com políticas vinculadas'
        $table2Link = 'https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/FilteringPolicyProfiles.ReactView'

        $table2Template = @'

## [{0}]({1})

| Nome do perfil | Estado | Prioridade | Políticas de filtragem vinculadas | Políticas de CA atribuídas | É linha de base |
| :----------- | :---- | -------: | :----------------------- | -------------------: | :---------- |
{2}
'@

        $table2Rows = ''
        foreach ($securityProfile in $profiles) {
            $profileName = $securityProfile.name
            $profileId = $securityProfile.id
            $state = $securityProfile.state
            $priority = $securityProfile.priority
            $isBaseline = if ($priority -eq $BASELINE_PROFILE_PRIORITY) { 'Sim' } else { 'Não' }

            # Create profile blade link
            $safeProfileName = Get-SafeMarkdown $profileName
            $profileBladeLink = "https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/EditProfileMenuBlade.MenuView/~/basics/profileId/$profileId"
            $profileNameWithLink = "[$safeProfileName]($profileBladeLink)"

            # Get filtering policy links
            $filteringPolicyLinks = $securityProfile.policies | Where-Object {
                $_.'@odata.type' -eq '#microsoft.graph.networkaccess.filteringPolicyLink' -and
                $_.policy.id -in $q1PolicyIds
            }

            $linkedPolicyNames = if ($filteringPolicyLinks.Count -gt 0) {
                ($filteringPolicyLinks | ForEach-Object { Get-SafeMarkdown $_.policy.name }) -join ', '
            } else {
                'Nenhuma'
            }

            $caCount = if ($isBaseline -eq 'Sim') {
                'N/A'
            } else {
                $securityProfile.conditionalAccessPolicies.Count
            }

            $table2Rows += "| $profileNameWithLink | $state | $priority | $linkedPolicyNames | $caCount | $isBaseline |`n"
        }

        $mdInfo += $table2Template -f $table2Title, $table2Link, $table2Rows
    }

    # Table 3: Conditional Access Policies Assigned to Security Profiles
    $caPolicies = @()
    foreach ($securityProfile in $profiles) {
        if ($securityProfile.conditionalAccessPolicies -and $securityProfile.conditionalAccessPolicies.Count -gt 0) {
            foreach ($caPolicy in $securityProfile.conditionalAccessPolicies) {
                $caPolicies += [PSCustomObject]@{
                    CAPolicyName = $caPolicy.displayName
                    ProfileName  = $securityProfile.name
                    CAPolicyId   = $caPolicy.id
                }
            }
        }
    }

    if ($caPolicies.Count -gt 0) {
        $table3Title = 'Políticas de Acesso Condicional atribuídas a perfis de segurança'
        $table3Link = 'https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/Policies'

        $table3Template = @'

## [{0}]({1})

| Nome da política de CA | Perfil de segurança |
| :------------- | :--------------- |
{2}
'@

        $table3Rows = ''
        foreach ($caPolicy in $caPolicies) {
            $safeCAPolicyName = Get-SafeMarkdown $caPolicy.CAPolicyName
            $safeProfileName = Get-SafeMarkdown $caPolicy.ProfileName
            $table3Rows += "| [$safeCAPolicyName](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/$($caPolicy.CAPolicyId)) | $safeProfileName |`n"
        }

        $mdInfo += $table3Template -f $table3Title, $table3Link, $table3Rows
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25410'
        Title  = 'O tráfego de internet é protegido por políticas de filtragem de conteúdo web no Global Secure Access'
        Status = $passed
        Result = $testResultMarkdown
    }
    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }
    Add-ZtTestResultDetail @params
}
