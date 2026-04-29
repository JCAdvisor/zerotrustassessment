Se usuários não privilegiados puderem criar aplicativos e entidades de serviço, essas contas podem ser configuradas incorretamente ou receber mais permissões do que o necessário, criando novos vetores para atacantes. Crimsonais podem explorar essas contas para estabelecer credenciais válidas no ambiente e ignorar alguns controles de segurança.

Se essas contas não privilegiadas receberem erroneamente permissões elevadas de proprietário de aplicativo, os atacantes podem usá-las para escalar seu nível de acesso. Invasores que comprometem contas não privilegiadas podem adicionar suas próprias credenciais ou alterar as permissões associadas aos aplicativos criados por esses usuários para garantir persistência indetectada.

Além disso, atacantes podem usar entidades de serviço para se misturar a processos e atividades legítimas do sistema. Como as entidades de serviço frequentemente realizam tarefas automatizadas, atividades maliciosas sob essas contas podem não ser sinalizadas como suspeitas.

**Ação de remediação**

- [Bloquear usuários não privilegiados de criar aplicativos](https://learn.microsoft.com/entra/identity/role-based-access-control/delegate-app-roles?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
