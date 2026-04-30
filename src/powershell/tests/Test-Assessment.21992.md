Se os certificados não forem rotacionados regularmente, eles podem dar aos agentes de ameaças uma janela estendida para extraí-los e explorá-los, levando ao acesso não autorizado. Quando credenciais como essas são expostas, os atacantes podem misturar suas atividades maliciosas com operações legítimas, facilitando a evasão de controles de segurança. Se um atacante comprometer o certificado de um aplicativo, ele poderá escalar seus privilégios dentro do sistema, levando a um acesso e controle mais amplos, dependendo dos privilégios do aplicativo.

Consulte todas as suas entidades de serviço (service principals) e registros de aplicativos que possuem credenciais de certificado. Certifique-se de que a data de início do certificado seja inferior a 180 dias.

**Ação de correção**

- [Definir uma política de gerenciamento de aplicativos para gerenciar o tempo de vida dos certificados](https://learn.microsoft.com/graph/api/resources/applicationauthenticationmethodpolicy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Definir uma cadeia de confiança de certificados confiáveis](https://learn.microsoft.com/graph/api/resources/certificatebasedapplicationconfiguration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Criar uma função personalizada de privilégio mínimo para rotacionar credenciais de aplicativos](https://learn.microsoft.com/entra/identity/role-based-access-control/custom-create?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Saiba mais sobre as políticas de gerenciamento de aplicativos para gerenciar credenciais baseadas em certificado](https://devblogs.microsoft.com/identity/app-management-policy/)
<!--- Results --->
%TestResult%