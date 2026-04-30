Convidar convidados externos é benéfico para a colaboração organizacional. No entanto, na ausência de um padrinho (sponsor) interno atribuído para cada convidado, essas contas podem persistir no diretório sem uma responsabilidade clara. Essa negligência cria um risco: atores de ameaças poderiam potencialmente comprometer uma conta de convidado não utilizada ou não monitorada e, em seguida, estabelecer um ponto de entrada inicial dentro do tenant. Uma vez concedido o acesso como um aparente usuário "legítimo", um invasor pode explorar recursos acessíveis e tentar a escalada de privilégios, o que poderia, em última análise, expor informações confidenciais ou sistemas críticos. Uma conta de convidado não monitorada pode, portanto, tornar-se o vetor de acesso não autorizado a dados ou de uma violação de segurança significativa. Uma sequência típica de ataque pode seguir o seguinte padrão, tudo realizado sob o disfarce de um colaborador externo padrão:

1. Acesso inicial obtido através de credenciais de convidado comprometidas.
2. Persistência devido à falta de supervisão.
3. Escalada adicional ou movimentação lateral se a conta do convidado possuir associações a grupos ou permissões elevadas.
4. Execução de objetivos maliciosos.

Exigir que cada conta de convidado seja atribuída a um padrinho mitiga diretamente esse risco. Tal requisito garante que cada usuário externo esteja vinculado a uma parte interna responsável, da qual se espera que monitore e ateste regularmente a necessidade contínua de acesso do convidado. O recurso de padrinho (sponsor) no Microsoft Entra ID apoia a responsabilidade rastreando o convidador e prevenindo a proliferação de contas de convidados "órfãs". Quando um padrinho gerencia o ciclo de vida da conta do convidado, como remover o acesso quando a colaboração termina, a oportunidade para atores de ameaças explorarem contas negligenciadas é substancialmente reduzida. Esta prática recomendada é consistente com a orientação da Microsoft de exigir o apadrinhamento para convidados de negócios como parte de uma estratégia eficaz de governança de acesso de convidados. Ela estabelece um equilíbrio entre permitir a colaboração e reforçar a segurança, pois garante que a presença e as permissões de cada usuário convidado permaneçam sob supervisão interna contínua.

**Ação de correção**
- Para cada usuário convidado que não possui padrinho, atribua um padrinho no Microsoft Entra ID.
    - [Adicionar um padrinho a um usuário convidado no centro de administração do Microsoft Entra](https://learn.microsoft.com/entra/external-id/b2b-sponsors?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
    - [Adicionar um padrinho a um usuário convidado usando o Microsoft Graph](https://learn.microsoft.com/graph/api/user-post-sponsors?view=graph-rest-1.0&preserve-view=true&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
