Sem fluxos de trabalho de aprovação, atores de ameaça que comprometem credenciais de Administrador Global por meio de phishing, preenchimento de credenciais ou outras técnicas de desvio de autenticação podem ativar imediatamente a função mais privilegiada em um locatário sem qualquer outra verificação ou supervisão. O Privileged Identity Management (PIM) permite que as ativações de funções qualificadas tornem-se ativas em segundos, de modo que credenciais comprometidas podem permitir escalonamento de privilégios quase instantâneo. Uma vez ativado, os atores de ameaça podem usar a função de Administrador Global para seguir os seguintes caminhos de ataque para obter acesso persistente ao locatário:
- Criar novas contas privilegiadas
- Modificar políticas de Acesso Condicional para excluir essas novas contas
- Estabelecer métodos alternativos de autenticação, como autenticação baseada em certificado ou registros de aplicativos com privilégios elevados

A função de Administrador Global fornece acesso a recursos administrativos no Microsoft Entra ID e serviços que usam identidades do Microsoft Entra, incluindo Microsoft Defender XDR, Microsoft Purview, Exchange Online e SharePoint Online. Sem portões de aprovação, atores de ameaça podem escalar rapidamente para o controle total do locatário, exfiltrando dados confidenciais, comprometendo todas as contas de usuário e estabelecendo backdoors de longo prazo por meio de modificações de principais de serviço ou federação que persistem mesmo após o comprometimento inicial ser detectado.

**Ação de correção**

- [Configure as definições de função para exigir aprovação para ativação do Administrador Global](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-how-to-change-default-settings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Configure o fluxo de trabalho de aprovação para funções privilegiadas](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-approval-workflow?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
