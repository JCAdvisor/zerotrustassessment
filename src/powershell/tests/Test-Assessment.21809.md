Habilitar o fluxo de trabalho de consentimento do administrador em um locatário do Microsoft Entra é uma medida de segurança vital que mitiga riscos associados ao acesso não autorizado a aplicativos e escalonamento de privilégios. Esta verificação garante que qualquer aplicativo que solicite permissões elevadas passe por um processo de revisão por administradores designados antes que o consentimento seja concedido. Se este fluxo estiver desabilitado, qualquer aplicativo pode solicitar e potencialmente receber permissões elevadas sem revisão administrativa, o que representa um risco substancial.

**Ação de remediação**

Para solicitações de consentimento, defina a configuração **Usuários podem solicitar consentimento do administrador para aplicativos aos quais não podem consentir** como **Sim**. Especifique quem pode revisar as solicitações.

- [Habilitar o fluxo de trabalho de consentimento do administrador](https://learn.microsoft.com/entra/identity/enterprise-apps/configure-admin-consent-workflow?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enable-the-admin-consent-workflow)
<!--- Results --->
%TestResult%
