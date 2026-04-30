Quando as configurações padrão de colaboração B2B de saída permitem que todos os usuários acessem todos os aplicativos em qualquer organização externa do Microsoft Entra, as organizações não podem controlar para onde os dados corporativos fluem ou com quem os funcionários colaboram. Os usuários podem, intencionalmente ou acidentalmente, carregar dados confidenciais para locatários externos, aceitar convites de locatários falsificados ou mal-intencionados projetados para phishing, ou conceder consentimento OAuth para aplicativos de risco que comprometem os dados corporativos.

Para setores regulamentados, a colaboração externa irrestrita pode violar os requisitos de residência de dados ou as proibições de compartilhamento de dados com organizações não aprovadas.

Ao bloquear a colaboração B2B de saída padrão, as organizações impõem uma postura de negação por padrão que restringe as relações externas a parceiros verificados, protege a propriedade intelectual e garante a visibilidade sobre cada colaboração entre locatários.

**Ação de remediação**
- Saiba mais sobre as configurações de acesso entre locatários e as considerações de planejamento antes de fazer alterações. Para mais informações, consulte [Visão geral do acesso entre locatários](https://learn.microsoft.com/entra/external-id/cross-tenant-access-overview?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Use a pasta de trabalho de atividade de acesso entre locatários para identificar os padrões atuais de colaboração externa antes de bloquear o acesso padrão. Para mais informações, consulte [Pasta de trabalho de atividade de acesso entre locatários](https://learn.microsoft.com/entra/identity/monitoring-health/workbook-cross-tenant-access-activity?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
- Configure as configurações padrão de colaboração B2B de saída para bloquear o acesso. Para mais informações, consulte [Modificar configurações de acesso de saída](https://learn.microsoft.com/entra/external-id/cross-tenant-access-settings-b2b-collaboration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#modify-outbound-access-settings).
- Adicione configurações específicas da organização para locatários parceiros aprovados que exigem colaboração B2B. Para mais informações, consulte [Adicionar uma organização](https://learn.microsoft.com/entra/external-id/cross-tenant-access-settings-b2b-collaboration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#add-an-organization).
<!--- Results --->
%TestResult%
