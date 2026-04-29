Se uma conta local for comprometida e estiver sincronizada com o Microsoft Entra, o atacante também poderá obter acesso ao locatário na nuvem. Esse risco aumenta porque os ambientes locais normalmente têm mais superfícies de ataque devido a infraestruturas mais antigas e controles de segurança limitados. Atacantes também podem visar as ferramentas usadas para permitir a conectividade, como o Microsoft Entra Connect ou o AD FS.

Se as contas privilegiadas da nuvem forem sincronizadas com contas locais, um invasor que adquira credenciais locais poderá usar essas mesmas credenciais para acessar recursos da nuvem e realizar movimento lateral para o ambiente de nuvem.

**Ação de remediação**

- [Protegendo o Microsoft 365 contra ataques locais](https://learn.microsoft.com/entra/architecture/protect-m365-from-on-premises-attacks?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- Crie contas de usuário exclusivas na nuvem (cloud-only) para indivíduos em funções privilegiadas e remova suas identidades híbridas dessas funções.
<!--- Results --->
%TestResult%
