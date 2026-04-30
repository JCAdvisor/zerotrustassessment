Sem políticas de criptografia FileVault devidamente configuradas e atribuídas no Intune, os agentes de ameaças podem explorar o acesso físico a dispositivos macOS não gerenciados ou mal configurados para extrair dados corporativos sensíveis. Dispositivos não criptografados permitem que invasores ignorem a segurança no nível do sistema operacional, inicializando a partir de mídia externa ou removendo a unidade de armazenamento. Esses ataques podem expor credenciais, certificados e tokens de autenticação em cache, permitindo a escalada de privilégios e a movimentação lateral. Além disso, dispositivos não criptografados prejudicam a conformidade com as regulamentações de proteção de dados e aumentam o risco de danos à reputação e penalidades financeiras em caso de violação.

A aplicação dA criptografia do FileVault protege os dados em repouso em dispositivos macOS, mesmo se perdidos ou roubados. Isso interrompe a colheita de credenciais e a movimentação lateral, apoia a conformidade regulatória e alinha-se aos princípios de Zero Trust de confiança do dispositivo.

**Ação de correção**

Use o Intune para aplicar A criptografia do FileVault e monitorar a conformidade em todos os dispositivos macOS gerenciados:
- [Criar uma política de criptografia de disco FileVault para macOS no Intune](https://learn.microsoft.com/intune/intune-service/protect/encrypt-devices-filevault?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-endpoint-security-policy-for-filevault)
- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)
- [Monitorar a criptografia do dispositivo com o Intune](https://learn.microsoft.com/intune/intune-service/protect/encryption-monitor?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
