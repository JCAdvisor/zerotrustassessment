Quando as políticas de expiração de senha permanecem ativadas, os atores de ameaça podem explorar os padrões previsíveis de rotação de senha que os usuários normalmente seguem quando forçados a alterar as senhas regularmente. Os usuários frequentemente criam senhas mais fracas fazendo modificações mínimas nas existentes, como incrementar números ou adicionar caracteres sequenciais. Os atores de ameaça podem facilmente antecipar e explorar esses tipos de alterações por meio de ataques de preenchimento de credenciais (credential stuffing) ou campanhas direcionadas de pulverização de senhas (password spraying). Esses padrões previsíveis permitem que os atores de ameaça estabeleçam persistência por meio de:

- Credenciais comprometidas
- Privilégios escalonados ao visar contas administrativas com senhas rotacionadas fracas
- Manutenção de acesso de longo prazo prevendo variações futuras de senha

Pesquisas mostram que os usuários criam senhas mais fracas e previsíveis quando são forçados a expirar. Essas senhas previsíveis são mais fáceis de quebrar para invasores experientes, pois eles costumam fazer modificações simples nas senhas existentes em vez de criar senhas inteiramente novas e fortes. Além disso, quando os usuários são obrigados a alterar as senhas com frequência, eles podem recorrer a práticas inseguras, como anotar senhas ou armazená-las em locais de fácil acesso, criando mais vetores de ataque para os atores de ameaça explorarem durante o reconhecimento físico ou campanhas de engenharia social.

**Ação de correção**

- [Defina a política de expiração de senha para sua organização](https://learn.microsoft.com/microsoft-365/admin/manage/set-password-expiration-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
    - Entre no [centro de administração do Microsoft 365](https://admin.microsoft.com/). Vá para **Configurações** > **Configurações da Organização** > **Segurança e Privacidade** > **Política de expiração de senha**. Certifique-se de que a configuração **Definir senhas para nunca expirarem** esteja marcada.
- [Desative a expiração de senha usando o Microsoft Graph](https://learn.microsoft.com/graph/api/domain-update?view=graph-rest-1.0&preserve-view=true&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- [Defina senhas de usuários individuais para nunca expirarem usando o Microsoft Graph PowerShell](https://learn.microsoft.com/microsoft-365/admin/add-users/set-password-to-never-expire?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
    - `Update-MgUser -UserId <UserID> -PasswordPolicies DisablePasswordExpiration`
<!--- Results --->
%TestResult%
