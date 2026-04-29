Os aplicativos de serviços da Microsoft que operam em seu locatário (tenant) são identificados como entidades de serviço com o ID de organização proprietária "f8cdef31-a31e-4b4a-93e4-5f571e91255a". Quando essas entidades de serviço têm credenciais configuradas em seu tenant, elas podem criar vetores de ataque potenciais. Se um administrador adicionou as credenciais e elas não são mais necessárias, elas podem se tornar um alvo. Atacantes podem usar essas credenciais para se autenticar como a entidade de serviço, obtendo as mesmas permissões e direitos de acesso que o aplicativo de serviço da Microsoft. Esse acesso inicial pode levar à escalada de privilégios e movimento lateral.

Se credenciais (como segredos de cliente ou certificados) estiverem configuradas para essas entidades de serviço, significa que alguém as habilitou para autenticação independente em seu ambiente. Essas credenciais devem ser investigadas para determinar sua legitimidade.

**Ação de remediação**

- Confirme se as credenciais adicionadas ainda são casos de uso válidos. Se não, remova as credenciais dos aplicativos de serviço da Microsoft.
    - No centro de administração do Microsoft Entra, acesse **Entra ID** > **Registros de aplicativo** e selecione o aplicativo afetado.
    - Vá para a seção **Certificados e segredos** e remova quaisquer credenciais que não sejam mais necessárias.
<!--- Results --->
%TestResult%
