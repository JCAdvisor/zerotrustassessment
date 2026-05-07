O Web Application Firewall (WAF) do Azure Application Gateway fornece proteção centralizada para aplicações web contra explorações e vulnerabilidades comuns em nível regional. A inspeção do corpo da requisição é uma capacidade crítica que permite ao WAF analisar o conteúdo de requisições HTTP POST, PUT e PATCH em busca de padrões maliciosos. Quando essa inspeção está desabilitada, agentes mal-intencionados podem embutir SQL malicioso, scripts ou payloads de injeção de comando em formulários, chamadas de API e uploads, contornando a avaliação de regras do WAF. Isso abre caminho para exploração, acesso inicial, exfiltração de dados sensíveis e movimentação lateral. Os conjuntos de regras gerenciadas, como OWASP Core Rule Set e Bot Manager da Microsoft, não conseguem bloquear ameaças que não conseguem inspecionar.

**Ação de remediação**

Visão geral dos recursos do WAF no Application Gateway, incluindo inspeção de corpo da requisição
- [O que é o Azure Web Application Firewall no Azure Application Gateway?](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview)

Orientações para criar e configurar políticas de WAF, incluindo parâmetros de inspeção de corpo da requisição
- [Criar políticas de Web Application Firewall para Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/create-waf-policy-ag)

FAQ e boas práticas para ajuste do WAF, incluindo limites de inspeção de corpo da requisição
- [Ajustar Web Application Firewall para Azure Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/application-gateway-waf-faq)

<!--- Results --->
%TestResult%
