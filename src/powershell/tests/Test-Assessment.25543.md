O Web Application Firewall (WAF) do Azure Front Door protege aplicações da web contra exploração de vulnerabilidades comuns, incluindo injeção de SQL, script entre sites e outras ameaças do OWASP Top 10. O WAF opera em dois modos: Detecção e Prevenção. O modo Detecção avalia e registra solicitações que correspondem às regras de WAF, mas não bloqueia o tráfego, enquanto o modo Prevenção bloqueia ativamente solicitações maliciosas antes de chegarem ao aplicativo de backend. Quando o WAF está no modo Detecção, os aplicativos da web permanecem expostos a exploração, embora as ameaças estejam sendo identificadas.

Sem WAF no modo Prevenção:

- Atores de ameaça podem explorar vulnerabilidades de aplicativos da web porque as solicitações correspondidas são apenas registradas, não bloqueadas.
- As organizações perdem a proteção ativa na borda global que as regras de WAF gerenciadas e personalizadas fornecem, o que reduz o WAF a uma ferramenta de observação em vez de um controle de segurança.

**Ação de remediação**

- [Configure o WAF para o Azure Front Door](https://learn.microsoft.com/azure/web-application-firewall/afds/afds-overview?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para mudar a política de WAF do **modo Detecção** para o **modo Prevenção**.
- [Configure as configurações de política de WAF para o Azure Front Door](https://learn.microsoft.com/azure/web-application-firewall/afds/waf-front-door-policy-settings?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#waf-mode) para ativar o **modo Prevenção** nas configurações da política.
<!--- Results --->
%TestResult%
