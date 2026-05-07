Os perfis de encaminhamento de tráfego são o mecanismo fundamental pelo qual o Global Secure Access captura e roteia o tráfego de rede para a infraestrutura Security Service Edge da Microsoft. Se você não habilitar os perfis de encaminhamento de tráfego apropriados, o tráfego de rede contorna completamente o serviço Global Secure Access, e os usuários não recebem essas proteções de acesso à rede.

Existem três perfis distintos:

- **Perfil de tráfego Microsoft**: captura Microsoft Entra ID, Microsoft Graph, SharePoint Online, Exchange Online e outras cargas de trabalho do Microsoft 365.
- **Perfil de acesso privado**: captura tráfego destinado a recursos corporativos internos.
- **Perfil de acesso à internet**: captura tráfego para internet pública, incluindo aplicações SaaS não Microsoft.

Se você não habilitar esses perfis:

- Você não pode aplicar políticas de segurança, filtragem de conteúdo da web, proteção contra ameaças ou Universal Continuous Access Evaluation.
- Agentes de ameaça que comprometem credenciais de usuário podem acessar recursos corporativos sem os controles de segurança que o Global Secure Access aplicaria.

**Ação de remediação**

- Habilite o perfil de encaminhamento de tráfego Microsoft. Para mais informações, veja [Gerenciar o perfil de tráfego Microsoft](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-microsoft-profile?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Habilite o perfil de encaminhamento de tráfego Private Access. Para mais informações, veja [Gerenciar o perfil de encaminhamento de tráfego Private Access](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-private-access-profile?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Habilite o perfil de encaminhamento de tráfego Internet Access. Para mais informações, veja [Gerenciar o perfil de encaminhamento de tráfego Internet Access](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-internet-access-profile?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%
