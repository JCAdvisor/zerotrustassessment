Este teste verifica se a conta de sincronização do diretório está restrita a locais nomeados (Named Locations) específicos. Ao restringir onde essas contas podem se autenticar, você reduz significativamente o risco de ataques que utilizam credenciais roubadas de redes externas ou não confiáveis.

**Ação de correção**
- [Usar a condição de localização em uma política de Acesso Condicional](https://learn.microsoft.com/entra/identity/conditional-access/location-condition?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- Crie uma política de Acesso Condicional visando a conta de sincronização e restringindo o acesso apenas aos endereços IP conhecidos da infraestrutura local.

<!--- Results --->
%TestResult%
