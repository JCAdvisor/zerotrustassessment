<#
.SYNOPSIS
    Tipos de informações sensíveis de entidade nomeada são usados em políticas de auto-rotulagem e prevenção de perda de dados

.DESCRIPTION
    Este teste avalia se a organização implantou Tipos de Informações Sensíveis de Entidade Nomeada (SITs)
    em políticas de auto-rotulagem ou regras de DLP. Named Entity SITs
    são classificadores pré-construídos e gerenciados pela Microsoft, projetados para detectar entidades sensíveis comuns
    como nomes de pessoas, endereços físicos e terminologia médica.

.NOTES
    Test ID: 35035
    Category: Advanced Classification
    Pillar: Data
    Risk Level: High
#>

function Test-Assessment-35035 {
    [ZtTest(
    	Category = 'Advanced Classification',
    	ImplementationCost = 'Low',
    	CompatibleLicense = ('EXCHANGE_S_ENTERPRISE'),
    	Service = ('SecurityCompliance'),
    	Pillar = 'Data',
    	RiskLevel = 'High',
    	SfiPillar = 'Protect tenants and production systems',
    	TenantType = ('Workforce'),
    	TestId = 35035,
    	Title = 'Named entity sensitive information types are used in auto-labeling and data loss prevention policies',
    	UserImpact = 'Medium'
    )]
    [CmdletBinding()]
    param()

    #region Helper Functions

    function Get-NamedEntitySitsFromRule {
        <#
        .SYNOPSIS
            Extracts Named Entity SITs from an AdvancedRule JSON property using ID-based matching.
        .DESCRIPTION
            Parses the AdvancedRule JSON and checks SIT IDs against the Named Entity SIT catalog
            (Classifier -eq "EntityMatch"). This approach is future-proof as new Named Entity SITs
            are automatically detected.
        .OUTPUTS
            Array of PSCustomObjects with Name and Id of Named Entity SITs found in the rule.
        #>
        param(
            [Parameter(Mandatory = $false)]
            [AllowNull()]
            [AllowEmptyString()]
            [string]$AdvancedRuleJson,

            [Parameter(Mandatory = $true)]
            [AllowEmptyCollection()]
            [array]$NamedEntitySitIds,

            [Parameter(Mandatory = $false)]
            [string]$RuleName = 'Unknown',

            [Parameter(Mandatory = $false)]
            [ValidateSet('AutoLabeling', 'DLP')]
            [string]$RuleType = 'AutoLabeling'
        )

        $namedEntitySits = @()

        if ([string]::IsNullOrWhiteSpace($AdvancedRuleJson)) {
            return $namedEntitySits
        }

        if ($NamedEntitySitIds.Count -eq 0) {
            return $namedEntitySits
        }

        try {
            $advancedRule = $AdvancedRuleJson | ConvertFrom-Json -ErrorAction Stop

            # Navigate to SubConditions
            $subConditions = $advancedRule.Condition.SubConditions
            if (-not $subConditions) {
                return $namedEntitySits
            }

            foreach ($subCondition in $subConditions) {
                # Only process ContentContainsSensitiveInformation conditions
                if ($subCondition.ConditionName -ne 'ContentContainsSensitiveInformation') {
                    continue
                }

                $values = $subCondition.Value
                if (-not $values) {
                    continue
                }

                if ($RuleType -eq 'AutoLabeling') {
                    # Auto-labeling: Grouped structure - Value[].Groups[].Sensitivetypes[]
                    foreach ($value in $values) {
                        if ($value.Groups) {
                            foreach ($group in $value.Groups) {
                                if ($group.Sensitivetypes) {
                                    foreach ($sit in $group.Sensitivetypes) {
                                        if ($sit.id -and $sit.id -in $NamedEntitySitIds) {
                                            $namedEntitySits += [PSCustomObject]@{
                                                Name = $sit.name
                                                Id   = $sit.id
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    # DLP: Nested structure - Value[0].groups[].sensitivetypes[]
                    if ($values -and $values[0].groups) {
                        foreach ($group in $values[0].groups) {
                            if ($group.sensitivetypes) {
                                foreach ($sit in $group.sensitivetypes) {
                                    if ($sit.id -and $sit.id -in $NamedEntitySitIds) {
                                        $namedEntitySits += [PSCustomObject]@{
                                            Name = $sit.name
                                            Id   = $sit.id
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        catch {
            Write-PSFMessage "Error parsing AdvancedRule JSON for rule '$RuleName': $_" -Level Warning
            throw
        }

        # Return unique SITs by Id
        return $namedEntitySits | Sort-Object -Property Id -Unique
    }

    #endregion Helper Functions

    #region Data Collection

    Write-PSFMessage '🟦 Start' -Tag Test -Level VeryVerbose
    $activity = 'Avaliando o uso de Named Entity SIT em políticas'
    Write-ZtProgress -Activity $activity -Status 'Construindo catálogo de pesquisa de Named Entity SIT'

    $namedEntitySitIds = @()
    $autoLabelRules = @()
    $dlpRules = @()
    $queryError = $null
    $catalogError = $null

    # Build lookup of Named Entity SIT IDs from catalog (Classifier -eq "EntityMatch")
    try {
        $namedEntitySits = Get-DlpSensitiveInformationType -ErrorAction Stop | Where-Object { $_.Classifier -eq 'EntityMatch' }
        $namedEntitySitIds = @($namedEntitySits.Id)
        Write-PSFMessage "Catálogo de Named Entity SIT construído com $($namedEntitySitIds.Count) SITs" -Level Verbose
    }
    catch {
        Write-PSFMessage "Erro ao construir o catálogo de Named Entity SIT: $_" -Level Warning
        $catalogError = $_
    }

    # Q1: Get all auto-sensitivity label rules
    Write-ZtProgress -Activity $activity -Status 'Recuperando regras de auto-rotulagem'
    try {
        $autoLabelRules = Get-AutoSensitivityLabelRule -ErrorAction Stop
        Write-PSFMessage "Recuperadas $($autoLabelRules.Count) regras de auto-rotulagem" -Level Verbose
    }
    catch {
        Write-PSFMessage "Erro ao recuperar regras de auto-rotulagem: $_" -Level Warning
        $queryError = $_
    }

    # Q2: Get all DLP compliance rules
    Write-ZtProgress -Activity $activity -Status 'Recuperando regras de conformidade de DLP'
    try {
        $dlpRules = Get-DlpComplianceRule -ErrorAction Stop
        Write-PSFMessage "Recuperadas $($dlpRules.Count) regras de DLP" -Level Verbose
    }
    catch {
        Write-PSFMessage "Erro ao recuperar regras de DLP: $_" -Level Warning
        if (-not $queryError) {
            $queryError = $_
        }
    }

    #endregion Data Collection

    #region Assessment Logic

    $passed = $false
    $customStatus = $null
    $testResultMarkdown = ''

    $autoLabelRulesWithNamedEntity = @()
    $dlpRulesWithNamedEntity = @()
    $parseErrors = @()

    # Check if catalog lookup failed
    if ($catalogError) {
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ Impossível determinar o uso de Named Entity SIT. Falha ao construir a pesquisa do catálogo de SIT: $catalogError`n`n%TestResult%"
    }
    # Check if both queries failed
    elseif ($queryError -and $autoLabelRules.Count -eq 0 -and $dlpRules.Count -eq 0) {
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ Impossível determinar o uso de Named Entity SIT devido a erro de consulta: $queryError`n`n%TestResult%"
    }
    # Check if catalog is empty (no Named Entity SITs found - unusual)
    elseif ($namedEntitySitIds.Count -eq 0) {
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ Impossível determinar o uso de Named Entity SIT. Nenhum Named Entity SIT encontrado no catálogo de SIT (Classifier = 'EntityMatch'). Isso é inesperado - verifique o acesso ao locatário.`n`n%TestResult%"
    }
    else {
        # Process auto-labeling rules
        Write-ZtProgress -Activity $activity -Status 'Analisando regras de auto-rotulagem para Named Entity SITs'
        foreach ($rule in $autoLabelRules) {
            try {
                $foundSits = Get-NamedEntitySitsFromRule -AdvancedRuleJson $rule.AdvancedRule -NamedEntitySitIds $namedEntitySitIds -RuleName $rule.Name -RuleType 'AutoLabeling'

                if ($foundSits.Count -gt 0) {
                    $autoLabelRulesWithNamedEntity += [PSCustomObject]@{
                        RuleName        = $rule.Name
                        PolicyName      = $rule.ParentPolicyName
                        NamedEntitySits = ($foundSits | ForEach-Object { $_.Name }) -join ', '
                        SitIds          = ($foundSits | ForEach-Object { $_.Id }) -join ', '
                        Workload        = $rule.Workload
                        CreatedDate     = $rule.WhenCreatedUTC
                        RuleType        = 'Auto-Labeling'
                        Count           = $foundSits.Count
                    }
                }
            }
            catch {
                $parseErrors += [PSCustomObject]@{
                    RuleName = $rule.Name
                    RuleType = 'Auto-Labeling'
                    Error    = $_.Exception.Message
                }
            }
        }

        # Process DLP rules
        Write-ZtProgress -Activity $activity -Status 'Analisando regras de DLP para Named Entity SITs'
        foreach ($rule in $dlpRules) {
            try {
                $foundSits = Get-NamedEntitySitsFromRule -AdvancedRuleJson $rule.AdvancedRule -NamedEntitySitIds $namedEntitySitIds -RuleName $rule.Name -RuleType 'DLP'

                if ($foundSits.Count -gt 0) {
                    $dlpRulesWithNamedEntity += [PSCustomObject]@{
                        RuleName        = $rule.Name
                        PolicyName      = $rule.ParentPolicyName
                        NamedEntitySits = ($foundSits | ForEach-Object { $_.Name }) -join ', '
                        SitIds          = ($foundSits | ForEach-Object { $_.Id }) -join ', '
                        Workload        = $rule.Workload
                        CreatedDate     = $rule.WhenCreatedUTC
                        RuleType        = 'DLP'
                        Count           = $foundSits.Count
                    }
                }
            }
            catch {
                $parseErrors += [PSCustomObject]@{
                    RuleName = $rule.Name
                    RuleType = 'DLP'
                    Error    = $_.Exception.Message
                }
            }
        }

        # Determine pass/fail status
        $totalRulesWithNamedEntity = $autoLabelRulesWithNamedEntity.Count + $dlpRulesWithNamedEntity.Count

        if ($totalRulesWithNamedEntity -gt 0) {
            $passed = $true
            $testResultMarkdown = "✅ Pelo menos uma regra de política de auto-rotulagem ou DLP usa um Named Entity SIT (como 'Todos os Nomes Completos', 'Todos os Endereços Físicos', 'Todos os Termos e Condições Médicos' ou classificadores pré-construídos similares).`n`n%TestResult%"
        }
        else {
            $passed = $false

            if ($autoLabelRules.Count -eq 0 -and $dlpRules.Count -eq 0) {
                $testResultMarkdown = "❌ Nenhuma regra de auto-rotulagem ou DLP foi encontrada em seu locatário.`n`n%TestResult%"
            }
            else {
                $testResultMarkdown = "❌ Nenhuma regra de política de auto-rotulagem ou DLP contém Named Entity SITs. Todas as políticas usam apenas SITs padrão (números de cartão de crédito, números de seguro social, etc.) ou não estão configuradas.`n`n%TestResult%"
            }
        }

        # Check for excessive parse errors which might indicate Investigate status
        if ($parseErrors.Count -gt 0 -and $totalRulesWithNamedEntity -eq 0) {
            $totalRules = $autoLabelRules.Count + $dlpRules.Count
            if ($parseErrors.Count -eq $totalRules -and $totalRules -gt 0) {
                $customStatus = 'Investigate'
                $testResultMarkdown = "⚠️ Impossível determinar o uso de Named Entity SIT devido a erros de análise JSON em todas as regras.`n`n%TestResult%"
            }
        }
    }

    #endregion Assessment Logic

    #region Report Generation

    $mdInfo = ''

    # Combine all rules with Named Entity SITs for display
    $allRulesWithNamedEntity = @()
    $allRulesWithNamedEntity += $autoLabelRulesWithNamedEntity
    $allRulesWithNamedEntity += $dlpRulesWithNamedEntity

    if ($allRulesWithNamedEntity.Count -gt 0) {
        $mdInfo += "`n`n### [Regras usando SITs de entidade nomeada](https://purview.microsoft.com/informationprotection/dataclassification/multicloudsensitiveinfotypes)`n"
        $mdInfo += "| Nome da regra | Nome da política | SITs de entidade nomeada | Contagem | Carga de trabalho | Tipo |`n"
        $mdInfo += "| :--- | :--- | :--- | :--- | :--- | :--- |`n"

        foreach ($rule in $allRulesWithNamedEntity) {
            $ruleName = Get-SafeMarkdown -Text $rule.RuleName
            $safePolicyName = Get-SafeMarkdown -Text $rule.PolicyName
            $sits = Get-SafeMarkdown -Text $rule.NamedEntitySits
            $workload = Get-SafeMarkdown -Text ($rule.Workload -join ', ')

            # Build policy URL based on rule type
            if ($rule.RuleType -eq 'Auto-Labeling') {
                $policyUrl = 'https://purview.microsoft.com/informationprotection/autolabeling'
            }
            else {
                $policyUrl = 'https://purview.microsoft.com/datalossprevention/policies'
            }
            $policyLink = "[$safePolicyName]($policyUrl)"

            $mdInfo += "| $ruleName | $policyLink | $sits | $($rule.Count) | $workload | $($rule.RuleType) |`n"
        }
    }

    # Summary section
    $mdInfo += "`n`n### Resumo`n"
    $mdInfo += "| Métrica | Contagem |`n"
    $mdInfo += "| :--- | :--- |`n"
    $mdInfo += "| SITs de entidade nomeada no catálogo | $($namedEntitySitIds.Count) |`n"
    $mdInfo += "| Total de regras de auto-rotulagem | $($autoLabelRules.Count) |`n"
    $mdInfo += "| Total de regras de DLP | $($dlpRules.Count) |`n"
    $mdInfo += "| Regras de auto-rotulagem usando SITs de entidade nomeada | $($autoLabelRulesWithNamedEntity.Count) |`n"
    $mdInfo += "| Regras de DLP usando SITs de entidade nomeada | $($dlpRulesWithNamedEntity.Count) |"

    # Report parsing errors if any occurred
    if ($parseErrors.Count -gt 0) {
        $mdInfo += "`n`n### ⚠️ Parsing Errors`n"
        $mdInfo += "The following rules could not be fully parsed:`n`n"
        $mdInfo += "| Rule name | Type | Error |`n"
        $mdInfo += "| :--- | :--- | :--- |`n"
        foreach ($parseError in $parseErrors) {
            $ruleName = Get-SafeMarkdown -Text $parseError.RuleName
            $errorMsg = Get-SafeMarkdown -Text $parseError.Error
            $mdInfo += "| $ruleName | $($parseError.RuleType) | $errorMsg |`n"
        }
        $mdInfo += "`n**Note**: These rules were excluded from the named entity SIT analysis.`n"
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo

    #endregion Report Generation

    $params = @{
        TestId = '35035'
        Title  = 'Named Entity SITs Usage in Auto-Labeling and DLP Policies'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add CustomStatus if status is 'Investigate'
    if ($null -ne $customStatus) {
        $params.CustomStatus = $customStatus
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
