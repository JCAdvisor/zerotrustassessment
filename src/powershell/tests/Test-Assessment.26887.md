O Azure Firewall processa todo o tráfego de rede de entrada e saída das cargas protegidas, sendo um ponto crítico de controle para monitoramento de segurança. Sem log de diagnóstico habilitado, a equipe de segurança perde visibilidade sobre padrões de tráfego, tentativas negadas, correspondências de inteligência de ameaças e detecções de assinaturas IDPS. Isso compromete investigações, correlação com outras telemetrias e requisitos de conformidade.

**Ação de remediação**

Crie um workspace do Log Analytics para armazenar logs do Azure Firewall
- [Criar um workspace do Log Analytics](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/quick-create-workspace)

Configure as definições de diagnóstico do Azure Firewall para habilitar a coleta de logs
- [Criar definições de diagnóstico no Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/create-diagnostic-settings)

Habilite logs estruturados (modo específico do recurso) para melhorar desempenho de consulta e otimização de custos
- [Logs estruturados do Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/monitor-firewall#structured-azure-firewall-logs)

Use o Azure Firewall Workbook para visualizar e analisar logs do firewall
- [Azure Firewall Workbook](https://learn.microsoft.com/en-us/azure/firewall/firewall-workbook)

Monitor Azure Firewall metrics and logs for security operations
- [Monitor Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/monitor-firewall)

<!--- Results --->
%TestResult%
