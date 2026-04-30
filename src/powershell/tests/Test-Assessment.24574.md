Se os perfis do Intune para as regras de Redução da Superfície de Ataque (ASR) não estiverem devidamente configurados e atribuídos a dispositivos Windows, os agentes de ameaças podem explorar endpoints desprotegidos para executar scripts ofuscados e invocar chamadas da API Win32 a partir de macros do Office. Estas técnicas são comummente utilizadas em campanhas de phishing e entrega de malware, permitindo que os atacantes contornem as defesas tradicionais de antivírus e ganhem acesso inicial. Uma vez lá dentro, os atacantes escalam privilégios, estabelecem persistência e movem-se lateralmente pela rede.

A imposição das regras ASR ajuda a bloquear técnicas comuns de ataque, como a execução baseada em scripts e o abuso de macros, reduzindo o risco de comprometimento inicial e apoiando o Zero Trust através do reforço das defesas dos endpoints.

**Ação de correção**

Utilize o Intune para implementar perfis de **Regras de Redução da Superfície de Ataque** para dispositivos Windows para bloquear comportamentos de alto risco:
- [Configurar perfis do Intune para Regras de Redução da Superfície de Ataque](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-asr-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#devices-managed-by-intune)
- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)

Para mais informações, consulte:
- [Referência das regras de redução da superfície de ataque](https://learn.microsoft.com/defender-endpoint/attack-surface-reduction-rules-reference?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) na documentação do Microsoft Defender.
<!--- Results --->
%TestResult%