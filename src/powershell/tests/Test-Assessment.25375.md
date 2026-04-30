O Global Secure Access requer licenças específicas do Microsoft Entra para funcionar, incluindo o Microsoft Entra Internet Access e o Microsoft Entra Private Access, ambos exigindo o Microsoft Entra ID P1 como pré-requisito. Sem licenças válidas provisionadas no locatário, os administradores não podem configurar perfis de encaminhamento de tráfego, políticas de segurança ou conexões de rede remota. Se você não atribuir licenças aos usuários, o tráfego deles não será roteado pelo Global Secure Access e permanecerá desprotegido pelos controles de segurança.

Sem essa proteção:

- Agentes de ameaças podem ignorar a filtragem de conteúdo da Web, a proteção contra ameaças e as políticas de Acesso Condicional.
- Assinaturas expiradas ou suspensas podem interromper o serviço Global Secure Access, criando lacunas de segurança onde fluxos de tráfego anteriormente protegidos não são monitorados.

**Ação de remediação**
- Revise os requisitos de licenciamento e adquira licenças apropriadas.
- Atribua licenças aos usuários por meio do centro de administração do Microsoft Entra.
- Use o licenciamento baseado em grupo para facilitar o gerenciamento em escala.
- Monitore a utilização de licenças através do centro de administração do Microsoft 365.
<!--- Resultados --->
%TestResult%