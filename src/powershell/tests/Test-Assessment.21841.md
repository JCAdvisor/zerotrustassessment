Atores de ameaça dependem cada vez mais de bombardeio de solicitações (prompt bombing) e proxies de phishing em tempo real para coagir ou enganar os usuários a aprovar desafios fraudulentos de autenticação multifator (MFA). Sem o recurso **Relatar atividade suspeita** do aplicativo Microsoft Authenticator ativado, um invasor pode iterar até que um usuário fadigado aceite a solicitação. Esse tipo de ataque pode levar ao escalonamento de privilégios, persistência, movimentação lateral em cargas de trabalho sensíveis, exfiltração de dados ou ações destrutivas.

Quando o relatório está ativado para todos os usuários, qualquer solicitação inesperada por push ou telefone pode ser sinalizada ativamente, elevando imediatamente o usuário a um risco alto e gerando uma detecção de risco de alta fidelidade (userReportedSuspiciousActivity) que políticas de Acesso Condicional baseadas em risco ou outras automações de resposta podem usar para bloquear ou exigir remediação segura.

**Ação de correção**

- [Ativar a configuração de relatar atividade suspeita no aplicativo Microsoft Authenticator](https://learn.microsoft.com/entra/identity/authentication/howto-mfa-mfasettings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#report-suspicious-activity)
<!--- Results --->
%TestResult%
