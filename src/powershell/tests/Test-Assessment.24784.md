Se as políticas do Microsoft Defender Antivirus não estiverem devidamente configuradas e atribuídas a dispositivos macOS no Intune, atacantes podem explorar endpoints desprotegidos para executar malware, desabilitar proteções de antivírus e persistir no ambiente. Sem políticas aplicadas, os dispositivos executam definições desatualizadas, não têm proteção em tempo real ou têm agendas de verificação mal configuradas, aumentando o risco de ameaças não detectadas e escalada de privilégios. Isso permite movimento lateral na rede, roubo de credenciais e exfiltração de dados. A ausência de aplicação do antivírus compromete a conformidade dos dispositivos, aumenta a exposição a ameaças de dia zero e pode resultar em não conformidade regulatória. Atacantes usam essas lacunas para manter persistência e evitar detecção, especialmente em ambientes sem aplicação centralizada de políticas.

A aplicação de políticas do Defender Antivirus garante que os dispositivos macOS sejam consistentemente protegidos contra malware, suporta a detecção de ameaças em tempo real e alinha-se ao Zero Trust ao manter uma postura de endpoint segura e em conformidade.

**Ação de remediação**

Use o Intune para configurar e atribuir políticas do Microsoft Defender Antivirus para dispositivos macOS a fim de aplicar proteção em tempo real, manter definições atualizadas e reduzir a exposição a malware:  
- [Configurar políticas do Intune para gerenciar o Microsoft Defender Antivirus](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-antivirus-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#macos)
- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)
<!--- Results --->
%TestResult%
