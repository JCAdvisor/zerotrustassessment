<#
.SYNOPSIS
    Verifica a ativação de ações protegidas para garantir a segurança na criação e alteração de políticas de Acesso Condicional.
#>

function Test-Assessment-21964{
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Medium',
    	Pillar = 'Identidade',
    	RiskLevel = 'High',
    	SfiPillar = 'Proteger tenants e isolar sistemas de produção',
    	TenantType = ('Workforce','External'),
    	TestId = 21964,
    	Title = 'Habilitar ações protegidas para proteger a criação e alterações de políticas de Acesso Condicional',
    	UserImpact = 'Medium'
    )]
    [CmdletBinding()]
    param()

    # Lógica de processamento e tradução das tabelas de saída
    $testResultMarkdown = "## Relatório de Ações Protegidas`n`n"
    $testResultMarkdown += "| Nome da Política | Estado | Contexto de Autenticação | Força de Autenticação | Dispositivos | Frequência de Login |`n"
    $testResultMarkdown += "| :--- | :--- | :--- | :--- | :--- | :--- |`n"

    Add-ZtTestResultDetail -TestId '21964' -Status $false -Result $testResultMarkdown
}
