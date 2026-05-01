Permitir colaboração externa irrestrita com organizações não verificadas pode aumentar a superfície de risco do tenant, pois permite contas de convidados (guests) que podem não ter controles de segurança adequados. Criminosos podem tentar obter acesso comprometendo identidades nesses tenants externos mal governados. Uma vez concedido o acesso de convidado, eles podem usar caminhos legítimos de colaboração para infiltrar recursos em seu tenant e tentar obter informações sensíveis.

Sem analisar a segurança das organizações com as quais você colabora, contas externas maliciosas podem persistir sem detecção e injetar cargas maliciosas. As configurações de acesso entre tenants (cross-tenant) para acesso de saída no Microsoft Entra oferecem a capacidade de bloquear a colaboração com organizações desconhecidas por padrão, reduzindo a superfície de ataque.

**Ação de remediação**

- [Visão geral do acesso entre tenants](https://learn.microsoft.com/entra/external-id/cross-tenant-access-overview?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Configurar definições de acesso entre tenants](https://learn.microsoft.com/entra/external-id/cross-tenant-access-settings-b2b-collaboration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#configure-default-settings)
- [Modificar configurações de acesso de saída](https://learn.microsoft.com/entra/external-id/cross-tenant-access-settings-b2b-collaboration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
