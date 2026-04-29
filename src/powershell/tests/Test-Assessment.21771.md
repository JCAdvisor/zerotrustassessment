Atacantes podem explorar aplicativos válidos, mas inativos, que ainda possuem privilégios elevados. Esses aplicativos podem ser usados para obter acesso inicial sem levantar alarmes, pois são aplicativos legítimos. A partir daí, os invasores podem usar os privilégios do aplicativo para planejar ou executar outros ataques. Os atacantes também podem manter o acesso manipulando o aplicativo inativo, como por exemplo, adicionando credenciais. Essa persistência garante que, mesmo que seu método de acesso primário seja detectado, eles possam recuperar o acesso mais tarde.

**Ação de remediação**

- [Desativar entidades de serviço inativas e privilegiadas](https://learn.microsoft.com/graph/api/serviceprincipal-update?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- Investigar se o aplicativo possui casos de uso legítimos. Se sim, [analise se uma permissão OAuth2 é mais adequada](https://learn.microsoft.com/entra/identity-platform/v2-app-types?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Se a entidade de serviço não tiver casos de uso legítimos, exclua-a](https://learn.microsoft.com/graph/api/serviceprincipal-delete?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)

<!--- Results --->
%TestResult%
