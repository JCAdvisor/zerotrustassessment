O Web Application Firewall (WAF) do Azure Front Door oferece desafio JavaScript como mecanismo de defesa contra bots automatizados e navegadores headless na rede global de borda. O desafio JavaScript funciona ao entregar um pequeno trecho de JavaScript que precisa ser executado pelo navegador cliente para comprovar que a requisicao vem de um navegador real com capacidade de executar JavaScript, e nao de um cliente HTTP simples ou bot.

Quando uma requisicao aciona um desafio JavaScript, o WAF responde com uma pagina de desafio contendo codigo JavaScript que o navegador deve executar para obter um cookie de desafio valido. Bots e ferramentas automatizadas que nao conseguem executar JavaScript falham nesse desafio e sao bloqueados de acessar recursos protegidos.

A configuracao `javascriptChallengeExpirationInMinutes` controla por quanto tempo o cookie de desafio permanece valido antes de o cliente precisar concluir outro desafio. O desafio JavaScript oferece um meio-termo entre permitir todo o trafego e bloquear imediatamente bots suspeitos.

Esta verificacao identifica politicas de WAF do Azure Front Door que estao anexadas a um Azure Front Door e valida se pelo menos uma regra personalizada com acao de desafio JavaScript esta configurada e habilitada.

**Ação de remediação**

- [Web Application Firewall do Azure no Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview)
- [Regras personalizadas do Web Application Firewall para Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-custom-rules)
- [Configurar desafio JavaScript para o WAF do Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-tuning#javascript-challenge)
- [Tutorial: Criar uma politica de Web Application Firewall no Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-create-portal)

<!--- Results --->
%TestResult%
