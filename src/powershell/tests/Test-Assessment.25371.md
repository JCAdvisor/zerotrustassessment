A Avaliação de Acesso Contínuo Universal (Universal CAE) valida os tokens de acesso à rede sempre que uma conexão é estabelecida através de túneis do Global Secure Access. Sem o Universal CAE, os tokens permanecem válidos por 60 a 90 minutos, independentemente de mudanças no estado do usuário.

Sem essa proteção:

- Um agente de ameaça que obtém um token por meio de roubo ou repetição pode continuar acessando todos os recursos protegidos pelo Global Secure Access mesmo após a conta do usuário ser desativada ou a senha ser redefinida.
- Eventos críticos, como revogação de sessão ou detecção de alto risco do usuário, não solicitam reautenticação imediata.
- Funcionários que saem da empresa ou usuários internos mal-intencionados mantêm acesso em nível de rede a recursos corporativos privados por até 90 minutos após a ação de remediação ser tomada.
- Ataques de repetição de token de endereços IP diferentes não são bloqueados sem o modo de Imposição Estrita.

**Ação de remediação**
- Revise os recursos do [Universal CAE](https://learn.microsoft.com/entra/global-secure-access/concept-universal-continuous-access-evaluation?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para Global Secure Access.
- Remova ou modifique as políticas de Acesso Condicional que desabilitam o CAE para cargas de trabalho do Global Secure Access.
- Configure o Universal CAE para usar o modo de Imposição Estrita para proteção aprimorada contra repetição de token.
<!--- Results --->
%TestResult%
