Quando você conecta redes remotas ao Global Secure Access através de túneis IPsec, mas não configura políticas de firewall de nuvem, todo o tráfego vinculado à internet dos escritórios remotos passa pela Security Service Edge sem controles de filtragem de saída. Se um ator de ameaça ganhar acesso a uma estação de trabalho do escritório remoto, ele pode fazer conexões de saída para infraestrutura de comando e controle, exfiltrar dados em portas padrão ou fazer download de cargas maliciosas sem inspeção em nível de rede.

Sem firewall de nuvem do Global Secure Access:

- Você não pode impor uma postura de negação por padrão ou restringir comunicações de saída de redes de escritório remoto para destinos da internet não autorizados.
- Atores de ameaça podem preparar dados para exfiltração, mudar para recursos de nuvem ou se mover lateralmente sem detecção.
- As defesas tradicionais do perímetro podem assumir que toda saída é legítima, resultando em lacunas na cobertura de segurança.

As políticas de firewall de nuvem vinculadas ao perfil base fornecem controle centralizado de saída para todo o tráfego de rede remota. Os administradores podem usar essas políticas para definir regras de filtragem granulares que restringem comunicações de saída não autorizadas.

**Ação de remediação**

- Como um pré-requisito para firewall de nuvem, [configure redes remotas para acesso à internet](https://learn.microsoft.com/entra/global-secure-access/how-to-create-remote-networks?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Siga as etapas em [Configurar firewall de nuvem do Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-cloud-firewall?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para:
    - Criar uma política de firewall de nuvem com regras de filtragem apropriadas.
    - Adicionar ou atualizar regras de firewall com base em IP de origem, IP de destino, portas e protocolos.
    - Vincular a política de firewall de nuvem ao perfil base para redes remotas.
<!--- Results --->
%TestResult%
