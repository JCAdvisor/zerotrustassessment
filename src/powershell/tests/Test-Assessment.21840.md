Quando o atestado de chave de segurança não é imposto, atores de ameaça podem explorar hardware de autenticação fraco ou comprometido para estabelecer presença persistente em ambientes organizacionais. Sem a validação de atestado, atores maliciosos podem registrar chaves de segurança FIDO2 não autorizadas ou falsificadas que ignoram os controles de segurança baseados em hardware, permitindo-lhes realizar ataques de preenchimento de credenciais (credential stuffing) usando autenticadores fabricados que imitam chaves de segurança legítimas.

Esse acesso inicial permite que os atores de ameaça escalem privilégios aproveitando a natureza confiável dos métodos de autenticação por hardware e, em seguida, se movam lateralmente pelo ambiente registrando mais chaves de segurança comprometidas em contas de alto privilégio. A falta de imposição de atestado cria um caminho para que os invasores estabeleçam comando e controle por meio de métodos de autenticação persistentes baseados em hardware, levando, em última análise, à exfiltração de dados ou ao comprometimento do sistema, mantendo a aparência de uma autenticação legítima protegida por hardware durante toda a cadeia de ataque.

**Ação de correção**

- [Ativar a imposição de atestado por meio da configuração da política de métodos de autenticação](https://learn.microsoft.com/entra/identity/authentication/how-to-enable-passkey-fido2?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enable-passkey-fido2-authentication-method).
- [Configurar a lista aprovada de chaves de segurança por Authenticator Attestation Globally Unique Identifier (AAGUID)](https://learn.microsoft.com/entra/identity/authentication/concept-fido2-hardware-vendor?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%
