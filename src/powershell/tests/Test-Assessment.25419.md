Sem logs do Global Secure Access integrados a um espaço de trabalho do Microsoft Sentinel, as equipes de operações de segurança carecem de visibilidade centralizada sobre padrões de tráfego de rede, tentativas de conexão e anomalias de acesso no Private Access, Internet Access e encaminhamento de tráfego do Microsoft 365. Atores de ameaça que comprometem credenciais de usuário ou dispositivos podem usar esses caminhos de acesso à rede para executar reconhecimento, se mover lateralmente ou exfiltrar dados sem detecção.

Sem essa integração:

- As equipes de segurança não podem correlacionar atividades em nível de rede com sinais baseados em identidade no Microsoft Entra ID ou detecções de endpoint.
- Os sistemas de gerenciamento de informações e eventos de segurança (SIEM) não podem aplicar análises comportamentais, correlação de inteligência de ameaças ou playbooks de resposta automatizados ao tráfego do Global Secure Access.
- As equipes de segurança não podem investigar padrões históricos de acesso à rede ou caçar ameaças entre sinais de rede e identidade.

**Ação de remediação**

- [Configure as configurações de diagnóstico do Microsoft Entra](https://learn.microsoft.com/entra/global-secure-access/how-to-sentinel-integration?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para enviar logs do Global Secure Access a um espaço de trabalho do Log Analytics para integração com o Microsoft Sentinel.
- [Ative todas as categorias de log de identidade do Global Secure Access necessárias](https://learn.microsoft.com/entra/identity/monitoring-health/concept-diagnostic-settings-logs-options?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci), incluindo `NetworkAccessTrafficLogs`, `EnrichedOffice365AuditLogs`, `RemoteNetworkHealthLogs`, `NetworkAccessAlerts`, `NetworkAccessConnectionEvents` e `NetworkAccessGenerativeAIInsights` nas configurações de diagnóstico.
- [Integre os logs de atividade do Microsoft Entra com o Azure Monitor](https://learn.microsoft.com/entra/identity/monitoring-health/howto-integrate-activity-logs-with-azure-monitor-logs?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para coleta centralizada de logs.
- [Configure um espaço de trabalho do Microsoft Sentinel](https://learn.microsoft.com/azure/sentinel/quickstart-onboard?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) e instale a solução Global Secure Access do content hub.
<!--- Results --->
%TestResult%
