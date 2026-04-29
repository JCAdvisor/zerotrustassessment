Quando os logons (sign-ins) de alto risco não são devidamente restritos por meio de políticas de Acesso Condicional, as organizações se expõem a vulnerabilidades de segurança. Atacantes podem explorar essas lacunas para obter acesso inicial por meio de credenciais comprometidas, ataques de preenchimento de credenciais (credential stuffing) ou padrões de logon anômalos que o Microsoft Entra ID Protection identifica como comportamentos de risco. Sem as restrições adequadas, criminosos que se autenticam com sucesso em cenários de alto risco podem realizar escalonamento de privilégios, abusando da sessão autenticada para acessar recursos sensíveis, modificar configurações de segurança ou realizar reconhecimento (reconnaissance) dentro do ambiente.

Uma vez estabelecido o acesso através de logons de alto risco não controlados, os invasores podem obter persistência criando contas adicionais ou modificando políticas de autenticação para manter o acesso a longo prazo. O acesso irrestrito permite movimento lateral entre sistemas e aplicativos, acessando repositórios de dados sensíveis ou interfaces administrativas.

**Ação de remediação**

- [Implantar uma política de Acesso Condicional para exigir MFA para risco de logon elevado](https://learn.microsoft.com/entra/identity/conditional-access/policy-risk-based-sign-in?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
