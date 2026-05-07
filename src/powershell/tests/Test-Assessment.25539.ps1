<#
.SYNOPSIS
    Valida se a Detecção de Intrusão está Ativada no Modo Negar no Azure Firewall.
.DESCRIPTION
    Este teste valida que as Políticas de Firewall do Azure têm a Detecção de Intrusão ativada no modo Negar.
    Verifica todas as políticas de firewall na assinatura e relata seu status de detecção de intrusão.
.NOTES
    Test ID: 25539
    Category: Azure Network Security
    Required API: Azure Firewall Policies
#>

function Test-Assessment-25539 {
    [ZtTest(
        Category = 'Segurança de rede do Azure',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Azure_Firewall_Premium'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce','External'),
        TestId = 25539,
        Title = 'A Inspeção de IDPS está Ativada no Modo Negar no Azure Firewall',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    #region Data Collection
    $activity = 'Detecção de Intrusão do Azure Firewall'
    Write-ZtProgress `
        -Activity $activity `
        -Status 'Verificando conexão do Azure'

    # Check if connected to Azure
    $azContext = Get-AzContext -ErrorAction SilentlyContinue
    if (-not $azContext) {
        Write-PSFMessage 'Not connected to Azure.' -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedAzure
        return
    }

    # Check the supported environment
    Write-ZtProgress -Activity $activity -Status 'Verificando ambiente do Azure'
    if ($azContext.Environment.Name -ne 'AzureCloud') {
        Write-PSFMessage 'Este teste é aplicável apenas para o ambiente AzureCloud.' -Tag Test -Level VeryVerbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable
        return
    }

    Write-ZtProgress -Activity $activity -Status 'Enumerando Políticas de Firewall'

        # Consulta subscriptions using REST API
    $resourceManagerUrl = $azContext.Environment.ResourceManagerUrl.TrimEnd('/')
    $subscriptionsUri = "$resourceManagerUrl/subscriptions?api-version=2025-03-01"

    try {
        $subscriptionsResponse = Invoke-AzRestMethod -Method GET -Uri $subscriptionsUri -ErrorAction Stop

        if ($subscriptionsResponse.StatusCode -eq 403) {
            Write-PSFMessage 'O usuário conectado não tem acesso para verificar assinaturas.' -Tag Firewall -Level Warning
            Add-ZtTestResultDetail -SkippedBecause NoAzureAccess
            return
        }

        if ($subscriptionsResponse.StatusCode -ge 400) {
            Write-PSFMessage "Falha na solicitação de assinaturas com código de status $($subscriptionsResponse.StatusCode)" -Tag Firewall -Level Warning
            Add-ZtTestResultDetail -SkippedBecause NoAzureAccess
            return
        }

        $subscriptionsContent = $subscriptionsResponse.Content
        $subscriptions = ($subscriptionsContent | ConvertFrom-Json).value
    }
    catch {
        Write-PSFMessage "Unable to enumerate subscriptions: $($_.Exception.Message)" -Tag Firewall -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NoAzureAccess
        return
    }

    $results = @()

    foreach ($sub in $subscriptions) {

        # Switch subscription context
        try {
            Set-AzContext -SubscriptionId $sub.subscriptionId -ErrorAction Stop | Out-Null
        }
        catch {
            Write-PSFMessage "Não foi possível mudar para a assinatura $($sub.displayName): $($_.Exception.Message)" -Tag Firewall -Level Warning
            continue
        }

            # Consulta Azure Firewall Policies
        try {
            $policiesUri = "$resourceManagerUrl/subscriptions/$($sub.subscriptionId)/providers/Microsoft.Network/firewallPolicies?api-version=2025-03-01"
            Write-ZtProgress -Activity $activity -Status "Enumerando políticas na assinatura $($sub.displayName)"

            $policyResponse = Invoke-AzRestMethod -Method GET -Uri $policiesUri -ErrorAction Stop

            if ($policyResponse.StatusCode -eq 403) {
                Write-PSFMessage "Access denied to firewall policies in subscription $($sub.displayName): Insufficient permissions" -Tag Firewall -Level Warning
                continue
            }

            if ($policyResponse.StatusCode -ge 400) {
                Write-PSFMessage "Firewall policies request failed with status code $($policyResponse.StatusCode)" -Tag Firewall -Level Warning
                continue
            }

            $policyResponseContent = $policyResponse.Content
            if (-not $policyResponseContent) {
                Write-PSFMessage "No response content for policies in subscription $($sub.displayName)" -Tag Firewall -Level Warning
                continue
            }

            $policies = ($policyResponseContent | ConvertFrom-Json).value
        }
        catch {
            Write-PSFMessage "Unable to enumerate firewall policies in subscription $($sub.displayName): $($_.Exception.Message)" -Tag Firewall -Level Warning
            continue
        }

        if (-not $policies) { continue }

        # Get individual firewall policy details
        $detailedPolicies = @()
        foreach ($policyResource in $policies) {
            try {
                $detailUri = "$resourceManagerUrl$($policyResource.id)?api-version=2025-03-01"
                $detailResponse = Invoke-AzRestMethod -Method GET -Uri $detailUri -ErrorAction Stop

                if ($detailResponse.StatusCode -eq 403) {
                    Write-PSFMessage "Access denied to firewall policy details in subscription $($sub.displayName): Insufficient permissions" -Tag Firewall -Level Warning
                    continue
                }

                if ($detailResponse.StatusCode -ge 400) {
                    Write-PSFMessage "Firewall policy details request failed with status code $($detailResponse.StatusCode)" -Tag Firewall -Level Warning
                    continue
                }

                $detailResponseContent = $detailResponse.Content
                if (-not $detailResponseContent) {
                    Write-PSFMessage "No response content for policy $($policyResource.name) in subscription $($sub.displayName)" -Tag Firewall -Level Warning
                    continue
                }

                $detailedPolicy = $detailResponseContent | ConvertFrom-Json
                $detailedPolicies += $detailedPolicy
            }
            catch {
                Write-PSFMessage "Unable to get detailed policy information for $($policyResource.name) in subscription $($sub.displayName): $($_.Exception.Message)" -Tag Firewall -Level Warning
            }
        }

        # Check intrusion detection mode for each firewall policy
        foreach ($policyResource in $detailedPolicies) {

            # Skip if policy is missing required properties
            if (-not $policyResource -or -not $policyResource.name -or -not $policyResource.Id -or -not $policyResource.properties) {
                Write-PSFMessage "Firewall policy is missing required properties. Skipping." -Tag Firewall -Level Verbose
                continue
            }

            # Skip if SKU tier is not Premium
            if ($policyResource.properties.sku.tier -ne 'Premium') {
                Write-PSFMessage "Firewall policy '$($policyResource.name)' does not have Premium SKU. Skipping." -Tag Firewall -Level Verbose
                continue
            }

            # Get intrusion detection mode - if not configured, it's disabled by default (FAIL)
            $idMode = if ($policyResource.properties.intrusionDetection) {
                $policyResource.properties.intrusionDetection.mode
            } else {
                'Off'
            }
            # Map intrusion detection mode to user-friendly display values
            $detectionModeDisplay = switch ($idMode) {
                'Deny' { 'Alert and Deny' }
                'Alert' { 'Alert Only' }
                'Off' { 'Disabled' }
            }

            $subContext = Get-AzContext

            $results += [PSCustomObject]@{
                PolicyName             = $policyResource.Name
                SubscriptionName       = $subContext.Subscription.Name
                SubscriptionId         = $subContext.Subscription.Id
                IntrusionDetectionMode = $detectionModeDisplay
                PolicyID               = $policyResource.Id
                Passed                 = $idMode -eq 'Deny'
            }
        }
    }
    #endregion Data Collection

    #region Assessment Logic

    # If no Premium firewall policies found, skip the test
    if ($results.Count -eq 0) {
        Write-PSFMessage 'No Azure Firewall Premium policies found to evaluate.' -Tag Firewall -Level Verbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable
        return
    }

    $failedPolicies = @($results | Where-Object { -not $_.Passed })
    $passed = $failedPolicies.Count -eq 0

    if ($passed) {
        $testResultMarkdown = "A inspeção do Sistema de Detecção e Prevenção de Intrusões (IDPS) está definida como Negar para as políticas do Azure Firewall.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "A inspeção do Sistema de Detecção e Prevenção de Intrusões (IDPS) não está definida como Negar para as políticas do Azure Firewall.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    $reportTitle = "Políticas de firewall"
    $tableRows = ""
    $mdInfo = ""

    if ($results.Count -gt 0) {
                # Criar uma here-string com placeholders de formatação {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da política | Nome da assinatura | Resultado |
| :--- | :--- | :--- |
{1}

'@

        foreach ($item in $results | Sort-Object PolicyName) {
            $policyLink = "https://portal.azure.com/#resource$($item.PolicyID)"
            $subLink = "https://portal.azure.com/#resource/subscriptions/$($item.SubscriptionId)"
            $policyMd = "[$(Get-SafeMarkdown -Text $item.PolicyName)]($policyLink)"
            $subMd = "[$(Get-SafeMarkdown -Text $item.SubscriptionName)]($subLink)"
            $icon = if ($item.Passed) { '✅' } else { '❌' }
            $resultText = "$icon $($item.IntrusionDetectionMode)"
            $tableRows += "| $policyMd | $subMd | $resultText |`n"
        }

                 # Formatar o template substituindo os placeholders pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25539'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
