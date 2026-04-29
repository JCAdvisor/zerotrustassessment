<#
.SYNOPSIS
    Verifica se todos os aplicativos empresariais com permissões de alto privilégio possuem pelo menos dois proprietários.
#>

function Test-Assessment-21867 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Monitorar e detectar ciberameaças',
    	TenantType = ('Workforce','External'),
    	TestId = 21867,
    	Title = 'Aplicativos empresariais com permissões de API do Microsoft Graph de alto privilégio possuem proprietários',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Test-ZtApplicationOwnership `
        -Database $Database `
        -TestId '21867' `
        -PrivilegeLevel 'High' `
        -PassMessage 'Todos os aplicativos empresariais com alto privilégio possuem proprietários' `
        -FailMessage 'Nem todos os aplicativos empresariais com permissões de alto privilégio possuem proprietários' `
        -ReportTitle 'Aplicativos sem proprietários suficientes' `
        -Activity 'Verificando se aplicativos empresariais com permissões de API do Microsoft Graph de alto privilégio possuem proprietários'
}
