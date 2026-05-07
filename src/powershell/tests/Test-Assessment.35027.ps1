<#
.SYNOPSIS
    Modelos de marca personalizada estão configurados para o Criptografia de Mensagens do Microsoft Purview

.DESCRIPTION
    Office 365 Message Encryption (OME) allows organizations to send encrypted emails and protect sensitive information.
    When custom branding templates are not configured for OME, external recipients receive a generic Microsoft-branded encryption portal experience.
    Custom branding templates allow organizations to apply their company logo, custom colors, disclaimer text, and contact information to the OME portal,
    reinforcing organizational identity and improving user experience for external recipients.

.NOTES
    Test ID: 35027
    Pillar: Data
    Risk Level: Low
    Category: Information Protection
#>

function Test-Assessment-35027 {
    [ZtTest(
    	Category = 'Information Protection',
    	ImplementationCost = 'Low',
    	MinimumLicense = ('Microsoft 365 E3','Microsoft 365 E5','Advanced Message Encryption add-on'),
    	Service = ('ExchangeOnline'),
    	Pillar = 'Data',
    	RiskLevel = 'Low',
    	SfiPillar = 'Protect tenants and production systems',
    	TenantType = ('Workforce'),
    	TestId = 35027,
    	Title = 'Custom branding templates are configured for Microsoft Purview Message Encryption',
    	UserImpact = 'Low'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando configuração de marca personalizada de OME'
    Write-ZtProgress -Activity $activity -Status 'Obtendo configuração de OME'

    $omeConfig = $null
    $errorMsg = $null
    $totalConfigs = 0
    $configsWithBranding = 0
    $configDetails = @()

    try {
            # Consulta Q1: Get all OME template branding configurations
        $omeConfig = Get-OMEConfiguration | Select-Object -Property Identity, ImageUrl, BackgroundColor, IntroductionText, PortalText, DisclaimerText, EmailText

        # Extract and normalize data
        $totalConfigs = ($omeConfig | Measure-Object).Count

        foreach ($config in $omeConfig) {
            # Check property values once (DRY principle)
            $hasBackgroundColor = -not [string]::IsNullOrWhiteSpace($config.BackgroundColor)
            $hasIntroductionText = -not [string]::IsNullOrWhiteSpace($config.IntroductionText)
            $hasDisclaimerText = -not [string]::IsNullOrWhiteSpace($config.DisclaimerText)
            $hasPortalText = -not [string]::IsNullOrWhiteSpace($config.PortalText)
            $hasEmailText = -not [string]::IsNullOrWhiteSpace($config.EmailText)
            $hasImageUrl = -not [string]::IsNullOrWhiteSpace($config.ImageUrl)

            # Check if this configuration has any custom branding
            $hasCustomBranding = $hasBackgroundColor -or $hasIntroductionText -or $hasDisclaimerText -or $hasPortalText -or $hasEmailText -or $hasImageUrl

            if ($hasCustomBranding) {
                $configsWithBranding++
            }

            # Store configuration details for reporting
            $configDetails += [PSCustomObject]@{
                Identity         = $config.Identity
                EmailText        = if ($hasEmailText) { "✅ $($config.EmailText)" } else { '❌ None' }
                LogoConfigured   = if ($hasImageUrl) { '✅ Yes' } else { '❌ No' }
                BackgroundColor  = if ($hasBackgroundColor) { "✅ $($config.BackgroundColor)" } else { '❌ None' }
                PortalText       = if ($hasPortalText) { "✅ $($config.PortalText)" } else { '❌ None' }
                IntroductionText = if ($hasIntroductionText) { "✅ $($config.IntroductionText)" } else { '❌ None' }
                DisclaimerText   = if ($hasDisclaimerText) { "✅ $($config.DisclaimerText)" } else { '❌ None' }
            }
        }
    }
    catch {
        $errorMsg = $_
        Write-PSFMessage "Erro ao consultar configuração de OME: $_" -Level Error
    }
    #endregion Data Collection

    #region Assessment Logic
    $passed = $false
    $customStatus = $null
    $testResultMarkdown = ''

    if ($errorMsg) {
        # Investigate scenario
        $customStatus = 'Investigate'
        $testResultMarkdown = "⚠️ Não foi possível determinar o status de configuração de marca de OME devido a problemas de permissões ou falha na consulta.`n`n%TestResult%"
    }
    elseif ($configsWithBranding -gt 0) {
        # Pass scenario
        $passed = $true
        $testResultMarkdown = "✅ Marca personalizada de OME foi configurada, fornecendo uma experiência de portal de criptografia marcada para destinatários externos.`n`n%TestResult%"
    }
    else {
        # Fail scenario
        $passed = $false
        $testResultMarkdown = "❌ Marca personalizada de OME não está configurada; o portal de criptografia usa marca genérica da Microsoft.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    if ($totalConfigs -gt 0) {
        # Build summary and configuration details table for both pass and fail scenarios
        $formatTemplate = @'
**Resumo:**

- Total de configurações de OME: {0}
- Configuradas com marca personalizada: {1}

**Detalhes de configuração:**

| Identidade da configuração | Texto de email | Logo configurada | Cor de fundo | Texto do portal | Texto de introdução | Texto de aviso |
|:-----------------------|:-----------|:----------------|:-----------------|:------------|:------------------|:----------------|
{2}
'@

        $tableRows = ''
        foreach ($detail in $configDetails) {
            $tableRows += "| $($detail.Identity) | $($detail.EmailText) | $($detail.LogoConfigured) | $($detail.BackgroundColor) | $($detail.PortalText) | $($detail.IntroductionText) | $($detail.DisclaimerText) |`n"
        }

        $mdInfo = $formatTemplate -f $totalConfigs, $configsWithBranding, $tableRows.TrimEnd("`n")
    }

    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '35027'
        Title  = 'OME Custom Branding Templates'
        Status = $passed
        Result = $testResultMarkdown
    }

    if ($customStatus) {
        $params.CustomStatus = $customStatus
    }

    Add-ZtTestResultDetail @params
}
