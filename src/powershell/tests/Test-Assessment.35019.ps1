<#
.SYNOPSIS
    As políticas de aplicação automática de rótulos estão configuradas para todas as cargas de trabalho

.DESCRIPTION
    Quando as políticas de aplicação automática de rótulos não estão configuradas, as organizações não podem classificar automaticamente o conteúdo com base em tipos de informação sensível, padrões ou condições. Isso cria uma lacuna significativa de conformidade e segurança porque dados sensíveis dependem inteiramente da ação manual do usuário para classificação. As políticas de aplicação automática de rótulos classificam inteligentemente o conteúdo em todas as cargas de trabalho (emails do Outlook, caixas de correio do Exchange, sites do SharePoint, contas do OneDrive, canais do Teams e Power BI) com base em inspeção de conteúdo. Configurar pelo menos uma política de aplicação automática de rótulo para os tipos de dados mais sensíveis da organização é a base para classificação automatizada consistente.

.NOTES
    Test ID: 35019
    Pillar: Data
    Risk Level: High
#>

function Test-Assessment-35019 {
    [ZtTest(
    	Category = 'Proteção de Informações',
    	ImplementationCost = 'Médio',
    	CompatibleLicense = ('EXCHANGE_S_ENTERPRISE'),
    	Service = ('SecurityCompliance'),
    	Pillar = 'Dados',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce'),
    	TestId = 35019,
    	Title = 'As políticas de aplicação automática de rótulos estão configuradas para todas as cargas de trabalho',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando políticas de aplicação automática de rótulos'
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de aplicação automática de rótulos'

    $errorMsg = $null
    $policies = @()

    try {
        # Get all auto-labeling policies
        $policies = @(Get-AutoSensitivityLabelPolicy -ErrorAction Stop)
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar políticas de aplicação automática de rótulos: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $customStatus = $null
    if ($errorMsg) {
        $passed = $false
        $customStatus = 'Investigate'
    }
    else {
        $passed = $policies.Count -gt 0
    }
    #endregion Assessment Logic

    #region Report Generation
    if ($errorMsg) {
        $testResultMarkdown = "### Investigar`n`n"
        $testResultMarkdown += "Não foi possível determinar o status da política de aplicação automática de rótulos devido a erro: $errorMsg"
    }
    else {
        if ($passed) {
            $testResultMarkdown = "✅ $($policies.Count) política$(if ($policies.Count -eq 1) { ' de ' } else { 's de ' })aplicação automática de rótulo$(if ($policies.Count -eq 1) { 'existe' } else { 'existem' }) na organização, habilitando classificação automática de conteúdo.`n`n"

            $policyLink = "https://purview.microsoft.com/informationprotection/autolabeling"

            $testResultMarkdown += "### [Políticas de Aplicação Automática de Rótulos]($policyLink)`n`n"
            $testResultMarkdown += "| Nome da política | Descrição | Habilitada | Modo | Carga de trabalho | Criada | Última modificação |`n"
            $testResultMarkdown += "| :--- | :--- | :---: | :--- | :--- | :--- | :--- |`n"

            foreach ($policy in $policies) {
                $policyName = Get-SafeMarkdown -Text $policy.Name
                $description = if ($policy.Comment) { Get-SafeMarkdown -Text $policy.Comment } else { '' }
                $enabled = if ($policy.Enabled) { '✅' } else { '❌' }
                $mode = if ($policy.Mode) { $policy.Mode } else { 'Desconhecido' }
                $workload = if ($policy.Workload) { $policy.Workload } else { 'Não especificado' }
                $created = if ($policy.WhenCreatedUTC) { $policy.WhenCreatedUTC.ToString('yyyy-MM-dd') } else { 'Desconhecida' }
                $lastModified = if ($policy.WhenChangedUTC) { $policy.WhenChangedUTC.ToString('yyyy-MM-dd') } else { 'Desconhecida' }

                $testResultMarkdown += "| $policyName | $description | $enabled | $mode | $workload | $created | $lastModified |`n"
            }

            # Summary section
            $testResultMarkdown += "`n### Resumo`n`n"
            $testResultMarkdown += "* **Total de políticas de aplicação automática de rótulos:** $($policies.Count)`n"

            # Check which workloads are covered
            $workloads = $policies.Workload | Where-Object { $_ } | Select-Object -Unique
            $workloads = $workloads -split ', ' | ForEach-Object { $_.Trim() } | Select-Object -Unique
            $testResultMarkdown += "`n**Cargas de trabalho com políticas de aplicação automática de rótulos:**`n"
            $hasExchange = $workloads -contains 'Exchange'
            $hasSharePoint = $workloads -contains 'SharePoint'
            $hasOneDrive = $workloads -contains 'OneDriveForBusiness'
            $hasTeams = $workloads -contains 'Teams'
            $hasPowerBI = $workloads -contains 'PowerBI'

            $testResultMarkdown += "* Exchange/Outlook: [$(if ($hasExchange) { 'Sim' } else { 'Não' })]`n"
            $testResultMarkdown += "* SharePoint: [$(if ($hasSharePoint) { 'Sim' } else { 'Não' })]`n"
            $testResultMarkdown += "* OneDrive: [$(if ($hasOneDrive) { 'Sim' } else { 'Não' })]`n"
            $testResultMarkdown += "* Teams: [$(if ($hasTeams) { 'Sim' } else { 'Não' })]`n"
            $testResultMarkdown += "* Power BI: [$(if ($hasPowerBI) { 'Sim' } else { 'Não' })]`n"

            # Date range
            $createdDates = $policies.WhenCreatedUTC | Where-Object { $_ } | Sort-Object
            if ($createdDates) {
                $oldest = $createdDates[0].ToString('yyyy-MM-dd')
                $newest = $createdDates[-1].ToString('yyyy-MM-dd')
                $testResultMarkdown += "`n* **Intervalo de datas de criação das políticas:** $oldest até $newest`n"
            }

            $testResultMarkdown += "`n💡 **Nota:** Este teste valida apenas a existência de políticas. O Teste 35020 valida que pelo menos uma política está em modo de aplicação.`n"
        }
        else {
            $testResultMarkdown = "❌ Nenhuma política de aplicação automática de rótulos está configurada na organização.`n`n"
            $testResultMarkdown += "### Recomendação`n`n"
            $testResultMarkdown += "Configure políticas de aplicação automática de rótulos para classificar automaticamente o conteúdo com base em tipos de informação sensível. "
            $testResultMarkdown += "Acesse o [portal de políticas de aplicação automática de rótulos](https://purview.microsoft.com/informationprotection/autolabeling) para criar políticas.`n"
        }
    }
    #endregion Report Generation

    $params = @{
        TestId = '35019'
        Title  = 'Políticas de aplicação automática de rótulos configuradas (Todas as cargas de trabalho)'
        Status = $passed
        Result = $testResultMarkdown
    }
    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }
    Add-ZtTestResultDetail @params
}
