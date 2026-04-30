Se as etiquetas de âmbito (scope tags) do Intune não forem configuradas corretamente para a administração delegada, os atacantes que obtenham acesso privilegiado ao Intune ou ao Microsoft Entra ID podem escalar privilégios e aceder a configurações de dispositivos sensíveis em todo o locatário. Sem etiquetas de âmbito granulares, os limites administrativos são pouco claros, permitindo que os atacantes se movam lateralmente, manipulem políticas de dispositivos, exfiltrem dados de configuração ou implementem definições maliciosas em todos os utilizadores e dispositivos. Uma única conta de administrador comprometida pode afetar todo o ambiente. A ausência de administração delegada também prejudica o acesso com o menor privilégio, tornando difícil conter violações e garantir a responsabilidade. Os atacantes podem explorar funções de administrador global ou atribuições de controlo de acesso baseado em funções (RBAC) mal configuradas para contornar políticas de conformidade e ganhar um controlo amplo sobre a gestão de dispositivos.

A aplicação de etiquetas de âmbito segmenta o acesso administrativo e alinha-o com os limites organizacionais. Isto limita o raio de impacto de contas comprometidas, apoia o acesso com o menor privilégio e alinha-se com os princípios Zero Trust de segmentação, controlo baseado em funções e contenção.

**Ação de correção**

Utilize etiquetas de âmbito e funções RBAC do Intune para limitar o acesso de administrador com base na função, geografia ou unidade de negócio:
- [Saiba como criar e implementar etiquetas de âmbito para TI distribuída](https://learn.microsoft.com/intune/intune-service/fundamentals/scope-tags?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Implementar o controlo de acesso baseado em funções com o Microsoft Intune](https://learn.microsoft.com/intune/intune-service/fundamentals/role-based-access-control?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%