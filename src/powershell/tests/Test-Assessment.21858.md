Quando identidades de convidados permanecem ativas, mas sem uso por longos períodos, atores de ameaça podem explorar essas contas dormentes como vetores de entrada na organização. Contas de convidados inativas representam uma superfície de ataque significativa porque muitas vezes mantêm permissões de acesso persistentes a recursos, aplicativos e dados, enquanto permanecem sem monitoramento pelas equipes de segurança. Atores de ameaça frequentemente visam essas contas por meio de preenchimento de credenciais (credential stuffing), pulverização de senhas (password spraying) ou comprometendo a organização de origem do convidado para obter acesso lateral. Uma vez que uma conta de convidado inativa é comprometida, os atacantes podem utilizar as concessões de acesso existentes para:
- Mover-se lateralmente dentro do locatário (tenant).
- Escalar privilégios por meio de associações a grupos ou permissões de aplicativos.
- Estabelecer persistência por meio de técnicas como a criação de mais principais de serviço ou modificação de permissões existentes.

A dormência prolongada dessas contas fornece aos atacantes um tempo de permanência estendido para realizar reconhecimento, exfiltrar dados sensíveis e estabelecer backdoors sem detecção, já que as organizações normalmente concentram os esforços de monitoramento em usuários internos ativos em vez de contas de convidados externos.

**Ação de correção**
- [Monitorar e limpar contas de convidados obsoletas](https://learn.microsoft.com/entra/identity/users/clean-up-stale-guest-accounts?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
