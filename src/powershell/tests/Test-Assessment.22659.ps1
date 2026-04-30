<#
.SYNOPSIS

#>

function Test-Assessment-22659 {
    [ZtTest(
    	Category = 'Monitoramento',
    	ImplementationCost = 'Alto',
    	MinimumLicense = ('P2'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 22659,
    	Title = 'Todos os logons de identidades de carga de trabalho de risco são triados',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraWorkloadID) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraWorkloadID
        return
    }

    $activity = 'Verificando logons de identidades de carga de trabalho de risco'
    Write-ZtProgress -Activity $activity -Status 'Obtendo detecções de logon de risco'

    # Obter detecções de logon de principal de serviço de risco
    $riskDetections = @()
    $response = Invoke-ZtGraphRequest -RelativeUri 'identityProtection/servicePrincipalRiskDetections' -ApiVersion 'beta'
    $riskDetections = $response.value | Where-Object {
        $_.activity -eq 'signIn' -and $_.riskState -eq 'atRisk'
    }

    $result = $riskDetections.Count -eq 0

    $testResultMarkdown = ''
    if ($result) {
        $testResultMarkdown = "✅ Todos os logons de identidades de carga de trabalho de risco foram triados."
    } else {
        $testResultMarkdown = @'
❌ Encontrados logons de identidades de carga de trabalho de risco que requerem triagem.

%TestResult%

'@
    }

    # Criar informações detalhadas em tabela se houver detecções de risco
    $mdInfo = ''
    if ($riskDetections) {
        $tableRows = ''
        $reportTitle = "Logons de Identidade de Carga de Trabalho de Risco"

        # Criar uma here-string com espaços reservados para formato {0}, {1}, etc.
        $formatTemplate = @'

## {0}


| Principal de Serviço | ID do Aplicativo | Estado de Risco | Nível de Risco | Última Atualização |
| :---------------- | :----- | :--------- | :--------- | :----------- |
{1}

'@

        foreach ($detection in $riskDetections) {
            $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/{0}/appId/{1}' -f $detection.servicePrincipalId, $detection.appId
            $tableRows += @'
| [{0}]({1}) | {2} | {3} | {4} | {5} |
'@ -f (Get-SafeMarkdown -Text $detection.servicePrincipalDisplayName), $portalLink, $detection.appId, $detection.riskState, $detection.riskLevel, (Get-FormattedDate -Date $detection.riskLastUpdatedDateTime)
            $tableRows += "`n"
        }

        # Formatar o modelo substituindo os espaços reservados pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    # Substituir o espaço reservado pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $passed = $result
    Add-ZtTestResultDetail `
        -TestId '22659' `
        -Title 'Todos os logons de identidades de carga de trabalho de risco são triados' `
        -UserImpact Low `
        -Risk High `
        -ImplementationCost High `
        -AppliesTo Identity `
        -Tag Identity `
        -Status $passed `
        -Result $testResultMarkdown
}