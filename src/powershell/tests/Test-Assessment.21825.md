Quando usuários privilegiados têm permissão para manter sessões de logon de longa duração sem reautenticação periódica, atores de ameaça ganham janelas estendidas de oportunidade para explorar credenciais comprometidas ou sequestrar sessões ativas. Uma vez que uma conta privilegiada é comprometida por técnicas como roubo de credenciais, phishing ou fixação de sessão, os tempos limite de sessão estendidos permitem que os invasores mantenham persistência no ambiente por períodos prolongados. Com sessões de longa duração, os atores de ameaça podem realizar movimentação lateral entre sistemas, escalar privilégios e acessar recursos sensíveis sem acionar outro desafio de autenticação. A duração estendida da sessão também aumenta a janela para ataques de sequestro de sessão (session hijacking), onde tokens de sessão podem ser roubados para personificar o usuário privilegiado. Uma vez estabelecido em uma sessão privilegiada, um invasor pode:

- Criar contas de backdoor
- Modificar políticas de segurança
- Acessar dados sensíveis
- Estabelecer mais mecanismos de persistência

A falta de requisitos de reautenticação periódica significa que, mesmo que o comprometimento inicial seja detectado, o ator de ameaça pode continuar operando sem ser notado usando a sessão privilegiada sequestrada até que ela expire naturalmente ou o usuário encerre a sessão manualmente.

**Ação de correção**

- [Saiba mais sobre as políticas de tempo de vida de sessão adaptativas do Acesso Condicional](https://learn.microsoft.com/entra/identity/conditional-access/concept-session-lifetime?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Configure a frequência de logon para usuários privilegiados com políticas de Acesso Condicional](https://learn.microsoft.com/entra/identity/conditional-access/howto-conditional-access-session-lifetime?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
