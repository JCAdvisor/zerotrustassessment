Quando os conectores de rede privada do Microsoft Entra estiverem inativos ou não saudáveis, as organizações podem recorrer a métodos de acesso menos seguros. Essa condição cria oportunidades para agentes de ameaça direcionarem serviços expostos externamente ou usarem credenciais comprometidas.

Sem conectores funcionais:

- A autenticação e autorização baseadas em token para todos os cenários do Microsoft Entra Private Access ficam eliminadas.
- Agentes de ameaça podem contornar os limites de segurança pretendidos para acessar recursos além do escopo autorizado.
- O serviço não consegue rotear solicitações corretamente, interrompendo diretamente os controles de acesso à rede.

**Ação de remediação**

- [Configure conectores para alta disponibilidade](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-connectors?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Monitore a integridade dos conectores no centro de administração do Microsoft Entra em Acesso Seguro Global > Conectar > Conectores.
- [Solucione problemas de instalação e conectividade dos conectores](https://learn.microsoft.com/entra/global-secure-access/troubleshoot-connectors?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%
