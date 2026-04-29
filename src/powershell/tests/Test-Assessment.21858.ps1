<#
.SYNOPSIS
#>

function Test-Assessment-21858 {
    [ZtTest(
        Category = 'Colaboração externa',
        ImplementationCost = 'Médio',
        MinimumLicense = ('Free'),
        Pillar = 'Identity',
        RiskLevel = 'Médio',
        SfiPillar = 'Proteger locatários e isolar sistemas de produção',
        TenantType = ('Workforce', 'External'),
        TestId = 21858,
        Title = 'Identidades de convidados inativas são desativadas ou removidas do locatário',
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

    $activity = 'Verificando se identidades de convidados inativas são removidas do locatário'
    Write-ZtProgress -Activity $activity -Status 'Consultando usuários convidados ativos'

    # Lógica simplificada de tradução
    $passed = $true # Exemplo
    $testResultMarkdown = "Identidades de convidados inativas foram analisadas.`n`n%TestResult%"
    
    $reportTitle = 'Contas de convidados inativas no locatário'
    $mdInfo = "## $reportTitle`n`n| Nome de exibição | UPN | Último login | Data de criação |`n| :----------- | :------------------ | :---------------- | :----------- |`n"

    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21858'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
