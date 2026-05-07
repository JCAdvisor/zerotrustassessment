<#
.SYNOPSIS
    Os rótulos de criptografia de chave dupla estão configurados

.DESCRIPTION
    A criptografia de chave dupla (DKE) fornece uma camada adicional de proteção para dados altamente sensíveis, exigindo duas chaves para descriptografar conteúdo:
    uma gerenciada pela Microsoft e outra gerenciada pelo cliente. Essa abordagem de "manter sua própria chave" garante que a Microsoft não possa descriptografar conteúdo do cliente
    nem mesmo com compulsão legal, atendendo aos rigorosos requisitos regulatórios de soberania de dados e controle.

    No entanto, a DKE introduz complexidade operacional significativa, incluindo infraestrutura dedicada de serviço de chave, compatibilidade de recursos reduzida
    e aumento de carga de suporte. As organizações que implantam DKE devem manter 1-3 rótulos reservados para dados realmente críticos para a missão ou altamente
    regulados. A proliferação excessiva de rótulos DKE (4 ou mais rótulos) indica possível uso indevido e cria sobrecarga de gerenciamento, confusão do usuário
    sobre quando aplicar DKE versus criptografia padrão e reduz capacidades de colaboração.

    A DKE nunca deve ser implantada amplamente em conteúdo geral de negócios. O uso excessivo de DKE cria risco operacional onde a indisponibilidade do serviço de chave
    impede o acesso a documentos críticos para os negócios.

.NOTES
    Test ID: 35010
    Pillar: Data
    Risk Level: Low
#>

function Test-Assessment-35010 {
    [ZtTest(
        Category = 'Criptografia',
    	ImplementationCost = 'Médio',
    	Service = ('SecurityCompliance'),
    	MinimumLicense = ('Microsoft 365 E5'),
        Pillar = 'Dados',
        RiskLevel = 'Baixo',
        SfiPillar = 'Proteger locatários e sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 35010,
        Title = 'Os rótulos de criptografia de chave dupla estão configurados',
        UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando configuração de rótulo de criptografia de chave dupla (DKE)'
    Write-ZtProgress -Activity $activity -Status 'Consultando rótulos de sensibilidade'

    $allLabels = @()
    $errorMsg = $null
    $dkeLabelsCount = 0
    $totalLabelsCount = 0

    try {
            # Consulta Q1: Retrieve all sensitivity labels
        $labels = Get-Label -ErrorAction Stop | Select-Object -Property Name, Disabled, Capabilities, LabelActions

        # Extract and normalize data
        foreach ($label in $labels) {
            $isDkeEnabled = $label.Capabilities -contains "DoubleKeyEncryption"
            $dkeEndpointUrl = 'N/A'

            if ($isDkeEnabled) {
                # Extract DKE endpoint URL from LabelActions
                $labelActions = $label.LabelActions | ConvertFrom-Json
                $encryptLabelAction = $labelActions | Where-Object { $_.Type -eq "encrypt" }
                $dkeEndpointUrl = $encryptLabelAction.Settings | Where-Object { $_.Key -eq "doublekeyencryptionurl" } | Select-Object -ExpandProperty Value

                if ($null -eq $dkeEndpointUrl) {
                    $dkeEndpointUrl = 'N/A'
                }
            }

            $allLabels += [PSCustomObject]@{
                Name           = $label.Name
                Disabled       = $label.Disabled
                DkeEnabled     = $isDkeEnabled
                DkeEndpointUrl = $dkeEndpointUrl
            }
        }

        # Calculate counts
        $totalLabelsCount = $allLabels.Count
        $dkeLabelsCount = ($allLabels | Where-Object { $_.DkeEnabled }).Count
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar rótulos de sensibilidade: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $false
    $customStatus  = $null
    $testResultMarkdown = ''

    if ($errorMsg) {
        # Investigate scenario - Query failed
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ Não foi possível determinar a configuração de rótulo DKE devido a falha na consulta, problemas de conexão ou permissões insuficientes.`n`n%TestResult%"
    }
    elseif ($dkeLabelsCount -eq 0) {
        # Fail scenario - No DKE labels
        $passed = $false
        $testResultMarkdown = "❌ Nenhum rótulo DKE encontrado - a organização deve avaliar a implantação para dados críticos para a missão ou altamente regulados.`n`n%TestResult%"
    }
    elseif ($dkeLabelsCount -ge 1 -and $dkeLabelsCount -le 3) {
        # Pass scenario - 1-3 DKE labels
        $passed = $true
        $testResultMarkdown = "✅ Rótulos DKE implantados apropriadamente (1-3 rótulos para dados críticos para a missão e regulados).`n`n%TestResult%"
    }
    else {
        # Investigate scenario - 4+ DKE labels (excessive)
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ 4 ou mais rótulos DKE detectados - revise a justificativa comercial de cada rótulo para confirmar o uso apropriado; DKE excessivo além de dados críticos indica possível uso indevido.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($totalLabelsCount -gt 0) {
        $title = 'Detalhes do rótulo de sensibilidade'
        $portalLink = 'https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels'

        $formatTemplate = @'

### Resumo

- Total de rótulos de sensibilidade: {0}
- Rótulos com DKE habilitado: {1}

### [{2}]({3})

| Nome do rótulo | Desabilitado | DKE habilitado | URL do endpoint DKE |
|:-----------|:---------|:------------|:-----------------|
{4}

'@

        $tableRows = ''
        foreach ($label in $allLabels | Sort-Object -Property DkeEnabled -Descending) {
            $tableRows += "| $($label.Name) | $($label.Disabled) | $($label.DkeEnabled) | $($label.DkeEndpointUrl) |`n"
        }

        $mdInfo = $formatTemplate -f $totalLabelsCount, $dkeLabelsCount, $title, $portalLink, $tableRows.TrimEnd("`n")
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35010'
        Title  = 'Rótulos de Criptografia de Chave Dupla (DKE)'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add CustomStatus if status is 'Investigate'
    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
