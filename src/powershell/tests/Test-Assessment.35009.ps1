<#
.SYNOPSIS
    A coautoria está habilitada para documentos criptografados
#>

function Test-Assessment-35009 {
    [ZtTest(
        Category = 'Rótulos de sensibilidade',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Microsoft 365 E5'),
    	Service = ('SecurityCompliance'),
        Pillar = 'Dados',
        RiskLevel = 'Baixo',
        SfiPillar = 'Proteger locatários e sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 35009,
        Title = 'A coautoria está habilitada para arquivos criptografados com rótulos de sensibilidade',
        UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se a coautoria está habilitada para documentos criptografados"
    Write-ZtProgress -Activity $activity -Status "Obtendo configuração de política"

    $cmdletFailed = $false

    # Q1: Retrieve policy configuration settings
    try {
        $policyConfig = Get-PolicyConfig -ErrorAction Stop
    }
    catch {
        Write-PSFMessage "Falha ao recuperar configuração de política: $_" -Tag Test -Level Warning
        $cmdletFailed = $true
    }

    # Q2: Check EnableLabelCoauth property value
    if (-not $cmdletFailed) {
        $enableLabelCoauth = $policyConfig.EnableLabelCoauth
    }

    #endregion Data Collection

    #region Assessment Logic

    if ($cmdletFailed) {
        # Cmdlet failed - mark as Investigate
        $passed = $false
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ A configuração de política existe, mas a configuração EnableLabelCoauth não pode ser determinada.`n`n"
    }
    elseif ($enableLabelCoauth -eq $true) {
        $passed = $true
        $testResultMarkdown = "✅ A coautoria está habilitada para documentos criptografados com rótulos de sensibilidade.`n`n%TestResult%"
    }
    else{
        $passed = $false
        $testResultMarkdown = "❌ A coautoria está desabilitada para documentos criptografados.`n`n%TestResult%"
    }

    #endregion Assessment Logic

    #region Report Generation

    if (-not $cmdletFailed) {
        $reportDetails = ""
        $reportDetails += "`n`n## Detalhes de configuração`n`n"
        $reportDetails += "| Configuração | Status |`n"
        $reportDetails += "| :------ | :----- |`n"
        $statusDisplay = if ($enableLabelCoauth -eq $true) { '✅ Habilitado' } elseif ($enableLabelCoauth -eq $false) { '❌ Desabilitado' } else { '-' }
        $reportDetails += "| EnableLabelCoauth | $statusDisplay |`n"

        $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $reportDetails
    }

    #endregion Report Generation

    $params = @{
        TestId = '35009'
        Title  = 'Coautoria habilitada para documentos criptografados'
        Status = $passed
        Result = $testResultMarkdown
    }
    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }

    Add-ZtTestResultDetail @params

}
