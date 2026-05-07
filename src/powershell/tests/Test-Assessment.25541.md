O Web Application Firewall (WAF) do Azure Application Gateway protege aplicações da web contra exploração de vulnerabilidades comuns, incluindo injeção de SQL, script entre sites e outras ameaças do OWASP Top 10. O WAF opera em dois modos: Detecção e Prevenção. O modo Detecção registra solicitações correspondidas, mas não bloqueia o tráfego, enquanto o modo Prevenção bloqueia ativamente solicitações maliciosas antes de chegarem ao aplicativo de backend. Quando o WAF está no modo Detecção, os aplicações da web permanecem expostos a explorações, embora as ameaças estejam sendo identificadas.

Sem WAF no modo Prevenção:

- Atores de ameaça podem explorar vulnerabilidades de aplicação da web, como injeção de SQL e script entre sites, porque as solicitações correspondidas são apenas registradas, não bloqueadas.
- As organizações perdem a proteção ativa que as regras de WAF gerenciadas e personalizadas fornecem, o que reduz o WAF a uma ferramenta de observabilidade em vez de um controle de segurança.

**Ação de remediação**

- [Configure o WAF no Azure Application Gateway](https://learn.microsoft.com/azure/web-application-firewall/ag/ag-overview?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#waf-modes) para mudar a política de WAF do **modo Detecção** para o **modo Prevenção**.
- [Crie e gerencie políticas de WAF para Application Gateway](https://learn.microsoft.com/azure/web-application-firewall/ag/create-waf-policy-ag?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para aplicar configurações do modo Prevenção em todas as instâncias do Application Gateway.
<!--- Results --->
%TestResult%
