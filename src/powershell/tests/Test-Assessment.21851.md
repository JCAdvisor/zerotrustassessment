Contas de usuários externos são frequentemente usadas para fornecer acesso a parceiros de negócios que pertencem a organizações que têm um relacionamento comercial com a sua organização. Se essas contas forem comprometidas em sua organização de origem, atacantes podem usar as credenciais válidas para obter acesso inicial ao seu ambiente, muitas vezes contornando as defesas tradicionais devido à sua aparente legitimidade.

Atacantes podem ganhar acesso com contas de usuários externos se a autenticação multifator (MFA) não for universalmente imposta ou se houver exceções em vigor. Eles também podem ganhar acesso explorando vulnerabilidades de métodos de MFA mais fracos, como SMS e chamadas telefônicas, usando técnicas de engenharia social, como SIM swapping ou phishing, para interceptar códigos de autenticação.

Uma vez que um atacante ganha acesso a uma conta sem MFA ou a uma sessão com métodos de MFA fracos, ele pode tentar manipular as configurações de MFA (por exemplo, registrando métodos controlados pelo atacante) para estabelecer persistência e planejar e executar ataques futuros com base nos privilégios das contas comprometidas.

**Ação de remediação**

- [Implantar uma política de Acesso Condicional para impor a força da autenticação para convidados](https://learn.microsoft.com/entra/identity/conditional-access/policy-guests-mfa-strength?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Para organizações com uma relação comercial mais próxima e verificação de suas práticas de MFA, considere implantar configurações de acesso entre locatários para aceitar a reivindicação de MFA.
   - [Configurar as definições de acesso entre locatários para colaboração B2B](https://learn.microsoft.com/entra/external-id/cross-tenant-access-settings-b2b-collaboration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#to-change-inbound-trust-settings-for-mfa-and-device-claims)
<!--- Results --->
%TestResult%
