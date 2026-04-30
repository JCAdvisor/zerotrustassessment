Sem uma política de Usuários e Grupos Locais devidamente configurada e atribuída no Intune, os agentes de ameaças podem explorar contas locais não gerenciadas ou mal configuradas em dispositivos Windows. Isso pode levar à escalada de privilégios não autorizada, persistência e movimentação lateral no ambiente. Se as contas de administrador local não forem controladas, os invasores podem criar contas ocultas ou elevar privilégios, contornando os controles de conformidade e segurança. Essa lacuna aumenta o risco de exfiltração de dados, implantação de ransomware e não conformidade regulatória.

Garantir que as políticas de Usuários e Grupos Locais sejam aplicadas em dispositivos Windows gerenciados, usando perfis de proteção de conta, é fundamental para manter uma frota de dispositivos segura e em conformidade.

**Ação de correção**

Configure e implante um perfil de **associação de grupo de usuário local** a partir da política de proteção de conta do Intune para restringir e gerenciar o uso de contas locais em dispositivos Windows:
- Criar uma [Política de proteção de conta para segurança de endpoint no Intune](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-account-protection-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#account-protection-profiles)
- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)
<!--- Results --->
%TestResult%