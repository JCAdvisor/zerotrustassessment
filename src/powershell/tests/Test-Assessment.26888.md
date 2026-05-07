O WAF do Azure Application Gateway protege aplicações web contra vulnerabilidades comuns, como SQL injection e cross-site scripting. Quando o log de diagnóstico não está habilitado, a equipe de segurança perde visibilidade sobre ataques bloqueados, correspondência de regras, padrões de acesso e eventos do firewall. Sem logs, não há correlação adequada com outras telemetrias, o que prejudica investigações e conformidade.

**Ação de remediação**

Crie um workspace do Log Analytics para armazenar logs do WAF do Application Gateway
- [Criar um workspace do Log Analytics](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/quick-create-workspace)

Configure as definições de diagnóstico do Application Gateway para habilitar coleta de logs
- [Criar definições de diagnóstico no Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/create-diagnostic-settings)

Habilite o log do WAF para capturar eventos de firewall e correspondências de regras
- [Logs e métricas do WAF do Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/application-gateway-waf-metrics)

Monitore o Application Gateway usando logs e métricas de diagnóstico
- [Monitor Azure Application Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/application-gateway-diagnostics)

Use Azure Monitor Workbooks for visualizing and analyzing WAF logs
- [Azure Monitor Workbooks](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview)

<!--- Results --->
%TestResult%
