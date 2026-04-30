Quando os conectores de rede privada do Microsoft Entra estão inativos ou não saudáveis, as organizações podem recorrer ao uso de métodos de acesso menos seguros. Essa condição cria oportunidades onde agentes de ameaças podem atingir serviços expostos externamente ou usar credenciais comprometidas.

Sem conectores funcionais:

- A autenticação e autorização baseadas em token para todos os cenários de Acesso Privado do Microsoft Entra são eliminadas.
- Invasores podem ignorar os limites de segurança pretendidos para acessar recursos além do seu escopo de autorização.
- O serviço não pode rotear solicitações adequadamente, interrompendo diretamente os controles de acesso à rede.

**Ação de remediação**

- [Configure conectores para alta disponibilidade](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-connectors?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Monitore a integridade do conector no centro de administração do Microsoft Entra em Global Secure Access > Conectar > Conectores.
- [Solucione problemas de instalação e conectividade do conector](https://learn.microsoft.com/entra/global-secure-access/troubleshoot-connectors?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Resultados --->
%TestResult%