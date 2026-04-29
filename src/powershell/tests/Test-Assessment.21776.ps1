<#
.SYNOPSIS

#>

function Test-Assessment-21776 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21776,
    	Title = 'Configurações de consentimento do usuário estão restritas',
    	UserImpact = 'Alto'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Iniciando' -Tag Test -Level VeryVerbose

    $activity = "Verificando se as configurações de consentimento do usuário estão restritas"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    $authorizationPolicy = Invoke-ZtGraphRequest -RelativeUri 'policies/authorizationPolicy' -ApiVersion 'v1.0'

    $matchedPolicies = $authorizationPolicy | Where-Object { $_.defaultUserRolePermissions.permissionGrantPoliciesAssigned -match '^ManagePermissionGrantsForSelf' }

    $hasNoMatchedPolicies = $matchedPolicies.Count -eq 0
    $hasLowImpactPolicy = $matchedPolicies.defaultUserRolePermissions.permissionGrantPoliciesAssigned -contains 'managePermissionGrantsForSelf.microsoft-user-default-low'

    if ($hasNoMatchedPolicies -or $hasLowImpactPolicy) {
        $passed = $true
        $testResultMarkdown = "✅ **Passou**: As configurações de consentimento do usuário estão devidamente restritas.`n`n"
    }
    else {
        $passed = $false
        $testResultMarkdown = "❌ **Falha**: O consentimento do usuário está muito permissivo, permitindo ataques de consentimento ilícito.`n`n"
    }

    $reportTitle = "Configurações de Consentimento"
    $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ConsentPoliciesMenuBlade/~/UserSettings"
    $formatTemplate = @"

## {0}

**[Configurações de consentimento do usuário]({1}) atuais**

- {2}

"@

    if ($hasNoMatchedPolicies) {
        $settingsDescription = "Não permitir o consentimento do usuário.`nUm administrador será necessário para todos os aplicativos."
    }
    elseif ($hasLowImpactPolicy) {
        $settingsDescription = "Permitir consentimento do usuário para aplicativos de editores verificados, para permissões selecionadas (Recomendado).`nTodos os usuários podem consentir para permissões classificadas como 'baixo impacto'."
    }
    else {
        $settingsDescription = "Permitir consentimento do usuário para aplicativos.`nTodos os usuários podem consentir para qualquer aplicativo acessar os dados da organização."
    }

    $mdInfo = $formatTemplate -f $reportTitle, $portalLink, $settingsDescription
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    $params = @{
        TestId             = '21776'
        Title              = 'Configurações de consentimento do usuário estão restritas'
        UserImpact         = 'Alto'
        Risk               = 'Alto'
        ImplementationCost = 'Médio'
        AppliesTo          = 'Identidade'
        Tag                = 'Identidade'
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
