Quando as organizações configuram o Microsoft Entra Private Access com segmentos de aplicativo amplos, como grandes intervalos de IP, vários protocolos ou configurações de Quick Access, elas efetivamente replicam o modelo de acesso excessivamente permissivo de VPNs tradicionais. Essa abordagem contraria o princípio Zero Trust do menor privilégio, em que os usuários devem alcançar apenas os recursos específicos necessários para sua função.

Riscos da segmentação ampla:

- Agentes de ameaça que comprometem as credenciais ou o dispositivo de um usuário podem usar permissões de rede amplas para realizar reconhecimento, identificando outros sistemas e serviços dentro do intervalo permitido.
- O movimento lateral torna-se mais fácil, pois os atacantes podem acessar vários sistemas com uma única credencial comprometida.
- A resposta a incidentes fica mais complicada porque as equipes de segurança não conseguem determinar rapidamente quais recursos específicos uma identidade comprometida poderia acessar.

Configurar segmentação por aplicativo com hosts de destino estreitamente definidos, portas específicas e Custom Security Attributes permite aplicação dinâmica de Conditional Access. Essa abordagem exige autenticação mais forte ou conformidade de dispositivo para aplicativos de alto risco, enquanto simplifica o acesso a recursos de menor risco.

**Ação de remediação**

- [Revise e refine os segmentos de aplicativo](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-per-app-access?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para usar FQDNs específicos, endereços IP e intervalos de portas específicos que correspondam aos requisitos do aplicativo, em vez de intervalos de portas amplos.
<!--- Results --->
%TestResult%
