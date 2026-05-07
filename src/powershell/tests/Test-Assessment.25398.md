Quando os administradores usam o Microsoft Entra Private Access para alcançar controladores de domínio via Remote Desktop Protocol (RDP), eles autenticam-se através do Microsoft Entra ID antes que o cliente Global Secure Access túnelize a conexão para a rede local. Os controladores de domínio detêm as chaves criptográficas de toda a floresta Active Directory. Comprometer um controlador de domínio oferece uma maneira de comprometer todas as identidades e recursos na organização.

Sem autenticação resistente a phishing:

- Agentes de ameaça podem interceptar credenciais durante campanhas de phishing ou ataques de adversário no meio.
- Tokens de sessão roubados podem ser reproduzidos para estabelecer conexões RDP com controladores de domínio.
- Uma vez conectados, agentes de ameaça podem executar ataques DCSync para coletar todos os hashes de senha do domínio.
- Ataques podem criar golden tickets para persistência indefinida no domínio.
- Objetos de Política de Grupo podem ser modificados para implantar ransomware ou backdoors em todas as máquinas ingressadas no domínio.

Ao exigir autenticação resistente a phishing, as organizações garantem que, mesmo que os usuários sejam vítimas de phishing, os agentes de ameaça não possam reproduzir credenciais porque esses métodos exigem comprovação criptográfica de posse.

**Ação de remediação**

- [Implemente métodos de autenticação resistente a phishing para administradores de controladores de domínio](https://learn.microsoft.com/entra/identity/authentication/how-to-deploy-phishing-resistant-passwordless-authentication?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- [Exija autenticação resistente a phishing para administradores que acessam controladores de domínio via RDP](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-domain-controllers?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%
