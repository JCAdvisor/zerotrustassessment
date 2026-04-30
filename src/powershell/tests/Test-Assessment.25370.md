Quando as organizações implementam o Global Secure Access como seu proxy de rede baseado em nuvem, a infraestrutura do Secure Service Edge da Microsoft roteia o tráfego do usuário. Se você não habilitar a restauração do IP de origem, todas as solicitações de autenticação virão do endereço IP do proxy em vez do IP de egresso público real do usuário.

Sem essa proteção:

- Agentes de ameaças que comprometem as credenciais do usuário podem se autenticar de qualquer local, ignorando os controles de Acesso Condicional baseados em IP e as políticas de localidade nomeada.
- As detecções de risco do Microsoft Entra ID Protection perdem visibilidade do endereço IP original do usuário, o que degrada a precisão dos algoritmos de pontuação de risco.
- Os logs de entrada e as trilhas de auditoria não mostram mais a verdadeira origem das tentativas de autenticação, o que dificulta a investigação de incidentes e a análise forense.

**Ação de remediação**

- Habilite a sinalização do Global Secure Access no Acesso Condicional. Para mais informações, consulte [Restauração do IP de origem](https://learn.microsoft.com/entra/global-secure-access/how-to-source-ip-restoration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Resultados --->
%TestResult%