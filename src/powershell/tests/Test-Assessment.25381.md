Os perfis de encaminhamento de tráfego são o mecanismo fundamental através do qual o Global Secure Access captura e roteia o tráfego de rede para a infraestrutura de Security Service Edge da Microsoft. Se você não habilitar os perfis de encaminhamento de tráfego apropriados, o tráfego de rede ignorará inteiramente o serviço Global Secure Access e os usuários não obterão essas proteções de acesso à rede.

Existem três perfis distintos:
- **Perfil de tráfego da Microsoft**: Captura Microsoft Entra ID, Microsoft Graph, SharePoint Online, Exchange Online e outras cargas de trabalho do Microsoft 365.
- **Perfil de acesso privado**: Captura tráfego destinado a recursos corporativos internos.
- **Perfil de acesso à Internet**: Captura tráfego para a Internet pública, incluindo aplicativos SaaS não Microsoft.

Se você não habilitar esses perfis:
- Você não pode impor políticas de segurança, filtragem de conteúdo da Web, proteção contra ameaças ou Avaliação de Acesso Contínuo Universal.
- Agentes de ameaças que comprometem as credenciais do usuário podem acessar recursos corporativos sem os controles de segurança que o Global Secure Access aplicaria de outra forma.

**Ação de remediação**
- Habilite o perfil de encaminhamento de tráfego da Microsoft. Para mais informações, consulte [Gerenciar o perfil de tráfego da Microsoft](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-microsoft-profile?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Habilite o perfil de encaminhamento de tráfego de Acesso Privado. Para mais informações, consulte [Gerenciar o perfil de encaminhamento de tráfego de Acesso Privado](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-private-access-profile?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Habilite o perfil de encaminhamento de tráfego de Acesso à Internet. Para mais informações, consulte [Gerenciar o perfil de encaminhamento de tráfego de Acesso à Internet](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-internet-access-profile?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%
