O uso do Microsoft Entra Connect Sync com contas de usuário em vez de Service Principals cria vulnerabilidades de segurança. A autenticação de conta de usuário legada com senhas é mais suscetível ao roubo de credenciais e ataques de senha do que a autenticação de Service Principal com certificados. Contas de conector comprometidas permitem que agentes de ameaças manipulem a sincronização de identidade, criem contas de backdoor, escalem privilégios ou interrompam a infraestrutura de identidade híbrida.

**Ação de correção**

- [Configurar autenticação de Service Principal para o Entra Connect](https://learn.microsoft.com/entra/identity/hybrid/connect/authenticate-application-id?tabs=default&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#onboard-to-application-based-authentication)
- [Remover as Contas de Sincronização de Diretório legadas](https://learn.microsoft.com/entra/identity/hybrid/connect/authenticate-application-id?tabs=default&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#remove-a-legacy-service-account)
<!--- Results --->
%TestResult%