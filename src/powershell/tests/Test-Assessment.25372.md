A implantação abrangente do cliente do Global Secure Access é fundamental para alcançar a segurança de rede Zero Trust. Se você não implantar o cliente do Global Secure Access nos endpoints gerenciados, esses dispositivos operam fora dos controles do Security Service Edge da organização. Atores de ameaça podem explorar endpoints desprotegidos para estabelecer acesso inicial, mover-se lateralmente ou exfiltrar dados sem acionar políticas de segurança em nível de rede.

Sem o cliente do Global Secure Access:

- Os dispositivos não podem se beneficiar de verificações de rede compatíveis em políticas do Conditional Access, restauração de IP de origem ou restrições de locatário.
- O roubo de credenciais e ataques de repetição de token são mais difíceis de detectar quando o tráfego contorna o perímetro de segurança.
- Endpoints gerenciados não podem acessar aplicativos privados por meio do Microsoft Entra Private Access.

**Ação de remediação**
- Instalar o cliente do Global Secure Access:
    - [Cliente Windows](https://learn.microsoft.com/entra/global-secure-access/how-to-install-windows-client?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
    - [Cliente macOS](https://learn.microsoft.com/entra/global-secure-access/how-to-install-macos-client?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
    - [Cliente iOS](https://learn.microsoft.com/entra/global-secure-access/how-to-install-ios-client?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
    - [Cliente Android](https://learn.microsoft.com/entra/global-secure-access/how-to-install-android-client?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
- Monitore a integridade e o status de conexão do cliente do Global Secure Access usando o [painel do Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/concept-traffic-dashboard?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).
<!--- Results --->
%TestResult%
