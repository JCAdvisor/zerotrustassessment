Quando as políticas de Conditional Access não protegem os aplicativos Private Access exigindo autenticação forte, agentes de ameaça podem usar ataques de phishing, credential stuffing ou password spraying para obter credenciais de usuário e entrar em aplicativos privados apenas com uma senha comprometida.

Sem autenticação forte:

- Agentes de ameaça ganham acesso inicial a recursos internos que deveriam ser protegidos por controles mais fortes.
- Se a autenticação multifator estiver ausente ou métodos suscetíveis a phishing como SMS ou voz forem usados, ataques de adversário no meio podem ocorrer, nos quais os agentes de ameaça interceptam tokens de autenticação e cookies de sessão.
- Agentes de ameaça podem mover-se lateralmente a partir do aplicativo privado inicialmente comprometido para outros recursos internos.

A Microsoft recomenda aplicar métodos de autenticação resistente a phishing, como chaves de segurança FIDO2, Windows Hello for Business ou autenticação baseada em certificado para acesso a aplicativos privados, com autenticação multifator como o mínimo aceitável.

**Ação de remediação**

- [Configure políticas de Conditional Access para exigir autenticação resistente a phishing](https://learn.microsoft.com/entra/identity/conditional-access/policy-all-users-mfa-strength?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%
