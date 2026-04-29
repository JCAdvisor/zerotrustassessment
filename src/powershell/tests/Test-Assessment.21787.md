Um atacante ou um funcionário bem-intencionado, mas desinformado, pode criar um novo locatário (tenant) do Microsoft Entra se não houver restrições em vigor. Por padrão, o usuário que cria um locatário recebe automaticamente a função de Administrador Global. Sem os controles adequados, essa ação fratura o perímetro de identidade ao criar um locatário fora da governança e visibilidade da organização. Isso introduz riscos por meio de uma plataforma de identidade paralela (shadow identity) que pode ser explorada para emissão de tokens, personificação de marca, phishing de consentimento ou infraestrutura de persistência. Como o locatário invasor pode não estar vinculado aos planos administrativos ou de monitoramento da empresa, as defesas tradicionais ficam cegas à sua criação, atividade e potencial uso indevido.

**Ação de remediação**

Habilite a configuração **Restringir usuários não administradores de criar locatários**. Para usuários que precisam da capacidade de criar locatários, atribua a eles a função de Criador de Locatário (Tenant Creator). Você também pode revisar eventos de criação de locatários nos logs de auditoria do Microsoft Entra.

- [Restringir as permissões padrão de usuários membros](https://learn.microsoft.com/entra/fundamentals/users-default-permissions?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#restrict-member-users-default-permissions)
- [Atribuir a função de Criador de Locatário](https://learn.microsoft.com/entra/identity/role-based-access-control/permissions-reference?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#tenant-creator)
- [Revisar eventos de criação de locatário](https://learn.microsoft.com/entra/identity/monitoring-health/reference-audit-activities?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#core-directory). Procure por OperationName=="Create Company", Category == "DirectoryManagement".
<!--- Results --->
%TestResult%
