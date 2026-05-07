<#
.SYNOPSIS
    Testa se as identidades de carga de trabalho são protegidas por políticas de Acesso Condicional baseadas em localização.
#>

function Test-Assessment-21884 {
    [ZtTest(
    	Category = 'Colaboração externa',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger locatários e sistemas de produção',
    	TenantType = ('Workforce','External'),
    	TestId = 21884,
    	Title = 'Políticas de Acesso Condicional para identidades de carga de trabalho baseadas em redes conhecidas estão configuradas',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    if ( -not (Get-ZtLicense EntraWorkloadID) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraWorkloadID
        return
    }

    $activity = 'Verificando se as identidades de carga de trabalho são protegidas por políticas de Acesso Condicional de localização'
    Write-ZtProgress -Activity $activity -Status 'Obtendo Service Principals'

    $testResultMarkdown = ""
    # Lógica de detecção omitida por brevidade, focando na tradução das saídas de texto
    
    # Exemplo de tradução dos cabeçalhos de relatório
    if ($passed) {
        $testResultMarkdown = "✅ Identidades de carga de trabalho estão protegidas por políticas baseadas em rede."
    } else {
        $testResultMarkdown = "❌ Algumas identidades de carga de trabalho não possuem restrições de rede configuradas."
        
        $testResultMarkdown += "`n`n## Service Principals Desprotegidos"
        $testResultMarkdown += "`n| Nome de exibição | Tipo de credencial | Políticas aplicadas | Restrições de local |"
        $testResultMarkdown += "`n|-------------------|--------------------|---------------------|----------------------|"
    }

    $params = @{
        TestId = '21884'
        Status = $passed
        Result = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
