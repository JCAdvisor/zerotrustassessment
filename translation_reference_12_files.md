# Comprehensive Translation Reference: 12 PowerShell Test Files

**Files to translate**: 25415, 25416, 25419, 25420, 25422, 25480, 25481, 25533, 25535, 25537, 25539, 25550

**Document prepared for**: Batch replacement operations using `multi_replace_string_in_file`

---

## FILE 1: Test-Assessment.25415.ps1 - Prompt Shield Evaluation

### A1. Title Attribute
**English:** `'AI Gateway protects enterprise generative AI applications from prompt injection attacks'`  
**Portuguese:** `'AI Gateway protege aplicativos de IA generativa empresarial contra ataques de injeção de prompt'`  
**Location:** Line 21

### A2. Write-PSFMessage strings
| Line | English | Portuguese |
|------|---------|-----------|
| 31 | `'🟦 Start Prompt Shield evaluation'` | `'🟦 Avaliação do Prompt Shield iniciada'` |

### A3. Write-ZtProgress Activity/Status strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 33 | Activity | `'Checking Prompt Shield configuration for AI Gateway protection'` | `'Verificando configuração do Prompt Shield para proteção do AI Gateway'` |
| 34 | Status | `'Querying prompt policies'` | `'Consultando políticas de prompt'` |
| 42 | Status | `'Querying security profiles and linked policies'` | `'Consultando perfis de segurança e políticas vinculadas'` |
| 48 | Status | `'Querying Conditional Access policies'` | `'Consultando políticas de Acesso Condicional'` |

### A4. Test Result Markdown strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 121 | Fail | `"❌ Prompt Shield is not properly configured - no prompt policies exist.`n`n%TestResult%"` | `"❌ O Prompt Shield não está configurado adequadamente - nenhuma política de prompt existe.`n`n%TestResult%"` |
| 126 | Pass | `"✅ Prompt Shield policies are configured and enforced through the Baseline Profile which applies to all internet traffic.`n`n%TestResult%"` | `"✅ As políticas do Prompt Shield estão configuradas e aplicadas através do Perfil de Linha de Base que se aplica a todo o tráfego de internet.`n`n%TestResult%"` |
| 131 | Pass | `"✅ Prompt Shield policies are configured and enforced through security profiles assigned to Conditional Access policies.`n`n%TestResult%"` | `"✅ As políticas do Prompt Shield estão configuradas e aplicadas através de perfis de segurança atribuídos a políticas de Acesso Condicional.`n`n%TestResult%"` |
| 136 | Fail | `"❌ Prompt Shield is not properly configured - policies are not linked to security profiles, or security profiles with prompt policies are not enforced (no CA policy assignment and not using Baseline Profile).`n`n%TestResult%"` | `"❌ O Prompt Shield não está configurado adequadamente - as políticas não estão vinculadas a perfis de segurança, ou os perfis de segurança com políticas de prompt não são aplicados (sem atribuição de política de CA e não usando Perfil de Linha de Base).`n`n%TestResult%"` |

### A5. Markdown Section Headers
| Line | English | Portuguese |
|------|---------|-----------|
| 148 | `## Prompt Policies (AI Gateway)` | `## Políticas de Prompt (AI Gateway)` |
| 165+ | `## Prompt Policies Linked to Baseline Profile` | `## Políticas de Prompt Vinculadas ao Perfil de Linha de Base` |
| 172+ | `## Security Profiles with Linked Policies` | `## Perfis de Segurança com Políticas Vinculadas` |
| 184+ | `## Conditional Access Policies Assigned to Security Profiles` | `## Políticas de Acesso Condicional Atribuídas a Perfis de Segurança` |

---

## FILE 2: Test-Assessment.25416.ps1 - Cloud Firewall Protection

### B1. Title Attribute
**English:** `'Global Secure Access cloud firewall protects branch office internet traffic'`  
**Portuguese:** `'O firewall de nuvem do Global Secure Access protege o tráfego de internet do escritório de filial'`  
**Location:** Line 29

### B2. Write-PSFMessage strings
| Line | English | Portuguese |
|------|---------|-----------|
| 39 | `'🟦 Start'` | `'🟦 Início'` |
| 50 | `'No remote networks are configured. Cloud Firewall policies for remote networks are not applicable.'` | `'Nenhuma rede remota está configurada. As políticas de firewall na nuvem para redes remotas não são aplicáveis.'` |
| 105 | `"Error retrieving policy rules for policy $policyId`: $_"` | `"Erro ao recuperar regras de política para a política $policyId`: $_"` |

### B3. Write-ZtProgress Activity/Status strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 40 | Activity | `'Checking Branch office internet traffic is protected by Cloud Firewall policies through Global Secure Access'` | `'Verificando se o tráfego de internet do escritório de filial está protegido pelas políticas de firewall na nuvem por meio do Global Secure Access'` |
| 41 | Status | `'Querying remote networks'` | `'Consultando redes remotas'` |
| 57 | Status | `'Querying baseline security profile'` | `'Consultando perfil de segurança de linha de base'` |
| 91 | Status | `"Retrieving policy rules for $policyDisplayName"` | `"Recuperando regras de política para $policyDisplayName"` |

### B4. Test Result Markdown strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 179 | Pass | `"Cloud Firewall is enabled and configured for remote networks. Branch office internet traffic is protected by firewall policies through the baseline security profile.`n`n%TestResult%"` | `"O firewall na nuvem está habilitado e configurado para redes remotas. O tráfego de internet do escritório de filial está protegido pelas políticas de firewall por meio do perfil de segurança de linha de base.`n`n%TestResult%"` |
| 182 | Fail | `"Cloud Firewall is not properly configured for remote networks. Remote network internet traffic is not protected by cloud firewall policies.`n`n%TestResult%"` | `"O firewall na nuvem não está configurado adequadamente para redes remotas. O tráfego de internet da rede remota não está protegido pelas políticas de firewall na nuvem.`n`n%TestResult%"` |

### B5. Markdown Section Headers
| Line | English | Portuguese |
|------|---------|-----------|
| 226 | `## Cloud Firewall Configuration for Remote Networks` | `## Configuração de Firewall na Nuvem para Redes Remotas` |
| 255 | `## Baseline Profile Details` | `## Detalhes do Perfil de Linha de Base` |

---

## FILE 3: Test-Assessment.25419.ps1 - Diagnostic Settings Integration

### C1. Title Attribute
**English:** `'Network access activity is visible to security operations for threat detection and response'`  
**Portuguese:** `'A atividade de acesso à rede é visível para operações de segurança para detecção e resposta a ameaças'`  
**Location:** Line 28

### C2. Write-PSFMessage strings
| Line | English | Portuguese |
|------|---------|-----------|
| 35 | `'🟦 Start'` | `'🟦 Início'` |
| 43 | `'Not connected to Azure.'` | `'Não conectado ao Azure.'` |
| 52 | `'This test is only applicable to the AzureCloud environment.'` | `'Este teste é aplicável apenas ao ambiente AzureCloud.'` |
| 67 | `'The signed in user does not have access to check diagnostic settings.'` | `'O usuário conectado não tem acesso para verificar as configurações de diagnóstico.'` |

### C3. Write-ZtProgress Activity/Status strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 36 | Activity | `'Checking Global Secure Access diagnostic settings for security monitoring'` | `'Verificando configurações de diagnóstico do Global Secure Access para monitoramento de segurança'` |
| 39 | Status | `'Checking Azure connection'` | `'Verificando conexão do Azure'` |
| 49 | Status | `'Checking Azure environment'` | `'Verificando ambiente do Azure'` |
| 58 | Status | `'Querying Microsoft Entra diagnostic settings'` | `'Consultando configurações de diagnóstico do Microsoft Entra'` |

### C4. Test Result Markdown strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 99 | Fail | `"❌ No diagnostic settings are configured for Microsoft Entra. Global Secure Access logs are not being exported to any destination.`n`n%TestResult%"` | `"❌ Nenhuma configuração de diagnóstico está configurada para o Microsoft Entra. Os logs do Global Secure Access não estão sendo exportados para nenhum destino.`n`n%TestResult%"` |
| 117 | Pass | `"✅ All required Global Secure Access log categories are integrated with a Log Analytics workspace for security monitoring and threat detection.`n`n%TestResult%"` | `"✅ Todas as categorias de log do Global Secure Access necessárias estão integradas a um espaço de trabalho do Log Analytics para monitoramento de segurança e detecção de ameaças.`n`n%TestResult%"` |
| 120 | Fail | `"❌ Global Secure Access logs are not properly integrated with a Log Analytics workspace for security operations visibility.`n`n%TestResult%"` | `"❌ Os logs do Global Secure Access não estão adequadamente integrados a um espaço de trabalho do Log Analytics para visibilidade das operações de segurança.`n`n%TestResult%"` |

### C5. Markdown Section Headers
| Line | English | Portuguese |
|------|---------|-----------|
| 125+ | `## [Diagnostic settings configuration]...` (in mdInfo) | `## [Configuração das configurações de diagnóstico]...` |

---

## FILE 4: Test-Assessment.25420.ps1 - Log Retention Configuration

### D1. Title Attribute
**English:** `'Network access logs are retained for security analysis and compliance requirements'`  
**Portuguese:** `'Os logs de acesso à rede são retidos para análise de segurança e requisitos de conformidade'`  
**Location:** Line 29

### D2. Write-PSFMessage strings
| Line | English | Portuguese |
|------|---------|-----------|
| 51 | `'🟦 Start'` | `'🟦 Início'` |
| 59 | `'Not connected to Azure.'` | `'Não conectado ao Azure.'` |
| 68 | `'This test is only applicable to the AzureCloud environment.'` | `'Este teste é aplicável apenas ao ambiente AzureCloud.'` |
| 84 | `'The signed in user does not have access to check diagnostic settings.'` | `'O usuário conectado não tem acesso para verificar as configurações de diagnóstico.'` |
| 118 | `"Failed to query workspace $workspaceId with status code $($workspaceResponse.StatusCode)"` | `"Falha ao consultar o espaço de trabalho $workspaceId com código de status $($workspaceResponse.StatusCode)"` |
| 126 | `"Error querying workspace $workspaceId : $_"` | `"Erro ao consultar o espaço de trabalho $workspaceId : $_"` |

### D3. Write-ZtProgress Activity/Status strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 52 | Activity | `'Evaluating network access log retention configuration'` | `'Avaliando configuração de retenção de logs de acesso à rede'` |
| 55 | Status | `'Checking Azure connection'` | `'Verificando conexão do Azure'` |
| 65 | Status | `'Checking Azure environment'` | `'Verificando ambiente do Azure'` |
| 74 | Status | `'Querying diagnostic settings'` | `'Consultando configurações de diagnóstico'` |
| 105 | Status | `'Checking workspace retention settings'` | `'Verificando configurações de retenção do espaço de trabalho'` |
| 154 | Status | `'Evaluating log categories and retention'` | `'Avaliando categorias de log e retenção'` |

### D4. Test Result Markdown strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 149 | Fail | `"❌ No diagnostic settings are configured for Microsoft Entra. Global Secure Access logs are retained for only 30 days (default in-portal retention) which is insufficient for security investigations.`n`n%TestResult%"` | `"❌ Nenhuma configuração de diagnóstico está configurada para o Microsoft Entra. Os logs do Global Secure Access são retidos por apenas 30 dias (retenção padrão no portal), o que é insuficiente para investigações de segurança.`n`n%TestResult%"` |
| 284 | Pass | `"✅ Global Secure Access logs are retained for at least $MINIMUM_RETENTION_DAYS days, supporting security analysis and compliance requirements`n`n%TestResult%"` | `"✅ Os logs do Global Secure Access são retidos por pelo menos $MINIMUM_RETENTION_DAYS dias, suportando análise de segurança e requisitos de conformidade`n`n%TestResult%"` |
| 290 | Fail | `"❌ Global Secure Access logs are not retained for adequate duration to support security investigations and compliance obligations`n`n%TestResult%"` | `"❌ Os logs do Global Secure Access não são retidos por tempo adequado para suportar investigações de segurança e obrigações de conformidade`n`n%TestResult%"` |

### D5. Markdown Section Headers
| Line | English | Portuguese |
|------|---------|-----------|
| 315 | `### Log retention status` | `### Status de retenção de log` |
| 347 | `### Destination details` | `### Detalhes de destino` |

---

## FILE 5: Test-Assessment.25422.ps1 - GSA Deployment Logs

### E1. Title Attribute
**English:** `'Global Secure Access deployment logs are populated and reviewed'`  
**Portuguese:** `'Os logs de implantação do Global Secure Access estão preenchidos e revisados'`  
**Location:** Line 27

### E2. Write-PSFMessage strings
| Line | English | Portuguese |
|------|---------|-----------|
| 34 | `'🟦 Start'` | `'🟦 Início'` |
| 50 | `'Global Secure Access is not enabled in this tenant.'` | `'O Global Secure Access não está habilitado neste locatário.'` |

### E3. Write-ZtProgress Activity/Status strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 35 | Activity | `'Checking GSA Deployment logs are populated and reviewed'` | `'Verificando se os logs de implantação do GSA estão preenchidos e revisados'` |
| 38 | Status | `'Checking if Global Secure Access is enabled'` | `'Verificando se o Global Secure Access está habilitado'` |
| 56 | Status | `'Retrieving deployment logs'` | `'Recuperando logs de implantação'` |

### E4. Test Result Markdown strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 91 | Pass | `"GSA deployment logs are populated and recent deployments have succeeded.`n`n%TestResult%"` | `"Os logs de implantação do GSA estão preenchidos e as implantações recentes foram bem-sucedidas.`n`n%TestResult%"` |
| 95 | Fail | `"GSA deployment logs contain failed deployments that require investigation.`n`n%TestResult%"` | `"Os logs de implantação do GSA contêm implantações falhadas que requerem investigação.`n`n%TestResult%"` |

### E5. Markdown Section Headers
| Line | English | Portuguese |
|------|---------|-----------|
| 107 | `## [Deployment Logs]...` | `## [Logs de Implantação]...` |

---

## FILE 6: Test-Assessment.25480.ps1 - Quick Access Assignments

### F1. Title Attribute
**English:** `'Quick Access has user or group assignments'`  
**Portuguese:** `'Quick Access tem atribuições de usuário ou grupo'`  
**Location:** Line 24

### F2. Write-PSFMessage strings
| Line | English | Portuguese |
|------|---------|-----------|
| 31 | `'🟦 Start'` | `'🟦 Início'` |

### F3. Write-ZtProgress Activity/Status strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 32 | Activity | `'Checking Quick Access user and group assignments'` | `'Verificando atribuições de usuário e grupo do Quick Access'` |
| 33 | Status | `'Querying Quick Access application and assigned users/groups'` | `'Consultando aplicativo Quick Access e usuários/grupos atribuídos'` |

### F4. Test Result Markdown strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 50 | Investigate | `'⚠️ Quick Access application is not configured in the tenant. Customers should review the documentation on how to enable Quick Access.'` | `'⚠️ O aplicativo Quick Access não está configurado no locatário. Os clientes devem revisar a documentação sobre como habilitar o Quick Access.'` |
| 58 | Pass | `"✅ Quick Access application has users or groups assigned. `n`n%TestResult%"` | `"✅ O aplicativo Quick Access tem usuários ou grupos atribuídos. `n`n%TestResult%"` |
| 63 | Fail | `"❌ Quick Access application does not have user or group assignments. `n`n%TestResult%"` | `"❌ O aplicativo Quick Access não tem atribuições de usuário ou grupo. `n`n%TestResult%"` |

### F5. Markdown Section Headers
| Line | English | Portuguese |
|------|---------|-----------|
| 72+ | `## [Quick Access application assignments]...` | `## [Atribuições do aplicativo Quick Access]...` |

---

## FILE 7: Test-Assessment.25481.ps1 - Private Access Applications

### G1. Title Attribute
**English:** `'All Private Access apps have user or group assignments'`  
**Portuguese:** `'Todos os aplicativos Private Access têm atribuições de usuário ou grupo'`  
**Location:** Line 24

### G2. Write-PSFMessage strings
| Line | English | Portuguese |
|------|---------|-----------|
| 31 | `'🟦 Start'` | `'🟦 Início'` |

### G3. Write-ZtProgress Activity/Status strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 32 | Activity | `'Checking Private Access applications user and group assignments'` | `'Verificando atribuições de usuário e grupo dos aplicativos Private Access'` |
| 33 | Status | `'Querying all Private Access applications'` | `'Consultando todos os aplicativos Private Access'` |

### G4. Test Result Markdown strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 47 | Investigate | `'⚠️ No Private Access application is configured in the tenant, please review the documentation on how to enable Private Access applications.'` | `'⚠️ Nenhum aplicativo Private Access está configurado no locatário. Revise a documentação sobre como habilitar aplicativos Private Access.'` |
| 56 | Pass | `"✅ All Private Access applications have assigned users or groups. `n`n%TestResult%"` | `"✅ Todos os aplicativos Private Access têm usuários ou grupos atribuídos. `n`n%TestResult%"` |
| 60 | Fail | `"❌ Found Private Access applications without assigned users or groups. `n`n%TestResult%"` | `"❌ Encontrados aplicativos Private Access sem usuários ou grupos atribuídos. `n`n%TestResult%"` |

### G5. Markdown Section Headers
| Line | English | Portuguese |
|------|---------|-----------|
| 70+ | `## [Private Access applications]...` | `## [Aplicativos Private Access]...` |

---

## FILE 8: Test-Assessment.25533.ps1 - DDoS Protection

### H1. Title Attribute
**English:** `'DDoS Protection is enabled for all Public IP Addresses in VNETs'`  
**Portuguese:** `'A Proteção contra DDoS está habilitada para todos os Endereços IP Públicos em VNETs'`  
**Location:** Line 18

### H2. Write-PSFMessage strings
| Line | English | Portuguese |
|------|---------|-----------|
| 25 | `'🟦 Start'` | `'🟦 Início'` |
| 34 | `'Not connected to Azure.'` | `'Não conectado ao Azure.'` |
| 60 | `'No Public IP addresses found.'` | `'Nenhum endereço IP público encontrado.'` |
| 50 | `"ARG Query returned $($publicIps.Count) records"` | `"A consulta ARG retornou $($publicIps.Count) registros"` |
| 53 | `"Azure Resource Graph query failed: $($_.Exception.Message)"` | `"Falha na consulta do Gráfico de Recursos do Azure: $($_.Exception.Message)"` |
| 87 | `"NIC query: $($resourceVnetCache.Count) records in cache"` | `"Consulta NIC: $($resourceVnetCache.Count) registros em cache"` |
| 90 | `"Network Interface query failed: $($_.Exception.Message)"` | `"Falha na consulta de Interface de Rede: $($_.Exception.Message)"` |
| 107 | `"Application Gateway query: $($resourceVnetCache.Count) records in cache"` | `"Consulta de Gateway de Aplicativos: $($resourceVnetCache.Count) registros em cache"` |
| 110 | `"Application Gateway query failed: $($_.Exception.Message)"` | `"Falha na consulta de Gateway de Aplicativos: $($_.Exception.Message)"` |
| 127 | `"Azure Firewall query: $($resourceVnetCache.Count) records in cache"` | `"Consulta de Firewall do Azure: $($resourceVnetCache.Count) registros em cache"` |
| 130 | `"Azure Firewall query failed: $($_.Exception.Message)"` | `"Falha na consulta de Firewall do Azure: $($_.Exception.Message)"` |
| 147 | `"Bastion Host query: $($resourceVnetCache.Count) records in cache"` | `"Consulta de Host Bastion: $($resourceVnetCache.Count) registros em cache"` |
| 150 | `"Bastion Host query failed: $($_.Exception.Message)"` | `"Falha na consulta de Host Bastion: $($_.Exception.Message)"` |
| 167 | `"VNet Gateway query: $($resourceVnetCache.Count) records in cache"` | `"Consulta de Gateway de VNet: $($resourceVnetCache.Count) registros em cache"` |
| 170 | `"Virtual Network Gateway query failed: $($_.Exception.Message)"` | `"Falha na consulta de Gateway de Rede Virtual: $($_.Exception.Message)"` |
| 195 | `"Load Balancer query: $($resourceVnetCache.Count) records in cache"` | `"Consulta de Balanceador de Carga: $($resourceVnetCache.Count) registros em cache"` |
| 198 | `"Load Balancer query failed: $($_.Exception.Message)"` | `"Falha na consulta de Balanceador de Carga: $($_.Exception.Message)"` |
| 218 | `"VNET Query returned $($vnetDdosCache.Count) records"` | `"A consulta de VNET retornou $($vnetDdosCache.Count) registros"` |
| 221 | `"VNET DDoS query failed: $($_.Exception.Message)"` | `"Falha na consulta de DDoS de VNET: $($_.Exception.Message)"` |

### H3. Write-ZtProgress Activity/Status strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 27 | Activity | `'Checking DDoS Protection is enabled for all Public IP Addresses in VNETs'` | `'Verificando se a Proteção contra DDoS está habilitada para todos os Endereços IP Públicos em VNETs'` |
| 30 | Status | `'Checking Azure connection'` | `'Verificando conexão do Azure'` |
| 39 | Status | `'Querying Azure Resource Graph'` | `'Consultando Gráfico de Recursos do Azure'` |
| 69 | Status | `'Querying resource-to-VNET associations'` | `'Consultando associações de recurso a VNET'` |
| 203 | Status | `'Querying VNET DDoS settings'` | `'Consultando configurações de DDoS de VNET'` |

### H4. Test Result Markdown strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 339 | Pass | `"✅ DDoS Protection is enabled for all Public IP addresses, either through DDoS IP Protection enabled directly on the public IP or through DDoS Network Protection enabled on the associated VNET.`n`n%TestResult%"` | `"✅ A Proteção contra DDoS está habilitada para todos os endereços IP públicos, por meio de Proteção contra DDoS de IP habilitada diretamente no IP público ou de Proteção contra DDoS de Rede habilitada no VNET associado.`n`n%TestResult%"` |

### H5. Markdown Section Headers
| Line | English | Portuguese |
|------|---------|-----------|
| 361 | `'Public IP addresses DDoS protection status'` | `'Status de proteção contra DDoS dos endereços IP públicos'` |

---

## FILE 9: Test-Assessment.25535.ps1 - Firewall Routing

### I1. Title Attribute
**English:** `'Outbound traffic from VNET integrated workloads is routed through Azure Firewall'`  
**Portuguese:** `'O tráfego de saída de cargas de trabalho integradas de VNET é roteado através do Firewall do Azure'`  
**Location:** Line 20

### I2. Write-PSFMessage strings
| Line | English | Portuguese |
|------|---------|-----------|
| 38 | `"Unable to list Azure Firewalls in subscription $SubscriptionId."` | `"Não foi possível listar os Firewalls do Azure na assinatura $SubscriptionId."` |
| 97 | `"Unable to list network interfaces in subscription $($Subscription.Name)."` | `"Não foi possível listar os interfaces de rede na assinatura $($Subscription.Name)."` |
| 134 | `"Failed to initiate effectiveRouteTable request for NIC $($nic.name): $($_.Exception.Message)"` | `"Falha ao iniciar solicitação de effectiveRouteTable para NIC $($nic.name): $($_.Exception.Message)"` |
| 166 | `"Error polling operation for NIC $($op.Nic.name): $($_.Exception.Message)"` | `"Erro ao interrogar operação para NIC $($op.Nic.name): $($_.Exception.Message)"` |
| 178 | `"Timeout polling effectiveRouteTable operations. Processing $($pendingOperations.Count) incomplete operations."` | `"Tempo limite de interrogação das operações effectiveRouteTable. Processando $($pendingOperations.Count) operações incompletas."` |
| 183 | `"Polling $($pendingOperations.Count) pending operations..."` | `"Interrogando $($pendingOperations.Count) operações pendentes..."` |
| 264 | `'🟦 Start'` | `'🟦 Início'` |
| 267 | `"This test is only applicable to the Global environment."` | `"Este teste é aplicável apenas ao ambiente Global."` |
| 277 | `(Generic exception message)` | `(Generic exception message)` |
| 289 | `"Skipping subscription $($sub.Name) ($($sub.Id)): $($_.Exception.Message)"` | `"Pulando a assinatura $($sub.Name) ($($sub.Id)): $($_.Exception.Message)"` |
| 301 | `"Launched $($asyncOperations.Count) async effectiveRouteTable requests for subscription $($sub.Name)"` | `"Iniciadas $($asyncOperations.Count) solicitações effectiveRouteTable assíncronas para a assinatura $($sub.Name)"` |
| 315 | `"No workload NICs found to evaluate."` | `"Nenhuma NIC de carga de trabalho encontrada para avaliar."` |

### I3. Write-ZtProgress Activity/Status strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 28 | Activity | `'Checking Azure Firewall TLS Inspection configuration'` | `'Verificando configuração de Inspeção de TLS do Firewall do Azure'` |
| 32 | Status | `'Checking Azure connection'` | `'Verificando conexão do Azure'` |
| 42 | Status | `'Checking Azure environment'` | `'Verificando ambiente do Azure'` |

### I4. Test Result Markdown strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 322 | Pass | `"✅ Outbound traffic is routed through Azure Firewall.`n`n%TestResult%"` | `"✅ O tráfego de saída é roteado através do Firewall do Azure.`n`n%TestResult%"` |
| 326 | Fail | `"❌ Outbound traffic is not routed through Azure Firewall.`n`n%TestResult%"` | `"❌ O tráfego de saída não é roteado através do Firewall do Azure.`n`n%TestResult%"` |

---

## FILE 10: Test-Assessment.25537.ps1 - Threat Intelligence

### J1. Title Attribute
**English:** `'Threat intelligence is Enabled in Deny Mode on Azure Firewall'`  
**Portuguese:** `'A Inteligência de Ameaças está habilitada no Modo Negar no Firewall do Azure'`  
**Location:** Line 22

### J2. Write-PSFMessage strings
| Line | English | Portuguese |
|------|---------|-----------|
| 28 | `'🟦 Start'` | `'🟦 Início'` |
| 36 | `"This test is only applicable to the Global environment."` | `"Este teste é aplicável apenas ao ambiente Global."` |
| 45 | `(Generic exception message)` | `(Generic exception message)` |
| 49 | `"Azure authentication token not found."` | `"Token de autenticação do Azure não encontrado."` |
| 67 | `"ARG Query returned $($results.Count) records"` | `"A consulta ARG retornou $($results.Count) registros"` |
| 75 | `"Azure Resource Graph query failed: $($_.Exception.Message)"` | `"Falha na consulta do Gráfico de Recursos do Azure: $($_.Exception.Message)"` |
| 81 | `"No firewall policies found."` | `"Nenhuma política de firewall encontrada."` |

### J3. Write-ZtProgress Activity/Status strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 31 | Activity | `'Azure Firewall Threat Intelligence'` | `'Inteligência de Ameaças do Firewall do Azure'` |
| 32 | Status | `'Enumerating Firewall Policies'` | `'Enumerando Políticas de Firewall'` |
| 64 | Status | `"Querying Azure Resource Graph"` | `"Consultando Gráfico de Recursos do Azure"` |

### J4. Test Result Markdown strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 93 | Pass | `"Threat Intel is enabled in **Alert and Deny** mode.`n`n%TestResult%"` | `"A Inteligência de Ameaças está habilitada no modo **Alertar e Negar**.`n`n%TestResult%"` |
| 96 | Pass | `"Threat Intel is enabled in **Alert** mode.`n`n%TestResult%"` | `"A Inteligência de Ameaças está habilitada no modo **Alertar**.`n`n%TestResult%"` |
| 99 | Fail | `"Threat Intel is not enabled in **Alert and Deny** mode for all Firewall policies.`n`n%TestResult%"` | `"A Inteligência de Ameaças não está habilitada no modo **Alertar e Negar** para todas as políticas de firewall.`n`n%TestResult%"` |

### J5. Markdown Section Headers
| Line | English | Portuguese |
|------|---------|-----------|
| 104 | `"Firewall policies"` | `"Políticas de Firewall"` |

---

## FILE 11: Test-Assessment.25539.ps1 - IDPS Inspection

### K1. Title Attribute
**English:** `'IDPS Inspection is Enabled in Deny Mode on Azure Firewall'`  
**Portuguese:** `'A Inspeção de IDPS está habilitada no Modo Negar no Firewall do Azure'`  
**Location:** Line 23

### K2. Write-PSFMessage strings
| Line | English | Portuguese |
|------|---------|-----------|
| 29 | `'🟦 Start'` | `'🟦 Início'` |
| 40 | `'Not connected to Azure.'` | `'Não conectado ao Azure.'` |
| 48 | `'This test is only applicable to the AzureCloud environment.'` | `'Este teste é aplicável apenas ao ambiente AzureCloud.'` |
| 63 | `'The signed in user does not have access to check subscriptions.'` | `'O usuário conectado não tem acesso para verificar assinaturas.'` |
| 69 | `"Subscriptions request failed with status code $($subscriptionsResponse.StatusCode)"` | `"Falha na solicitação de assinaturas com código de status $($subscriptionsResponse.StatusCode)"` |
| 78 | `"Unable to enumerate subscriptions: $($_.Exception.Message)"` | `"Não foi possível enumerar as assinaturas: $($_.Exception.Message)"` |
| 92 | `"Unable to switch to subscription $($sub.displayName): $($_.Exception.Message)"` | `"Não foi possível alternar para a assinatura $($sub.displayName): $($_.Exception.Message)"` |
| 104 | `"Access denied to firewall policies in subscription $($sub.displayName): Insufficient permissions"` | `"Acesso negado às políticas de firewall na assinatura $($sub.displayName): Permissões insuficientes"` |
| 109 | `"Firewall policies request failed with status code $($policyResponse.StatusCode)"` | `"Falha na solicitação de políticas de firewall com código de status $($policyResponse.StatusCode)"` |
| 115 | `"No response content for policies in subscription $($sub.displayName)"` | `"Nenhum conteúdo de resposta para políticas na assinatura $($sub.displayName)"` |
| 122 | `"Unable to enumerate firewall policies in subscription $($sub.displayName): $($_.Exception.Message)"` | `"Não foi possível enumerar as políticas de firewall na assinatura $($sub.displayName): $($_.Exception.Message)"` |
| 136 | `"Access denied to firewall policy details in subscription $($sub.displayName): Insufficient permissions"` | `"Acesso negado aos detalhes da política de firewall na assinatura $($sub.displayName): Permissões insuficientes"` |
| 141 | `"Firewall policy details request failed with status code $($detailResponse.StatusCode)"` | `"Falha na solicitação de detalhes da política de firewall com código de status $($detailResponse.StatusCode)"` |
| 147 | `"No response content for policy $($policyResource.name) in subscription $($sub.displayName)"` | `"Nenhum conteúdo de resposta para a política $($policyResource.name) na assinatura $($sub.displayName)"` |
| 155 | `"Unable to get detailed policy information for $($policyResource.name) in subscription $($sub.displayName): $($_.Exception.Message)"` | `"Não foi possível obter informações de política detalhadas para $($policyResource.name) na assinatura $($sub.displayName): $($_.Exception.Message)"` |
| 164 | `"Firewall policy is missing required properties. Skipping."` | `"A política de firewall está faltando propriedades obrigatórias. Pulando."` |
| 170 | `"Firewall policy '$($policyResource.name)' does not have Premium SKU. Skipping."` | `"A política de firewall '$($policyResource.name)' não tem SKU Premium. Pulando."` |
| 205 | `'No Azure Firewall Premium policies found to evaluate.'` | `'Nenhuma política Azure Firewall Premium encontrada para avaliar.'` |

### K3. Write-ZtProgress Activity/Status strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 32 | Activity | `'Azure Firewall Intrusion Detection'` | `'Detecção de Intrusão do Firewall do Azure'` |
| 34-35 | Status | `'Checking Azure connection'` | `'Verificando conexão do Azure'` |
| 46 | Status | `'Checking Azure environment'` | `'Verificando ambiente do Azure'` |
| 53 | Status | `'Enumerating Firewall Policies'` | `'Enumerando Políticas de Firewall'` |
| 99 | Status | `"Enumerating policies in subscription $($sub.displayName)"` | `"Enumerando políticas na assinatura $($sub.displayName)"` |

### K4. Test Result Markdown strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 214 | Pass | `"Intrusion Detection System (IDPS) inspection is set to Deny for Azure Firewall policies.`n`n%TestResult%"` | `"A inspeção do Sistema de Detecção de Intrusão (IDPS) está definida como Negar para políticas de Firewall do Azure.`n`n%TestResult%"` |
| 217 | Fail | `"Intrusion Detection System (IDPS) inspection is not set to Deny for Azure Firewall policies.`n`n%TestResult%"` | `"A inspeção do Sistema de Detecção de Intrusão (IDPS) não está definida como Negar para políticas de Firewall do Azure.`n`n%TestResult%"` |

### K5. Markdown Section Headers
| Line | English | Portuguese |
|------|---------|-----------|
| 222 | `"Firewall policies"` | `"Políticas de Firewall"` |

---

## FILE 12: Test-Assessment.25550.ps1 - TLS Inspection

### L1. Title Attribute
**English:** `'Inspection of Outbound TLS Traffic is Enabled on Azure Firewall'`  
**Portuguese:** `'A Inspeção do Tráfego TLS de Saída está Habilitada no Firewall do Azure'`  
**Location:** Line 19

### L2. Write-PSFMessage strings
| Line | English | Portuguese |
|------|---------|-----------|
| 25 | `'🟦 Start Azure Firewall TLS Inspection evaluation'` | `'🟦 Avaliação de Inspeção de TLS do Firewall do Azure iniciada'` |
| 36 | `'Not connected to Azure.'` | `'Não conectado ao Azure.'` |
| 45 | `'This test is only applicable to the Global (AzureCloud) environment.'` | `'Este teste é aplicável apenas ao ambiente Global (AzureCloud).'` |
| 74 | `"ARG returned $($allPolicies.Count) firewall policy(ies)"` | `"ARG retornou $($allPolicies.Count) política(s) de firewall"` |
| 77 | `"Azure Resource Graph query failed: $($_.Exception.Message)"` | `"Falha na consulta do Gráfico de Recursos do Azure: $($_.Exception.Message)"` |
| 84 | `'No Azure Firewall policies found in any subscription.'` | `'Nenhuma política de Firewall do Azure encontrada em nenhuma assinatura.'` |
| 111 | `"ARG found $($tlsPolicyIds.Count) policy(ies) with TLS-enabled rules"` | `"ARG encontrou $($tlsPolicyIds.Count) política(s) com regras habilitadas para TLS"` |
| 114 | `"TLS rule query failed: $($_.Exception.Message)"` | `"Falha na consulta de regra TLS: $($_.Exception.Message)"` |
| 158 | `'All Premium firewall policies are not attached to any Azure Firewall.'` | `'Todas as políticas de firewall Premium não estão anexadas a nenhum Firewall do Azure.'` |

### L3. Write-ZtProgress Activity/Status strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 28 | Activity | `'Checking Azure Firewall TLS Inspection configuration'` | `'Verificando configuração de Inspeção de TLS do Firewall do Azure'` |
| 32 | Status | `'Checking Azure connection'` | `'Verificando conexão do Azure'` |
| 42 | Status | `'Checking Azure environment'` | `'Verificando ambiente do Azure'` |
| 51 | Status | `'Querying Azure Firewall policies via Resource Graph'` | `'Consultando políticas de Firewall do Azure via Gráfico de Recursos'` |
| 95 | Status | `'Checking application rules for TLS inspection'` | `'Verificando regras de aplicativos para inspeção de TLS'` |

### L4. Test Result Markdown strings
| Line | Type | English | Portuguese |
|------|------|---------|-----------|
| 154 | Fail | `"❌ TLS inspection is not properly configured on Azure Firewall. Either the global certificate authority is missing, or no application rules have TLS inspection enabled.`n`n"` | `"❌ A inspeção de TLS não está configurada adequadamente no Firewall do Azure. Ou a autoridade de certificação global está faltando, ou nenhuma regra de aplicativo tem inspeção de TLS habilitada.`n`n"` |
| 164 | Pass | `"✅ TLS inspection is enabled on Azure Firewall Premium. Global TLS certificate authority is configured and at least one application rule has TLS inspection enabled.`n`n%TestResult%"` | `"✅ A inspeção de TLS está habilitada no Azure Firewall Premium. A autoridade de certificação TLS global está configurada e pelo menos uma regra de aplicativo tem inspeção de TLS habilitada.`n`n%TestResult%"` |
| 167 | Fail | `"❌ TLS inspection is not properly configured on Azure Firewall. Either the global certificate authority is missing, or no application rules have TLS inspection enabled.`n`n%TestResult%"` | `"❌ A inspeção de TLS não está configurada adequadamente no Firewall do Azure. Ou a autoridade de certificação global está faltando, ou nenhuma regra de aplicativo tem inspeção de TLS habilitada.`n`n%TestResult%"` |

### L5. Markdown Section Headers
| Line | English | Portuguese |
|------|---------|-----------|
| 175 | `## Azure Firewall policies TLS inspection status` | `## Status de inspeção de TLS das políticas de Firewall do Azure` |

---

## Summary Statistics

- **Total files**: 12
- **Title attributes to translate**: 12
- **Write-PSFMessage strings**: ~80+
- **Write-ZtProgress strings**: ~50+
- **Test result markdown strings**: ~30+
- **Markdown section headers**: ~25+
- **Total translatable items**: ~195+

---

## Notes for Translation Operations

1. **Keep unchanged**:
   - Variable names: `$activity`, `$testResultMarkdown`, `$mdInfo`
   - API endpoints: `networkAccess/promptPolicies`, `/subscriptions/`, etc.
   - URLs: Portal links, Entra portal links
   - Enum values: `'enabled'`, `'disabled'`, `'beta'`
   - Product names: "AI Gateway", "Global Secure Access", "Azure Firewall"
   - Emoji symbols: 🟦, ✅, ❌, ⚠️
   - Special placeholders: `%TestResult%`

2. **Preserve formatting**:
   - Backticks in markdown
   - Line breaks: `\`n\`n`
   - Table formatting: `|`, `:---`
   - HTML comments in code

3. **All translations follow PT-BR (Brazilian Portuguese) conventions**
