<#
.SYNOPSIS
    A associação de superusuário está configurada para o Azure Information Protection

.DESCRIPTION
    Avalia se o recurso de superusuário do Azure Information Protection (AIP) está configurado corretamente.

    Os cmdlets exigem o módulo AipService (v3.0+) que só tem suporte no Windows PowerShell 5.1. Uma solução alternativa do processo do PowerShell 7 é empregada automaticamente se estiver em execução no PowerShell Core.

.NOTES
    Test ID: 35011
    Pillar: Data
    Risk Level: Medium
#>

function Test-Assessment-35011 {
    [ZtTest(
        Category = 'Recursos avançados de rótulos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Microsoft 365 E5'),
    	Service = ('AipService','Graph'),
        Pillar = 'Dados',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger locatários e sistemas de produção',
    	TenantType = ('Workforce','External'),
    	TestId = 35011,
        Title = 'A associação de superusuário está configurada para o Microsoft Purview Information Protection',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando configuração de superusuário do Azure Information Protection'
    Write-ZtProgress -Activity $activity -Status 'Consultando configurações de superusuário AIP'

    $superUserFeatureEnabled = $null
    $superUsers = @()
    $superUserObjects = @()
    $errorMsg = $null

    try {
        # Note: AipService must be authenticated in Connect-ZtAssessment first
        # This test only performs queries against the authenticated service

            # Consulta Q1: Check if super user feature is enabled
        $superUserFeatureRaw = Get-AipServiceSuperUserFeature -ErrorAction Stop
        $superUserFeatureEnabled = $superUserFeatureRaw.Value

            # Consulta Q2: Get list of configured super users
        $superUsers = Get-AipServiceSuperUser -ErrorAction Stop

        # Process superusers and create PSObjects with type classification
        foreach ($superUser in $superUsers) {
            # Split superuser on @ to extract the appId (for service principals) or email (for users)
            $userIdentifier = $superUser -split '@' | Select-Object -First 1

            # Check if the identifier is a GUID (service principal) or email/UPN (user)
            $parsedGuid = [Guid]::Empty
            $isGuid = [Guid]::TryParse($userIdentifier, [ref]$parsedGuid)
            $accountType = if ($isGuid) { 'Service Principal' } else { 'User' }

            # For users, display the full email; for service principals, will be updated with lookup result
            $displayName = if ($isGuid) { $userIdentifier } else { $superUser }
            $servicePrincipalName = $null
            $objectId = $null

            # If it's a service principal, lookup the display name via Graph API
            if ($isGuid) {
                try {
                    $spDetails = Invoke-ZtGraphRequest -RelativeUri 'servicePrincipals' -ApiVersion 'beta' -Filter "appId eq '$userIdentifier'" -Select 'id,displayName,appDisplayName,servicePrincipalNames' -ErrorAction SilentlyContinue

                    if ($spDetails) {
                        # Prefer appDisplayName, then displayName, then the GUID
                        $servicePrincipalName = $spDetails.appDisplayName
                        if (-not $servicePrincipalName) {
                            $servicePrincipalName = $spDetails.displayName
                        }

                        if ($servicePrincipalName) {
                            $displayName = $servicePrincipalName
                        }
                        else {
                            $displayName = $userIdentifier
                        }

                        # Capture the service principal's object ID
                        if ($spDetails.id) {
                            $objectId = $spDetails.id
                        }
                    }
                }
                catch {
                    Write-PSFMessage "Aviso: Não foi possível procurar detalhes do principal de serviço para $userIdentifier : $_" -Tag Test -Level Warning
                }
            }

            $superUserObj = [PSCustomObject]@{
                DisplayName        = $displayName
                AccountType        = $accountType
                AppId              = $userIdentifier
                Id                 = $objectId
                IsServicePrincipal = $isGuid
            }

            $superUserObjects += $superUserObj
        }
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar configuração de superusuário AIP: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $false
    $investigateFlag = $false
    $superUserCount = if ($superUsers) { @($superUsers).Count } else { 0 }

    if ($errorMsg) {
        $investigateFlag = $true
    }
    else {
        # Evaluation logic:
        # - Pass: Feature is DISABLED and count >= 1 (secure state with emergency access pre-configured)
        # - Fail: Feature is DISABLED and count = 0 (no emergency access capability)
        # - Fail: Feature is ENABLED and count = 0 (feature active but no members configured)
        # - Investigate: Feature is ENABLED and count >= 1 (feature actively in use)

        if ($superUserFeatureEnabled -eq "Disabled") {
            if ($superUserCount -ge 1) {
                $passed = $true
            }
            else {
                $passed = $false
            }
        }
        elseif ($superUserFeatureEnabled -eq "Enabled") {
            if ($superUserCount -ge 1) {
                $investigateFlag = $true
            }
            else {
                $passed = $false
            }
        }
    }
    #endregion Assessment Logic

    #region Report Generation

    $testResultMarkdown = ""
    $mdInfo = ""
    $customStatus = $null

    if ($investigateFlag) {
        if ($errorMsg) {
            $testResultMarkdown = "⚠️ Não foi possível determinar a configuração de superusuário devido a problemas de permissões ou conexão.`n`n%TestResult%"
        }
        else {
            $testResultMarkdown = "⚠️ O recurso de superusuário está ativado com membros configurados (revise as contas e considere usar o Azure PIM para acesso just-in-time em vez de ativação permanente).`n`n%TestResult%"
        }
        $customStatus = 'Investigate'
    }
    elseif ($passed) {
        $testResultMarkdown = "✅ O recurso de superusuário está desabilitado com pelo menos um membro pré-configurado para acesso de emergência (revise os membros para garantir que ainda sejam necessários).`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ O recurso de superusuário está desabilitado sem membros configurados, OU o recurso está ativado sem membros.`n`n%TestResult%"
    }

    # Build detailed information section
    $mdInfo = "## Configuração de Superusuário do Azure Information Protection`n`n"

    if ($errorMsg) {
        # Show explicit "Unknown" values when an error occurred
        $mdInfo += "**Recurso de Superusuário:** Desconhecido (não foi possível consultar)`n`n"
        $mdInfo += "**Superusuários Configurados:** Desconhecido`n`n"
    }
    else {
        $mdInfo += "**Recurso de Superusuário:** $superUserFeatureEnabled`n`n"
        $mdInfo += "**Superusuários Configurados:** $superUserCount`n`n"
    }

    if (-not $errorMsg -and $superUserCount -gt 0) {
        $mdInfo += "| Nome do Superusuário | Tipo de Conta |`n"
        $mdInfo += "| :--- | :--- |`n"

        foreach ($superUserObj in $superUserObjects) {
            if ($superUserObj.IsServicePrincipal -and $superUserObj.Id) {
                # Only create portal link when we have a valid object ID
                $spPortalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/$($superUserObj.Id)/appId/$($superUserObj.AppId)"
                $displayText = "[$(Get-SafeMarkdown $superUserObj.DisplayName)]($spPortalLink)"
            }
            else {
                $displayText = Get-SafeMarkdown $superUserObj.DisplayName
            }
            $mdInfo += "| $displayText | $($superUserObj.AccountType) |`n"
        }

        $mdInfo += "`n"
    }

    $mdInfo += "**Nota:** A configuração de superusuário não está disponível por meio do portal do Azure e deve ser gerenciada via PowerShell usando o módulo AipService.`n"

    # Replace placeholder with actual detailed info
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35011'
        Status = $passed
        Result = $testResultMarkdown
    }
    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }
    Add-ZtTestResultDetail @params
}
