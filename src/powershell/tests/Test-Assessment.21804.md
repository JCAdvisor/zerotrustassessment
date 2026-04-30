Quando métodos de autenticação fracos, como SMS e chamadas de voz, permanecem habilitados no Microsoft Entra ID, os atacantes podem explorar essas vulnerabilidades por meio de múltiplos vetores de ataque. Inicialmente, os criminosos realizam reconhecimento para identificar organizações que utilizam esses métodos mais fracos por meio de engenharia social ou varredura técnica. Em seguida, podem executar o acesso inicial através de ataques de preenchimento de credenciais (credential stuffing), pulverização de senhas (password spraying) ou campanhas de phishing.

Uma vez que as credenciais básicas são comprometidas, os invasores exploram as fraquezas na autenticação baseada em SMS e voz. Mensagens SMS podem ser interceptadas por meio de ataques de troca de SIM (SIM swapping), vulnerabilidades na rede SS7 ou malware em dispositivos móveis, enquanto as chamadas de voz são suscetíveis a phishing por voz (vishing) e manipulação de encaminhamento de chamadas. Com esses segundos fatores ignorados, os atacantes estabelecem persistência registrando seus próprios métodos de autenticação. Contas comprometidas podem ser usadas para visar usuários com privilégios mais altos, permitindo o escalonamento de privilégios. Finalmente, os criminosos atingem seus objetivos através de exfiltração de dados ou movimento lateral, mantendo-se ocultos ao usar caminhos de autenticação legítimos.

**Ação de remediação**

- [Implantar campanhas de registro de métodos de autenticação para incentivar métodos mais fortes](https://learn.microsoft.com/graph/api/authenticationmethodspolicy-update?view=graph-rest-beta&preserve-view=true&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Desabilitar métodos de autenticação fracos](https://learn.microsoft.com/entra/identity/authentication/concept-authentication-methods-manage?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Desabilitar métodos baseados em telefone nas configurações legadas de MFA](https://learn.microsoft.com/entra/identity/authentication/howto-mfa-mfasettings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Implantar políticas de Acesso Condicional usando força de autenticação](https://learn.microsoft.com/entra/identity/authentication/concept-authentication-strength-how-it-works?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
