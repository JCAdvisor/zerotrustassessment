Considere que usuários de alto risco foram comprometidos por atacantes. Sem investigação e remediação, os invasores podem executar scripts, implantar aplicativos maliciosos ou manipular chamadas de API para estabelecer persistência, com base nas permissões do usuário comprometido. Atacantes podem então explorar configurações incorretas ou abusar de tokens OAuth para se mover lateralmente entre cargas de trabalho, como documentos, aplicativos SaaS ou recursos do Azure.

Organizações que usam senhas podem contar com a redefinição de senha para remediar automaticamente usuários de risco. Organizações que utilizam credenciais sem senha (passwordless) devem bloquear o acesso de usuários de risco até que o risco seja investigado e remediado.

**Ação de remediação**
- [Implantar política de Acesso Condicional para exigir alteração de senha segura para risco de usuário elevado](https://learn.microsoft.com/entra/identity/conditional-access/policy-risk-based-user?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Use o Microsoft Entra ID Protection para [investigar o risco detalhadamente](https://learn.microsoft.com/entra/id-protection/howto-identity-protection-investigate-risk?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%
