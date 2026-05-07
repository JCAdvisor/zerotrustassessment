O Azure Front Door é um ponto de entrada global e escalável que usa a rede de borda da Microsoft para entregar aplicações web com desempenho e segurança. O WAF integrado ao Azure Front Door protege contra explorações e vulnerabilidades comuns na borda da rede. O ruleset Bot Manager, disponível no SKU Premium, protege contra bots maliciosos e permite bots legítimos, como rastreadores de busca. Sem essa proteção, a organização fica exposta a credential stuffing, scraping, bots de esgotamento de estoque e ataques de negação de serviço na camada de aplicação.

**Ação de remediação**

Faça upgrade para o Azure Front Door Premium, se estiver no Standard, para habilitar recursos de proteção contra bots
- [Comparação de camadas do Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/standard-premium/tier-comparison)

Crie uma política de WAF no SKU Premium, se ainda não existir
- [Criar uma política de WAF para Azure Front Door no portal do Azure](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-create-portal)

Habilite o ruleset Bot Manager na política de WAF
- [Configurar proteção contra bots para Web Application Firewall](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-policy-configure-bot-protection)

Associe a política de WAF ao perfil do Azure Front Door por meio de políticas de segurança
- [Add security policy in Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/how-to-configure-endpoints#add-security-policy)

Configure bot protection rules to customize actions for different bot categories
- [Bot protection rule set on Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview#bot-protection-rule-set)

Monitor bot traffic using Azure Front Door logs and metrics
- [Monitor metrics and logs in Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-diagnostics)

<!--- Results --->
%TestResult%
