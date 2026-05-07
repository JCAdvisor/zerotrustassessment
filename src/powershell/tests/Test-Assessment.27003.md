Ao usar inspeção de Transport Layer Security (TLS), o Global Secure Access pode descriptografar tráfego HTTPS e verificá-lo contra ameaças, conteúdo malicioso e violações de política. Quando a inspeção falha, o tráfego pode contornar controles de segurança, permitindo que malware, comando e controle e exfiltração de dados passem sem detecção.

Taxas de falha acima de 1% indicam problemas sistêmicos, como confiança de certificado inadequada em endpoints, aplicações incompatíveis com certificate pinning sem regras de bypass apropriadas, ou erros de configuração de autoridade certificadora. Agentes mal-intencionados também podem provocar falhas de inspeção intencionalmente.

**Ação de remediação**

- [Configure definições de diagnóstico para exportar logs de tráfego](https://learn.microsoft.com/entra/global-secure-access/how-to-view-traffic-logs?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#configure-diagnostic-settings-to-export-logs) para um workspace do Log Analytics. Use esses logs para monitorar taxas de sucesso da inspeção TLS e investigar causas de falhas.
- Siga as etapas em [Solucionar erros de inspeção de Transport Layer Security no Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/troubleshoot-transport-layer-security?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para resolver falhas comuns.
- Para destinos com certificate pinning, [adicione regras de bypass TLS](https://learn.microsoft.com/entra/global-secure-access/how-to-transport-layer-security?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para reduzir falhas e manter inspeção no restante do tráfego.
<!--- Results --->
%TestResult%
