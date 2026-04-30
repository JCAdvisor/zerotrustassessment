Quando aplicações que suportam autenticação e provisionamento através do Microsoft Entra não estão configuradas para provisionamento automático, as organizações tornam-se vulneráveis a lacunas no ciclo de vida da identidade que atores de ameaças podem explorar. Sem o provisionamento automatizado, as contas de usuário podem persistir em aplicações após os funcionários deixarem a organização. Essa vulnerabilidade cria contas inativas que invasores podem descobrir através de atividades de reconhecimento. Essas contas órfãs frequentemente mantêm suas permissões de acesso originais, mas carecem de monitoramento ativo, tornando-as alvos atraentes para o acesso inicial.

Atores de ameaças que ganham acesso a essas contas inativas podem usá-las para estabelecer persistência na aplicação alvo, já que as contas parecem legítimas e podem não disparar alertas de segurança. A partir dessas contas de aplicação comprometidas, os invasores podem:

- Tentar escalar seus privilégios explorando permissões específicas da aplicação.
- Acessar dados confidenciais armazenados na aplicação.
- Usar a aplicação como um ponto de pivô para acessar outros sistemas conectados.

A falta de gerenciamento centralizado do ciclo de vida da identidade também dificulta a detecção pelas equipes de segurança quando um invasor está usando essas contas órfãs, pois as contas podem não estar devidamente correlacionadas com o diretório de usuários ativos da organização.

**Ação de correção**

- [Configurar o provisionamento de aplicativos para aplicações ausentes](https://learn.microsoft.com/entra/identity/app-provisioning/configure-automatic-user-provisioning-portal?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
