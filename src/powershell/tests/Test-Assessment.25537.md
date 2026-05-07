A filtragem baseada em inteligência de ameaça do Azure Firewall alerta e nega o tráfego de e para endereços IP maliciosos conhecidos, nomes de domínio totalmente qualificados (FQDNs) e URLs provenientes do feed de Inteligência de Ameaça da Microsoft. Quando você não ativa a inteligência de ameaça no modo `Alerta e negar`, o Azure Firewall não bloqueia ativamente o tráfego para destinos maliciosos conhecidos.

Se você não ativar a inteligência de ameaça no modo `Alerta e negar`:

- Atores de ameaça podem se comunicar com infraestrutura maliciosa conhecida, permitindo exfiltração de dados e comunicação de comando e controle sem bloqueio ativo.
- As organizações que usam o modo `Apenas alerta` podem ver atividade de ameaça em logs, mas não conseguem impedir conexões com destinos maliciosos conhecidos.
- Todos os níveis de política de firewall permanecem expostos a ameaças que o feed de Inteligência de Ameaça da Microsoft já identificou.

**Ação de remediação**

- [Configure as configurações de inteligência de ameaça no Gerenciador de Firewall do Azure](https://learn.microsoft.com/azure/firewall-manager/threat-intelligence-settings?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para definir o modo de inteligência de ameaça como `Alerta e negar` na política de firewall.
<!--- Results --->
%TestResult%
