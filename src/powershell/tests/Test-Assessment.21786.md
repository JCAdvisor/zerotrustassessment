Um atacante pode interceptar ou extrair tokens de autenticação da memória, do armazenamento local em um dispositivo legítimo ou inspecionando o tráfego de rede. O invasor pode reutilizar esses tokens para ignorar os controles de autenticação de usuários e dispositivos, obter acesso não autorizado a dados sensíveis ou realizar novos ataques. Como esses tokens são válidos e limitados no tempo, a detecção de anomalias tradicional muitas vezes falha em sinalizar a atividade, o que pode permitir o acesso sustentado até que o token expire ou seja revogado.

A proteção de token, também chamada de vinculação de token (token binding), ajuda a evitar o roubo de tokens, garantindo que um token seja utilizável apenas a partir do dispositivo pretendido. A proteção de token utiliza criptografia para que, sem a chave do dispositivo cliente, ninguém possa usar o token.

**Ação de remediação**

- [Implantar uma política de Acesso Condicional para exigir proteção de token](https://learn.microsoft.com/entra/identity/conditional-access/concept-token-protection?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)
<!--- Results --->
%TestResult%
