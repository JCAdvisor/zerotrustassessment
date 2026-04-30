URIs de redirecionamento não mantidas ou órfãs em registros de aplicativos criam vulnerabilidades de segurança significativas quando referenciam domínios que não apontam mais para recursos ativos. Atores de ameaças podem explorar essas entradas de DNS "pendentes" (dangling) ao provisionar recursos em domínios abandonados, assumindo efetivamente o controle dos endpoints de redirecionamento. Essa vulnerabilidade permite que invasores interceptem tokens de autenticação e credenciais durante os fluxos do OAuth 2.0, o que pode levar ao acesso não autorizado, sequestro de sessão e potencial comprometimento organizacional mais amplo.

**Ação de correção**

- [Visão geral e restrições de URI de redirecionamento (reply URL)](https://learn.microsoft.com/entra/identity-platform/reply-url?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
