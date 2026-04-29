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
        $azRoleAssignmentUri = $resourceManagementUrl + 'providers/Microsoft.Authorization/roleAssignments?api-version=2022-04-01&$filter=roleDefinitionId eq ''/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'''
        $results = (Invoke-RestMethod -Uri $azRoleAssignmentUri -Method Get -Authentication Bearer -Token $accessToken).value

        $passed = $results.Count -eq 0

        if ($passed) {
            $testResultMarkdown = "✅ **Passou**: Nenhum Administrador Global possui acesso persistente elevado a assinaturas do Azure.`n`n"
        }
        else {
            $testResultMarkdown = "❌ **Falha**: Administradores Globais com acesso persistente a assinaturas do Azure foram encontrados.`n`n%TestResult%"
        }

        $mdInfo = ""
        if ($results.Count -gt 0) {
            $reportTitle = "Administradores Globais com acesso persistente ao Azure"
            $formatTemplate = @'
## {0}

| Objeto Entra ID | ID do Objeto | Tipo de Principal |
| :-------------- | :-------- | :------------- |
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
                    Write-PSFMessage "Falha ao obter objeto para o principalId $($result.principalId): $_"
                    $displayName = $result.principalId
                }
                $tableRows += "| $displayName | $($object.id) | $($result.principalType) |`n"
            }
            $mdInfo = $formatTemplate -f $reportTitle, $tableRows
        }

        $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

        $params = @{
            TestId = '21788'
            Title  = "Administradores Globais não possuem acesso persistente elevado a todas as assinaturas do Azure no locatário"
            Status = $passed
            Result = $testResultMarkdown
        }
        Add-ZtTestResultDetail @params
    }
}
