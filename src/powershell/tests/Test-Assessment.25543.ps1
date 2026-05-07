<#
.SYNOPSIS
    Valida que o WAF do Azure Front Door está habilitado em modo Prevenção.

.DESCRIPTION
    Este teste valida que as políticas de Firewall de Aplicativo Web do Azure Front Door estão configuradas
    em modo Prevenção para bloquear ativamente solicitações maliciosas. Verifica todas as políticas WAF do Front Door
    em todas as assinaturas e relata o status do modo prevenção/detecção.

.NOTES
    Test ID: 25543
    Category: Azure Network Security
    Required API: Azure Front Door WAF Policies
#>

function Test-Assessment-25543 {
    [ZtTest(
        Category = 'Segurança de rede do Azure',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Azure WAF on Azure Front Door Premium SKU', 'Azure Standard SKU'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
        TenantType = ('Workforce'),
        TestId = 25543,
        Title = 'O WAF do Azure Front Door está Habilitado em Modo Prevenção',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando configuração de políticas WAF do Azure Front Door'

    # Check if connected to Azure
    Write-ZtProgress -Activity $activity -Status 'Verificando conexão com Azure'

    $azContext = Get-AzContext -ErrorAction SilentlyContinue
    if (-not $azContext) {
        Write-PSFMessage 'Não conectado ao Azure.' -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedAzure
        return
    }

    Write-ZtProgress -Activity $activity -Status 'Enumerando assinaturas'

    # Initialize variables
    $subscriptions = @()
    $policies = @()
    $anySuccessfulAccess = 0
    $apiVersion = "2025-03-01"

    try {
        $subscriptions = Get-AzSubscription -ErrorAction Stop
    }
    catch {
        Write-PSFMessage "Não foi possível recuperar as assinaturas do Azure: $_" -Level Warning
    }

    if ($subscriptions.Count -eq 0) {
        Write-PSFMessage "Nenhuma assinatura do Azure encontrada." -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NoAzureAccess
        return
    }

    # Collect WAF policies from all subscriptions
    foreach ($sub in $subscriptions) {
        Write-ZtProgress -Activity $activity -Status "Verificando assinatura: $($sub.Name)"

        $path = "/subscriptions/$($sub.Id)/providers/Microsoft.Network/FrontDoorWebApplicationFirewallPolicies?api-version=$apiVersion"
        $response = Invoke-AzRestMethod -Path $path -ErrorAction SilentlyContinue

        # Skip if request failed completely
        if (-not $response -or $null -eq $response.StatusCode) {
            Write-PSFMessage "Falha ao consultar assinatura '$($sub.Name)'. Ignorando." -Level Warning
            continue
        }

        # Handle access denied for this subscription - skip and continue to next
        if ($response.StatusCode -eq 403) {
            Write-PSFMessage "Acesso negado à assinatura '$($sub.Name)': HTTP $($response.StatusCode). Ignorando." -Level Verbose
            continue
        }

        # Handle other HTTP errors - skip this subscription
        if ($response.StatusCode -ge 400) {
            Write-PSFMessage "Erro ao consultar assinatura '$($sub.Name)': HTTP $($response.StatusCode). Ignorando." -Level Warning
            continue
        }

        # Count successful accesses
        $anySuccessfulAccess++

        # No content or no policies in this subscription
        if (-not $response.Content) {
            continue
        }

        $policiesJson = $response.Content | ConvertFrom-Json

        if (-not $policiesJson.value -or $policiesJson.value.Count -eq 0) {
            continue
        }

        # Collect policies from this subscription
        foreach ($policyResource in $policiesJson.value) {
            $policies += [PSCustomObject]@{
                SubscriptionId   = $sub.Id
                SubscriptionName = $sub.Name
                PolicyName       = $policyResource.name
                PolicyId         = $policyResource.id
                EnabledState     = $policyResource.properties.policySettings.enabledState
                Mode             = $policyResource.properties.policySettings.mode
            }
        }
    }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $false

    # Skip test if no policies found
    if ($policies.Count -eq 0) {
        if ($anySuccessfulAccess -eq 0) {
            # All subscriptions were inaccessible
            Write-PSFMessage "Nenhuma assinatura do Azure acessível encontrada." -Level Warning
            Add-ZtTestResultDetail -SkippedBecause NoAzureAccess
        } else {
            # Subscriptions accessible but no WAF policies deployed
            Write-PSFMessage "Nenhuma política WAF do Azure Front Door encontrada em assinaturas." -Tag Test -Level Verbose
            Add-ZtTestResultDetail -SkippedBecause NotApplicable
        }
        return
    }

    # Check if all policies are enabled and in Prevention mode
    $allCompliant = $true
    foreach ($policy in $policies) {
        if ($policy.EnabledState -ne 'Enabled' -or $policy.Mode -ne 'Prevention') {
            $allCompliant = $false
            break
        }
    }

    if ($allCompliant) {
        $passed = $true
        $testResultMarkdown = "✅ Todas as políticas WAF do Azure Front Door estão habilitadas em modo **Prevenção**.`n`n%TestResult%"
    }
    else {
        $passed = $false
        $testResultMarkdown = "❌ Uma ou mais políticas WAF do Azure Front Door estão em estado **Desabilitado** ou em modo **Detecção**.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    # Table title
    $reportTitle = 'Políticas WAF do Azure Front Door'
    $portalLink = "https://portal.azure.com/#view/Microsoft_Azure_HybridNetworking/FirewallManagerMenuBlade/~/wafMenuItem"

    # Prepare table rows
    $tableRows = ''
    foreach ($item in $policies) {
        $policyLink = "https://portal.azure.com/#resource$($item.PolicyId)"
        $subLink = "https://portal.azure.com/#resource/subscriptions/$($item.SubscriptionId)"
        $policyMd = "[$(Get-SafeMarkdown $item.PolicyName)]($policyLink)"
        $subMd = "[$(Get-SafeMarkdown $item.SubscriptionName)]($subLink)"

        # Calculate status indicators
        $policyStatus = if ($item.EnabledState -eq 'Enabled' -and $item.Mode -eq 'Prevention') { '✅' } else { '❌' }
        $modeDisplay = if ($item.Mode -eq 'Prevention') { '✅ Prevenção' } else { '❌ Detecção' }
        $enabledStateDisplay = if ($item.EnabledState -eq 'Enabled') { '✅ Habilitado' } else { '❌ Desabilitado' }

        $tableRows += "| $policyMd | $subMd | $enabledStateDisplay | $modeDisplay | $policyStatus |`n"
    }

    $formatTemplate = @'


## [{0}]({1})

| Nome da Política | Nome da Assinatura | Estado da Política | Modo | Status |
| :---------- | :---------------- | :----------: | :--: | :----: |
{2}

'@

    $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $tableRows.TrimEnd("`n")

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25543'
        Title  = 'O WAF do Azure Front Door está Habilitado em Modo Prevenção'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
