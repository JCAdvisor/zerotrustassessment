Se as organizações não usarem proteção Prompt Shield, atores de ameaça podem explorar vulnerabilidades de injeção de prompt para comprometer fluxos de trabalho alimentados por IA. Usuários maliciosos podem criar entradas adversárias que manipulam grandes modelos de linguagem para ignorar instruções do sistema, divulgar dados confidenciais ou executar ações não intencionais, como gerar conteúdo de phishing.

Sem filtragem de prompt em nível de rede:

- Ataques diretos de injeção de prompt podem contornar mecanismos de segurança em nível de aplicativo através de técnicas sofisticadas de jailbreak.
- A injeção indireta de prompt ocorre quando atores de ameaça incorporam instruções maliciosas em conteúdo externo que a IA processa.
- Cada aplicativo de IA deve implementar proteção de forma independente, criando posturas de segurança inconsistentes e proteções inadequadas contra implantações de IA novas ou personalizadas.

**Ação de remediação**

- [Ativar o perfil de encaminhamento de tráfego do Internet Access para rotear o tráfego da internet através do Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-internet-access-profile?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- [Configure as configurações de inspeção TLS e implante o certificado CA para permitir a inspeção do tráfego de aplicativos de IA criptografados](https://learn.microsoft.com/entra/global-secure-access/how-to-transport-layer-security-settings?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Siga as etapas em [Proteger aplicações de IA generativa corporativa com Prompt Shield](https://learn.microsoft.com/entra/global-secure-access/how-to-ai-prompt-shield?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para:
    - Criar políticas de prompt para verificar e bloquear prompts maliciosos direcionados a aplicações de IA generativa.
    - Vincular políticas de prompt a perfis de segurança para organizá-las para direcionamento do Conditional Access.
    - Criar políticas de Conditional Access para aplicar perfis de segurança com políticas de prompt aos usuários que acessam recursos da internet.
- [Instale o cliente Global Secure Access em dispositivos de usuário para ativar a aquisição de tráfego](https://learn.microsoft.com/entra/global-secure-access/how-to-install-windows-client?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%
