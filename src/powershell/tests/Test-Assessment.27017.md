O Web Application Firewall (WAF) do Azure Application Gateway oferece desafio JavaScript como mecanismo de defesa contra bots automatizados e navegadores headless. Esse desafio funciona entregando um pequeno trecho de JavaScript que precisa ser executado pelo navegador cliente para comprovar que a requisição vem de um navegador real com capacidade de executar JavaScript, e nao de um cliente HTTP simples ou bot.

Quando uma requisicao aciona o desafio JavaScript, o WAF responde com uma pagina de desafio contendo codigo JavaScript que o navegador deve executar para obter um cookie de desafio valido. Se o cliente executar o JavaScript com sucesso e retornar com um cookie valido, as requisicoes seguintes passam normalmente ate o cookie expirar. Bots e ferramentas automatizadas que nao conseguem executar JavaScript falham nesse desafio e sao bloqueados de acessar recursos protegidos. Esse mecanismo e especialmente eficaz contra bots de credential stuffing, raspadores web e bots de negacao de servico distribuida que usam bibliotecas HTTP simples sem mecanismo JavaScript.

A configuracao `jsChallengeCookieExpirationInMins` controla por quanto tempo o cookie de desafio permanece valido antes de o cliente precisar concluir outro desafio. O desafio JavaScript oferece um meio-termo entre permitir todo o trafego e bloquear imediatamente bots suspeitos: ele valida a capacidade do navegador sem exigir interacao do usuario, como CAPTCHA. Ao configurar regras personalizadas com a acao de desafio JavaScript, as organizacoes podem proteger endpoints sensiveis, como paginas de login, endpoints de API e recursos de alto valor, contra abuso automatizado, mantendo uma experiencia fluida para usuarios legitimos.

**Ação de remediação**

- [O que é o Azure Web Application Firewall no Azure Application Gateway?](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview) - Visao geral das capacidades do WAF no Application Gateway, incluindo regras e acoes personalizadas
- [Criar e usar regras personalizadas do Web Application Firewall v2 no Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/create-custom-waf-rules) - Orientacao passo a passo para criar regras personalizadas com diferentes acoes, incluindo desafio JavaScript
- [Regras personalizadas do Web Application Firewall](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/custom-waf-rules-overview) - Documentacao detalhada dos tipos de regras personalizadas e das acoes disponiveis
- [Visao geral da protecao contra bots para o WAF do Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/bot-protection-overview) - Visao geral dos recursos de protecao contra bots, incluindo acoes de desafio

<!--- Results --->
%TestResult%
