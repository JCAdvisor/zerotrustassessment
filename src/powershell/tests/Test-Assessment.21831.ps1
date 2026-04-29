<#
.SYNOPSIS
    Verifica se Ações Protegidas estão habilitadas para tarefas de gerenciamento de alto impacto.
#>

function Test-Assessment-21831 {
    [ZtTest(
    	Category = 'Acesso privilegiado',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Protect tenants and isolate production systems',
    	TenantType = ('Workforce'),
    	TestId = 21831,
    	Title = 'Ações protegidas estão habilitadas para tarefas de gerenciamento de alto impacto',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se Ações Protegidas do Acesso Condicional estão habilitadas"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $passed = $false
    $testResultMarkdown = "Planejado para uma versão futura."

    Add-ZtTestResultDetail -TestId '21831' -Title "Ações protegidas estão habilitadas" `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
