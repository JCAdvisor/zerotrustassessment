A Avaliação Contínua de Acesso Universal (Universal CAE) valida os tokens de acesso à rede toda vez que uma conexão é estabelecida por túneis do Global Secure Access. Sem o Universal CAE, os tokens permanecem válidos por 60 a 90 minutos, independentemente das alterações no estado do usuário.

Sem essa proteção:

- Um agente de ameaça que obtém um token por roubo ou repetição pode continuar acessando todos os recursos protegidos pelo Global Secure Access mesmo após a conta do usuário ser desativada ou a senha ser redefinida.
- Eventos críticos como revogação de sessão ou detecção de alto risco do usuário não acionam reautenticação imediata.
- Funcionários que saem ou insiders maliciosos mantêm acesso em nível de rede a recursos corporativos privados por até 90 minutos após a ação de remediação.
- Ataques de repetição de token a partir de IPs diferentes não são bloqueados sem o modo de Aplicação Rigorosa.

**Ação de remediação**
- Revise os recursos do [Universal CAE](https://learn.microsoft.com/entra/global-secure-access/concept-universal-continuous-access-evaluation?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para o Global Secure Access.
- Remova ou modifique políticas de Conditional Access que desabilitam o CAE para cargas de trabalho do Global Secure Access. Para mais informações, veja [Avaliação contínua de acesso](https://learn.microsoft.com/entra/identity/conditional-access/concept-continuous-access-evaluation?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Configure o Universal CAE para usar o modo de Aplicação Rigorosa para proteção aprimorada contra repetição de token. Para mais informações, veja [Avaliação Contínua de Acesso Universal](https://learn.microsoft.com/entra/global-secure-access/concept-universal-continuous-access-evaluation?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#strict-enforcement-mode).
<!--- Results --->
%TestResult%
