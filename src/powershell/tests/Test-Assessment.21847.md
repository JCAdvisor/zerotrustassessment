Quando a proteção de senha local (on-premises) não está habilitada ou imposta, atores de ameaça podem usar ataques de password spray do tipo "low-and-slow" com variantes comuns, como estação+ano+símbolo ou termos locais, para obter acesso inicial a contas do Active Directory Domain Services. Os Controladores de Domínio (DCs) podem aceitar senhas fracas quando qualquer uma das seguintes afirmações for verdadeira:

- O agente do Microsoft Entra Password Protection para DC não está instalado.
- A configuração de proteção de senha do locatário está desabilitada ou em modo apenas de auditoria.

Com credenciais locais válidas, os atacantes se movem lateralmente reutilizando senhas entre endpoints, escalam para administrador de domínio através da reutilização de admin local ou contas de serviço e persistem adicionando backdoors; enquanto isso, a imposição fraca ou desabilitada produz menos eventos de bloqueio e sinais previsíveis. O design da Microsoft requer um proxy que faça a mediação da política do Microsoft Entra ID e um agente de DC que imponha as listas de banidos globais e personalizadas do locatário combinadas na alteração/redefinição de senha; a imposição consistente requer cobertura do agente de DC em todos os DCs de um domínio e o uso do modo Imposto (Enforced) após a avaliação da auditoria.

**Ação de remediação**

- [Implantar o Microsoft Entra password protection](https://learn.microsoft.com/entra/identity/authentication/howto-password-ban-bad-on-premises-deploy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
