<#
.SYNOPSIS
    Valida que as regras de bypass de inspeção de TLS são revisadas regularmente para evitar lacunas de proteção de segurança.

.DESCRIPTION
    Este teste verifica se as políticas de inspeção de TLS contendo regras de bypass personalizadas foram revisadas nos últimos 90 dias.
    security blind spots, as threat actors specifically target uninspected traffic channels.

.NOTES
    Test ID: 27001
    Category: Global Secure Access
    Required API: networkAccess/tlsInspectionPolicies
#>

function Test-Assessment-27001 {
    [ZtTest(
        Category = 'Acesso Seguro Global',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Entra_Premium_Internet_Access'),
    	CompatibleLicense = ('Entra_Premium_Internet_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 27001,
            Title = 'As regras de bypass de inspeção de TLS são revisadas regularmente',
            UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando status de revisão de política de inspeção de TLS'

        # Query 1: Retrieve all TLS Inspection Policies
    Write-ZtProgress -Activity $activity -Status 'Recuperando políticas de inspeção de TLS'

    $tlsInspectionPolicies = $null
    $errorMsg = $null
    try {
        $tlsInspectionPolicies = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/tlsInspectionPolicies?$expand=policyRules' -ApiVersion beta -ErrorAction Stop
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Não foi possível recuperar políticas de inspeção de TLS: $errorMsg" -Level Warning
    }

    if(-not $errorMsg){
        # Check if we got any policies
        if (-not $tlsInspectionPolicies -or $tlsInspectionPolicies.Count -eq 0) {
            Write-PSFMessage "Nenhuma política de inspeção de TLS encontrada." -Tag Test -Level Verbose
            Add-ZtTestResultDetail -SkippedBecause NotApplicable
            return
        }

        # Process each policy's expanded policy rules
        $policiesWithCustomBypass = @()

        foreach ($policy in $tlsInspectionPolicies) {
            Write-ZtProgress -Activity $activity -Status "Verificando política: $($policy.name)"

            $policyRules = $policy.policyRules

            if (-not $policyRules -or $policyRules.Count -eq 0) {
                continue
            }

            # Filter out auto-created system rules (description starts with "Auto-created TLS rule")
            $customRules = $policyRules | Where-Object {
                $_.description -notlike "Auto-created TLS rule*"
            }

            # Count custom bypass rules
            $customBypassRules = @($customRules | Where-Object { $_.action -eq 'bypass' })
            $customBypassCount = $customBypassRules.Count

            # Skip policies with no custom bypass rules
            if ($customBypassCount -eq 0) {
                continue
            }

            # Calculate days since last modified
            $daysSinceModified = ([datetime]::UtcNow - $policy.lastModifiedDateTime).Days

            $policiesWithCustomBypass += [PSCustomObject]@{
                PolicyName           = $policy.name
                LastModifiedDateTime = $policy.lastModifiedDateTime.ToString("yyyy-MM-ddTHH:mm:ss")
                DaysSinceModified    = $daysSinceModified
                CustomBypassCount    = $customBypassCount
                RequiresReview       = $daysSinceModified -gt 90
            }
        }
    }

    #endregion Data Collection

    #region Assessment Logic
    $passed = $false

    # Fail if there was an error retrieving policies
    if($errorMsg) {
        $passed = $false
        $testResultMarkdown = "❌ Unable to retrieve TLS inspection policies due to error:`n`n$errorMsg`n`n%TestResult%"
    }
    # Check if no policies with custom bypass rules were found
    elseif ($policiesWithCustomBypass.Count -eq 0) {
        $passed = $true
        $testResultMarkdown = "✅ Nenhuma política de inspeção de TLS com regras de bypass personalizadas encontrada.`n`n%TestResult%"
    }
    else {
        # Check if any policies require review
        $policiesRequiringReview = @($policiesWithCustomBypass | Where-Object { $_.RequiresReview -eq $true })

        if ($policiesRequiringReview.Count -gt 0) {
            $passed = $false
            $testResultMarkdown = "❌ Uma ou mais políticas de inspeção de TLS com regras de bypass personalizadas não foram modificadas há mais de 90 dias e requerem revisão.`n`n%TestResult%"
        }
        else {
            $passed = $true
            $testResultMarkdown = "✅ Todas as políticas de inspeção de TLS com regras de bypass personalizadas foram revisadas nos últimos 90 dias.`n`n%TestResult%"
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($policiesWithCustomBypass.Count -gt 0) {
        $reportTitle = 'Políticas de inspeção de TLS'
        $portalLink = 'https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/TLSInspectionPolicy.ReactView'

        # Prepare table rows
        $tableRows = ''
        foreach ($item in $policiesWithCustomBypass) {
            $lastModifiedDisplay = Get-FormattedDate -DateString $item.LastModifiedDateTime
            $reviewStatus = if ($item.RequiresReview) { '❌' } else { '✅' }

            $tableRows += "| $($item.PolicyName) | $lastModifiedDisplay | $($item.DaysSinceModified) | $($item.CustomBypassCount) | $reviewStatus |`n"
        }

        $totalCount = $policiesWithCustomBypass.Count
        $oldPoliciesCount = $policiesRequiringReview.Count

        $formatTemplate = @'

## [{0}]({1})

| Nome da política | Última modificação | Dias desde modificação | Contagem de regras de bypass personalizadas | Status |
| :---------- | :------------ | :------------------ | :----------------------- | :----- |
{2}

**Summary:**
- Total policies with custom bypass rules: {3}
- Policies older than 90 days: {4}
'@

        $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $tableRows, $totalCount, $oldPoliciesCount
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '27001'
        Title  = 'As regras de bypass de inspeção de TLS são revisadas regularmente para evitar lacunas de proteção de segurança'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
