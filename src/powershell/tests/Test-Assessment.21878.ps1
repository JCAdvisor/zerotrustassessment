<#
.SYNOPSIS
    Avaliação 21878 – Verifica se todas as políticas de gerenciamento de direitos possuem datas de expiração configuradas.
#>

function Test-Assessment-21878 {
    [ZtTest(
    	Category = 'Governança de identidade',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('P2','Governance'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger tenants e isolar sistemas de produção',
    	TenantType = ('Workforce','External'),
    	TestId = 21878,
    	Title = 'Todas as políticas de gerenciamento de direitos possuem uma data de expiração',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ((Get-MgContext).Environment -ne 'Global') {
        Write-PSFMessage "Este teste é aplicável apenas ao ambiente Global." -Tag Test -Level VeryVerbose
        return
    }

    if( -not (Get-ZtLicense EntraIDP2) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedEntraIDP2
        return
    }

    $activity = 'Verificando políticas de atribuição de gerenciamento de direitos para datas de expiração'
    Write-ZtProgress -Activity $activity -Status 'Obtendo políticas de atribuição'

    # Consultar políticas de atribuição de gerenciamento de direitos
    $policies = Invoke-ZtGraphRequest -RelativeUri 'identityGovernance/entitlementManagement/assignmentPolicies' -ApiVersion v1.0

    $matchingPolicies    = @()
    $nonMatchingPolicies = @()

    foreach ($policy in $policies) {
        $expiration    = $policy.expiration
        $hasDuration   = ($expiration.duration) -and ($expiration.type -eq 'afterDuration')
        $hasEndDate    = ($expiration.endDateTime) -and ($expiration.type -eq 'afterDateTime')
        $meetsCriteria = ($hasDuration -or $hasEndDate)

        $detail = [PSCustomObject]@{
            PolicyId       = $policy.id
            DisplayName    = $policy.displayName
            ExpirationType = $expiration.type
            Duration       = $expiration.duration
            EndDateTime    = $expiration.endDateTime
            AccessPackageId= $policy.accessPackageId
            CatalogId      = $policy.catalogId
            CatalogName    = $policy.catalogName
            MeetsCriteria  = $meetsCriteria
        }

        if ($meetsCriteria) {
            $matchingPolicies += $detail
        } else {
            $nonMatchingPolicies += $detail
        }
    }

    function Get-PolicyPortalLink {
        param($policy)
        $catalogName = [uri]::EscapeDataString($policy.CatalogName)
        $entitlementName = [uri]::EscapeDataString($policy.DisplayName)
        return 'https://entra.microsoft.com/#view/Microsoft_Azure_ELMAdmin/EntitlementMenuBlade/~/policies/entitlementId/{0}/catalogId/{1}/catalogName/{2}/entitlementName/{3}' -f $policy.AccessPackageId, $policy.CatalogId, $catalogName, $entitlementName
    }

    $passed = ($nonMatchingPolicies | Measure-Object).Count -eq 0
    $testResultMarkdown = ''

    if ($passed) {
        $testResultMarkdown += '✅ Todas as políticas de gerenciamento de direitos possuem datas de expiração configuradas.'
    } else {
        $testResultMarkdown += '❌ Nem todas as políticas de gerenciamento de direitos possuem datas de expiração configuradas.'
    }

    if (-not $matchingPolicies) {
        $testResultMarkdown += "`nNenhuma política de gerenciamento de direitos foi encontrada com data de expiração configurada."
    } else {
        $testResultMarkdown += "`n### Políticas de Atribuição de Gerenciamento de Direitos com Datas de Expiração`n"
        $testResultMarkdown += '| Nome | Tipo de Expiração | Duração / Data de Término |' + "`n"
        $testResultMarkdown += '| :--- | :--- | ---: |' + "`n"
        foreach ($item in $matchingPolicies) {
            $duration = if ($item.Duration) { $item.Duration } else { '' }
            $endDateTime = if ($item.EndDateTime) { Get-FormattedDate($item.EndDateTime) } else { '' }
            $portalLink = Get-PolicyPortalLink $item
            $testResultMarkdown += '| [{0}]({1}) | {2} | {3}{4} |' -f (Get-SafeMarkdown $item.DisplayName), $portalLink, $item.ExpirationType, $duration, $endDateTime
            $testResultMarkdown += "`n"
        }
    }

    if ($nonMatchingPolicies.Count -gt 0) {
        $testResultMarkdown += "`n#### Políticas sem expiração:`n"
        $testResultMarkdown += '| Nome | Tipo de Expiração | Duração / Data de Término |' + "`n"
        $testResultMarkdown += '| :--- | :--- | ---: |' + "`n"
        foreach ($item in $nonMatchingPolicies) {
            $duration = if ($item.Duration) { $item.Duration } else { '' }
            $endDateTime = if ($item.EndDateTime) { $item.EndDateTime } else { '' }
            $portalLink = Get-PolicyPortalLink $item
            $testResultMarkdown += '| [{0}]({1}) | {2} | {3} | {4} |' -f (Get-SafeMarkdown $item.DisplayName), $portalLink, $item.ExpirationType, $duration, $endDateTime
            $testResultMarkdown += "`n"
        }
    }

    $params = @{
        TestId = '21878'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
