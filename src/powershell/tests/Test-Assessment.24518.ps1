<#!
.SYNOPSIS
Verifica se todos os aplicativos empresariais possuem proprietários atribuídos e lista os nomes das permissões com classificações.
#>

function Test-Assessment-24518 {

    [ZtTest(
    	Category = 'Gestão de aplicativos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger sistemas de engenharia',
    	TenantType = ('Workforce'),
    	TestId = 24518,
    	Title = 'Aplicativos empresariais possuem proprietários',
    	UserImpact = 'Baixo'
    )]

    [CmdletBinding()]
    param(
        $Database
    )

    Test-ZtApplicationOwnership `
        -Database $Database `
        -TestId '24518' `
        -PrivilegeLevel 'Medium', 'Low', 'Unranked' `
        -PassMessage 'Todos os aplicativos empresariais possuem pelo menos dois proprietários.' `
        -FailMessage 'Nem todos os aplicativos empresariais possuem pelo menos dois proprietários.' `
        -ReportTitle 'Propriedade de Aplicativos Empresariais' `
        -Activity 'Verificando a propriedade de aplicativos empresariais'
}