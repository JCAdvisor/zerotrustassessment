Sem o log de diagnóstico habilitado no WAF do Azure Front Door, as equipes de segurança perdem visibilidade de ataques bloqueados, correspondências de regras, padrões de acesso e eventos na borda da rede. Tentativas de exploração por SQL injection, cross-site scripting e outros ataques OWASP Top 10 podem passar sem detecção. A ausência de logs também prejudica investigações e requisitos de auditoria.

**Ação de remediação**

Configure as definições de diagnóstico do Azure Front Door para habilitar a coleta de logs do WAF
- [Criar definições de diagnóstico no Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/create-diagnostic-settings)

Habilite o log do WAF para capturar eventos de firewall e correspondências de regras
- [Monitoramento e logging do WAF do Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-monitor)

Crie um workspace do Log Analytics para armazenar e analisar logs do WAF
- [Criar um workspace do Log Analytics](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/quick-create-workspace)

Monitore o Azure Front Door usando logs e métricas de diagnóstico
- [Monitor metrics and logs in Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-diagnostics)

<!--- Results --->
%TestResult%
