Protocolos de autenticação legada, como autenticação básica para SMTP e IMAP, não suportam recursos modernos de segurança como a autenticação multifator (MFA), que é crucial para proteger contra acesso não autorizado. Essa falta de proteção torna as contas que usam esses protocolos vulneráveis a ataques baseados em senha e fornece aos atacantes um meio de obter acesso inicial usando credenciais roubadas ou adivinhadas.

Quando um invasor obtém acesso não autorizado a credenciais, ele pode usá-las para acessar serviços vinculados. Atacantes que ganham acesso via autenticação legada podem fazer alterações no Microsoft Exchange, como configurar regras de encaminhamento de e-mail, permitindo que mantenham acesso contínuo a comunicações sensíveis.

**Ação de remediação**
- [Protocolos do Exchange podem ser desativados no Exchange Online](https://learn.microsoft.com/exchange/clients-and-mobile-in-exchange-online/disable-basic-authentication-in-exchange-online?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Protocolos de autenticação legada podem ser bloqueados com Acesso Condicional](https://learn.microsoft.com/entra/identity/conditional-access/policy-block-legacy-authentication?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Workbook de logons usando autenticação legada para ajudar a determinar a segurança da desativação](https://learn.microsoft.com/entra/identity/monitoring-health/workbook-legacy-authentication?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
