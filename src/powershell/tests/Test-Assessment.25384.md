Um administrador de aplicações com escopo ao nível do locatário pode gerenciar todos os registros de aplicativo e aplicações empresariais. Se um agente de ameaça comprometer um administrador de aplicações com escopo em todo o locatário, ele pode adicionar credenciais a qualquer service principal, consentir APIs maliciosas, modificar ou criar aplicações que permitam exfiltração de dados e desabilitar ou manipular apps Private Access. Escopar a função apenas para apps Private Access necessários aplica o menor privilégio e limita a área de impacto.

Se você não escopar as atribuições de Application Administrator para aplicativos específicos:

- Um Application Administrator comprometido pode gerenciar todos os registros de aplicativo e aplicações empresariais em seu locatário.
- Agentes de ameaça podem adicionar credenciais a qualquer service principal, permitindo persistência e movimento lateral.
- Não há contenção da área de impacto; uma única identidade comprometida pode afetar todas as aplicações.

**Ação de remediação**

- [Atribua funções de Application Administrator escopadas a registros de aplicativo específicos](https://learn.microsoft.com/entra/identity/role-based-access-control/custom-enterprise-app-permissions?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) em vez de em todo o locatário.
- [Atribua funções do Microsoft Entra](https://learn.microsoft.com/entra/identity/role-based-access-control/manage-roles-portal?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) com o menor privilégio necessário para executar as tarefas requeridas.
- [Use o Privileged Identity Management para gerenciar a ativação sob demanda de funções](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-configure?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- [Gerencie atribuições de função do Microsoft Entra no centro de administração](https://learn.microsoft.com/entra/identity/role-based-access-control/manage-roles-portal?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%
