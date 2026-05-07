<#
.SYNOPSIS
    Os rótulos de sensibilidade estão configurados

.DESCRIPTION
    Este teste verifica se há pelo menos um rótulo de sensibilidade configurado no locaário.
    Sensitivity labels are the foundation of Microsoft Information Protection.

.NOTES
    Test ID: 35003
    Pillar: Data
    Risk Level: High
#>

function Test-Assessment-35003 {
    [ZtTest(
        Category = 'Rótulos de sensibilidade',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Microsoft 365 E3'),
    	Service = ('SecurityCompliance'),
        Pillar = 'Dados',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger locatários e sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 35003,
        Title = 'Os rótulos de sensibilidade estão configurados',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando Rótulos de Sensibilidade'
    Write-ZtProgress -Activity $activity -Status 'Obtendo Rótulos de Sensibilidade'

    $labels = @()
    $errorMsg = $null

    try {
            # Consulta: Get all sensitivity labels
        $labels = Get-Label -ErrorAction Stop
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Error querying Sensitivity Labels: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    if ($errorMsg) {
        $passed = $false
    }
    else {
        $passed = $labels.Count -gt 0
    }
    #endregion Assessment Logic

    #region Report Generation
    if ($errorMsg) {
        $testResultMarkdown = "### Investigate`n`n"
        $testResultMarkdown += "Não foi possível consultar rótulos de sensibilidade devido a erro: $errorMsg"
    }
    else {
        if ($passed) {
            $testResultMarkdown = "✅ Pelo menos um rótulo de sensibilidade está configurado no locaário.`n`n"
        }
        else {
            $testResultMarkdown = "❌ Nenhum rótulo de sensibilidade está configurado.`n`n"
        }

        $testResultMarkdown += "### Resumo da Configuração de Rótulo de Sensibilidade`n`n"
        $testResultMarkdown += "**Estatísticas de Rótulo:**`n"
        $testResultMarkdown += "* Contagem total de rótulos: $($labels.Count)`n"

        $topLevelCount = ($labels | Where-Object { [string]::IsNullOrEmpty($_.ParentId) }).Count
        $subLabelCount = ($labels | Where-Object { -not [string]::IsNullOrEmpty($_.ParentId) }).Count

        $testResultMarkdown += "* Contagem de rótulos de nível superior: $topLevelCount`n"
        $testResultMarkdown += "* Contagem de sub-rótulos: $subLabelCount`n`n"

        if ($labels.Count -gt 0) {
            $testResultMarkdown += "**Rótulos de exemplo** (até 5):`n"
            $testResultMarkdown += "| Nome do Rótulo | Prioridade | Rótulo Pai |`n"
            $testResultMarkdown += "|:---|:---|:---|`n"

            foreach ($label in ($labels | Select-Object -First 5)) {
                $parentName = if (-not [string]::IsNullOrEmpty($label.ParentLabelDisplayName)) { $label.ParentLabelDisplayName } else { "None" }
                $labelName = Get-SafeMarkdown -Text $label.DisplayName
                $parentName = Get-SafeMarkdown -Text $parentName
                $testResultMarkdown += "| $labelName | $($label.Priority) | $parentName |`n"
            }
        }

        $testResultMarkdown += "`n[Gerenciar Rótulos de Sensibilidade no Microsoft Purview](https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels)`n"
    }
    #endregion Report Generation

    $testResultDetail = @{
        TestId             = '35003'
        Title              = 'Total de Rótulos de Sensibilidade Configurados'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @testResultDetail
}
