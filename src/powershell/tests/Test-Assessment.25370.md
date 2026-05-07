<!-- This file is a duplicate of 25380.md. Docs files reference 25380.md.-->
Quando organizações implantam o Global Secure Access como seu proxy de rede em nuvem, a infraestrutura do Secure Service Edge da Microsoft roteia o tráfego do usuário. Se você não habilitar a restauração de IP de origem, todas as solicitações de autenticação virão do endereço IP do proxy em vez do IP público real de saída do usuário.

Sem essa proteção:

- Atores de ameaça que comprometem credenciais de usuário podem autenticar de qualquer local enquanto contornam controles de Conditional Access baseados em IP e políticas de local nomeado.
- As detecções de risco do Microsoft Entra ID Protection perdem visibilidade do IP de origem original do usuário, o que degrada a precisão dos algoritmos de pontuação de risco.
- Os logs de entrada e trilhas de auditoria deixam de mostrar a fonte verdadeira das tentativas de autenticação, dificultando a investigação de incidentes e a análise forense.

**Ação de remediação**

- Habilite a sinalização do Global Secure Access no Conditional Access. Para mais informações, veja [Restauração de IP de origem](https://learn.microsoft.com/entra/global-secure-access/how-to-source-ip-restoration?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%
