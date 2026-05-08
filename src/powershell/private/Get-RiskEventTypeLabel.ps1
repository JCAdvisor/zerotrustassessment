# Convert the risk event type to human-readable format.
function Get-RiskEventTypeLabel {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        # Risk event type to format
        [string] $RiskEventType
    )

    process {
        if([System.String]::IsNullOrEmpty($RiskEventType)) {
            return $null
        }

        $riskEventTypeList = @{
            "riskyIPAddress" = "Atividade de endereço IP anônimo"
            "generic" = "Risco adicional detectado (entrada)"
            "adminConfirmedUserCompromised" = "Administrador confirmou usuário comprometido"
            "anomalousToken" = "Token anômalo (entrada)"
            "anonymizedIPAddress" = "Endereço IP anônimo"
            "unlikelyTravel" = "Viagem atípica"
            "mcasImpossibleTravel" = "Viagem impossível"
            "maliciousIPAddress" = "Endereço IP malicioso"
            "mcasFinSuspiciousFileAccess" = "Acesso em massa a arquivos confidenciais"
            "investigationsThreatIntelligence" = "Inteligência de ameaças do Microsoft Entra (entrada)"
            "newCountry" = "Novo país"
            "passwordSpray" = "Pulverização de senhas"
            "suspiciousBrowser" = "Navegador suspeito"
            "suspiciousInboxForwarding" = "Encaminhamento suspeito de caixa de entrada"
            "mcasSuspiciousInboxManipulationRules" = "Regras suspeitas de manipulação de caixa de entrada"
            "tokenIssuerAnomaly" = "Anomalia do emissor de token"
            "unfamiliarFeatures" = "Propriedades de entrada desconhecidas"
            "nationStateIP" = "IP de ator de ameaça verificado"
        }

        return $riskEventTypeList[$RiskEventType]
    }
}
