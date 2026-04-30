Sem a aplicação de políticas da Solução de Password de Administrador Local (LAPS), os agentes de ameaças que obtenham acesso a endpoints podem explorar passwords de administrador local estáticas ou fracas para escalar privilégios, mover-se lateralmente e estabelecer persistência. A cadeia de ataque começa normalmente com o comprometimento do dispositivo — através de phishing, malware ou acesso físico — seguido de tentativas de recolher credenciais de administrador local. Sem o LAPS, os atacantes podem reutilizar credenciais comprometidas em vários dispositivos, aumentando o risco de escalonamento de privilégios e comprometimento de todo o domínio.

A aplicação do Windows LAPS em todos os dispositivos Windows corporativos garante passwords de administrador local únicas e rodadas regularmente. Isto interrompe a cadeia de ataque nas fases de acesso a credenciais e movimento lateral, reduzindo significativamente o risco de comprometimento generalizado.

**Ação de correção**

Utilize o Intune para impor políticas de Windows LAPS que rodem passwords de administrador local fortes e únicas, e que façam o backup das mesmas de forma segura:
- [Implementar a política de Windows LAPS com o Microsoft Intune](https://learn.microsoft.com/intune/intune-service/protect/windows-laps-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-a-laps-policy)

Para mais informações, consulte:
- [Referência de definições da política de Windows LAPS](https://learn.microsoft.com/windows-server/identity/laps/laps-management-policy-settings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Saiba mais sobre o suporte do Intune para o Windows LAPS](https://learn.microsoft.com/intune/intune-service/protect/windows-laps-overview?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%