Se as políticas para o Firewall do Windows não estiverem configuradas e atribuídas, os agentes de ameaças podem explorar endpoints desprotegidos para obter acesso não autorizado, mover-se lateralmente e escalar privilégios no ambiente. Sem regras de firewall aplicadas, os invasores podem burlar a segmentação de rede, exfiltrar dados ou implantar malware, aumentando o risco de comprometimento generalizado.

A aplicação de políticas do Firewall do Windows garante a aplicação consistente de controles de tráfego de entrada e saída, reduzindo a exposição ao acesso não autorizado e apoiando o Zero Trust por meio da segmentação de rede e proteção no nível do dispositivo.

**Ação de correção**

Configure e atribua políticas de firewall para Windows no Intune para bloquear tráfego não autorizado e aplicar proteções de rede consistentes em todos os dispositivos gerenciados:

- [Configurar políticas de firewall para dispositivos Windows](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-firewall-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci). O Intune usa dois perfis complementares para gerenciar as configurações de firewall:
  - **Firewall do Windows** - Use este perfil para configurar o comportamento geral do firewall com base no tipo de rede.
  - **Regras do Firewall do Windows** - Use este perfil para definir regras de tráfego para aplicativos, portas ou IPs, adaptadas a grupos ou cargas de trabalho específicos. Este perfil do Intune também oferece suporte ao uso de [grupos de configurações reutilizáveis](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-firewall-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#add-reusable-settings-groups-to-profiles-for-firewall-rules) para ajudar a simplificar o gerenciamento de configurações comuns que você usa para diferentes instâncias de perfil.
- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)

Para mais informações, consulte:
- [Configurações disponíveis do Firewall do Windows](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-firewall-profile-settings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#windows-firewall-profile)
<!--- Resultados --->
%TestResult%