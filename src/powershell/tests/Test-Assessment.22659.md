Os agentes de ameaças visam cada vez mais as identidades de carga de trabalho (aplicativos, principais de serviço e identidades gerenciadas) porque elas carecem de fatores humanos e geralmente usam credenciais de longa duração. Um comprometimento geralmente segue o seguinte caminho:

1. Abuso de credenciais ou roubo de chaves.
2. Logons não interativos em recursos na nuvem.
3. Movimentação lateral via permissões de aplicativos.
4. Persistência por meio de novos segredos ou atribuições de funções.

O Microsoft Entra ID Protection gera continuamente detecções de identidades de carga de trabalho de risco e sinaliza eventos de logon com estado e detalhes de risco. Logons de identidades de carga de trabalho de risco que não são triados (confirmados como comprometidos, descartados ou marcados como seguros), a fadiga de detecção e um grande acúmulo de alertas podem ser desafiadores para os administradores de TI gerenciarem. Essa carga de trabalho pesada pode permitir que acessos maliciosos repetidos, escalonamento de privilégios e repetição de tokens continuem passando despercebidos. Para tornar a carga de trabalho gerenciável, trate os logons de identidades de carga de trabalho de risco em duas partes:

- Fechar o ciclo: Trie os logons e registre uma decisão definitiva sobre cada evento de risco.
- Promover a contenção: Desative o principal de serviço, rotacione as credenciais ou revogue as sessões.

**Ação de correção**

- [Investigar identidades de carga de trabalho de risco e realizar a remediação apropriada](https://learn.microsoft.com/entra/id-protection/concept-workload-identity-risk?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Descartar riscos de identidade de carga de trabalho quando determinados como falsos positivos](https://learn.microsoft.com/graph/api/riskyserviceprincipal-dismiss?view=graph-rest-1.0&preserve-view=true&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Confirmar identidades de carga de trabalho comprometidas quando os riscos são validados](https://learn.microsoft.com/graph/api/riskyserviceprincipal-confirmcompromised?view=graph-rest-1.0&preserve-view=true&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Resultados --->
%TestResult%