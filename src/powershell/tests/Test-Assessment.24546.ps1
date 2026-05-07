<#
.SYNOPSIS

#>

function Test-Assessment-24546 {
    [ZtTest(
    	Category = 'Tenant',
    	ImplementationCost = 'Baixo',
        MinimumLicense = ('P1'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger tenants e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24546,
    	Title = 'O registro automático de dispositivos Windows é aplicado para eliminar riscos de endpoints não gerenciados',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Coleta de Dados
    Write-PSFMessage '🟦 Iniciar' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    $activity = "Verificando se o Registro Automático do Windows está habilitado"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    # Recuperar Políticas de Gerenciamento de Dispositivos Móveis (MDM)
    $MDMPoliciesUri = "policies/mobileDeviceManagementPolicies"
    $MDMPolicies = Invoke-ZtGraphRequest -RelativeUri $MDMPoliciesUri -ApiVersion beta

    # Converter para array se for um valor único para garantir tratamento consistente
    if ($null -eq $MDMPolicies) {
        $MDMPolicies = @()
    }
    elseif ($MDMPolicies -isnot [array]) {
        $MDMPolicies = @($MDMPolicies)
    }

    # Filtrar para a política do Microsoft Intune (usando o ID comum para Intune se disponível ou procurando por nome)
    $intunePolicy = $MDMPolicies | Where-Object { $_.displayName -eq "Microsoft Intune" }
    #endregion Coleta de Dados

    #region Lógica de Avaliação
    # O registro automático é considerado habilitado se AppliesTo for 'all' ou 'selected'
    $passed = $null -ne $intunePolicy -and ($intunePolicy.appliesTo -eq "all" -or $intunePolicy.appliesTo -eq "selected")
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $testResultMarkdown = ""
    if ($passed) {
        $testResultMarkdown = "✅ O Registro Automático do Windows está habilitado e aplicado no tenant.`n`n"
    }
    else {
        $testResultMarkdown = "❌ O Registro Automático do Windows não está habilitado ou está configurado como 'Nenhum'.`n`n"
    }

    # Variáveis para inserir na string de formato
    $reportTitle = "Registro Automático do Windows"
    $tableRows = ""

    if ($intunePolicy) {
        # Criar uma here-string com espaços reservados para formato {0}, {1}, etc.
        $formatTemplate = @'

## {0}

| Nome da Política | Escopo do Usuário |
| :---------- | :--------- |
{1}

'@

        $policyName = $intunePolicy.displayName
        $portalLink = 'https://intune.microsoft.com/#view/Microsoft_AAD_IAM/MdmConfiguration.ReactView/appId/0000000a-0000-0000-c000-000000000000/appName/Microsoft%20Intune'

        switch ($intunePolicy.appliesTo) {
            'none' {
                $userScope = "❌ Nenhum"
            }
            'selected' {
                $userScope = "✅ Grupos Específicos"
            }
            'all' {
                $userScope = "✅ Todos os Usuários"
            }
            default {
                $userScope = "⚠️ Escopo Desconhecido"
            }
        }

        $tableRows = "| [$(Get-SafeMarkdown -Text $policyName)]($portalLink) | $userScope |`n"
    }

    # Formatar o modelo substituindo os espaços reservados pelos valores
    $mdInfo = $formatTemplate -f $reportTitle, $tableRows

    # Substituir o espaço reservado pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24546'
        Title  = 'O Registro Automático do Windows está Habilitado'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
