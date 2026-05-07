O recurso de superusuario do servico de Gerenciamento de Direitos do Azure concede a contas designadas a capacidade de descriptografar conteudo que sua organizacao criptografou usando esse servico, independentemente das permissoes originais atribuidas. Superusuarios podem ser necessarios para descoberta eletronica, recuperacao de dados, investigacoes de conformidade e migracao de conteudo. O recurso de superusuario garante que pessoas e servicos autorizados sempre possam ler e inspecionar os dados que o servico de Gerenciamento de Direitos do Azure criptografa para sua organizacao.

Quando voce usa um grupo para designar contas de superusuario, a associacao desse grupo deve ser cuidadosamente controlada e limitada, por exemplo, a contas de servico usadas por ferramentas de conformidade ou plataformas de descoberta eletronica. A menos que voce tenha um requisito tecnico ou necessidade de negocio que exija esse recurso habilitado o tempo todo, a Microsoft recomenda mante-lo desabilitado por padrao e habilita-lo apenas quando necessario. Quando voce usa um grupo para designar contas de superusuario, use o Microsoft Entra Privileged Identity Management (PIM) para reduzir riscos com acesso just-in-time quando necessario e minimizacao de privilegio permanente.

**Ação de remediação**

- [Configurar superusuarios do Gerenciamento de Direitos do Azure para servicos de descoberta ou recuperacao de dados](https://learn.microsoft.com/purview/encryption-super-users?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#security-best-practices-for-the-super-user-feature)
<!--- Results --->
%TestResult%
