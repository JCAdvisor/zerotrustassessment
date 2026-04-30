Se as políticas do Windows Update não forem aplicadas em todos os dispositivos Windows corporativos, os agentes de ameaças podem explorar vulnerabilidades não corrigidas para obter acesso não autorizado, escalar privilégios e mover-se lateralmente dentro do ambiente. A cadeia de ataque começa frequentemente com o comprometimento do dispositivo através de phishing, malware ou exploração de vulnerabilidades conhecidas, seguida de tentativas de contornar os controlos de segurança. Sem políticas de atualização aplicadas, os atacantes aproveitam o software desatualizado para persistir no ambiente, aumentando o risco de escalonamento de privilégios e comprometimento de todo o domínio.

A aplicação de políticas do Windows Update garante a correção atempada de falhas de segurança, interrompendo a persistência do atacante e reduzindo o risco de comprometimento generalizado.

**Ação de correção**

Comece por consultar [Gerir atualizações de software do Windows no Intune](https://learn.microsoft.com/intune/device-updates/windows/configure?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para compreender os tipos de política do Windows Update disponíveis e como configurá-los.

O Intune inclui os seguintes tipos de política de atualização do Windows:
- [Política de atualizações de qualidade do Windows](https://learn.microsoft.com/intune/device-updates/windows/quality-updates?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) - *para instalar as atualizações mensais regulares do Windows.*
- [Política de atualizações aceleradas](https://learn.microsoft.com/intune/device-updates/windows/expedite-updates?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) - *para instalar rapidamente patches de segurança críticos.*
- [Política de atualizações de funcionalidades](https://learn.microsoft.com/intune/device-updates/windows/feature-updates?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Política de anéis de atualização](https://learn.microsoft.com/intune/device-updates/windows/update-rings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) - *para gerir como e quando os dispositivos instalam atualizações de funcionalidades e de qualidade.*
- [Atualizações de controladores do Windows](https://learn.microsoft.com/intune/device-updates/windows/driver-updates?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%