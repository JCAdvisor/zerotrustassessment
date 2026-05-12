<#
.SYNOPSIS
    Valida que as regras de bypass de inspeção de TLS personalizadas não duplicam destinos de bypass do sistema.

.DESCRIPTION
    Este teste verifica se as regras de bypass de inspeção de TLS personalizadas contém destinos que já são cobertos pela lista de bypass do sistema.
    - Consume policy capacity unnecessarily
    - Create administrative overhead
    - May cause confusion about necessary vs. duplicated rules

    The test identifies exact matches, subdomain matches, and wildcard overlaps between
    custom bypass rules and the system bypass list.

.NOTES
    Test ID: 27004
    Category: Global Secure Access
    Required API: networkAccess/tlsInspectionPolicies (beta) with $expand=policyRules
    System Bypass List: assets/27004-system-bypass-fqdns.json (sourced from GSA backend team; manually maintained until API is available)
#>

function Test-Assessment-27004 {
    [ZtTest(
        Category = 'Global Secure Access',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Entra_Premium_Internet_Access'),
    	CompatibleLicense = ('Entra_Premium_Internet_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Baixo',
        SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 27004,
            Title = 'As regras personalizadas de bypass de inspeção de TLS não duplicam os destinos de bypass do sistema',
            UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    # Constants for output display limits
    [int]$MAX_RULES_DISPLAYED = 10
    [int]$MAX_RULE_GROUPS = 10
    [int]$MAX_DESTINATIONS_PER_RULE = 10

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando regras de bypass de inspeção de TLS para destinos de sistema redundantes'
    Write-ZtProgress -Activity $activity -Status 'Carregando lista de referéncia de bypass do sistema'

    # Load system bypass FQDN list from config file.
    $dataFilePath = Join-Path $PSScriptRoot '..' 'assets' '27004-system-bypass-fqdns.json' | Resolve-Path -ErrorAction SilentlyContinue
    if (-not $dataFilePath -or -not (Test-Path $dataFilePath)) {
        Write-PSFMessage "Arquivo de configuração FQDN de bypass do sistema não encontrado: $dataFilePath" -Tag Test -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotSupported
        return
    }

    $jsonErrorMsg = $null
    try {
        $bypassConfig = Get-Content $dataFilePath -Raw | ConvertFrom-Json
        $systemFqdns = @($bypassConfig.fqdns)
        $systemFqdnsLower = $systemFqdns | ForEach-Object { $_.ToLower() }
        Write-PSFMessage "Carregados $($systemFqdns.Count) FQDNs de bypass do sistema a partir da configuração (última atualização: $($bypassConfig.metadata.lastUpdated))" -Tag Test -Level VeryVerbose
    }
    catch {
        $jsonErrorMsg = $_
        Write-PSFMessage "Falha ao analisar arquivo de configuração de bypass do sistema: $jsonErrorMsg" -Tag Test -Level Warning
    }

    # System recommended bypass categories (from priority 65000 rule)
    $systemCategories = @('Education', 'Finance', 'Government', 'HealthAndMedicine')
    $systemCategoriesLower = $systemCategories | ForEach-Object { $_.ToLower() }

    Write-ZtProgress -Activity $activity -Status 'Consultando políticas de inspeção de TLS e regras'

    $tlsPolicies = @()
    $errorMsg = $null

    try {
        $tlsPolicies = Invoke-ZtGraphRequest `
            -RelativeUri 'networkAccess/tlsInspectionPolicies' `
            -QueryParameters @{ '$expand' = 'policyRules' } `
            -ApiVersion beta
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Falha ao recuperar políticas de inspeção de TLS: $errorMsg" -Tag Test -Level Warning
    }
    #endregion Data Collection

    #region Assessment Logic
    $testResultMarkdown = ''
    $passed = $false
    $customStatus = $null

    if ($jsonErrorMsg) {
        # JSON parsing failed - unable to load system bypass configuration
        $passed = $false
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ Não foi possível carregar a configuração de bypass do sistema devido a erro de análise de JSON.`n`n%TestResult%"
    }
    elseif ($errorMsg) {
        # API call failed - unable to determine status
        $passed = $false
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ Não foi possível recuperar políticas de inspeção de TLS devido a erro de API ou permissões insuficientes.`n`n%TestResult%"
    }
    elseif ($null -eq $tlsPolicies -or $tlsPolicies.Count -eq 0) {
        # No TLS inspection policies configured - prerequisite not met
        Write-PSFMessage 'A inspeção de TLS não está configurada neste locaário.' -Tag Test -Level Verbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable -Result 'A inspeção de TLS não está configurada neste locatário. Esta verificação não se aplica até que uma política de inspeção de TLS seja criada.'
        return
    }
    else {

    Write-ZtProgress -Activity $activity -Status 'Analisando regras de bypass para redundâncias'

    $allBypassRules = [System.Collections.Generic.List[object]]::new()
    $redundantRules = [System.Collections.Generic.List[object]]::new()

    foreach ($policy in $tlsPolicies) {
        if ($null -eq $policy.policyRules) {
            continue
        }

        $bypassRules = @($policy.policyRules | Where-Object { $_.action -eq 'bypass' })

        foreach ($rule in $bypassRules) {
            # Skip auto-created system rules
            if ($rule.description -like 'Auto-created TLS rule*') {
                continue
            }

            $destinations = @()
            $destinationTypeMap = @{}
            $matchedPairs = [System.Collections.Generic.List[object]]::new()

            # Extract destinations from matchingConditions, tracking type per value
            if ($null -ne $rule.matchingConditions -and $null -ne $rule.matchingConditions.destinations) {
                foreach ($dest in $rule.matchingConditions.destinations) {
                    if ($null -ne $dest.values) {
                        $destType = if ($dest.'@odata.type' -like '*tlsInspectionFqdnDestination*') { 'FQDN' }
                                    elseif ($dest.'@odata.type' -like '*tlsInspectionWebCategoryDestination*') { 'Categoria' }
                                    else { 'Desconhecido' }
                        foreach ($v in $dest.values) {
                            $destinations += $v
                            $destinationTypeMap[$v] = $destType
                        }
                    }
                }
            }

            # Skip rule if no destinations found
            if ($destinations.Count -eq 0) {
                continue
            }

            # Check each custom destination against the system bypass list.
            # Supports exact matches, subdomain matches under wildcards (*.domain.com),
            # wildcard-to-wildcard matches, and double-wildcard patterns (*.domain.*).
            foreach ($destination in $destinations) {
                $destLower = $destination.ToLower().Trim()
                $destType = if ($destinationTypeMap.ContainsKey($destination)) { $destinationTypeMap[$destination] } else { 'FQDN' }

                # Check if this is a web category destination
                if ($destType -eq 'Categoria') {
                    # Check against system recommended bypass categories
                    for ($i = 0; $i -lt $systemCategoriesLower.Count; $i++) {
                        if ($destLower -eq $systemCategoriesLower[$i]) {
                            $matchedPairs.Add([PSCustomObject]@{
                                CustomFqdn = $destination
                                SystemFqdn = $systemCategories[$i]
                                MatchType  = 'Exata'
                                DestType   = 'Categoria'
                            })
                            break
                        }
                    }
                }
                else {
                    # Check FQDN against system bypass FQDN list
                    for ($i = 0; $i -lt $systemFqdnsLower.Count; $i++) {
                        $sysFqdn = $systemFqdnsLower[$i]
                        $isMatch = $false
                        $matchType = ''

                        if ($destLower -eq $sysFqdn) {
                            # Exact match (covers wildcard-to-wildcard too)
                            $isMatch = $true; $matchType = 'Exata'
                        }
                        elseif ($sysFqdn -match '^\*\.([^.]+)\.\*$') {
                            # Double-wildcard: *.domain.* — check if custom destination matches the pattern
                            $mid = [regex]::Escape($Matches[1])
                            if ($destLower -match "\.$mid\.") {
                                $isMatch = $true
                                # Determine match type based on whether custom is also a wildcard
                                $matchType = if ($destLower -match '^\*\.') { 'Curinga' } else { 'Subdomínio' }
                            }
                        }
                        elseif ($sysFqdn -match '^\*\.(.+)$') {
                            # Standard wildcard: *.domain.com
                            $suffix = $Matches[1]
                            if ($destLower -eq "*.$suffix") {
                                # Exact wildcard-to-wildcard match
                                $isMatch = $true
                                $matchType = 'Exact'
                            }
                            elseif ($destLower -like "*.$suffix") {
                                # Subdomain of the wildcard suffix
                                $isMatch = $true
                                $matchType = 'Subdomínio'
                            }
                            elseif ($destLower -eq $suffix) {
                                # Base domain match
                                $isMatch = $true
                                $matchType = 'Subdomínio'
                            }
                        }

                        # Check if custom destination is a wildcard being covered by system base domain
                        if (-not $isMatch -and $destLower -match '^\*\.(.+)$') {
                            $customSuffix = $Matches[1]
                            if ($sysFqdn -eq $customSuffix -or $sysFqdn -eq "*.$customSuffix") {
                                $isMatch = $true; $matchType = 'Curinga'
                            }
                        }

                        if ($isMatch) {
                            $matchedPairs.Add([PSCustomObject]@{
                                CustomFqdn = $destination
                                SystemFqdn = $systemFqdns[$i]
                                MatchType  = $matchType
                                DestType   = 'FQDN'
                            })
                            break  # Only match once per destination
                        }
                    }
                }
            }

            $ruleStatus = if ($matchedPairs.Count -eq 0) { 'Sem sobreposição' }
                          elseif ($matchedPairs.Count -ge $destinations.Count) { 'Redundante' }
                          else { 'Parcial' }

            $ruleInfo = [PSCustomObject]@{
                PolicyName        = $policy.name
                PolicyId          = $policy.id
                RuleName          = $rule.name
                RuleId            = $rule.id
                Destinations      = $destinations
                TotalDestinations = $destinations.Count
                RedundantCount    = $matchedPairs.Count
                MatchedPairs      = $matchedPairs
                Status            = $ruleStatus
            }

            $allBypassRules.Add($ruleInfo)

            if ($ruleStatus -ne 'Sem sobreposição') {
                $redundantRules.Add($ruleInfo)
            }
        }
    }

        # Evaluate test result per spec evaluation logic
        if ($redundantRules.Count -eq 0) {
            # No custom bypass rules OR custom rules exist but none are redundant - pass
            $passed = $true
            $testResultMarkdown = "✅ Todas as regras de bypass de inspeção de TLS personalizadas visam destinos exclusivos não cobertos pela lista de bypass do sistema.`n`n%TestResult%"
        }
        else {
            # Any matches found - fail with list of redundant rules
            $passed = $false
            $testResultMarkdown = "❌ Encontradas regras de bypass personalizadas que duplicam destinos de bypass do sistema; essas regras são redundantes e podem ser removidas para simplificar o gerenciamento de políticas.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($allBypassRules.Count -gt 0) {
        $reportTitle = 'Análise de Regra de Bypass de Inspeção de TLS'
        $portalLink = 'https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/TLSInspectionPolicy.ReactView'

        # Calculate totals
        $totalDestinations = ($allBypassRules | ForEach-Object { $_.TotalDestinations } | Measure-Object -Sum).Sum
        $totalRedundantDestinations = ($allBypassRules | ForEach-Object { $_.RedundantCount } | Measure-Object -Sum).Sum
        $totalUniqueDestinations = $totalDestinations - $totalRedundantDestinations

        # Sort rules per spec: Status priority (Redundant → Partial → No Overlap), then by descending redundant count
        $statusPriority = @{ 'Redundante' = 1; 'Parcial' = 2; 'Sem sobreposição' = 3 }
        $sortedRules = $allBypassRules | Sort-Object { $statusPriority[$_.Status] }, @{ Expression = { $_.RedundantCount }; Descending = $true }

        # Build rule-level summary table with row cap
        $rulesTable = "#### Resumo de nível de regra`n`n"
        $rulesTable += "| Nome da política | Nome da regra | Destinos totais | Destinos redundantes | Status |`n"
        $rulesTable += "| :---------- | :-------- | :----------------- | :--------------------- | :----- |`n"

        $displayedRules = $sortedRules | Select-Object -First $MAX_RULES_DISPLAYED

        foreach ($rule in $displayedRules) {
            $policyName = Get-SafeMarkdown -Text $rule.PolicyName
            $ruleName = Get-SafeMarkdown -Text $rule.RuleName
            $rulesTable += "| $policyName | $ruleName | $($rule.TotalDestinations) | $($rule.RedundantCount) | $($rule.Status) |`n"
        }

        # Add overflow summary if there are more rules than the display limit
        if ($sortedRules.Count -gt $MAX_RULES_DISPLAYED) {
            $remaining = $sortedRules | Select-Object -Skip $MAX_RULES_DISPLAYED
            $remainingCount = $remaining.Count
            $remainingRedundant = ($remaining | Where-Object { $_.Status -eq 'Redundant' }).Count
            $remainingPartial = ($remaining | Where-Object { $_.Status -eq 'Partial' }).Count
            $remainingNoOverlap = ($remaining | Where-Object { $_.Status -eq 'No Overlap' }).Count
            $rulesTable += "| *+ $remainingCount regras adicionais não exibidas ($remainingRedundant redundantes, $remainingPartial parciais, $remainingNoOverlap sem sobreposição)* | | | | |`n"
        }

        # Build redundant destination detail grouped by rule
        $redundantDetail = ''
        if ($redundantRules.Count -gt 0) {
            $redundantDetail = "#### Detalhe de destino redundante`n`n"

            # Sort redundant rules by same criteria: Status priority then redundant count desc
            $sortedRedundantRules = $redundantRules | Sort-Object { $statusPriority[$_.Status] }, @{ Expression = { $_.RedundantCount }; Descending = $true }

            # Cap at maximum rule groups
            $displayedRuleGroups = $sortedRedundantRules | Select-Object -First $MAX_RULE_GROUPS

            foreach ($rule in $displayedRuleGroups) {
                $policyName = Get-SafeMarkdown -Text $rule.PolicyName
                $ruleName = Get-SafeMarkdown -Text $rule.RuleName
                $redundantDetail += "**Regra: $ruleName** (Política: $policyName) — $($rule.RedundantCount) de $($rule.TotalDestinations) destinos redundantes`n`n"
                $redundantDetail += "| # | Destino de bypass personalizado | Tipo de destino | Entrada de bypass do sistema correspondida | Tipo de correspondência |`n"
                $redundantDetail += "| :- | :----------------------- | :--------------- | :-------------------------- | :--------- |`n"

                # Cap at maximum destination entries per rule group
                $displayedPairs = $rule.MatchedPairs | Select-Object -First $MAX_DESTINATIONS_PER_RULE

                $rowNum = 1
                foreach ($pair in $displayedPairs) {
                    # Escape asterisks in FQDNs for markdown rendering (prevent italic/bold interpretation)
                    $customFqdn = $pair.CustomFqdn -replace '\*', '\*'
                    $systemFqdn = $pair.SystemFqdn -replace '\*', '\*'
                    $redundantDetail += "| $rowNum | $customFqdn | $($pair.DestType) | $systemFqdn | $($pair.MatchType) |`n"
                    $rowNum++
                }

                # Add overflow row if this rule has more redundant destinations than display limit
                if ($rule.MatchedPairs.Count -gt $MAX_DESTINATIONS_PER_RULE) {
                    $remainingPairs = $rule.MatchedPairs.Count - $MAX_DESTINATIONS_PER_RULE
                    $redundantDetail += "| | *+ $remainingPairs destinos redundantes adicionais não exibidos para esta regra* | | | |`n"
                }

                $redundantDetail += "`n"
            }

            # Add overflow line if there are more rule groups than display limit
            if ($sortedRedundantRules.Count -gt $MAX_RULE_GROUPS) {
                $remainingRuleGroups = $sortedRedundantRules.Count - $MAX_RULE_GROUPS
                $redundantDetail += "*+ $remainingRuleGroups regras adicionais com destinos redundantes não exibidas*`n`n"
            }
        }

        $formatTemplate = @'

## [{0}]({1})

**Resumo:**
- Total de regras de bypass personalizadas: {2}
- Total de destinos de bypass personalizados: {3}
- Destinos redundantes encontrados: {4}
- Destinos exclusivos: {5}

{6}

{7}
'@

        $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $allBypassRules.Count, $totalDestinations, $totalRedundantDestinations, $totalUniqueDestinations, $rulesTable, $redundantDetail
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '27004'
        Title  = 'As regras de bypass de inspeção de TLS personalizadas não duplicam destinos de bypass do sistema'
        Status = $passed
        Result = $testResultMarkdown
    }
    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }
    Add-ZtTestResultDetail @params
}
