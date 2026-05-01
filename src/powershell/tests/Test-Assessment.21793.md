As Restrições de tenant v2 (TRv2) permitem que as organizações apliquem políticas que restringem o acesso a tenants específicos do Microsoft Entra, impedindo a exfiltração não autorizada de dados corporativos para tenants externos usando contas locais. Sem o TRv2, atacantes podem explorar essa vulnerabilidade, o que leva a potencial exfiltração de dados e violações de conformidade, seguidas por colheita de credenciais se esses tenants externos possuírem controles mais fracos. Uma vez obtidas as credenciais, os invasores podem obter acesso inicial a esses tenants externos. O TRv2 fornece o mecanismo para impedir que os usuários se autentiquem em tenants não autorizados. Caso contrário, os atacantes podem se mover lateralmente, escalar privilégios e potencialmente exfiltrar dados sensíveis, tudo isso aparecendo como atividade de usuário legítima que ignora os controles tradicionais de prevenção de perda de dados (DLP) focados no monitoramento interno do tenant.

A implementação do TRv2 aplica políticas que restringem o acesso a tenants especificados, mitigando esses riscos ao garantir que a autenticação e o acesso aos dados sejam confinados apenas a tenants autorizados.

Se este teste passar, seu tenant possui uma política TRv2 configurada, mas etapas adicionais são necessárias para validar o cenário de ponta a ponta.

**Ação de remediação**
- [Configurar Restrições de tenant v2](https://learn.microsoft.com/entra/external-id/tenant-restrictions-v2?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
