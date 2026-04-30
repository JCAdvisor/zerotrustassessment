Sem uma política de firewall gerida de forma centralizada, os dispositivos macOS podem depender de definições predefinidas ou modificadas pelo utilizador, que muitas vezes não cumprem os padrões de segurança corporativos. Isto expõe os dispositivos a ligações de entrada não solicitadas, permitindo que agentes de ameaças explorem vulnerabilidades, estabeleçam tráfego de comando e controlo (C2) de saída para exfiltração de dados e se movam lateralmente dentro da rede — aumentando significativamente o alcance e o impacto de uma violação.

A aplicação de políticas de Firewall no macOS garante um controlo consistente sobre o tráfego de entrada e saída, reduzindo a exposição a acessos não autorizados e apoiando o Zero Trust através de proteção ao nível do dispositivo e segmentação de rede.

**Ação de correção**

Configure e atribua perfis de **Firewall do macOS** no Intune para bloquear tráfego não autorizado e aplicar proteções de rede consistentes em todos os dispositivos macOS geridos:

- [Configurar o firewall integrado em dispositivos macOS](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-firewall-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)

Para mais informações, consulte:
- [Definições de firewall do macOS disponíveis](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-firewall-profile-settings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#macos-firewall-profile)
<!--- Results --->
%TestResult%