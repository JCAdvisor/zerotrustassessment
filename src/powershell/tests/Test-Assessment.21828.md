Bloquear a transferência de autenticação no Microsoft Entra ID é um controle de segurança crítico. Ele ajuda a proteger contra roubo de token e ataques de replay, impedindo o uso de tokens de dispositivo para autenticação silenciosa em outros dispositivos ou navegadores. Quando a transferência de autenticação está habilitada, um ator de ameaça que ganha acesso a um dispositivo pode acessar recursos em dispositivos não aprovados, ignorando a autenticação padrão e as verificações de conformidade do dispositivo. Quando os administradores bloqueiam esse fluxo, as organizações garantem que cada solicitação de autenticação deve se originar do dispositivo original, mantendo a integridade da conformidade do dispositivo e o contexto da sessão do usuário.

**Ação de correção**

- [Implantar uma política de Acesso Condicional para bloquear a transferência de autenticação](https://learn.microsoft.com/entra/identity/conditional-access/policy-block-authentication-flows?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#authentication-transfer-policies)
<!--- Results --->
%TestResult%
