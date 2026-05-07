O Web Application Firewall (WAF) do Azure Front Door fornece proteção centralizada na borda para aplicações web distribuídas globalmente por meio de conjuntos de regras gerenciadas com assinaturas pré-configuradas para ataques conhecidos. O Microsoft Default Ruleset é atualizado continuamente e protege contra vulnerabilidades web comuns e críticas sem exigir configuração avançada. Quando nenhum ruleset gerenciado está habilitado, a política de WAF atua praticamente como pass-through, sem bloquear padrões de ataque conhecidos. Isso expõe a aplicação a SQL injection, cross-site scripting, inclusão local de arquivos e injeção de comandos.

**Ação de remediação**

Visão geral dos recursos de WAF no Azure Front Door, incluindo rulesets gerenciados
- [Azure Web Application Firewall no Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview)

Documentação detalhada dos grupos e regras do Default Rule Set no Azure Front Door
- [Grupos e regras de DRS do Web Application Firewall](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-drs)

Guia passo a passo para criar e configurar políticas de WAF com rulesets gerenciados
- [Tutorial: Criar uma política de Web Application Firewall no Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-create-portal)

<!--- Results --->
%TestResult%
