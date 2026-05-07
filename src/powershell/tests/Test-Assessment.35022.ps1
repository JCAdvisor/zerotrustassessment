<#
.SYNOPSIS
    As varreduras sob demanda estão configuradas para descoberta de informações sensíveis

.DESCRIPTION
    Verifica se as varreduras sob demanda estão configuradas para descoberta de informações sensíveis no
    SharePoint, OneDrive e Exchange. Implementa resolução dinâmica de SIT GUID -> nome amigável
    e gera um resultado de markdown adequado para inclusão em relatórios de teste.

    Reference: https://learn.microsoft.com/en-us/purview/on-demand-classification

.NOTES
    Test ID: 35022
    Pillar: Data
    Risk Level: Medium
    User Impact: Low
    Implementation Cost: Medium
#>

function Test-Assessment-35022 {
    [ZtTest(
        Category = 'Information Protection',
        ImplementationCost = 'Medium',
        Service = ('SecurityCompliance'),
        CompatibleLicense = ('EXCHANGE_S_ENTERPRISE'),
        Pillar = 'Data',
        RiskLevel = 'Medium',
        SfiPillar = 'Protect tenants and production systems',
        TenantType = 'Workforce',
        TestId = 35022,
        Title = 'On-demand scans are configured for sensitive information discovery',
        UserImpact = 'Low'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando varreduras sob demanda configuradas para descoberta de informações sensíveis'
    Write-ZtProgress -Activity $activity -Status 'Obtendo catálogo SIT'

    $sitGuidMap = @{}
    $scansList = $null
    $errorMsg = $null

    try {
        # Build dynamic SIT catalog from tenant
        $sitCatalog = Get-DlpSensitiveInformationType -ErrorAction Stop
        foreach ($sit in $sitCatalog) {
            try {
                $id = $null
                $id = $sit.Identity
                $name = $sit.Name
                $sitGuidMap[$id] = $name
            }
            catch {
                # Ignore individual SIT failures, continue
            }
        }
    }
    catch {
        Write-PSFMessage "Aviso: Falha ao construir catálogo SIT de locatário: $($_.Exception.Message)" -Level Warning
    }

    # Fallback common SIT mapping
    $fallbackMap = @{
        '50842eb7-edc8-4019-85dd-5a5c1f2bb085' = 'Credit Card Number'
        'a44669fe-0d48-453d-a9b1-2cc83f2cba77' = 'U.S. Social Security Number (SSN)'
        'ed36cf51-9d63-40f3-a9a6-5a865c418d21' = 'U.S. Bank Account Number'
        '48ee9090-3f74-4238-89c9-6c0a93767a8f' = 'SWIFT Code'
        '50f56e32-3a6f-459f-82e9-e2b27b96b430' = 'Drivers License Number (U.S.)'
        '65ce4b3d-79b3-46c0-ba9d-8226d98130c8' = 'IBAN (International Banking Account Number)'
        '3b35900d-fd2d-446b-b3ad-b4723419e2d5' = 'ABA Routing Number'
        'f3dbc5dd-e2d4-4487-b43c-ebd87f349aa4' = 'Canada Social Insurance Number'
        'f87b75b6-570d-465d-a91a-f0d9b9e0b000' = 'U.K. National Insurance Number (NINO)'
        'b3a2fd72-cc1b-40fc-b0dc-6c5ca0e00f6f' = 'International Medical Record Number (MRN)'
    }

    Write-ZtProgress -Activity $activity -Status 'Obtendo varreduras sob demanda'

    try {
        $scansList = Get-SensitiveInformationScan -ErrorAction Stop
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar varreduras sob demanda: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $scanCount = 0
    $passed = $false
    $tableData = @()
    $statusCounts = @{}
    $hasSharePoint = 0
    $hasOneDrive = 0
    $hasExchange = 0
    $customStatus = $null
    $mostRecentScan = $null

    if ($errorMsg) {
        $passed = $false
    }
    else {
        $scanCount = @($scansList).Count
        $passed = $scanCount -ge 1
        if ($scanCount -gt 0) {
            foreach ($scan in $scansList) {
                # Use scan object directly - already contains full details from Get-SensitiveInformationScan
                # Normalize fields
                $name = $scan.Name
                $status = $scan.SensitiveInformationScanStatus

                # Workload may be string or array
                $workload = ''
                if ($scan.Workload -is [System.Collections.IEnumerable] -and -not ($scan.Workload -is [string])) {
                    $workload = ($scan.Workload -join ', ')
                }
                else {
                    $workload = $scan.Workload
                }

                # Parse ItemStatistics.SIT
                $sitDetails = @()
                # Put into list to simulate cmdlet output
                try {
                    if ($scan.ItemStatistics -and $scan.ItemStatistics.SIT) {
                        $sits = $scan.ItemStatistics.SIT

                        # Determine SIT keys depending on object type
                        if ($sits -is [System.Collections.IDictionary]) {
                            $sitKeys = $sits.Keys
                        }
                        elseif ($sits -is [PSCustomObject]) {
                            $sitKeys = $sits.PSObject.Properties | ForEach-Object { $_.Name }
                        }
                        else {
                            $sitKeys = @()
                        }

                        foreach ($guid in $sitKeys) {
                        $guidString = $guid.ToString().Trim()

                        # Obtain count for this GUID
                        $count = 0
                        if ($sits -is [System.Collections.IDictionary]) {
                            $count = $sits[$guid]
                        }
                        else {
                            try {
                                $count = $sits.$guid
                            }
                            catch {
                                $count = 0
                            }
                        }

                        # 🔹 SPEC RULE: Ignore SITs with zero matches
                        if (-not $count -or $count -le 0) {
                            continue
                        }

                        # Resolve SIT GUID to friendly name
                        $friendlyName = $null
                        if ($sitGuidMap.ContainsKey($guidString)) {
                            $friendlyName = $sitGuidMap[$guidString]
                        }
                        elseif ($fallbackMap.ContainsKey($guidString)) {
                            $friendlyName = $fallbackMap[$guidString]
                        }
                        else {
                            try {
                                $sitObj = Get-DlpSensitiveInformationType -Identity $guidString -ErrorAction SilentlyContinue
                                if ($sitObj) {
                                    if ($sitObj.PSObject.Properties['Name']) {
                                        $friendlyName = $sitObj.Name
                                    }
                                    elseif ($sitObj.PSObject.Properties['DisplayName']) {
                                        $friendlyName = $sitObj.DisplayName
                                    }
                                    else {
                                        $friendlyName = $sitObj.ToString()
                                    }
                                }
                            }
                            catch {}
                        }

                        if (-not $friendlyName) {
                            $friendlyName = "Unknown SIT - $guidString"
                        }

                        $sitDetails += "$friendlyName`: $count matches"
                    }
                    }
                }
                catch {

                }

                $sitString = if ($sitDetails.Count -gt 0) {
                    $sitDetails -join "; "
                }
                else {
                    'None'
                }

                $createdUtc = ''
                if ($scan.WhenCreatedUTC) {
                    $createdUtc = $scan.WhenCreatedUTC
                }
                $lastScanStart = ''
                if ($scan.LastScanStartTime) {
                    $lastScanStart = $scan.LastScanStartTime
                }

                # Build output row
                $row = [PSCustomObject]@{
                    Name              = $name
                    Status            = $status
                    Workload          = $workload
                    'SIT Detected'    = $sitString
                    'Created (UTC)'   = $createdUtc
                    'Last Scan Start' = $lastScanStart
                }
                $tableData += $row

                # Status counts
                if ($status -ne '') {
                    if ($statusCounts.ContainsKey($status)) {
                        $statusCounts[$status]++
                    }
                    else {
                        $statusCounts[$status] = 1
                    }
                }
            }
        }

        # Workload coverage counts
        $hasSharePoint = (@($scansList) | Where-Object { $_.Workload -and (($_.Workload -contains 'SharePoint') -or (($_.Workload -join ',') -match 'SharePoint')) }).Count
        $hasOneDrive = (@($scansList) | Where-Object { $_.Workload -and (($_.Workload -contains 'OneDrive') -or (($_.Workload -join ',') -match 'OneDrive')) }).Count
        $hasExchange = (@($scansList) | Where-Object { $_.Workload -and (($_.Workload -contains 'Exchange') -or (($_.Workload -join ',') -match 'Exchange')) }).Count

        # Most recent scan start
        $mostRecentScan = @($scansList) | Where-Object { $_.LastScanStartTime } | Sort-Object LastScanStartTime -Descending | Select-Object -First 1 | ForEach-Object { $_.LastScanStartTime }
    }


    #endregion Assessment Logic

    #region Report Generation
    $testResultMarkdown = ""

    if ($errorMsg) {
        $testResultMarkdown = "Não foi possível determinar a configuração de varredura sob demanda devido a problemas de permissões ou falha na consulta.`n`n"
        $customStatus = 'Investigate'
    }
    else {
        if ($passed) {
            $testResultMarkdown = "✅ Pelo menos uma varredura sob demanda está configurada na organização, habilitando descoberta e classificação de informações sensíveis históricas.`n`n"
        }
        else {
            $testResultMarkdown = "❌ Nenhuma varredura sob demanda está configurada na organização; dados sensíveis históricos não podem ser descobertos.`n`n"
        }

        $testResultMarkdown += "### Resumo de configuração de varredura sob demanda`n`n"

        if ($scanCount -gt 0 -and $tableData) {
            $testResultMarkdown += "**Detalhes da varredura:**`n`n"
            $testResultMarkdown += "| Nome | Status de varredura de informação sensível | Carga de trabalho | Tipos de informação sensível detectados  | Quando criado UTC | Hora Última de início da varredura |`n"
            $testResultMarkdown += "|------|--------|----------|--------------|---------------|-----------------|`n"

            foreach ($row in $tableData) {
                $nameEsc = $row.Name
                $statusEsc = $row.Status
                $workEsc = $row.Workload
                $sitEsc = $row.'SIT Detected'
                $created = if ($row.'Created (UTC)') {
                     Get-FormattedDate -DateString $row.'Created (UTC)'
                }
                else {
                    ''
                }
                $last = if ($row.'Last Scan Start') {
                     Get-FormattedDate -DateString $row.'Last Scan Start'
                }
                else {
                    ''
                }

                $testResultMarkdown += "| $nameEsc | $statusEsc | $workEsc | $sitEsc | $created | $last |`n"
            }

            $testResultMarkdown += "`n**Resumo:**`n`n"
            $testResultMarkdown += "* **Total de varreduras sob demanda configuradas:** $scanCount`n"
            $testResultMarkdown += "* **Varreduras por status:**`n"
            foreach ($status in ($statusCounts.Keys | Sort-Object)) {
                $testResultMarkdown += "  * $status`: $($statusCounts[$status])`n"
            }
            $testResultMarkdown += "* **Locais verificados:**`n"
            $testResultMarkdown += "  * SharePoint: $(if ($hasSharePoint -gt 0) { 'Sim' } else { 'Não' })`n"
            $testResultMarkdown += "  * OneDrive: $(if ($hasOneDrive -gt 0) { 'Sim' } else { 'Não' })`n"
            $testResultMarkdown += "  * Exchange: $(if ($hasExchange -gt 0) { 'Sim' } else { 'Não' })`n"
            $testResultMarkdown += "* **Conclusão de varredura mais recente:** $(if ($mostRecentScan) { $mostRecentScan } else { 'Sem varreduras concluídas' })`n"
        }
        else {
            $testResultMarkdown += "* **Total de varreduras sob demanda configuradas:** 0`n"
            $testResultMarkdown += "* **Status:** Nenhuma varredura está configurada`n"
        }

        $testResultMarkdown += "`n[Microsoft Purview Portal > Information Protection > Classifiers > On-demand classification](https://purview.microsoft.com/informationprotection/dataclassification/colddatascans)`n"
        $testResultMarkdown += "or"
        $testResultMarkdown += "`n[Microsoft Purview Portal > Data Loss Prevention > Classifiers > On-demand classification](https://purview.microsoft.com/datalossprevention/dataclassification/colddatascans)`n"

    }
    #endregion Report Generation

    $params = @{
        TestId = '35022'
        Title  = 'On-Demand scans configured for sensitive information discovery'
        Status = $passed
        Result = $testResultMarkdown
    }
     if ($null -ne $customStatus) {
        $params.CustomStatus = $customStatus
    }
    Add-ZtTestResultDetail @params
}
