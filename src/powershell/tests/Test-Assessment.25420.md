Sem retenção estendida para auditoria do Global Secure Access e logs de tráfego, atores de ameaça podem operar além da janela de retenção padrão de 30 dias, sabendo que suas atividades são automaticamente apagadas antes da detecção. As investigações de segurança geralmente exigem análise histórica que abrange semanas ou meses para identificar vetores de comprometimento, padrões de movimento lateral e canais de exfiltração de dados.

Sem retenção adequada de logs:

- As equipes de segurança não podem estabelecer padrões de comportamento de linha de base, executar caça de ameaças retrospectiva ou correlacionar eventos de acesso à rede em períodos estendidos.
- As organizações sujeitas a estruturas regulatórias como [GDPR](https://learn.microsoft.com/compliance/regulatory/gdpr?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci), HIPAA, PCI DSS e SOX enfrentam violações de conformidade quando não conseguem produzir trilhas de auditoria para períodos de retenção obrigatórios.
- A análise da causa raíz durante a resposta a incidentes é limitada, potencialmente permitindo que atores de ameaça mantenham persistência enquanto as organizações se concentram em sintomas visíveis.

**Ação de remediação**

- [Configure as configurações de diagnóstico com um espaço de trabalho do Log Analytics](https://learn.microsoft.com/entra/identity/monitoring-health/howto-integrate-activity-logs-with-azure-monitor-logs?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para uma retenção estendida de 90-730 dias, com recursos de consulta.
- [Configure a retenção do espaço de trabalho do Log Analytics](https://learn.microsoft.com/azure/azure-monitor/logs/data-retention-archive?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para atender aos requisitos de segurança e conformidade organizacionais (mínimo de 90 dias recomendado).
- [Ative a retenção em nível de tabela](https://learn.microsoft.com/azure/azure-monitor/logs/data-retention-archive?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#configure-table-level-retention) para tabelas especiais do Global Secure Access para estender além dos padrões do espaço de trabalho.
<!--- Results --->
%TestResult%
