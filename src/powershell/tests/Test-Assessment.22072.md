Permitir perguntas de segurança como um método de redefinição de senha por autoatendimento (SSPR) enfraquece o processo de redefinição de senha porque as respostas são frequentemente fáceis de adivinhar, reutilizadas em vários sites ou descobertas por meio de inteligência de fontes abertas (OSINT). Agentes de ameaças enumeram ou aplicam phishing em usuários, derivam respostas prováveis (nomes de familiares, escolas e locais) e, em seguida, acionam fluxos de redefinição de senha para contornar métodos mais fortes explorando essa barreira baseada em conhecimento, que é mais fraca. Depois de redefinirem com sucesso uma senha em uma conta que não está protegida por autenticação multifator, eles podem: obter credenciais primárias válidas, estabelecer tokens de sessão e expandir lateralmente registrando métodos de autenticação mais duráveis, adicionar regras de encaminhamento ou exfiltrar dados sensíveis.

Eliminar este método remove um elo fraco no processo de redefinição de senha. Algumas organizações podem ter motivos comerciais específicos para deixar as perguntas de segurança ativadas, mas isso não é recomendado.

**Ação de correção**

- [Desabilitar perguntas de segurança na política de SSPR](https://learn.microsoft.com/entra/identity/authentication/concept-authentication-security-questions?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Selecionar métodos de autenticação e opções de registro](https://learn.microsoft.com/entra/identity/authentication/tutorial-enable-sspr?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#select-authentication-methods-and-registration-options)
<!--- Results --->
%TestResult%