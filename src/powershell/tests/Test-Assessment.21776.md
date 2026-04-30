Sem configurações de consentimento do usuário restritas, atacantes podem explorar configurações permissivas de consentimento de aplicativos para obter acesso não autorizado a dados organizacionais sensíveis. Quando o consentimento do usuário é irrestrito, os invasores podem:

- Usar engenharia social e ataques de concessão de consentimento ilícito (illicit consent grant) para enganar os usuários.
- Personificar serviços legítimos para solicitar permissões amplas (e-mail, arquivos, calendários).
- Obter tokens OAuth legítimos que ignoram controles de segurança de perímetro.
- Estabelecer acesso persistente e realizar movimento lateral.

O consentimento irrestrito também limita a capacidade de governança centralizada, dificultando a visibilidade de quais aplicativos não-Microsoft têm acesso aos dados.

**Ação de remediação**

- [Configurar definições de consentimento do usuário restritas](https://learn.microsoft.com/entra/identity/enterprise-apps/configure-user-consent?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para evitar concessões de consentimento ilícitas, desabilitando o consentimento do usuário ou limitando-o a editores verificados com permissões de baixo risco apenas.
<!--- Results --->
%TestResult%
