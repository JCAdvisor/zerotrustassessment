<#
.SYNOPSIS
    Returns the description for why a test was skipped.
#>
function Get-ZtSkippedReason {
    [CmdletBinding()]
    param(
        # The reason for skipping
        [string] $SkippedBecause
    )

    switch ($SkippedBecause) {
        "NotConnectedAzure" { "Não conectado ao Azure." ; break}
        "NotConnectedExchange" { "Não conectado ao Exchange Online."; break}
        "NotConnectedSecurityCompliance" { "Não conectado ao Security & Compliance."; break}
        "NotDotGovDomain" { "Este teste é apenas para departamentos e agências federais do poder executivo."; break}
        "NotLicensedEntraIDP1" { "Este teste é para tenants licenciados para o Entra ID P1. Consulte [Licenciamento do Entra ID](https://learn.microsoft.com/entra/fundamentals/licensing)"; break}
        "NotLicensedEntraIDP2" { "Este teste é para tenants licenciados para o Entra ID P2. Consulte [Licenciamento do Entra ID](https://learn.microsoft.com/entra/fundamentals/licensing)"; break}
        "NotLicensedEntraIDGovernance" { "Este teste é para tenants licenciados para o Entra ID Governance. Consulte [Licenciamento do Entra ID Governance](https://learn.microsoft.com/entra/fundamentals/licensing#microsoft-entra-id-governance)"; break}
        "NotLicensedEntraWorkloadID" { "Este teste é para tenants licenciados para o Entra Workload ID. Consulte [Licenciamento do Entra Workload ID](https://learn.microsoft.com/entra/workload-id/workload-identities-faqs)"; break}
        "NotLicensedIntune" { "Este teste é para tenants licenciados para o Microsoft Intune. Consulte [Licenciamento do Microsoft Intune](https://learn.microsoft.com/intune/intune-service/fundamentals/licenses)"; break}
        "NotSupported" { "Este teste depende de funcionalidades não disponíveis atualmente (ex.: cmdlets não disponíveis em todas as plataformas, Resolve-DnsName)"; break}
        "NoAzureAccess" { "O usuário conectado não tem acesso à assinatura do Azure para realizar este teste."; break}
        "NotApplicable" { "Este teste não se aplica ao ambiente atual."; break}
        "NotConnectedToService" { "Este teste requer conexão com o(s) serviço(s) `"{0}`" atualmente desconectado(s). Use _Connect-ZtAssessment_ para conectar."; break}
        "NoCompatibleLicenseFound" { "Este teste requer uma das seguintes licenças: (`"{0}`"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"; break}
        "TimeoutReached" { "Este teste não foi concluído porque a execução do relatório excedeu o tempo esperado. Isso pode ocorrer devido a um grande número de objetos no tenant. Considere adicionar ``-Timeout '03:00:00:00'`` ao ``Invoke-ZtAssessment``."; break}
        default { $SkippedBecause; break}
    }
}
