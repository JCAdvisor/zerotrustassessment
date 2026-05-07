O Microsoft Rights Management Service (RMS) e a tecnologia de protecao que aplica criptografia para rotulos de sensibilidade e politicas de protecao de informacoes. Quando usuarios acessam conteudo criptografado, seus aplicativos precisam se autenticar no servico RMS (App ID: `00000012-0000-0000-c000-000000000000`) para descriptografar o conteudo. Se as politicas de Acesso Condicional bloquearem ou restringirem essa autenticacao de forma incorreta, por exemplo exigindo autenticacao multifator (MFA), conformidade do dispositivo ou localizacoes de rede especificas, os usuarios nao conseguirao abrir emails, documentos ou arquivos criptografados protegidos por rotulos de sensibilidade.
Isso fica mais evidente ao colaborar em conteudo protegido por MIP entre um locatario externo e o locatario de origem.
O servico RMS deve ser explicitamente excluido de politicas de Acesso Condicional que aplicam controles de autenticacao, pois o proprio aplicativo realiza a descriptografia e o usuario ja foi autenticado no aplicativo cliente principal. Bloquear a autenticacao do RMS impede o processo de descriptografia e interrompe fluxos de protecao da informacao nos servicos do Microsoft 365, incluindo Outlook, Word, Excel, PowerPoint, Teams e SharePoint.

**Ação de remediação**

Para excluir o RMS das politicas de Acesso Condicional:
1. Acesse [Centro de administracao do Microsoft Entra > Entra ID > Acesso Condicional > Politicas](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/Policies)
2. Selecione a politica que esta bloqueando o RMS
3. Em Recursos de destino > Todos os recursos (anteriormente "Todos os aplicativos de nuvem")
4. Em Excluir, selecione "Selecionar recursos" e adicione "Microsoft Rights Management Services" (App ID: `00000012-0000-0000-c000-000000000000`)
5. Salve a politica

- [Configuracao do Microsoft Entra para Azure Information Protection](https://learn.microsoft.com/purview/encryption-azure-ad-configuration)
- [Politicas de Acesso Condicional e documentos criptografados](https://learn.microsoft.com/purview/encryption-azure-ad-configuration#conditional-access-policies-and-encrypted-documents)
- [Acesso Condicional: aplicativos de nuvem, acoes e contexto de autenticacao](https://learn.microsoft.com/entra/identity/conditional-access/concept-conditional-access-cloud-apps)

<!--- Results --->
%TestResult%
