Quando seus usuarios enviam ou compartilham arquivos ou emails criptografados com pessoas fora da organizacao, ou recebem conteudo criptografado de parceiros, o Microsoft Entra ID precisa verificar identidades. Essa verificacao ocorre em ambos os lados do envio e do recebimento para aplicar as configuracoes de criptografia. Se as configuracoes de acesso entre locatarios bloquearem o acesso ao servico Azure Rights Management, esses usuarios verao o erro "Access is blocked by your organization". Nesse cenario, eles nao conseguem abrir o conteudo protegido.

Permita o aplicativo Microsoft Rights Management Services configurando as definicoes de acesso entre locatarios para trafego de entrada (usuarios externos abrindo conteudo que voce compartilha) e de saida (seus usuarios abrindo conteudo de parceiros). Sem essa configuracao, o compartilhamento de conteudo criptografado falha, mesmo quando as permissoes corretas estao atribuidas.

**Ação de remediação**

- [Configuracoes de acesso entre locatarios e conteudo criptografado](https://learn.microsoft.com/purview/encryption-azure-ad-configuration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#cross-tenant-access-settings-and-encrypted-content)
- [Configurar acesso entre locatarios para colaboracao B2B](https://learn.microsoft.com/entra/external-id/cross-tenant-access-settings-b2b-collaboration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
