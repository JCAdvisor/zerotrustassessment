<#
.SYNOPSIS
    Verifica se todos os Logs do Entra estão configurados com Definições de Diagnóstico.
#>

function Test-Assessment-21860 {
    [ZtTest(
    	Category = 'Monitoramento',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Monitorar e detectar ciberameaças',
    	TenantType = ('Workforce','External'),
    	TestId = 21860,
    	Title = 'Configurações de diagnóstico estão configuradas para todos os logs do Microsoft Entra',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    if((Get-MgContext).Environment -ne 'Global')
    {
        Write-PSFMessage "Este teste é aplicável apenas ao ambiente Global." -Tag Test -Level VeryVerbose
        return
    }


    $skipped = $null
    try {
        $accessToken = Get-AzAccessToken -AsSecureString -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }
    catch [Management.Automation.CommandNotFoundException] {
        Write-PSFMessage $_.Exception.Message -Tag Test -Level Error
    }

    $passed = $false

    if (!$accessToken) {
        Write-PSFMessage "Token de autenticação do Azure não encontrado." -Level Warning
        Add-ZtTestResultDetail -SkippedBecause NotConnectedAzure
        return
    }
    else {
        $azAccessToken = ($accessToken.Token)

        $resourceManagementUrl = (Get-AzContext).Environment.ResourceManagerUrl
        $azDiagUri = $resourceManagementUrl + 'providers/Microsoft.Authorization/roleAssignments?$filter=atScope()&api-version=2022-04-01'

        try {
            $result = Invoke-WebRequest -Uri $azDiagUri -Authentication Bearer -Token $azAccessToken -ErrorAction Stop
        }
        catch {
            if ($_.Exception.Response.StatusCode -eq 403 -or $_.Exception.Message -like "*403*" -or $_.Exception.Message -like "*Forbidden*") {
                Write-PSFMessage "O usuário conectado não possui acesso à assinatura do Azure para verificar o arquivamento de logs." -Level Verbose
                Add-ZtTestResultDetail -SkippedBecause NoAzureAccess
                return
            }
            else {
                throw
            }
        }

        $diagnosticSettings = $result.Content | ConvertFrom-Json
        $enabledLogs = $diagnosticSettings.value.properties.logs | Where-Object { $_.enabled } | Select-Object -ExpandProperty category -Unique

        $logsToCheck = @(
            "AuditLogs",
            "SignInLogs",
            "NonInteractiveUserSignInLogs",
            "ServicePrincipalSignInLogs",
            "ManagedIdentitySignInLogs",
            "ProvisioningLogs",
            "ADFSSignInLogs",
            "RiskyUsers",
            "UserRiskEvents",
            "NetworkAccessTrafficLogs",
            "RiskyServicePrincipals",
            "ServicePrincipalRiskEvents",
            "EnrichedOffice365AuditLogs",
            "MicrosoftGraphActivityLogs",
            "RemoteNetworkHealthLogs"
        )

        $missingLogs = $logsToCheck | Where-Object { $_ -notin $enabledLogs }


        $passed = $null -eq $missingLogs

        if ($passed) {
            $testResultMarkdown += "Todos os Logs do Entra estão configurados com Definições de Diagnóstico.`n`n%TestResult%"
        }
        else {
            $testResultMarkdown += "Alguns Logs do Entra não estão configurados com definições de Diagnóstico.`n`n%TestResult%"
        }

        $mdInfo = "## Arquivamento de logs`n`n"

        $mdInfo += "Log | Arquivamento habilitado |`n"
        $mdInfo += "| :--- | :---: |`n"

        foreach ($item in $missingLogs | Sort-Object) {
            $mdInfo += "|$item | ❌ |`n"
        }

        foreach ($item in $enabledLogs | Sort-Object) {
            $mdInfo += "|$item | ✅ |`n"
        }

        $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    }

    Add-ZtTestResultDetail -TestId '21860' -Title 'Configurações de diagnóstico estão configuradas para todos os logs do Microsoft Entra' `
        -UserImpact Baixo -Risk Alto -ImplementationCost Médio `
        -AppliesTo Identity -Tag Application `
        -Status $passed -Result $testResultMarkdown
}
