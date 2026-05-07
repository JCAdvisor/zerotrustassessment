O Web Application Firewall (WAF) do Azure Front Door oferece limitacao de taxa por meio de regras personalizadas que restringem o numero de requisicoes que os clientes podem fazer dentro de uma janela de tempo especifica na rede global de borda. A limitacao de taxa e um mecanismo de defesa critico que protege aplicacoes contra abuso, reduzindo a velocidade de clientes que excedem os limites definidos antes que o trafego alcance os servidores de origem.

Sem a limitacao de taxa configurada, agentes mal-intencionados podem executar ataques de forca bruta, credential stuffing, abuso de API e ataques de negacao de servico na camada de aplicacao que inundam endpoints com requisicoes e esgotam a capacidade do servidor.

As regras de limitacao de taxa usam o tipo de regra `RateLimitRule` e permitem que administradores definam limites com base na contagem de requisicoes por minuto, com possibilidade de agrupar requisicoes por endereco IP do cliente. Quando um cliente ultrapassa o limite configurado, o WAF pode bloquear requisicoes subsequentes, registrar a violacao, emitir um desafio CAPTCHA ou redirecionar para uma pagina personalizada.

Esta verificacao identifica politicas de WAF do Azure Front Door que estao anexadas a um Azure Front Door e valida se pelo menos uma regra de limitacao de taxa esta configurada e habilitada.

**Ação de remediação**

- [Web Application Firewall do Azure no Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview)
- [Regras personalizadas do Web Application Firewall para Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-custom-rules)
- [Limitacao de taxa para o WAF do Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-rate-limit)
- [Tutorial: Criar uma politica de Web Application Firewall no Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-create-portal)

<!--- Results --->
%TestResult%
