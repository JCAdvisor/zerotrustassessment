<#
.SYNOPSIS
    Unmanaged and unprotected Apps are restricted from Accessing Corporate Data
#>

function Test-Assessment-24827 {
    [ZtTest(
    	Category = 'Dados',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger tenants e sistemas em produção',
    	TenantType = ('Workforce'),
    	TestId = 24827,
    	Title = 'Políticas de Acesso Condicional bloqueiam acesso de aplicativos não gerenciados',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    #region Coleta de Dados
    $activity = "Verificando se aplicativos não gerenciados e não protegidos estão bloqueados de acessar dados corporativos"
    Write-ZtProgress -Activity $activity

    # Consulta 1: Todos
    $allCompliantAppCAPUri = "identity/conditionalAccess/policies?`$filter=state eq 'enabled' and grantControls/builtInControls/any(bc: bc eq 'compliantApplication') and conditions/platforms/includePlatforms/any(p: p eq 'iOS' or p eq 'android')&`$select=id,displayName,grantControls,conditions"
    $allCompliantAppCAP = Invoke-ZtGraphRequest -RelativeUri $allCompliantAppCAPUri -ApiVersion beta

    #region Lógica de Avaliação
    $passed = ($allCompliantAppCAP.Where{$null -eq $_.conditions.platforms.includePlatforms}.Count -gt 0) -or ( # sem filtro de plataforma
        $allCompliantAppCAP.Where{$_.conditions.platforms.includePlatforms -contains 'android'}.Count -gt 0 -and # pelo menos um Android
        $allCompliantAppCAP.Where{$_.conditions.platforms.includePlatforms -contains 'iOS'}.Count -gt 0 # pelo menos um iOS
    )

    if ($passed) {
        $testResultMarkdown = "Pelo menos uma política de Acesso Condicional habilitada com Proteção de Aplicativo existe para iOS e Android. As plataformas podem fazer parte da mesma política ou de políticas diferentes com o controle de concessão necessário.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "Nenhuma política de Acesso Condicional com Proteção de Aplicativo existe para iOS e Android ou ambas.`n`n%TestResult%"
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    # Construir as seções detalhadas do markdown

    # Definir variáveis para inserir na string de formato
    $reportTitle = "Políticas de Acesso Condicional para iOS e Android"
    $tableRows = ""

    # Gerar linhas de tabela markdown para cada política
    if ($allCompliantAppCAP.Count -gt 0) {
        # Criar uma here-string com placeholders de formatação {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Política | Plataformas |
| :---------- | :-------- |
{1}

'@

        foreach ($policy in $allCompliantAppCAP) {
            $portalLink = 'https://intune.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/Policies'
            $policyName = Get-SafeMarkdown -Text $policy.displayName
            $platformFilter = 'Todas as Plataformas'
            if ($null -ne $policy.conditions.platforms.includePlatforms) {
                $platformFilter = ($policy.conditions.platforms.includePlatforms -join ', ')
            }

            $tableRows += @"
| [$policyName]($portalLink) | $platformFilter |
"@
        }

                  # Formatar o template substituindo os placeholders pelos valores
        $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    }

    # Substituir o placeholder no markdown de resultado do teste pelos detalhes gerados
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId             = '24827'
        Title              = "Aplicativos não gerenciados e não protegidos estão restringidos de acessar dados corporativos"
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
