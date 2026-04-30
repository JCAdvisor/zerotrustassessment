<#
.SYNOPSIS
    Avaliação 21892 – Verifica se toda a atividade de logon está restrita a dispositivos gerenciados.
#>

function Test-Assessment-21892 {
    [ZtTest(
        Category = 'Access control',
        ImplementationCost = 'High',
        MinimumLicense = ('P1'),
        Pillar = 'Identity',
        RiskLevel = 'High',
        SfiPillar = 'Protect identities and secrets',
        TenantType = ('Workforce', 'External'),
        TestId = 21892,
        Title = 'Toda a atividade de logon provém de dispositivos gerenciados',
        UserImpact = 'High'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    $activity = "Verificando se toda a atividade de logon provém de dispositivos gerenciados"
    Write-ZtProgress -Activity $activity -Status "Obtendo políticas de Acesso Condicional"

    # ... (Lógica de processamento de políticas)

    $testResultMarkdown = ""
    if ($passed) {
        $testResultMarkdown = "✅ Toda a atividade de logon está restrita a dispositivos gerenciados.`n"
    }
    else {
        $testResultMarkdown += "`n### Resumo das políticas de Acesso Condicional para dispositivos gerenciados`n"
        $testResultMarkdown += "`nA tabela abaixo lista todas as políticas de Acesso Condicional que exigem um dispositivo em conformidade ou um dispositivo com ingresso híbrido.`n"

        $testResultMarkdown += "| Nome | Todos os usuários | Todos os apps | Dispositivo em conformidade | Dispositivo híbrido | Estado da política | Status |`n"
        $testResultMarkdown += "| :--- | :---:  | :---: | :---: | :---: | :--- | :--- |`n"
        # ...
    }

    $params = @{
        TestId = '21892'
        Status = $passed
        Result = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
