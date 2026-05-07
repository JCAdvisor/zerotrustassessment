<#
.SYNOPSIS

#>

function Test-Assessment-21899{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21899,
    	Title = 'Todas as atribuições de função privilegiada têm um destinatário que pode receber notificações',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando se todas as atribuições de função privilegiada têm um destinatário que pode receber notificações"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $result = $false
    $testResultMarkdown = "Planejado para lançamento futuro."
    $passed = $result


    Add-ZtTestResultDetail -TestId '21899' -Title "Todas as atribuições de função privilegiada têm um destinatário que pode receber notificações" `
        -UserImpact Low -Risk Medium -ImplementationCost Low `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown -SkippedBecause UnderConstruction
}
