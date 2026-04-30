Se as políticas para o Windows Hello para Empresas (WHfB) não estiverem configuradas e atribuídas a todos os utilizadores e dispositivos, os agentes de ameaças podem explorar mecanismos de autenticação fracos — como palavras-passe — para obter acesso não autorizado. Isto pode levar ao roubo de credenciais, escalonamento de privilégios e movimentação lateral dentro do ambiente. Sem uma autenticação forte e baseada em políticas como o WHfB, os atacantes podem comprometer dispositivos e contas, aumentando o risco de um impacto generalizado.

A imposição do WHfB interrompe esta cadeia de ataque ao exigir uma autenticação forte e multifator, o que ajuda a reduzir o risco de ataques baseados em credenciais e acesso não autorizado.

**Ação de correção**

Implemente o Windows Hello para Empresas no Intune para forçar uma autenticação forte e multifator:
- [Configurar uma política de Windows Hello para Empresas ao nível do locatário](https://learn.microsoft.com/intune/intune-service/protect/windows-hello?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-a-windows-hello-for-business-policy-for-device-enrollment) que se aplica no momento em que um dispositivo se regista no Intune.
- Após o registo, [configure perfis de proteção de conta](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-account-protection-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#account-protection-profiles) e [atribua](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups) diferentes configurações de Windows Hello para Empresas a diferentes grupos de utilizadores e dispositivos.
<!--- Results --->
%TestResult%