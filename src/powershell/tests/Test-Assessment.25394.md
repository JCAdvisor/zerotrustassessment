Quando você configura o Quick Access no Microsoft Entra Private Access sem políticas de Conditional Access, agentes de ameaça que comprometem credenciais de usuário obtêm acesso irrestrito a recursos privados. O aplicativo Quick Access serve como um contêiner para recursos privados, incluindo FQDNs e endereços IP.

Sem aplicação de políticas:

- Contas comprometidas fornecem um caminho direto para sistemas internos.
- Agentes de ameaça operando a partir de dispositivos não gerenciados ou locais anômalos podem acessar recursos privados de forma indistinguível dos usuários autorizados.
- Movimento lateral pela rede interna e exfiltração de dados de aplicativos privados se tornam possíveis.
- Requisitos de autenticação multifator e verificações de integridade do dispositivo não podem ser aplicados.

**Ação de remediação**

- [Aplique políticas de Conditional Access aos aplicativos Microsoft Entra Private Access](https://learn.microsoft.com/entra/global-secure-access/how-to-target-resource-private-access-apps?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%
