<#
.SYNOPSIS
    Os rótulos de sensibilidade publicados globalmente não excedem o máximo recomendado

.DESCRIPTION
    As políticas de rótulo de sensibilidade controlam quais rótulos estão disponíveis para os usuários e podem ser escopo para usuários específicos, grupos ou toda a organização. Publicar muitos rótulos globalmente cria confusão e paralisia de decisão para os usuários finais. A Microsoft recomenda publicar no máximo 25 rótulos em políticas com escopo global para manter a usabilidade e reduzir o erro de classificação.

.NOTES
    Test ID: 35015
    Pillar: Data
    Risk Level: Medium
#>

function Test-Assessment-35015 {
    [ZtTest(
        Category = 'Rótulos de sensibilidade',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Microsoft 365 E3'),
    	Service = ('SecurityCompliance'),
        Pillar = 'Dados',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce'),
    	TestId = 35015,
        Title = 'Os rótulos de sensibilidade publicados globalmente não excedem o máximo recomendado',
        UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando contagem de rótulo de escopo global'

    # Q1: Get all enabled label policies
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de rótulo'

    $errorMsg = $null
    $maxRecommendedLabels = 25

    try {
        # Get all enabled label policies
        $labelPolicies = Get-LabelPolicy -WarningAction SilentlyContinue -ErrorAction Stop | Where-Object { $_.Enabled -eq $true }
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar políticas de rótulo: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $customStatus = $null
    if ($errorMsg) {
        $testResultMarkdown = "⚠️ Não foi possível determinar a contagem de rótulo global devido a problemas de permissões ou falha na consulta.`n`n"
        $customStatus = 'Investigate'
    }
    else {
        # Identify globally-scoped policies by checking all location names
        $globalPolicies = $labelPolicies | ForEach-Object {
            $policy = $_
            $allLocationNames = @(
                $policy.ExchangeLocation.Name
                $policy.ModernGroupLocation.Name
                $policy.SharePointLocation.Name
                $policy.OneDriveLocation.Name
                $policy.SkypeLocation.Name
                $policy.PublicFolderLocation.Name
            ) | Where-Object { $_ }
            $isGlobal = $allLocationNames -contains 'All'
            $scope = if ($isGlobal) { 'Global' } else { 'User/Group-Scoped' }

            $policy | Add-Member -MemberType NoteProperty -Name 'Scope' -Value $scope -PassThru
        } | Where-Object { $_.Scope -eq 'Global' }
        $uniqueLabels = $globalPolicies.Labels | Where-Object { $_ } | Select-Object -Unique
        $totalUniqueLabels = @($uniqueLabels).Count
        $passed = $totalUniqueLabels -le $maxRecommendedLabels
    }
    #endregion Assessment Logic

    #region Report Generation
    if ($errorMsg) {
        $testResultMarkdown = "### Investigar`n`n"
        $testResultMarkdown += "Não foi possível determinar a contagem de rótulos globais devido a erro: $errorMsg"
    }
    else {
        $status = if ($passed) { '✅' } else { '❌' }
        $statusText = if ($passed) { 'dentro' } else { 'excedendo' }
        $testResultMarkdown = "$status $totalUniqueLabels rótulos de sensibilidade são publicados em políticas com escopo global, $statusText o limite recomendado de $maxRecommendedLabels.`n`n"

        if ($globalPolicies) {
            $testResultMarkdown += "### [Políticas de rótulo global](https://purview.microsoft.com/informationprotection/labelpolicies)`n`n"
            $testResultMarkdown += "| Nome da política | Cargas de trabalho globais | Rótulos publicados | Exemplo de rótulos |`n"
            $testResultMarkdown += "| :--- | :--- | :---: | :--- |`n"

            $policyLink = "https://purview.microsoft.com/informationprotection/labelpolicies"

            foreach ($policy in $globalPolicies) {
                $policyName = Get-SafeMarkdown -Text $policy.Name
                $labelCount = @($policy.Labels).Count

                # Identify which workloads have "All" (Location Properties with "All")
                $globalWorkloads = @()
                if ($policy.ExchangeLocation.Name -contains 'All') { $globalWorkloads += 'Exchange' }
                if ($policy.SharePointLocation.Name -contains 'All') { $globalWorkloads += 'SharePoint' }
                if ($policy.OneDriveLocation.Name -contains 'All') { $globalWorkloads += 'OneDrive' }
                if ($policy.ModernGroupLocation.Name -contains 'All') { $globalWorkloads += 'ModernGroup' }
                if ($policy.SkypeLocation.Name -contains 'All') { $globalWorkloads += 'Skype' }

                $workloadsText = if ($globalWorkloads.Count -gt 0) {
                    $globalWorkloads -join ', '
                } else { 'Nenhum' }

                # Get sample labels (up to 5)
                $sampleLabels = if ($policy.Labels) {
                    $samples = @($policy.Labels | Select-Object -First 5)
                    $labelText = ($samples | ForEach-Object { Get-SafeMarkdown -Text $_ }) -join ', '
                    if (@($policy.Labels).Count -gt 5) { $labelText += ', ...' }
                    $labelText
                } else { 'Nenhum' }

                $testResultMarkdown += "| [$policyName]($policyLink) | $workloadsText | $labelCount | $sampleLabels |`n"
            }

            $statusText = if ($passed) { 'Aprovado' } else { 'Falhou' }
            $testResultMarkdown += "`n### Resumo`n`n"
            $testResultMarkdown += "* **Total de rótulos únicos publicados globalmente:** $totalUniqueLabels`n"
            $testResultMarkdown += "* **Máximo recomendado:** $maxRecommendedLabels`n"
            $testResultMarkdown += "* **Status:** $statusText`n"
            $testResultMarkdown += "`n*Nota: Os rótulos que aparecem em várias políticas globais são contados uma vez (desduplicados).*`n"
        } else {
            $testResultMarkdown += "Nenhuma política de rótulo com escopo global encontrada.`n"
        }
    }
    #endregion Report Generation

    $params = @{
        TestId = '35015'
        Title  = 'Contagem de rótulos de escopo global'
        Status = $passed
        Result = $testResultMarkdown
    }
    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }
    Add-ZtTestResultDetail @params
}
