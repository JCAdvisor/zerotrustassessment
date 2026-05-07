O Web Application Firewall (WAF) do Azure Application Gateway oferece limitação de taxa por meio de regras personalizadas que restringem o número de requisições por janela de tempo. Esse controle protege aplicações contra abuso ao limitar clientes que excedem limiares definidos.

Sem limitação de taxa, agentes mal-intencionados podem executar brute force, credential stuffing, abuso de APIs e negação de serviço na camada de aplicação para esgotar recursos.

As regras de limitação de taxa usam `RateLimitRule` e permitem definir limiares por requisições/minuto, com agrupamento por IP do cliente (`groupBy` com `ClientAddr`). Ao exceder o limite, o WAF pode bloquear, registrar ou redirecionar. Diferente de rulesets gerenciados, essa defesa é quantitativa e reduz impacto de ataques volumétricos, mesmo quando requisições individuais parecem legítimas.


**Ação de remediação**

- [O que é o Azure Web Application Firewall no Azure Application Gateway?](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview) - Visão geral dos recursos do WAF no Application Gateway, incluindo regras personalizadas
- [Criar e usar regras personalizadas do Web Application Firewall v2 no Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/create-custom-waf-rules) - Passo a passo para criar regras personalizadas, incluindo limitação de taxa
- [Regras personalizadas do Web Application Firewall](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/custom-waf-rules-overview) - Documentação detalhada dos tipos de regra, incluindo `RateLimitRule`
- [Limitação de taxa no WAF do Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/rate-limiting-overview) - Visão geral de capacidades e opções de configuração


<!--- Results --->
%TestResult%
