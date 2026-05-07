Quando os aplicativos do Microsoft Entra Private Access carecem de atribuições de usuário ou grupo, os usuários não conseguem estabelecer túneis através do aplicativo para alcançar os nomes de domínio totalmente qualificados (FQDNs) e endereços IP configurados. Essa restrição impede o acesso aos recursos internos protegidos. Sem atribuições, as organizações não conseguem impor políticas do Conditional Access porque essas políticas exigem relações explícitas de usuário para aplicação para avaliar sinais de risco, conformidade de dispositivo e requisitos de força de autenticação.

Sem atribuições de usuário em aplicações do Private Access:

- As organizações perdem a capacidade de impor controles de acesso com o menor privilégio em que os usuários obtêm acesso apenas aos recursos específicos de que precisam.
- As organizações não conseguem aplicar políticas de acesso baseadas em risco que bloqueiam ou desafiam a autenticação com base no risco de entrada, risco do usuário ou conformidade do dispositivo.
- Os sinais de proteção de identidade que detectam comprometimento de credenciais, viagem impossível ou endereços IP anônimos não conseguem proteger recursos privados.

**Ação de remediação**

- [Atribua usuários e grupos aos aplicativos do Private Access](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-per-app-access?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-users-and-groups) para ativar os controles de acesso Zero Trust e a imposição do Conditional Access.
<!--- Results --->
%TestResult%
