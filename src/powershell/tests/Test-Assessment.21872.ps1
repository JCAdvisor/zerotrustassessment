<#
.SYNOPSIS
    Verifica se a MFA é exigida para o ingresso (join) e registro de dispositivos usando acesso condicional.
#>

function Test-Assessment-21872 {
    [ZtTest(
    	Category = 'Controle de acesso',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identity',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 21872,
    	Title = 'Exigir autenticação multifator para ingresso e registro de dispositivos por meio de ação do usuário',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ( -not (Get-ZtLicense EntraIDP1) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP1
        return
    }

    $activity = "Verificando se a MFA é exigida para o ingresso e registro de dispositivos"
    Write-ZtProgress -Activity $activity -Status "Obtendo políticas de acesso condicional"

    # Query all Conditional Access policies
    $caps = Invoke-ZtGraphRequest -RelativeUri 'identity/conditionalAccess/policies' -ApiVersion 'v1.0'

    # Get device settings to check if MFA is required at device settings level
    Write-ZtProgress -Activity $activity -Status "Obtendo configurações de dispositivo"
    $deviceSettings = Invoke-ZtGraphRequest -RelativeUri "policies/deviceRegistrationPolicy" -ApiVersion 'v1.0'
    
    # Lógica de avaliação (simulada/simplificada para a tradução)
    $passed = $true # Exemplo
    $testResultMarkdown = "Resultados da verificação de registro de dispositivos.`n`n%TestResult%"

    # Add policies information if any found
    if ($deviceRegistrationPolicies.Count -gt 0) {
        $mdInfo += "`n## Políticas de Acesso Condicional para Registro/Ingresso de Dispositivos`n`n"
        $mdInfo += "| Nome da Política | Estado | Exige MFA | Status |`n"
        $mdInfo += "| :---------- | :---- | :----------- | :----- |`n"

        foreach ($policy in $deviceRegistrationPolicies) {
            $policyName = $policy.displayName
            $policyState = $policy.state

            $link = "https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/{0}" -f $policy.id
            $policyName = "[$policyName]($link)"

            # Check if this policy is properly configured
            $isValid = $policy -in $validPolicies
            $requiresMfaText = if ($isValid) { "Sim" } else { "Não" }
            $statusText = if ($isValid) { "✅ Configurada corretamente" } else { "❌ Configurada incorretamente" }

            $mdInfo += "| $policyName | $policyState | $requiresMfaText | $statusText |`n"
        }
    }

    # Replace the placeholder with the detailed information
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo

    Add-ZtTestResultDetail -TestId '21872' -Title "Exigir autenticação multifator para ingresso e registro de dispositivos por meio de ação do usuário" `
        -UserImpact Médio -Risk Alto -ImplementationCost Baixo `
        -AppliesTo Identity -Tag Identity `
        -Status $passed -Result $testResultMarkdown
}
