O Azure Firewall Premium oferece inspeção de TLS (Transport Layer Security) para descriptografar e inspecionar tráfego de saída e leste-oeste, e tráfego de entrada de TLS quando usado com o Azure Application Gateway. A inspeção de TLS é crítica para detectar ameaças avançadas que usam canais criptografados para contornar controles de segurança tradicionais.

Quando a inspeção de TLS está ativada, o Azure Firewall usa um certificado de autoridade de certificação (CA) fornecido pelo cliente armazenado no Azure Key Vault para descriptografar, inspecionar e depois criptografar novamente o tráfego antes de encaminhá-lo para seu destino. Isso permite recursos de segurança avançados, como IDPS e filtragem de URL, para analisar tráfego criptografado e identificar atividades maliciosas que de outro modo permaneceriam ocultas.

Essa verificação verifica se o Azure Firewall Premium tem a inspeção de TLS ativada. Sem a inspeção de TLS, o firewall não consegue inspecionar payloads criptografados, limitando significativamente a visibilidade em ameaças que usam TLS para contornar a detecção.

**Ação de remediação**

- [Guia de implementação de recursos do Azure Firewall Premium](https://learn.microsoft.com/en-us/azure/firewall/premium-features)
- [Implantar e configurar certificados de CA corporativa para o Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/premium-deploy-certificates-enterprise-ca)
- [Certificados do Azure Firewall Premium](https://learn.microsoft.com/en-us/azure/firewall/premium-certificates)

<!--- Results --->
%TestResult%
