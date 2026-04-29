A Microsoft encerrou o suporte e as correções de segurança para o ADAL em 30 de junho de 2023. O uso continuado do ADAL ignora as proteções de segurança modernas disponíveis apenas no MSAL, incluindo a imposição de Acesso Condicional, Avaliação de Acesso Contínuo (CAE) e proteção avançada de tokens. Os aplicativos ADAL criam vulnerabilidades de segurança ao usar padrões de autenticação legados mais fracos, muitas vezes chamando endpoints obsoletos do Azure AD Graph, e impedindo a adoção de fluxos de autenticação endurecidos que poderiam mitigar futuros avisos de segurança.

**Ação de remediação**

- [Migrar aplicativos para a Biblioteca de Autenticação da Microsoft (MSAL)](https://learn.microsoft.com/entra/identity-platform/msal-migration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
