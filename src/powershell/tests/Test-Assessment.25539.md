O Azure Firewall Premium fornece detecção e prevenção de intrusões (IDPS) baseada em assinatura que identifica ataques detectando padrões específicos no tráfego de rede, como sequências de bytes e sequências de instruções maliciosas conhecidas usadas por malware. O IDPS aplica-se ao tráfego de entrada, leste-oeste (falou-para-falou) e de saída nas Camadas 3-7. Quando o IDPS não está configurado no modo `Alerta e negar`, o Azure Firewall apenas registra ameaças detectadas sem bloqueá-las.

Sem IDPS ativado no modo `Alerta e negar`:

- Atores de ameaça podem enviar tráfego que corresponde a assinaturas de ataque conhecidas sem serem bloqueados.
- As organizações que executam o IDPS no modo `Apenas alerta` ganham visibilidade nas ameaças, mas não conseguem impedir tentativas de intrusão de alcançar suas cargas de trabalho.
- O tráfego de movimento lateral e exfiltração que corresponde a assinaturas de ataque conhecidas passa pelo firewall sem intervenção ativa.

**Ação de remediação**

- [Ative o IDPS no modo Alerta e Negar no Azure Firewall Premium](https://learn.microsoft.com/azure/firewall/premium-features?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) configurando o modo de detecção de intrusão como `Alerta e negar` na política de firewall.
<!--- Results --->
%TestResult%
