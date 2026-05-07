Os logs de implantação do Global Secure Access rastreiam o status e o progresso das mudanças de configuração em toda a rede global. Essas mudanças incluem redistribuições de perfil de encaminhamento, atualizações de rede remota, mudanças de perfil de filtragem e mudanças nas configurações do Conditional Access. Se os logs de implantação mostram implantações falhadas, atores de ameaça podem explorar configurações de segurança inconsistentes em que alguns locais de borda tên políticas desatualizadas ou mal configuradas.

Se você não monitorar os logs de implantação:

- As implantações falhadas podem deixar lacunas de segurança, como perfis de encaminhamento desatualizados que não roteia m o tráfego através de inspeção de segurança, ou perfis de filtragem que não bloqueiam destinos maliciosos.
- Os administradores podem não estar cientes de configurações desatualizadas, acreditando que as mudanças são aplicadas uniformemente.
- As falhas de implantação que criam lacunas exploitáveis podem passar despercebidas.

**Ação de remediação**

- Siga as etapas em [Como usar os logs de implantação do Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/how-to-view-deployment-logs?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para:
    - Acessar e revisar logs de implantação no centro de administração do Microsoft Entra para identificar implantações falhadas.
    - Para implantações falhadas, examine a mensagem de erro no campo `status.message` e repita a mudança de configuração que acionou a falha.
    - Monitore notificações de implantação que aparecem no centro de administração ao fazer mudanças de configuração para capturar falhas em tempo real.
- Se as implantações continuarem falhando para redes remotas, [revise a configuração de rede remota subjacente](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-remote-networks?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para erros.
- Para falhas de implantação do perfil de encaminhamento, [verifique a configuração de encaminhamento de tráfego](https://learn.microsoft.com/entra/global-secure-access/concept-traffic-forwarding?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%
