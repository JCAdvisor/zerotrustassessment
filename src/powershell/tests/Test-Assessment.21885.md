Aplicações OAuth configuradas com URLs que incluem curingas (wildcards) ou encurtadores de URL aumentam a superfície de ataque para atores de ameaças. URIs de redirecionamento inseguros (reply URLs) podem permitir que adversários manipulem solicitações de autenticação, sequestrem códigos de autorização e interceptem tokens ao direcionar usuários para endpoints controlados pelo invasor. Entradas com curingas expandem o risco ao permitir que domínios não pretendidos processem respostas de autenticação, enquanto URLs curtas podem facilitar phishing e roubo de tokens em ambientes não controlados.

Sem uma validação estrita das URIs de redirecionamento, os invasores podem burlar controles de segurança, personificar aplicações legítimas e escalar seus privilégios. Essa má configuração permite persistência, acesso não autorizado e movimentação lateral, conforme adversários exploram a aplicação fraca de OAuth para infiltrar recursos protegidos sem detecção.

**Ação de correção**

- [Verifique as URIs de redirecionamento para os seus registros de aplicativo.](https://learn.microsoft.com/entra/identity-platform/reply-url?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) Certifique-se de que as URIs de redirecionamento não possuam *.azurewebsites.net, curingas ou encurtadores de URL.
<!--- Results --->
%TestResult%
