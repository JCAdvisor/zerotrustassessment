<#
.SYNOPSIS
    Validates that Universal Tenant Restrictions (UTR) are configured to block access to unauthorized external tenants.

.DESCRIPTION
    This test checks if Universal Tenant Restrictions are properly configured by verifying:
    1. Global Secure Access network packet tagging is enabled
    2. Tenant restrictions v2 default policy blocks all users and all applications

.NOTES
    Test ID: 25377
    Category: Global Secure Access
    Required API: networkAccess/settings/crossTenantAccess (beta), policies/crossTenantAccessPolicy/default (beta)
#>

function Test-Assessment-25377 {
    [ZtTest(
        Category = 'Acesso Seguro Global',
        ImplementationCost = 'Médio',
    	MinimumLicense = ('AAD_PREMIUM','Entra_Premium_Internet_Access'),
    	CompatibleLicense = ('Entra_Premium_Internet_Access'),
        Pillar = 'Rede',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce','External'),
    	TestId = 25377,
        Title = 'As restrições universais de locatário bloqueiam o acesso externo não autorizado',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param($Database)

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    $activity = 'Verificando a configuração de Restrições Universais de Locatário'
    Write-ZtProgress -Activity $activity -Status 'Consultando o status de marcação de pacotes de rede do Global Secure Access'

    # Q1: Get Global Secure Access Universal Tenant Restrictions status
    try {
        $crossTenantAccessSettings = Invoke-ZtGraphRequest -RelativeUri 'networkAccess/settings/crossTenantAccess' -ApiVersion beta -ErrorAction Stop
        $networkPacketTaggingStatus = $crossTenantAccessSettings.networkPacketTaggingStatus
    }
    catch {
        Write-PSFMessage "Falha ao recuperar as configurações de acesso entre locatários do Global Secure Access: $_" -Tag Test -Level Warning
        $networkPacketTaggingStatus = $null
    }

    Write-ZtProgress -Activity $activity -Status 'Consultando a política padrão de restrições de locatário v2'

    # Q2: Get default cross-tenant access policy tenant restrictions configuration
    try {
        $defaultCrossTenantPolicy = Invoke-ZtGraphRequest -RelativeUri 'policies/crossTenantAccessPolicy/default' -ApiVersion beta -ErrorAction Stop
        $tenantRestrictions = $defaultCrossTenantPolicy.tenantRestrictions
    }
    catch {
        Write-PSFMessage "Falha ao recuperar a política de acesso entre locatários: $_" -Tag Test -Level Warning
        $tenantRestrictions = $null
    }
    #endregion Data Collection

    #region Assessment Logic
    $testResultMarkdown = ''
    $passed = $false

    # Check Q1: Network packet tagging must be enabled
    if ($null -eq $networkPacketTaggingStatus -or $networkPacketTaggingStatus -ne 'enabled') {
        $statusText = if ($null -eq $networkPacketTaggingStatus) {
            'not configured'
        }
        else {
            $networkPacketTaggingStatus
        }
        $testResultMarkdown = "❌ As Restrições Universais de Locatário não estão totalmente configuradas. A marcação de pacotes de rede está $statusText (esperado: enabled). `n`n%TestResult%"
        $passed = $false
    }
    else {
        # Check if tenant restrictions policy was retrieved successfully
        if ($null -eq $tenantRestrictions) {
            $testResultMarkdown = "❌ Não foi possível recuperar a política padrão de restrições de locatário v2. A marcação de pacotes de rede está habilitada, mas a configuração da política não pôde ser avaliada.`n`n%TestResult%"
            $passed = $false
        }
        else {
            # Validate usersAndGroups configuration
            $usersAndGroupsValid = $false
            if ($tenantRestrictions.usersAndGroups) {
                $usersAccessType = $tenantRestrictions.usersAndGroups.accessType
                $usersTargets = $tenantRestrictions.usersAndGroups.targets

                # Check if accessType is blocked and targets contain AllUsers
                if ($usersAccessType -eq 'blocked' -and $usersTargets) {
                    $usersAndGroupsValid = @($usersTargets.target) -contains 'AllUsers'
                }
            }

            # Validate applications configuration
            $applicationsValid = $false
            if ($tenantRestrictions.applications) {
                $appsAccessType = $tenantRestrictions.applications.accessType
                $appsTargets = $tenantRestrictions.applications.targets

                # Check if accessType is blocked and targets contain AllApplications
                if ($appsAccessType -eq 'blocked' -and $appsTargets) {
                    $applicationsValid = @($appsTargets.target) -contains 'AllApplications'
                }
            }

            # Both must be valid for test to pass
            if ($usersAndGroupsValid -and $applicationsValid) {
                $testResultMarkdown = "✅ As Restrições Universais de Locatário estão configuradas. A marcação de pacotes de rede está habilitada e a política padrão de restrições de locatário v2 bloqueia todos os usuários de acessar todas as aplicações em locatários externos não autorizados. `n`n%TestResult%"
                $passed = $true
            }
            else {
                $testResultMarkdown = "❌ As Restrições Universais de Locatário não estão totalmente configuradas. A política de restrições de locatário v2 não bloqueia todos os usuários e todas as aplicações por padrão. `n`n%TestResult%"
                $passed = $false
            }
        }
    }
    #endregion Assessment Logic

    #region Report Generation
    # Calculate all values and status icons
    # Network Packet Tagging
    $networkPacketDisplay = if ($null -eq $networkPacketTaggingStatus) { 'Não configurado' } else { $networkPacketTaggingStatus }
    $networkPacketIcon = if ($networkPacketTaggingStatus -eq 'enabled') { '✅' } else { '❌' }

    # Tipo de acesso de usuários e grupos
    $usersAccessTypeDisplay = if ($tenantRestrictions.usersAndGroups) { $tenantRestrictions.usersAndGroups.accessType } else { 'Não configurado' }
    $usersAccessIcon = if ($usersAccessTypeDisplay -eq 'blocked') { '✅' } else { '❌' }

    # Users & Groups Target - extract targets array (no GUID resolution for users)
    $usersTargetsArray = @()
    if ($tenantRestrictions.usersAndGroups.targets) {
        $usersTargetsArray = @($tenantRestrictions.usersAndGroups.targets | ForEach-Object { $_.target })
    }

    $usersTargetDisplay = if ($usersTargetsArray.Count -gt 0) { $usersTargetsArray[0] } else { '' }
    $usersTargetIcon = if ($usersTargetsArray -contains 'AllUsers') { '✅' } else { '❌' }

    # Tipo de acesso de aplicações
    $appsAccessTypeDisplay = if ($tenantRestrictions.applications) { $tenantRestrictions.applications.accessType } else { 'Não configurado' }
    $appsAccessIcon = if ($appsAccessTypeDisplay -eq 'blocked') { '✅' } else { '❌' }

    # Applications Target - extract targets array and resolve GUIDs
    $appsTargetsArray = @()
    if ($tenantRestrictions.applications.targets) {
        $appsTargetsArray = @($tenantRestrictions.applications.targets | ForEach-Object { $_.target })
    }

    # Resolve application GUIDs to display names
    $resolvedAppsArray = Get-ApplicationNameFromId -TargetsArray $appsTargetsArray -Database $Database

    # Display first 5 items with "..." if more exist
    $maxItems = 5
    $appsTargetDisplay = if ($resolvedAppsArray.Count -le $maxItems) {
        $resolvedAppsArray -join ', '
    } else {
        ($resolvedAppsArray[0..($maxItems - 1)] -join ', ') + ' ...'
    }
    $appsTargetIcon = if ($appsTargetsArray -contains 'AllApplications') { '✅' } else { '❌' }

    # Build configuration table using format template
    $formatTemplate = @'

## [{0}]({1})

| Setting | Current Value | Expected Value | Status |
| :------ | :------------ | :------------- | :----: |
{2}

'@

    $reportTitle = 'Configuração de Restrições Universais de Locatário'
    $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/TenantRestrictions.ReactView/isDefault~/true/name//id/'

        $tableRows = "| Status da marcação de pacotes de rede | $networkPacketDisplay | habilitado | $networkPacketIcon |`n"
    $tableRows += "| Tipo de acesso de usuários e grupos | $usersAccessTypeDisplay | bloqueado | $usersAccessIcon |`n"
    $tableRows += "| Destino de usuários e grupos | $usersTargetDisplay | AllUsers | $usersTargetIcon |`n"
    $tableRows += "| Tipo de acesso de aplicações | $appsAccessTypeDisplay | bloqueado | $appsAccessIcon |`n"
    $tableRows += "| Destino de aplicações | $appsTargetDisplay | AllApplications | $appsTargetIcon |"

    $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $tableRows

        # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25377'
        Title  = 'Usuários que acessam aplicações externas a partir de dispositivos corporativos são bloqueados, a menos que autorizados explicitamente pelas políticas de restrições de locatário'
        Status = $passed
        Result = $testResultMarkdown
    }

    # Add test result details
    Add-ZtTestResultDetail @params
}
