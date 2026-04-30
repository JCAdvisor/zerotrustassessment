Se as políticas do Microsoft Defender Antivírus não forem configuradas e atribuídas corretamente aos dispositivos macOS no Intune, invasores podem explorar endpoints desprotegidos para executar malware, desativar proteções de antivírus e persistir no ambiente. Sem políticas impostas, os dispositivos executam definições desatualizadas, carecem de proteção em tempo real ou possuem cronogramas de verificação mal configurados, aumentando o risco de ameaças não detectadas e escalada de privilégios. Isso permite a movimentação lateral na rede, colheita de credenciais e exfiltração de dados. A ausência de imposição de antivírus compromete a conformidade do dispositivo, aumenta a exposição a ameaças de dia zero e pode resultar em descumprimento regulatório. Invasores usam essas lacunas para manter persistência e evitar detecção, especialmente em ambientes sem imposição centralizada.

A imposição de políticas do Defender Antivírus garante que os dispositivos macOS estejam consistentemente protegidos contra malware, oferece suporte à detecção de ameaças em tempo real e se alinha ao Zero Trust mantendo uma postura de endpoint segura.

**Ação de remediação**

Use o Intune para configurar e atribuir políticas do Microsoft Defender Antivírus para dispositivos macOS para impor a proteção em tempo real e manter definições atualizadas:  
- [Configurar políticas do Intune para gerenciar o Microsoft Defender Antivírus](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-antivirus-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#macos)
- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)
<!--- Results --->
%TestResult%
