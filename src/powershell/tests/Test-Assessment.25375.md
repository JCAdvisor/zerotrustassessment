O Global Secure Access requer licenças específicas do Microsoft Entra, incluindo Microsoft Entra Internet Access e Microsoft Entra Private Access, ambos com Microsoft Entra ID P1 como pré-requisito. Sem licenças válidas provisionadas no locatário, os administradores não podem configurar perfis de encaminhamento de tráfego, políticas de segurança ou conexões de rede remota. Se você não atribuir licenças aos usuários, o tráfego deles não é roteado pelo Global Secure Access e permanece sem a proteção dos controles de segurança.

Sem essa proteção:

- Os agentes de ameaça podem contornar filtragem de conteúdo da web, proteção contra ameaças e políticas de Conditional Access.
- Assinaturas expiradas ou suspensas podem interromper o serviço Global Secure Access, criando lacunas de segurança em que tráfego anteriormente protegido não é monitorado.

**Ação de remediação**

- Reveja os requisitos de licenciamento do Global Secure Access e adquira as licenças apropriadas. Para mais informações, veja [Visão geral de licenciamento](https://learn.microsoft.com/entra/global-secure-access/overview-what-is-global-secure-access?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#licensing-overview).
- Atribua licenças aos usuários pelo centro de administração do Microsoft Entra. Para mais informações, veja [Atribuir licenças a usuários](https://learn.microsoft.com/entra/fundamentals/license-users-groups?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Use licenciamento baseado em grupo para facilitar o gerenciamento em escala. Para mais informações, veja [Licenciamento baseado em grupo](https://learn.microsoft.com/entra/fundamentals/concept-group-based-licensing?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Monitore a utilização de licenças pelo centro de administração do Microsoft 365. Para mais informações, veja [Microsoft 365 admin center](https://admin.microsoft.com/Adminportal/Home#/licenses).
- Avalie o Microsoft Entra Suite como alternativa que inclui Internet Access e Private Access. Para mais informações, veja [Novidades do Microsoft Entra](https://learn.microsoft.com/entra/fundamentals/whats-new?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#microsoft-entra-suite).
<!--- Results --->
%TestResult%
