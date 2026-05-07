Sem pré-autenticação do Microsoft Entra configurada nos aplicativos do Application Proxy, agentes de ameaça podem atingir diretamente a URL interna de aplicativos locais publicados sem primeiro comprovar sua identidade. Quando você usa autenticação passthrough, o Application Proxy encaminha o tráfego sem validar o solicitante, e toda a responsabilidade de autenticação recai sobre o aplicativo interno.

Se você não configurar pré-autenticação nos aplicativos do Application Proxy:

- Agentes de ameaça podem acessar endpoints de aplicativos internos sem verificação de identidade, permitindo reconhecimento e exploração de vulnerabilidades de backend.
- Políticas de Conditional Access não podem ser aplicadas, então você não pode exigir autenticação multifator, avaliar risco de login ou aplicar restrições baseadas em localização.
- Você não pode integrar com o Microsoft Defender for Cloud Apps para monitoramento e controle de sessão em tempo real.

**Ação de remediação**

- [Configure a pré-autenticação do Microsoft Entra para aplicativos do Application Proxy](https://learn.microsoft.com/entra/identity/app-proxy/application-proxy-add-on-premises-application?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#add-an-on-premises-app-to-microsoft-entra-id) alterando o método de Pré-autenticação de **Passthrough** para **Microsoft Entra ID**.
- [Use a API Microsoft Graph para atualizar programaticamente as configurações do Application Proxy](https://learn.microsoft.com/graph/application-proxy-configure-api?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%
