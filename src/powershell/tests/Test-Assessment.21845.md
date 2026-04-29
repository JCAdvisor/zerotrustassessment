Sem o Passe de Acesso Temporário (TAP) ativado, as organizações enfrentam desafios significativos para realizar o bootstrapping seguro das credenciais de usuário, criando uma vulnerabilidade onde os usuários dependem de mecanismos de autenticação fracos durante sua configuração inicial. Quando os usuários não podem registrar credenciais resistentes a phishing, como chaves de segurança FIDO2 ou Windows Hello for Business, por falta de métodos de autenticação forte existentes, eles permanecem expostos a ataques baseados em credenciais, incluindo phishing e pulverização de senhas. Atores de ameaça podem explorar essa lacuna de registro visando os usuários em seu estado mais vulnerável, quando possuem opções limitadas e dependem de combinações tradicionais de usuário + senha. Essa exposição permite o comprometimento de contas durante a fase crítica de configuração, permitindo a manipulação do processo de registro para métodos de autenticação forte e ganhando acesso persistente.

Ative o TAP e use-o com o registro de informações de segurança para proteger essa lacuna potencial em suas defesas.

**Ação de correção**

- [Saiba como ativar o Passe de Acesso Temporário na política de métodos de autenticação](https://learn.microsoft.com/entra/identity/authentication/howto-authentication-temporary-access-pass?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enable-the-temporary-access-pass-policy)
- [Saiba como atualizar as políticas de força de autenticação para incluir o Passe de Acesso Temporário](https://learn.microsoft.com/entra/identity/authentication/concept-authentication-strength-advanced-options?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Saiba como criar uma política de Acesso Condicional para registro de informações de segurança com imposição de força de autenticação](https://learn.microsoft.com/entra/identity/conditional-access/policy-all-users-security-info-registration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
