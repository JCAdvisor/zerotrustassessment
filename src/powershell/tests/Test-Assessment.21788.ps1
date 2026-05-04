<#
.SYNOPSIS

#>

function Test-Assessment-21788 {
    [ZtTest(
        Category = 'Acesso privilegiado',
        ImplementationCost = 'Baixo',
        MinimumLicense = ('Free'),
        Pillar = 'Identidade',
        RiskLevel = 'Alto',
        SfiPillar = 'Proteger sistemas de engenharia',
        TenantType = ('Workforce'),
        TestId = 21788,
        Title = 'Administradores Globais não possuem acesso persistente a assinaturas do Azure',
        UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando se Administradores Globais não possuem acesso persistente elevado a todas as assinaturas do Azure"
    Write-ZtProgress -Activity $activity -Status "Verificando conexão com Azure"

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
        Write-ZtProgress -Activity $activity -Status "Obtendo atribuições de função"

        $resourceManagementUrl = (Get-AzContext).Environment.ResourceManagerUrl
        $azRoleAssignmentUri = $resourceManagementUrl + 'providers/Microsoft.Authorization/roleAssignments?$filter=atScope()&api-version=2022-04-01'

        try {
            $results = (Invoke-RestMethod -Uri $azRoleAssignmentUri -Method Get -Authentication Bearer -Token $accessToken).value
        }
        catch {
             if ($_.Exception.Response.StatusCode -eq 403 -or $_.Exception.Message -like "*403*" -or $_.Exception.Message -like "*Forbidden*") {
                Write-PSFMessage "O usuário logado não tem acesso necessário à assinatura do Azure." -Level Verbose
                Add-ZtTestResultDetail -SkippedBecause NoAzureAccess
                return
            }
            else {
                throw
            }
        }

                $results = ($roleAssignments.Content | ConvertFrom-Json).value.properties | Where-Object {
            $_.roleDefinitionId -eq '/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
        }

        $testResultMarkdown = ""

        if ( -not $results -or $results.Count -eq 0 ) {
            $passed = $true
            $testResultMarkdown += "Sem acesso persistente ao Grupo de Gerenciamento Raiz do Azure."
        }
        else {
            $passed = $false
            $testResultMarkdown += "Acesso persistente ao Grupo de Gerenciamento Raiz do Azure foi encontrado.`n`n%TestResult%"
        }

        # Build the detailed sections of the markdown

        # Define variables to insert into the format string
        $reportTitle = "Objetos do Entra ID objects com acesso persistente ao Grupo de Gerenciamento Raiz"
        $tableRows = ""

         if ($results -and $results.Count -gt 0) {
            # Create a here-string with format placeholders {0}, {1}, etc.
            $formatTemplate = @'

## {0}


| Object do Entra ID | ID do Objeto | Tipo do Objeto |
| :----------------- | :----------- | :------------- |
{1}

'@

            foreach ($result in $results) {
                try {
                    $object = Invoke-ZtGraphRequest -RelativeUri "directoryObjects/$($result.principalId)" -ApiVersion 'v1.0'
                    if ($result.principalType -eq 'User') {
                        $displayName = $object.userPrincipalName
                    }
                    else {
                        $displayName = $object.displayName
                    }

                }
                catch {
                    Write-PSFMessage "Falha ao obter o objeto com o id $($result.principalId): $_"
                    $displayName = $result.principalId
                }

                $tableRows += @"
| $displayName | $($object.id) | $($result.principalType) |`n
"@
            }

            # Format the template by replacing placeholders with values
            $mdInfo = $formatTemplate -f $reportTitle, $tableRows
        }

        # Replace the placeholder with the detailed information
        $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

        $params = @{
            TestId = '21788'
            Title  = "Administradores Globais não possuem acesso persistente elevado a todas as assinaturas do Azure no tenant"
            Status = $passed
            Result = $testResultMarkdown
        }
        Add-ZtTestResultDetail @params
    }
}
