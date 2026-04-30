Quando identidades de carga de trabalho operam sem restrições de Acesso Condicional baseadas em rede, atores de ameaças podem comprometer credenciais de Service Principals através de vários métodos, como segredos expostos em repositórios de código ou interceptação de tokens de autenticação. Os invasores podem então usar essas credenciais de qualquer local do mundo. Esse acesso irrestrito permite que realizem atividades de reconhecimento, enumerem recursos e mapeiem a infraestrutura do tenant enquanto parecem legítimos. Uma vez estabelecido no ambiente, o invasor pode se mover lateralmente entre serviços, acessar armazenamentos de dados confidenciais e potencialmente escalar privilégios explorando permissões excessivas entre serviços. A falta de restrições de rede torna impossível detectar padrões de acesso anômalos baseados em localização. Essa lacuna permite que atores de ameaças mantenham acesso persistente e exfiltrem dados por longos períodos sem disparar alertas de segurança que normalmente sinalizariam conexões de redes ou localizações geográficas inesperadas.

**Ação de correção**

- [Configurar Acesso Condicional para identidades de carga de trabalho](https://learn.microsoft.com/entra/identity/conditional-access/workload-identity?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Criar locais nomeados (Named Locations)](https://learn.microsoft.com/entra/identity/conditional-access/concept-assignment-network?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Seguir as melhores práticas para proteger identidades de carga de trabalho](https://learn.microsoft.com/entra/workload-id/workload-identities-overview?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
