A inspeção de bypass de Transport Layer Security (TLS) cria exceções em que o tráfego criptografado ignora a inspeção profunda de pacotes. Sem revisão periódica, regras temporárias se tornam permanentes, aplicações são desativadas e regras obsoletas permanecem ativas. Agentes mal-intencionados exploram esses canais sem inspeção para ocultar comando e controle, exfiltração de dados e roubo de credenciais via HTTPS.

**Ação de remediação**

- Estabeleça um processo trimestral de revisão das regras de bypass de inspeção TLS, documente a justificativa de negócio de cada regra e remova as que não forem mais necessárias.
- [Revise e gerencie políticas de inspeção TLS](https://learn.microsoft.com/graph/api/resources/networkaccess-tlsinspectionpolicy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) no centro de administração Microsoft Entra em **Global Secure Access** > **Secure** > **TLS inspection**.
- Revise as etapas em [Configurar políticas de inspeção de Transport Layer Security](https://learn.microsoft.com/entra/global-secure-access/how-to-transport-layer-security?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para entender como modificar ou remover regras de bypass como parte do processo de revisão.
<!--- Results --->
%TestResult%
