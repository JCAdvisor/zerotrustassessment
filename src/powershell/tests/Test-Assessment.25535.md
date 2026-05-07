O Azure Firewall fornece inspeção centralizada, registro em log e imposição para tráfego de rede de saída. Quando você não roteia o tráfego de saída de cargas de trabalho integradas de rede virtual (VNet) através do Azure Firewall, o tráfego pode sair do seu ambiente sem inspeção ou imposição de política. As cargas de trabalho integradas de VNet incluem máquinas virtuais, pools de nós do AKS, App Service com integração de VNet e Azure Functions em VNet.

Sem rotear tráfego de saída através do Azure Firewall:

- Atores de ameaça podem usar caminhos de saída não inspecionados para exfiltração de dados e comunicação de comando e controle.
- As organizações perdem imposição consistente de controles de segurança de saída, como filtragem de inteligência de ameaças, detecção e prevenção de intrusões e inspeção TLS.
- As equipes de segurança carecem de visibilidade nos padrões de tráfego de saída, o que dificulta a detecção e investigação de atividades de rede suspeitas.

**Ação de remediação**

- [Configure o roteamento do Azure Firewall](https://learn.microsoft.com/azure/firewall/tutorial-firewall-deploy-portal?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#configure-routing) para direcionar o tráfego de saída de sub-redes de carga de trabalho através do endereço IP privado do firewall.
- [Gerenciar tabelas de rota e rotas](https://learn.microsoft.com/azure/virtual-network/manage-route-table?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para criar rotas definidas pelo usuário para a rota padrão (0.0.0.0/0) apontando para o IP privado do Azure Firewall.
- [Controlar o tráfego de saída do App Service com o Azure Firewall](https://learn.microsoft.com/azure/app-service/network-secure-outbound-traffic-azure-firewall?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para cenários de integração de VNet do App Service.
- [Configure as regras do Azure Firewall](https://learn.microsoft.com/azure/firewall/rule-processing?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para permitir o tráfego de saída necessário e bloquear destinos maliciosos.
<!--- Results --->
%TestResult%
