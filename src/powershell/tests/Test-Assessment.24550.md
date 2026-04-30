Sem uma política BitLocker devidamente configurada e atribuída no Intune, os agentes de ameaças podem explorar dispositivos Windows não criptografados para obter acesso não autorizado a dados corporativos confidenciais. Os dispositivos que carecem de criptografia forçada são vulneráveis a ataques físicos, como a remoção do disco ou o arranque a partir de suportes externos, permitindo que os atacantes contornem os controlos de segurança do sistema operativo. Estes ataques podem resultar em exfiltração de dados, roubo de credenciais e movimentação lateral adicional dentro do ambiente.

A imposição do BitLocker em dispositivos Windows geridos é fundamental para a conformidade com as regulamentações de proteção de dados e para reduzir o risco de violações de dados.

**Ação de correção**

Utilize o Intune para forçar a criptografia BitLocker e monitorizar a conformidade em todos os dispositivos Windows geridos:
- [Criar uma política BitLocker para dispositivos Windows no Intune](https://learn.microsoft.com/intune/intune-service/protect/encrypt-devices?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-and-deploy-policy)
- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)
- [Monitorizar a criptografia do dispositivo com o Intune](https://learn.microsoft.com/intune/intune-service/protect/encryption-monitor?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%