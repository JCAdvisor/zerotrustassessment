Sem controles de rede compatível nas políticas de Conditional Access, as organizações não conseguem impor que os usuários se conectem a recursos corporativos através do serviço Global Secure Access. Essa limitação deixa o tráfego de autenticação vulnerável a interceptação e ataques de repetição de qualquer localização de rede.

Um agente de ameaça que obtém credenciais válidas de usuário por phishing ou roubo de credenciais pode autenticar de qualquer localização na internet, contornando os controles de rede do Global Secure Access. Uma vez autenticado, o agente de ameaça pode acessar aplicações e serviços integrados ao Microsoft Entra ID, exfiltrar dados ou estabelecer persistência criando credenciais adicionais ou modificando permissões de usuário.

A verificação de rede compatível reduz esse risco exigindo que o tráfego de autenticação se origine no serviço Global Secure Access, que marca solicitações de autenticação com sinais de identidade de rede específicos do locatário. Esse requisito permite que o Microsoft Entra ID Conditional Access verifique se os usuários se conectam pelo caminho de rede protegido da organização antes de conceder acesso.

**Ação de remediação**
- Habilite a sinalização do Global Secure Access para Conditional Access. Para mais informações, veja [Habilitar verificação de rede compatível com Conditional Access](https://learn.microsoft.com/entra/global-secure-access/how-to-compliant-network?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enable-global-secure-access-signaling-for-conditional-access).
- Crie uma política de Conditional Access que exija rede compatível para acesso. Para mais informações, veja [Proteja seus recursos por trás da rede compatível](https://learn.microsoft.com/entra/global-secure-access/how-to-compliant-network?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#protect-your-resources-behind-the-compliant-network).
- Implemente clientes Global Secure Access nos dispositivos. Para mais informações, veja [Visão geral de clientes do Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/concept-clients?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Entenda a aplicação da verificação de rede compatível. Para mais informações, veja [Aplicação da verificação de rede compatível](https://learn.microsoft.com/entra/global-secure-access/how-to-compliant-network?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#compliant-network-check-enforcement).
<!--- Results --->
%TestResult%
