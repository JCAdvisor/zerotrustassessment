<#
.SYNOPSIS
    Verifica se todas as políticas de gerenciamento de direitos que se aplicam a usuários externos exigem aprovação.
#>

function Test-Assessment-21879 {
    [ZtTest(
    	Category = 'Colaboração externa',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P2'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21879,
    	Title = 'Todas as políticas de atribuição de pacotes de acesso que se aplicam a usuários externos exigem aprovação',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando se todas as políticas de gerenciamento de direitos que se aplicam a usuários externos exigem aprovação'
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de atribuição'

    if ( -not (Get-ZtLicense EntraIDP2) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP2
        return
    }

    # Consultar políticas de atribuição diretamente com informações expandidas do pacote de acesso
    $assignmentPolicies = Invoke-ZtGraphRequest -RelativeUri 'identityGovernance/entitlementManagement/assignmentPolicies' -QueryParameters @{'$expand' = 'accessPackage' } -ApiVersion v1.0

    # Lidar com o caso onde não existem políticas ou a API retorna nulo
    if ($null -eq $assignmentPolicies -or $assignmentPolicies.Count -eq 0) {
        Write-PSFMessage 'Nenhuma política de atribuição encontrada no tenant' -Level Verbose
        $testResultMarkdown = 'Nenhuma política de atribuição de pacotes de acesso encontrada no tenant.'
        $passed = $true
    }
    else {
        Write-ZtProgress -Activity $activity -Status 'Filtrando políticas para usuários externos'

        # Filtro do lado do cliente para políticas que se aplicam a usuários externos
        $externalUserPolicies = @()

        foreach ($policy in $assignmentPolicies) {
            # Pular se requestorSettings for nulo ou estiver ausente
            if ($null -eq $policy.requestorSettings) {
                Write-PSFMessage "Pulando política $($policy.id) - sem requestorSettings" -Level Debug
                continue
            }

            # Verificar se a política aceita solicitações
            if ($policy.requestorSettings.acceptRequests -eq $true) {
                # Usar a função Test-ZtExternalUserScope existente para verificar se a política se aplica a usuários externos
                $appliesToExternal = Test-ZtExternalUserScope -TargetScope $policy.allowedTargetScope

                if ($appliesToExternal) {
                    $externalUserPolicies += [PSCustomObject]@{
                        AccessPackageId           = $policy.accessPackage.id
                        AccessPackageName         = $policy.accessPackage.displayName
                        AssignmentPolicyId        = $policy.id
                        AssignmentPolicyName      = $policy.displayName
                        AssignmentPolicyScopeType = $policy.allowedTargetScope
                        IsApprovalRequired        = [bool]($policy.requestorSettings.approvalSettings.isApprovalRequired)
                    }
                }
            }
        }

        Write-ZtProgress -Activity $activity -Status 'Avaliando requisitos de aprovação'

        if ($externalUserPolicies.Count -eq 0) {
            $testResultMarkdown = 'Nenhuma política de atribuição de pacotes de acesso encontrada que se aplique a usuários externos.'
            $passed = $true
        }
        else {
            # Lógica Passa/Falha: Se houver pelo menos um resultado onde isApprovalRequired == "false", reprovar o teste. Caso contrário, aprovar.
            $policiesWithoutApproval = $externalUserPolicies | Where-Object { $_.IsApprovalRequired -eq $false }

            if ($policiesWithoutApproval.Count -eq 0) {
                # PASSA: Nenhuma política sem aprovação
                $passed = $true
                $testResultMarkdown = 'Todas as políticas de atribuição de pacotes de acesso para usuários externos exigem aprovação'
            }
            else {
                # FALHA: Pelo menos uma política sem aprovação
                $passed = $false
                $testResultMarkdown = 'Foram encontradas no tenant políticas de atribuição de pacotes de acesso para usuários externos sem aprovação'
            }

            # Detalhes: Para cada política encontrada
            $testResultMarkdown += "`n`n## Detalhes`n`n"
            $testResultMarkdown += "Políticas de atribuição que se aplicam a usuários externos:`n`n"
            $testResultMarkdown += '| ID do Pacote de Acesso | Nome do Pacote de Acesso | ID da Política de Atribuição | Nome da Política de Atribuição | Tipo de Escopo da Política | Aprovação Necessária |`n'
            $testResultMarkdown += '|:---|:---|:---|:---|:---|:---|`n'

            foreach ($policy in $externalUserPolicies) {
                $packageLink = "https://entra.microsoft.com/#view/Microsoft_AAD_ERM/DashboardBlade/~/elmEntitlementManagement/menuId/AccessPackages"
                $approvalStatus = if ($policy.IsApprovalRequired) {
                    'true'
                }
                else {
                    'false'
                }

                $testResultMarkdown += "| ``$($policy.AccessPackageId)`` | [$(Get-SafeMarkdown $policy.AccessPackageName)]($packageLink) | ``$($policy.AssignmentPolicyId)`` | $(Get-SafeMarkdown $policy.AssignmentPolicyName) | $($policy.AssignmentPolicyScopeType) | **$approvalStatus** |`n"
            }
        }
    }

    $params = @{
        TestId = '21879'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
