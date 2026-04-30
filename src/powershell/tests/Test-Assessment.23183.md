Aplicativos não-Microsoft e multi-inquilinos configurados com URLs que incluem curingas (wildcards), localhost ou encurtadores de URL aumentam a superfície de ataque para agentes de ameaças. Esses URIs de redirecionamento inseguros (URLs de resposta) podem permitir que adversários manipulem solicitações de autenticação, sequestrem códigos de autorização e interceptem tokens direcionando os usuários para endpoints controlados pelo invasor. As entradas com curingas expandem o risco ao permitir que domínios não intencionais processem respostas de autenticação, enquanto URLs de localhost e encurtadores podem facilitar o phishing e o roubo de tokens em ambientes não controlados.

Sem uma validação rigorosa dos URIs de redirecionamento, os invasores podem burlar controles de segurança, personificar aplicativos legítimos e escalar seus privilégios. Essa configuração incorreta permite a persistência, o acesso não autorizado e a movimentação lateral, conforme os adversários exploram a aplicação fraca de OAuth para infiltrar-se em recursos protegidos sem serem detectados.

**Ação de correção**

- [Verificar os URIs de redirecionamento para seus registros de aplicativos.](https://learn.microsoft.com/entra/identity-platform/reply-url?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) Certifique-se de que os URIs de redirecionamento não tenham localhost, *.azurewebsites.net, curingas ou encurtadores de URL.
<!--- Results --->
%TestResult%
