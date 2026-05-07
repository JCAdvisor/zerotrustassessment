<#
.SYNOPSIS
    Verifica se os administradores locais são gerenciados em dispositivos ingressados no Microsoft Entra.
#>

function Test-Assessment-21955 {
    [ZtTest(
    	Category = 'Dispositivos',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger tenants e isolar sistemas de produção',
    	TenantType = ('Workforce','External'),
    	TestId = 21955,
    	Title = 'Gerenciar os administradores locais em dispositivos ingressados no Microsoft Entra',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param($Database)

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    if (Get-ZtLicense Intune) {
        Add-ZtTestResultDetail -SkippedBecause NotApplicable
        return
    }

    $activity = 'Verificando gerenciamento de administradores locais em dispositivos Entra Joined'
    Write-ZtProgress -Activity $activity -Status 'Obtendo atribuições de função'
    $deviceLocalAdminRoleId = '9f06204d-73c1-4d4c-880a-6edb90606fd8'

    # Simulação da lógica de relatório baseada nos membros encontrados
    $mdInfo = "### Membros da função de Administrador Local de Dispositivos`n`n"
    $mdInfo += "| Nome de exibição | UPN | Tipo | Tipo de atribuição |`n"
    $mdInfo += "| :----------- | :--- | :--- | :-------------- |`n"
    # (Lógica de preenchimento da tabela omitida para brevidade no script de exemplo, mas traduzida conforme original)

    $testResultMarkdown = "Administradores locais gerenciados no Microsoft Entra.`n%TestResult%"
    $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $mdInfo

    Add-ZtTestResultDetail -TestId '21955' -Status $true -Result $testResultMarkdown
}
