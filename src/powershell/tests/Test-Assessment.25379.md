Sem os controles de rede em conformidade nas políticas de Acesso Condicional, as organizações não podem impor que os usuários se conectem aos recursos corporativos por meio do serviço Global Secure Access. Essa limitação deixa o tráfego de autenticação vulnerável a ataques de interceptação e repetição de locais de rede arbitrários.

Um agente de ameaças que obtém credenciais de usuário válidas por meio de phishing ou roubo de credenciais pode se autenticar de qualquer local da Internet, ignorando os controles de rede do Global Secure Access. Uma vez autenticado, o agente de ameaças pode acessar aplicativos e serviços integrados ao Microsoft Entra ID, exfiltrar dados ou estabelecer persistência criando credenciais adicionais ou modificando permissões de usuário.

A verificação de rede em conformidade reduz esse risco ao exigir que o tráfego de autenticação se origine do serviço Global Secure Access, que marca as solicitações de autenticação com sinais de identidade de rede específicos do locatário. Esse requisito permite que o Acesso Condicional do Microsoft Entra ID verifique se os usuários se conectam por meio do caminho de rede seguro da organização antes de conceder o acesso.

**Ação de remediação**
- Habilite a sinalização do Global Secure Access para o Acesso Condicional. Para mais informações, consulte [Habilitar verificação de rede em conformidade com o Acesso Condicional](https://learn.microsoft.com/entra/global-secure-access/how-to-compliant-network?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enable-global-secure-access-signaling-for-conditional-access).
- Crie uma política de Acesso Condicional que exija rede em conformidade para o acesso. Para mais informações, consulte [Proteja seus recursos atrás da rede em conformidade](https://learn.microsoft.com/entra/global-secure-access/how-to-compliant-network?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#protect-your-resources-behind-the-compliant-network).
<!--- Results --->
%TestResult%
