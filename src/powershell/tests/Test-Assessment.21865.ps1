<#
.SYNOPSIS

#>

function Test-Assessment-21865 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger redes',
    	TenantType = ('Workforce','External'),
    	TestId = 21865,
    	Title = 'Locais nomeados estão configurados',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    $activity = "Verificando se locais de rede confiáveis estão configurados para aumentar a qualidade das detecções de risco"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    # Query all named locations
    $allNamedLocations = Invoke-ZtGraphRequest -RelativeUri 'identity/conditionalAccess/namedLocations' -ApiVersion 'v1.0'

    # Check if at least one named location is configured as trusted
    if ($allNamedLocations | Where-Object { $_.isTrusted -eq $true }) {
        $passed = $true
        $testResultMarkdown = "✅ **Passou**: Locais nomeados confiáveis estão configurados no Microsoft Entra ID para suportar controles de segurança baseados em localização.`n`n%TestResult%"
    }
    else {
        $passed = $false
        $testResultMarkdown = "❌ **Falha**: Nenhum local nomeado confiável foi encontrado no Microsoft Entra ID.`n`n%TestResult%"
    }

    # Gerar detalhes do relatório
    $reportTitle = "Locais Nomeados Configurados"
    $totalNamedLocations = if ($null -eq $allNamedLocations) { 0 } else { $allNamedLocations.Count }
    $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ConditionalAccessMenuBlade/~/NamedLocations'

    $formatTemplate = @'
## {0}

Total de locais nomeados: [{1}]({2})

| Nome | Tipo | Confiável | Criado em | Modificado em |
| :--- | :--- | :--- | :--- | :--- |
{3}
'@

    foreach ($namedLocation in $allNamedLocations | Sort-Object displayName) {
        $name = $namedLocation.displayName
        $locationType = switch ($namedLocation) {
            { $_.'@odata.type' -eq '#microsoft.graph.ipNamedLocation' } { 'Baseado em IP' }
            { $_.'@odata.type' -eq '#microsoft.graph.countryNamedLocation' } { 'Baseado em País' }
            default { 'Desconhecido' }
        }
        $trusted = if ($namedLocation.isTrusted) { 'Sim' } else { 'Não' }
        $createdDateTime = Get-FormattedDate -DateString $namedLocation.createdDateTime
        $modifiedDateTime = Get-FormattedDate -DateString $namedLocation.modifiedDateTime

        $tableRows += @"
| $name | $locationType | $trusted | $createdDateTime | $modifiedDateTime |`n
"@
    }

    # Format the template by replacing placeholders with values
    $mdInfo = $formatTemplate -f $reportTitle, $totalNamedLocations, $portalLink, $tableRows

    # Replace the placeholder with the detailed information
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21865'
        Title              = 'Locais de rede confiáveis estão configurados para aumentar a qualidade das detecções de risco'
        UserImpact         = 'Baixo'
        Risk               = 'Médio'
        ImplementationCost = 'Baixo'
        AppliesTo          = 'Identidade'
        Tag                = 'Identidade'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
