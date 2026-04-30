Eventos de criação de locatário (tenant) devem ser monitorados e triados para detectar a criação não autorizada de tenants. Usuários com permissões suficientes podem criar novos locatários, que poderiam ser usados para estabelecer ambientes sombra (shadow environments) fora do monitoramento de segurança da sua organização. O roteamento de logs de auditoria para um SIEM e a configuração de alertas para eventos de criação de locatário permitem que as equipes de segurança investiguem e respondam rapidamente a atividades potencialmente maliciosas.

**Ação de remediação**

- [Revisar e restringir permissões para criar locatários](https://learn.microsoft.com/entra/identity/role-based-access-control/permissions-reference?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Transmitir logs de auditoria para um hub de eventos para integração com SIEM](https://learn.microsoft.com/entra/identity/monitoring-health/howto-stream-logs-to-event-hub?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Configurar monitoramento e alertas para eventos de auditoria](https://learn.microsoft.com/entra/identity/monitoring-health/overview-monitoring-health?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
