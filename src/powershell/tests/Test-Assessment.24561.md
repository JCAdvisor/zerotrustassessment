Sem a aplicação de políticas de LAPS para macOS durante o Registro Automatizado de Dispositivos (ADE), os agentes de ameaças podem explorar senhas de administrador local estáticas ou reutilizadas para escalar privilégios, mover-se lateralmente e estabelecer persistência. Dispositivos provisionados sem credenciais aleatórias são vulneráveis à colheita de credenciais e reutilização em múltiplos endpoints, aumentando o risco de comprometimento de todo o domínio.

A aplicação do LAPS para macOS garante que cada dispositivo seja provisionado com uma senha de administrador local única e criptografada, gerenciada pelo Intune. Isso interrompe a cadeia de ataque nas fases de acesso a credenciais e movimento lateral, reduzindo significativamente o risco de comprometimento generalizado e alinhando-se aos princípios de Zero Trust de privilégio mínimo e higiene de credenciais.

**Ação de correção**

Use o Intune para configurar perfis de ADE para macOS que provisionem uma conta de administrador local com uma senha aleatória e criptografada, e que permitam a rotação segura:
- [Configurar LAPS para macOS no Microsoft Intune](https://learn.microsoft.com/intune/intune-service/enrollment/macos-laps?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Rotacionar senha de administrador local (macOS)](https://learn.microsoft.com/intune/intune-service/remote-actions/device-rotate-local-admin-password?pivots=macos&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)

Para mais informações, consulte:
- [Guia de configuração de ADE para macOS](https://learn.microsoft.com/intune/intune-service/enrollment/device-enrollment-program-enroll-macos?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%