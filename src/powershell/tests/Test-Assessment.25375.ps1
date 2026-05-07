<#
.SYNOPSIS
    Validates that GSA licenses are available in the tenant and assigned to users.

.DESCRIPTION
    This test checks whether Global Secure Access (GSA) licenses are provisioned in the tenant
    and actively assigned to users. It verifies:
    - GSA service plans exist in tenant subscribed SKUs
    - Licenses have capabilityStatus = "Enabled"
    - Licenses are assigned to at least one user
    - Service plans are not disabled for assigned users

.NOTES
    Test ID: 25375
    Category: Global Secure Access
    Required API: subscribedSkus (beta)
    Required Database: User table
    GSA Service Plan IDs:
    - Entra_Premium_Internet_Access: 8d23cb83-ab07-418f-8517-d7aca77307dc
    - Entra_Premium_Private_Access: f057aab1-b184-49b2-85c0-881b02a405c5
#>

function Test-Assessment-25375 {
    [ZtTest(
        Category = 'Acesso Seguro Global',
        ImplementationCost = 'Baixo',
    	MinimumLicense = ('Entra_Premium_Internet_Access','Entra_Premium_Private_Access'),
    	CompatibleLicense = ('Entra_Premium_Internet_Access','Entra_Premium_Private_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce'),
    	TestId = 25375,
    	Title = 'Licenças do Global Secure Access estão disponíveis no locatário e atribuídas aos usuários',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando disponibilidade e atribuição de licenças do Global Secure Access'
    Write-ZtProgress -Activity $activity -Status 'Consultando licenças do locatário'

    # GSA Service Plan IDs
    $gsaServicePlanIds = @{
        InternetAccess = '8d23cb83-ab07-418f-8517-d7aca77307dc' # Entra_Premium_Internet_Access
        PrivateAccess  = 'f057aab1-b184-49b2-85c0-881b02a405c5' # Entra_Premium_Private_Access
    }

    $skuCmdletFailed = $false
    $userCmdletFailed = $false
    $subscribedSkus = @()
    $userLicenses = @()

        # Consulta 1: Retrieve tenant licenses with GSA service plans
    try {
        $subscribedSkus = Invoke-ZtGraphRequest -RelativeUri 'subscribedSkus' -ApiVersion beta -ErrorAction Stop
    }
    catch {
        $skuCmdletFailed = $true
        Write-PSFMessage "Falha ao recuperar SKUs subscritos: $_" -Tag Test -Level Warning
    }

    Write-ZtProgress -Activity $activity -Status 'Consultando atribuições de licença de usuário'

        # Consulta 2: Retrieve all users with assigned licenses from database
    try {
        $sqlUsers = @"
SELECT
    u.id,
    u.displayName,
    u.userPrincipalName,
    unnest(u.assignedLicenses).skuId::VARCHAR AS skuId,
    unnest(u.assignedLicenses).disabledPlans AS disabledPlans
FROM "User" u
WHERE len(u.assignedLicenses) > 0
"@
        $userLicenses = @(Invoke-DatabaseQuery -Database $Database -Sql $sqlUsers -AsCustomObject -ErrorAction Stop)
        # Filter out any records with null IDs
        $userLicenses = @($userLicenses | Where-Object { $_.id })
    }
    catch {
        $userCmdletFailed = $true
        Write-PSFMessage "Falha ao recuperar usuários: $_" -Tag Test -Level Warning
    }
    #endregion Data Collection

    #region Assessment Logic
    $testResultMarkdown = ''
    $passed = $false
    $customStatus = $null

    # Handle any query failure - cannot determine license status
    if ($skuCmdletFailed -or $userCmdletFailed) {
        Write-PSFMessage "Não foi possível determinar os dados de licença do GSA devido a falha na consulta" -Tag Test -Level Warning
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ Não foi possível determinar a disponibilidade e atribuição de licenças do GSA devido à falha na consulta, problemas de conexão ou permissões insuficientes.`n`n"

        Add-ZtTestResultDetail -TestId '25375' -Title 'Licenças do GSA estão disponíveis no locatário e atribuídas aos usuários' -Status $false -Result $testResultMarkdown -CustomStatus $customStatus
        return
    }

    # Filter SKUs containing GSA service plans
    $gsaSkus = @($subscribedSkus | Where-Object {
        $_.ServicePlans | Where-Object { $_.ServicePlanId -in $gsaServicePlanIds.Values }
    })

    # Check if GSA licenses exist and are enabled
    $enabledGsaSkus = @($gsaSkus | Where-Object { $_.CapabilityStatus -eq 'Enabled' })

    if ($gsaSkus.Count -eq 0 -or $enabledGsaSkus.Count -eq 0) {
        # No GSA licenses available or not enabled - skip test
        Write-PSFMessage 'Não há licenças do GSA disponíveis neste locatário.' -Tag Test -Level Verbose
        Add-ZtTestResultDetail -SkippedBecause NotApplicable -Result 'Não há licenças do GSA disponíveis neste locatário.'
        return
    }

    Write-ZtProgress -Activity $activity -Status 'Analisando atribuições de licença de usuário'

    # Build SKU ID to SKU mapping and pre-filter service plans for performance
    $gsaSkuIds = @{}
    $internetAccessPlansBySku = @{}
    $privateAccessPlansBySku = @{}

    foreach ($sku in $enabledGsaSkus) {
        $skuIdString = $sku.SkuId.ToString().ToLower()
        $gsaSkuIds[$skuIdString] = $sku

        # Pre-filter service plans to avoid repeated Where-Object calls
        $internetPlan = $sku.ServicePlans | Where-Object { $_.ServicePlanId -eq $gsaServicePlanIds.InternetAccess }
        if ($internetPlan) {
            $internetAccessPlansBySku[$skuIdString] = $internetPlan
        }

        $privatePlan = $sku.ServicePlans | Where-Object { $_.ServicePlanId -eq $gsaServicePlanIds.PrivateAccess }
        if ($privatePlan) {
            $privateAccessPlansBySku[$skuIdString] = $privatePlan
        }
    }

    # Count users with GSA licenses assigned
    $usersWithInternetAccess = [System.Collections.Generic.List[object]]::new()
    $usersWithPrivateAccess = [System.Collections.Generic.List[object]]::new()
    $usersWithAnyGsa = [System.Collections.Generic.List[object]]::new()

    # Group licenses by user (since query returns one row per license)
    $userGroups = $userLicenses | Group-Object -Property id

    foreach ($userGroup in $userGroups) {
        $userId = $userGroup.Name
        $userLicenseRecords = $userGroup.Group
        $userDisplayName = $userLicenseRecords[0].displayName
        $userPrincipalName = $userLicenseRecords[0].userPrincipalName

        $hasInternetAccess = $false
        $hasPrivateAccess = $false

        foreach ($licenseRecord in $userLicenseRecords) {
            if (-not $licenseRecord.skuId) { continue }

            $userSkuId = $licenseRecord.skuId.ToString().ToLower()

            if ($gsaSkuIds.ContainsKey($userSkuId)) {
                $disabledPlans = if ($licenseRecord.disabledPlans) { $licenseRecord.disabledPlans } else { @() }

                # Check if Internet Access service plan is enabled
                if ($internetAccessPlansBySku.ContainsKey($userSkuId)) {
                    $internetPlan = $internetAccessPlansBySku[$userSkuId]
                    if ($internetPlan.ServicePlanId -notin $disabledPlans) {
                        $hasInternetAccess = $true
                    }
                }

                # Check if Private Access service plan is enabled
                if ($privateAccessPlansBySku.ContainsKey($userSkuId)) {
                    $privatePlan = $privateAccessPlansBySku[$userSkuId]
                    if ($privatePlan.ServicePlanId -notin $disabledPlans) {
                        $hasPrivateAccess = $true
                    }
                }
            }
        }

        # Create user object for display
        $userObj = [PSCustomObject]@{
            Id = $userId
            DisplayName = $userDisplayName
            UserPrincipalName = $userPrincipalName
        }

        if ($hasInternetAccess) {
            $usersWithInternetAccess.Add($userObj)
        }
        if ($hasPrivateAccess) {
            $usersWithPrivateAccess.Add($userObj)
        }
        if ($hasInternetAccess -or $hasPrivateAccess) {
            $usersWithAnyGsa.Add($userObj)
        }
    }

    $gsaUserCount = $usersWithAnyGsa.Count

    # Evaluate test result
    if ($gsaUserCount -eq 0) {
        # Licenses exist and enabled but not assigned to any user - fail
        $passed = $false
        $testResultMarkdown = "❌ As licenças do GSA estão disponíveis no locatário, mas não foram atribuídas a nenhum usuário.`n`n%TestResult%"
    }
    else {
        # Licenses exist, enabled, and assigned to at least one user - pass
        $passed = $true
        $testResultMarkdown = "✅ As licenças do GSA estão disponíveis e atribuídas a pelo menos um usuário.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build detailed information if we have valid license data
    $mdInfo = ''

    if ($null -ne $enabledGsaSkus -and $enabledGsaSkus.Count -gt 0) {
        $reportTitle = 'Licenças'
        $portalLink = 'https://admin.microsoft.com/Adminportal/Home#/licenses'

        $formatTemplate = @'

## [{0}]({1})

**Resumo de licenças do GSA:**

| SKU Name | Status | Available | Assigned |
| :------- | :----- | --------: | -------: |
{2}

**Planos de serviço do GSA detectados:**

| Service Plan | SKU |
| :----------- | :-- |
{3}

**Resumo de atribuição de usuários:**

| Metric | Value |
| :----- | ----: |
{4}

{5}
'@

        # Build SKU table
        $skuTableRows = ''
        foreach ($sku in $enabledGsaSkus) {
            $skuName = Get-SafeMarkdown -Text $sku.SkuPartNumber
            $status = Get-SafeMarkdown -Text $sku.CapabilityStatus
            $available = $sku.PrepaidUnits.Enabled
            $assigned = $sku.ConsumedUnits

            $skuTableRows += "| $skuName | $status | $available | $assigned |`n"
        }

        # Build service plan table
        $servicePlanTableRows = ''
        foreach ($sku in $enabledGsaSkus) {
            $gsaPlans = $sku.ServicePlans | Where-Object { $_.ServicePlanId -in $gsaServicePlanIds.Values }
            foreach ($plan in $gsaPlans) {
                $planName = Get-SafeMarkdown -Text $plan.ServicePlanName
                $skuName = Get-SafeMarkdown -Text $sku.SkuPartNumber

                $servicePlanTableRows += "| $planName | $skuName |`n"
            }
        }

        # Build user assignment summary
        $assignmentSummary = "| Users with GSA Internet Access | $($usersWithInternetAccess.Count) |`n"
        $assignmentSummary += "| Users with GSA Private Access | $($usersWithPrivateAccess.Count) |`n"
        $assignmentSummary += "| Total users with any GSA license | $gsaUserCount |`n"

        # Build user list (truncate at 10)
        $userListSection = ''
        if ($gsaUserCount -gt 0) {
            if ($gsaUserCount -gt 10) {
                $userListSection += "**Usuários com licenças do GSA (mostrando 10 de $gsaUserCount):**`n`n"
            }
            else {
                $userListSection += "**Usuários com licenças do GSA:**`n`n"
            }

            $userListSection += "| Display name | User principal name | Internet Access | Private Access |`n"
            $userListSection += "| :----------- | :------------------ | :-------------- | :------------- |`n"

            # Build HashSets for efficient ID lookups
            if ($usersWithInternetAccess.Count -gt 0) {
                $internetAccessIds = [System.Collections.Generic.HashSet[string]]::new([string[]]($usersWithInternetAccess.Id))
            } else {
                $internetAccessIds = [System.Collections.Generic.HashSet[string]]::new()
            }

            if ($usersWithPrivateAccess.Count -gt 0) {
                $privateAccessIds = [System.Collections.Generic.HashSet[string]]::new([string[]]($usersWithPrivateAccess.Id))
            } else {
                $privateAccessIds = [System.Collections.Generic.HashSet[string]]::new()
            }

            $displayUsers = $usersWithAnyGsa | Select-Object -First 10
            foreach ($user in $displayUsers) {
                $displayName = Get-SafeMarkdown -Text $user.DisplayName
                $upn = Get-SafeMarkdown -Text $user.UserPrincipalName
                $hasInternet = if ($internetAccessIds.Contains($user.Id)) { '✅' } else { '❌' }
                $hasPrivate = if ($privateAccessIds.Contains($user.Id)) { '✅' } else { '❌' }

                $userListSection += "| $displayName | $upn | $hasInternet | $hasPrivate |`n"
            }

            if ($gsaUserCount -gt 10) {
                $userListSection += "| ... | | | |`n`n"
                $userListSection += "Ver todos os usuários no [Microsoft 365 admin center - Licenses](https://admin.microsoft.com/Adminportal/Home#/licenses)"
            }
        }

        $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $skuTableRows, $servicePlanTableRows, $assignmentSummary, $userListSection
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25375'
        Title  = 'Licenças do GSA estão disponíveis no locatário e atribuídas aos usuários'
        Status = $passed
        Result = $testResultMarkdown
    }
    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }
    Add-ZtTestResultDetail @params
}
