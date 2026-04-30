Quando usuários não administradores podem acessar suas próprias chaves do BitLocker, agentes de ameaça que comprometem credenciais de usuários ganham acesso direto às chaves de criptografia sem exigir escalonamento de privilégios. Uma vez que os atacantes obtêm as chaves do BitLocker, eles podem descriptografar dados sensíveis armazenados no dispositivo, incluindo credenciais em cache, bancos de dados locais e arquivos confidenciais.

Sem as restrições adequadas, uma única conta de usuário comprometida fornece acesso imediato a todos os dados criptografados naquele dispositivo, anulando o principal benefício de segurança da criptografia de disco e criando um caminho para movimentação lateral.

**Ação de remediação**

- [Restringir usuários não administradores de recuperar as chaves do BitLocker para seus dispositivos próprios](https://learn.microsoft.com/entra/identity/devices/manage-device-identities?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#configure-device-settings)
<!--- Results --->
%TestResult%
