Contas de convidados com sessões de logon estendidas aumentam a superfície de ataque. Quando as sessões persistem além do tempo necessário, atores de ameaça podem tentar acesso inicial via credential stuffing, pulverização de senhas ou engenharia social. Uma vez dentro, podem manter o acesso por longos períodos sem novos desafios de autenticação. Essas sessões estendidas permitem:

- Acesso não autorizado a artefatos do Microsoft Entra, permitindo identificar recursos sensíveis.
- Persistência na rede usando tokens de autenticação legítimos, dificultando a detecção.
- Uma janela maior para escalar privilégios acessando recursos compartilhados ou explorando relações de confiança.

Sem controles de sessão adequados, invasores podem realizar movimentação lateral por toda a infraestrutura, acessando dados críticos muito além do escopo original da conta de convidado.

**Ação de correção**
- [Configurar políticas adaptativas de tempo de vida de sessão](https://learn.microsoft.com/entra/identity/conditional-access/howto-conditional-access-session-lifetime?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para que as políticas de frequência de logon tenham sessões mais curtas.
<!--- Results --->
%TestResult%
