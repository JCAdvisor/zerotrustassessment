Integração do Gerenciamento de Direitos de Informação (IRM) nas bibliotecas do SharePoint Online é um recurso herdado que foi substituído pelas Permissões Avançadas do SharePoint (ESP). Qualquer biblioteca usando este recurso herdado deve ser sinalizada para migrar para capacidades mais novas.

**Ação de remediação**

Para desabilitar o IRM herdado no SharePoint Online:
1. Identificar as bibliotecas que estão usando proteção IRM (auditar sites existentes)
2. Planejar migração para rótulos de sensibilidade moderno com criptografia
3. Conectar ao SharePoint Online: `Connect-SPOService -Url https://<tenant>-admin.sharepoint.com`
4. Desabilitar IRM herdado: `Set-SPOTenant -IrmEnabled $false`
5. Habilitar rótulos de sensibilidade modernos: `Set-SPOTenant -EnableAIPIntegration $true`
6. Configurar e publicar rótulos de sensibilidade com criptografia para substituir políticas de IRM

- [Habilitar rótulos de sensibilidade para o SharePoint e OneDrive](https://learn.microsoft.com/microsoft-365/compliance/sensitivity-labels-sharepoint-onedrive-files)
- [SharePoint IRM e rótulos de sensibilidade (orientação de migração)](https://learn.microsoft.com/microsoft-365/compliance/sensitivity-labels-sharepoint-onedrive-files#sharepoint-information-rights-management-irm-and-sensitivity-labels)
- [Criar e configurar rótulos de sensibilidade com criptografia](https://learn.microsoft.com/microsoft-365/compliance/encryption-sensitivity-labels)

<!--- Results --->
%TestResult%
