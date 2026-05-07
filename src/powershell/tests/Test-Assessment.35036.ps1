<#
.SYNOPSIS
    Classificadores treináveis são usados em políticas de prevenção de perda de dados e identificação automática de rótulos

.DESCRIPTION
    Este teste verifica se os classificadores treináveis estão sendo usados em políticas por:
    1. Recuperando todas as regras de etiqueta de sensibilidade automática e procurando por classificadores treináveis em AdvancedRule
    2. Recuperando todas as regras de conformidade de DLP e procurando por classificadores treináveis em AdvancedRule
    3. Analisando AdvancedRule JSON para extrair detalhes do classificador (identificado por Classifiertype=MLModel)

.NOTES
    Test ID: 35036
    Category: Advanced Classification
    Required Module: ExchangeOnlineManagement v3.5.1+
    Required Connection: Connect-IPPSSession
#>

function Test-Assessment-35036 {
    [ZtTest(
        	Category = 'Classificação Avançada',
    	ImplementationCost = 'Alto',
    	CompatibleLicense = ('EXCHANGE_S_ENTERPRISE'),
    	Service = ('SecurityCompliance'),
        	Pillar = 'Dados',
        	RiskLevel = 'Médio',
        	SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce','External'),
    	TestId = 35036,
        	Title = 'Classificadores treináveis são usados em políticas de prevenção de perda de dados e identificação automática de rótulos',
        	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando uso de classificador treinável em políticas'
    Write-ZtProgress -Activity $activity -Status 'Consultando regras de aplicação automática de rótulos e DLP'

    $autoLabelCmdletFailed = $false
    $dlpCmdletFailed = $false
    $autoLabelRulesWithClassifiers = @()
    $dlpRulesWithClassifiers = @()

        # Consulta 1 & 2: Get auto-sensitivity label rules with trainable classifiers
    try {
        Write-ZtProgress -Activity $activity -Status 'Verificando regras de etiqueta automática'
        $allAutoLabelRules = Get-AutoSensitivityLabelRule -ErrorAction Stop

        # Filter rules that contain trainable classifiers (MLModel in AdvancedRule)
        $rulesWithMLModel = $allAutoLabelRules | Where-Object { $_.AdvancedRule -match 'MLModel' }

        foreach ($rule in $rulesWithMLModel) {
            try {
                # Parse AdvancedRule JSON to extract classifier details
                $advancedRule = $rule.AdvancedRule | ConvertFrom-Json -ErrorAction Stop

                # Navigate to ContentContainsSensitiveInformation condition
                $sensitiveInfoCondition = $advancedRule.Condition.SubConditions | Where-Object {
                    $_.ConditionName -eq 'ContentContainsSensitiveInformation'
                }

                if ($sensitiveInfoCondition) {
                    # Extract trainable classifiers from Groups (Value is an array)
                    $trainableClassifiers = @()
                    foreach ($valueItem in $sensitiveInfoCondition.Value) {
                        foreach ($group in $valueItem.Groups) {
                            # Check all groups regardless of name (could be "Default", "Trainable Classifiers", etc.)
                            foreach ($classifier in $group.Sensitivetypes) {
                                if ($classifier.Classifiertype -eq 'MLModel') {
                                    $trainableClassifiers += $classifier.Name
                                }
                            }
                        }
                    }

                    if ($trainableClassifiers.Count -gt 0) {
                        # Deduplicate classifier names
                        $uniqueClassifiers = $trainableClassifiers | Select-Object -Unique
                        $autoLabelRulesWithClassifiers += [PSCustomObject]@{
                            RuleName          = $rule.Name
                            ParentPolicyName  = $rule.ParentPolicyName
                            CreatedDate       = $rule.WhenCreatedUTC
                            Classifiers       = $uniqueClassifiers
                        }
                    }
                }
            }
            catch {
                Write-PSFMessage "Falha ao analisar AdvancedRule para regra de etiqueta automática '$($rule.Name)': $_" -Tag Test -Level Warning

                # Fallback: this rule matched 'MLModel' via string search, so record it even if JSON parsing failed
                $autoLabelRulesWithClassifiers += [PSCustomObject]@{
                    RuleName          = $rule.Name
                    ParentPolicyName  = $rule.ParentPolicyName
                    CreatedDate       = $rule.WhenCreatedUTC
                    Classifiers       = @('Unknown (AdvancedRule parse failed)')
                }
            }
        }
    }
    catch {
        $autoLabelCmdletFailed = $true
        Write-PSFMessage "Falha ao recuperar regras de etiqueta de sensibilidade automática: $_" -Tag Test -Level Warning
    }

        # Consulta 3 & 4: Get DLP compliance rules with trainable classifiers
    try {
        Write-ZtProgress -Activity $activity -Status 'Verificando regras de DLP'
        $allDlpRules = Get-DlpComplianceRule -ErrorAction Stop

        # Filter rules that contain trainable classifiers (MLModel in AdvancedRule)
        $rulesWithMLModel = $allDlpRules | Where-Object { $_.AdvancedRule -match 'MLModel' }

        foreach ($rule in $rulesWithMLModel) {
            try {
                # Parse AdvancedRule JSON to extract classifier details
                $advancedRule = $rule.AdvancedRule | ConvertFrom-Json -ErrorAction Stop

                # Navigate to ContentContainsSensitiveInformation condition
                $sensitiveInfoCondition = $advancedRule.Condition.SubConditions | Where-Object {
                    $_.ConditionName -eq 'ContentContainsSensitiveInformation'
                }

                if ($sensitiveInfoCondition) {
                    # Extract trainable classifiers from Groups (Value is an array)
                    $trainableClassifiers = @()
                    foreach ($valueItem in $sensitiveInfoCondition.Value) {
                        foreach ($group in $valueItem.Groups) {
                            # Check all groups regardless of name (could be "Default", "Trainable Classifiers", etc.)
                            foreach ($classifier in $group.Sensitivetypes) {
                                if ($classifier.Classifiertype -eq 'MLModel') {
                                    $trainableClassifiers += $classifier.Name
                                }
                            }
                        }
                    }

                    if ($trainableClassifiers.Count -gt 0) {
                        # Deduplicate classifier names
                        $uniqueClassifiers = $trainableClassifiers | Select-Object -Unique
                        $dlpRulesWithClassifiers += [PSCustomObject]@{
                            RuleName          = $rule.Name
                            ParentPolicyName  = $rule.ParentPolicyName
                            CreatedDate       = $rule.WhenCreatedUTC
                            Classifiers       = $uniqueClassifiers
                        }
                    }
                }
            }
            catch {
                Write-PSFMessage "Falha ao analisar AdvancedRule para regra de DLP '$($rule.Name)': $_" -Tag Test -Level Warning

                # Fallback: this rule matched 'MLModel' via string search, so record it even if JSON parsing failed
                $dlpRulesWithClassifiers += [PSCustomObject]@{
                    RuleName          = $rule.Name
                    ParentPolicyName  = $rule.ParentPolicyName
                    CreatedDate       = $rule.WhenCreatedUTC
                    Classifiers       = @('Unknown (AdvancedRule parse failed)')
                }
            }
        }
    }
    catch {
        $dlpCmdletFailed = $true
        Write-PSFMessage "Falha ao recuperar regras de conformidade de DLP: $_" -Tag Test -Level Warning
    }
    #endregion Data Collection

    #region Assessment Logic
    $testResultMarkdown = ''
    $passed = $false
    $customStatus = $null

    $totalRulesWithClassifiers = $autoLabelRulesWithClassifiers.Count + $dlpRulesWithClassifiers.Count

    # Check if both cmdlets failed
    if ($autoLabelCmdletFailed -and $dlpCmdletFailed) {
        $testResultMarkdown = "⚠️ Não foi possível determinar o uso de classificador treinável devido a problemas de permissão ou falha de conexão com o serviço.`n`n%TestResult%"
        $passed = $false
        $customStatus = 'Investigate'
    }
    # Check if one cmdlet failed but we have some results
    elseif ($autoLabelCmdletFailed -or $dlpCmdletFailed) {
        $failedQuery = if ($autoLabelCmdletFailed) { 'regras de etiqueta automática' } else { 'regras de DLP' }
        $testResultMarkdown = "⚠️ Não foi possível recuperar $failedQuery devido a falha na consulta, problemas de conexão ou permissões insuficientes.`n`n%TestResult%"
        $passed = if ($totalRulesWithClassifiers -gt 0) { $true } else { $false }
        $customStatus = 'Investigate'
    }
    # Check if any rules use trainable classifiers
    elseif ($totalRulesWithClassifiers -eq 0) {
        $testResultMarkdown = "❌ Nenhum classificador treinável está sendo usado em políticas de etiqueta automática ou DLP; confiando apenas em classificação baseada em padrão.`n`n%TestResult%"
        $passed = $false
    }
    else {
        $testResultMarkdown = "✅ Os classificadores treináveis estão integrados nas políticas de etiqueta automática e/ou DLP, permitindo classificação de conteúdo com inteligência artificial para documentos comerciais complexos.`n`n%TestResult%"
        $passed = $true
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($totalRulesWithClassifiers -gt 0) {
        $formatTemplate = @'

## [{0}]({1})

{2}

    **Resumo:**
    * Total de Regras de Etiqueta Automática que Usam Classificadores: {3}
    * Total de Regras de DLP que Usam Classificadores: {4}

'@

        $reportTitle = 'Uso de Classificadores Treináveis em Políticas'
        $portalLink = 'https://purview.microsoft.com/informationprotection/dataclassification/trainableclassifiers'

        # Build details section
        $details = ''

        # Auto-Labeling Rules
        if ($autoLabelRulesWithClassifiers.Count -gt 0) {
            $details += "**Classificadores Treináveis em Regras de Etiqueta Automática:**`n`n"
            $details += "| Nome da regra | Política principal | Data de criação | Classificadores na regra |`n"
            $details += "| :-------- | :------------ | :----------- | :------------------ |`n"

            foreach ($rule in $autoLabelRulesWithClassifiers) {
                $ruleName = if ($rule.RuleName) { Get-SafeMarkdown -Text $rule.RuleName } else { 'N/A' }
                $policyName = if ($rule.ParentPolicyName) { Get-SafeMarkdown -Text $rule.ParentPolicyName } else { 'N/A' }
                $createdDate = if ($rule.CreatedDate) { $rule.CreatedDate.ToString('yyyy-MM-dd') } else { 'N/A' }

                if ($rule.Classifiers) {
                    $sanitizedClassifiers = $rule.Classifiers | ForEach-Object { Get-SafeMarkdown -Text $_ }
                    if (@($sanitizedClassifiers).Count -gt 5) {
                        $classifiers = ($sanitizedClassifiers[0..4] -join ', ') + ', ...'
                    }
                    else {
                        $classifiers = $sanitizedClassifiers -join ', '
                    }
                }
                else {
                    $classifiers = 'N/A'
                }

                $details += "| $ruleName | $policyName | $createdDate | $classifiers |`n"
            }
            $details += "`n"
        }

        # DLP Rules
        if ($dlpRulesWithClassifiers.Count -gt 0) {
            $details += "**Classificadores Treináveis em Regras de DLP:**`n`n"
            $details += "| Nome da regra | Política principal | Data de criação | Classificadores na regra |`n"
            $details += "| :-------- | :------------ | :----------- | :------------------ |`n"

            foreach ($rule in $dlpRulesWithClassifiers) {
                $ruleName = if ($rule.RuleName) { Get-SafeMarkdown -Text $rule.RuleName } else { 'N/A' }
                $policyName = if ($rule.ParentPolicyName) { Get-SafeMarkdown -Text $rule.ParentPolicyName } else { 'N/A' }
                $createdDate = if ($rule.CreatedDate) { $rule.CreatedDate.ToString('yyyy-MM-dd') } else { 'N/A' }

                if ($rule.Classifiers) {
                    $sanitizedClassifiers = $rule.Classifiers | ForEach-Object { Get-SafeMarkdown -Text $_ }
                    if (@($sanitizedClassifiers).Count -gt 5) {
                        $classifiers = ($sanitizedClassifiers[0..4] -join ', ') + ', ...'
                    }
                    else {
                        $classifiers = $sanitizedClassifiers -join ', '
                    }
                }
                else {
                    $classifiers = 'N/A'
                }

                $details += "| $ruleName | $policyName | $createdDate | $classifiers |`n"
            }
            $details += "`n"
        }

        $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $details,
            $autoLabelRulesWithClassifiers.Count,
            $dlpRulesWithClassifiers.Count
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35036'
        Title  = 'Uso de Classificadores Treináveis em Políticas'
        Status = $passed
        Result = $testResultMarkdown
    }

    if ($null -ne $customStatus) {
        $params.CustomStatus = $customStatus
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
