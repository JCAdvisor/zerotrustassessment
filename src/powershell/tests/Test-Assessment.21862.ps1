<#
.SYNOPSIS
    Verifica se todas as identidades de carga de trabalho de risco passaram por triagem.
#>

function Test-Assessment-21862{
    [ZtTest(
    	Category = 'Monitoramento',
    	ImplementationCost = 'Alto',
    	MinimumLicense = ('P2'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Monitorar e detectar ciberameaças',
    	TenantType = ('Workforce','External'),
    	TestId = 21862,
    	Title = 'Todas as identidades de carga de trabalho de risco passaram por triagem',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if( -not (Get-ZtLicense EntraWorkloadID) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraWorkloadID
        return
    }

    $activity = "Verificando se todas as identidades de carga de trabalho de risco passaram por triagem"
    Write-ZtProgress -Activity $activity -Status "Obtendo principais de serviço de risco"

    $untriagedRiskyPrincipals = Invoke-ZtGraphRequest -RelativeUri "identityProtection/riskyServicePrincipals" -ApiVersion v1.0 -Filter "riskState eq 'atRisk'"

    Write-ZtProgress -Activity $activity -Status "Obtendo detecções de risco de principais de serviço"

    $servicePrincipalRiskDetections = Invoke-ZtGraphRequest -RelativeUri "identityProtection/servicePrincipalRiskDetections" -ApiVersion v1.0 -Filter "riskState eq 'atRisk'"

    $untriagedRiskDetections = $servicePrincipalRiskDetections | Where-Object { $_.riskState -eq 'atRisk' }

    $passed = ($untriagedRiskyPrincipals.Count -eq 0) -and ($untriagedRiskDetections.Count -eq 0)

    if ($passed) {
        $testResultMarkdown = "Todas as identidades de carga de trabalho de risco passaram pela triagem"
    }
    else {
        $riskySPCount = $untriagedRiskyPrincipals.Count
        $riskyDetectionCount = $untriagedRiskDetections.Count
        $testResultMarkdown = "Encontrados $riskySPCount principais de serviço de risco sem triagem e $riskyDetectionCount detecções de risco sem triagem"

        if ($riskySPCount -gt 0) {
            $testResultMarkdown += "`n`n## Principais de Serviço de Risco sem Triagem`n`n"
            $testResultMarkdown += "| Principal de Serviço | Tipo | Nível de Risco | Estado do Risco | Última Atualização do Risco |`n"
            $testResultMarkdown += "| :--- | :--- | :--- | :--- | :--- |`n"
            foreach ($sp in $untriagedRiskyPrincipals) {
                $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/SignOn/objectId/$($sp.id)/appId/$($sp.appId)"
                $testResultMarkdown += "| [$($sp.displayName)]($portalLink) | $($sp.servicePrincipalType) | $(Get-FormattedRiskLevel -RiskLevel $sp.riskLevel) | $(Get-RiskStateLabel -RiskState $sp.riskState) | $($sp.riskLastUpdatedDateTime) |`n"
            }
        }

        if ($riskyDetectionCount -gt 0) {
            $testResultMarkdown += "`n`n## Eventos de Detecção de Risco sem Triagem`n`n"
            $testResultMarkdown += "| Principal de Serviço | Nível de Risco | Estado do Risco | Tipo de Evento de Risco | Última Atualização do Risco |`n"
            $testResultMarkdown += "| :--- | :--- | :--- | :--- | :--- |`n"
            foreach ($detection in $untriagedRiskDetections) {
                $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/SignOn/objectId/$($detection.servicePrincipalId)/appId/$($detection.appId)"
                $testResultMarkdown += "| [$($detection.servicePrincipalDisplayName)]($portalLink) | $(Get-FormattedRiskLevel -RiskLevel $detection.riskLevel) | $(Get-RiskStateLabel -RiskState $detection.riskState) | $(Get-RiskEventTypeLabel -RiskEventType $detection.riskEventType) | $($detection.detectedDateTime) |`n"
            }
        }
    }

    Add-ZtTestResultDetail -Status $passed -Result $testResultMarkdown
}
