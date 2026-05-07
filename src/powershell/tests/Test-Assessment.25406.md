Quando o perfil de encaminhamento de acesso à Internet não está habilitado, os usuários podem acessar recursos da internet sem rotear o tráfego pelo Secure Web Gateway. Essa lacuna permite que agentes de ameaça contornem controles de segurança que bloqueiam ameaças, conteúdo malicioso e destinos inseguros.

Sem essa proteção:

- As organizações perdem visibilidade sobre os padrões de tráfego. Não conseguem detectar exfiltração de dados, conexões a domínios maliciosos ou acesso externo não autorizado.
- Agentes de ameaça podem entregar malware, estabelecer conexões de comando e controle ou exfiltrar dados por canais não monitorados.
- Agentes de ameaça podem usar credenciais comprometidas ou engenharia social para obter acesso inicial, baixar ferramentas, estabelecer persistência ou se comunicar com infraestrutura externa.
- Agentes de ameaça podem usar contas comprometidas para se misturar ao comportamento típico do usuário e acessar recursos externos sem acionar alertas de segurança baseados em contexto de usuário, conformidade de dispositivo ou localização.

**Ação de remediação**
- Habilite o perfil de encaminhamento de acesso à Internet para rotear o tráfego pelo Secure Web Gateway. Para mais informações, consulte [Como gerenciar o perfil de encaminhamento de tráfego de acesso à Internet](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-internet-access-profile?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Atribua usuários e grupos ao perfil de acesso à Internet para limitar o encaminhamento de tráfego a usuários específicos. Para mais informações, consulte [Perfis de encaminhamento de tráfego do Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/concept-traffic-forwarding?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%










