O Global Secure Access mantém uma lista de bypass do sistema com destinos automaticamente excluídos da inspeção de Transport Layer Security (TLS). Esses destinos representam incompatibilidades conhecidas, como certificate pinning, requisitos de TLS mútuo ou outras restrições técnicas. Regras personalizadas que duplicam destinos da lista de bypass do sistema são redundantes e sem benefício funcional.

Regras redundantes consomem capacidade de política, geram sobrecarga administrativa e causam confusão sobre o que é realmente necessário. A inspeção TLS suporta até 1.000 regras e 8.000 destinos por locatário. Manter uma configuração limpa, com apenas regras de bypass necessárias, melhora a governança e facilita auditorias.

**Ação de remediação**

- Review and remove redundant custom TLS inspection bypass rules in the Microsoft Entra admin center. Navigate to **Global Secure Access** > **Secure** > **TLS inspection policies**.
- Review [the destinations included in the system bypass list](https://learn.microsoft.com/entra/global-secure-access/faq-transport-layer-security?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#what-destinations-are-included-in-the-system-bypass).
<!--- Results --->
%TestResult%
