<#
.SYNOPSIS
    Verifica se o Microsoft Rights Management Services (RMS) é permitido em Políticas de Acesso Entre Locaários (XTAP).

.DESCRIPTION
    Este teste verifica que o aplicativo Microsoft Rights Management Services (RMS) (App ID: 00000012-0000-0000-c000-000000000000)
    is allowed in both Inbound and Outbound Cross-Tenant Access Policies.
    It checks the Default policy and any Partner-specific policies.

    RMS is required for decrypting content shared across tenants (e.g., encrypted emails, MIP labels).
    Blocking it prevents users from opening protected content.

.NOTES
    Test ID: 35002
    Pillar: Data
    Risk Level: High
    Graph Scopes: Policy.Read.All, CrossTenantInformation.ReadBasic.All
#>

function Test-Assessment-35002 {
    [ZtTest(
        Category = 'Identidade',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Microsoft 365 E5'),
    	Service = ('Graph'),
        Pillar = 'Dados',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 35002,
        Title = 'As configurações de acesso entre locatários estão configuradas para permitir o compartilhamento de conteúdo criptografado',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Helper Functions
    function Get-RmsAccessStatus {
        param (
            $Settings
        )

        $rmsAppId = "00000012-0000-0000-c000-000000000000"
        $allApps = "AllApplications"

        if ($null -eq $Settings -or $null -eq $Settings.applications) {
            return "Inherited"
        }

        $accessType = $Settings.applications.accessType
        # Handle targets being an array or single object or null
        $targets = @()
        if ($Settings.applications.targets) {
            $targets = $Settings.applications.targets | ForEach-Object { $_.target }
        }

        if ($accessType -eq "allowed") {
            # In "Allowed" mode, only listed apps are allowed.
            if ($targets -contains $allApps -or $targets -contains $rmsAppId) {
                return "Allowed"
            }
            return "Blocked (Implicit)"
        }
        elseif ($accessType -eq "blocked") {
            # In "Blocked" mode, listed apps are blocked.
            if ($targets -contains $allApps -or $targets -contains $rmsAppId) {
                return "Blocked (Explicit)"
            }
            return "Allowed (Implicit)"
        }

        return "Unknown"
    }
    #endregion Helper Functions

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando configurações de RMS de Política de Acesso Entre Locaários (XTAP)'
    Write-ZtProgress -Activity $activity -Status 'Obtendo Política Padrão'

    $defaultPolicy = $null
    $partners = @()
    $errorMsg = $null

    try {
        # 1. Get Default Policy
        $defaultPolicy = Invoke-ZtGraphRequest -RelativeUri 'policies/crossTenantAccessPolicy/default' -ApiVersion v1.0 -ErrorAction Stop

        # 2. Get Partner Policies
        Write-ZtProgress -Activity $activity -Status 'Obtendo Políticas do Parceiro'
        $partners = Invoke-ZtGraphRequest -RelativeUri 'policies/crossTenantAccessPolicy/partners' -ApiVersion v1.0 -ErrorAction Stop
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar Políticas de Acesso Entre Locaários: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $xtapResults = @()
    $hasFailure = $false

    if ($errorMsg) {
        $passed = $false
    }
    else {
        # Check Default Inbound
        if ($defaultPolicy) {
            $inboundStatus = Get-RmsAccessStatus -Settings $defaultPolicy.b2bCollaborationInbound
            if ($inboundStatus -notlike "Allowed*") { $hasFailure = $true }

            $xtapResults += [PSCustomObject]@{
                Policy    = "Default"
                Direction = "Inbound"
                Status    = $inboundStatus
                Details   = "B2B Collaboration"
            }

            # Check Default Outbound
            $outboundStatus = Get-RmsAccessStatus -Settings $defaultPolicy.b2bCollaborationOutbound
            if ($outboundStatus -notlike "Allowed*") { $hasFailure = $true }

            $xtapResults += [PSCustomObject]@{
                Policy    = "Default"
                Direction = "Outbound"
                Status    = $outboundStatus
                Details   = "B2B Collaboration"
            }
        }

        # Check Partners
        foreach ($partner in $partners) {
            $tenantId = $partner.tenantId

            # Check Inbound
            if ($partner.b2bCollaborationInbound) {
                $pInboundStatus = Get-RmsAccessStatus -Settings $partner.b2bCollaborationInbound
                if ($pInboundStatus -ne "Inherited") {
                    if ($pInboundStatus -notlike "Allowed*") { $hasFailure = $true }

                    $xtapResults += [PSCustomObject]@{
                        Policy    = "Partner ($tenantId)"
                        Direction = "Inbound"
                        Status    = $pInboundStatus
                        Details   = "Explicit Override"
                    }
                }
            }

            # Check Outbound
            if ($partner.b2bCollaborationOutbound) {
                $pOutboundStatus = Get-RmsAccessStatus -Settings $partner.b2bCollaborationOutbound
                if ($pOutboundStatus -ne "Inherited") {
                    if ($pOutboundStatus -notlike "Allowed*") { $hasFailure = $true }

                    $xtapResults += [PSCustomObject]@{
                        Policy    = "Partner ($tenantId)"
                        Direction = "Outbound"
                        Status    = $pOutboundStatus
                        Details   = "Explicit Override"
                    }
                }
            }
        }

        $passed = -not $hasFailure
    }
    #endregion Assessment Logic

    #region Report Generation
    $rmsAppId = "00000012-0000-0000-c000-000000000000"

    if ($errorMsg) {
        $testResultMarkdown = "### Investigate`n`n"
        $testResultMarkdown += "As configurações de política de acesso entre locaários não podem ser determinadas ou o RMS não está explicitamente configurado.`n`n"
        $testResultMarkdown += "Verifique a saída do console para detalhes de erro."
    }
    else {
        if ($passed) {
            $testResultMarkdown = "✅ O aplicativo RMS é permitido (ou não restrito) nas configurações de política de acesso entre locaários para acesso de entrada e saída.`n`n"
        }
        else {
            $testResultMarkdown = "❌ O aplicativo RMS está explicitamente bloqueado nas configurações de política de acesso entre locaários de entrada ou saída.`n`n"
        }

        $testResultMarkdown += "### Configuração de Política de Acesso Entre Locaários (XTAP)`n`n"
        $testResultMarkdown += "| Política | Direção | Status | Detalhes |`n"
        $testResultMarkdown += "|:---|:---|:---|:---|`n"

        foreach ($result in $xtapResults) {
            $icon = if ($result.Status -like "Allowed*") { "✅" } else { "❌" }
            $testResultMarkdown += "| $($result.Policy) | $($result.Direction) | $icon $($result.Status) | $($result.Details) |`n"
        }
        $testResultMarkdown += "`n`n"

        if (-not $passed) {
            $testResultMarkdown += "⚠️ **Risco:** Bloquear RMS impede que os usuários abram conteúdo criptografado (e-mails, documentos) compartilhado entre locaários.`n"
            $testResultMarkdown += "Verifique as políticas bloqueadas e adicione 'Microsoft Rights Management Services' (App ID: $rmsAppId) à lista de aplicações permitidas.`n"
        }
    }
    #endregion Report Generation

    $testResultDetail = @{
        TestId             = '35002'
        Title              = 'Configuração de Política de Acesso Entre Locaários (XTAP) RMS de Entrada/Saída'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @testResultDetail
}
