<#
.SYNOPSIS
    Verifica se a autenticação legada está bloqueada.
#>

function Test-Assessment-21796 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 21796,
    	Title = 'A política de bloqueio de autenticação legada está configurada',
    	UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    $activity = "Verificando o bloqueio de autenticação legada"
    Write-ZtProgress -Activity $activity -Status "Obtendo políticas de Acesso Condicional"

    $caps = Invoke-ZtGraphRequest -RelativeUri 'identity/conditionalAccess/policies' -ApiVersion beta

    $blockPolicies = $caps | Where-Object {`
            $_.grantControls.builtInControls -contains "block" -and `
            $_.conditions.clientAppTypes -contains "exchangeActiveSync" -and `
            $_.conditions.clientAppTypes -contains "other" }

    $blockPoliciesEnabled = $blockPolicies | Where-Object {`
         $_.conditions.users.includeUsers -contains "All" -and `
         $_.state -eq "enabled" `
    }

    $passed = ($blockPoliciesEnabled | Measure-Object).Count -ge 1

    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: Políticas de Acesso Condicional para bloquear autenticação legada estão configuradas e habilitadas.`n`n%TestResult%"
    }
    elseif (($blockPolicies | Measure-Object).Count -ge 1) {
        $testResultMarkdown = "⚠️ **Atenção**: Foram encontradas políticas para bloquear autenticação legada, mas elas não estão configuradas corretamente ou não estão habilitadas.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ **Falha**: Nenhuma política de Acesso Condicional para bloquear autenticação legada foi encontrada."
    }

    Add-ZtTestResultDetail -TestId '21796' -Status $passed -Result $testResultMarkdown -GraphObjectType ConditionalAccess -GraphObjects $blockPolicies
}
