<#
.SYNOPSIS
    Os rótulos de sensibilidade com criptografia estão configurados

.DESCRIPTION
    Este teste verifica se existem rótulos de sensibilidade com criptografia habilitada:
    1. Recuperando todos os rótulos de sensibilidade com LabelActions
    2. Analisando JSON de LabelActions para identificar ações de criptografia
    3. Analisando configurações de criptografia (tipo, permissões, coautoria)

.NOTES
    Test ID: 35013
    Category: Sensitivity Labels Configuration
    Required Module: ExchangeOnlineManagement v3.5.1+
    Required Connection: Connect-IPPSSession
#>

function Test-Assessment-35013 {
    [ZtTest(
        Category = 'Configuração de rótulos de sensibilidade',
        ImplementationCost = 'Médio',
        Service = ('SecurityCompliance'),
        MinimumLicense = 'Microsoft 365 E3',
        Pillar = 'Dados',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger locatários e sistemas de produção',
        TenantType = ('Workforce', 'External'),
        TestId = 35013,
        Title = 'Os rótulos de sensibilidade com criptografia estão configurados',
        UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando rótulos de sensibilidade com criptografia habilitada'
    Write-ZtProgress -Activity $activity -Status 'Consultando rótulos de sensibilidade'

    $getCmdletFailed = $false
    $parsingFailed = $false
    $allLabels = $null
    $encryptedLabels = @()

        # Consulta: Get all sensitivity labels
    try {
        $allLabels = Get-Label -ErrorAction Stop

        # Parse LabelActions to extract encryption details
        foreach ($label in $allLabels) {
            try {
                $labelActions = $label.LabelActions | ConvertFrom-Json
                $encryptAction = $labelActions | Where-Object { $_.Type -eq 'encrypt' }

                if ($null -ne $encryptAction) {
                    # Check if encryption is disabled
                    $disabledSetting = $encryptAction.Settings | Where-Object { $_.Key -eq 'disabled' }
                    if ($disabledSetting -and $disabledSetting.Value -eq 'true') {
                        continue  # Skip this label as encryption is disabled
                    }

                    # Check if DKE using Capabilities property (more reliable than LabelActions)
                    $isDKE = $label.Capabilities -contains 'DoubleKeyEncryption'

                    # Extract encryption details from Settings array (Key-Value pairs)
                    $protectionTypeSetting = $encryptAction.Settings | Where-Object { $_.Key -eq 'protectiontype' }

                    # Determine encryption type
                    if ($isDKE) {
                        $encryptionType = 'dke'
                    }
                    elseif ($protectionTypeSetting) {
                        $encryptionType = $protectionTypeSetting.Value
                    }
                    else {
                        $encryptionType = 'template'
                    }

                    $rightsDefSetting = $encryptAction.Settings | Where-Object { $_.Key -eq 'rightsdefinitions' }
                    $rightsDef = if ($rightsDefSetting) { $rightsDefSetting.Value } else { 'Not specified' }

                    $contentExpirySetting = $encryptAction.Settings | Where-Object { $_.Key -eq 'contentexpiredondateindaysornever' }
                    $contentExpiry = if ($contentExpirySetting) { $contentExpirySetting.Value } else { 'Never' }

                    # Determine if co-authoring is blocked
                    $coAuthoringBlocked = ($encryptionType -eq 'dke') -or ($contentExpiry -ne 'Never')

                    $encryptedLabels += [PSCustomObject]@{
                        Name                  = $label.DisplayName
                        EncryptionType        = $encryptionType
                        RightsDefinitions     = $rightsDef
                        CoAuthoringBlocked    = if ($coAuthoringBlocked) { 'Sim' } else { 'Não' }
                    }
                }
            }
            catch {
                Write-PSFMessage "Falha ao analisar LabelActions para rótulo '$($label.DisplayName)': $_" -Tag Test -Level Warning
                $parsingFailed = $true
            }
        }
    }
    catch {
        $getCmdletFailed = $true
        Write-PSFMessage "Falha ao recuperar rótulos de sensibilidade: $_" -Tag Test -Level Warning
    }
    #endregion Data Collection

    #region Assessment Logic
    $testResultMarkdown = ''
    $passed = $false
    $customStatus = $null

    # Check if Get-Label cmdlet failed
    if ($getCmdletFailed) {
        $testResultMarkdown = "⚠️ Não foi possível determinar a configuração do rótulo com criptografia habilitada devido a falha na consulta, problemas de conexão ou permissões insuficientes.`n`n%TestResult%"
        $passed = $false
        $customStatus = 'Investigate'
    }
    # Check if labels were retrieved but parsing failed
    elseif ($parsingFailed) {
        $testResultMarkdown = "⚠️ Os rótulos existem, mas a configuração de criptografia não pode ser determinada para alguns rótulos.`n`n%TestResult%"
        $passed = $false
        $customStatus = 'Investigate'
    }
    # Check encrypted label count
    elseif ($encryptedLabels.Count -eq 0) {
        $testResultMarkdown = "❌ Nenhum rótulo com criptografia habilitada existe; todos os rótulos fornecem apenas classificação.`n`n%TestResult%"
        $passed = $false
    }
    else {
        $testResultMarkdown = "✅ Pelo menos um rótulo de sensibilidade com criptografia habilitada está configurado.`n`n%TestResult%"
        $passed = $true
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($encryptedLabels.Count -gt 0) {
        $formatTemplate = @'

## [{0}]({1})

| Nome do rótulo | Tipo de criptografia | Identidades com permissões padrão | Co-autoria bloqueada |
| :--------- | :-------------- | :----------------------------- | :------------------: |
{2}

'@

        $reportTitle = 'Detalhes do rótulo de criptografia'
        $portalLink = 'https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels'

        # Build table rows
        $labelDetails = ''
        foreach ($encLabel in $encryptedLabels) {
            $name = if ($encLabel.Name) { Get-SafeMarkdown -Text $encLabel.Name } else { 'N/A' }
            $encType = switch ($encLabel.EncryptionType) {
                'template' { 'Standard RMS' }
                'dke' { 'Double Key Encryption (DKE)' }
                'userdefined' { 'Definido pelo usuário' }
                default { $encLabel.EncryptionType }
            }

            # Format rights definitions - show first 5 identities (users, groups, or domains)
            $rights = 'Não especificado'
            if ($encLabel.RightsDefinitions -and $encLabel.RightsDefinitions -ne 'Not specified') {
                try {
                    # Parse the JSON string containing rights definitions
                    $rightsArray = $encLabel.RightsDefinitions | ConvertFrom-Json
                    if ($rightsArray) {
                        $identities = @($rightsArray | Where-Object { $_.Identity } | ForEach-Object { Get-SafeMarkdown -Text $_.Identity })
                        if ($identities.Count -gt 5) {
                            $rights = ($identities[0..4] -join ', ') + ', ...'
                        }
                        else {
                            $rights = $identities -join ', '
                        }
                    }
                }
                catch {
                    # If parsing fails, show fallback message
                    $rights = 'Não foi possível analisar permissões'
                }
            }

            $coAuthBlocked = $encLabel.CoAuthoringBlocked

            $labelDetails += "| $name | $encType | $rights | $coAuthBlocked |`n"
        }

        $labelDetails += "`n**Resumo:**`n"
        $labelDetails += "* Total de rótulos habilitados para criptografia: $($encryptedLabels.Count)`n"

        # Count by encryption type
        $standardRMS = @($encryptedLabels | Where-Object { $_.EncryptionType -eq 'template' }).Count
        $userDefined = @($encryptedLabels | Where-Object { $_.EncryptionType -eq 'userdefined' }).Count
        $dkeLabels = @($encryptedLabels | Where-Object { $_.EncryptionType -eq 'dke' }).Count

        $labelDetails += "* Standard RMS: $standardRMS`n"
        $labelDetails += "* Definido pelo usuário: $userDefined`n"
        $labelDetails += "* Double Key Encryption (DKE): $dkeLabels"

        $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $labelDetails
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35013'
        Title  = 'Rótulos habilitados para criptografia'
        Status = $passed
        Result = $testResultMarkdown
    }

    if ($null -ne $customStatus) {
        $params.CustomStatus = $customStatus
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
