Atores de ameaça frequentemente visam interfaces de gerenciamento legadas, como o módulo Azure AD PowerShell (AzureAD e AzureADPreview), que não suportam autenticação moderna, imposição de Acesso Condicional ou log de auditoria avançado. O uso contínuo desses módulos expõe o ambiente a riscos, incluindo autenticação fraca, bypass de controles de segurança e visibilidade incompleta das ações administrativas. Atacantes podem explorar essas fraquezas para obter acesso não autorizado, escalar privilégios e realizar alterações maliciosas.

Bloqueie o módulo Azure AD PowerShell e imponha o uso do Microsoft Graph PowerShell ou Microsoft Entra PowerShell para garantir que apenas canais de gerenciamento seguros, suportados e auditáveis estejam disponíveis, fechando lacunas críticas na cadeia de ataque.

**Ação de correção**

- [Desativar o logon de usuário para o aplicativo](https://learn.microsoft.com/entra/identity/enterprise-apps/disable-user-sign-in-portal?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
