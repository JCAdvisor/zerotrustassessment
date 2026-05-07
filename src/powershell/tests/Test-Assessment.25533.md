Os ataques de DDoS continuam sendo um risco importante de segurança e disponibilidade para clientes com aplicações hospedadas em nuvem. Esses ataques visam sobrecarregar recursos de computação, rede ou memória de um aplicativo, tornando-o inacessível aos usuários legítimos. Qualquer endpoint voltado ao público exposto à internet pode ser um alvo em potencial para um ataque de DDoS. A Proteção contra DDoS do Azure fornece monitoramento sempre ativo e mitigação automática contra ataques de DDoS direcionados a cargas de trabalho voltadas ao público.

Sem a Proteção contra DDoS do Azure (Network Protection ou IP Protection), endereços IP públicos para serviços como Application Gateways, Load Balancers, Azure Firewalls, Azure Bastion, Virtual Network Gateways ou máquinas virtuais permanecem expostos a ataques de DDoS que podem sobrecarregar a largura de banda da rede, esgotar recursos do sistema e causar indisponibilidade completa de serviço. Esses ataques podem interromper o acesso de usuários legítimos, degradar o desempenho e criar interrupções em cascata em serviços dependentes.

A Proteção contra DDoS do Azure pode ser ativada de duas maneiras:

- DDoS IP Protection — A proteção é explicitamente ativada em endereços IP públicos individuais definindo ddosSettings.protectionMode como Habilitado.
- DDoS Network Protection — A proteção é ativada no nível de VNET através de um Plano de Proteção contra DDoS. Os endereços IP públicos associados a recursos nesse VNET herdam a proteção quando ddosSettings.protectionMode é definido como VirtualNetworkInherited. No entanto, um endereço IP público com VirtualNetworkInherited não é protegido a menos que o VNET realmente tenha um Plano de Proteção contra DDoS associado e enableDdosProtection definido como verdadeiro.
Essa verificação verifica se cada endereço IP público está realmente coberto pela proteção DDoS, seja através da Proteção de DDoS IP ativada diretamente no IP público ou através da Proteção de Rede DDoS ativada no VNET em que reside o recurso associado do IP público. Se essa verificação não passar, suas cargas de trabalho permanecerão significativamente mais vulneráveis ao tempo de inatividade, impacto do cliente e disrupção operacional durante um ataque.

**Ação de remediação**

Para ativar a Proteção contra DDoS para endereços IP públicos, consulte a seguinte documentação do Microsoft Learn:

- [Visão geral da Proteção contra DDoS do Azure](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview)
- [Início rápido: Criar e configurar a Proteção de Rede DDoS do Azure usando o portal do Azure](https://learn.microsoft.com/en-us/azure/ddos-protection/manage-ddos-protection)
- [Início rápido: Criar e configurar a Proteção de IP DDoS do Azure usando o portal do Azure](https://learn.microsoft.com/en-us/azure/ddos-protection/manage-ddos-ip-protection-portal)
- [Comparação de SKU de Proteção contra DDoS do Azure](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-sku-comparison)

<!--- Results --->
%TestResult%
