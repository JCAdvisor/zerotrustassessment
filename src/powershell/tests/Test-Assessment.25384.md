Uma função de Administrador de Aplicativos com escopo no nível do locatário pode gerenciar todos os registros de aplicativos e aplicativos corporativos. Se um agente de ameaças comprometer um Administrador de Aplicativos com escopo em todo o locatário, ele poderá adicionar credenciais a qualquer entidade de serviço, consentir com APIs maliciosas, modificar ou criar aplicativos que permitam a exfiltração de dados e desativar ou adulterar aplicativos de Acesso Privado. Definir o escopo da função apenas para os aplicativos corporativos de Acesso Privado necessários impõe o privilégio mínimo e limita o raio de explosão (blast radius).

Se você não definir o escopo das atribuições de Administrador de Aplicativos para aplicativos específicos:

- Um Administrador de Aplicativos comprometido pode gerenciar cada registro de aplicativo e aplicativo corporativo em seu locatário.
- Invasores podem adicionar credenciais a qualquer entidade de serviço, permitindo persistência e movimentação lateral.
- Não há contenção do raio de explosão; uma única identidade comprometida pode afetar todos os aplicativos.

**Ação de remediação**

- [Atribua funções de Administrador de Aplicativos com escopo para registros de aplicativos específicos](https://learn.microsoft.com/entra/identity/role-based-access-control/custom-enterprise-app-permissions?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) em vez de em todo o locatário.
- [Atribua funções do Microsoft Entra](https://learn.microsoft.com/entra/identity/role-based-access-control/manage-roles-portal?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) com o privilégio mínimo necessário para realizar as tarefas exigidas.
- [Use o Privileged Identity Management para gerenciar a ativação de função just-in-time](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-configure?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Resultados --->
%TestResult%