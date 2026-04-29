Aplicativos que utilizam segredos de cliente (client secrets) podem armazená-los em arquivos de configuração, codificá-los diretamente em scripts ou correr o risco de exposição de outras formas. A complexidade do gerenciamento de segredos torna os segredos de cliente suscetíveis a vazamentos e atraentes para atacantes. Quando expostos, os segredos de cliente permitem que invasores misturem suas atividades com operações legítimas, facilitando a evasão de controles de segurança. Se um atacante comprometer o segredo de um aplicativo, ele poderá escalar seus privilégios no sistema, levando a um acesso e controle mais amplos, dependendo das permissões do aplicativo.

Aplicativos e entidades de serviço que possuem permissões para as APIs do Microsoft Graph ou outras APIs apresentam um risco maior, pois um invasor pode explorar essas permissões adicionais.

**Ação de remediação**

- [Migrar aplicativos de segredos compartilhados para identidades gerenciadas (managed identities) e adotar práticas mais seguras](https://learn.microsoft.com/entra/identity/enterprise-apps/migrate-applications-from-secrets?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
   - Use identidades gerenciadas para recursos do Azure
   - Implemente políticas de Acesso Condicional para identidades de carga de trabalho (workload identities)
   - Implemente a varredura de segredos (secret scanning)
   - Implemente políticas de autenticação de aplicativos para forçar práticas seguras
   - Crie uma função personalizada de privilégio mínimo para rotacionar credenciais
   - Garanta que existe um processo para triagem e monitoramento de aplicativos
<!--- Results --->
%TestResult%
