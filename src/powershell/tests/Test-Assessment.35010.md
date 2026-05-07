Criptografia de Chave Dupla (DKE) fornece uma camada extra de proteção para dados altamente sensíveis exigindo duas chaves para descriptografar conteúdo: uma gerenciada pela Microsoft e outra pelo cliente. Essa abordagem de "mantenha sua própria chave" garante que a Microsoft não possa descriptografar o conteúdo mesmo com compulsão legal, atendendo a requisitos regulatórios rigorosos de soberania de dados.

No entanto, o DKE introduz complexidade operacional significativa, incluindo infraestrutura de serviço de chave dedicada, compatibilidade reduzida de recursos e aumento do ônus de suporte. As organizações devem manter 1-3 rótulos reservados para dados verdadeiramente críticos da missão ou altamente regulados, com justificativa comercial documentada para cada rótulo DKE. Use criptografia padrão para conteúdo comercial geral. Rótulos DKE excessivos (4 ou mais) criam sobrecarga de gerenciamento, confusão do usuário e reduzem colaboração. DKE nunca deve ser amplamente implantado, pois a indisponibilidade do serviço de chave impede o acesso aos documentos críticos do negócio.

**Ação de remediação**

- [Criptografia de Chave Dupla](https://learn.microsoft.com/purview/double-key-encryption?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- [Configurar Criptografia de Chave Dupla](https://learn.microsoft.com/purview/double-key-encryption-setup?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
