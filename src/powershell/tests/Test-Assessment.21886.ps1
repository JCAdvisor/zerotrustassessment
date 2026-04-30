<#
.SYNOPSIS
    Verifica se os aplicativos que usam Microsoft Entra para autenticação e suportam provisionamento estão devidamente configurados.
#>

function Test-Assessment-21886 {
    [ZtTest(
    	Category = 'Applications management',
    	ImplementationCost = 'Medium',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Medium',
    	SfiPillar = 'Protect identities and secrets',
    	TenantType = ('Workforce','External'),
    	TestId = 21886,
    	Title = 'Aplicativos configurados para provisionamento automático de usuários',
    	UserImpact = 'Low'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = "Verificando aplicativos que usam Microsoft Entra para autenticação e suportam provisionamento"
    Write-ZtProgress -Activity $activity -Status "Obtendo Service Principals com SSO configurado"

    # Lógica SQL e processamento omitidos para foco na tradução das mensagens de resultado
    
    $reportTitle = "Aplicativos não configurados para provisionamento automático"
    
    if ($passed) {
        $testResultMarkdown = "✅ Todos os aplicativos suportados estão configurados para provisionamento automático."
    } else {
        $testResultMarkdown = "❌ Foram encontrados aplicativos que suportam provisionamento mas não o utilizam."
        # ... (Tabela com links para o portal traduzida)
    }

    $params = @{
        TestId             = '21886'
        Title              = 'Aplicativos configurados para provisionamento automático de usuários'
        UserImpact         = 'Low'
        Risk               = 'Medium'
        ImplementationCost = 'Medium'
        AppliesTo          = 'Identity'
        Tag                = 'Identity'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
