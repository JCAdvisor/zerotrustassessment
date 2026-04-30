Organizações com extensas superfícies de senha voltadas ao usuário expõem múltiplos pontos de entrada para atores de ameaças lançarem ataques baseados em credenciais. Interações frequentes do usuário com prompts de senha em aplicativos, dispositivos e fluxos de trabalho aumentam o risco de exploração. Os invasores geralmente começam com o preenchimento de credenciais (credential stuffing) — usando credenciais comprometidas de violações de dados — seguido por pulverização de senhas (password spraying) para testar senhas comuns em várias contas. Uma vez obtido o acesso inicial, eles realizam a descoberta de credenciais examinando repositórios de senhas de navegadores, credenciais em cache na memória e gerenciadores de credenciais para coletar materiais de autenticação adicionais. Essas credenciais roubadas permitem a movimentação lateral, permitindo que os invasores acessem mais sistemas e aplicativos, frequentemente escalando privilégios ao visar contas administrativas que ainda dependem de autenticação por senha. Na fase de persistência, os invasores podem criar contas de "backdoor" com acesso baseado em senha ou enfraquecer as defesas alterando as políticas de senha. Para evitar a detecção, eles aproveitam canais de autenticação legítimos, misturando-se à atividade normal do usuário enquanto mantêm acesso persistente aos recursos organizacionais.

**Ação de correção**

 * [Habilitar métodos de autenticação sem senha (passwordless)](https://learn.microsoft.com/en-us/entra/identity/authentication/how-to-plan-prerequisites-phishing-resistant-passwordless-authentication)

 * [Implantar chaves de segurança FIDO2](https://learn.microsoft.com/en-us/entra/identity/authentication/how-to-enable-passkey-fido2)

<!--- Results --->
%TestResult%
