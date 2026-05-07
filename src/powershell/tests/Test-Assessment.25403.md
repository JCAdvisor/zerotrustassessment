Se você não implantar sensores do Microsoft Entra Private Access em controladores de domínio, agentes de ameaça podem explorar solicitações de autenticação Kerberos de qualquer dispositivo na rede, incluindo endpoints não gerenciados ou comprometidos. Eles podem usar essa vulnerabilidade para obter tickets de serviço para recursos locais sem autenticação multifator ou validação de conformidade do dispositivo.

Se você não implantar sensores do Private Access em controladores de domínio:

- Agentes de ameaça podem solicitar tickets Kerberos para recursos privilegiados, como compartilhamentos de arquivos, servidores de banco de dados e serviços de área de trabalho remota. Essa vulnerabilidade possibilita movimento lateral pelo ambiente local.
- Políticas de Conditional Access não se aplicam à autenticação Kerberos, pois ela opera dentro de um modelo de confiança baseado em perímetro, onde qualquer usuário autenticado pode solicitar tickets independentemente da força de autenticação ou postura do dispositivo.
- Credenciais de usuário comprometidas obtidas por phishing ou roubo de credenciais podem ser imediatamente usadas para acessar recursos autenticados no domínio sem acionar requisitos de autenticação multifator.

**Ação de remediação**

- [Configure o Microsoft Entra Private Access para controladores de domínio do Active Directory](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-domain-controllers?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%







