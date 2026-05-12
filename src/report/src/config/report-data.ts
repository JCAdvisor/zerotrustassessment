// Use quicktype (Paste JSON as Code) VSCode extension to generate this typescript interface from ZeroTrustAssessmentReport.json created by PowerShell

export interface ZeroTrustAssessmentReport {
  ExecutedAt: string;
  TenantId: string;
  TenantName: string;
  Domain: string;
  Account: string;
  CurrentVersion: string;
  LatestVersion: string;
  IsDemo?: boolean;
  Tests: Test[];
  TenantInfo: TenantInfo | null;
  TestResultSummary: TestResultSummaryData;
  EndOfJson: string;
}

export interface TenantInfo {
  OverviewCaMfaAllUsers?: SankeyData | null;
  OverviewCaDevicesAllUsers?: SankeyData | null;
  OverviewAuthMethodsPrivilegedUsers?: SankeyData | null;
  OverviewAuthMethodsAllUsers?: SankeyData | null;
  ConfigWindowsEnrollment?: ConfigWindowsEnrollment[] | null;
  ConfigDeviceEnrollmentRestriction?: ConfigDeviceEnrollmentRestriction[] | null;
  ConfigDeviceCompliancePolicies?: ConfigDeviceCompliancePolicies[] | null;
  ConfigDeviceAppProtectionPolicies?: ConfigDeviceAppProtectionPolicies[] | null;
  DeviceOverview?: DeviceOverview | null;
  TenantOverview?: TenantOverview | null;
}

export interface ConfigWindowsEnrollment {
  Type: string | null;
  PolicyName: string | null;
  AppliesTo: string | null;
  Groups: string | null;
}

export interface ConfigDeviceEnrollmentRestriction {
  Platform: string | null;
  Priority: string | number | null;
  Name: string | null;
  MDM: string | null;
  MinVer: string | null;
  MaxVer: string | null;
  PersonallyOwned: string | null;
  BlockedManufacturers: string | null;
  Scope: string | null;
  AssignedTo: string | null;
}

export interface ConfigDeviceCompliancePolicies {
  Platform: string | null;
  PolicyName: string | null;
  DefenderForEndPoint: string | null;
  MinOsVersion: string | null;
  MaxOsVersion: string | null;
  RequirePswd: boolean | string | null;
  MinPswdLength: number | string | null;
  PasswordType: string | null;
  PswdExpiryDays: number | string | null;
  CountOfPreviousPswdToBlock: number | string | null;
  MaxInactivityMin: number | string | null;
  RequireEncryption: string | null;
  RootedJailbrokenDevices: string | null;
  MaxDeviceThreatLevel: string | null;
  RequireFirewall: string | null;
  ActionForNoncomplianceDaysPushNotification: number | string | null;
  ActionForNoncomplianceDaysSendEmail: number | string | null;
  ActionForNoncomplianceDaysRemoteLock: number | string | null;
  ActionForNoncomplianceDaysBlock: number | string | null;
  ActionForNoncomplianceDaysRetire: number | string | null;
  Scope: string | null;
  IncludedGroups: string | null;
  ExcludedGroups: string | null;
}

export interface ConfigDeviceAppProtectionPolicies {
  Platform: string | null;
  Name: string | string[] | null;
  AppsPublic: string | null;
  AppsCustom: string | null;
  BackupOrgDataToICloudOrGoogle: string | null;
  SendOrgDataToOtherApps: string | null;
  AppsToExempt: string | null;
  SaveCopiesOfOrgData: string | null;
  AllowUserToSaveCopiesToSelectedServices: string | null;
  DataProtectionTransferTelecommunicationDataTo: string | null;
  DataProtectionReceiveDataFromOtherApps: string | null;
  DataProtectionOpenDataIntoOrgDocuments: string | null;
  DataProtectionAllowUsersToOpenDataFromSelectedServices: string | null;
  DataProtectionRestrictCutCopyBetweenOtherApps: string | null;
  DataProtectionCutCopyCharacterLimitForAnyApp: string | null;
  DataProtectionEncryptOrgData: string | null;
  DataProtectionSyncPolicyManagedAppDataWithNativeApps: string | null;
  DataProtectionPrintingOrgData: string | null;
  DataProtectionRestrictWebContentTransferWithOtherApps: string | null;
  DataProtectionOrgDataNotifications: string | null;
  ConditionalLaunchAppMaxPinAttempts: string | null;
  ConditionalLaunchAppOfflineGracePeriodBlockAccess: string | null;
  ConditionalLaunchAppOfflineGracePeriodWipeData: string | null;
  ConditionalLaunchAppDisabedAccount: string | null;
  ConditionalLaunchAppMinAppVersion: string | null;
  ConditionalLaunchDeviceRootedJailbrokenDevices: string | null;
  ConditionalLaunchDevicePrimaryMtdService: string | null;
  ConditionalLaunchDeviceMaxAllowedDeviceThreatLevel: string | null;
  ConditionalLaunchDeviceMinOsVersion: string | null;
  ConditionalLaunchDeviceMaxOsVersion: string | null;
  Scope: string | null;
  IncludedGroups: string | null;
  ExcludedGroups: string | null;
}

export interface TestResultSummaryData {
  IdentityPassed: number;
  IdentityTotal: number;
  DevicesPassed: number;
  DevicesTotal: number;
  DataPassed?: number;
  DataTotal?: number;
  NetworkPassed?: number;
  NetworkTotal?: number;
}
export interface SankeyData {
  nodes: SankeyDataNode[];
  description: string;
  totalDevices?: number;
  entrareigstered?: number;
  entrahybridjoined?: number;
  entrajoined?: number;
}
export interface SankeyDataNode {
  value: number | null;
  source: string;
  target: string;
}

export interface TenantOverview {
  UserCount: number;
  GuestCount: number;
  GroupCount: number;
  ApplicationCount: number;
  DeviceCount: number;
  ManagedDeviceCount: number;
}
export interface DeviceOverview {
  DesktopDevicesSummary: SankeyData | null;
  MobileSummary: SankeyData | null;
  ManagedDevices: ManagedDevices | null;
  DeviceCompliance: DeviceCompliance | null;
  DeviceOwnership: DeviceOwnership | null;
}

export interface DeviceOwnership {
  corporateCount: number | null;
  personalCount: number | null;
}

export interface ManagedDevices {
  "@odata.context": string;
  id: string;
  totalCount: number | null;
  desktopCount: number;
  mobileCount: number;
  enrolledDeviceCount: number;
  mdmEnrolledCount: number;
  dualEnrolledDeviceCount: number;
  managedDeviceModelsAndManufacturers: object | null;
  lastModifiedDateTime: string;
  deviceOperatingSystemSummary: DeviceOperatingSystemSummary;
  deviceExchangeAccessStateSummary: DeviceExchangeAccessStateSummary;
}

export interface DeviceOperatingSystemSummary {
  androidCount: number;
  iosCount: number;
  macOSCount: number;
  windowsMobileCount: number;
  windowsCount: number;
  unknownCount: number;
  androidDedicatedCount: number;
  androidDeviceAdminCount: number;
  androidFullyManagedCount: number;
  androidWorkProfileCount: number;
  androidCorporateWorkProfileCount: number;
  configMgrDeviceCount: number;
  aospUserlessCount: number;
  aospUserAssociatedCount: number;
  linuxCount: number;
  chromeOSCount: number;
}

export interface DeviceExchangeAccessStateSummary {
  allowedDeviceCount: number;
  blockedDeviceCount: number;
  quarantinedDeviceCount: number;
  unknownDeviceCount: number;
  unavailableDeviceCount: number;
}

export interface DeviceCompliance {
  "@odata.context": string;
  inGracePeriodCount: number;
  configManagerCount: number;
  id: string;
  unknownDeviceCount: number;
  notApplicableDeviceCount: number;
  compliantDeviceCount: number;
  remediatedDeviceCount: number;
  nonCompliantDeviceCount: number;
  errorDeviceCount: number;
  conflictDeviceCount: number;
}

export interface Test {
  TestTitle: string;
  TestRisk: string;
  TestAppliesTo: string[] | null;
  TestImpact: string;
  TestCategory: string | null;
  TestImplementationCost: string;
  TestMinimumLicense?: string[] | string | null;
  TestSfiPillar: string | null;
  TestPillar: string | null;
  SkippedReason: string | null;
  TestResult: string;
  TestSkipped: string;
  TestStatus: string;
  TestTags: string[] | null;
  TestId: string | number;
  TestDescription: string;
}

export const reportData: ZeroTrustAssessmentReport = {
  "ExecutedAt": "2026-05-07T19:48:33.7848114-03:00",
  "TenantId": "9b9d2469-2044-4933-b7a1-357e41cabf70",
  "TenantName": "JC2Sec",
  "Domain": "jcadvisor.com.br",
  "Account": "temporariojc2sec@jcadvisor.com.br",
  "CurrentVersion": "2.1.8",
  "LatestVersion": "2.2.0",
  "TestResultSummary": {
    "IdentityPassed": 47,
    "IdentityTotal": 86,
    "DevicesPassed": 11,
    "DevicesTotal": 35,
    "NetworkPassed": 8,
    "NetworkTotal": 29,
    "DataPassed": 18,
    "DataTotal": 25
  },
  "Tests": [
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\n❌ **Falha**: Nenhuma política ativa restringindo o fluxo de código do dispositivo foi encontrada.\n\n## Políticas de Acesso Condicional\n\n\n",
      "TestDescription": "O fluxo de código do dispositivo (device code flow) é um fluxo de autenticação entre dispositivos projetado para aparelhos com restrição de entrada de dados. Ele pode ser explorado em ataques de phishing, onde um atacante inicia o fluxo e engana um usuário para completá-lo em seu próprio dispositivo, enviando assim os tokens do usuário para o invasor. Dados os riscos de segurança e o uso legítimo infrequente deste fluxo, você deve habilitar uma política de Acesso Condicional para bloqueá-lo por padrão.\n\n**Ação de remediação**\n\n- [Implantar uma política de Acesso Condicional para bloquear o fluxo de código do dispositivo](https://learn.microsoft.com/entra/identity/conditional-access/policy-block-authentication-flows?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#device-code-flow-policies).\n",
      "TestImplementationCost": "Low",
      "TestId": "21808",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Restringir o fluxo de código do dispositivo"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\nNenhuma política de atualização do iOS está configurada ou aplicada.\n\nNenhuma política de atualização do iOS encontrada neste locatário.\n",
      "TestDescription": "Se as políticas de atualização do iOS não forem configuradas e atribuídas, os agentes de ameaças podem explorar vulnerabilidades não corrigidas em sistemas operativos desatualizados em dispositivos geridos. A ausência de políticas de atualização aplicadas permite que os atacantes utilizem exploits conhecidos para obter acesso inicial, escalar privilégios e mover-se lateralmente dentro do ambiente. Sem atualizações atempadas, os dispositivos permanecem suscetíveis a exploits que já foram resolvidos pela Apple, permitindo que os agentes de ameaças contornem os controlos de segurança, instalem malware ou exfiltrem dados confidenciais. Esta cadeia de ataque começa com o comprometimento do dispositivo através de uma vulnerabilidade não corrigida, seguida de persistência e potencial violação de dados que impacta tanto a segurança organizacional como a postura de conformidade.\n\nA aplicação de políticas de atualização interrompe esta cadeia, garantindo que os dispositivos estejam consistentemente protegidos contra ameaças conhecidas.\n\n**Ação de correção**\n\nConfigure e atribua políticas de atualização do iOS/iPadOS no Intune para impor a correção atempada e reduzir o risco de vulnerabilidades não corrigidas:\n- [Gerir atualizações de software iOS/iPadOS no Intune](https://learn.microsoft.com/intune/intune-service/protect/software-updates-guide-ios-ipados?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)\n",
      "TestImplementationCost": "Low",
      "TestId": "24554",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Políticas de atualização para iOS/iPadOS são aplicadas para reduzir o risco de vulnerabilidades não corrigidas"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\n%TestResult%\n",
      "TestDescription": "Permitir colaboração externa irrestrita com organizações não verificadas pode aumentar a superfície de risco do tenant, pois permite contas de convidados (guests) que podem não ter controles de segurança adequados. Criminosos podem tentar obter acesso comprometendo identidades nesses tenants externos mal governados. Uma vez concedido o acesso de convidado, eles podem usar caminhos legítimos de colaboração para infiltrar recursos em seu tenant e tentar obter informações sensíveis.\n\nSem analisar a segurança das organizações com as quais você colabora, contas externas maliciosas podem persistir sem detecção e injetar cargas maliciosas. As configurações de acesso entre tenants (cross-tenant) para acesso de saída no Microsoft Entra oferecem a capacidade de bloquear a colaboração com organizações desconhecidas por padrão, reduzindo a superfície de ataque.\n\n**Ação de remediação**\n\n- [Visão geral do acesso entre tenants](https://learn.microsoft.com/entra/external-id/cross-tenant-access-overview?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Configurar definições de acesso entre tenants](https://learn.microsoft.com/entra/external-id/cross-tenant-access-settings-b2b-collaboration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#configure-default-settings)\n- [Modificar configurações de acesso de saída](https://learn.microsoft.com/entra/external-id/cross-tenant-access-settings-b2b-collaboration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "High",
      "TestId": "21790",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Configurações de acesso de saída entre tenants estão configuradas"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Acesso privilegiado",
      "SkippedReason": null,
      "TestResult": "\n❌ **Falha**: Usuários não privilegiados têm permissão para criar novos tenants.\n\n\n",
      "TestDescription": "Um atacante ou um funcionário bem-intencionado, mas desinformado, pode criar um novo tenant (tenant) do Microsoft Entra se não houver restrições em vigor. Por padrão, o usuário que cria um tenant recebe automaticamente a função de Administrador Global. Sem os controles adequados, essa ação fratura o perímetro de identidade ao criar um tenant fora da governança e visibilidade da organização. Isso introduz riscos por meio de uma plataforma de identidade paralela (shadow identity) que pode ser explorada para emissão de tokens, personificação de marca, phishing de consentimento ou infraestrutura de persistência. Como o tenant invasor pode não estar vinculado aos planos administrativos ou de monitoramento da empresa, as defesas tradicionais ficam cegas à sua criação, atividade e potencial uso indevido.\n\n**Ação de remediação**\n\nHabilite a configuração **Restringir usuários não administradores de criar tenants**. Para usuários que precisam da capacidade de criar tenants, atribua a eles a função de Criador de tenant (Tenant Creator). Você também pode revisar eventos de criação de tenants nos logs de auditoria do Microsoft Entra.\n\n- [Restringir as permissões padrão de usuários membros](https://learn.microsoft.com/entra/fundamentals/users-default-permissions?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#restrict-member-users-default-permissions)\n- [Atribuir a função de Criador de tenant](https://learn.microsoft.com/entra/identity/role-based-access-control/permissions-reference?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#tenant-creator)\n- [Revisar eventos de criação de tenant](https://learn.microsoft.com/entra/identity/monitoring-health/reference-audit-activities?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#core-directory). Procure por OperationName==\"Create Company\", Category == \"DirectoryManagement\".\n",
      "TestImplementationCost": "Medium",
      "TestId": "21787",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "As permissões para criar novos tenants são limitadas à função de Criador de tenant"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\n❌ **Falha**: Nenhuma política de Acesso Condicional ativa protegendo o registro de informações de segurança foi encontrada.\n\nNenhuma política de Acesso Condicional visando o registro de informações de segurança foi encontrada.\n\n",
      "TestDescription": "Sem políticas de Acesso Condicional protegendo o registro de informações de segurança, atacantes podem explorar fluxos de registro desprotegidos para comprometer métodos de autenticação. Quando os usuários registram métodos de MFA e redefinição de senha sem controles adequados, criminosos podem interceptar essas sessões por meio de ataques de adversário no meio (AiTM) ou explorar dispositivos não gerenciados acessando o registro de locais não confiáveis. Uma vez que os atacantes ganham acesso a um fluxo de registro desprotegido, eles podem registrar seus próprios métodos, sequestrando efetivamente o perfil de autenticação do alvo. Isso permite ignorar controles de segurança e escalar privilégios, mantendo acesso persistente.\n\n**Ação de remediação**\n\n- [Implantar uma política de Acesso Condicional para o registro de informações de segurança](https://learn.microsoft.com/entra/identity/conditional-access/policy-all-users-security-info-registration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Configurar locais de rede conhecidos](https://learn.microsoft.com/entra/identity/conditional-access/concept-assignment-network?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Habilitar o registro combinado de informações de segurança](https://learn.microsoft.com/entra/identity/authentication/howto-registration-mfa-sspr-combined?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21806",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Proteger a página de registro de MFA (Minhas Informações de Segurança)"
    },
    {
      "TestResult": "\n❌ A implantação do cliente do Global Secure Access é insuficiente ou não pode ser verificada. A cobertura de implantação está abaixo de 70%, nenhum dispositivo é detectado ou os serviços podem não estar no escopo deste ambiente.\n\n\n## [Resumo de implantação](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/AdminDashboard.ReactView)\n\n| Métrica | Valor |\n| :----- | ----: |\n| Total de dispositivos GSA | 0 |\n| Dispositivos ativos | 0 |\n| Dispositivos inativos | 0 |\n| Contagem total de dispositivos gerenciados | 91 |\n| Percentual de implantação | 0% |\n| Lacuna | 91 |\n| Período de avaliação | 2026-04-30 a 2026-05-07 |\n\n\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Failed",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access",
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "",
      "TestId": "25372",
      "TestTitle": "O cliente do Global Secure Access está implantado em todos os endpoints gerenciados",
      "TestDescription": "A implantação abrangente do cliente do Global Secure Access é fundamental para alcançar a segurança de rede Zero Trust. Se você não implantar o cliente do Global Secure Access nos endpoints gerenciados, esses dispositivos operam fora dos controles do Security Service Edge da organização. Atores de ameaça podem explorar endpoints desprotegidos para estabelecer acesso inicial, mover-se lateralmente ou exfiltrar dados sem acionar políticas de segurança em nível de rede.\n\nSem o cliente do Global Secure Access:\n\n- Os dispositivos não podem se beneficiar de verificações de rede compatíveis em políticas do Conditional Access, restauração de IP de origem ou restrições de locatário.\n- O roubo de credenciais e ataques de repetição de token são mais difíceis de detectar quando o tráfego contorna o perímetro de segurança.\n- Endpoints gerenciados não podem acessar aplicativos privados por meio do Microsoft Entra Private Access.\n\n**Ação de remediação**\n- Instalar o cliente do Global Secure Access:\n    - [Cliente Windows](https://learn.microsoft.com/entra/global-secure-access/how-to-install-windows-client?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n    - [Cliente macOS](https://learn.microsoft.com/entra/global-secure-access/how-to-install-macos-client?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n    - [Cliente iOS](https://learn.microsoft.com/entra/global-secure-access/how-to-install-ios-client?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n    - [Cliente Android](https://learn.microsoft.com/entra/global-secure-access/how-to-install-android-client?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- Monitore a integridade e o status de conexão do cliente do Global Secure Access usando o [painel do Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/concept-traffic-dashboard?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\nResultado da verificação de políticas de Acesso Condicional para funções privilegiadas.\n\n## Proteção de Funções Privilegiadas\n\n\n",
      "TestDescription": "Sem métodos de autenticação resistentes a phishing, os usuários privilegiados ficam mais vulneráveis a ataques de phishing. Esses tipos de ataques enganam os usuários para que revelem suas credenciais para conceder acesso não autorizado aos invasores. Se métodos de autenticação não resistentes a phishing forem usados, os atacantes podem interceptar credenciais e tokens, por meio de métodos como ataques de adversário no meio (AiTM), comprometendo a segurança da conta privilegiada.\n\nUma vez que uma conta ou sessão privilegiada é comprometida devido a métodos de autenticação fracos, os atacantes podem manipular a conta para manter o acesso a longo prazo, criar outros backdoors ou modificar permissões de usuário. Atacantes também podem usar a conta privilegiada comprometida para escalar seu acesso ainda mais, ganhando controle sobre sistemas mais sensíveis.\n\n**Ação de remediação**\n\n- [Comece com uma implantação de autenticação sem senha resistente a phishing](https://learn.microsoft.com/entra/identity/authentication/how-to-plan-prerequisites-phishing-resistant-passwordless-authentication?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Garanta que as contas privilegiadas registrem e usem métodos resistentes a phishing](https://learn.microsoft.com/entra/identity/authentication/concept-authentication-strengths?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#authentication-strengths)\n- [Implante uma política de Acesso Condicional para exigir credenciais resistentes a phishing para administradores](https://learn.microsoft.com/entra/identity/conditional-access/policy-admin-phish-resistant-mfa?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Monitore a atividade dos métodos de autenticação](https://learn.microsoft.com/entra/identity/monitoring-health/concept-usage-insights-report?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#authentication-methods-activity)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21783",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Funções integradas do Microsoft Entra são alvo de políticas de Acesso Condicional para exigir métodos resistentes a phishing"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": null,
      "TestResult": "\nO método de autenticação por Passkey não está ativado ou não está configurado para nenhum usuário em seu tenant.\n\n### Detalhes da Configuração de Passkey\n\n- **Status** : disabled\n- **Alvos incluídos** : All users\n- **Impor atestado** : True\n\n",
      "TestDescription": "Quando a autenticação por passkey não está ativada no Microsoft Entra ID, as organizações dependem de métodos de autenticação baseados em senha que são vulneráveis a phishing, roubo de credenciais e ataques de replay. Invasores podem usar senhas roubadas para obter acesso inicial, ignorar a autenticação multifator tradicional por meio de ataques Adversary-in-the-Middle (AiTM) e estabelecer acesso persistente por meio do roubo de tokens.\n\nAs passkeys fornecem autenticação resistente a phishing usando prova criptográfica que os invasores não podem pescar, interceptar ou replicar. Ativar passkeys elimina a vulnerabilidade fundamental que permite cadeias de ataque baseadas em credenciais.\n\n**Ação de correção**\n\n- Saiba como [ativar o método de autenticação por passkey](https://learn.microsoft.com/entra/identity/authentication/how-to-enable-passkey-fido2?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enable-passkey-fido2-authentication-method).\n- Saiba como [planejar uma implantação de autenticação sem senha resistente a phishing](https://learn.microsoft.com/entra/identity/authentication/how-to-plan-prerequisites-phishing-resistant-passwordless-authentication?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "TestImplementationCost": "Medium",
      "TestId": "21839",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Método de autenticação por Passkey ativado"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\n❌ O LAPS para macOS não está configurado em nenhum perfil de registro.\n\n",
      "TestDescription": "Sem a aplicação de políticas de LAPS para macOS durante o Registro Automatizado de Dispositivos (ADE), os agentes de ameaças podem explorar senhas de administrador local estáticas ou reutilizadas para escalar privilégios, mover-se lateralmente e estabelecer persistência. Dispositivos provisionados sem credenciais aleatórias são vulneráveis à colheita de credenciais e reutilização em múltiplos endpoints, aumentando o risco de comprometimento de todo o domínio.\n\nA aplicação do LAPS para macOS garante que cada dispositivo seja provisionado com uma senha de administrador local única e criptografada, gerenciada pelo Intune. Isso interrompe a cadeia de ataque nas fases de acesso a credenciais e movimento lateral, reduzindo significativamente o risco de comprometimento generalizado e alinhando-se aos princípios de Zero Trust de privilégio mínimo e higiene de credenciais.\n\n**Ação de correção**\n\nUse o Intune para configurar perfis de ADE para macOS que provisionem uma conta de administrador local com uma senha aleatória e criptografada, e que permitam a rotação segura:\n- [Configurar LAPS para macOS no Microsoft Intune](https://learn.microsoft.com/intune/intune-service/enrollment/macos-laps?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Rotacionar senha de administrador local (macOS)](https://learn.microsoft.com/intune/intune-service/remote-actions/device-rotate-local-admin-password?pivots=macos&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n\nPara mais informações, consulte:\n- [Guia de configuração de ADE para macOS](https://learn.microsoft.com/intune/intune-service/enrollment/device-enrollment-program-enroll-macos?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24561",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Credenciais de administrador local no macOS são protegidas durante o registro pelo LAPS para macOS"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Dados",
      "SkippedReason": null,
      "TestResult": "\nNenhuma política de Acesso Condicional com conformidade de dispositivo existe para uma ou mais plataformas, e nenhuma política se aplica a todas as plataformas.\n\n\n",
      "TestDescription": "Se as políticas do Microsoft Entra Conditional Access não exigirem conformidade de dispositivo, os usuários podem se conectar a recursos corporativos a partir de dispositivos que não atendem aos padrões de segurança. Isso expõe dados sensíveis a riscos como malware, acesso não autorizado e não conformidade regulatória. Sem controles como aplicação de criptografia, verificações de integridade do dispositivo e restrições de acesso, agentes de ameaça podem explorar dispositivos não conformes para contornar medidas de segurança e manter persistência.\n\n\nExigir conformidade de dispositivo nas políticas de Conditional Access garante que apenas dispositivos confiáveis e seguros possam acessar recursos corporativos. Isso apoia o Zero Trust ao aplicar decisões de acesso com base na saúde do dispositivo e na postura de conformidade.\n\n**Ação de remediação**\n\nConfigure políticas de Conditional Access no Microsoft Entra para exigir conformidade de dispositivo antes de conceder acesso a recursos corporativos:  \n- [Criar uma política de Conditional Access baseada em conformidade de dispositivo](https://learn.microsoft.com/intune/intune-service/protect/create-conditional-access-intune?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n\nPara mais informações, veja:\n- [O que é Conditional Access?](https://learn.microsoft.com/entra/identity/conditional-access/overview?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Integrar resultados de conformidade de dispositivo ao Conditional Access](https://learn.microsoft.com/intune/intune-service/protect/device-compliance-get-started?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#integrate-with-conditional-access)\n",
      "TestImplementationCost": "Low",
      "TestId": "24824",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Políticas de Acesso Condicional bloqueiam acesso de dispositivos não conformes"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\nNenhuma política de atualização do macOS foi criada, ou as políticas criadas não estão atribuídas.\n\nNenhuma política de atualização do macOS encontrada neste locatário.\n\n",
      "TestDescription": "Se as políticas de atualização do macOS não estiverem devidamente configuradas e atribuídas, agentes de ameaça podem explorar vulnerabilidades não corrigidas em dispositivos macOS dentro da organização. Sem políticas de atualização impostas, os dispositivos permanecem em versões de software desatualizadas, aumentando a superfície de ataque para escalação de privilégios, execução remota de código ou técnicas de persistência. Agentes de ameaça podem aproveitar essas fraquezas para obter acesso inicial, escalar privilégios e se mover lateralmente no ambiente. Se as políticas existirem mas não forem atribuídas a grupos de dispositivos, os endpoints permanecerão desprotegidos e as lacunas de conformidade passarão despercebidas. Isso pode resultar em comprometimento generalizado, exfiltração de dados e interrupção operacional.\n\nA aplicação de políticas de atualização do macOS garante que os dispositivos recebam patches oportunos, reduzindo o risco de exploração e apoiando o Zero Trust ao manter uma frota de dispositivos segura e em conformidade.\n\n**Ação de remediação**\n\nConfigure e atribua políticas de atualização do macOS no Intune para aplicar patches oportunos e reduzir o risco de vulnerabilidades não corrigidas:  \n- [Gerenciar atualizações de software do macOS no Intune](https://learn.microsoft.com/intune/intune-service/protect/software-updates-macos?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24690",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "As políticas de atualização do macOS são impostas para reduzir o risco de vulnerabilidades não corrigidas"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Dados",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma política de proteção de aplicativos para Android foi encontrada ou nenhuma está atribuída.\n\n",
      "TestDescription": "Sem políticas de proteção de aplicativos, os dados corporativos acedidos em dispositivos Android são vulneráveis a fugas através de aplicações não geridas ou maliciosas. Os utilizadores podem copiar involuntariamente informações confidenciais para aplicações pessoais, armazenar dados de forma insegura ou contornar controlos de autenticação. Este risco é ampliado em dispositivos que não são totalmente geridos, onde os contextos corporativo e pessoal coexistem, aumentando a probabilidade de exfiltração de dados ou acesso não autorizado.\n\nA aplicação de políticas de proteção de aplicativos garante que os dados corporativos sejam apenas acedidos através de aplicações fidedignas e permaneçam protegidos mesmo em dispositivos Android pessoais ou BYOD.\n\nEstas políticas aplicam criptografia, restringem a partilha de dados e exigem autenticação, reduzindo o risco de fuga de dados e alinhando-se com os princípios Zero Trust de proteção de dados e Acesso Condicional.\n\n**Ação de correção**\n\nImplemente políticas de proteção de aplicativos do Intune que criptografem dados, restrinjam a partilha e exijam autenticação em aplicações Android aprovadas:\n- [Implementar políticas de proteção de aplicativos do Intune](https://learn.microsoft.com/intune/intune-service/apps/app-protection-policies?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-an-iosipados-or-android-app-protection-policy)\n- [Rever a referência de configurações de proteção de aplicativos Android](https://learn.microsoft.com/intune/intune-service/apps/app-protection-policy-settings-android?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n\nPara mais informações, veja:\n- [Saiba mais sobre a utilização de políticas de proteção de aplicativos](https://learn.microsoft.com/intune/intune-service/apps/app-protection-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24549",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "High",
      "TestRisk": "High",
      "TestTitle": "Dados no Android estão protegidos por políticas de proteção de aplicativos"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Dados",
      "SkippedReason": null,
      "TestResult": "\nNenhum perfil de Wi-Fi Empresarial para macOS existe ou nenhum está atribuído.\n\n\n",
      "TestDescription": "Se os perfis de Wi-Fi não estiverem devidamente configurados e atribuídos, dispositivos macOS podem falhar ao se conectar a redes seguras ou se conectar de forma insegura, expondo dados corporativos à interceptação ou acesso não autorizado. Sem gerenciamento centralizado, os dispositivos dependem de configuração manual, aumentando o risco de má configuração, autenticação fraca e conexão a redes maliciosas. Essas lacunas podem levar à interceptação de dados, acesso de rede não autorizado e violações de conformidade.\n\nGerenciar centralmente perfis de Wi-Fi para dispositivos macOS no Intune garante conectividade segura e consistente com redes empresariais. Isso aplica padrões de autenticação e criptografia, simplifica a integração e apoia o Zero Trust ao reduzir a exposição a redes não confiáveis.\n\n**Ação de remediação**\n\nUse o Intune para configurar e atribuir perfis de Wi-Fi seguros para dispositivos macOS, a fim de aplicar padrões de autenticação e criptografia:\n\n- [Configurar as configurações de Wi-Fi para dispositivos macOS no Intune](https://learn.microsoft.com/intune/intune-service/configuration/wi-fi-settings-configure?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-the-profile)\n\nPara mais informações, veja:\n\n- [Revisar as configurações de Wi-Fi disponíveis para dispositivos macOS no Microsoft Intune](https://learn.microsoft.com/intune/intune-service/configuration/wi-fi-settings-macos?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24870",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Perfis de Wi-Fi seguros protegem dispositivos macOS contra acesso de rede não autorizado"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\nNenhuma política relevante do Defender Antivirus está configurada ou atribuída para macOS.\n\n\n",
      "TestDescription": "Se as políticas do Microsoft Defender Antivirus não estiverem devidamente configuradas e atribuídas a dispositivos macOS no Intune, atacantes podem explorar endpoints desprotegidos para executar malware, desabilitar proteções de antivírus e persistir no ambiente. Sem políticas aplicadas, os dispositivos executam definições desatualizadas, não têm proteção em tempo real ou têm agendas de verificação mal configuradas, aumentando o risco de ameaças não detectadas e escalada de privilégios. Isso permite movimento lateral na rede, roubo de credenciais e exfiltração de dados. A ausência de aplicação do antivírus compromete a conformidade dos dispositivos, aumenta a exposição a ameaças de dia zero e pode resultar em não conformidade regulatória. Atacantes usam essas lacunas para manter persistência e evitar detecção, especialmente em ambientes sem aplicação centralizada de políticas.\n\nA aplicação de políticas do Defender Antivirus garante que os dispositivos macOS sejam consistentemente protegidos contra malware, suporta a detecção de ameaças em tempo real e alinha-se ao Zero Trust ao manter uma postura de endpoint segura e em conformidade.\n\n**Ação de remediação**\n\nUse o Intune para configurar e atribuir políticas do Microsoft Defender Antivirus para dispositivos macOS a fim de aplicar proteção em tempo real, manter definições atualizadas e reduzir a exposição a malware:  \n- [Configurar políticas do Intune para gerenciar o Microsoft Defender Antivirus](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-antivirus-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#macos)\n- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)\n",
      "TestImplementationCost": "Low",
      "TestId": "24784",
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Políticas do Defender Antivirus protegem dispositivos macOS contra malware"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\nURIs de redirecionamento inseguros encontrados\n\n1️⃣ → Uso de http(s) em vez de https, 2️⃣ → Uso de *.azurewebsites.net, 3️⃣ → URL inválido, 4️⃣ → Domínio não resolvido\n\n| | Nome | URIs de redirecionamento inseguros |\n| :--- | :--- | :--- |\n|  | [3CX Phone System](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/SignOn/objectId/725b22c1-3198-49fa-b0a6-e928d57541b8/appId/84047e82-3acb-4aab-a81f-ad7b0c18500e/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/) | `4️⃣ https://jc2sec.my3cx.com.br/oauth2office2`, `4️⃣ https://jc2sec.my3cx.com.br/oauth2presence`, `4️⃣ https://jc2sec.my3cx.com.br/`, `4️⃣ https://jc2sec.my3cx.com.br/webclient` |  |\n|  | [SharePoint Online Client Extensibility Web Application Principal](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/SignOn/objectId/dc84cd3d-b80a-47c6-a5fa-af52ca3800c1/appId/313ff249-6744-4b00-b8f1-9d1d361d328e/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/) | `4️⃣ https://dev.fluidpreview.office.net/spfxsinglesignon` |  |\n|  | [aad-extensions-app. Do not modify. Used by AAD for storing user data.](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/SignOn/objectId/dc1d02ba-d1c7-47cf-bb04-282d1c941778/appId/a7ab1826-836a-4c16-93a3-9a14329cc013/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/) | `4️⃣ https://segjcadvisor.onmicrosoft.com/cpimextensions` |  |\n|  | [pam360](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/SignOn/objectId/623159bd-a3c1-4f17-8371-d22b0bb385f8/appId/ed7a98c8-d203-4f84-945c-021f4ff76e2d/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/) | `4️⃣ https://pam360.jcadvisor.com.br/`, `4️⃣ https://pam360.jcadvisor.com.br/pam360redirect/AzureOAuth` |  |\n|  | [webviewer-powerbi](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/SignOn/objectId/55d3edcd-5021-41a4-818c-8a2080384b43/appId/0f38d262-a372-4a0a-af1e-92b2b338fafb/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/) | `4️⃣ https://webview.riskargus.com.br` |  |\n\n",
      "TestDescription": "URIs de redirecionamento não mantidas ou órfãs em registros de aplicativos criam vulnerabilidades de segurança significativas quando referenciam domínios que não apontam mais para recursos ativos. Atores de ameaças podem explorar essas entradas de DNS \"pendentes\" (dangling) ao provisionar recursos em domínios abandonados, assumindo efetivamente o controle dos endpoints de redirecionamento. Essa vulnerabilidade permite que invasores interceptem tokens de autenticação e credenciais durante os fluxos do OAuth 2.0, o que pode levar ao acesso não autorizado, sequestro de sessão e potencial comprometimento organizacional mais amplo.\n\n**Ação de correção**\n\n- [Visão geral e restrições de URI de redirecionamento (reply URL)](https://learn.microsoft.com/entra/identity-platform/reply-url?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21888",
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Registros de aplicativos não devem ter URIs de redirecionamento de domínios pendentes ou abandonados"
    },
    {
      "TestResult": "\n❌ O encaminhamento de tráfego do Microsoft 365 está desabilitado ou nenhum tráfego do Microsoft 365 está sendo roteado pelo Global Secure Access.\n\n\n## Resumo\n\n| Métrica | Valor |\n| :--- | ---: |\n| Perfil habilitado | ✅ Sim |\n| Transações do M365 (7 dias) | 0 |\n| Transações bloqueadas do M365 | 0 |\n| Dispositivos ativos | 0 |\n| Dispositivos totais | 0 |\n\n\n## Perfil de encaminhamento de tráfego\n\n| Propriedade | Valor |\n| :--- | :--- |\n| Nome do perfil | Microsoft 365 traffic forwarding profile |\n| Estado | enabled |\n| Tipo de tráfego | m365 |\n\n\n## Resumo de transações\n\n| Tipo de tráfego | Total | Bloqueado |\n| :--- | ---: | ---: |\n| - | Nenhum dado disponível | - |\n\n*Período de Avaliação: 2026-04-30 a 2026-05-07*\n\n\n## Uso de Dispositivos\n\n| Métrica | Contagem |\n| :--- | ---: |\n| Total de dispositivos | 0 |\n| Dispositivos ativos | 0 |\n| Dispositivos inativos | 0 |\n\n\n[Ver no portal do Entra: encaminhamento de tráfego](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/ForwardingProfile.ReactView)\r\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Failed",
      "TestRisk": "High",
      "TestCategory": "Segurança de rede",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access",
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "",
      "TestId": "25376",
      "TestTitle": "O tráfego do Microsoft 365 está fluindo ativamente pelo Global Secure Access",
      "TestDescription": "Quando o tráfego do Microsoft 365 contorna o Global Secure Access, as organizações perdem visibilidade e controle sobre suas cargas de trabalho de produtividade mais críticas. Agentes de ameaça que exploram conexões não monitoradas do Microsoft 365 podem exfiltrar dados confidenciais pelo SharePoint, OneDrive ou Exchange sem acionar políticas de segurança ou gerar telemetria acionável. O roubo de tokens e ataques de repetição tornam-se mais difíceis de detectar quando o tráfego não flui pelo Security Service Edge, pois a correlação de IP de origem com logs de entrada e a avaliação de Conditional Access não podem ser aplicadas de forma consistente.\n\nOrganizações com tráfego significativamente contornado, seja devido à implantação incompleta do cliente, perfis de encaminhamento mal configurados ou usuários em dispositivos não gerenciados, criam pontos cegos onde ataques man-in-the-middle, captura de credenciais e transferências não autorizadas de dados podem ocorrer sem detecção. O tráfego que contorna o Global Secure Access também não pode se beneficiar de verificações de rede compatíveis em políticas de Conditional Access, restrições de locatário ou restauração de IP de origem, deixando controles de segurança significativos ineficazes.\n\n**Ação de remediação**\n- Habilite o perfil de tráfego do Microsoft. Para mais informações, veja [Habilitar perfil de tráfego Microsoft](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-microsoft-profile?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Implante o cliente Global Secure Access em todos os dispositivos gerenciados. Para mais informações, veja [Implantar o cliente Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/how-to-install-windows-client?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Revise e configure as regras de encaminhamento de tráfego conforme necessário. Para mais informações, veja [Revisar regras de encaminhamento de tráfego](https://learn.microsoft.com/entra/global-secure-access/concept-microsoft-traffic-profile?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma política de conformidade para iOS/iPadOS foi encontrada ou nenhuma está atribuída.\n\n\n",
      "TestDescription": "Se as políticas de conformidade não estiverem atribuídas a dispositivos iOS/iPadOS no Intune, os agentes de ameaças podem explorar endpoints não conformes para obter acesso não autorizado a recursos corporativos, burlar controles de segurança e estabelecer persistência no ambiente. Sem a conformidade aplicada, os dispositivos podem carecer de configurações críticas de segurança, como requisitos de código de acesso e controles de versão do SO. Essas lacunas aumentam o risco de vazamento de dados, escalonamento de privilégios e movimentação lateral. A conformidade inconsistente dos dispositivos enfraquece a postura de segurança da organização e torna mais difícil detectar e remediar ameaças antes que ocorram danos significativos.\n\nA aplicação de políticas de conformidade garante que os dispositivos iOS/iPadOS atendam aos requisitos básicos de segurança e apoia o modelo Zero Trust, validando a integridade do dispositivo e reduzindo a exposição a endpoints mal configurados ou não gerenciados.\n\n**Ação de correção**\n\nCrie e atribua políticas de conformidade do Intune para dispositivos iOS/iPadOS para aplicar os padrões organizacionais de acesso e gerenciamento seguros:\n- [Criar uma política de conformidade no Microsoft Intune](https://learn.microsoft.com/intune/intune-service/protect/create-compliance-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-the-policy)\n- [Revisar as configurações de conformidade do iOS/iPadOS que você pode gerenciar com o Intune](https://learn.microsoft.com/intune/intune-service/protect/compliance-policy-create-ios?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24543",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Políticas de conformidade protegem dispositivos iOS/iPadOS"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Dados",
      "SkippedReason": null,
      "TestResult": "\nNenhum perfil de Wi-Fi Empresarial para Android existe ou nenhum está atribuído.\n\n\n",
      "TestDescription": "Se os perfis de Wi-Fi não estiverem devidamente configurados e atribuídos, dispositivos Android podem falhar ao se conectar a redes seguras ou se conectar de forma insegura, expondo dados corporativos à interceptação ou acesso não autorizado. Sem gerenciamento centralizado, os dispositivos dependem de configuração manual, aumentando o risco de má configuração, autenticação fraca e conexão a redes maliciosas.\n\nGerenciar centralmente perfis de Wi-Fi para dispositivos Android no Intune garante conectividade segura e consistente com redes empresariais. Isso aplica padrões de autenticação e criptografia, simplifica a integração e apoia o Zero Trust ao reduzir a exposição a redes não confiáveis.\n\n\n\nUse o Intune para configurar perfis de Wi-Fi seguros que apliquem padrões de autenticação e criptografia.\n\n**Ação de remediação**\n\nUse o Intune para configurar e atribuir perfis de Wi-Fi seguros para dispositivos Android, a fim de aplicar padrões de autenticação e criptografia:  \n- [Implantar perfis de Wi-Fi em dispositivos no Microsoft Intune](https://learn.microsoft.com/intune/intune-service/configuration/wi-fi-settings-configure?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-the-profile)\n\nPara mais informações, veja:  \n- [Revisar as configurações de Wi-Fi disponíveis para dispositivos Android no Microsoft Intune](https://learn.microsoft.com/intune/intune-service/configuration/wi-fi-settings-android-enterprise?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24840",
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Perfis de Wi-Fi seguros protegem dispositivos Android contra acesso de rede não autorizado"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Dados",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma política de proteção de aplicativos para iOS foi encontrada ou nenhuma está atribuída.\n\n",
      "TestDescription": "Sem políticas de proteção de aplicativos, os dados corporativos acedidos em dispositivos iOS/iPadOS são vulneráveis a fugas através de aplicações não geridas ou pessoais. Os utilizadores podem copiar involuntariamente informações confidenciais para aplicações não seguras, armazenar dados fora dos limites corporativos ou contornar controlos de autenticação. Este risco é especialmente elevado em dispositivos BYOD, onde os contextos pessoal e de trabalho coexistem, aumentando a probabilidade de exfiltração de dados ou acesso não autorizado.\n\nAs políticas de proteção de aplicativos garantem que os dados corporativos permaneçam seguros em aplicações aprovadas, mesmo em dispositivos pessoais. Estas políticas aplicam criptografia, restringem a partilha de dados e exigem autenticação, reduzindo o risco de fuga de dados e alinhando-se com os princípios Zero Trust de proteção de dados e Acesso Condicional.\n \n**Ação de correção**\n\nImplemente políticas de proteção de aplicativos do Intune que criptografem dados corporativos, restrinjam a partilha e exijam autenticação em aplicações iOS/iPadOS aprovadas:\n- [Implementar políticas de proteção de aplicativos do Intune](https://learn.microsoft.com/intune/intune-service/apps/app-protection-policies?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-an-iosipados-or-android-app-protection-policy)\n- [Rever a referência de configurações de proteção de aplicativos iOS](https://learn.microsoft.com/intune/intune-service/apps/app-protection-policy-settings-ios?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n\nPara mais informações, veja:\n- [Saiba mais sobre a utilização de políticas de proteção de aplicativos](https://learn.microsoft.com/intune/intune-service/apps/app-protection-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24548",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "High",
      "TestRisk": "High",
      "TestTitle": "Dados no iOS/iPadOS estão protegidos por políticas de proteção de aplicativos"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma política de configuração do Firewall do Windows encontrada neste tenant.\n",
      "TestDescription": "Se as políticas para o Firewall do Windows não estiverem configuradas e atribuídas, os agentes de ameaças podem explorar endpoints desprotegidos para obter acesso não autorizado, mover-se lateralmente e escalar privilégios no ambiente. Sem regras de firewall aplicadas, os invasores podem burlar a segmentação de rede, exfiltrar dados ou implantar malware, aumentando o risco de comprometimento generalizado.\n\nA aplicação de políticas do Firewall do Windows garante a aplicação consistente de controles de tráfego de entrada e saída, reduzindo a exposição ao acesso não autorizado e apoiando o Zero Trust por meio da segmentação de rede e proteção no nível do dispositivo.\n\n**Ação de correção**\n\nConfigure e atribua políticas de firewall para Windows no Intune para bloquear tráfego não autorizado e aplicar proteções de rede consistentes em todos os dispositivos gerenciados:\n\n- [Configurar políticas de firewall para dispositivos Windows](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-firewall-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci). O Intune usa dois perfis complementares para gerenciar as configurações de firewall:\n  - **Firewall do Windows** - Use este perfil para configurar o comportamento geral do firewall com base no tipo de rede.\n  - **Regras do Firewall do Windows** - Use este perfil para definir regras de tráfego para aplicativos, portas ou IPs, adaptadas a grupos ou cargas de trabalho específicos. Este perfil do Intune também oferece suporte ao uso de [grupos de configurações reutilizáveis](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-firewall-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#add-reusable-settings-groups-to-profiles-for-firewall-rules) para ajudar a simplificar o gerenciamento de configurações comuns que você usa para diferentes instâncias de perfil.\n- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)\n\nPara mais informações, consulte:\n- [Configurações disponíveis do Firewall do Windows](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-firewall-profile-settings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#windows-firewall-profile)\n",
      "TestImplementationCost": "Low",
      "TestId": "24540",
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Políticas do Firewall do Windows protegem contra acesso não autorizado à rede"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": null,
      "TestResult": "\n❌ O registro combinado não está habilitado ou a migração está pendente.\n\n\n",
      "TestDescription": "As políticas legadas de MFA e redefinição de senha (SSPR) no Microsoft Entra ID gerenciam métodos separadamente, levando a configurações fragmentadas e experiência do usuário subótima. Além disso, gerenciar essas políticas de forma independente aumenta a carga administrativa e o risco de configuração incorreta.\n\nA migração para a política de Métodos de Autenticação combinada consolida o gerenciamento de MFA, SSPR e métodos sem senha em uma estrutura única. Isso permite um controle mais granular e suporte a métodos modernos como FIDO2 e Windows Hello for Business. A Microsoft definiu a aposentadoria das políticas legadas para 30 de setembro de 2025.\n\n**Ação de remediação**\n\n- [Habilitar o registro de informações de segurança combinado](https://learn.microsoft.com/entra/identity/authentication/howto-registration-mfa-sspr-combined?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Como migrar configurações para a política de métodos de autenticação](https://learn.microsoft.com/entra/identity/authentication/how-to-authentication-methods-manage?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21803",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Migrar das políticas legadas de MFA e SSPR"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\nEncontrados 2 aplicativos e 3 entidades de serviço em seu tenant com certificados que não foram rotacionados nos últimos 180 dias.\n\n\n## Aplicativos com certificados que não foram rotacionados nos últimos 180 dias\n\n| Aplicativo | Data de Início do Certificado |\n| :--- | :--- |\n| [3CX Phone System](https://entra.microsoft.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Credentials/appId/84047e82-3acb-4aab-a81f-ad7b0c18500e) | 2025-01-08 |\n| [Application to manage WDATP TVM Network scan agent - ac05a3be42f5b677f0593d34f07ac01e05db84f0](https://entra.microsoft.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Credentials/appId/a7985929-9f79-4909-8bf0-4b488cf3d5b0) | 2025-05-16 |\n\n\n## Entidades de serviço com certificados que não foram rotacionados nos últimos 180 dias\n\n| Entidade de serviço | tenant proprietário | Data de Início do Certificado |\n| :--- | :--- | :--- |\n| [Key Cloak](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/SignOn/objectId/87e10597-c491-4802-967c-fd2bd7792adc/appId/3d2e56a5-7c93-4f98-98dd-3d0bb09fca17/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/) |  | 2025-09-16 |\n| [P2P Server](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/SignOn/objectId/927d089e-02d2-4459-a10b-564d9e0c58a8/appId/ec9962e3-5170-42a2-a042-bf348b84df9b/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/) |  | 2025-06-10 |\n| [automation-cond-access](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/SignOn/objectId/04c5049c-baa7-49bc-9492-257b88eda448/appId/9910ae44-77a0-4edf-b6ea-e4ffc63dab8b/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/) |  | 2025-04-17 |\n",
      "TestDescription": "Se os certificados não forem rotacionados regularmente, eles podem dar aos agentes de ameaças uma janela estendida para extraí-los e explorá-los, levando ao acesso não autorizado. Quando credenciais como essas são expostas, os atacantes podem misturar suas atividades maliciosas com operações legítimas, facilitando a evasão de controles de segurança. Se um atacante comprometer o certificado de um aplicativo, ele poderá escalar seus privilégios dentro do sistema, levando a um acesso e controle mais amplos, dependendo dos privilégios do aplicativo.\n\nConsulte todas as suas entidades de serviço (service principals) e registros de aplicativos que possuem credenciais de certificado. Certifique-se de que a data de início do certificado seja inferior a 180 dias.\n\n**Ação de correção**\n\n- [Definir uma política de gerenciamento de aplicativos para gerenciar o tempo de vida dos certificados](https://learn.microsoft.com/graph/api/resources/applicationauthenticationmethodpolicy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Definir uma cadeia de confiança de certificados confiáveis](https://learn.microsoft.com/graph/api/resources/certificatebasedapplicationconfiguration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Criar uma função personalizada de privilégio mínimo para rotacionar credenciais de aplicativos](https://learn.microsoft.com/entra/identity/role-based-access-control/custom-create?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Saiba mais sobre as políticas de gerenciamento de aplicativos para gerenciar credenciais baseadas em certificado](https://devblogs.microsoft.com/identity/app-management-policy/)\n",
      "TestImplementationCost": "High",
      "TestId": "21992",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Certificados de aplicativos devem ser rotacionados regularmente"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma política de conformidade para Android Enterprise foi encontrada ou nenhuma está atribuída.\n\n",
      "TestDescription": "Se as políticas de conformidade não estiverem atribuídas a dispositivos Android Enterprise totalmente gerenciados no Intune, os agentes de ameaças podem explorar endpoints não conformes para obter acesso não autorizado a recursos corporativos, burlar controles de segurança e estabelecer persistência no ambiente. Sem a conformidade aplicada, os dispositivos podem carecer de configurações críticas de segurança, como requisitos de código de acesso, criptografia de armazenamento de dados e controles de versão do SO. Essas lacunas aumentam o risco de vazamento de dados, escalonamento de privilégios e movimentação lateral. A conformidade inconsistente dos dispositivos enfraquece a postura de segurança da organização e torna mais difícil detectar e remediar ameaças antes que ocorram danos significativos.\n\nA aplicação de políticas de conformidade garante que os dispositivos Android Enterprise atendam aos requisitos básicos de segurança e apoia o modelo Zero Trust, validando a integridade do dispositivo e reduzindo a exposição a endpoints mal configurados ou não gerenciados.\n\n**Ação de correção**\n\nCrie e atribua políticas de conformidade do Intune para dispositivos Android Enterprise totalmente gerenciados e de propriedade corporativa para aplicar os padrões organizacionais de acesso e gerenciamento seguros:\n- [Criar uma política de conformidade no Microsoft Intune](https://learn.microsoft.com/intune/intune-service/protect/create-compliance-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-the-policy)\n- [Revisar as configurações de conformidade do Android Enterprise que você pode gerenciar com o Intune](https://learn.microsoft.com/intune/intune-service/protect/compliance-policy-create-android-for-work?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24545",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Políticas de conformidade protegem dispositivos Android totalmente gerenciados e de propriedade corporativa"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma política de conformidade para o Perfil de Trabalho Android foi encontrada ou nenhuma está atribuída.\n\n",
      "TestDescription": "Se as políticas de conformidade não forem atribuídas a dispositivos Android Enterprise de propriedade pessoal no Intune, os agentes de ameaças podem explorar endpoints não conformes para obter acesso não autorizado a recursos corporativos, ignorar controlos de segurança e introduzir vulnerabilidades. Sem a conformidade aplicada, os dispositivos podem carecer de configurações de segurança críticas, como requisitos de código de acesso, criptografia de armazenamento de dados e controlos de versão do SO. Estas lacunas aumentam o risco de fuga de dados e acesso não autorizado. A conformidade inconsistente dos dispositivos enfraquece a postura de segurança da organização e torna mais difícil detetar e remediar ameaças antes que ocorram danos significativos.\n\nA aplicação de políticas de conformidade garante que os dispositivos Android de propriedade pessoal atendam aos requisitos básicos de segurança e apoia o Zero Trust, validando a integridade do dispositivo e reduzindo a exposição a endpoints mal configurados ou não geridos.\n\n**Ação de correção**\n\nCrie e atribua políticas de conformidade do Intune a dispositivos Android Enterprise de propriedade pessoal para aplicar os padrões organizacionais para acesso e gestão seguros:\n- [Criar uma política de conformidade no Microsoft Intune](https://learn.microsoft.com/intune/intune-service/protect/create-compliance-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-the-policy)\n- [Rever as configurações de conformidade do Android Enterprise que pode gerir com o Intune](https://learn.microsoft.com/intune/intune-service/protect/compliance-policy-create-android-for-work?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24547",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Políticas de conformidade protegem dispositivos Android de propriedade pessoal"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma política de conformidade para macOS foi encontrada ou nenhuma está atribuída.\n\n",
      "TestDescription": "Se as políticas de conformidade para dispositivos macOS não estiverem configuradas e atribuídas, os agentes de ameaças podem explorar endpoints não gerenciados ou não conformes para obter acesso não autorizado a recursos corporativos, burlar controles de segurança e estabelecer persistência no ambiente. Sem a conformidade aplicada, os dispositivos macOS podem carecer de configurações críticas de segurança, como criptografia de armazenamento de dados, requisitos de senha e controles de versão do SO. Essas lacunas aumentam o risco de vazamento de dados, escalonamento de privilégios e movimentação lateral. A conformidade inconsistente dos dispositivos enfraquece a postura de segurança da organização e torna mais difícil detectar e remediar ameaças antes que ocorram danos significativos.\n\nA aplicação de políticas de conformidade garante que os dispositivos macOS atendam aos requisitos básicos de segurança e apoia o modelo Zero Trust, validando a integridade do dispositivo e reduzindo a exposição a endpoints mal configurados.\n\n**Ações de correção**\n\nCrie e atribua políticas de conformidade do Intune para dispositivos macOS para aplicar os padrões organizacionais de acesso e gerenciamento seguros:\n- [Criar e atribuir políticas de conformidade do Intune](https://learn.microsoft.com/intune/intune-service/protect/create-compliance-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-the-policy)\n- [Revisar as configurações de conformidade do macOS que você pode gerenciar com o Intune](https://learn.microsoft.com/intune/intune-service/protect/compliance-policy-create-mac-os?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24542",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Políticas de conformidade protegem dispositivos macOS"
    },
    {
      "TestResult": "\n❌ O Prompt Shield não está configurado adequadamente - nenhuma política de prompt existe.\n\n[View Prompt Shield Configuration](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/PromptPolicy.ReactView)\n\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Failed",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "",
      "TestId": "25415",
      "TestTitle": "O AI Gateway protege aplicativos de IA generativa empresariais contra ataques de injeção de prompt",
      "TestDescription": "Se as organizações não usarem proteção Prompt Shield, atores de ameaça podem explorar vulnerabilidades de injeção de prompt para comprometer fluxos de trabalho alimentados por IA. Usuários maliciosos podem criar entradas adversárias que manipulam grandes modelos de linguagem para ignorar instruções do sistema, divulgar dados confidenciais ou executar ações não intencionais, como gerar conteúdo de phishing.\n\nSem filtragem de prompt em nível de rede:\n\n- Ataques diretos de injeção de prompt podem contornar mecanismos de segurança em nível de aplicativo através de técnicas sofisticadas de jailbreak.\n- A injeção indireta de prompt ocorre quando atores de ameaça incorporam instruções maliciosas em conteúdo externo que a IA processa.\n- Cada aplicativo de IA deve implementar proteção de forma independente, criando posturas de segurança inconsistentes e proteções inadequadas contra implantações de IA novas ou personalizadas.\n\n**Ação de remediação**\n\n- [Ativar o perfil de encaminhamento de tráfego do Internet Access para rotear o tráfego da internet através do Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-internet-access-profile?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- [Configure as configurações de inspeção TLS e implante o certificado CA para permitir a inspeção do tráfego de aplicativos de IA criptografados](https://learn.microsoft.com/entra/global-secure-access/how-to-transport-layer-security-settings?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Siga as etapas em [Proteger aplicações de IA generativa corporativa com Prompt Shield](https://learn.microsoft.com/entra/global-secure-access/how-to-ai-prompt-shield?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para:\n    - Criar políticas de prompt para verificar e bloquear prompts maliciosos direcionados a aplicações de IA generativa.\n    - Vincular políticas de prompt a perfis de segurança para organizá-las para direcionamento do Conditional Access.\n    - Criar políticas de Conditional Access para aplicar perfis de segurança com políticas de prompt aos usuários que acessam recursos da internet.\n- [Instale o cliente Global Secure Access em dispositivos de usuário para ativar a aquisição de tráfego](https://learn.microsoft.com/entra/global-secure-access/how-to-install-windows-client?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestResult": "\n❌ As Restrições Universais de Locatário não estão totalmente configuradas. A marcação de pacotes de rede está disabled (esperado: enabled). \n\n\n## [Configuração de Restrições Universais de Locatário](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/TenantRestrictions.ReactView/isDefault~/true/name//id/)\n\n| Setting | Current Value | Expected Value | Status |\n| :------ | :------------ | :------------- | :----: |\n| Status da marcação de pacotes de rede | disabled | habilitado | ❌ |\n| Tipo de acesso de usuários e grupos | blocked | bloqueado | ✅ |\n| Destino de usuários e grupos | AllUsers | AllUsers | ✅ |\n| Tipo de acesso de aplicações | blocked | bloqueado | ✅ |\n| Destino de aplicações | AllApplications | AllApplications | ✅ |\n\r\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Failed",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "",
      "TestId": "25377",
      "TestTitle": "As restrições universais de locatário bloqueiam o acesso externo não autorizado",
      "TestDescription": "Sem as restrições universais de locatário configuradas, usuários em dispositivos e redes corporativas podem autenticar em locatários externos não autorizados do Microsoft Entra e acessar aplicações na nuvem usando identidades externas. Essa vulnerabilidade permite que um agente de ameaça use credenciais de usuário comprometidas ou persistência estabelecida em um dispositivo corporativo para autenticar em um locatário que ele controla. Eles podem contornar controles de segurança de rede tradicionais que não conseguem inspecionar o tráfego de autenticação criptografado para pontos de extremidade de identidade da Microsoft.\n\nUma vez autenticado em um locatário externo, um agente de ameaça pode acessar APIs do Microsoft Graph e serviços em nuvem. Esse acesso permite exfiltrar dados pelo OneDrive, SharePoint, Teams ou qualquer aplicação integrada ao Microsoft Entra no locatário externo. Esse caminho de ataque explora a confiança inerente que redes e dispositivos corporativos têm nos serviços de identidade da Microsoft. As restrições universais de locatário abordam essa vulnerabilidade injetando cabeçalhos de identidade de locatário no tráfego do plano de autenticação por meio do Global Secure Access. O Microsoft Entra ID usa esses cabeçalhos para aplicar políticas de restrições de locatário v2 que bloqueiam tentativas de autenticação para locatários externos não autorizados.\n\n**Ação de remediação**\n- Configure políticas de restrições de locatário v2 para bloquear todos os locatários externos por padrão. Para mais informações, veja [Configurar políticas de restrições de locatário v2](https://learn.microsoft.com/entra/external-id/tenant-restrictions-v2?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Ative o sinalização de restrições universais de locatário no Global Secure Access. Para mais informações, veja [Ativar restrições universais de locatário](https://learn.microsoft.com/entra/global-secure-access/how-to-universal-tenant-restrictions?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Implemente o cliente Global Secure Access nos dispositivos. Para mais informações, veja [Implantar cliente Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/concept-clients?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Habilite o perfil de tráfego Microsoft. Para mais informações, veja [Habilitar o perfil de tráfego Microsoft](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-microsoft-profile?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\n❌ **Falha**: Não foram encontradas políticas habilitadas para restringir acesso de usuários de alto risco.\n\n### Detalhes das Políticas\n\n\n",
      "TestDescription": "Considere que usuários de alto risco foram comprometidos por atacantes. Sem investigação e remediação, os invasores podem executar scripts, implantar aplicativos maliciosos ou manipular chamadas de API para estabelecer persistência, com base nas permissões do usuário comprometido. Atacantes podem então explorar configurações incorretas ou abusar de tokens OAuth para se mover lateralmente entre cargas de trabalho, como documentos, aplicativos SaaS ou recursos do Azure.\n\nOrganizações que usam senhas podem contar com a redefinição de senha para remediar automaticamente usuários de risco. Organizações que utilizam credenciais sem senha (passwordless) devem bloquear o acesso de usuários de risco até que o risco seja investigado e remediado.\n\n**Ação de remediação**\n- [Implantar política de Acesso Condicional para exigir alteração de senha segura para risco de usuário elevado](https://learn.microsoft.com/entra/identity/conditional-access/policy-risk-based-user?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Use o Microsoft Entra ID Protection para [investigar o risco detalhadamente](https://learn.microsoft.com/entra/id-protection/howto-identity-protection-investigate-risk?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "TestImplementationCost": "Medium",
      "TestId": "21797",
      "TestSfiPillar": "Acelerar resposta e remediação",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P2",
      "TestImpact": "High",
      "TestRisk": "High",
      "TestTitle": "Restringir acesso a usuários de alto risco"
    },
    {
      "TestResult": "\n❌ A política de Inspeção TLS não foi configurada corretamente.\n\n\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Failed",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "High",
      "TestSkipped": "",
      "TestId": "25411",
      "TestTitle": "A inspeção TLS está habilitada e corretamente configurada para tráfego de saída",
      "TestDescription": "A inspeção TLS descriptografa e inspeciona o tráfego HTTPS, permitindo visibilidade nas sessões criptografadas. Sem ela, muitos recursos do Microsoft Entra Internet Access não podem funcionar, incluindo filtro de URL e detecção avançada de ameaças. A maioria do tráfego da internet é criptografada, portanto, a inspeção TLS é essencial para aplicar políticas de segurança à maioria da atividade do usuário.\n\n**Ação de remediação**\n\n- [Configure políticas de inspeção de segurança da camada de transporte](https://learn.microsoft.com/entra/global-secure-access/how-to-transport-layer-security?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de Credenciais",
      "SkippedReason": null,
      "TestResult": "\n❌ O Microsoft Rights Management Service (RMS) está bloqueado ou restrito por uma ou mais políticas de Acesso Condicional.\n\n**Políticas que afetam o RMS:**\n\n| Nome da Política | Estado | RMS Direcionado | RMS Excluído | Controles de Concessão | Controles de Sessão |\n| :--- | :--- | :--- | :--- | :--- | :--- |\n| [Allow legay authentication - Email André](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/2922cabf-073e-4da1-907a-d11e2674a3c8) | enabled | Yes | No | None | Disable Resilience Defaults |\n\n",
      "TestDescription": "O Microsoft Rights Management Service (RMS) e a tecnologia de protecao que aplica criptografia para rotulos de sensibilidade e politicas de protecao de informacoes. Quando usuarios acessam conteudo criptografado, seus aplicativos precisam se autenticar no servico RMS (App ID: `00000012-0000-0000-c000-000000000000`) para descriptografar o conteudo. Se as politicas de Acesso Condicional bloquearem ou restringirem essa autenticacao de forma incorreta, por exemplo exigindo autenticacao multifator (MFA), conformidade do dispositivo ou localizacoes de rede especificas, os usuarios nao conseguirao abrir emails, documentos ou arquivos criptografados protegidos por rotulos de sensibilidade.\nIsso fica mais evidente ao colaborar em conteudo protegido por MIP entre um locatario externo e o locatario de origem.\nO servico RMS deve ser explicitamente excluido de politicas de Acesso Condicional que aplicam controles de autenticacao, pois o proprio aplicativo realiza a descriptografia e o usuario ja foi autenticado no aplicativo cliente principal. Bloquear a autenticacao do RMS impede o processo de descriptografia e interrompe fluxos de protecao da informacao nos servicos do Microsoft 365, incluindo Outlook, Word, Excel, PowerPoint, Teams e SharePoint.\n\n**Ação de remediação**\n\nPara excluir o RMS das politicas de Acesso Condicional:\n1. Acesse [Centro de administracao do Microsoft Entra > Entra ID > Acesso Condicional > Politicas](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/Policies)\n2. Selecione a politica que esta bloqueando o RMS\n3. Em Recursos de destino > Todos os recursos (anteriormente \"Todos os aplicativos de nuvem\")\n4. Em Excluir, selecione \"Selecionar recursos\" e adicione \"Microsoft Rights Management Services\" (App ID: `00000012-0000-0000-c000-000000000000`)\n5. Salve a politica\n\n- [Configuracao do Microsoft Entra para Azure Information Protection](https://learn.microsoft.com/purview/encryption-azure-ad-configuration)\n- [Politicas de Acesso Condicional e documentos criptografados](https://learn.microsoft.com/purview/encryption-azure-ad-configuration#conditional-access-policies-and-encrypted-documents)\n- [Acesso Condicional: aplicativos de nuvem, acoes e contexto de autenticacao](https://learn.microsoft.com/entra/identity/conditional-access/concept-conditional-access-cloud-apps)\n\n",
      "TestImplementationCost": "Low",
      "TestId": "35001",
      "TestSfiPillar": "",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E5",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "As políticas de Acesso Condicional não excluem cargas de trabalho do Gerenciamento de Direitos"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de postura de segurança de dados",
      "SkippedReason": null,
      "TestResult": "\n❌ O registro de auditoria do Purview está DESABILITADO, criando uma lacuna crítica de visibilidade em que acessos não autorizados, violações de política e incidentes de segurança não podem ser detectados ou investigados.\n\n\n\n### [Status do registro de auditoria](https://purview.microsoft.com/audit)\n| Propriedade de configuração | Valor |\n| :--- | :--- |\n| Ingestão unificada do log de auditoria habilitada | False |\n| Limite de idade do log de auditoria | 90.00:00:00 |\n| ID da organização | FFO.extest.microsoft.com/Microsoft Exchange Hosted Organizations/segjcadvisor.onmicrosoft.com - FFO.extest.microsoft.com/Microsoft Exchange Hosted Organizations/segjcadvisor.onmicrosoft.com/Configuration |\n",
      "TestDescription": "O registro de auditoria do Purview registra quem acessou dados sensíveis, quando ocorreram violações de política e quais ações administrativas foram tomadas no Microsoft 365. Quando os logs de auditoria estão disponíveis, as equipes de segurança podem investigar incidentes, realizar eDiscovery, detectar ameaças internas e demonstrar controles para auditores e reguladores.\n\nSem o registro de auditoria habilitado, agentes mal-intencionados frequentemente podem operar sem serem detectados, e a resposta a incidentes se torna impossível devido à falta de evidências. Organizações que deixam de habilitar o registro de auditoria também correm risco de não conformidade com requisitos regulatórios que exigem registro de atividades para operações sensíveis.\n\n**Ação de remediação**\n\n- [Ativar ou desativar a auditoria](https://learn.microsoft.com/purview/audit-log-enable-disable?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "35037",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E3",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Registro de auditoria do Purview habilitado"
    },
    {
      "TestResult": "\n⚠️ No Private Access applications are configured.\n\n## Links do portal\n\n- [Global Secure Access > Aplicativos > Aplicativos corporativos](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/EnterpriseApplicationListBladeV3/fromNav/globalSecureAccess/applicationType/GlobalSecureAccessApplication)\n- [Conditional Access > Políticas](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/Overview/menuId//fromNav/Identity)\n- [Métodos de autenticação > Forças de autenticação](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/AuthStrengths)\n",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestStatus": "Failed",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "",
      "TestId": "25396",
      "TestTitle": "Políticas de Conditional Access aplicam autenticação forte para aplicativos privados",
      "TestDescription": "Quando as políticas de Conditional Access não protegem os aplicativos Private Access exigindo autenticação forte, agentes de ameaça podem usar ataques de phishing, credential stuffing ou password spraying para obter credenciais de usuário e entrar em aplicativos privados apenas com uma senha comprometida.\n\nSem autenticação forte:\n\n- Agentes de ameaça ganham acesso inicial a recursos internos que deveriam ser protegidos por controles mais fortes.\n- Se a autenticação multifator estiver ausente ou métodos suscetíveis a phishing como SMS ou voz forem usados, ataques de adversário no meio podem ocorrer, nos quais os agentes de ameaça interceptam tokens de autenticação e cookies de sessão.\n- Agentes de ameaça podem mover-se lateralmente a partir do aplicativo privado inicialmente comprometido para outros recursos internos.\n\nA Microsoft recomenda aplicar métodos de autenticação resistente a phishing, como chaves de segurança FIDO2, Windows Hello for Business ou autenticação baseada em certificado para acesso a aplicativos privados, com autenticação multifator como o mínimo aceitável.\n\n**Ação de remediação**\n\n- [Configure políticas de Conditional Access para exigir autenticação resistente a phishing](https://learn.microsoft.com/entra/identity/conditional-access/policy-all-users-mfa-strength?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestResult": "\n❌ Os sensores do Microsoft Entra Private Access para controladores de domínio não estão implantados.\n\n\n\n\r\n\r\n\r\n\r\n\r\n\r\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Failed",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "",
      "TestId": "25403",
      "TestTitle": "Os sensores de Private Access estão impondo políticas de autenticação forte nos controladores de domínio",
      "TestDescription": "Se você não implantar sensores do Microsoft Entra Private Access em controladores de domínio, agentes de ameaça podem explorar solicitações de autenticação Kerberos de qualquer dispositivo na rede, incluindo endpoints não gerenciados ou comprometidos. Eles podem usar essa vulnerabilidade para obter tickets de serviço para recursos locais sem autenticação multifator ou validação de conformidade do dispositivo.\n\nSe você não implantar sensores do Private Access em controladores de domínio:\n\n- Agentes de ameaça podem solicitar tickets Kerberos para recursos privilegiados, como compartilhamentos de arquivos, servidores de banco de dados e serviços de área de trabalho remota. Essa vulnerabilidade possibilita movimento lateral pelo ambiente local.\n- Políticas de Conditional Access não se aplicam à autenticação Kerberos, pois ela opera dentro de um modelo de confiança baseado em perímetro, onde qualquer usuário autenticado pode solicitar tickets independentemente da força de autenticação ou postura do dispositivo.\n- Credenciais de usuário comprometidas obtidas por phishing ou roubo de credenciais podem ser imediatamente usadas para acessar recursos autenticados no domínio sem acionar requisitos de autenticação multifator.\n\n**Ação de remediação**\n\n- [Configure o Microsoft Entra Private Access para controladores de domínio do Active Directory](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-domain-controllers?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestResult": "\n\n## Resumo\n\n| Métrica | Contagem |\n| :--- | ---: |\n| Atribuições totais | 2 |\n| Atribuições de todo o locatário | 2 |\n| Atribuições escopadas | 0 |\n| Atribuições problemáticas | 1 |\n\n\n## Atribuições de Application Administrator:\n\n- Contagem: 2\n\n| DirectoryScopeId | Nome principal | UPN | Conta habilitada | Tipo | Tipo de usuário |\n| :--- | :--- | :--- | :---: | :--- | :--- |\n| / | AdminAgents @( Ingram Micro Brasil Ltda , ingrammicrobrasilcsp.onmicrosoft.com ) |  |  | group |  |\n| / | Arthur Silva | JC2Sec | arthur.silva@jc2sec.com.br | True | user | Member |\n\n\n## ❌ Atribuições em todo o locatário\n\nAs seguintes atribuições do Application Administrator têm escopo em todo o locatário e devem ser restritas:\n\n| Principal | Tipo | Tipo de usuário | Escopo |\n| :--- | :--- | :--- | :--- |\n| AdminAgents @( Ingram Micro Brasil Ltda , ingrammicrobrasilcsp.onmicrosoft.com ) | group |  | Tenant-wide (/) |\n| arthur.silva@jc2sec.com.br | user | Member | Tenant-wide (/) |\n\n\n## ❌ Atribuições problemáticas de principal\n\nAs seguintes atribuições usam grupos, service principals ou usuários convidados:\n\n| Principal | Tipo | Tipo de usuário | Escopo |\n| :--- | :--- | :--- | :--- |\n| AdminAgents @( Ingram Micro Brasil Ltda , ingrammicrobrasilcsp.onmicrosoft.com ) | group |  | Abrangência do locatário (/) |\n\n\n[Ver no Portal do Entra: Funções e administradores](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/AllRolesBlade)\r\n",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestStatus": "Failed",
      "TestRisk": "High",
      "TestCategory": "Gerenciamento de funções",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access",
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "25384",
      "TestTitle": "Os direitos de administrador de aplicação são restritos a apps Private Access específicos",
      "TestDescription": "Um administrador de aplicações com escopo ao nível do locatário pode gerenciar todos os registros de aplicativo e aplicações empresariais. Se um agente de ameaça comprometer um administrador de aplicações com escopo em todo o locatário, ele pode adicionar credenciais a qualquer service principal, consentir APIs maliciosas, modificar ou criar aplicações que permitam exfiltração de dados e desabilitar ou manipular apps Private Access. Escopar a função apenas para apps Private Access necessários aplica o menor privilégio e limita a área de impacto.\n\nSe você não escopar as atribuições de Application Administrator para aplicativos específicos:\n\n- Um Application Administrator comprometido pode gerenciar todos os registros de aplicativo e aplicações empresariais em seu locatário.\n- Agentes de ameaça podem adicionar credenciais a qualquer service principal, permitindo persistência e movimento lateral.\n- Não há contenção da área de impacto; uma única identidade comprometida pode afetar todas as aplicações.\n\n**Ação de remediação**\n\n- [Atribua funções de Application Administrator escopadas a registros de aplicativo específicos](https://learn.microsoft.com/entra/identity/role-based-access-control/custom-enterprise-app-permissions?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) em vez de em todo o locatário.\n- [Atribua funções do Microsoft Entra](https://learn.microsoft.com/entra/identity/role-based-access-control/manage-roles-portal?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) com o menor privilégio necessário para executar as tarefas requeridas.\n- [Use o Privileged Identity Management para gerenciar a ativação sob demanda de funções](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-configure?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- [Gerencie atribuições de função do Microsoft Entra no centro de administração](https://learn.microsoft.com/entra/identity/role-based-access-control/manage-roles-portal?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\n❌ **Falha**: Foram encontrados aplicativos ou entidades de serviço utilizando segredos de cliente. Recomenda-se o uso de certificados ou identidades gerenciadas.\n\n\n",
      "TestDescription": "Aplicativos que utilizam segredos de cliente (client secrets) podem armazená-los em arquivos de configuração, codificá-los diretamente em scripts ou correr o risco de exposição de outras formas. A complexidade do gerenciamento de segredos torna os segredos de cliente suscetíveis a vazamentos e atraentes para atacantes. Quando expostos, os segredos de cliente permitem que invasores misturem suas atividades com operações legítimas, facilitando a evasão de controles de segurança. Se um atacante comprometer o segredo de um aplicativo, ele poderá escalar seus privilégios no sistema, levando a um acesso e controle mais amplos, dependendo das permissões do aplicativo.\n\nAplicativos e entidades de serviço que possuem permissões para as APIs do Microsoft Graph ou outras APIs apresentam um risco maior, pois um invasor pode explorar essas permissões adicionais.\n\n**Ação de remediação**\n\n- [Migrar aplicativos de segredos compartilhados para identidades gerenciadas (managed identities) e adotar práticas mais seguras](https://learn.microsoft.com/entra/identity/enterprise-apps/migrate-applications-from-secrets?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n   - Use identidades gerenciadas para recursos do Azure\n   - Implemente políticas de Acesso Condicional para identidades de carga de trabalho (workload identities)\n   - Implemente a varredura de segredos (secret scanning)\n   - Implemente políticas de autenticação de aplicativos para forçar práticas seguras\n   - Crie uma função personalizada de privilégio mínimo para rotacionar credenciais\n   - Garanta que existe um processo para triagem e monitoramento de aplicativos\n",
      "TestImplementationCost": "Medium",
      "TestId": "21772",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identidade"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identidade"
      ],
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Aplicativos não possuem segredos de cliente configurados"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Dados",
      "SkippedReason": null,
      "TestResult": "\nNenhuma política de Acesso Condicional com Proteção de Aplicativo existe para iOS e Android ou ambas.\n\n\n",
      "TestDescription": "Se as políticas do Microsoft Entra Conditional Access não forem combinadas com controles de proteção de aplicativo, os usuários podem se conectar a recursos corporativos por meio de aplicativos não gerenciados ou inseguros. Isso expõe dados sensíveis a riscos como vazamento de dados, acesso não autorizado e não conformidade regulatória. Sem salvaguardas como proteção de dados em nível de aplicativo, restrições de acesso e prevenção contra perda de dados, agentes de ameaça podem explorar aplicativos desprotegidos para contornar controles de segurança e comprometer dados organizacionais.\n\nA aplicação de políticas de proteção de aplicativos do Intune dentro do Conditional Access garante que apenas aplicativos confiáveis possam acessar dados corporativos. Isso apoia o Zero Trust ao aplicar decisões de acesso com base na confiança do aplicativo, contenção de dados e restrições de uso.\n\n**Ação de remediação**\n\nConfigure políticas de Conditional Access baseadas em aplicativo no Microsoft Entra e Intune para exigir proteção de aplicativo para o acesso a recursos corporativos:  \n- [Configurar políticas de Conditional Access baseadas em aplicativo com o Intune](https://learn.microsoft.com/intune/intune-service/protect/app-based-conditional-access-intune-create?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n\nPara mais informações, veja:  \n- [O que é Conditional Access?](https://learn.microsoft.com/entra/identity/conditional-access/overview?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Saiba mais sobre políticas de Conditional Access baseadas em aplicativo com o Intune](https://learn.microsoft.com/intune/intune-service/protect/app-based-conditional-access-intune?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24827",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Políticas de Acesso Condicional bloqueiam acesso de aplicativos não gerenciados"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de credenciais, Acesso privilegiado",
      "SkippedReason": null,
      "TestResult": "\n❌ Administradores têm acesso ao Autoatendimento para Redefinição de Senha, o que contorna controles de segurança.\n",
      "TestDescription": "O recurso de Redefinição de Senha por Autoatendimento (SSPR) para administradores permite que alterações de senha ocorram sem fatores de autenticação secundários fortes ou supervisão administrativa. Atores de ameaça que comprometem credenciais administrativas podem usar essa capacidade para ignorar outros controles de segurança e manter acesso persistente ao ambiente.\n\nUma vez comprometidos, os invasores podem redefinir imediatamente a senha para bloquear os administradores legítimos. Eles podem então estabelecer persistência, escalar privilégios e implantar cargas maliciosas sem serem detectados.\n\n**Ação de correção**\n\n- [Desativar o SSPR para administradores atualizando a política de autorização](https://learn.microsoft.com/entra/identity/authentication/concept-sspr-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#administrator-reset-policy-differences)\n",
      "TestImplementationCost": "Low",
      "TestId": "21842",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Bloquear administradores de usar o SSPR"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\nURIs de redirecionamento inseguros encontrados\n\n1️⃣ → Uso de http(s) em vez de https, 2️⃣ → Uso de *.azurewebsites.net, 3️⃣ → URL inválido, 4️⃣ → Domínio não resolvido\n\n| | Nome | URIs de redirecionamento inseguros |Tenant proprietário do aplicativo |\n| :--- | :--- | :--- | :--- |\n|  | [BizagiLogin](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/0d70d232-c090-4bf2-b639-8cb831575403/appId/4e105613-0b2d-4726-9ee6-f83993ed6bfc) | `2️⃣ https://authb2c.azurewebsites.net/api/Login/`, `2️⃣ https://authb2c.azurewebsites.net/api/Redirect/`, `2️⃣ https://cockpitlatam-b0e4ahakh0b2agad.eastus2-01.azurewebsites.net/signin-oidc`, `2️⃣ https://companiesresearch-atcyggb7b9hpauea.eastus2-01.azurewebsites.net/signin-oidc`, `2️⃣ https://cockpit-europe-cpdjc3gsc6hwbwh8.eastus2-01.azurewebsites.net/signin-oidc` | 418ce5c4-0e3a-4ef8-8ce6-2d3bd225509c |\n|  | [Data Migration Service](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/4df74d92-3be6-4f64-976e-2169c3144984/appId/a4bad4aa-bf02-4631-9f78-a64ffdba8150) | `1️⃣ http://datamigration.azure.com` | 72f988bf-86f1-41af-91ab-2d7cd011db47 |\n|  | [Graph Explorer](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/7c5a3bce-0478-40c4-be1d-657b55e4d655/appId/de8bc8b5-d9f9-48b1-a8ad-b748da725064) | `2️⃣ https://graphtryit-func-prod-eastus.azurewebsites.net/`, `2️⃣ https://graphtryit-func-ppe-eastus.azurewebsites.net/` | cdc5aeea-15c5-4db6-b079-fcadd2505dc2 |\n|  | [Learn on Demand LMS](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/76cb9396-8fc0-4052-bd03-b303eee62618/appId/143f708f-6a25-4180-bbe3-3167e75f8b47) | `1️⃣ http://lms.localtest.me/AuthenticationProvider/Callback` | e076b593-d7db-4a8e-9556-04bbe80df72d |\n\n",
      "TestDescription": "Aplicativos não-Microsoft e multi-inquilinos configurados com URLs que incluem curingas (wildcards), localhost ou encurtadores de URL aumentam a superfície de ataque para agentes de ameaças. Esses URIs de redirecionamento inseguros (URLs de resposta) podem permitir que adversários manipulem solicitações de autenticação, sequestrem códigos de autorização e interceptem tokens direcionando os usuários para endpoints controlados pelo invasor. As entradas com curingas expandem o risco ao permitir que domínios não intencionais processem respostas de autenticação, enquanto URLs de localhost e encurtadores podem facilitar o phishing e o roubo de tokens em ambientes não controlados.\n\nSem uma validação rigorosa dos URIs de redirecionamento, os invasores podem burlar controles de segurança, personificar aplicativos legítimos e escalar seus privilégios. Essa configuração incorreta permite a persistência, o acesso não autorizado e a movimentação lateral, conforme os adversários exploram a aplicação fraca de OAuth para infiltrar-se em recursos protegidos sem serem detectados.\n\n**Ação de correção**\n\n- [Verificar os URIs de redirecionamento para seus registros de aplicativos.](https://learn.microsoft.com/entra/identity-platform/reply-url?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) Certifique-se de que os URIs de redirecionamento não tenham localhost, *.azurewebsites.net, curingas ou encurtadores de URL.\n",
      "TestImplementationCost": "High",
      "TestId": "23183",
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Entidades de serviço usam URIs de redirecionamento seguros"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Monitoramento",
      "SkippedReason": null,
      "TestResult": "\nEncontradas 6 recomendações de alta prioridade do Entra não tratadas.\n\n\n## Recomendações de alta prioridade do Entra não tratadas\n\n| Nome de Exibição | Status | Insights |\n| :--- | :--- | :--- |\n| Protect all users with a user risk policy  | active | You have 73 of 73 users that don’t have a user risk policy enabled.  |\n| Protect all users with a sign-in risk policy | active | You have 73 of 73 users that don't have a sign-in risk policy turned on. |\n| Do not expire passwords | active | Your current policy is set to let passwords expire. |\n| Ensure all users can complete multifactor authentication | active | You have 19 of 73 users that aren’t registered with MFA.  |\n| Enable policy to block legacy authentication | active | You have 1 of 73 users that don’t have legacy authentication blocked.  |\n| Renew expiring application credentials | active | Your tenant has applications with credentials that will expire soon. |\n",
      "TestDescription": "Deixar recomendações de alta prioridade do Microsoft Entra sem tratamento pode criar uma lacuna na postura de segurança de uma organização, oferecendo aos agentes de ameaças oportunidades para explorar fraquezas conhecidas. Não agir sobre esses itens pode resultar em um aumento da superfície de ataque, operações abaixo do ideal ou uma experiência de usuário insatisfatória.\n\n**Ação de correção**\n\n- [Tratar todas as recomendações de alta prioridade no centro de administração do Microsoft Entra](https://learn.microsoft.com/entra/identity/monitoring-health/overview-recommendations?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#how-does-it-work)\n",
      "TestImplementationCost": "Medium",
      "TestId": "22124",
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": [
        "Application"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Recomendações de alta prioridade do Microsoft Entra foram tratadas"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma linha de base de segurança encontrada ou atribuída.\n\n",
      "TestDescription": "Sem as linhas de base de segurança (security baselines) do Intune devidamente configuradas e atribuídas para Windows, os dispositivos permanecem vulneráveis a uma vasta gama de vetores de ataque que os agentes de ameaças exploram para ganhar persistência e escalar privilégios. Os adversários aproveitam as configurações predefinidas do Windows, que carecem de definições de segurança reforçadas, para realizar movimentos laterais utilizando técnicas como despejo de credenciais (credential dumping), escalonamento de privilégios via vulnerabilidades não corrigidas e exploração de mecanismos de autenticação fracos. Na ausência de linhas de base de segurança impostas, os atacantes podem contornar controlos de segurança críticos e exfiltrar dados sensíveis.\n\nA aplicação de linhas de base de segurança garante que os dispositivos Windows sejam configurados com definições reforçadas, reduzindo a superfície de ataque, impondo a defesa em profundidade e apoiando o Zero Trust através da padronização de controlos de segurança em todo o ambiente.\n\n**Ação de correção**\n\nConfigure e atribua as linhas de base de segurança do Intune a dispositivos Windows para impor definições de segurança padronizadas e monitorizar a conformidade:\n- [Implementar linhas de base de segurança para ajudar a proteger dispositivos Windows](https://learn.microsoft.com/intune/intune-service/protect/security-baselines-configure?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-a-profile-for-a-security-baseline)\n- [Monitorizar a conformidade da linha de base de segurança](https://learn.microsoft.com/intune/intune-service/protect/security-baselines-monitor?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "24573",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Linhas de base de segurança são aplicadas a dispositivos Windows para reforçar a postura de segurança"
    },
    {
      "TestResult": "\n❌ A política de acesso à Internet não está sendo aplicada por meio do Conditional Access.\n\n\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Failed",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "",
      "TestId": "25407",
      "TestTitle": "A filtragem de conteúdo web integra-se ao Conditional Access",
      "TestDescription": "O perfil base aplica as mesmas regras de filtragem a todos os usuários e sessões. A integração com o Conditional Access permite filtragem consciente de identidade que se adapta ao risco do usuário, conformidade do dispositivo, localização ou associação a grupos. Aplique filtragem mais rígida a sessões de risco enquanto permite acesso padrão para usuários verificados em dispositivos compatíveis, impedindo que contas comprometidas contornem os controles de segurança.\n\n**Ação de remediação**\n\n- [Vincule perfis de segurança a políticas do Conditional Access](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-web-content-filtering?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-and-link-conditional-access-policy)\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": null,
      "TestResult": "\nO método de autenticação por chave de segurança não está ativado; os usuários não podem registrar chaves de segurança FIDO2 para autenticação forte.\n\n\n## Configurações do método de autenticação de chave de segurança FIDO2\n\n❌ **Método de autenticação FIDO2**\n- Status: Disabled\n- Alvos incluídos: All users\n- Alvos excluídos: Nenhum\n",
      "TestDescription": "As chaves de segurança FIDO2 fornecem autenticação resistente a phishing e baseada em hardware, que protege contra roubo de credenciais e acesso não autorizado. As chaves de segurança usam prova criptográfica de identidade vinculada a um dispositivo específico, tornando as credenciais impossíveis de replicar ou pescar (phish). Ativar este método de autenticação permite que os usuários registrem chaves de segurança para uma autenticação forte sem senha (passwordless).\n\n**Ação de correção**\n\n- [Ativar o método de autenticação de chave de segurança FIDO2](https://learn.microsoft.com/entra/identity/authentication/how-to-enable-passkey-fido2?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enable-passkey-fido2-authentication-method)\n- [Gerenciar métodos de autenticação](https://learn.microsoft.com/entra/identity/authentication/concept-authentication-methods-manage?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21838",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Método de autenticação de chave de segurança ativado"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\n❌ **Falha**: Alguns logons de alto risco não são mitigados adequadamente por políticas de Acesso Condicional.\n\n\n",
      "TestDescription": "Quando os logons (sign-ins) de alto risco não são devidamente restritos por meio de políticas de Acesso Condicional, as organizações se expõem a vulnerabilidades de segurança. Atacantes podem explorar essas lacunas para obter acesso inicial por meio de credenciais comprometidas, ataques de preenchimento de credenciais (credential stuffing) ou padrões de logon anômalos que o Microsoft Entra ID Protection identifica como comportamentos de risco. Sem as restrições adequadas, criminosos que se autenticam com sucesso em cenários de alto risco podem realizar escalonamento de privilégios, abusando da sessão autenticada para acessar recursos sensíveis, modificar configurações de segurança ou realizar reconhecimento (reconnaissance) dentro do ambiente.\n\nUma vez estabelecido o acesso através de logons de alto risco não controlados, os invasores podem obter persistência criando contas adicionais ou modificando políticas de autenticação para manter o acesso a longo prazo. O acesso irrestrito permite movimento lateral entre sistemas e aplicativos, acessando repositórios de dados sensíveis ou interfaces administrativas.\n\n**Ação de remediação**\n\n- [Implantar uma política de Acesso Condicional para exigir MFA para risco de logon elevado](https://learn.microsoft.com/entra/identity/conditional-access/policy-risk-based-sign-in?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21799",
      "TestSfiPillar": "Acelerar resposta e remediação",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P2",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Restringir logons de alto risco"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\n❌ **Falha**: Nenhuma política de Acesso Condicional exigindo proteção de token foi encontrada.\n\nNenhuma política de Acesso Condicional visando proteção de token foi encontrada.\n\n",
      "TestDescription": "Um atacante pode interceptar ou extrair tokens de autenticação da memória, do armazenamento local em um dispositivo legítimo ou inspecionando o tráfego de rede. O invasor pode reutilizar esses tokens para ignorar os controles de autenticação de usuários e dispositivos, obter acesso não autorizado a dados sensíveis ou realizar novos ataques. Como esses tokens são válidos e limitados no tempo, a detecção de anomalias tradicional muitas vezes falha em sinalizar a atividade, o que pode permitir o acesso sustentado até que o token expire ou seja revogado.\n\nA proteção de token, também chamada de vinculação de token (token binding), ajuda a evitar o roubo de tokens, garantindo que um token seja utilizável apenas a partir do dispositivo pretendido. A proteção de token utiliza criptografia para que, sem a chave do dispositivo cliente, ninguém possa usar o token.\n\n**Ação de remediação**\n\n- [Implantar uma política de Acesso Condicional para exigir proteção de token](https://learn.microsoft.com/entra/identity/conditional-access/concept-token-protection?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21786",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "A atividade de logon do usuário utiliza proteção de token"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\nNem todos os aplicativos empresariais com permissões de alto privilégio possuem proprietários\n\n## Aplicativos sem proprietários suficientes\n\n| App name | Multi-tenant | Permission  | Classification | Owner count |\n| :-------- | :------------ | :---------- | :------------- | :----------- |\n| [Amazon Alexa Connect](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/b9646c43-0f3a-4e17-92f1-a1450d044c32) | False | Calendars.Read.Shared, Calendars.ReadWrite, Calendars.ReadWrite.Shared, Contacts.Read, offline_access, People.Read, User.Read | High | 0 |\n| [SharePoint Online Client Extensibility Web Application Principal Helper](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/602547da-0cc6-4460-b5ab-46a46ea60d14) | False | Directory.AccessAsUser.All | High | 0 |\n| [MyFiles](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/167d40d1-6b85-4dbd-8351-c3c1c79154f0) | False | Files.ReadWrite, offline_access, User.Read | High | 0 |\n| [v1-app-registration-866c2573-b902-499d-a324-dc411b3ccd6d](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/a6e9bc42-4782-4e63-9783-4518aa521003) | False | Directory.Read.All, User.Read.All | High | 0 |\n| [Backup Service](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/6f97503e-0119-4629-9a6e-d06e63a2a057) | False | ChannelMessage.Read.All, Directory.Read.All, Files.ReadWrite.All, full_access_as_app, Group.ReadWrite.All, Sites.FullControl.All, Sites.Manage.All, Sites.ReadWrite.All, TermStore.ReadWrite.All, User.Read, User.ReadWrite.All | High | 0 |\n| [Zoho Sign](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/e0bd303b-4530-4f33-9a4f-8e37a7bfbfdb) | False | Contacts.Read, Files.ReadWrite.All, offline_access, User.ReadBasic.All | High | 0 |\n| [Trend Micro Vision One](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/998076d2-5bd0-4d39-91b0-41e98b0e5365) | False | ActivityFeed.Read, AuditLog.Read.All, Directory.Read.All, Group.Read.All, IdentityRiskEvent.Read.All, MailboxSettings.Read, Member.Read.Hidden, Organization.Read.All, People.Read.All, Place.Read.All, Policy.Read.All, Reports.Read.All, SecurityEvents.Read.All, Sites.Read.All, ThreatAssessment.Read.All, User.Read.All, UserAuthenticationMethod.Read.All | High | 0 |\n| [Trend Micro Vision One (US)](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/9efbcaa0-965c-4ac5-b3cc-972f3760cb33) | False | Directory.ReadWrite.All, User.Read | High | 0 |\n| [Trend Micro Vision One (US)](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/c374179b-cab1-4c7a-a780-64e0287f8357) | False | Directory.Read.All, User.Read | High | 0 |\n| [3CX Phone System](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/725b22c1-3198-49fa-b0a6-e928d57541b8) | False | Mail.Send, User.Read, User.Read.All | High | 0 |\n| [Lusha](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/983024ab-0f09-49a9-b22b-0b0a0a62d578) | False | Calendars.ReadWrite, Contacts.Read, email, Mail.Read, Mail.ReadWrite, Mail.Send, offline_access, openid, People.Read, profile, User.Read | High | 0 |\n| [Prowler](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/f2df545a-e19c-4af9-84a0-211ad81add28) | False | Directory.Read.All, Policy.Read.All, User.Read, UserAuthenticationMethod.Read.All | High | 0 |\n| [Atlassian Cloud](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/cd8213ca-7977-4274-b52c-9bcb946cbd97) | False | email, offline_access, openid, People.Read, User.Read | High | 0 |\n| [MSFT Power Platform - Azure AD](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/880547df-d5c5-489d-94dd-534ace773d4b) | False | Directory.ReadWrite.All, Group.ReadWrite.All, offline_access, User.ReadWrite.All | High | 0 |\n| [Backup Service](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/e0149848-9f0d-4783-afed-68f44affc4fa) | False | ChannelMessage.Read.All, Directory.Read.All, Files.ReadWrite.All, full_access_as_app, Group.ReadWrite.All, Sites.FullControl.All, Sites.Manage.All, Sites.ReadWrite.All, TermStore.ReadWrite.All, User.Read, User.ReadWrite.All | High | 0 |\n| [Cloudflare One Read-Only](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/d122ef6f-f0ea-438c-a111-b98cc89c566c) | False | Application.Read.All, AuditLog.Read.All, Calendars.Read, CrossTenantInformation.ReadBasic.All, Directory.Read.All, Domain.Read.All, Files.Read.All, Group.Read.All, GroupMember.Read.All, IdentityRiskyUser.Read.All, InformationProtectionPolicy.Read.All, Mail.ReadWrite, MailboxSettings.Read, offline_access, Organization.Read.All, profile, RoleManagement.Read.All, User.Read.All, UserAuthenticationMethod.Read.All | High | 0 |\n| [GraphPowerBI](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/25ec645b-aa7c-4177-9aba-e782e87e844f) | False | AuditLog.Read.All, AuditLogsQuery-Entra.Read.All, AuditLogsQuery.Read.All, AuthenticationContext.Read.All, Directory.Read.All, User.Read, User.Read.All | High | 0 |\n| [Services Desk - Freshservice](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/0e4f0ba8-986a-47ef-a1e7-64a771c56c24) | False | User.Read.All | High | 0 |\n| [BloqueioCLT](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/56107465-251a-4d72-b19b-39b042749172) | False | Policy.Read.All, Policy.Read.ConditionalAccess, Policy.Read.DeviceConfiguration, Policy.Read.IdentityProtection, Policy.Read.PermissionGrant, Policy.ReadWrite.AccessReview, Policy.ReadWrite.ApplicationConfiguration, Policy.ReadWrite.AuthenticationFlows, Policy.ReadWrite.AuthenticationMethod, Policy.ReadWrite.Authorization, Policy.ReadWrite.ConditionalAccess, Policy.ReadWrite.ConsentRequest, Policy.ReadWrite.CrossTenantAccess, Policy.ReadWrite.CrossTenantCapability, Policy.ReadWrite.DeviceConfiguration, Policy.ReadWrite.ExternalIdentities, Policy.ReadWrite.FeatureRollout, Policy.ReadWrite.FedTokenValidation, Policy.ReadWrite.IdentityProtection, Policy.ReadWrite.MobilityManagement, Policy.ReadWrite.PermissionGrant, Policy.ReadWrite.SecurityDefaults, Policy.ReadWrite.TrustFramework, User.Read | High | 0 |\n| [CSPM - JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/2c2c526c-91c2-4069-85a5-fb747d195109) | False | Directory.Read.All, Policy.Read.All, User.Read, UserAuthenticationMethod.Read.All | High | 0 |\n| [ZeroTrustAssessment](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/2919ea4b-3b81-4ac6-a5e4-f6d65d21dd07) | False | AttackSimulation.Read.All, AuditLog.Read.All, AuditLogsQuery-Endpoint.Read.All, AuditLogsQuery-Entra.Read.All, AuditLogsQuery-Exchange.Read.All, AuditLogsQuery-OneDrive.Read.All, AuditLogsQuery-SharePoint.Read.All, AuditLogsQuery.Read.All, DeviceManagementApps.Read.All, DeviceManagementConfiguration.Read.All, DeviceManagementManagedDevices.Read.All, DeviceManagementServiceConfig.Read.All, Directory.Read.All, Policy.Read.All, Policy.Read.AuthenticationMethod, Reports.Read.All, RoleManagement.Read.All, RoleManagement.Read.Directory, SecurityEvents.Read.All, UserAuthenticationMethod.Read.All | High | 0 |\n| [Graph Explorer](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/7c5a3bce-0478-40c4-be1d-657b55e4d655) | False | Directory.Read.All, offline_access, openid, profile, User.Read, User.Read.All | High | 0 |\n| [Key Cloak](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/f0312aa4-239e-4865-a530-5e339981edf0) | False | Mail.Send, SMTP.Send, User.Read | High | 0 |\n| [Passbolt](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/5e8325d5-72ec-462c-a8b1-861020c76036) | False | Mail.Send | High | 0 |\n| [audit_cloud](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/40159f6d-95b0-4298-b3a0-fe5d0215766d) | True | Calendars.Read, DeviceManagementApps.Read.All, DeviceManagementConfiguration.Read.All, DeviceManagementManagedDevices.Read.All, Directory.Read.All, Policy.Read.All, Reports.Read.All, SecurityEvents.Read.All, User.Read.All | High | 0 |\n| [VPN Server](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/383251dd-0e36-42e5-887b-d73c815250db) | False | Directory.Read.All | High | 0 |\n\n",
      "TestDescription": "Sem proprietários, os aplicativos empresariais tornam-se ativos órfãos que atores de ameaça podem explorar por meio de técnicas de coleta de credenciais e escalonamento de privilégios. Esses aplicativos geralmente retêm permissões elevadas e acesso a recursos sensíveis, enquanto carecem de supervisão adequada e governança de segurança. A elevação de privilégio para proprietários pode gerar uma preocupação de segurança, dependendo das permissões do aplicativo. Mais criticamente, aplicativos sem um proprietário podem criar incerteza no monitoramento de segurança, onde atores de ameaça podem estabelecer persistência usando permissões de aplicativos existentes para acessar dados ou criar contas de backdoor sem acionar mecanismos de detecção baseados em propriedade.\n\nQuando os aplicativos carecem de proprietários, as equipes de segurança não conseguem conduzir efetivamente o gerenciamento do ciclo de vida do aplicativo. Essa lacuna deixa aplicativos com permissões potencialmente excessivas, configurações obsoletas ou credenciais comprometidas que atores de ameaça podem descobrir por meio de técnicas de enumeração e explorar para se mover lateralmente no ambiente. A ausência de propriedade também impede revisões de acesso adequadas e auditorias de permissão, permitindo que atores de ameaça mantenham acesso de longo prazo por meio de aplicativos que deveriam ser desativados ou ter suas permissões reduzidas. Não manter um portfólio de aplicativos limpo pode fornecer vetores de acesso persistentes que podem ser usados para exfiltração de dados ou comprometimento adicional do ambiente.\n\n**Ação de correção**\n\n- [Atribuir proprietários a aplicativos](https://learn.microsoft.com/entra/identity/enterprise-apps/assign-app-owners?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21867",
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Aplicativos empresariais com permissões de API do Microsoft Graph de alto privilégio possuem proprietários"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\n❌ Not all sign-in activity comes from managed devices.\n\n### Managed device conditional access policy summary\n\nThe table below lists all Conditional Access policies that require a compliant device or a hybrid joined device.\n| Name | All users | All apps | Compliant device | Hybrid joined device | Policy state | Status |\n| :--- | :---:  | :---: | :---: | :---: | :--- | :--- |\n| [Política para bloqueio disp. pessoal (BYOD)](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/f9dedbeb-6ab6-40e6-958a-2ab95504768b) | 🔴 | 🟢 | 🟢 | 🔴 | 🟡 Report-only | ❌ Fail |\n\n",
      "TestDescription": "Exigir que os logons ocorram a partir de dispositivos gerenciados garante que os usuários acessem os recursos organizacionais apenas de dispositivos que atendam aos seus requisitos de segurança e conformidade. Dispositivos não gerenciados carecem de controles de segurança organizacional e proteção de endpoint, criando potenciais pontos de entrada para invasores. O uso do Acesso Condicional para exigir dispositivos em conformidade ou dispositivos com ingresso híbrido no Microsoft Entra ajuda a proteger contra o roubo de credenciais e o acesso não autorizado a partir de endpoints não confiáveis.\n\n**Ação de correção**\n\n- [Exigir dispositivos em conformidade ou com ingresso híbrido com Acesso Condicional](https://learn.microsoft.com/entra/identity/conditional-access/policy-all-users-device-compliance?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Configurar políticas de conformidade de dispositivos no Microsoft Intune](https://learn.microsoft.com/mem/intune/protect/device-compliance-get-started?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "High",
      "TestId": "21892",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "High",
      "TestRisk": "High",
      "TestTitle": "Toda a atividade de logon provém de dispositivos gerenciados"
    },
    {
      "TestResult": "\n❌ Os logs do Global Secure Access não são retidos por tempo suficiente para suportar investigações de segurança e obrigações de conformidade.\n\n\n## [Configuração de diagnóstico](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/DiagnosticSettings)\n\n### Status de retenção de log\n\n| Categoria de log | Habilitado | Tipo de destino | Período de retenção | Atende ao mínimo (90 dias) |\n| :--- | :--- | :--- | :--- | :--- |\n| AuditLogs | Sim | Workspace | Não configurado | Não |\n| NetworkAccessTrafficLogs | Não | Nenhum | Não configurado | Não |\n| EnrichedOffice365AuditLogs | Não | Nenhum | Não configurado | Não |\n| RemoteNetworkHealthLogs | Não | Nenhum | Não configurado | Não |\n| NetworkAccessAlerts | Não | Nenhum | Não configurado | Não |\n| NetworkAccessConnectionEvents | Não | Nenhum | Não configurado | Não |\n| NetworkAccessGenerativeAIInsights | Não | Nenhum | Não configurado | Não |\n\n### Detalhes do destino\n\n| Tipo de destino | Nome do recurso | Retenção padrão | Status |\n| :--- | :--- | :--- | :--- |\n| None | N/A | N/A | Insufficient |\n\n### Resumo\n\n| Métrica | Valor |\n| :--- | :--- |\n| Total de configurações de diagnóstico | 1 |\n| Configurações com destino de longo prazo | 1 |\n| Período médio de retenção | N/A |\n| Retenção mínima encontrada | N/A |\n| Atende ao mínimo de 90 dias | Não |\n\n",
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestStatus": "Failed",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access",
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "25420",
      "TestTitle": "Os logs de acesso à rede são retidos para análise de segurança e conformidade",
      "TestDescription": "Sem retenção estendida para auditoria do Global Secure Access e logs de tráfego, atores de ameaça podem operar além da janela de retenção padrão de 30 dias, sabendo que suas atividades são automaticamente apagadas antes da detecção. As investigações de segurança geralmente exigem análise histórica que abrange semanas ou meses para identificar vetores de comprometimento, padrões de movimento lateral e canais de exfiltração de dados.\n\nSem retenção adequada de logs:\n\n- As equipes de segurança não podem estabelecer padrões de comportamento de linha de base, executar caça de ameaças retrospectiva ou correlacionar eventos de acesso à rede em períodos estendidos.\n- As organizações sujeitas a estruturas regulatórias como [GDPR](https://learn.microsoft.com/compliance/regulatory/gdpr?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci), HIPAA, PCI DSS e SOX enfrentam violações de conformidade quando não conseguem produzir trilhas de auditoria para períodos de retenção obrigatórios.\n- A análise da causa raíz durante a resposta a incidentes é limitada, potencialmente permitindo que atores de ameaça mantenham persistência enquanto as organizações se concentram em sintomas visíveis.\n\n**Ação de remediação**\n\n- [Configure as configurações de diagnóstico com um espaço de trabalho do Log Analytics](https://learn.microsoft.com/entra/identity/monitoring-health/howto-integrate-activity-logs-with-azure-monitor-logs?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para uma retenção estendida de 90-730 dias, com recursos de consulta.\n- [Configure a retenção do espaço de trabalho do Log Analytics](https://learn.microsoft.com/azure/azure-monitor/logs/data-retention-archive?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para atender aos requisitos de segurança e conformidade organizacionais (mínimo de 90 dias recomendado).\n- [Ative a retenção em nível de tabela](https://learn.microsoft.com/azure/azure-monitor/logs/data-retention-archive?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#configure-table-level-retention) para tabelas especiais do Global Secure Access para estender além dos padrões do espaço de trabalho.\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\n## Relatório de Ações Protegidas\n\n| Nome da Política | Estado | Contexto de Autenticação | Força de Autenticação | Dispositivos | Frequência de Login |\n| :--- | :--- | :--- | :--- | :--- | :--- |\n\n",
      "TestDescription": "Agentes de ameaça que ganham acesso privilegiado a um tenant podem manipular políticas de Acesso Condicional, potencialmente desabilitando controles críticos de segurança e permitindo acesso persistente ou movimentação lateral. Esse tipo de ataque pode resultar em comprometimento de todo o ambiente ao contornar barreiras de autenticação e autorização.\n\nAções protegidas permitem que os administradores protejam a criação e modificação de políticas de Acesso Condicional com controles extras de segurança, como métodos de autenticação mais fortes (MFA sem senha ou MFA resistente a phishing), o uso de estações de trabalho de acesso privilegiado (PAW) ou tempos de expiração de sessão mais curtos.\n\n**Ação de remediação**\n\n- [Adicionar, testar ou remover ações protegidas no Microsoft Entra ID](https://learn.microsoft.com/entra/identity/role-based-access-control/protected-actions-add?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21964",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": null,
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Habilitar ações protegidas para proteger a criação e alterações de políticas de Acesso Condicional"
    },
    {
      "TestResult": "\n❌ Default outbound B2B collaboration allows all users to access all applications in external organizations without governance.\n\n\n## [Configurações padrão de acesso entre locatários — colaboração B2B de saída](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/CompanyRelationshipsMenuBlade/~/CrossTenantAccessSettings)\n\n| Setting | Configured value | Expected value | Status |\n| :------ | :--------------- | :------------- | :----: |\n| É serviço padrão | true | false | ❌ |\n| Tipo de acesso de usuários e grupos | allowed | blocked | ❌ |\n| Destino de usuários e grupos | AllUsers | AllUsers | ✅ |\n| Tipo de acesso de aplicações | allowed | blocked | ❌ |\n| Destino de aplicações | AllApplications | AllApplications | ✅ |\n\r\n",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestStatus": "Failed",
      "TestRisk": "High",
      "TestCategory": "Identidades externas",
      "TestImpact": "High",
      "TestMinimumLicense": [
        "AAD_PREMIUM",
        "AAD_PREMIUM_P2"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "",
      "TestId": "25378",
      "TestTitle": "A colaboração externa é governada por políticas explícitas de acesso entre locatários",
      "TestDescription": "Quando as configurações padrão de colaboração B2B de saída permitem que todos os usuários acessem todas as aplicações em qualquer organização externa do Microsoft Entra, as organizações não conseguem controlar para onde os dados corporativos fluem ou com quem os funcionários colaboram. Os usuários podem carregar intencionalmente ou acidentalmente dados confidenciais em locatários externos, aceitar convites de locatários falsificados ou maliciosos criados para phishing, ou conceder consentimento OAuth a aplicações arriscadas que comprometem dados corporativos.\n\nPara indústrias regulamentadas, a colaboração externa irrestrita pode violar requisitos de residência de dados ou proibições de compartilhamento de dados com organizações não aprovadas.\n\nAo bloquear a colaboração B2B de saída padrão, as organizações aplicam uma postura de negar por padrão que restringe relacionamentos externos a parceiros aprovados, protege propriedade intelectual e garante visibilidade de cada colaboração entre locatários.\n\n**Ação de remediação**\n- Aprenda sobre configurações de acesso entre locatários e considerações de planejamento antes de fazer alterações. Para mais informações, veja [Visão geral de acesso entre locatários](https://learn.microsoft.com/entra/external-id/cross-tenant-access-overview?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Use o workbook de atividade de acesso entre locatários para identificar padrões atuais de colaboração externa antes de bloquear o acesso padrão. Para mais informações, veja [Workbook de atividade de acesso entre locatários](https://learn.microsoft.com/entra/identity/monitoring-health/workbook-cross-tenant-access-activity?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Configure as configurações padrão de colaboração B2B de saída para bloquear o acesso. Para mais informações, veja [Modificar configurações de acesso de saída](https://learn.microsoft.com/entra/external-id/cross-tenant-access-settings-b2b-collaboration?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#modify-outbound-access-settings).\n- Adicione configurações específicas de organização para locatários parceiros aprovados que requerem colaboração B2B. Para mais informações, veja [Adicionar uma organização](https://learn.microsoft.com/entra/external-id/cross-tenant-access-settings-b2b-collaboration?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#add-an-organization).\n- Atualize a política padrão de acesso entre locatários via Microsoft Graph API. Para mais informações, veja [Atualizar política padrão de acesso entre locatários](https://learn.microsoft.com/graph/api/crosstenantaccesspolicyconfigurationdefault-update?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\nSua organização depende fortemente da autenticação baseada em senha, criando vulnerabilidades de segurança.\n## Métodos de autenticação sem senha\n\n| Método | Estado | Alvos Incluídos | Modo de Autenticação | Status |\n| :----- | :---- | :-------------- | :------------------ | :----- |\n| FIDO2 Security Keys | ❌ Desativado | All users | N/A | ❌ Reprovado |\n| Microsoft Authenticator | ✅ Ativo | All users | ✅ any | ✅ Aprovado |\n\n",
      "TestDescription": "Organizações com extensas superfícies de senha voltadas ao usuário expõem múltiplos pontos de entrada para atores de ameaças lançarem ataques baseados em credenciais. Interações frequentes do usuário com prompts de senha em aplicativos, dispositivos e fluxos de trabalho aumentam o risco de exploração. Os invasores geralmente começam com o preenchimento de credenciais (credential stuffing) — usando credenciais comprometidas de violações de dados — seguido por pulverização de senhas (password spraying) para testar senhas comuns em várias contas. Uma vez obtido o acesso inicial, eles realizam a descoberta de credenciais examinando repositórios de senhas de navegadores, credenciais em cache na memória e gerenciadores de credenciais para coletar materiais de autenticação adicionais. Essas credenciais roubadas permitem a movimentação lateral, permitindo que os invasores acessem mais sistemas e aplicativos, frequentemente escalando privilégios ao visar contas administrativas que ainda dependem de autenticação por senha. Na fase de persistência, os invasores podem criar contas de \"backdoor\" com acesso baseado em senha ou enfraquecer as defesas alterando as políticas de senha. Para evitar a detecção, eles aproveitam canais de autenticação legítimos, misturando-se à atividade normal do usuário enquanto mantêm acesso persistente aos recursos organizacionais.\n\n**Ação de correção**\n\n * [Habilitar métodos de autenticação sem senha (passwordless)](https://learn.microsoft.com/en-us/entra/identity/authentication/how-to-plan-prerequisites-phishing-resistant-passwordless-authentication)\n\n * [Implantar chaves de segurança FIDO2](https://learn.microsoft.com/en-us/entra/identity/authentication/how-to-enable-passkey-fido2)\n\n",
      "TestImplementationCost": "Medium",
      "TestId": "21889",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Reduzir a superfície de exposição de senhas visível ao usuário"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Dados",
      "SkippedReason": null,
      "TestResult": "\nNenhum perfil de Wi-Fi Empresarial para iOS existe ou nenhum está atribuído.\n\n\n",
      "TestDescription": "Se os perfis de Wi-Fi não estiverem devidamente configurados e atribuídos, os usuários podem se conectar de forma insegura ou não conseguir se conectar a redes confiáveis, expondo dados corporativos à interceptação ou acesso não autorizado. Sem gerenciamento centralizado, os dispositivos dependem de configuração manual, aumentando o risco de má configuração, autenticação fraca e conexão a redes maliciosas.\n\nGerenciar centralmente os perfis de Wi-Fi para dispositivos iOS no Intune garante conectividade segura e consistente com redes empresariais. Isso aplica padrões de autenticação e criptografia, simplifica a integração e apoia o Zero Trust ao reduzir a exposição a redes não confiáveis.\n\n**Ação de remediação**\n\nUse o Intune para configurar e atribuir perfis de Wi-Fi seguros para dispositivos iOS/iPadOS a fim de aplicar padrões de autenticação e criptografia:\n\n- [Implantar perfis de Wi-Fi em dispositivos no Microsoft Intune](https://learn.microsoft.com/intune/intune-service/configuration/wi-fi-settings-configure?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-the-profile)\n\nPara mais informações, veja:  \n- [Revisar as configurações de Wi-Fi disponíveis para dispositivos iOS e iPadOS no Microsoft Intune](https://learn.microsoft.com/intune/intune-service/configuration/wi-fi-settings-ios?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "24839",
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Perfis de Wi-Fi seguros protegem dispositivos iOS contra acesso de rede não autorizado"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\n[Usuários não administradores podem recuperar chaves do BitLocker para seus dispositivos próprios](https://entra.microsoft.com/#view/Microsoft_AAD_Devices/DevicesMenuBlade/~/DeviceSettings/menuId/Overview)\n",
      "TestDescription": "Quando usuários não administradores podem acessar suas próprias chaves do BitLocker, agentes de ameaça que comprometem credenciais de usuários ganham acesso direto às chaves de criptografia sem exigir escalonamento de privilégios. Uma vez que os atacantes obtêm as chaves do BitLocker, eles podem descriptografar dados sensíveis armazenados no dispositivo, incluindo credenciais em cache, bancos de dados locais e arquivos confidenciais.\n\nSem as restrições adequadas, uma única conta de usuário comprometida fornece acesso imediato a todos os dados criptografados naquele dispositivo, anulando o principal benefício de segurança da criptografia de disco e criando um caminho para movimentação lateral.\n\n**Ação de remediação**\n\n- [Restringir usuários não administradores de recuperar as chaves do BitLocker para seus dispositivos próprios](https://learn.microsoft.com/entra/identity/devices/manage-device-identities?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#configure-device-settings)\n",
      "TestImplementationCost": "Low",
      "TestId": "21954",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Restringir usuários não administradores de recuperar as chaves do BitLocker para seus dispositivos próprios"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma política de FileVault encontrada ou atribuída.\n\n\n",
      "TestDescription": "Sem políticas de criptografia FileVault devidamente configuradas e atribuídas no Intune, os agentes de ameaças podem explorar o acesso físico a dispositivos macOS não gerenciados ou mal configurados para extrair dados corporativos sensíveis. Dispositivos não criptografados permitem que invasores ignorem a segurança no nível do sistema operacional, inicializando a partir de mídia externa ou removendo a unidade de armazenamento. Esses ataques podem expor credenciais, certificados e tokens de autenticação em cache, permitindo a escalada de privilégios e a movimentação lateral. Além disso, dispositivos não criptografados prejudicam a conformidade com as regulamentações de proteção de dados e aumentam o risco de danos à reputação e penalidades financeiras em caso de violação.\n\nA aplicação dA criptografia do FileVault protege os dados em repouso em dispositivos macOS, mesmo se perdidos ou roubados. Isso interrompe a colheita de credenciais e a movimentação lateral, apoia a conformidade regulatória e alinha-se aos princípios de Zero Trust de confiança do dispositivo.\n\n**Ação de correção**\n\nUse o Intune para aplicar A criptografia do FileVault e monitorar a conformidade em todos os dispositivos macOS gerenciados:\n- [Criar uma política de criptografia de disco FileVault para macOS no Intune](https://learn.microsoft.com/intune/intune-service/protect/encrypt-devices-filevault?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-endpoint-security-policy-for-filevault)\n- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)\n- [Monitorar a criptografia do dispositivo com o Intune](https://learn.microsoft.com/intune/intune-service/protect/encryption-monitor?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24569",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "A criptografia do FileVault protege os dados em dispositivos macOS"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Investigar",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\nO [número máximo de dispositivos por usuário](https://entra.microsoft.com/#view/Microsoft_AAD_Devices/DevicesMenuBlade/~/DeviceSettings/menuId/Overview) está definido como 20. Considere reduzir para 10 ou menos.\n",
      "TestDescription": "Controlar a proliferação de dispositivos é importante. Defina um limite razoável para o número de dispositivos que cada usuário pode registrar em seu tenant do Microsoft Entra ID. Limitar o registro de dispositivos mantém a segurança enquanto permite flexibilidade comercial. O Microsoft Entra ID permite que os usuários registrem até 50 dispositivos por padrão. Reduzir esse número para 10 minimiza a superfície de ataque e simplifica o gerenciamento de dispositivos.\n\n**Ação de correção**\n\n- Saiba como [limitar o número máximo de dispositivos por usuário](https://learn.microsoft.com/entra/identity/devices/manage-device-identities?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#configure-device-settings).\n",
      "TestImplementationCost": "Low",
      "TestId": "21837",
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Limitar o número máximo de dispositivos por usuário para 10"
    },
    {
      "TestResult": "\n⚠️ Nenhum aplicativo Private Access por aplicativo configurado. Revise a documentação sobre como configurar aplicativos Private Access com segmentos de rede granulares.\n\n\n## Resumo\n\n| Métrica | Valor |\n|---|---|\n| Total de aplicativos Private Access | 0 |\n| Aplicativos com segmentos amplos | 0 |\n| Aplicativos com CSA atribuído | 0 |\n| Aplicativos sem CSA | 0 |\n| Políticas de CA usando applicationFilter | 0 |\n\n\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Investigate",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "High",
      "TestSkipped": "",
      "TestId": "25395",
      "TestTitle": "Os segmentos de aplicação do Entra Private Access são definidos para aplicar o acesso de menor privilégio",
      "TestDescription": "Quando as organizações configuram o Microsoft Entra Private Access com segmentos de aplicativo amplos, como grandes intervalos de IP, vários protocolos ou configurações de Quick Access, elas efetivamente replicam o modelo de acesso excessivamente permissivo de VPNs tradicionais. Essa abordagem contraria o princípio Zero Trust do menor privilégio, em que os usuários devem alcançar apenas os recursos específicos necessários para sua função.\n\nRiscos da segmentação ampla:\n\n- Agentes de ameaça que comprometem as credenciais ou o dispositivo de um usuário podem usar permissões de rede amplas para realizar reconhecimento, identificando outros sistemas e serviços dentro do intervalo permitido.\n- O movimento lateral torna-se mais fácil, pois os atacantes podem acessar vários sistemas com uma única credencial comprometida.\n- A resposta a incidentes fica mais complicada porque as equipes de segurança não conseguem determinar rapidamente quais recursos específicos uma identidade comprometida poderia acessar.\n\nConfigurar segmentação por aplicativo com hosts de destino estreitamente definidos, portas específicas e Custom Security Attributes permite aplicação dinâmica de Conditional Access. Essa abordagem exige autenticação mais forte ou conformidade de dispositivo para aplicativos de alto risco, enquanto simplifica o acesso a recursos de menor risco.\n\n**Ação de remediação**\n\n- [Revise e refine os segmentos de aplicativo](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-per-app-access?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para usar FQDNs específicos, endereços IP e intervalos de portas específicos que correspondam aos requisitos do aplicativo, em vez de intervalos de portas amplos.\n",
      "SkippedReason": null
    },
    {
      "TestResult": "\n⚠️ Nenhum aplicativo do Private Access está configurado no tenant, revise a documentação sobre como ativar os aplicativos do Private Access.\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Investigate",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "25481",
      "TestTitle": "Todos os aplicativos de Private Access têm atribuições de usuários ou grupos",
      "TestDescription": "Quando os aplicativos do Microsoft Entra Private Access carecem de atribuições de usuário ou grupo, os usuários não conseguem estabelecer túneis através do aplicativo para alcançar os nomes de domínio totalmente qualificados (FQDNs) e endereços IP configurados. Essa restrição impede o acesso aos recursos internos protegidos. Sem atribuições, as organizações não conseguem impor políticas do Conditional Access porque essas políticas exigem relações explícitas de usuário para aplicação para avaliar sinais de risco, conformidade de dispositivo e requisitos de força de autenticação.\n\nSem atribuições de usuário em aplicações do Private Access:\n\n- As organizações perdem a capacidade de impor controles de acesso com o menor privilégio em que os usuários obtêm acesso apenas aos recursos específicos de que precisam.\n- As organizações não conseguem aplicar políticas de acesso baseadas em risco que bloqueiam ou desafiam a autenticação com base no risco de entrada, risco do usuário ou conformidade do dispositivo.\n- Os sinais de proteção de identidade que detectam comprometimento de credenciais, viagem impossível ou endereços IP anônimos não conseguem proteger recursos privados.\n\n**Ação de remediação**\n\n- [Atribua usuários e grupos aos aplicativos do Private Access](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-per-app-access?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-users-and-groups) para ativar os controles de acesso Zero Trust e a imposição do Conditional Access.\n",
      "SkippedReason": null
    },
    {
      "TestResult": "\n⚠️ Nenhum aplicativo Quick Access está configurado. Revise a documentação para habilitar o Quick Access se necessário.\n\n\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Investigate",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "25394",
      "TestTitle": "O Quick Access está vinculado a uma política de Conditional Access",
      "TestDescription": "Quando você configura o Quick Access no Microsoft Entra Private Access sem políticas de Conditional Access, agentes de ameaça que comprometem credenciais de usuário obtêm acesso irrestrito a recursos privados. O aplicativo Quick Access serve como um contêiner para recursos privados, incluindo FQDNs e endereços IP.\n\nSem aplicação de políticas:\n\n- Contas comprometidas fornecem um caminho direto para sistemas internos.\n- Agentes de ameaça operando a partir de dispositivos não gerenciados ou locais anômalos podem acessar recursos privados de forma indistinguível dos usuários autorizados.\n- Movimento lateral pela rede interna e exfiltração de dados de aplicativos privados se tornam possíveis.\n- Requisitos de autenticação multifator e verificações de integridade do dispositivo não podem ser aplicados.\n\n**Ação de remediação**\n\n- [Aplique políticas de Conditional Access aos aplicativos Microsoft Entra Private Access](https://learn.microsoft.com/entra/global-secure-access/how-to-target-resource-private-access-apps?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Acesso privilegiado",
      "SkippedReason": null,
      "TestResult": "\nAs atribuições de funções são gerenciadas pelo PIM.\n\n## Atribuições Permanentes de Administrador Global\n\n| Nome | UPN | Tipo | Sincronizado Local |\n| :--- | :--- | :--- | :--- |\n\n",
      "TestDescription": "Atores de ameaça que comprometem contas privilegiadas atribuídas permanentemente ganham acesso contínuo a operações de diretório de alto impacto. Esse acesso estendido permite que os invasores estabeleçam backdoors persistentes, modifiquem configurações de segurança e desativem sistemas de monitoramento. Sem controles de acesso limitados por tempo, as contas privilegiadas comprometidas fornecem controle indefinido do tenant.\n\nExigir que as atribuições de funções qualificadas sejam ativadas just-in-time reduz a superfície de ataque e limita o tempo de permanência do invasor.\n\n**Ação de correção**\n\n- [Use o Privileged Identity Management para gerenciar funções privilegiadas do Microsoft Entra](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-getting-started?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21816",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P2",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Todas as atribuições de funções privilegiadas do Microsoft Entra são gerenciadas com PIM"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Passed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\n✅ Pelo menos uma política de conformidade para Windows foi encontrada e atribuída.\n\n",
      "TestDescription": "Se as políticas de conformidade para dispositivos Windows não estiverem configuradas e atribuídas, os agentes de ameaças podem explorar endpoints não gerenciados ou não conformes para obter acesso não autorizado a recursos corporativos, burlar controles de segurança e estabelecer persistência no ambiente. Sem a conformidade aplicada, os dispositivos podem carecer de configurações críticas de segurança, como criptografia BitLocker, requisitos de senha, configurações de firewall e controles de versão do SO. Essas lacunas aumentam o risco de vazamento de dados, escalonamento de privilégios e movimentação lateral. A conformidade inconsistente dos dispositivos enfraquece a postura de segurança da organização e torna mais difícil detectar e remediar ameaças antes que ocorram danos significativos.\n\nA aplicação de políticas de conformidade garante que os dispositivos Windows atendam aos requisitos básicos de segurança e apoia o modelo Zero Trust, validando a integridade do dispositivo e reduzindo a exposição a endpoints mal configurados.\n\n**Ação de correção**\n\nCrie e atribua políticas de conformidade do Intune para dispositivos Windows para aplicar os padrões organizacionais de acesso e gerenciamento seguros:\n- [Criar e atribuir políticas de conformidade do Intune](https://learn.microsoft.com/intune/intune-service/protect/create-compliance-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-the-policy)\n- [Revisar as configurações de conformidade do Windows que você pode gerenciar com o Intune](https://learn.microsoft.com/intune/intune-service/protect/compliance-policy-create-windows?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24541",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Políticas de conformidade protegem dispositivos Windows"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\nResultados da verificação de registro de dispositivos.\n\n\n",
      "TestDescription": "Atores de ameaça podem explorar a falta de autenticação multifator durante o registro de novos dispositivos. Uma vez autenticados, eles podem registrar dispositivos não autorizados, estabelecer persistência e contornar controles de segurança vinculados a endpoints confiáveis. Essa posição permite que os invasores exfiltrem dados sensíveis, implantem aplicativos maliciosos ou se movam lateralmente, dependendo das permissões das contas que estão sendo usadas pelo invasor. Sem a imposição de MFA, o risco aumenta à medida que os adversários podem se reautenticar continuamente, escapar da detecção e executar seus objetivos.\n\n**Ação de correção**\n\n- [Implantar uma política de Acesso Condicional para exigir autenticação multifator para o registro de dispositivos](https://learn.microsoft.com/entra/identity/conditional-access/policy-all-users-device-registration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "TestImplementationCost": "Low",
      "TestId": "21872",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Exigir autenticação multifator para ingresso e registro de dispositivos por meio de ação do usuário"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\nA transferência de autenticação está configurada corretamente para ser bloqueada.\n\n## Políticas de Acesso Condicional Detectadas\n\n| Nome da Política | ID | Estado |\n| :--- | :--- | :--- |\n\n",
      "TestDescription": "Bloquear a transferência de autenticação no Microsoft Entra ID é um controle de segurança crítico. Ele ajuda a proteger contra roubo de token e ataques de replay, impedindo o uso de tokens de dispositivo para autenticação silenciosa em outros dispositivos ou navegadores. Quando a transferência de autenticação está habilitada, um ator de ameaça que ganha acesso a um dispositivo pode acessar recursos em dispositivos não aprovados, ignorando a autenticação padrão e as verificações de conformidade do dispositivo. Quando os administradores bloqueiam esse fluxo, as organizações garantem que cada solicitação de autenticação deve se originar do dispositivo original, mantendo a integridade da conformidade do dispositivo e o contexto da sessão do usuário.\n\n**Ação de correção**\n\n- [Implantar uma política de Acesso Condicional para bloquear a transferência de autenticação](https://learn.microsoft.com/entra/identity/conditional-access/policy-block-authentication-flows?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#authentication-transfer-policies)\n",
      "TestImplementationCost": "Low",
      "TestId": "21828",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Transferência de autenticação está bloqueada"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\nO fluxo de trabalho de consentimento do administrador está habilitado.\n\n\n",
      "TestDescription": "Habilitar o fluxo de trabalho de consentimento do administrador em um tenant do Microsoft Entra é uma medida de segurança vital que mitiga riscos associados ao acesso não autorizado a aplicativos e escalonamento de privilégios. Esta verificação garante que qualquer aplicativo que solicite permissões elevadas passe por um processo de revisão por administradores designados antes que o consentimento seja concedido. Se este fluxo estiver desabilitado, qualquer aplicativo pode solicitar e potencialmente receber permissões elevadas sem revisão administrativa, o que representa um risco substancial.\n\n**Ação de remediação**\n\nPara solicitações de consentimento, defina a configuração **Usuários podem solicitar consentimento do administrador para aplicativos aos quais não podem consentir** como **Sim**. Especifique quem pode revisar as solicitações.\n\n- [Habilitar o fluxo de trabalho de consentimento do administrador](https://learn.microsoft.com/entra/identity/enterprise-apps/configure-admin-consent-workflow?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enable-the-admin-consent-workflow)\n",
      "TestImplementationCost": "Low",
      "TestId": "21809",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Fluxo de trabalho de consentimento do administrador está habilitado"
    },
    {
      "TestResult": "\n✅ Todos os perfis de encaminhamento de tráfego estão habilitados. O tráfego de rede está sendo capturado e protegido pelo Security Service Edge da Microsoft.\n\n\n## Perfis de encaminhamento de tráfego\n\n[Abrir perfis de encaminhamento de tráfego no portal Entra](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/ForwardingProfile.ReactView)\n\n| Tipo de tráfego | Nome | Estado |\n| :----------- | :--- | :---- |\n| Microsoft 365 | Microsoft 365 traffic forwarding profile | ✅ enabled |\n| Acesso privado | Private access traffic forwarding profile | ✅ enabled |\n| Acesso à Internet | Internet traffic forwarding profile | ✅ enabled |\n\r\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Passed",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access",
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "",
      "TestId": "25381",
      "TestTitle": "O tráfego de rede é roteado pelo Global Secure Access para aplicação de políticas de segurança",
      "TestDescription": "Os perfis de encaminhamento de tráfego são o mecanismo fundamental pelo qual o Global Secure Access captura e roteia o tráfego de rede para a infraestrutura Security Service Edge da Microsoft. Se você não habilitar os perfis de encaminhamento de tráfego apropriados, o tráfego de rede contorna completamente o serviço Global Secure Access, e os usuários não recebem essas proteções de acesso à rede.\n\nExistem três perfis distintos:\n\n- **Perfil de tráfego Microsoft**: captura Microsoft Entra ID, Microsoft Graph, SharePoint Online, Exchange Online e outras cargas de trabalho do Microsoft 365.\n- **Perfil de acesso privado**: captura tráfego destinado a recursos corporativos internos.\n- **Perfil de acesso à internet**: captura tráfego para internet pública, incluindo aplicações SaaS não Microsoft.\n\nSe você não habilitar esses perfis:\n\n- Você não pode aplicar políticas de segurança, filtragem de conteúdo da web, proteção contra ameaças ou Universal Continuous Access Evaluation.\n- Agentes de ameaça que comprometem credenciais de usuário podem acessar recursos corporativos sem os controles de segurança que o Global Secure Access aplicaria.\n\n**Ação de remediação**\n\n- Habilite o perfil de encaminhamento de tráfego Microsoft. Para mais informações, veja [Gerenciar o perfil de tráfego Microsoft](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-microsoft-profile?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Habilite o perfil de encaminhamento de tráfego Private Access. Para mais informações, veja [Gerenciar o perfil de encaminhamento de tráfego Private Access](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-private-access-profile?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Habilite o perfil de encaminhamento de tráfego Internet Access. Para mais informações, veja [Gerenciar o perfil de encaminhamento de tráfego Internet Access](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-internet-access-profile?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": null,
      "TestResult": "\n✅ **Passou**: Este tenant não está sincronizado com um ambiente local.\n",
      "TestDescription": "Quando a proteção de senha local (on-premises) não está habilitada ou imposta, atores de ameaça podem usar ataques de password spray do tipo \"low-and-slow\" com variantes comuns, como estação+ano+símbolo ou termos locais, para obter acesso inicial a contas do Active Directory Domain Services. Os Controladores de Domínio (DCs) podem aceitar senhas fracas quando qualquer uma das seguintes afirmações for verdadeira:\n\n- O agente do Microsoft Entra Password Protection para DC não está instalado.\n- A configuração de proteção de senha do tenant está desabilitada ou em modo apenas de auditoria.\n\nCom credenciais locais válidas, os atacantes se movem lateralmente reutilizando senhas entre endpoints, escalam para administrador de domínio através da reutilização de admin local ou contas de serviço e persistem adicionando backdoors; enquanto isso, a imposição fraca ou desabilitada produz menos eventos de bloqueio e sinais previsíveis. O design da Microsoft requer um proxy que faça a mediação da política do Microsoft Entra ID e um agente de DC que imponha as listas de banidos globais e personalizadas do tenant combinadas na alteração/redefinição de senha; a imposição consistente requer cobertura do agente de DC em todos os DCs de um domínio e o uso do modo Imposto (Enforced) após a avaliação da auditoria.\n\n**Ação de remediação**\n\n- [Implantar o Microsoft Entra password protection](https://learn.microsoft.com/entra/identity/authentication/howto-password-ban-bad-on-premises-deploy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21847",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "A proteção de senha para ambientes locais está habilitada"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "SharePoint Online",
      "SkippedReason": null,
      "TestResult": "\n✅ Os rótulos de sensibilidade estão habilitados no SharePoint Online e OneDrive, permitindo que os usuários classifiquem e protejam documentos armazenados nesses serviços.\n\n### Resumo da Configuração do SharePoint Online\n\n**Configurações de Locaário:**\n* EnableAIPIntegration: True\n\n[Gerenciar Proteção de Informações no Centro de Administração do SharePoint](https://admin.microsoft.com/sharepoint?page=classicSettings&modern=true)\n\n",
      "TestDescription": "Quando a integracao de rotulos de sensibilidade esta desabilitada (padrao) no SharePoint, os arquivos no SharePoint e no OneDrive nao podem ser rotulados nem exibir rotulos existentes, e nao se beneficiam da protecao adicional de rotulos de sensibilidade que aplicam criptografia. Essa lacuna de protecao deixa arquivos sensiveis sem classificacao e vulneraveis a acesso nao autorizado e compartilhamento externo.\n\nHabilitar rotulos de sensibilidade no SharePoint permite que os usuarios apliquem rotulos usando o Office para a Web e o SharePoint. Isso tambem e um requisito para rotulagem padrao nesses locais e para politicas de rotulagem automatica que classificam arquivos automaticamente. Rotulos de sensibilidade nesses arquivos tambem podem fortalecer a seguranca para o Microsoft 365 Copilot e ser usados com politicas de prevencao contra perda de dados e outras solucoes do Microsoft Purview.\n\n**Ação de remediação**\n\n- [Habilitar rotulos de sensibilidade para arquivos no SharePoint e no OneDrive](https://learn.microsoft.com/purview/sensitivity-labels-sharepoint-onedrive-files?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "35005",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "MIP_P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Os rótulos de sensibilidade estão habilitados para SharePoint e OneDrive"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\nO fluxo de trabalho de aprovação está configurado para o Administrador Global.\n\n## Ativação da função de Administrador Global e fluxo de trabalho de aprovação\n\n| Aprovação Necessária | Aprovadores Primários | Aprovadores de Escalonamento |\n| :--- | :--- | :--- |\n\n",
      "TestDescription": "Sem fluxos de trabalho de aprovação, atores de ameaça que comprometem credenciais de Administrador Global por meio de phishing, preenchimento de credenciais ou outras técnicas de desvio de autenticação podem ativar imediatamente a função mais privilegiada em um tenant sem qualquer outra verificação ou supervisão. O Privileged Identity Management (PIM) permite que as ativações de funções qualificadas tornem-se ativas em segundos, de modo que credenciais comprometidas podem permitir escalonamento de privilégios quase instantâneo. Uma vez ativado, os atores de ameaça podem usar a função de Administrador Global para seguir os seguintes caminhos de ataque para obter acesso persistente ao tenant:\n- Criar novas contas privilegiadas\n- Modificar políticas de Acesso Condicional para excluir essas novas contas\n- Estabelecer métodos alternativos de autenticação, como autenticação baseada em certificado ou registros de aplicativos com privilégios elevados\n\nA função de Administrador Global fornece acesso a recursos administrativos no Microsoft Entra ID e serviços que usam identidades do Microsoft Entra, incluindo Microsoft Defender XDR, Microsoft Purview, Exchange Online e SharePoint Online. Sem portões de aprovação, atores de ameaça podem escalar rapidamente para o controle total do tenant, exfiltrando dados confidenciais, comprometendo todas as contas de usuário e estabelecendo backdoors de longo prazo por meio de modificações de entidades de serviço ou federação que persistem mesmo após o comprometimento inicial ser detectado.\n\n**Ação de correção**\n\n- [Configure as definições de função para exigir aprovação para ativação do Administrador Global](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-how-to-change-default-settings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Configure o fluxo de trabalho de aprovação para funções privilegiadas](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-approval-workflow?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21817",
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P2",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "A ativação da função de Administrador Global aciona um fluxo de trabalho de aprovação"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de Credenciais",
      "SkippedReason": null,
      "TestResult": "\n✅ O aplicativo RMS é permitido (ou não restrito) nas configurações de política de acesso entre locaários para acesso de entrada e saída.\n\n### Configuração de Política de Acesso Entre Locaários (XTAP)\n\n| Política | Direção | Status | Detalhes |\n|:---|:---|:---|:---|\n| Default | Inbound | ✅ Allowed | B2B Collaboration |\n| Default | Outbound | ✅ Allowed | B2B Collaboration |\n\n\n\n",
      "TestDescription": "Quando seus usuarios enviam ou compartilham arquivos ou emails criptografados com pessoas fora da organizacao, ou recebem conteudo criptografado de parceiros, o Microsoft Entra ID precisa verificar identidades. Essa verificacao ocorre em ambos os lados do envio e do recebimento para aplicar as configuracoes de criptografia. Se as configuracoes de acesso entre locatarios bloquearem o acesso ao servico Azure Rights Management, esses usuarios verao o erro \"Access is blocked by your organization\". Nesse cenario, eles nao conseguem abrir o conteudo protegido.\n\nPermita o aplicativo Microsoft Rights Management Services configurando as definicoes de acesso entre locatarios para trafego de entrada (usuarios externos abrindo conteudo que voce compartilha) e de saida (seus usuarios abrindo conteudo de parceiros). Sem essa configuracao, o compartilhamento de conteudo criptografado falha, mesmo quando as permissoes corretas estao atribuidas.\n\n**Ação de remediação**\n\n- [Configuracoes de acesso entre locatarios e conteudo criptografado](https://learn.microsoft.com/purview/encryption-azure-ad-configuration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#cross-tenant-access-settings-and-encrypted-content)\n- [Configurar acesso entre locatarios para colaboracao B2B](https://learn.microsoft.com/entra/external-id/cross-tenant-access-settings-b2b-collaboration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "35002",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E5",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "As configurações de acesso entre locatários estão configuradas para permitir o compartilhamento de conteúdo criptografado"
    },
    {
      "TestResult": "\n✅ As funções GA/GSA são limitadas a usuários Membro habilitados e avaliados; nenhum grupo, convidado, service principal ou conta desabilitada está atribuído, e as contagens de atribuição estão dentro dos limites aprovados.\n\n\n## [Global Administrator — Atribuições](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/RolesManagementMenuBlade/~/AllRoles)\n\n**ID da definição de função**: 62e90394-69f5-4237-9190-012177145e10  \n**Contagem total de atribuições**: 0  \n**Contagem de atribuições válidas**: 0  \n**Contagem de problemas**: 0  \n\n\n## [Global Secure Access Administrator — Atribuições](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/RolesManagementMenuBlade/~/AllRoles)\n\n**ID da definição de função**: ac434307-12b9-4fa1-a708-88bf58caabc1  \n**Contagem total de atribuições**: 0  \n**Contagem de atribuições válidas**: 0  \n**Contagem de problemas**: 0  \n\n\r\n",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestStatus": "Passed",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "AAD_PREMIUM",
        "AAD_PREMIUM_P2"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "25383",
      "TestTitle": "Os privilégios administrativos são rigidamente limitados para evitar comprometimento",
      "TestDescription": "A atribuição excessiva de funções como Global Administrator e Global Secure Access Administrator cria um caminho para agentes de ameaça comprometerem essas identidades. Com essas funções, um invasor pode autenticar, manipular políticas de segurança, criar ou elevar contas, desabilitar a monitoração, acessar todos os dados corporativos e mais. Limite o acesso a essas funções a um pequeno conjunto de administradores e habilite o monitoramento de atribuições e ativações para grupos, convidados, service principals e contas desabilitadas para reduzir a superfície de ataque e aplicar o princípio do menor privilégio.\n\n**Ação de remediação**\n\n- [Contas de acesso de emergência estão configuradas adequadamente](https://learn.microsoft.com/entra/fundamentals/zero-trust-protect-engineering-systems?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#emergency-access-accounts-are-configured-appropriately)\n- [Limite as atribuições das funções Global Administrator e Global Secure Access Administrator a um pequeno conjunto de administradores](https://learn.microsoft.com/entra/fundamentals/zero-trust-protect-identities?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#high-global-administrator-to-privileged-user-ratio)\n- [Configure as configurações de função para exigir aprovação para ativação de Global Administrator](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-how-to-change-default-settings?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": null
    },
    {
      "TestResult": "\nOs perfis de encaminhamento de tráfego estão direcionados adequadamente.\n\n\n## Resumo dos perfis de encaminhamento de tráfego\n\n- **Perfis totais:** 3\n- **Perfis habilitados:** 3\n- **Perfis desabilitados:** 0\n\n## [Perfis de encaminhamento de tráfego](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/ForwardingProfile.ReactView)\n\n| Nome do perfil | Tipo | Estado | Contagem de redes remotas | Usuários | Grupos | Escopo de atribuição |\n| :----------- | :--- | :---- | :-------------- | :---- | :----- | :--------------- |\n| Microsoft 365 traffic forwarding profile | Microsoft 365 | ✅ Habilitado | 0 | 1 | 0 | [Específico (1)](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Users/objectId/dc2f7ff2-4b20-445b-a496-648e43089b4f/appId/225f62ff-2cfe-4a36-a05d-8fabcd0214b1/preferredSingleSignOnMode~/null/servicePrincipalType/Application/fromNav/) |\n| Internet traffic forwarding profile | Internet | ✅ Habilitado | 0 | 1 | 0 | [Específico (1)](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Users/objectId/fddf4c37-682d-4810-a4fe-063998df7b33/appId/427c5187-dd58-4f4a-9e7c-c447e1c61a0c/preferredSingleSignOnMode~/null/servicePrincipalType/Application/fromNav/) |\n| Private access traffic forwarding profile | Acesso privado | ✅ Habilitado | 0 | 1 | 0 | [Específico (1)](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Users/objectId/15d1ece8-440c-4575-9910-cb329872005b/appId/839dba54-455e-4dcc-9a24-30d492304369/preferredSingleSignOnMode~/null/servicePrincipalType/Application/fromNav/) |\n\r\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Passed",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Internet_Access",
        "Entra_Premium_Private_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "25382",
      "TestTitle": "Perfis de encaminhamento de tráfego são direcionados a usuários e grupos apropriados para implantação controlada",
      "TestDescription": "Sem o escopo adequado dos perfis de encaminhamento de tráfego, as organizações correm o risco de expor todos os usuários aos controles de segurança antes que a infraestrutura esteja pronta ou de excluir inadvertidamente usuários que deveriam ser protegidos.\n\nRiscos de escopo inadequado:\n\n- **Muito amplo**: quando os perfis são atribuídos a \"todos os usuários\" sem planejamento deliberado, uma configuração incorreta pode interromper a conectividade de rede de toda a organização simultaneamente.\n- **Muito estreito**: se os perfis forem escopados de forma muito estreita ou as atribuições forem incompletas, um subconjunto de usuários opera fora do perímetro de segurança, criando lacunas que agentes de ameaça podem explorar.\n- **Acesso não monitorado**: invasores que comprometem dispositivos de usuários não atribuídos podem acessar recursos sem que o tráfego seja inspecionado, registrado ou sujeito a políticas de segurança.\n\nUm escopo adequado garante implantação controlada — começando por grupos pilotos para validar a funcionalidade e depois expandindo para populações mais amplas — enquanto mantém visibilidade sobre quais usuários estão protegidos.\n\n**Ação de remediação**\n\n- Atribua usuários e grupos aos perfis de encaminhamento de tráfego. Para mais informações, veja [Gerenciar atribuição de usuários e grupos](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-users-groups-assignment?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\nNenhum usuário convidado foi encontrado em funções de diretório altamente privilegiadas.\n\n\n",
      "TestDescription": "Quando usuários convidados são atribuídos a funções de diretório altamente privilegiadas, como Administrador Global ou Administrador de Funções Privilegiadas, as organizações criam vulnerabilidades de segurança significativas que os agentes de ameaças podem explorar para acesso inicial por meio de contas externas comprometidas ou ambientes de parceiros de negócios. Como os usuários convidados são originários de organizações externas sem controle direto das políticas de segurança, os agentes de ameaças que comprometem essas identidades externas podem obter acesso privilegiado ao tenant (tenant) do Microsoft Entra da organização visada.\n\nQuando os agentes de ameaças obtêm acesso por meio de contas de convidados comprometidas com privilégios elevados, eles podem escalar seus próprios privilégios para criar outras contas de backdoor, modificar políticas de segurança ou atribuir a si mesmos funções permanentes na organização. As contas de convidados privilegiadas comprometidas permitem que os agentes de ameaças estabeleçam persistência e façam todas as alterações necessárias para permanecerem indetectados. Por exemplo, eles poderiam criar contas apenas na nuvem, contornar políticas de Acesso Condicional aplicadas a usuários internos e manter o acesso mesmo depois que a organização de origem do convidado detectasse o comprometimento. Os agentes de ameaças podem, então, realizar movimentos laterais usando privilégios administrativos para acessar recursos sensíveis, modificar configurações de auditoria ou desativar o monitoramento de segurança em todo o tenant. Os agentes de ameaças podem atingir o comprometimento total da infraestrutura de identidade da organização, mantendo a negação plausível por meio da origem da conta de convidado externa.\n\n**Ação de correção**\n\n- [Remover usuários convidados de funções privilegiadas](https://learn.microsoft.com/entra/identity/role-based-access-control/best-practices?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "22128",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Usuários convidados não possuem funções de diretório altamente privilegiadas atribuídas"
    },
    {
      "TestResult": "\n✅ O Universal CAE está habilitado para o Global Secure Access.\n\n\n## [Status do Global Secure Access](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/Welcome.ReactView)\n\n**Status de sinalização**: ✅ Habilitado\n\n## [Perfis de tráfego ativos](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/TrafficForwarding.ReactView)\n\n| Nome | Status | Tipo de Tráfego |\n| :--- | :--- | :--- |\n| Internet traffic forwarding profile | Enabled | internet |\n| Microsoft 365 traffic forwarding profile | Enabled | m365 |\n| Private access traffic forwarding profile | Enabled | private |\n\n## [Políticas que desabilitam a Avaliação Contínua de Acesso](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/Policies)\n\nNenhuma política de Conditional Access que desabilite a Avaliação Contínua de Acesso foi encontrada.\n\n\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Passed",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access",
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "25371",
      "TestTitle": "A validação de rede é configurada por meio da Avaliação Contínua de Acesso Universal",
      "TestDescription": "A Avaliação Contínua de Acesso Universal (Universal CAE) valida os tokens de acesso à rede toda vez que uma conexão é estabelecida por túneis do Global Secure Access. Sem o Universal CAE, os tokens permanecem válidos por 60 a 90 minutos, independentemente das alterações no estado do usuário.\n\nSem essa proteção:\n\n- Um agente de ameaça que obtém um token por roubo ou repetição pode continuar acessando todos os recursos protegidos pelo Global Secure Access mesmo após a conta do usuário ser desativada ou a senha ser redefinida.\n- Eventos críticos como revogação de sessão ou detecção de alto risco do usuário não acionam reautenticação imediata.\n- Funcionários que saem ou insiders maliciosos mantêm acesso em nível de rede a recursos corporativos privados por até 90 minutos após a ação de remediação.\n- Ataques de repetição de token a partir de IPs diferentes não são bloqueados sem o modo de Aplicação Rigorosa.\n\n**Ação de remediação**\n- Revise os recursos do [Universal CAE](https://learn.microsoft.com/entra/global-secure-access/concept-universal-continuous-access-evaluation?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para o Global Secure Access.\n- Remova ou modifique políticas de Conditional Access que desabilitam o CAE para cargas de trabalho do Global Secure Access. Para mais informações, veja [Avaliação contínua de acesso](https://learn.microsoft.com/entra/identity/conditional-access/concept-continuous-access-evaluation?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Configure o Universal CAE para usar o modo de Aplicação Rigorosa para proteção aprimorada contra repetição de token. Para mais informações, veja [Avaliação Contínua de Acesso Universal](https://learn.microsoft.com/entra/global-secure-access/concept-universal-continuous-access-evaluation?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#strict-enforcement-mode).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": null,
      "TestResult": "\nOs métodos de autenticação SMS e chamadas de voz estão desabilitados no tenant.\n\n## Métodos de autenticação fracos\n| ID do Método | O método é fraco? | Estado |\n| :-------- | :-------------- | :---- |\n| Sms | Sim | Disabled |\n| Voice | Sim | Disabled |\n\n",
      "TestDescription": "Quando métodos de autenticação fracos, como SMS e chamadas de voz, permanecem habilitados no Microsoft Entra ID, os atacantes podem explorar essas vulnerabilidades por meio de múltiplos vetores de ataque. Inicialmente, os criminosos realizam reconhecimento para identificar organizações que utilizam esses métodos mais fracos por meio de engenharia social ou varredura técnica. Em seguida, podem executar o acesso inicial através de ataques de preenchimento de credenciais (credential stuffing), pulverização de senhas (password spraying) ou campanhas de phishing.\n\nUma vez que as credenciais básicas são comprometidas, os invasores exploram as fraquezas na autenticação baseada em SMS e voz. Mensagens SMS podem ser interceptadas por meio de ataques de troca de SIM (SIM swapping), vulnerabilidades na rede SS7 ou malware em dispositivos móveis, enquanto as chamadas de voz são suscetíveis a phishing por voz (vishing) e manipulação de encaminhamento de chamadas. Com esses segundos fatores ignorados, os atacantes estabelecem persistência registrando seus próprios métodos de autenticação. Contas comprometidas podem ser usadas para visar usuários com privilégios mais altos, permitindo o escalonamento de privilégios. Finalmente, os criminosos atingem seus objetivos através de exfiltração de dados ou movimento lateral, mantendo-se ocultos ao usar caminhos de autenticação legítimos.\n\n**Ação de remediação**\n\n- [Implantar campanhas de registro de métodos de autenticação para incentivar métodos mais fortes](https://learn.microsoft.com/graph/api/authenticationmethodspolicy-update?view=graph-rest-beta&preserve-view=true&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Desabilitar métodos de autenticação fracos](https://learn.microsoft.com/entra/identity/authentication/concept-authentication-methods-manage?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Desabilitar métodos baseados em telefone nas configurações legadas de MFA](https://learn.microsoft.com/entra/identity/authentication/howto-mfa-mfasettings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Implantar políticas de Acesso Condicional usando força de autenticação](https://learn.microsoft.com/entra/identity/authentication/concept-authentication-strength-how-it-works?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21804",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identidade"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identidade"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Métodos de autenticação SMS e Chamada de Voz estão desabilitados"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\n## Resumo de Contas de Emergência\n\n| Nome | UPN | Apenas Nuvem | Excluído CA | MFA Resistente |\n| :--- | :--- | :---: | :---: | :---: |\n\n",
      "TestDescription": "A Microsoft recomenda que as organizações tenham duas contas de acesso de emergência exclusivamente na nuvem (cloud-only) atribuídas permanentemente à função de [Administrador Global](https://learn.microsoft.com/entra/identity/role-based-access-control/permissions-reference?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#global-administrator). Essas contas são altamente privilegiadas e não são atribuídas a indivíduos específicos. Elas são limitadas a cenários de emergência ou \"break glass\", onde as contas normais não podem ser usadas ou todos os outros administradores foram acidentalmente bloqueados.\n\n**Ação de correção**\n\n- Crie contas seguindo as [recomendações para contas de acesso de emergência](https://learn.microsoft.com/entra/identity/role-based-access-control/security-emergency-access?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "TestImplementationCost": "High",
      "TestId": "21835",
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Contas de acesso de emergência estão configuradas adequadamente"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\nNenhum URI de redirecionamento inseguro encontrado\n",
      "TestDescription": "Aplicações OAuth configuradas com URLs que incluem curingas (wildcards) ou encurtadores de URL aumentam a superfície de ataque para atores de ameaças. URIs de redirecionamento inseguros (reply URLs) podem permitir que adversários manipulem solicitações de autenticação, sequestrem códigos de autorização e interceptem tokens ao direcionar usuários para endpoints controlados pelo invasor. Entradas com curingas expandem o risco ao permitir que domínios não pretendidos processem respostas de autenticação, enquanto URLs curtas podem facilitar phishing e roubo de tokens em ambientes não controlados.\n\nSem uma validação estrita das URIs de redirecionamento, os invasores podem burlar controles de segurança, personificar aplicações legítimas e escalar seus privilégios. Essa má configuração permite persistência, acesso não autorizado e movimentação lateral, conforme adversários exploram a aplicação fraca de OAuth para infiltrar recursos protegidos sem detecção.\n\n**Ação de correção**\n\n- [Verifique as URIs de redirecionamento para os seus registros de aplicativo.](https://learn.microsoft.com/entra/identity-platform/reply-url?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) Certifique-se de que as URIs de redirecionamento não possuam *.azurewebsites.net, curingas ou encurtadores de URL.\n",
      "TestImplementationCost": "High",
      "TestId": "21885",
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Registros de aplicativos usam URIs de redirecionamento seguras"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Acesso privilegiado",
      "SkippedReason": null,
      "TestResult": "\n✅ **Passou**: Todas as contas privilegiadas possuem métodos resistentes a phishing registrados.\n\n## Usuários Privilegiados\n\nTodos os usuários privilegiados registraram métodos de autenticação resistentes a phishing.\n\n| Usuário | Nome da Função | Método resistente a phishing registrado |\n| :--- | :--- | :---: |\n\n",
      "TestDescription": "Sem métodos de autenticação resistentes a phishing, os usuários privilegiados ficam mais vulneráveis a ataques de phishing. Esses tipos de ataques enganam os usuários para que revelem suas credenciais para conceder acesso não autorizado aos invasores. Se métodos de autenticação não resistentes a phishing forem usados, os atacantes podem interceptar credenciais e tokens, por meio de métodos como ataques de adversário no meio (AiTM), comprometendo a segurança da conta privilegiada.\n\nUma vez que uma conta ou sessão privilegiada é comprometida devido a métodos de autenticação fracos, os atacantes podem manipular a conta para manter o acesso a longo prazo, criar outros backdoors ou modificar permissões de usuário. Atacantes também podem usar a conta privilegiada comprometida para escalar seu acesso ainda mais, ganhando controle sobre sistemas mais sensíveis.\n\n**Ação de remediação**\n\n- [Comece com uma implantação de autenticação sem senha resistente a phishing](https://learn.microsoft.com/entra/identity/authentication/how-to-plan-prerequisites-phishing-resistant-passwordless-authentication?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Garanta que as contas privilegiadas registrem e usem métodos resistentes a phishing](https://learn.microsoft.com/entra/identity/authentication/concept-authentication-strengths?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#authentication-strengths)\n- [Implante uma política de Acesso Condicional para exigir credenciais resistentes a phishing para administradores](https://learn.microsoft.com/entra/identity/conditional-access/policy-admin-phish-resistant-mfa?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Monitore a atividade dos métodos de autenticação](https://learn.microsoft.com/entra/identity/monitoring-health/concept-usage-insights-report?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#authentication-methods-activity)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21782",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Authentication"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Contas privilegiadas possuem métodos resistentes a phishing registrados"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Passed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\n✅ Políticas de Usuários e Grupos Locais foram encontradas e atribuídas.\n\n\n## Políticas de Usuários e Grupos Locais\n\n| Nome da Política | Status | Alvo de Atribuição |\n| :---------- | :----- | :---------------- |\n| [\\[JC2\\] Assign User to Local Administrator Group](https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/configuration) | ✅ Atribuída | Vários |\n| [Windows LAPS](https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/configuration) | ✅ Atribuída | Vários |\n\n",
      "TestDescription": "Sem uma política de Usuários e Grupos Locais devidamente configurada e atribuída no Intune, os agentes de ameaças podem explorar contas locais não gerenciadas ou mal configuradas em dispositivos Windows. Isso pode levar à escalada de privilégios não autorizada, persistência e movimentação lateral no ambiente. Se as contas de administrador local não forem controladas, os invasores podem criar contas ocultas ou elevar privilégios, contornando os controles de conformidade e segurança. Essa lacuna aumenta o risco de exfiltração de dados, implantação de ransomware e não conformidade regulatória.\n\nGarantir que as políticas de Usuários e Grupos Locais sejam aplicadas em dispositivos Windows gerenciados, usando perfis de proteção de conta, é fundamental para manter uma frota de dispositivos segura e em conformidade.\n\n**Ação de correção**\n\nConfigure e implante um perfil de **associação de grupo de usuário local** a partir da política de proteção de conta do Intune para restringir e gerenciar o uso de contas locais em dispositivos Windows:\n- Criar uma [Política de proteção de conta para segurança de endpoint no Intune](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-account-protection-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#account-protection-profiles)\n- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)\n",
      "TestImplementationCost": "Low",
      "TestId": "24564",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "O uso de contas locais no Windows é restrito para reduzir o acesso não autorizado"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\n## Detalhes das Políticas de PAW\n\n**Políticas encontradas com controle de dispositivo compatível:**\n**Políticas encontradas com filtro de dispositivo PAW/SAW:**\n\n",
      "TestDescription": "Se as ativações de funções privilegiadas não forem restritas a Estações de Trabalho de Acesso Privilegiado (PAWs) dedicadas, atores de ameaça podem explorar dispositivos de endpoint comprometidos para realizar ataques de escalonamento de privilégios a partir de estações de trabalho não gerenciadas ou não conformes. Estações de trabalho de produtividade padrão geralmente contêm vetores de ataque, como navegação web irrestrita, clientes de e-mail vulneráveis a phishing e aplicativos instalados localmente com vulnerabilidades potenciais. Quando administradores ativam funções privilegiadas a partir dessas estações, atores de ameaça que ganham acesso inicial por meio de malware ou engenharia social podem usar as credenciais privilegiadas em cache ou sequestrar sessões autenticadas existentes. As ativações de funções privilegiadas concedem amplos direitos administrativos no Microsoft Entra ID e serviços conectados, permitindo que invasores criem novas contas administrativas, modifiquem políticas de segurança e acessem dados sensíveis em todos os recursos organizacionais. Esse movimento lateral de um endpoint comprometido para recursos de nuvem privilegiados representa um caminho de ataque crítico que ignora muitos controles de segurança tradicionais.\n\nSe esta verificação passar, seu tenant possui uma política de Acesso Condicional que restringe o acesso a funções privilegiadas a dispositivos PAW, mas este não é o único controle necessário para habilitar totalmente uma solução PAW. Você também precisa configurar uma configuração de dispositivo do Intune, política de conformidade e um filtro de dispositivo.\n\n**Ação de correção**\n\n- [Implantar uma solução de estação de trabalho de acesso privilegiado](https://learn.microsoft.com/security/privileged-access-workstations/privileged-access-deployment?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n    - Fornece orientações para configurar o Acesso Condicional e as políticas de conformidade e configuração de dispositivos do Intune.\n- [Configurar filtros de dispositivo no Acesso Condicional para restringir o acesso privilegiado](https://learn.microsoft.com/entra/identity/conditional-access/concept-condition-filters-for-devices?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "High",
      "TestId": "21830",
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Funções altamente privilegiadas são ativadas apenas em dispositivos PAW/SAW"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Passed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\n✅ As políticas BitLocker para Windows foram encontradas e atribuídas.\n\n",
      "TestDescription": "Sem uma política BitLocker devidamente configurada e atribuída no Intune, os agentes de ameaças podem explorar dispositivos Windows não criptografados para obter acesso não autorizado a dados corporativos confidenciais. Os dispositivos que carecem de criptografia forçada são vulneráveis a ataques físicos, como a remoção do disco ou o arranque a partir de suportes externos, permitindo que os atacantes contornem os controlos de segurança do sistema operativo. Estes ataques podem resultar em exfiltração de dados, roubo de credenciais e movimentação lateral adicional dentro do ambiente.\n\nA imposição do BitLocker em dispositivos Windows geridos é fundamental para a conformidade com as regulamentações de proteção de dados e para reduzir o risco de violações de dados.\n\n**Ação de correção**\n\nUtilize o Intune para forçar a criptografia BitLocker e monitorizar a conformidade em todos os dispositivos Windows geridos:\n- [Criar uma política BitLocker para dispositivos Windows no Intune](https://learn.microsoft.com/intune/intune-service/protect/encrypt-devices?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-and-deploy-policy)\n- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)\n- [Monitorizar a criptografia do dispositivo com o Intune](https://learn.microsoft.com/intune/intune-service/protect/encryption-monitor?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24550",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Dados no Windows estão protegidos pela criptografia do BitLocker"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Passed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\n✅ Políticas de ASR para Windows foram encontradas e atribuídas.\n\n\n## Regras de Redução da Superfície de Ataque\n\n| Nome da Política | Estado | Alvo da Atribuição |\n| :---------- | :----- | :---------------- |\n| [Default EDR policy for all devices](https://intune.microsoft.com/#view/Microsoft_Intune_Workflows/SecurityManagementMenu/~/asr) | ✅ Atribuída | Vários |\n\n",
      "TestDescription": "Se os perfis do Intune para as regras de Redução da Superfície de Ataque (ASR) não estiverem devidamente configurados e atribuídos a dispositivos Windows, os agentes de ameaças podem explorar endpoints desprotegidos para executar scripts ofuscados e invocar chamadas da API Win32 a partir de macros do Office. Estas técnicas são comummente utilizadas em campanhas de phishing e entrega de malware, permitindo que os atacantes contornem as defesas tradicionais de antivírus e ganhem acesso inicial. Uma vez lá dentro, os atacantes escalam privilégios, estabelecem persistência e movem-se lateralmente pela rede.\n\nA imposição das regras ASR ajuda a bloquear técnicas comuns de ataque, como a execução baseada em scripts e o abuso de macros, reduzindo o risco de comprometimento inicial e apoiando o Zero Trust através do reforço das defesas dos endpoints.\n\n**Ação de correção**\n\nUtilize o Intune para implementar perfis de **Regras de Redução da Superfície de Ataque** para dispositivos Windows para bloquear comportamentos de alto risco:\n- [Configurar perfis do Intune para Regras de Redução da Superfície de Ataque](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-asr-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#devices-managed-by-intune)\n- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)\n\nPara mais informações, consulte:\n- [Referência das regras de redução da superfície de ataque](https://learn.microsoft.com/defender-endpoint/attack-surface-reduction-rules-reference?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) na documentação do Microsoft Defender.\n",
      "TestImplementationCost": "Medium",
      "TestId": "24574",
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "Regras de Redução da Superfície de Ataque são aplicadas para prevenir a exploração de componentes vulneráveis"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "Proteção de Informações",
      "SkippedReason": null,
      "TestResult": "\n✅ A rotulagem obrigatória está configurada e aplicada por meio de pelo menos uma política de rótulo de sensibilidade ativa em uma ou mais cargas de trabalho (Outlook, Teams/OneDrive, SharePoint/Grupos Microsoft 365 ou Power BI).\n\n\n\n### [Políticas de rótulo habilitadas](https://purview.microsoft.com/informationprotection/labelpolicies)\n| Nome da política | Email | Arquivos/Colaboração | Sites/Grupos | Power BI | Substituição de email | Escopo | Rótulos |\n| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |\n| Política Padrão de Classificação | ✅ | ❌ | ✅ | ✅ | Não | Global | 4 |\n\n\n### Resumo\n| Métrica | Contagem |\n| :--- | :--- |\n| Total de políticas de rótulo habilitadas | 1 |\n| Total de políticas de rótulo habilitadas com rotulagem obrigatória | 1 |\n| Rotulagem obrigatória de email | 1 |\n| Rotulagem obrigatória de arquivo/colaboração | 0 |\n| Rotulagem obrigatória de site/grupo | 1 |\n| Rotulagem obrigatória do Power BI | 1 |\n",
      "TestDescription": "A configuracao de politica **Exigir que os usuarios apliquem um rotulo** garante que um rotulo de sensibilidade seja aplicado antes que os usuarios possam salvar arquivos, enviar emails ou convites de reuniao, criar novos grupos ou sites e usar conteudo do Power BI. Essa configuracao tambem impede que os usuarios removam completamente um rotulo de sensibilidade. Itens sem rotulo criam riscos de seguranca e conformidade. Por exemplo, agentes mal-intencionados podem exfiltrar dados sensiveis que poderiam ser bloqueados por solucoes de protecao acionadas com base na deteccao de rotulo.\n\n**Ação de remediação**\n\n- [Publicar rotulos de sensibilidade criando uma politica de rotulo](https://learn.microsoft.com/purview/create-sensitivity-labels?tabs=modern-label-scheme&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#publish-sensitivity-labels-by-creating-a-label-policy)\n- [Exigir que os usuarios apliquem um rotulo aos seus emails e documentos](https://learn.microsoft.com/purview/sensitivity-labels-office-apps?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#require-users-to-apply-a-label-to-their-email-and-documents)\n",
      "TestImplementationCost": "Medium",
      "TestId": "35016",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E3",
      "TestImpact": "High",
      "TestRisk": "High",
      "TestTitle": "A rotulagem obrigatória está habilitada nas políticas de rótulo de sensibilidade"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\nNenhum aplicativo inativo com funções integradas privilegiadas do Entra foi encontrado\n\n\n",
      "TestDescription": "Atacantes podem explorar aplicativos válidos, mas inativos, que ainda possuem privilégios elevados. Esses aplicativos podem ser usados para obter acesso inicial sem levantar alarmes, pois são aplicativos legítimos. A partir daí, os invasores podem usar os privilégios do aplicativo para planejar ou executar outros ataques. Os atacantes também podem manter o acesso manipulando o aplicativo inativo, como por exemplo, adicionando credenciais. Essa persistência garante que, mesmo que seu método de acesso primário seja detectado, eles possam recuperar o acesso mais tarde.\n\n**Ação de remediação**\n\n- [Desativar entidades de serviço inativas e privilegiadas](https://learn.microsoft.com/graph/api/serviceprincipal-update?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- Investigar se o aplicativo possui casos de uso legítimos. Se sim, [analise se uma permissão OAuth2 é mais adequada](https://learn.microsoft.com/entra/identity-platform/v2-app-types?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Se a entidade de serviço não tiver casos de uso legítimos, exclua-a](https://learn.microsoft.com/graph/api/serviceprincipal-delete?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n\n",
      "TestImplementationCost": "Low",
      "TestId": "21771",
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "TestTags": [
        "Application"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Aplicativos inativos não possuem funções integradas altamente privilegiadas"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\n✅ **Passou**: As configurações de consentimento do usuário estão devidamente restritas.\n\n\n",
      "TestDescription": "Sem configurações de consentimento do usuário restritas, atacantes podem explorar configurações permissivas de consentimento de aplicativos para obter acesso não autorizado a dados organizacionais sensíveis. Quando o consentimento do usuário é irrestrito, os invasores podem:\n\n- Usar engenharia social e ataques de concessão de consentimento ilícito (illicit consent grant) para enganar os usuários.\n- Personificar serviços legítimos para solicitar permissões amplas (e-mail, arquivos, calendários).\n- Obter tokens OAuth legítimos que ignoram controles de segurança de perímetro.\n- Estabelecer acesso persistente e realizar movimento lateral.\n\nO consentimento irrestrito também limita a capacidade de governança centralizada, dificultando a visibilidade de quais aplicativos não-Microsoft têm acesso aos dados.\n\n**Ação de remediação**\n\n- [Configurar definições de consentimento do usuário restritas](https://learn.microsoft.com/entra/identity/enterprise-apps/configure-user-consent?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para evitar concessões de consentimento ilícitas, desabilitando o consentimento do usuário ou limitando-o a editores verificados com permissões de baixo risco apenas.\n",
      "TestImplementationCost": "Medium",
      "TestId": "21776",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identidade"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identidade"
      ],
      "TestMinimumLicense": "Free",
      "TestImpact": "High",
      "TestRisk": "High",
      "TestTitle": "Configurações de consentimento do usuário estão restritas"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Acesso privilegiado",
      "SkippedReason": null,
      "TestResult": "\nTodas as atribuições de funções privilegiadas são ativadas just-in-time e não são permanentemente ativas.\n\n## Usuários privilegiados com atribuições permanentes\n\n| Usuário | UPN | Função | Tipo de Atribuição |\n| :--- | :--- | :--- | :--- |\n\n",
      "TestDescription": "Atores de ameaça visam contas privilegiadas porque elas têm acesso aos dados e recursos que desejam. Isso pode incluir maior acesso ao seu tenant do Microsoft Entra, dados no Microsoft SharePoint ou a capacidade de estabelecer persistência de longo prazo. Sem um modelo de ativação just-in-time (JIT), os privilégios administrativos permanecem continuamente expostos, fornecendo aos invasores uma janela estendida para operar sem serem detectados. O acesso just-in-time mitiga o risco ao impor a ativação de privilégios limitada por tempo com controles extras, como aprovações, justificativas e políticas de Acesso Condicional, garantindo que permissões de alto risco sejam concedidas apenas quando necessário e por uma duração limitada. Essa restrição minimiza a superfície de ataque, interrompe a movimentação lateral e força os adversários a acionar ações que podem ser monitoradas e negadas especificamente quando não esperadas. Sem o acesso just-in-time, as contas de administrador comprometidas concedem controle indefinido, permitindo que os invasores desativem controles de segurança, apaguem logs e mantenham o sigilo, ampliando o impacto de um comprometimento.\n\nUse o Microsoft Entra Privileged Identity Management (PIM) para fornecer acesso just-in-time limitado por tempo às atribuições de funções privilegiadas. Use as revisões de acesso no Microsoft Entra ID Governance para revisar regularmente o acesso privilegiado para garantir a necessidade contínua.\n\n**Ação de correção**\n\n- [Comece a usar o Privileged Identity Management](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-getting-started?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Crie uma revisão de acesso de recursos do Azure e funções do Microsoft Entra no PIM](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-create-roles-and-resource-roles-review?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "High",
      "TestId": "21815",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P2",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Todas as atribuições de funções privilegiadas são ativadas just-in-time e não permanentemente ativas"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Infraestrutura híbrida",
      "SkippedReason": null,
      "TestResult": "\n✅ O Entra Connect Sync está usando Service Principals para sincronização.\n\n",
      "TestDescription": "O uso do Microsoft Entra Connect Sync com contas de usuário em vez de Service Principals cria vulnerabilidades de segurança. A autenticação de conta de usuário legada com senhas é mais suscetível ao roubo de credenciais e ataques de senha do que a autenticação de Service Principal com certificados. Contas de conector comprometidas permitem que agentes de ameaças manipulem a sincronização de identidade, criem contas de backdoor, escalem privilégios ou interrompam a infraestrutura de identidade híbrida.\n\n**Ação de correção**\n\n- [Configurar autenticação de Service Principal para o Entra Connect](https://learn.microsoft.com/entra/identity/hybrid/connect/authenticate-application-id?tabs=default&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#onboard-to-application-based-authentication)\n- [Remover as Contas de Sincronização de Diretório legadas](https://learn.microsoft.com/entra/identity/hybrid/connect/authenticate-application-id?tabs=default&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#remove-a-legacy-service-account)\n",
      "TestImplementationCost": "Medium",
      "TestId": "24570",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "O Entra Connect Sync está configurado com credenciais de Service Principal"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Passed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\n✅ Políticas do Microsoft Defender Antivírus foram encontradas e atribuídas.\n\n\n## Políticas do Microsoft Defender Antivírus\n\n| Nome da Política | Estado | Alvo da Atribuição |\n| :---------- | :----- | :---------------- |\n| [Default EDR policy for all devices](https://intune.microsoft.com/#view/Microsoft_Intune_Workflows/SecurityManagementMenu/~/antivirus) | ✅ Atribuída | Vários |\n\n",
      "TestDescription": "Se as políticas para o Microsoft Defender Antivírus não estiverem devidamente configuradas e atribuídas no Intune, os agentes de ameaças podem explorar endpoints desprotegidos para executar malware, desativar as proteções de antivírus e persistir no ambiente. Sem políticas de antivírus impostas, os dispositivos operam com definições desatualizadas, proteção em tempo real desativada ou agendas de análise mal configuradas. Estas falhas permitem que os atacantes contornem a deteção e se movam lateralmente pela rede. A ausência de imposição de antivírus compromete a conformidade dos dispositivos e aumenta a exposição a ameaças zero-day.\n\nA imposição das políticas do Defender Antivírus garante uma proteção consistente contra malware, apoia a deteção de ameaças em tempo real e alinha-se ao Zero Trust ao manter uma postura de endpoint segura e em conformidade.\n\n**Ação de correção**\n\nConfigure e atribua políticas do Intune para o Microsoft Defender Antivírus para impor a proteção em tempo real e manter as definições atualizadas:\n- [Configurar políticas do Intune para gerir o Microsoft Defender Antivírus](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-antivirus-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#windows)\n- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)\n",
      "TestImplementationCost": "Medium",
      "TestId": "24575",
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Políticas do Defender Antivírus protegem dispositivos Windows contra malware"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\n✅ **Passou**: A política de Restrições de tenant v2 foi encontrada.\n\n## Configuração de Restrições de tenant v2\n\n| Configurado | Usuários e Grupos Alvo | Aplicativos Alvo |\n| :---------- | :--------------------- | :--------------- |\n| [Sim](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/TenantRestrictions.ReactView/isDefault~/true/name//id/) | Todos os usuários e grupos externos | Todos os aplicativos externos |\n\n",
      "TestDescription": "As Restrições de tenant v2 (TRv2) permitem que as organizações apliquem políticas que restringem o acesso a tenants específicos do Microsoft Entra, impedindo a exfiltração não autorizada de dados corporativos para tenants externos usando contas locais. Sem o TRv2, atacantes podem explorar essa vulnerabilidade, o que leva a potencial exfiltração de dados e violações de conformidade, seguidas por colheita de credenciais se esses tenants externos possuírem controles mais fracos. Uma vez obtidas as credenciais, os invasores podem obter acesso inicial a esses tenants externos. O TRv2 fornece o mecanismo para impedir que os usuários se autentiquem em tenants não autorizados. Caso contrário, os atacantes podem se mover lateralmente, escalar privilégios e potencialmente exfiltrar dados sensíveis, tudo isso aparecendo como atividade de usuário legítima que ignora os controles tradicionais de prevenção de perda de dados (DLP) focados no monitoramento interno do tenant.\n\nA implementação do TRv2 aplica políticas que restringem o acesso a tenants especificados, mitigando esses riscos ao garantir que a autenticação e o acesso aos dados sejam confinados apenas a tenants autorizados.\n\nSe este teste passar, seu tenant possui uma política TRv2 configurada, mas etapas adicionais são necessárias para validar o cenário de ponta a ponta.\n\n**Ação de remediação**\n- [Configurar Restrições de tenant v2](https://learn.microsoft.com/entra/external-id/tenant-restrictions-v2?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21793",
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "A política de Restrições de tenant v2 está configurada"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": null,
      "TestResult": "\nO atestado de chave de segurança é imposto corretamente, garantindo que apenas autenticadores de hardware verificados possam ser registrados.\n\n- **Atestado imposto** : True\n\n",
      "TestDescription": "Quando o atestado de chave de segurança não é imposto, atores de ameaça podem explorar hardware de autenticação fraco ou comprometido para estabelecer presença persistente em ambientes organizacionais. Sem a validação de atestado, atores maliciosos podem registrar chaves de segurança FIDO2 não autorizadas ou falsificadas que ignoram os controles de segurança baseados em hardware, permitindo-lhes realizar ataques de preenchimento de credenciais (credential stuffing) usando autenticadores fabricados que imitam chaves de segurança legítimas.\n\nEsse acesso inicial permite que os atores de ameaça escalem privilégios aproveitando a natureza confiável dos métodos de autenticação por hardware e, em seguida, se movam lateralmente pelo ambiente registrando mais chaves de segurança comprometidas em contas de alto privilégio. A falta de imposição de atestado cria um caminho para que os invasores estabeleçam comando e controle por meio de métodos de autenticação persistentes baseados em hardware, levando, em última análise, à exfiltração de dados ou ao comprometimento do sistema, mantendo a aparência de uma autenticação legítima protegida por hardware durante toda a cadeia de ataque.\n\n**Ação de correção**\n\n- [Ativar a imposição de atestado por meio da configuração da política de métodos de autenticação](https://learn.microsoft.com/entra/identity/authentication/how-to-enable-passkey-fido2?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enable-passkey-fido2-authentication-method).\n- [Configurar a lista aprovada de chaves de segurança por Authenticator Attestation Globally Unique Identifier (AAGUID)](https://learn.microsoft.com/entra/identity/authentication/concept-fido2-hardware-vendor?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "TestImplementationCost": "Low",
      "TestId": "21840",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Atestado de chave de segurança é imposto"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "Rótulos de sensibilidade",
      "SkippedReason": null,
      "TestResult": "\n✅ Pelo menos um rótulo de sensibilidade está configurado no locaário.\n\n### Resumo da Configuração de Rótulo de Sensibilidade\n\n**Estatísticas de Rótulo:**\n* Contagem total de rótulos: 7\n* Contagem de rótulos de nível superior: 5\n* Contagem de sub-rótulos: 2\n\n**Rótulos de exemplo** (até 5):\n| Nome do Rótulo | Prioridade | Rótulo Pai |\n|:---|:---|:---|\n| Interna e Restrita | 0 | None |\n| Uso Interno | 1 | Interna e Restrita |\n| Uso Restrito | 2 | Interna e Restrita |\n| \\[Pública\\] | 3 | None |\n| \\[Interna\\] | 4 | None |\n\n[Gerenciar Rótulos de Sensibilidade no Microsoft Purview](https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels)\n\n",
      "TestDescription": "Rotulos de sensibilidade sao a base do Microsoft Purview Information Protection. Eles permitem que as organizacoes classifiquem e protejam dados sensiveis no Microsoft 365, em ambientes locais e em aplicativos nao Microsoft.\n\nSem rotulos de sensibilidade, as organizacoes nao possuem uma forma padronizada de proteger dados, deixando-os vulneraveis a acesso nao autorizado e compartilhamento indevido. Uma taxonomia de rotulos bem desenhada normalmente inclui de 3 a 7 rotulos de nivel superior; rotulos em excesso sobrecarregam os usuarios e reduzem a efetividade.\n\n**Ação de remediação**\n\n- [Introducao aos rotulos de sensibilidade](https://learn.microsoft.com/purview/get-started-with-sensitivity-labels?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Criar e configurar rotulos de sensibilidade e suas politicas](https://learn.microsoft.com/purview/create-sensitivity-labels?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "35003",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E3",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Os rótulos de sensibilidade estão configurados"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Passed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\n✅ O Registro Automático do Windows está habilitado e aplicado no tenant.\n\n",
      "TestDescription": "Se o registro automático do Windows não estiver habilitado, os dispositivos não gerenciados podem se tornar um ponto de entrada para invasores. Os agentes de ameaças podem usar esses dispositivos para acessar dados corporativos, burlar políticas de conformidade e introduzir vulnerabilidades no ambiente. Dispositivos ingressados no Microsoft Entra sem o registro no Intune criam lacunas na visibilidade e no controle. Esses endpoints não gerenciados podem expor fraquezas no sistema operacional ou aplicativos mal configurados que os invasores podem explorar.\n\nA aplicação do registro automático garante que os dispositivos Windows sejam gerenciados desde o início, permitindo a aplicação consistente de políticas e visibilidade da conformidade. Isso apoia o modelo Zero Trust, garantindo que todos os dispositivos sejam verificados, monitorados e governados por controles de segurança.\n\n**Ação de correção**\n\nHabilite o registro automático para dispositivos Windows usando o Intune e o Microsoft Entra para garantir que todos os dispositivos ingressados no domínio ou no Entra sejam gerenciados:\n- [Habilitar o registro automático do Windows](https://learn.microsoft.com/intune/intune-service/enrollment/windows-enroll?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enable-windows-automatic-enrollment)\n\nPara mais informações, consulte:\n- [Guia de implantação - Registro para Windows](https://learn.microsoft.com/intune/intune-service/fundamentals/deployment-guide-enroll?tabs=work-profile%2Ccorporate-owned-apple%2Cautomatic-enrollment&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enrollment-for-windows)\n",
      "TestImplementationCost": "Low",
      "TestId": "24546",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "O registro automático de dispositivos Windows é aplicado para eliminar riscos de endpoints não gerenciados"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\n## Identidades de Carga de Trabalho com Funções Privilegiadas\n\n| Nome | Função | Tipo de Atribuição |\n| :--- | :--- | :--- |\n\n",
      "TestDescription": "Se os administradores atribuírem funções privilegiadas a identidades de carga de trabalho (workload identities), como entidades de serviço ou identidades gerenciadas, o tenant pode ser exposto a riscos significativos se essas identidades forem comprometidas. Atores de ameaça que ganham acesso a uma identidade de carga de trabalho privilegiada podem realizar reconhecimento para enumerar recursos, escalar privilégios e manipular ou exfiltrar dados sensíveis. A cadeia de ataque normalmente começa com o roubo de credenciais ou abuso de um aplicativo vulnerável. O próximo passo é o escalonamento de privilégios por meio da função atribuída, movimentação lateral pelos recursos de nuvem e, finalmente, persistência via outras atribuições de função ou atualizações de credenciais. As identidades de carga de trabalho são frequentemente usadas em automação e podem não ser monitoradas tão de perto quanto as contas de usuário. O comprometimento pode passar despercebido, permitindo que os atacantes mantenham o acesso e o controle sobre recursos críticos. Identidades de carga de trabalho não estão sujeitas a proteções centradas no usuário, como MFA, tornando a atribuição de privilégio mínimo e a revisão regular essenciais.\n\n**Ação de correção**\n- [Revisar e remover atribuições de funções privilegiadas](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-resource-roles-assign-roles?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#update-or-remove-an-existing-role-assignment).\n- [Siga as melhores práticas para identidades de carga de trabalho](https://learn.microsoft.com/entra/workload-id/workload-identities-overview?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#key-scenarios).\n- [Saiba mais sobre funções e permissões privilegiadas no Microsoft Entra ID](https://learn.microsoft.com/entra/identity/role-based-access-control/privileged-roles-permissions?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": 21836,
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Identidades de Carga de Trabalho não possuem funções privilegiadas atribuídas"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Passed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\nO Conector de Defesa contra Ameaças Móveis está habilitado e a inscrição do Android está ativa.\n\n\n## [Inscrição no Microsoft Defender for Endpoint para dispositivos Android](https://intune.microsoft.com/#view/Microsoft_Intune_Workflows/SecurityManagementMenu/~/atp)\n\n| Status | Android Enrollment |\n| :----- | :----------------- |\n| Enabled | True |\n\n\n",
      "TestDescription": "Se a inscrição automática no Microsoft Defender for Endpoint não estiver configurada para dispositivos Android no Intune, os endpoints gerenciados podem permanecer desprotegidos contra ameaças móveis. Sem o onboard do Defender, os dispositivos ficam sem capacidades avançadas de detecção e resposta a ameaças, aumentando o risco de malware, phishing e outros ataques móveis. Dispositivos desprotegidos podem contornar políticas de segurança, acessar recursos corporativos e expor dados sensíveis a comprometimentos. Essa lacuna na defesa contra ameaças móveis enfraquece a postura Zero Trust da organização e reduz a visibilidade sobre a integridade dos endpoints.\n\nHabilitar a inscrição automática no Defender garante que dispositivos Android sejam protegidos por capacidades avançadas de detecção e resposta a ameaças. Isso apoia o Zero Trust ao aplicar proteção contra ameaças móveis, melhorar a visibilidade e reduzir a exposição a endpoints não gerenciados ou comprometidos.\n\n**Ação de remediação**\n\nUse o Intune para configurar a inscrição automática no Microsoft Defender for Endpoint para dispositivos Android e aplicar proteção contra ameaças móveis:\n\n- [Integrar o Microsoft Defender for Endpoint ao Intune e incorporar dispositivos](https://learn.microsoft.com/intune/intune-service/protect/advanced-threat-protection-configure?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24871",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "A inscrição automática no Defender para Endpoint é aplicada para reduzir riscos de ameaças Android não gerenciadas"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Passed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\n✅ A política de Windows LAPS foi encontrada e está atribuída.\n\n",
      "TestDescription": "Sem a aplicação de políticas da Solução de Password de Administrador Local (LAPS), os agentes de ameaças que obtenham acesso a endpoints podem explorar passwords de administrador local estáticas ou fracas para escalar privilégios, mover-se lateralmente e estabelecer persistência. A cadeia de ataque começa normalmente com o comprometimento do dispositivo — através de phishing, malware ou acesso físico — seguido de tentativas de recolher credenciais de administrador local. Sem o LAPS, os atacantes podem reutilizar credenciais comprometidas em vários dispositivos, aumentando o risco de escalonamento de privilégios e comprometimento de todo o domínio.\n\nA aplicação do Windows LAPS em todos os dispositivos Windows corporativos garante passwords de administrador local únicas e rodadas regularmente. Isto interrompe a cadeia de ataque nas fases de acesso a credenciais e movimento lateral, reduzindo significativamente o risco de comprometimento generalizado.\n\n**Ação de correção**\n\nUtilize o Intune para impor políticas de Windows LAPS que rodem passwords de administrador local fortes e únicas, e que façam o backup das mesmas de forma segura:\n- [Implementar a política de Windows LAPS com o Microsoft Intune](https://learn.microsoft.com/intune/intune-service/protect/windows-laps-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-a-laps-policy)\n\nPara mais informações, consulte:\n- [Referência de definições da política de Windows LAPS](https://learn.microsoft.com/windows-server/identity/laps/laps-management-policy-settings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Saiba mais sobre o suporte do Intune para o Windows LAPS](https://learn.microsoft.com/intune/intune-service/protect/windows-laps-overview?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24560",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Credenciais de administrador local no Windows são protegidas pelo Windows LAPS"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\nTodos os domínios estão usando autenticação em nuvem.\n\n",
      "TestDescription": "Um servidor de federação local introduz uma superfície de ataque crítica ao servir como um ponto de autenticação central para aplicativos em nuvem. Atores de ameaça frequentemente ganham uma posição inicial ao comprometer um usuário privilegiado, como um representante de suporte técnico ou um engenheiro de operações, por meio de ataques como phishing, preenchimento de credenciais ou exploração de senhas fracas. Eles também podem visar vulnerabilidades não corrigidas na infraestrutura, usar explorações de execução remota de código, atacar o protocolo Kerberos ou usar ataques de pass-the-hash para escalar privilégios. Ferramentas de acesso remoto mal configuradas, como RDP, VPN ou servidores de salto (jump servers), fornecem outros pontos de entrada, enquanto comprometimentos da cadeia de suprimentos ou ameaças internas aumentam ainda mais a exposição. Uma vez lá dentro, os atores de ameaça podem manipular fluxos de autenticação, forjar tokens de segurança para personificar qualquer usuário e pivotar para ambientes de nuvem. Estabelecendo persistência, eles podem desativar logs de segurança, evitar detecção e exfiltrar dados sensíveis.\n\n**Ação de correção**\n\n- [Migrar da federação para a autenticação em nuvem, como a Sincronização de Hash de Senha (PHS) do Microsoft Entra](https://learn.microsoft.com/entra/identity/hybrid/connect/migrate-from-federation-to-cloud-authentication?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "TestImplementationCost": "High",
      "TestId": "21829",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "High",
      "TestRisk": "High",
      "TestTitle": "Uso de autenticação em nuvem"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\n✅ **Passou**: Todos os aplicativos multitenants possuem o bloqueio de instância configurado.\n\n\n",
      "TestDescription": "O bloqueio de propriedade de instância de aplicativo impede alterações em propriedades sensíveis de um aplicativo multitenant (multitenant) após o aplicativo ter sido provisionado em outro tenant. Sem um bloqueio, propriedades críticas, como credenciais de aplicativo, podem ser modificadas maliciosa ou involuntariamente, causando interrupções, aumento de risco, acesso não autorizado ou escalonamento de privilégios.\n\n**Ação de remediação**\nHabilite o bloqueio de propriedade de instância de aplicativo para todos os aplicativos multitenants e especifique as propriedades a serem bloqueadas.\n- [Configurar um bloqueio de instância de aplicativo](https://learn.microsoft.com/entra/identity-platform/howto-configure-app-instance-property-locks?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#configure-an-app-instance-lock)\n",
      "TestImplementationCost": "Low",
      "TestId": "21777",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": [
        "Identidade"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identidade"
      ],
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "O bloqueio de propriedade de instância de aplicativo está configurado para todos os aplicativos multitenants"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Monitoramento",
      "SkippedReason": null,
      "TestResult": "\nNão há logins de risco sem triagem no tenant.\n",
      "TestDescription": "Logins de risco sinalizados pelo Microsoft Entra ID Protection indicam uma alta probabilidade de tentativas de acesso não autorizado. Atores de ameaça usam esses logins para obter uma posição inicial. Se esses logins permanecerem sem investigação, os adversários podem estabelecer persistência autenticando-se repetidamente sob o disfarce de usuários legítimos.\n\nA falta de resposta permite que os atacantes executem reconhecimento, tentem escalar seu acesso e se misturem a padrões normais. Quando logins sem triagem continuam a gerar alertas e não há intervenção, as lacunas de segurança aumentam, facilitando a movimentação lateral e a evasão de defesa, à medida que os adversários reconhecem a ausência de uma resposta de segurança ativa.\n\n**Ação de correção**\n\n- [Investigar logins de risco](https://learn.microsoft.com/entra/id-protection/howto-identity-protection-investigate-risk?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Corrigir riscos e desbloquear usuários](https://learn.microsoft.com/entra/id-protection/howto-identity-protection-remediate-unblock?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "High",
      "TestId": "21863",
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P2",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Todos os logins de alto risco passaram por triagem"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "Configuração de rótulos de sensibilidade",
      "SkippedReason": null,
      "TestResult": "\n✅ Pelo menos um rótulo de sensibilidade com criptografia habilitada está configurado.\n\n\n## [Detalhes do rótulo de criptografia](https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels)\n\n| Nome do rótulo | Tipo de criptografia | Identidades com permissões padrão | Co-autoria bloqueada |\n| :--------- | :-------------- | :----------------------------- | :------------------: |\n| Uso Interno | Standard RMS | jc2sec.com.br | Não |\n| Uso Restrito | Standard RMS | AuthenticatedUsers | Sim |\n| \\[Confidencial\\] | Definido pelo usuário | Não especificado | Não |\n\n**Resumo:**\n* Total de rótulos habilitados para criptografia: 3\n* Standard RMS: 2\n* Definido pelo usuário: 1\n* Double Key Encryption (DKE): 0\n\n",
      "TestDescription": "Sem criptografia, rótulos de sensibilidade denotam o nível de sensibilidade de um item sem impedir acesso não autorizado, a menos que complementado por outro mecanismo de proteção. Rótulos de sensibilidade configurados para aplicar criptografia do serviço de Gerenciamento de Direitos do Azure aplicam controle de acesso e direitos de uso. Essa proteção persiste independentemente de onde o conteúdo é armazenado ou compartilhado. Por exemplo, os usuários ainda podem compartilhar um documento rotulado como \"Confidencial\", mas se esse rótulo aplicar criptografia, pessoas não autorizadas não poderão abri-lo.\n\nAs organizações que usam rótulos sem criptografia ganham visibilidade do nível de sensibilidade, mas os rótulos em si carecem de aplicação técnica. Rótulos que aplicam criptografia garantem que apenas usuários autorizados possam descriptografar o conteúdo e usá-lo com quaisquer restrições especificadas para esse usuário. Por exemplo, somente leitura ou impedir cópia. Essa proteção ajuda a impedir exfiltração de dados mesmo se os arquivos forem vazados ou compartilhados de forma inadequada. Pelo menos um rótulo de sensibilidade deve ser configurado para aplicar criptografia a dados de alto valor que exigem proteção além de identificar o nível de sensibilidade.\n\n**Ação de remediação**\n\n- [Restringir o acesso ao conteúdo usando criptografia em rótulos de sensibilidade](https://learn.microsoft.com/purview/encryption-sensitivity-labels?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "35013",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E3",
      "TestImpact": "High",
      "TestRisk": "High",
      "TestTitle": "Os rótulos de sensibilidade com criptografia estão configurados"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\n✅ **Passou**: Nenhuma credencial personalizada foi encontrada nos aplicativos de serviços da Microsoft.\n\n\n",
      "TestDescription": "Os aplicativos de serviços da Microsoft que operam em seu tenant (tenant) são identificados como entidades de serviço com o ID de organização proprietária \"f8cdef31-a31e-4b4a-93e4-5f571e91255a\". Quando essas entidades de serviço têm credenciais configuradas em seu tenant, elas podem criar vetores de ataque potenciais. Se um administrador adicionou as credenciais e elas não são mais necessárias, elas podem se tornar um alvo. Atacantes podem usar essas credenciais para se autenticar como a entidade de serviço, obtendo as mesmas permissões e direitos de acesso que o aplicativo de serviço da Microsoft. Esse acesso inicial pode levar à escalada de privilégios e movimento lateral.\n\nSe credenciais (como segredos de cliente ou certificados) estiverem configuradas para essas entidades de serviço, significa que alguém as habilitou para autenticação independente em seu ambiente. Essas credenciais devem ser investigadas para determinar sua legitimidade.\n\n**Ação de remediação**\n\n- Confirme se as credenciais adicionadas ainda são casos de uso válidos. Se não, remova as credenciais dos aplicativos de serviço da Microsoft.\n    - No centro de administração do Microsoft Entra, acesse **Entra ID** > **Registros de aplicativo** e selecione o aplicativo afetado.\n    - Vá para a seção **Certificados e segredos** e remova quaisquer credenciais que não sejam mais necessárias.\n",
      "TestImplementationCost": "Low",
      "TestId": "21774",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identidade"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identidade"
      ],
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Aplicativos de serviços da Microsoft não possuem credenciais configuradas"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "Rights Management Service",
      "SkippedReason": null,
      "TestResult": "\n✅ O Azure RMS está habilitado no nível do locatário, habilitando todos os recursos de criptografia e gerenciamento de direitos downstream.\n\n\n### Status do Azure RMS\n\n| Configuração | Valor |\n| :------ | :---- |\n| AzureRMSLicensingEnabled | True |\n| SimplifiedClientAccessEnabled | True |\n| InternalLicensingEnabled | True |\n| ExternalLicensingEnabled | True |\n| Configuração criada | 06/12/2025 08:21:04 |\n\n\n**Resumo:**\n\n Serviço do Azure RMS: ✅ Habilitado\n\n",
      "TestDescription": "O serviço de Gerenciamento de Direitos do Azure fornece a tecnologia fundamental de criptografia e controle de acesso para a Proteção de Informação do Microsoft Purview. É usado com rótulos de sensibilidade que aplicam criptografia, protege emails com a Criptografia de Mensagem do Microsoft Purview e até usado com as tecnologias de proteção mais antigas, como IRM do SharePoint e regras de fluxo de email que aplicam criptografia. Este serviço deve ser ativado para o locatário antes de você configurar qualquer outro recurso de proteção de informações.\n\n**Ação de remediação**\n\n- [Ativar o serviço de Gerenciamento de Direitos do Azure](https://learn.microsoft.com/purview/activate-rights-management-service?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "35024",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E3",
      "TestImpact": "High",
      "TestRisk": "High",
      "TestTitle": "Azure Rights Management service is enabled"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Monitoramento",
      "SkippedReason": null,
      "TestResult": "\nAlertas de monitoramento estão configurados para funções privilegiadas.\n\n## Detalhes de Notificação\n\n| Função | Cenário | Tipo | Destinatários Padrão | Destinatários Extras |\n| :--- | :--- | :--- | :--- | :--- |\n\n",
      "TestDescription": "Organizações sem alertas de ativação adequados para funções altamente privilegiadas carecem de visibilidade sobre quando os usuários acessam essas permissões críticas. Atores de ameaça podem explorar essa lacuna de monitoramento para realizar escalonamento de privilégios ativando funções altamente privilegiadas sem detecção e, em seguida, estabelecer persistência por meio da criação de contas de administrador ou modificações de políticas de segurança. A ausência de alertas em tempo real permite que os invasores realizem movimentação lateral, modifiquem configurações de auditoria e desativem controles de segurança sem acionar procedimentos de resposta imediata.\n\n**Ação de correção**\n\n- [Configure as definições de função do Microsoft Entra no Privileged Identity Management](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-how-to-change-default-settings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#require-justification-on-activation)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21818",
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P2",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Ativações de funções privilegiadas têm monitoramento e alertas configurados"
    },
    {
      "TestResult": "\n✅ O perfil de encaminhamento de acesso à Internet está habilitado com atribuições de usuário.\n\n\n## Perfil de acesso à Internet\n\n| Nome do perfil | Estado do perfil | Atribuições | Contagem de atribuições |\n| :----------- | :------------ | :---------- | :---------- |\n| [Internet traffic forwarding profile](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/ForwardingProfile.ReactView) | ✅ Ativado | [Gabriel Lorenzi | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Users/objectId/fddf4c37-682d-4810-a4fe-063998df7b33/appId/427c5187-dd58-4f4a-9e7c-c447e1c61a0c/preferredSingleSignOnMode~/null/servicePrincipalType/Application/fromNav/) | 1 |\n\n## Atribuições de usuário/grupo\n\n| Nome exibido do principal | Tipo de principal | Id do principal |\n| :------------- | :----------- | :----------- |\n| [Gabriel Lorenzi | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/overview/userId/5109b9a1-c835-4bce-9dc1-343312d476fa) | User | 5109b9a1-c835-4bce-9dc1-343312d476fa |\n\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Passed",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "25406",
      "TestTitle": "O perfil de encaminhamento de acesso à Internet está habilitado",
      "TestDescription": "Quando o perfil de encaminhamento de acesso à Internet não está habilitado, os usuários podem acessar recursos da internet sem rotear o tráfego pelo Secure Web Gateway. Essa lacuna permite que agentes de ameaça contornem controles de segurança que bloqueiam ameaças, conteúdo malicioso e destinos inseguros.\n\nSem essa proteção:\n\n- As organizações perdem visibilidade sobre os padrões de tráfego. Não conseguem detectar exfiltração de dados, conexões a domínios maliciosos ou acesso externo não autorizado.\n- Agentes de ameaça podem entregar malware, estabelecer conexões de comando e controle ou exfiltrar dados por canais não monitorados.\n- Agentes de ameaça podem usar credenciais comprometidas ou engenharia social para obter acesso inicial, baixar ferramentas, estabelecer persistência ou se comunicar com infraestrutura externa.\n- Agentes de ameaça podem usar contas comprometidas para se misturar ao comportamento típico do usuário e acessar recursos externos sem acionar alertas de segurança baseados em contexto de usuário, conformidade de dispositivo ou localização.\n\n**Ação de remediação**\n- Habilite o perfil de encaminhamento de acesso à Internet para rotear o tráfego pelo Secure Web Gateway. Para mais informações, consulte [Como gerenciar o perfil de encaminhamento de tráfego de acesso à Internet](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-internet-access-profile?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Atribua usuários e grupos ao perfil de acesso à Internet para limitar o encaminhamento de tráfego a usuários específicos. Para mais informações, consulte [Perfis de encaminhamento de tráfego do Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/concept-traffic-forwarding?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Passed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\nPolítica do Windows Hello para Empresas está atribuída e aplicada.\n\n\n## Política do Windows Hello para Empresas está Configurada e Atribuída\n\nWindows Hello para Empresas ([Tenant Wide Setting](https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesEnrollmentMenu/~/windowsEnrollment) ): ✅ Ativo.\n\n| Nome da Política | Status | Alvo da Atribuição |\n| :--------------- | :----- | :----------------- |\n\n\n",
      "TestDescription": "Se as políticas para o Windows Hello para Empresas (WHfB) não estiverem configuradas e atribuídas a todos os utilizadores e dispositivos, os agentes de ameaças podem explorar mecanismos de autenticação fracos — como palavras-passe — para obter acesso não autorizado. Isto pode levar ao roubo de credenciais, escalonamento de privilégios e movimentação lateral dentro do ambiente. Sem uma autenticação forte e baseada em políticas como o WHfB, os atacantes podem comprometer dispositivos e contas, aumentando o risco de um impacto generalizado.\n\nA imposição do WHfB interrompe esta cadeia de ataque ao exigir uma autenticação forte e multifator, o que ajuda a reduzir o risco de ataques baseados em credenciais e acesso não autorizado.\n\n**Ação de correção**\n\nImplemente o Windows Hello para Empresas no Intune para forçar uma autenticação forte e multifator:\n- [Configurar uma política de Windows Hello para Empresas ao nível do tenant](https://learn.microsoft.com/intune/intune-service/protect/windows-hello?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-a-windows-hello-for-business-policy-for-device-enrollment) que se aplica no momento em que um dispositivo se regista no Intune.\n- Após o registo, [configure perfis de proteção de conta](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-account-protection-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#account-protection-profiles) e [atribua](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups) diferentes configurações de Windows Hello para Empresas a diferentes grupos de utilizadores e dispositivos.\n",
      "TestImplementationCost": "Medium",
      "TestId": "24551",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestTitle": "A autenticação no Windows utiliza o Windows Hello para Empresas"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "Rights Management Service (RMS)",
      "SkippedReason": null,
      "TestResult": "\n✅ O licenciamento interno de RMS está habilitado, permitindo que usuários internos licenciem e compartilhem conteúdo protegido dentro da organização.\n\n**[Status de licenciamento de RMS interno](https://purview.microsoft.com/settings/encryption)**\n| Configuração | Status |\n| :--- | :--- |\n| InternalLicensingEnabled | True |\n| ExternalLicensingEnabled | True |\n| AzureRMSLicensingEnabled | True |\n| LicensingLocation | https://0829d6d7-04a6-4664-b2d4-6e9800acf25e.rms.sa.aadrm.com/_wmcs/licensing |\n\n\n### Resumo\n* Configuração de licenciamento interno: ✅ Enabled\n* Pontos de extremidade de licenciamento: ✅ Configured\n\n",
      "TestDescription": "O licenciamento interno de RMS permite que os usuários e serviços da organização licenciem o conteúdo protegido para distribuição e compartilhamento interno. É habilitado automaticamente quando o Azure RMS é ativado. Se desabilitado, os usuários não podem colaborar em emails e arquivos criptografados internamente, e as operações de bloqueio legal, descoberta eletrônica e recuperação de dados não podem acessar o conteúdo criptografado.\n\n**Ação de remediação**\n\n- [Configurar Criptografia de Mensagem](https://learn.microsoft.com/purview/set-up-new-message-encryption-capabilities?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "35025",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E3",
      "TestImpact": "High",
      "TestRisk": "High",
      "TestTitle": "Internal Rights Management licensing is enabled"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\nA Solução de Senha de Administrador Local (LAPS) está implantada.\n## Configurações da Solução de Senha de Administrador Local (LAPS)\n\n| Configuração | Status |\n| :---- | :---- |\n|[Habilitar Microsoft Entra Local Administrator Password Solution (LAPS)](https://entra.microsoft.com/#view/Microsoft_AAD_Devices/DevicesMenuBlade/~/DeviceSettings/menuId/Overview) | Habilitado\n\n",
      "TestDescription": "Sem a implantação da Solução de Senha de Administrador Local (LAPS), os agentes de ameaça exploram senhas estáticas de administradores locais para estabelecer o acesso inicial. Após comprometerem um único dispositivo com uma credencial de administrador local compartilhada, eles podem se mover lateralmente pelo ambiente e se autenticar em outros sistemas que compartilham a mesma senha. O acesso de administrador local comprometido concede privilégios de nível de sistema, permitindo desabilitar controles de segurança, instalar backdoors persistentes, exfiltrar dados sensíveis e estabelecer canais de comando e controle.\n\nA rotação automatizada de senhas e o gerenciamento centralizado do LAPS fecham essa lacuna de segurança e adicionam controles para ajudar a gerenciar quem tem acesso a essas contas críticas. Sem soluções como o LAPS, não é possível detectar ou responder ao uso não autorizado de contas de administrador local, dando aos atacantes um tempo de permanência estendido para alcançar seus objetivos sem serem detectados.\n\n**Ação de remediação**\n\n- [Configurar a Solução de Senha de Administrador Local do Windows (LAPS)](https://learn.microsoft.com/entra/identity/devices/howto-manage-local-admin-passwords?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "TestImplementationCost": "Medium",
      "TestId": "21953",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "A Solução de Senha de Administrador Local (LAPS) está implantada"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "...\n\n**Ação de correção**\n\n",
      "TestImplementationCost": "High",
      "TestId": "21864",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Todas as detecções de risco passaram por triagem"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para lançamento futuro.\n",
      "TestDescription": "A configuração de notificações de redefinição de senha para funções de administrador no Microsoft Entra ID aumenta a segurança ao notificar administradores privilegiados quando outro administrador redefine sua senha. Essa visibilidade ajuda a detectar atividades não autorizadas ou suspeitas que poderiam indicar comprometimento de credenciais ou ameaças internas. Sem essas notificações, atores maliciosos poderiam explorar privilégios elevados para estabelecer persistência, escalar o acesso ou extrair dados confidenciais. Notificações proativas apoiam a ação rápida, preservam a integridade do acesso privilegiado e fortalecem a postura geral de segurança.\n\n**Ação de correção**\n\n- [Notificar todos os administradores quando outros administradores redefinirem suas senhas](https://learn.microsoft.com/entra/identity/authentication/concept-sspr-howitworks?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#notify-all-admins-when-other-admins-reset-their-passwords)\n",
      "TestImplementationCost": "Low",
      "TestId": "21891",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Exigir notificações de redefinição de senha para funções de administrador"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Acesso privilegiado",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Funções privilegiadas não devem permanecer atribuídas a identidades que não mostram atividade de login recente. Contas obsoletas com privilégios administrativos são alvos atraentes para atacantes porque podem ser comprometidas sem acionar alertas de análise comportamental. Revisar e remover regularmente atribuições de funções privilegiadas de identidades inativas reduz o risco de ataques baseados em credenciais e ajuda a manter o acesso de privilégio mínimo.\n\n**Ação de correção**\n\n- [Revisar atribuições de funções privilegiadas usando revisões de acesso](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-create-roles-and-resource-roles-review?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Remover atribuições de funções privilegiadas de identidades inativas](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-resource-roles-assign-roles?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#update-or-remove-an-existing-role-assignment)\n- [Configurar revisões de acesso automatizadas para funções privilegiadas](https://learn.microsoft.com/entra/id-governance/access-reviews-overview?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21854",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Funções privilegiadas não são atribuídas a identidades obsoletas"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para lançamento futuro.\n",
      "TestDescription": "**Ação de correção**\n\n",
      "TestImplementationCost": "Medium",
      "TestId": "21881",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Assinaturas do Azure usadas pela Governança de Identidade são protegidas consistentemente com as funções da Governança de Identidade"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Se você não habilitar as notificações do ID Protection, sua organização perderá alertas críticos em tempo real quando atacantes comprometerem contas de usuários ou realizarem atividades de reconhecimento. Quando o Microsoft Entra ID Protection detecta contas em risco, ele envia alertas por e-mail com o assunto **Usuários em risco detectados**. Sem essas notificações, as equipes de segurança permanecem sem conhecimento de ameaças ativas.\n\n**Ação de remediação**\n- [Configurar alertas de usuários em risco detectados](https://learn.microsoft.com/entra/id-protection/howto-identity-protection-configure-notifications?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#configure-users-at-risk-detected-alerts)\n",
      "TestImplementationCost": "Low",
      "TestId": "21798",
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P2",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Notificações do ID Protection estão habilitadas"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Acesso privilegiado",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nEncontradas contas que não registraram métodos resistentes a phishing\n\n%TestResult%\n",
      "TestDescription": "Sem métodos de autenticação resistentes a phishing, os usuários privilegiados ficam mais vulneráveis a ataques de phishing. Esses tipos de ataques enganam os usuários para que revelem suas credenciais para conceder acesso não autorizado aos invasores. Se métodos de autenticação não resistentes a phishing forem usados, os atacantes podem interceptar credenciais e tokens, por meio de métodos como ataques de adversário no meio (AiTM), comprometendo a segurança da conta privilegiada.\n\nUma vez que uma conta ou sessão privilegiada é comprometida devido a métodos de autenticação fracos, os atacantes podem manipular a conta para manter o acesso a longo prazo, criar outros backdoors ou modificar permissões de usuário.\n\n**Ação de remediação**\n\n- [Comece com uma implantação de autenticação sem senha resistente a phishing](https://learn.microsoft.com/entra/identity/authentication/how-to-plan-prerequisites-phishing-resistant-passwordless-authentication?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Garanta que as contas privilegiadas registrem e usem métodos resistentes a phishing](https://learn.microsoft.com/entra/identity/authentication/concept-authentication-strengths?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#authentication-strengths)\n- [Implante uma política de Acesso Condicional para exigir credenciais resistentes a phishing para administradores](https://learn.microsoft.com/entra/identity/conditional-access/policy-admin-phish-resistant-mfa?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Monitore a atividade dos métodos de autenticação](https://learn.microsoft.com/entra/identity/monitoring-health/concept-usage-insights-report?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#authentication-methods-activity)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21781",
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": [
        "Authentication"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Usuários privilegiados fazem logon com métodos resistentes a phishing"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\r\nPlanejado para lançamento futuro.\r\n",
      "TestDescription": "...\r\n\r\n**Ação de remediação**\r\n\r\n",
      "TestImplementationCost": "Low",
      "TestId": "21912",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Os recursos do Azure usados pelo Microsoft Entra permitem acesso somente a partir de funções privilegiadas"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nIgnorado. Este teste não se aplica ao ambiente atual.\n",
      "TestDescription": "O Azure Firewall processa todo o tráfego de rede de entrada e saída das cargas protegidas, sendo um ponto crítico de controle para monitoramento de segurança. Sem log de diagnóstico habilitado, a equipe de segurança perde visibilidade sobre padrões de tráfego, tentativas negadas, correspondências de inteligência de ameaças e detecções de assinaturas IDPS. Isso compromete investigações, correlação com outras telemetrias e requisitos de conformidade.\n\n**Ação de remediação**\n\nCrie um workspace do Log Analytics para armazenar logs do Azure Firewall\n- [Criar um workspace do Log Analytics](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/quick-create-workspace)\n\nConfigure as definições de diagnóstico do Azure Firewall para habilitar a coleta de logs\n- [Criar definições de diagnóstico no Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/create-diagnostic-settings)\n\nHabilite logs estruturados (modo específico do recurso) para melhorar desempenho de consulta e otimização de custos\n- [Logs estruturados do Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/monitor-firewall#structured-azure-firewall-logs)\n\nUse o Azure Firewall Workbook para visualizar e analisar logs do firewall\n- [Azure Firewall Workbook](https://learn.microsoft.com/en-us/azure/firewall/firewall-workbook)\n\nMonitor Azure Firewall metrics and logs for security operations\n- [Monitor Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/monitor-firewall)\n\n",
      "TestImplementationCost": "Low",
      "TestId": 26887,
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": [
        "Azure_Firewall_Standard",
        "Azure_Firewall_Premium"
      ],
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "O registro de diagnóstico está habilitado no Azure Firewall"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nIgnorado. Este teste não se aplica ao ambiente atual.\n",
      "TestDescription": "O WAF do Azure Application Gateway protege aplicações web contra vulnerabilidades comuns, como SQL injection e cross-site scripting. Quando o log de diagnóstico não está habilitado, a equipe de segurança perde visibilidade sobre ataques bloqueados, correspondência de regras, padrões de acesso e eventos do firewall. Sem logs, não há correlação adequada com outras telemetrias, o que prejudica investigações e conformidade.\n\n**Ação de remediação**\n\nCrie um workspace do Log Analytics para armazenar logs do WAF do Application Gateway\n- [Criar um workspace do Log Analytics](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/quick-create-workspace)\n\nConfigure as definições de diagnóstico do Application Gateway para habilitar coleta de logs\n- [Criar definições de diagnóstico no Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/create-diagnostic-settings)\n\nHabilite o log do WAF para capturar eventos de firewall e correspondências de regras\n- [Logs e métricas do WAF do Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/application-gateway-waf-metrics)\n\nMonitore o Application Gateway usando logs e métricas de diagnóstico\n- [Monitor Azure Application Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/application-gateway-diagnostics)\n\nUse Azure Monitor Workbooks for visualizing and analyzing WAF logs\n- [Azure Monitor Workbooks](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview)\n\n",
      "TestImplementationCost": "Low",
      "TestId": 26888,
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Azure_Application_Gateway_WAF",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "O registro de diagnóstico está habilitado no WAF do Application Gateway"
    },
    {
      "TestResult": "\nIgnorado. Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)\n",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Classificação Avançada",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "EXCHANGE_S_ENTERPRISE"
      ],
      "TestPillar": "Data",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "High",
      "TestSkipped": "NoCompatibleLicenseFound",
      "TestId": "35033",
      "TestTitle": "Custom sensitive information types are configured",
      "TestDescription": "Os tipos de informação sensível personalizado (SITs) estendem a detecção integrada do Microsoft Purview para cobrir padrões de dados específicos da organização, identificadores proprietários, esquemas de classificação internos, códigos de indústria especializados ou outros formatos que os SITs integrados não correspondem. Sem SITs personalizado, as políticas de aplicação automática de rótulo e as regras de prevenção de perda de dados (DLP) dependem exclusivamente de padrões genéricos e podem perder dados sensíveis únicos da sua organização.\n\n**Ação de remediação**\n\n- [Criar tipos de informação sensível personalizado](https://learn.microsoft.com/purview/create-a-custom-sensitive-information-type?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": "Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nNenhuma política de WAF do Azure Front Door anexada ao Azure Front Door encontrada em todas as assinaturas.\n",
      "TestDescription": "O Web Application Firewall (WAF) do Azure Front Door fornece proteção centralizada na borda para aplicações web distribuídas globalmente por meio de conjuntos de regras gerenciadas com assinaturas pré-configuradas para ataques conhecidos. O Microsoft Default Ruleset é atualizado continuamente e protege contra vulnerabilidades web comuns e críticas sem exigir configuração avançada. Quando nenhum ruleset gerenciado está habilitado, a política de WAF atua praticamente como pass-through, sem bloquear padrões de ataque conhecidos. Isso expõe a aplicação a SQL injection, cross-site scripting, inclusão local de arquivos e injeção de comandos.\n\n**Ação de remediação**\n\nVisão geral dos recursos de WAF no Azure Front Door, incluindo rulesets gerenciados\n- [Azure Web Application Firewall no Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview)\n\nDocumentação detalhada dos grupos e regras do Default Rule Set no Azure Front Door\n- [Grupos e regras de DRS do Web Application Firewall](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-drs)\n\nGuia passo a passo para criar e configurar políticas de WAF com rulesets gerenciados\n- [Tutorial: Criar uma política de Web Application Firewall no Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-create-portal)\n\n",
      "TestImplementationCost": "Low",
      "TestId": 26883,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Azure WAF",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "O conjunto de regras padrão está atribuído no WAF do Azure Front Door"
    },
    {
      "TestResult": "\nIgnorado. Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)\n",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Gerenciamento de postura de segurança de dados",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "EXCHANGE_S_ENTERPRISE"
      ],
      "TestPillar": "Data",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "NoCompatibleLicenseFound",
      "TestId": "35040",
      "TestTitle": "Monitoramento de conformidade de comunicação configurado para ferramentas de IA corporativa",
      "TestDescription": "As Políticas de Coleta fornecem a camada de ingestão de dados que dá suporte ao monitoramento da atividade de aplicativos de IA corporativa. Quando essas políticas estão em vigor, a Comunicação em Conformidade pode coletar sinais das interações com aplicativos de IA e ajudar as organizações a entender onde podem existir riscos de proteção de dados em fluxos de trabalho habilitados por IA. Essa visibilidade ajuda as equipes a aplicar controles de proteção de dados de forma mais consistente à medida que o uso de IA se expande além do Microsoft Copilot.\n\t\t\nNa prática, os usuários podem compartilhar acidentalmente dados sensíveis com aplicativos de IA personalizados, fluxos do Power Automate, automações do AI Builder ou serviços de IA que não sejam da Microsoft e que não estejam aprovados para lidar com informações confidenciais. No entanto, políticas de Comunicação em Conformidade que abrangem interações com aplicativos de IA corporativa podem ajudar a identificar possíveis exposições de dados para esses serviços e estender as práticas de proteção de dados para soluções de IA personalizadas e de terceiros.\n\n**Ação de remediação**\n\n- [Criar e implantar políticas de coleta](https://learn.microsoft.com/purview/collection-policies-create-deploy-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Criar e gerenciar políticas de Comunicação em Conformidade](https://learn.microsoft.com/purview/communication-compliance-policies?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": "Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Skipped",
      "TestCategory": "Monitoramento",
      "SkippedReason": "Este teste é para tenants licenciados para o Entra Workload ID. Consulte [Licenciamento do Entra Workload ID](https://learn.microsoft.com/entra/workload-id/workload-identities-faqs)",
      "TestResult": "\nIgnorado. Este teste é para tenants licenciados para o Entra Workload ID. Consulte [Licenciamento do Entra Workload ID](https://learn.microsoft.com/entra/workload-id/workload-identities-faqs)\n",
      "TestDescription": "Identidades de carga de trabalho comprometidas (entidades de serviço e aplicativos) permitem que atores de ameaça obtenham acesso persistente sem interação do usuário ou autenticação multifator. O Microsoft Entra ID Protection monitora essas identidades para atividades suspeitas, como credenciais vazadas, tráfego de API anômalo e aplicativos maliciosos. Identidades de carga de trabalho de risco não tratadas permitem escalonamento de privilégios, movimentação lateral, exfiltração de dados e backdoors persistentes que contornam controles de segurança tradicionais. As organizações devem investigar e remediar sistematicamente esses riscos para evitar o acesso não autorizado.\n\n**Ação de correção**\n\n- [Investigar e remediar identidades de carga de trabalho de risco](https://learn.microsoft.com/entra/id-protection/concept-workload-identity-risk?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#investigate-risky-workload-identities)\n- [Aplicar políticas de Acesso Condicional para identidades de carga de trabalho](https://learn.microsoft.com/entra/identity/conditional-access/workload-identity?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "High",
      "TestId": 21862,
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": null,
      "TestSkipped": "NotLicensedEntraWorkloadID",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P2",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Todas as identidades de carga de trabalho de risco passaram por triagem"
    },
    {
      "TestResult": "\nNenhum aplicativo do Application Proxy está configurado neste locatário.\n",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Application Proxy",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "AAD_PREMIUM",
        "AAD_PREMIUM_P2"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "NotApplicable",
      "TestId": 25401,
      "TestTitle": "Os aplicativos do Application Proxy requerem pré-autenticação para bloquear acesso anônimo",
      "TestDescription": "Sem pré-autenticação do Microsoft Entra configurada nos aplicativos do Application Proxy, agentes de ameaça podem atingir diretamente a URL interna de aplicativos locais publicados sem primeiro comprovar sua identidade. Quando você usa autenticação passthrough, o Application Proxy encaminha o tráfego sem validar o solicitante, e toda a responsabilidade de autenticação recai sobre o aplicativo interno.\n\nSe você não configurar pré-autenticação nos aplicativos do Application Proxy:\n\n- Agentes de ameaça podem acessar endpoints de aplicativos internos sem verificação de identidade, permitindo reconhecimento e exploração de vulnerabilidades de backend.\n- Políticas de Conditional Access não podem ser aplicadas, então você não pode exigir autenticação multifator, avaliar risco de login ou aplicar restrições baseadas em localização.\n- Você não pode integrar com o Microsoft Defender for Cloud Apps para monitoramento e controle de sessão em tempo real.\n\n**Ação de remediação**\n\n- [Configure a pré-autenticação do Microsoft Entra para aplicativos do Application Proxy](https://learn.microsoft.com/entra/identity/app-proxy/application-proxy-add-on-premises-application?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#add-an-on-premises-app-to-microsoft-entra-id) alterando o método de Pré-autenticação de **Passthrough** para **Microsoft Entra ID**.\n- [Use a API Microsoft Graph para atualizar programaticamente as configurações do Application Proxy](https://learn.microsoft.com/graph/application-proxy-configure-api?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": "Este teste não se aplica ao ambiente atual."
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nIgnorado. Este teste não se aplica ao ambiente atual.\n",
      "TestDescription": "Os ataques de DDoS continuam sendo um risco importante de segurança e disponibilidade para clientes com aplicações hospedadas em nuvem. Esses ataques visam sobrecarregar recursos de computação, rede ou memória de um aplicativo, tornando-o inacessível aos usuários legítimos. Qualquer endpoint voltado ao público exposto à internet pode ser um alvo em potencial para um ataque de DDoS. A Proteção contra DDoS do Azure fornece monitoramento sempre ativo e mitigação automática contra ataques de DDoS direcionados a cargas de trabalho voltadas ao público.\n\nSem a Proteção contra DDoS do Azure (Network Protection ou IP Protection), endereços IP públicos para serviços como Application Gateways, Load Balancers, Azure Firewalls, Azure Bastion, Virtual Network Gateways ou máquinas virtuais permanecem expostos a ataques de DDoS que podem sobrecarregar a largura de banda da rede, esgotar recursos do sistema e causar indisponibilidade completa de serviço. Esses ataques podem interromper o acesso de usuários legítimos, degradar o desempenho e criar interrupções em cascata em serviços dependentes.\n\nA Proteção contra DDoS do Azure pode ser ativada de duas maneiras:\n\n- DDoS IP Protection — A proteção é explicitamente ativada em endereços IP públicos individuais definindo ddosSettings.protectionMode como Habilitado.\n- DDoS Network Protection — A proteção é ativada no nível de VNET através de um Plano de Proteção contra DDoS. Os endereços IP públicos associados a recursos nesse VNET herdam a proteção quando ddosSettings.protectionMode é definido como VirtualNetworkInherited. No entanto, um endereço IP público com VirtualNetworkInherited não é protegido a menos que o VNET realmente tenha um Plano de Proteção contra DDoS associado e enableDdosProtection definido como verdadeiro.\nEssa verificação verifica se cada endereço IP público está realmente coberto pela proteção DDoS, seja através da Proteção de DDoS IP ativada diretamente no IP público ou através da Proteção de Rede DDoS ativada no VNET em que reside o recurso associado do IP público. Se essa verificação não passar, suas cargas de trabalho permanecerão significativamente mais vulneráveis ao tempo de inatividade, impacto do cliente e disrupção operacional durante um ataque.\n\n**Ação de remediação**\n\nPara ativar a Proteção contra DDoS para endereços IP públicos, consulte a seguinte documentação do Microsoft Learn:\n\n- [Visão geral da Proteção contra DDoS do Azure](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview)\n- [Início rápido: Criar e configurar a Proteção de Rede DDoS do Azure usando o portal do Azure](https://learn.microsoft.com/en-us/azure/ddos-protection/manage-ddos-protection)\n- [Início rápido: Criar e configurar a Proteção de IP DDoS do Azure usando o portal do Azure](https://learn.microsoft.com/en-us/azure/ddos-protection/manage-ddos-ip-protection-portal)\n- [Comparação de SKU de Proteção contra DDoS do Azure](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-sku-comparison)\n\n",
      "TestImplementationCost": "Low",
      "TestId": 25533,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": [
        "DDoS_Network_Protection",
        "DDoS_IP_Protection"
      ],
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "A Proteção contra DDoS está ativada para todos os Endereços IP Públicos em VNETs"
    },
    {
      "TestResult": "\nIgnorado. Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)\n",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Gerenciamento de postura de segurança de dados",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "EXCHANGE_S_ENTERPRISE"
      ],
      "TestPillar": "Data",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "NoCompatibleLicenseFound",
      "TestId": "35039",
      "TestTitle": "Monitoramento de conformidade de comunicação configurado para o Microsoft Copilot",
      "TestDescription": "Até que as organizações configurem políticas de Conformidade de Comunicação para capturar as interações do Copilot, elas não conseguem perceber quando os usuários expõem dados sensíveis a serviços de IA. Também não conseguem identificar como as pessoas usam o Copilot com informações confidenciais, nem detectar possíveis violações de política. Como resultado, os usuários podem compartilhar inadvertidamente registros de clientes, dados financeiros, código-fonte ou segredos comerciais com serviços de IA.\n\nAs políticas de conformidade de comunicação focadas em interações do Copilot dão às organizações uma supervisão clara do uso de IA, ao mesmo tempo em que respeitam os controles de privacidade. Essas políticas mostram como os usuários trabalham com dados sensíveis em recursos de IA e ajudam a garantir que as equipes cumpram os requisitos de governança e conformidade de dados.\n\n**Ação de remediação**\n\n- [Criar e gerenciar políticas de Comunicação em Conformidade](https://learn.microsoft.com/purview/communication-compliance-policies?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": "Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"
    },
    {
      "TestResult": "\nIgnorado. Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)\n",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Proteção de Informações",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "EXCHANGE_S_ENTERPRISE"
      ],
      "TestPillar": "Data",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "NoCompatibleLicenseFound",
      "TestId": "35021",
      "TestTitle": "Auto-labeling policies are enabled for SharePoint and OneDrive",
      "TestDescription": "Quando a aplicação automática de rótulo para o SharePoint e OneDrive não está configurada, os arquivos carregados sem rótulos de sensibilidade podem não ser visíveis para as políticas de Proteção contra Perda de Dados (DLP) que dependem de rótulos. Como resultado, esses arquivos podem se mover pelo ambiente com menos salvaguardas, o que pode aumentar o risco de compartilhamento ou acesso inadequado.\n    \nPor exemplo, ao habilitar pelo menos uma política de aplicação automática de rótulo no modo de aplicação para o SharePoint e OneDrive, ajuda a classificar arquivos sensíveis quando os usuários os criam ou editam. A classificação de aplicação automática suporta proteções a jusante, como políticas DLP, para que possam responder com base na sensibilidade do arquivo e ajudar a reduzir o risco de exposção de dados.\n\n**Ação de remediação**\n\n- [Aplicar rótulos de sensibilidade automaticamente para o SharePoint e OneDrive](https://learn.microsoft.com/purview/apply-sensitivity-label-automatically?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": "Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"
    },
    {
      "TestResult": "\nIgnorado. Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)\n",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Proteção de Informações",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "EXCHANGE_S_ENTERPRISE"
      ],
      "TestPillar": "Data",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "NoCompatibleLicenseFound",
      "TestId": "35019",
      "TestTitle": "As políticas de aplicação automática de rótulos estão configuradas para todas as cargas de trabalho",
      "TestDescription": "A aplicação automática de rótulos estende muito seu alcance de rotulagem, rotulando automaticamente itens com base na inspeção de conteúdo. Quando você depende apenas da rotulagem manual, os usuários podem nem sempre reconhecer o que é considerado dado sensível ou podem esquecer de rotular informações durante suas tarefas diárias. Rótulos padrão oferecem uma linha de base de proteção, mas não levam em consideração o conteúdo que requer um nível mais alto de proteção. Isso leva a lacunas na classificação, permitindo que o conteúdo sensível se mova pelos aplicativos do Microsoft 365 sem rótulos ou proteção apropriados.\n\nVocê pode configurar configurações de aplicação automática de rótulos para rótulos que são acionados quando os usuários abrem arquivos em seus aplicativos do Office, e políticas de aplicação automática de rótulos que não exigem interação do usuário. Configurar pelo menos uma política de aplicação automática de rótulo para detectar conteúdo sensível rotula automaticamente esse conteúdo, independentemente das ações que as pessoas executem. Por sua vez, esse conteúdo rotulado pode ser usado com outras soluções do Microsoft Purview para aumentar sua segurança, como regras de prevenção de perda de dados (DLP) e restrições de acesso.\n\n**Ação de remediação**\n\n- [Aplicar automaticamente um rótulo de sensibilidade aos dados do Microsoft 365](https://learn.microsoft.com/purview/apply-sensitivity-label-automatically?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": "Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"
    },
    {
      "TestResult": "\nNão há licenças do GSA disponíveis neste locatário.\r\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Internet_Access",
        "Entra_Premium_Private_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "NotApplicable",
      "TestId": 25375,
      "TestTitle": "Licenças do Global Secure Access estão disponíveis no locatário e atribuídas aos usuários",
      "TestDescription": "O Global Secure Access requer licenças específicas do Microsoft Entra, incluindo Microsoft Entra Internet Access e Microsoft Entra Private Access, ambos com Microsoft Entra ID P1 como pré-requisito. Sem licenças válidas provisionadas no locatário, os administradores não podem configurar perfis de encaminhamento de tráfego, políticas de segurança ou conexões de rede remota. Se você não atribuir licenças aos usuários, o tráfego deles não é roteado pelo Global Secure Access e permanece sem a proteção dos controles de segurança.\n\nSem essa proteção:\n\n- Os agentes de ameaça podem contornar filtragem de conteúdo da web, proteção contra ameaças e políticas de Conditional Access.\n- Assinaturas expiradas ou suspensas podem interromper o serviço Global Secure Access, criando lacunas de segurança em que tráfego anteriormente protegido não é monitorado.\n\n**Ação de remediação**\n\n- Reveja os requisitos de licenciamento do Global Secure Access e adquira as licenças apropriadas. Para mais informações, veja [Visão geral de licenciamento](https://learn.microsoft.com/entra/global-secure-access/overview-what-is-global-secure-access?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#licensing-overview).\n- Atribua licenças aos usuários pelo centro de administração do Microsoft Entra. Para mais informações, veja [Atribuir licenças a usuários](https://learn.microsoft.com/entra/fundamentals/license-users-groups?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Use licenciamento baseado em grupo para facilitar o gerenciamento em escala. Para mais informações, veja [Licenciamento baseado em grupo](https://learn.microsoft.com/entra/fundamentals/concept-group-based-licensing?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Monitore a utilização de licenças pelo centro de administração do Microsoft 365. Para mais informações, veja [Microsoft 365 admin center](https://admin.microsoft.com/Adminportal/Home#/licenses).\n- Avalie o Microsoft Entra Suite como alternativa que inclui Internet Access e Private Access. Para mais informações, veja [Novidades do Microsoft Entra](https://learn.microsoft.com/entra/fundamentals/whats-new?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#microsoft-entra-suite).\n",
      "SkippedReason": "Este teste não se aplica ao ambiente atual."
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste depende de funcionalidades não disponíveis atualmente (ex.: cmdlets não disponíveis em todas as plataformas, Resolve-DnsName)",
      "TestResult": "\nIgnorado. Este teste depende de funcionalidades não disponíveis atualmente (ex.: cmdlets não disponíveis em todas as plataformas, Resolve-DnsName)\n",
      "TestDescription": "A filtragem baseada em inteligência de ameaça do Azure Firewall alerta e nega o tráfego de e para endereços IP maliciosos conhecidos, nomes de domínio totalmente qualificados (FQDNs) e URLs provenientes do feed de Inteligência de Ameaça da Microsoft. Quando você não ativa a inteligência de ameaça no modo `Alerta e negar`, o Azure Firewall não bloqueia ativamente o tráfego para destinos maliciosos conhecidos.\n\nSe você não ativar a inteligência de ameaça no modo `Alerta e negar`:\n\n- Atores de ameaça podem se comunicar com infraestrutura maliciosa conhecida, permitindo exfiltração de dados e comunicação de comando e controle sem bloqueio ativo.\n- As organizações que usam o modo `Apenas alerta` podem ver atividade de ameaça em logs, mas não conseguem impedir conexões com destinos maliciosos conhecidos.\n- Todos os níveis de política de firewall permanecem expostos a ameaças que o feed de Inteligência de Ameaça da Microsoft já identificou.\n\n**Ação de remediação**\n\n- [Configure as configurações de inteligência de ameaça no Gerenciador de Firewall do Azure](https://learn.microsoft.com/azure/firewall-manager/threat-intelligence-settings?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para definir o modo de inteligência de ameaça como `Alerta e negar` na política de firewall.\n",
      "TestImplementationCost": "Low",
      "TestId": 25537,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotSupported",
      "TestAppliesTo": null,
      "TestMinimumLicense": [
        "Azure_Firewall_Standard",
        "Azure_Firewall_Premium"
      ],
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "A inteligência de ameaça está Ativada no Modo Negar no Azure Firewall"
    },
    {
      "TestResult": "\nIgnorado. Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)\n",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Classificação Avançada",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "EXCHANGE_S_ENTERPRISE"
      ],
      "TestPillar": "Data",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "NoCompatibleLicenseFound",
      "TestId": "35034",
      "TestTitle": "Exact Data Match is configured for sensitive information detection",
      "TestDescription": "A correspondentes de dados exatos (EDM) é um tipo de informação sensível avançado que detecta dados específicos da organização correspondendo valores exatos em um banco de dados de referência carregado. Diferentemente dos tipos de informação sensível (SITs) baseados em padrões que detectam formatos comuns, EDM identifica coisas como listas de clientes, IDs de funcionários ou códigos proprietários únicos da sua organização. Sem EDM, as políticas de aplicação automática de rótulo e as regras DLP não podem detectar esses dados proprietários, deixando-os em risco de exposição.\n\n**Ação de remediação**\n\n- [Saiba mais sobre tipos de informação sensível baseado em correspondentes de dados exatos](https://learn.microsoft.com/purview/sit-learn-about-exact-data-match-based-sits?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Comece com tipos de informação sensível baseado em correspondentes de dados exatos](https://learn.microsoft.com/purview/sit-get-started-exact-data-match-based-sits-overview?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": "Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Skipped",
      "TestCategory": "Monitoramento",
      "SkippedReason": "Este teste é para tenants licenciados para o Entra Workload ID. Consulte [Licenciamento do Entra Workload ID](https://learn.microsoft.com/entra/workload-id/workload-identities-faqs)",
      "TestResult": "\nIgnorado. Este teste é para tenants licenciados para o Entra Workload ID. Consulte [Licenciamento do Entra Workload ID](https://learn.microsoft.com/entra/workload-id/workload-identities-faqs)\n",
      "TestDescription": "Os agentes de ameaças visam cada vez mais as identidades de carga de trabalho (aplicativos, entidades de serviço e identidades gerenciadas) porque elas carecem de fatores humanos e geralmente usam credenciais de longa duração. Um comprometimento geralmente segue o seguinte caminho:\n\n1. Abuso de credenciais ou roubo de chaves.\n2. Logons não interativos em recursos na nuvem.\n3. Movimentação lateral via permissões de aplicativos.\n4. Persistência por meio de novos segredos ou atribuições de funções.\n\nO Microsoft Entra ID Protection gera continuamente detecções de identidades de carga de trabalho de risco e sinaliza eventos de logon com estado e detalhes de risco. Logons de identidades de carga de trabalho de risco que não são triados (confirmados como comprometidos, descartados ou marcados como seguros), a fadiga de detecção e um grande acúmulo de alertas podem ser desafiadores para os administradores de TI gerenciarem. Essa carga de trabalho pesada pode permitir que acessos maliciosos repetidos, escalonamento de privilégios e repetição de tokens continuem passando despercebidos. Para tornar a carga de trabalho gerenciável, trate os logons de identidades de carga de trabalho de risco em duas partes:\n\n- Fechar o ciclo: Trie os logons e registre uma decisão definitiva sobre cada evento de risco.\n- Promover a contenção: Desative o principal de serviço, rotacione as credenciais ou revogue as sessões.\n\n**Ação de correção**\n\n- [Investigar identidades de carga de trabalho de risco e realizar a remediação apropriada](https://learn.microsoft.com/entra/id-protection/concept-workload-identity-risk?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Descartar riscos de identidade de carga de trabalho quando determinados como falsos positivos](https://learn.microsoft.com/graph/api/riskyserviceprincipal-dismiss?view=graph-rest-1.0&preserve-view=true&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Confirmar identidades de carga de trabalho comprometidas quando os riscos são validados](https://learn.microsoft.com/graph/api/riskyserviceprincipal-confirmcompromised?view=graph-rest-1.0&preserve-view=true&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "High",
      "TestId": 22659,
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "NotLicensedEntraWorkloadID",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P2",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Todos os logons de identidades de carga de trabalho de risco são triados"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nIgnorado. Este teste não se aplica ao ambiente atual.\n",
      "TestDescription": "O Azure Firewall Premium fornece detecção e prevenção de intrusões (IDPS) baseada em assinatura que identifica ataques detectando padrões específicos no tráfego de rede, como sequências de bytes e sequências de instruções maliciosas conhecidas usadas por malware. O IDPS aplica-se ao tráfego de entrada, leste-oeste (falou-para-falou) e de saída nas Camadas 3-7. Quando o IDPS não está configurado no modo `Alerta e negar`, o Azure Firewall apenas registra ameaças detectadas sem bloqueá-las.\n\nSem IDPS ativado no modo `Alerta e negar`:\n\n- Atores de ameaça podem enviar tráfego que corresponde a assinaturas de ataque conhecidas sem serem bloqueados.\n- As organizações que executam o IDPS no modo `Apenas alerta` ganham visibilidade nas ameaças, mas não conseguem impedir tentativas de intrusão de alcançar suas cargas de trabalho.\n- O tráfego de movimento lateral e exfiltração que corresponde a assinaturas de ataque conhecidas passa pelo firewall sem intervenção ativa.\n\n**Ação de remediação**\n\n- [Ative o IDPS no modo Alerta e Negar no Azure Firewall Premium](https://learn.microsoft.com/azure/firewall/premium-features?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) configurando o modo de detecção de intrusão como `Alerta e negar` na política de firewall.\n",
      "TestImplementationCost": "Low",
      "TestId": 25539,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Azure_Firewall_Premium",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "A Inspeção de IDPS está Ativada no Modo Negar no Azure Firewall"
    },
    {
      "TestResult": "\nIgnorado. Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)\n",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Proteção de Informações",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "EXCHANGE_S_ENTERPRISE"
      ],
      "TestPillar": "Data",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "NoCompatibleLicenseFound",
      "TestId": "35020",
      "TestTitle": "Auto-labeling policies are in enforcement mode",
      "TestDescription": "Quando politicas de rotulagem automatica permanecem no modo de simulacao, a protecao por rotulo desses dados nao e aplicada. Como resultado, usuarios e servicos nao conseguem adotar medidas adicionais para proteger os dados sensiveis identificados. Por exemplo, os usuarios nao verão em seus aplicativos do Office que um arquivo foi rotulado como Altamente Confidencial. Regras de prevencao contra perda de dados podem usar rotulos de sensibilidade para bloquear compartilhamento com usuarios externos e outras acoes de risco. Dados rotulados tambem fornecem uma camada adicional de protecao ao usar o Microsoft 365 Copilot.\n\nPara garantir que informacoes sensiveis sejam rotuladas automaticamente, ative pelo menos uma politica de rotulagem automatica. Ativar essas politicas apos os testes de simulacao coloca as medidas de protecao em vigor e comeca a reduzir o risco.\n\n**Ação de remediação**\n\n- [Como configurar politicas de rotulagem automatica para SharePoint, OneDrive e Exchange](https://learn.microsoft.com/purview/apply-sensitivity-label-automatically?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#how-to-configure-auto-labeling-policies-for-sharepoint-onedrive-and-exchange)\n",
      "SkippedReason": "Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"
    },
    {
      "TestResult": "\nA inspeção de TLS não está configurada neste locaário. Esta verificação não é aplicável até que uma política de inspeção de TLS seja criada.\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "NotSupported",
      "TestId": 27003,
      "TestTitle": "A taxa de falha da inspeção de TLS está abaixo de 1%",
      "TestDescription": "Ao usar inspeção de Transport Layer Security (TLS), o Global Secure Access pode descriptografar tráfego HTTPS e verificá-lo contra ameaças, conteúdo malicioso e violações de política. Quando a inspeção falha, o tráfego pode contornar controles de segurança, permitindo que malware, comando e controle e exfiltração de dados passem sem detecção.\n\nTaxas de falha acima de 1% indicam problemas sistêmicos, como confiança de certificado inadequada em endpoints, aplicações incompatíveis com certificate pinning sem regras de bypass apropriadas, ou erros de configuração de autoridade certificadora. Agentes mal-intencionados também podem provocar falhas de inspeção intencionalmente.\n\n**Ação de remediação**\n\n- [Configure definições de diagnóstico para exportar logs de tráfego](https://learn.microsoft.com/entra/global-secure-access/how-to-view-traffic-logs?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#configure-diagnostic-settings-to-export-logs) para um workspace do Log Analytics. Use esses logs para monitorar taxas de sucesso da inspeção TLS e investigar causas de falhas.\n- Siga as etapas em [Solucionar erros de inspeção de Transport Layer Security no Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/troubleshoot-transport-layer-security?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para resolver falhas comuns.\n- Para destinos com certificate pinning, [adicione regras de bypass TLS](https://learn.microsoft.com/entra/global-secure-access/how-to-transport-layer-security?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para reduzir falhas e manter inspeção no restante do tráfego.\n",
      "SkippedReason": "Este teste depende de funcionalidades não disponíveis atualmente (ex.: cmdlets não disponíveis em todas as plataformas, Resolve-DnsName)"
    },
    {
      "TestResult": "\nIgnorado. Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)\n",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Gerenciamento de postura de segurança de dados",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "EXCHANGE_S_ENTERPRISE"
      ],
      "TestPillar": "Data",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "NoCompatibleLicenseFound",
      "TestId": "35038",
      "TestTitle": "Políticas de Insider Risk Management habilitadas para uso arriscado de IA",
      "TestDescription": "Até que as organizações usem o Insider Risk Management com Proteção Adaptativa, elas podem deixar de detectar ameaças internas, comportamentos de risco como o uso indevido de acesso legítimo para exfiltrar dados, ou cenários inseguros de IA em que os usuários expõem dados sensíveis a grandes modelos de linguagem ou serviços de IA em nuvem não autorizados.\n\nO Insider Risk Management trabalha com Data Loss Prevention (DLP) para combinar sinais de comportamento do usuário com regras baseadas em conteúdo, ajudando as equipes a detectar riscos cedo e responder antes que dados sensíveis sejam expostos ou comprometidos.\n\n**Ação de remediação**\n\n- [Criar e configurar políticas de Insider Risk Management](https://learn.microsoft.com/purview/insider-risk-management-policies?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Ajudar a mitigar riscos dinamicamente com Proteção Adaptativa](https://learn.microsoft.com/purview/insider-risk-management-adaptive-protection?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": "Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nNenhuma política de WAF do Azure Front Door anexada ao Azure Front Door encontrada.\n",
      "TestDescription": "O Web Application Firewall (WAF) do Azure Front Door oferece limitacao de taxa por meio de regras personalizadas que restringem o numero de requisicoes que os clientes podem fazer dentro de uma janela de tempo especifica na rede global de borda. A limitacao de taxa e um mecanismo de defesa critico que protege aplicacoes contra abuso, reduzindo a velocidade de clientes que excedem os limites definidos antes que o trafego alcance os servidores de origem.\n\nSem a limitacao de taxa configurada, agentes mal-intencionados podem executar ataques de forca bruta, credential stuffing, abuso de API e ataques de negacao de servico na camada de aplicacao que inundam endpoints com requisicoes e esgotam a capacidade do servidor.\n\nAs regras de limitacao de taxa usam o tipo de regra `RateLimitRule` e permitem que administradores definam limites com base na contagem de requisicoes por minuto, com possibilidade de agrupar requisicoes por endereco IP do cliente. Quando um cliente ultrapassa o limite configurado, o WAF pode bloquear requisicoes subsequentes, registrar a violacao, emitir um desafio CAPTCHA ou redirecionar para uma pagina personalizada.\n\nEsta verificacao identifica politicas de WAF do Azure Front Door que estao anexadas a um Azure Front Door e valida se pelo menos uma regra de limitacao de taxa esta configurada e habilitada.\n\n**Ação de remediação**\n\n- [Web Application Firewall do Azure no Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview)\n- [Regras personalizadas do Web Application Firewall para Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-custom-rules)\n- [Limitacao de taxa para o WAF do Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-rate-limit)\n- [Tutorial: Criar uma politica de Web Application Firewall no Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-create-portal)\n\n",
      "TestImplementationCost": "Medium",
      "TestId": 27018,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Azure_WAF",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "A limitação de taxa está habilitada no WAF do Azure Front Door"
    },
    {
      "TestResult": "\nNenhum aplicativo Private Access configurado neste locatário.\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "NotApplicable",
      "TestId": 25398,
      "TestTitle": "O acesso RDP a controladores de domínio está protegido por autenticação resistente a phishing via Global Secure Access",
      "TestDescription": "Quando os administradores usam o Microsoft Entra Private Access para alcançar controladores de domínio via Remote Desktop Protocol (RDP), eles autenticam-se através do Microsoft Entra ID antes que o cliente Global Secure Access túnelize a conexão para a rede local. Os controladores de domínio detêm as chaves criptográficas de toda a floresta Active Directory. Comprometer um controlador de domínio oferece uma maneira de comprometer todas as identidades e recursos na organização.\n\nSem autenticação resistente a phishing:\n\n- Agentes de ameaça podem interceptar credenciais durante campanhas de phishing ou ataques de adversário no meio.\n- Tokens de sessão roubados podem ser reproduzidos para estabelecer conexões RDP com controladores de domínio.\n- Uma vez conectados, agentes de ameaça podem executar ataques DCSync para coletar todos os hashes de senha do domínio.\n- Ataques podem criar golden tickets para persistência indefinida no domínio.\n- Objetos de Política de Grupo podem ser modificados para implantar ransomware ou backdoors em todas as máquinas ingressadas no domínio.\n\nAo exigir autenticação resistente a phishing, as organizações garantem que, mesmo que os usuários sejam vítimas de phishing, os agentes de ameaça não possam reproduzir credenciais porque esses métodos exigem comprovação criptográfica de posse.\n\n**Ação de remediação**\n\n- [Implemente métodos de autenticação resistente a phishing para administradores de controladores de domínio](https://learn.microsoft.com/entra/identity/authentication/how-to-deploy-phishing-resistant-passwordless-authentication?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- [Exija autenticação resistente a phishing para administradores que acessam controladores de domínio via RDP](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-domain-controllers?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": "Este teste não se aplica ao ambiente atual."
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nIgnorado. Este teste não se aplica ao ambiente atual.\n",
      "TestDescription": "O Azure Firewall Premium oferece inspeção de TLS (Transport Layer Security) para descriptografar e inspecionar tráfego de saída e leste-oeste, e tráfego de entrada de TLS quando usado com o Azure Application Gateway. A inspeção de TLS é crítica para detectar ameaças avançadas que usam canais criptografados para contornar controles de segurança tradicionais.\n\nQuando a inspeção de TLS está ativada, o Azure Firewall usa um certificado de autoridade de certificação (CA) fornecido pelo cliente armazenado no Azure Key Vault para descriptografar, inspecionar e depois criptografar novamente o tráfego antes de encaminhá-lo para seu destino. Isso permite recursos de segurança avançados, como IDPS e filtragem de URL, para analisar tráfego criptografado e identificar atividades maliciosas que de outro modo permaneceriam ocultas.\n\nEssa verificação verifica se o Azure Firewall Premium tem a inspeção de TLS ativada. Sem a inspeção de TLS, o firewall não consegue inspecionar payloads criptografados, limitando significativamente a visibilidade em ameaças que usam TLS para contornar a detecção.\n\n**Ação de remediação**\n\n- [Guia de implementação de recursos do Azure Firewall Premium](https://learn.microsoft.com/en-us/azure/firewall/premium-features)\n- [Implantar e configurar certificados de CA corporativa para o Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/premium-deploy-certificates-enterprise-ca)\n- [Certificados do Azure Firewall Premium](https://learn.microsoft.com/en-us/azure/firewall/premium-certificates)\n\n",
      "TestImplementationCost": "Low",
      "TestId": 25550,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Azure_Firewall_Premium",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "A inspeção de tráfego TLS de saída está habilitada no Azure Firewall"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "O usuário conectado não tem acesso à assinatura do Azure para realizar este teste.",
      "TestResult": "\nIgnorado. O usuário conectado não tem acesso à assinatura do Azure para realizar este teste.\n",
      "TestDescription": "O Web Application Firewall (WAF) do Azure Front Door protege aplicações da web contra exploração de vulnerabilidades comuns, incluindo injeção de SQL, script entre sites e outras ameaças do OWASP Top 10. O WAF opera em dois modos: Detecção e Prevenção. O modo Detecção avalia e registra solicitações que correspondem às regras de WAF, mas não bloqueia o tráfego, enquanto o modo Prevenção bloqueia ativamente solicitações maliciosas antes de chegarem ao aplicativo de backend. Quando o WAF está no modo Detecção, os aplicativos da web permanecem expostos a exploração, embora as ameaças estejam sendo identificadas.\n\nSem WAF no modo Prevenção:\n\n- Atores de ameaça podem explorar vulnerabilidades de aplicativos da web porque as solicitações correspondidas são apenas registradas, não bloqueadas.\n- As organizações perdem a proteção ativa na borda global que as regras de WAF gerenciadas e personalizadas fornecem, o que reduz o WAF a uma ferramenta de observação em vez de um controle de segurança.\n\n**Ação de remediação**\n\n- [Configure o WAF para o Azure Front Door](https://learn.microsoft.com/azure/web-application-firewall/afds/afds-overview?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para mudar a política de WAF do **modo Detecção** para o **modo Prevenção**.\n- [Configure as configurações de política de WAF para o Azure Front Door](https://learn.microsoft.com/azure/web-application-firewall/afds/waf-front-door-policy-settings?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#waf-mode) para ativar o **modo Prevenção** nas configurações da política.\n",
      "TestImplementationCost": "Low",
      "TestId": 25543,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NoAzureAccess",
      "TestAppliesTo": null,
      "TestMinimumLicense": [
        "Azure WAF on Azure Front Door Premium SKU",
        "Azure Standard SKU"
      ],
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "O WAF do Azure Front Door está Habilitado em Modo Prevenção"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nNenhuma política de WAF do Application Gateway encontrada anexada aos Application Gateways.\n",
      "TestDescription": "O Web Application Firewall (WAF) do Azure Application Gateway oferece limitação de taxa por meio de regras personalizadas que restringem o número de requisições por janela de tempo. Esse controle protege aplicações contra abuso ao limitar clientes que excedem limiares definidos.\n\nSem limitação de taxa, agentes mal-intencionados podem executar brute force, credential stuffing, abuso de APIs e negação de serviço na camada de aplicação para esgotar recursos.\n\nAs regras de limitação de taxa usam `RateLimitRule` e permitem definir limiares por requisições/minuto, com agrupamento por IP do cliente (`groupBy` com `ClientAddr`). Ao exceder o limite, o WAF pode bloquear, registrar ou redirecionar. Diferente de rulesets gerenciados, essa defesa é quantitativa e reduz impacto de ataques volumétricos, mesmo quando requisições individuais parecem legítimas.\n\n\n**Ação de remediação**\n\n- [O que é o Azure Web Application Firewall no Azure Application Gateway?](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview) - Visão geral dos recursos do WAF no Application Gateway, incluindo regras personalizadas\n- [Criar e usar regras personalizadas do Web Application Firewall v2 no Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/create-custom-waf-rules) - Passo a passo para criar regras personalizadas, incluindo limitação de taxa\n- [Regras personalizadas do Web Application Firewall](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/custom-waf-rules-overview) - Documentação detalhada dos tipos de regra, incluindo `RateLimitRule`\n- [Limitação de taxa no WAF do Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/rate-limiting-overview) - Visão geral de capacidades e opções de configuração\n\n\n",
      "TestImplementationCost": "Medium",
      "TestId": 27016,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Azure WAF",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "A limitação de taxa está habilitada no WAF do Application Gateway"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Skipped",
      "TestCategory": "Colaboração externa",
      "SkippedReason": "Este teste é para tenants licenciados para o Entra Workload ID. Consulte [Licenciamento do Entra Workload ID](https://learn.microsoft.com/entra/workload-id/workload-identities-faqs)",
      "TestResult": "\nIgnorado. Este teste é para tenants licenciados para o Entra Workload ID. Consulte [Licenciamento do Entra Workload ID](https://learn.microsoft.com/entra/workload-id/workload-identities-faqs)\n",
      "TestDescription": "Quando identidades de carga de trabalho operam sem restrições de Acesso Condicional baseadas em rede, atores de ameaças podem comprometer credenciais de Service Principals através de vários métodos, como segredos expostos em repositórios de código ou interceptação de tokens de autenticação. Os invasores podem então usar essas credenciais de qualquer local do mundo. Esse acesso irrestrito permite que realizem atividades de reconhecimento, enumerem recursos e mapeiem a infraestrutura do tenant enquanto parecem legítimos. Uma vez estabelecido no ambiente, o invasor pode se mover lateralmente entre serviços, acessar armazenamentos de dados confidenciais e potencialmente escalar privilégios explorando permissões excessivas entre serviços. A falta de restrições de rede torna impossível detectar padrões de acesso anômalos baseados em localização. Essa lacuna permite que atores de ameaças mantenham acesso persistente e exfiltrem dados por longos períodos sem disparar alertas de segurança que normalmente sinalizariam conexões de redes ou localizações geográficas inesperadas.\n\n**Ação de correção**\n\n- [Configurar Acesso Condicional para identidades de carga de trabalho](https://learn.microsoft.com/entra/identity/conditional-access/workload-identity?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Criar locais nomeados (Named Locations)](https://learn.microsoft.com/entra/identity/conditional-access/concept-assignment-network?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Seguir as melhores práticas para proteger identidades de carga de trabalho](https://learn.microsoft.com/entra/workload-id/workload-identities-overview?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": 21884,
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "NotLicensedEntraWorkloadID",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Políticas de Acesso Condicional para identidades de carga de trabalho baseadas em redes conhecidas estão configuradas"
    },
    {
      "TestResult": "\nIgnorado. Este teste não se aplica ao ambiente atual.\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "NotApplicable",
      "TestId": 25416,
      "TestTitle": "O firewall de nuvem do Global Secure Access protege o tráfego de internet das filiais",
      "TestDescription": "Quando você conecta redes remotas ao Global Secure Access através de túneis IPsec, mas não configura políticas de firewall de nuvem, todo o tráfego vinculado à internet dos escritórios remotos passa pela Security Service Edge sem controles de filtragem de saída. Se um ator de ameaça ganhar acesso a uma estação de trabalho do escritório remoto, ele pode fazer conexões de saída para infraestrutura de comando e controle, exfiltrar dados em portas padrão ou fazer download de cargas maliciosas sem inspeção em nível de rede.\n\nSem firewall de nuvem do Global Secure Access:\n\n- Você não pode impor uma postura de negação por padrão ou restringir comunicações de saída de redes de escritório remoto para destinos da internet não autorizados.\n- Atores de ameaça podem preparar dados para exfiltração, mudar para recursos de nuvem ou se mover lateralmente sem detecção.\n- As defesas tradicionais do perímetro podem assumir que toda saída é legítima, resultando em lacunas na cobertura de segurança.\n\nAs políticas de firewall de nuvem vinculadas ao perfil base fornecem controle centralizado de saída para todo o tráfego de rede remota. Os administradores podem usar essas políticas para definir regras de filtragem granulares que restringem comunicações de saída não autorizadas.\n\n**Ação de remediação**\n\n- Como um pré-requisito para firewall de nuvem, [configure redes remotas para acesso à internet](https://learn.microsoft.com/entra/global-secure-access/how-to-create-remote-networks?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Siga as etapas em [Configurar firewall de nuvem do Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-cloud-firewall?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para:\n    - Criar uma política de firewall de nuvem com regras de filtragem apropriadas.\n    - Adicionar ou atualizar regras de firewall com base em IP de origem, IP de destino, portas e protocolos.\n    - Vincular a política de firewall de nuvem ao perfil base para redes remotas.\n",
      "SkippedReason": "Este teste não se aplica ao ambiente atual."
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nIgnorado. Este teste não se aplica ao ambiente atual.\n",
      "TestDescription": "Sem o log de diagnóstico habilitado no WAF do Azure Front Door, as equipes de segurança perdem visibilidade de ataques bloqueados, correspondências de regras, padrões de acesso e eventos na borda da rede. Tentativas de exploração por SQL injection, cross-site scripting e outros ataques OWASP Top 10 podem passar sem detecção. A ausência de logs também prejudica investigações e requisitos de auditoria.\n\n**Ação de remediação**\n\nConfigure as definições de diagnóstico do Azure Front Door para habilitar a coleta de logs do WAF\n- [Criar definições de diagnóstico no Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/create-diagnostic-settings)\n\nHabilite o log do WAF para capturar eventos de firewall e correspondências de regras\n- [Monitoramento e logging do WAF do Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-monitor)\n\nCrie um workspace do Log Analytics para armazenar e analisar logs do WAF\n- [Criar um workspace do Log Analytics](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/quick-create-workspace)\n\nMonitore o Azure Front Door usando logs e métricas de diagnóstico\n- [Monitor metrics and logs in Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-diagnostics)\n\n",
      "TestImplementationCost": "Low",
      "TestId": 26889,
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": [
        "Azure_FrontDoor_Standard",
        "Azure_FrontDoor_Premium"
      ],
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "O registro de diagnóstico está habilitado no WAF do Azure Front Door"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nIgnorado. Este teste não se aplica ao ambiente atual.\n",
      "TestDescription": "O Azure Front Door é um ponto de entrada global e escalável que usa a rede de borda da Microsoft para entregar aplicações web com desempenho e segurança. O WAF integrado ao Azure Front Door protege contra explorações e vulnerabilidades comuns na borda da rede. O ruleset Bot Manager, disponível no SKU Premium, protege contra bots maliciosos e permite bots legítimos, como rastreadores de busca. Sem essa proteção, a organização fica exposta a credential stuffing, scraping, bots de esgotamento de estoque e ataques de negação de serviço na camada de aplicação.\n\n**Ação de remediação**\n\nFaça upgrade para o Azure Front Door Premium, se estiver no Standard, para habilitar recursos de proteção contra bots\n- [Comparação de camadas do Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/standard-premium/tier-comparison)\n\nCrie uma política de WAF no SKU Premium, se ainda não existir\n- [Criar uma política de WAF para Azure Front Door no portal do Azure](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-create-portal)\n\nHabilite o ruleset Bot Manager na política de WAF\n- [Configurar proteção contra bots para Web Application Firewall](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-policy-configure-bot-protection)\n\nAssocie a política de WAF ao perfil do Azure Front Door por meio de políticas de segurança\n- [Add security policy in Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/how-to-configure-endpoints#add-security-policy)\n\nConfigure bot protection rules to customize actions for different bot categories\n- [Bot protection rule set on Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview#bot-protection-rule-set)\n\nMonitor bot traffic using Azure Front Door logs and metrics\n- [Monitor metrics and logs in Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-diagnostics)\n\n",
      "TestImplementationCost": "Low",
      "TestId": 26884,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Azure_Front_Door_Premium",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "O conjunto de regras de proteção contra bots está habilitado e atribuído no WAF do Azure Front Door"
    },
    {
      "TestResult": "\nIgnorado. Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)\n",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Prevenção contra Perda de Dados (DLP)",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "EXCHANGE_S_ENTERPRISE"
      ],
      "TestPillar": "Data",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "NoCompatibleLicenseFound",
      "TestId": "35030",
      "TestTitle": "Data loss prevention policies are enabled",
      "TestDescription": "Sem políticas de Prevenção contra Perda de Dados (DLP), os funcionários podem compartilhar livremente informações sensíveis por email, upload de arquivo ou comunicações do Microsoft Teams, aumentando o risco de brechas de dados e violações regulatórias.\n\nAs políticas DLP monitoram, detectam e previnem automaticamente a divulgação de informações sensíveis em cargas de trabalho do Microsoft 365, fornecendo proteção automatizada contra exfiltração de dados não autorizada.\n\n**Ação de remediação**\n\n- [Criar e configurar políticas DLP](https://learn.microsoft.com/purview/dlp-create-deploy-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": "Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nNo Application Gateway WAF policies attached to Application Gateways found across subscriptions.\n",
      "TestDescription": "O Web Application Firewall (WAF) do Azure Application Gateway fornece proteção centralizada para aplicações web contra explorações e vulnerabilidades comuns em nível regional. A inspeção do corpo da requisição é uma capacidade crítica que permite ao WAF analisar o conteúdo de requisições HTTP POST, PUT e PATCH em busca de padrões maliciosos. Quando essa inspeção está desabilitada, agentes mal-intencionados podem embutir SQL malicioso, scripts ou payloads de injeção de comando em formulários, chamadas de API e uploads, contornando a avaliação de regras do WAF. Isso abre caminho para exploração, acesso inicial, exfiltração de dados sensíveis e movimentação lateral. Os conjuntos de regras gerenciadas, como OWASP Core Rule Set e Bot Manager da Microsoft, não conseguem bloquear ameaças que não conseguem inspecionar.\n\n**Ação de remediação**\n\nVisão geral dos recursos do WAF no Application Gateway, incluindo inspeção de corpo da requisição\n- [O que é o Azure Web Application Firewall no Azure Application Gateway?](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview)\n\nOrientações para criar e configurar políticas de WAF, incluindo parâmetros de inspeção de corpo da requisição\n- [Criar políticas de Web Application Firewall para Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/create-waf-policy-ag)\n\nFAQ e boas práticas para ajuste do WAF, incluindo limites de inspeção de corpo da requisição\n- [Ajustar Web Application Firewall para Azure Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/application-gateway-waf-faq)\n\n",
      "TestImplementationCost": "Low",
      "TestId": 26879,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Azure WAF",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "A inspeção do corpo da solicitação está habilitada no WAF do Application Gateway"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Não conectado ao Azure.",
      "TestResult": "\nIgnorado. Não conectado ao Azure.\n",
      "TestDescription": "O Azure Firewall fornece inspeção centralizada, registro em log e imposição para tráfego de rede de saída. Quando você não roteia o tráfego de saída de cargas de trabalho integradas de rede virtual (VNet) através do Azure Firewall, o tráfego pode sair do seu ambiente sem inspeção ou imposição de política. As cargas de trabalho integradas de VNet incluem máquinas virtuais, pools de nós do AKS, App Service com integração de VNet e Azure Functions em VNet.\n\nSem rotear tráfego de saída através do Azure Firewall:\n\n- Atores de ameaça podem usar caminhos de saída não inspecionados para exfiltração de dados e comunicação de comando e controle.\n- As organizações perdem imposição consistente de controles de segurança de saída, como filtragem de inteligência de ameaças, detecção e prevenção de intrusões e inspeção TLS.\n- As equipes de segurança carecem de visibilidade nos padrões de tráfego de saída, o que dificulta a detecção e investigação de atividades de rede suspeitas.\n\n**Ação de remediação**\n\n- [Configure o roteamento do Azure Firewall](https://learn.microsoft.com/azure/firewall/tutorial-firewall-deploy-portal?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#configure-routing) para direcionar o tráfego de saída de sub-redes de carga de trabalho através do endereço IP privado do firewall.\n- [Gerenciar tabelas de rota e rotas](https://learn.microsoft.com/azure/virtual-network/manage-route-table?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para criar rotas definidas pelo usuário para a rota padrão (0.0.0.0/0) apontando para o IP privado do Azure Firewall.\n- [Controlar o tráfego de saída do App Service com o Azure Firewall](https://learn.microsoft.com/azure/app-service/network-secure-outbound-traffic-azure-firewall?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para cenários de integração de VNet do App Service.\n- [Configure as regras do Azure Firewall](https://learn.microsoft.com/azure/firewall/rule-processing?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para permitir o tráfego de saída necessário e bloquear destinos maliciosos.\n",
      "TestImplementationCost": "Medium",
      "TestId": 25535,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotConnectedAzure",
      "TestAppliesTo": null,
      "TestMinimumLicense": [
        "Azure_Firewall_Basic",
        "Azure_Firewall_Standard",
        "Azure_Firewall_Premium"
      ],
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "O tráfego de saída de cargas de trabalho integradas de VNET é roteado através do Azure Firewall"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Skipped",
      "TestCategory": "Monitoramento",
      "SkippedReason": "O usuário conectado não tem acesso à assinatura do Azure para realizar este teste.",
      "TestResult": "\nIgnorado. O usuário conectado não tem acesso à assinatura do Azure para realizar este teste.\n",
      "TestDescription": "Os logs de atividade e relatórios no Microsoft Entra podem ajudar a detectar tentativas de acesso não autorizado ou identificar quando as configurações do tenant mudam. Quando os logs são arquivados ou integrados a ferramentas de Gerenciamento de Informações e Eventos de Segurança (SIEM), as equipes de segurança podem implementar controles poderosos de monitoramento e detecção, busca proativa de ameaças (threat hunting) e processos de resposta a incidentes. Os logs e recursos de monitoramento podem ser usados para avaliar a integridade do tenant e fornecer evidências para conformidade e auditorias.\n\nSe os logs não forem arquivados regularmente ou enviados a uma ferramenta SIEM para consulta, torna-se difícil investigar problemas de entrada (sign-in). A ausência de logs históricos significa que as equipes de segurança podem perder padrões de tentativas de entrada malsucedidas, atividades incomuns e outros indicadores de comprometimento. Essa falta de visibilidade pode impedir a detecção oportuna de violações, permitindo que os atacantes mantenham acesso não detectado por períodos prolongados.\n\n**Ação de correção**\n\n- [Configurar as definições de diagnóstico do Microsoft Entra](https://learn.microsoft.com/entra/identity/monitoring-health/howto-configure-diagnostic-settings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Integrar os logs do Microsoft Entra com os logs do Azure Monitor](https://learn.microsoft.com/entra/identity/monitoring-health/howto-integrate-activity-logs-with-azure-monitor-logs?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Transmitir logs do Microsoft Entra para um hub de eventos](https://learn.microsoft.com/entra/identity/monitoring-health/howto-stream-logs-to-event-hub?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": 21860,
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": null,
      "TestSkipped": "NoAzureAccess",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Configurações de diagnóstico estão configuradas para todos os logs do Microsoft Entra"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nIgnorado. Este teste não se aplica ao ambiente atual.\n",
      "TestDescription": "O Web Application Firewall (WAF) do Azure Application Gateway protege aplicações da web contra exploração de vulnerabilidades comuns, incluindo injeção de SQL, script entre sites e outras ameaças do OWASP Top 10. O WAF opera em dois modos: Detecção e Prevenção. O modo Detecção registra solicitações correspondidas, mas não bloqueia o tráfego, enquanto o modo Prevenção bloqueia ativamente solicitações maliciosas antes de chegarem ao aplicativo de backend. Quando o WAF está no modo Detecção, os aplicações da web permanecem expostos a explorações, embora as ameaças estejam sendo identificadas.\n\nSem WAF no modo Prevenção:\n\n- Atores de ameaça podem explorar vulnerabilidades de aplicação da web, como injeção de SQL e script entre sites, porque as solicitações correspondidas são apenas registradas, não bloqueadas.\n- As organizações perdem a proteção ativa que as regras de WAF gerenciadas e personalizadas fornecem, o que reduz o WAF a uma ferramenta de observabilidade em vez de um controle de segurança.\n\n**Ação de remediação**\n\n- [Configure o WAF no Azure Application Gateway](https://learn.microsoft.com/azure/web-application-firewall/ag/ag-overview?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#waf-modes) para mudar a política de WAF do **modo Detecção** para o **modo Prevenção**.\n- [Crie e gerencie políticas de WAF para Application Gateway](https://learn.microsoft.com/azure/web-application-firewall/ag/create-waf-policy-ag?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para aplicar configurações do modo Prevenção em todas as instâncias do Application Gateway.\n",
      "TestImplementationCost": "Low",
      "TestId": 25541,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": [
        "Azure WAF",
        "Azure Application Gateway Standard SKU"
      ],
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "O WAF do Application Gateway está Habilitado em Modo Prevenção"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Skipped",
      "TestCategory": "Dispositivos",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nIgnorado. Este teste não se aplica ao ambiente atual.\n",
      "TestDescription": "Quando os administradores locais em dispositivos ingressados no Microsoft Entra não são gerenciados adequadamente, agentes de ameaça com credenciais comprometidas podem executar ataques de tomada de controle do dispositivo (takeover), removendo administradores organizacionais e desabilitando a conexão do dispositivo com o Microsoft Entra. Essa falta de controle resulta na perda completa do controle organizacional, criando ativos órfãos que não podem ser gerenciados ou recuperados.\n\n**Ação de remediação**\n\n- [Gerenciar os administradores locais em dispositivos ingressados no Microsoft Entra](https://learn.microsoft.com/entra/identity/devices/assign-local-admin?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#manage-the-microsoft-entra-joined-device-local-administrator-role)\n",
      "TestImplementationCost": "Low",
      "TestId": 21955,
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestTitle": "Gerenciar os administradores locais em dispositivos ingressados no Microsoft Entra"
    },
    {
      "TestResult": "\nIgnorado. Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)\n",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestStatus": "Skipped",
      "TestRisk": "High",
      "TestCategory": "Classificação Avançada",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "EXCHANGE_S_ENTERPRISE"
      ],
      "TestPillar": "Data",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "NoCompatibleLicenseFound",
      "TestId": "35035",
      "TestTitle": "Named entity sensitive information types are used in auto-labeling and data loss prevention policies",
      "TestDescription": "Os tipos de informação sensível de entidade nomeada (SITs) são classificadores Microsoft pré-construídos que detectam entidades sensíveis comuns como nomes de pessoas, endereços físicos e terminologia médica. Eles estendem a proteção de dados além da correspondência de padrões em classificação ciente de contexto e podem ser usados em políticas de aplicação automática de rótulo e regras DLP sem qualquer desenvolvimento personalizado.\n\n**Ação de remediação**\n\n- [Saiba mais sobre entidades nomeadas](https://learn.microsoft.com/purview/sit-named-entities-learn?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Use entidades nomeadas nas suas políticas de prevenção de perda de dados](https://learn.microsoft.com/purview/sit-named-entities-use?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": "Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Failed",
      "TestCategory": "Proteção de Informações",
      "SkippedReason": null,
      "TestResult": "\n❌ Marca personalizada de OME não está configurada; o portal de criptografia usa marca genérica da Microsoft.\n\n**Resumo:**\n\n- Total de configurações de OME: 1\n- Configuradas com marca personalizada: 0\n\n**Detalhes de configuração:**\n\n| Identidade da configuração | Texto de email | Logo configurada | Cor de fundo | Texto do portal | Texto de introdução | Texto de aviso |\n|:-----------------------|:-----------|:----------------|:-----------------|:------------|:------------------|:----------------|\n| OME Configuration | ❌ None | ❌ No | ❌ None | ❌ None | ❌ None | ❌ None |\n",
      "TestDescription": "Quando uma organização não usa modelos de marca personalizada, pessoas fora da empresa que recebem mensagens criptografadas podem ver um portal genérico com marca Microsoft. Como o portal não reflete a identidade da organização, os destinatários podem ter menos confiança sobre de onde a mensagem veio.\n\nOs modelos de marca personalizada permitem que as organizações adicionem seu logotipo, cores, avisos e detalhes de contato ao portal. Esses elementos ajudam o portal a parecer familiar para os destinatários e podem apoiar a confiança quando eles visualizam e interagem com mensagens criptografadas.\n\n**Ação de remediação**\n\n- [Adicione a marca da sua organização às suas mensagens criptografadas](https://learn.microsoft.com/purview/add-your-organization-brand-to-encrypted-messages?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "35027",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": [
        "Microsoft 365 E3",
        "Microsoft 365 E5",
        "Advanced Message Encryption add-on"
      ],
      "TestImpact": "Low",
      "TestRisk": "Low",
      "TestTitle": "Custom branding templates are configured for Microsoft Purview Message Encryption"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Failed",
      "TestCategory": "Rótulos de sensibilidade",
      "SkippedReason": null,
      "TestResult": "\n❌ A coautoria está desabilitada para documentos criptografados.\n\n\n\n## Detalhes de configuração\n\n| Configuração | Status |\n| :------ | :----- |\n| EnableLabelCoauth | ❌ Desabilitado |\n\n",
      "TestDescription": "Quando a co-autoria não está habilitada para documentos protegidos por rótulos de sensibilidade que aplicam criptografia, apenas uma pessoa pode editar o arquivo por vez quando usa aplicativos de desktop do Office. Como resultado, isso pode desacelerar os times, o que torna a colaboração difícil e pode atrasar a conclusão do projeto. Essa limitação é especialmente desafiadora para grupos que trabalham em projetos sensíveis que exigem criptografia por privacidade, mas também precisam trabalhar juntos com eficiência.\n\nAo ativar a co-autoria para arquivos criptografados com rótulos de sensibilidade, vários usuários autorizados podem editar o arquivo ao mesmo tempo em aplicativos de desktop do Office. A menos que você possa garantir que todos os usuários editam esses arquivos usando o Office na web, essa mudança remove o desaceleração de exigir checkout e permite que os times colaborem com eficiência sem sacrificar a segurança. A configuração de co-autoria também pode ser um requisito para outras funcionalidades de rotulagem.\n\n**Ação de remediação**\n\n- [Habilitar co-autoria para arquivos criptografados com rótulos de sensibilidade](https://learn.microsoft.com/purview/sensitivity-labels-coauthoring?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "35009",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E5",
      "TestImpact": "High",
      "TestRisk": "Low",
      "TestTitle": "A coautoria está habilitada para arquivos criptografados com rótulos de sensibilidade"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Failed",
      "TestCategory": "Criptografia",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhum rótulo DKE encontrado - a organização deve avaliar a implantação para dados críticos para a missão ou altamente regulados.\n\n\n### Resumo\n\n- Total de rótulos de sensibilidade: 7\n- Rótulos com DKE habilitado: 0\n\n### [Detalhes do rótulo de sensibilidade](https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels)\n\n| Nome do rótulo | Desabilitado | DKE habilitado | URL do endpoint DKE |\n|:-----------|:---------|:------------|:-----------------|\n| Interno e Restrito | False | False | N/A |\n| Uso Interno | False | False | N/A |\n| Uso Restrito | False | False | N/A |\n| Público | False | False | N/A |\n| Interno | False | False | N/A |\n| Confidencial | False | False | N/A |\n| Restrito | False | False | N/A |\n\n",
      "TestDescription": "Criptografia de Chave Dupla (DKE) fornece uma camada extra de proteção para dados altamente sensíveis exigindo duas chaves para descriptografar conteúdo: uma gerenciada pela Microsoft e outra pelo cliente. Essa abordagem de \"mantenha sua própria chave\" garante que a Microsoft não possa descriptografar o conteúdo mesmo com compulsão legal, atendendo a requisitos regulatórios rigorosos de soberania de dados.\n\nNo entanto, o DKE introduz complexidade operacional significativa, incluindo infraestrutura de serviço de chave dedicada, compatibilidade reduzida de recursos e aumento do ônus de suporte. As organizações devem manter 1-3 rótulos reservados para dados verdadeiramente críticos da missão ou altamente regulados, com justificativa comercial documentada para cada rótulo DKE. Use criptografia padrão para conteúdo comercial geral. Rótulos DKE excessivos (4 ou mais) criam sobrecarga de gerenciamento, confusão do usuário e reduzem colaboração. DKE nunca deve ser amplamente implantado, pois a indisponibilidade do serviço de chave impede o acesso aos documentos críticos do negócio.\n\n**Ação de remediação**\n\n- [Criptografia de Chave Dupla](https://learn.microsoft.com/purview/double-key-encryption?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Configurar Criptografia de Chave Dupla](https://learn.microsoft.com/purview/double-key-encryption-setup?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "35010",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E5",
      "TestImpact": "High",
      "TestRisk": "Low",
      "TestTitle": "Os rótulos de criptografia de chave dupla estão configurados"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "SharePoint Online",
      "SkippedReason": null,
      "TestResult": "\n✅ O recurso de IRM legado está desabilitado. As organizações devem usar rótulos de sensibilidade modernos para proteção de documentos.\n\n### Resumo de configuração do SharePoint Online\n\n**Configurações de locatário:**\n* IrmEnabled: False\n\n[Gerenciar o Gerenciamento de Direitos de Informação (IRM) no Centro de Administração do SharePoint](https://admin.microsoft.com/sharepoint?page=classicSettings&modern=true)\n\n",
      "TestDescription": "Integração do Gerenciamento de Direitos de Informação (IRM) nas bibliotecas do SharePoint Online é um recurso herdado que foi substituído pelas Permissões Avançadas do SharePoint (ESP). Qualquer biblioteca usando este recurso herdado deve ser sinalizada para migrar para capacidades mais novas.\n\n**Ação de remediação**\n\nPara desabilitar o IRM herdado no SharePoint Online:\n1. Identificar as bibliotecas que estão usando proteção IRM (auditar sites existentes)\n2. Planejar migração para rótulos de sensibilidade moderno com criptografia\n3. Conectar ao SharePoint Online: `Connect-SPOService -Url https://<tenant>-admin.sharepoint.com`\n4. Desabilitar IRM herdado: `Set-SPOTenant -IrmEnabled $false`\n5. Habilitar rótulos de sensibilidade modernos: `Set-SPOTenant -EnableAIPIntegration $true`\n6. Configurar e publicar rótulos de sensibilidade com criptografia para substituir políticas de IRM\n\n- [Habilitar rótulos de sensibilidade para o SharePoint e OneDrive](https://learn.microsoft.com/microsoft-365/compliance/sensitivity-labels-sharepoint-onedrive-files)\n- [SharePoint IRM e rótulos de sensibilidade (orientação de migração)](https://learn.microsoft.com/microsoft-365/compliance/sensitivity-labels-sharepoint-onedrive-files#sharepoint-information-rights-management-irm-and-sensitivity-labels)\n- [Criar e configurar rótulos de sensibilidade com criptografia](https://learn.microsoft.com/microsoft-365/compliance/encryption-sensitivity-labels)\n\n",
      "TestImplementationCost": "Low",
      "TestId": "35007",
      "TestSfiPillar": "",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E3",
      "TestImpact": "Low",
      "TestRisk": "Low",
      "TestTitle": "O Gerenciamento de Direitos de Informação está habilitado no SharePoint Online"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Acesso privilegiado",
      "SkippedReason": null,
      "TestResult": "\nAlertas de ativação estão configurados para funções privilegiadas.\n\n## Funções com alertas ausentes ou configurados incorretamente\n\n| Nome da Função | Destinatários Padrão | Destinatários Adicionais |\n| :--- | :--- | :--- |\n\n",
      "TestDescription": "Sem alertas de ativação para atribuições de funções privilegiadas, atores de ameaça podem escalar privilégios sem serem detectados. Essa falta de visibilidade cria um ponto cego onde os invasores podem ativar a função mais privilegiada e realizar ações maliciosas, como criar contas de backdoor, modificar políticas de segurança ou acessar dados confidenciais.\n\nO monitoramento desses alertas de ativação pode ajudar as equipes de segurança a distinguir entre atividades de escalonamento de privilégios autorizadas e não autorizadas.\n\n**Ação de correção**\n\n- [Configure notificações para funções privilegiadas](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-how-to-change-default-settings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#require-justification-on-active-assignment)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21820",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P2",
      "TestImpact": "Low",
      "TestRisk": "Low",
      "TestTitle": "Alerta de ativação para todas as atribuições de funções privilegiadas"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Passed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\n✅ A política de análise de pontos de extremidade foi encontrada e atribuída.\n\n\n## Políticas de Análise de Pontos de Extremidade\n\n| Nome da Política | Estado | Alvo da Atribuição |\n| :---------- | :----- | :---------------- |\n| [\\[JC2\\] Política de coleta de dados do Intune](https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/configuration) | ✅ Atribuída | **Included:** All Devices |\n\n",
      "TestDescription": "Se a análise de pontos de extremidade (endpoint analytics) não estiver ativada, os agentes de ameaças podem explorar lacunas na integridade, desempenho e postura de segurança dos dispositivos. Sem a visibilidade que a análise de pontos de extremidade proporciona, pode ser difícil para uma organização detetar indicadores como comportamento anómalo de dispositivos, atrasos na aplicação de patches ou desvios de configuração. Estas falhas permitem que os atacantes estabeleçam persistência e se movam lateralmente pelo ambiente.\n\nA ativação da análise de pontos de extremidade proporciona visibilidade sobre a integridade e o comportamento dos dispositivos, ajudando as organizações a detetar riscos, a responder rapidamente a ameaças e a manter uma postura forte de Zero Trust.\n\n**Ação de correção**\n\nRegiste os dispositivos Windows na análise de pontos de extremidade no Intune para monitorizar a integridade dos dispositivos e identificar riscos:\n- [Configurar análise de pontos de extremidade](https://learn.microsoft.com/intune/endpoint-analytics/configure?pivots=intune&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n\nPara mais informações, consulte:\n- [O que é a análise de pontos de extremidade?](https://learn.microsoft.com/intune/endpoint-analytics/index?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24576",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "Low",
      "TestTitle": "A análise de pontos de extremidade está ativada para ajudar a identificar riscos em dispositivos Windows"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "Rótulos de sensibilidade",
      "SkippedReason": null,
      "TestResult": "\n✅ Pelo menos uma política de rótulo habilitada é publicada para os usuários.\n\n### Resumo da Política de Rótulo\n\n* Total de Políticas Configuradas: 1\n* Políticas Habilitadas: 1\n* Políticas Desabilitadas: 0\n* Total de Usuários/Grupos com Acesso a Rótulo: All Users\n\n**Políticas:**\n| Nome da política | Habilitado | Rótulos incluíos | Publicado para |\n|:---|:---|:---|:---|\n| Política Padrão de Classificação | True | 4 | All Users/Groups |\n\n[Gerenciar Políticas de Rótulo no Microsoft Purview](https://purview.microsoft.com/informationprotection/labelpolicies)\n\n",
      "TestDescription": "Os rotulos devem ser publicados por meio de politicas de rotulo antes que os usuarios possam aplica-los a itens, como arquivos, emails e reunioes. As politicas de rotulo definem quais usuarios recebem quais rotulos, estabelecem o comportamento padrao de rotulagem e outros requisitos de rotulagem. Sem politicas publicadas, os rotulos de sensibilidade permanecem indisponiveis para os usuarios.\n\n**Ação de remediação**\n\n- [Criar e configurar rotulos de sensibilidade e suas politicas](https://learn.microsoft.com/purview/create-sensitivity-labels?tabs=classic-label-scheme&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#publish-sensitivity-labels-by-creating-a-label-policy)\n",
      "TestImplementationCost": "Low",
      "TestId": "35004",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E3",
      "TestImpact": "Medium",
      "TestRisk": "Low",
      "TestTitle": "As políticas de rótulos de sensibilidade são publicadas para os usuários"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Passed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\nPelo menos uma regra de limpeza de dispositivos existe.\n\n\n## Regras de Limpeza de Dispositivos\n\n| Nome da Regra | Plataforma ou SO |\n| :-------- | :------------- |\n| [Limpeza Pós 45 Dias](https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/DevicesMenu/~/deviceCleanUp) | all |\n\n\n",
      "TestDescription": "Se as regras de limpeza de dispositivos não estiverem configuradas no Intune, dispositivos inativos ou obsoletos podem permanecer visíveis no locatário indefinidamente. Isso leva a listas de dispositivos desordenadas, relatórios imprecisos e visibilidade reduzida do cenário de dispositivos ativos. Dispositivos não utilizados podem reter credenciais de acesso ou tokens, aumentando o risco de acesso não autorizado ou decisões de política mal informadas.\n\nAs regras de limpeza de dispositivos ocultam automaticamente dispositivos inativos das visualizações e relatórios de administração, melhorando a higiene do locatário e reduzindo o esforço administrativo. Isso apoia o Zero Trust mantendo um inventário de dispositivos preciso e confiável, preservando dados históricos para auditoria ou investigação.\n\n**Ação de remediação**\n\nConfigure as regras de limpeza de dispositivos do Intune para ocultar automaticamente dispositivos inativos do locatário:  \n- [Criar uma regra de limpeza de dispositivo](https://learn.microsoft.com/intune/intune-service/fundamentals/device-cleanup-rules?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#how-to-create-a-device-cleanup-rule)\n\nPara mais informações, veja:  \n- [Usar regras de limpeza de dispositivos do Intune](https://techcommunity.microsoft.com/blog/devicemanagementmicrosoft/using-intune-device-cleanup-rules-updated-version/3760854) *no blog Microsoft Tech Community*\n",
      "TestImplementationCost": "Low",
      "TestId": "24802",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "Low",
      "TestTitle": "Regras de limpeza de dispositivos mantêm a higiene do locatário ocultando dispositivos inativos"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Este teste verifica se o módulo legado Microsoft Online PowerShell (MSOnline) está bloqueado. Interfaces de gerenciamento legadas muitas vezes não suportam controles de segurança modernos, como Acesso Condicional e autenticação multifator moderna, tornando-as alvos preferenciais para atacantes.\n\n**Ação de correção**\n\n",
      "TestImplementationCost": "High",
      "TestId": "21843",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": null,
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Low",
      "TestTitle": "Bloquear o módulo legado Microsoft Online PowerShell"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "...\n\n**Ação de correção**\n\n",
      "TestImplementationCost": "High",
      "TestId": "21895",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Low",
      "TestTitle": "As credenciais de certificado de aplicativo são gerenciadas usando HSM"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "...\n\n**Ação de correção**\n\n",
      "TestImplementationCost": "Medium",
      "TestId": "21894",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Low",
      "TestTitle": "Todos os certificados de Registros de Aplicativos e Entidades de Serviço do Microsoft Entra devem ser emitidos por uma autoridade de certificação aprovada"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Este teste verifica se a conta de sincronização do diretório está restrita a locais nomeados (Named Locations) específicos. Ao restringir onde essas contas podem se autenticar, você reduz significativamente o risco de ataques que utilizam credenciais roubadas de redes externas ou não confiáveis.\n\n**Ação de correção**\n- [Usar a condição de localização em uma política de Acesso Condicional](https://learn.microsoft.com/entra/identity/conditional-access/location-condition?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- Crie uma política de Acesso Condicional visando a conta de sincronização e restringindo o acesso apenas aos endereços IP conhecidos da infraestrutura local.\n\n",
      "TestImplementationCost": "Low",
      "TestId": "21834",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": null,
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Low",
      "TestTitle": "Conta de sincronização do diretório restrita a um local nomeado específico"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Exigir o registro de autenticação multifator (MFA) para todos os usuários. Com base em estudos, sua conta tem mais de 99% menos probabilidade de ser comprometida se você estiver usando MFA. Mesmo que você não exija MFA o tempo todo, esta política garante que seus usuários estejam prontos quando for necessário.\n\n**Ação de correção**\n\n- [Configurar a política de registro de autenticação multifator](https://learn.microsoft.com/entra/id-protection/howto-identity-protection-configure-mfa-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21893",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P2",
      "TestImpact": "Medium",
      "TestRisk": "Low",
      "TestTitle": "Todos os usuários devem se registrar para MFA"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.",
      "TestDescription": "**Ação de correção**\n\n",
      "TestImplementationCost": "Low",
      "TestId": "21984",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Low",
      "TestTitle": "Nenhuma recomendação do Entra de baixa prioridade ativa encontrada"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Acesso privilegiado",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Este teste verifica se as credenciais da conta de sincronização do diretório (usada por ferramentas como o Microsoft Entra Connect ou Cloud Sync) foram rotacionadas recentemente. Credenciais de longa duração para contas altamente privilegiadas, como a de sincronização, aumentam o risco de persistência se forem comprometidas. A rotação regular ajuda a mitigar o impacto de vazamentos de credenciais.\n\n**Ação de correção**\n- [Gerenciar credenciais e certificados do Microsoft Entra Connect](https://learn.microsoft.com/entra/identity/hybrid/connect/how-to-connect-install-automatic-upgrade?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- Rotacione as chaves e credenciais usadas para a sincronização de diretório local.\n\n",
      "TestImplementationCost": "High",
      "TestId": "21833",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": null,
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Low",
      "TestTitle": "As credenciais da conta de sincronização do diretório foram rotacionadas recentemente"
    },
    {
      "TestResult": "\nTLS inspection is not configured in this tenant. This check is not applicable until a TLS inspection policy is created.\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Skipped",
      "TestRisk": "Low",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "NotApplicable",
      "TestId": 27004,
      "TestTitle": "As regras personalizadas de bypass de inspeção de TLS não duplicam os destinos de bypass do sistema",
      "TestDescription": "O Global Secure Access mantém uma lista de bypass do sistema com destinos automaticamente excluídos da inspeção de Transport Layer Security (TLS). Esses destinos representam incompatibilidades conhecidas, como certificate pinning, requisitos de TLS mútuo ou outras restrições técnicas. Regras personalizadas que duplicam destinos da lista de bypass do sistema são redundantes e sem benefício funcional.\n\nRegras redundantes consomem capacidade de política, geram sobrecarga administrativa e causam confusão sobre o que é realmente necessário. A inspeção TLS suporta até 1.000 regras e 8.000 destinos por locatário. Manter uma configuração limpa, com apenas regras de bypass necessárias, melhora a governança e facilita auditorias.\n\n**Ação de remediação**\n\n- Review and remove redundant custom TLS inspection bypass rules in the Microsoft Entra admin center. Navigate to **Global Secure Access** > **Secure** > **TLS inspection policies**.\n- Review [the destinations included in the system bypass list](https://learn.microsoft.com/entra/global-secure-access/faq-transport-layer-security?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#what-destinations-are-included-in-the-system-bypass).\n",
      "SkippedReason": "Este teste não se aplica ao ambiente atual."
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\r\nAs políticas de proteção de token não estão configuradas.\n\nNenhuma política de Conditional Access encontrada para plataformas Windows.\n\n\r\n",
      "TestDescription": "As políticas de proteção de token nos tenants do Entra ID são essenciais para proteger os tokens de autenticação contra uso indevido e acesso não autorizado. Sem essas políticas, os agentes de ameaça podem interceptar e manipular tokens, levando ao acesso não autorizado a recursos sensíveis. Isso pode resultar em exfiltração de dados, movimentação lateral na rede e possível comprometimento de contas privilegiadas.\r\n\r\nQuando a proteção de token não está configurada adequadamente, os agentes de ameaça podem explorar diversos vetores de ataque:\r\n\r\n1. **Roubo de token e ataques de replay** - Os invasores podem roubar tokens de autenticação de dispositivos comprometidos e reproduzi-los em locais diferentes\r\n2. **Sequestro de sessão** - Sem controles de sessão de sign-in seguro, os invasores podem sequestrar sessões legítimas de usuários\r\n3. **Abuso de token entre plataformas** - Tokens emitidos para uma plataforma (como mobile) podem ser indevidamente utilizados em outras plataformas (como navegadores web)\r\n4. **Acesso persistente** - Tokens comprometidos podem fornecer acesso não autorizado de longo prazo sem acionar alertas de segurança\r\n\r\nA cadeia de ataque normalmente envolve acesso inicial por meio de roubo de token, seguido de escalação de privilégios e persistência, culminando em exfiltração de dados e impacto em todo o ambiente Microsoft 365 da organização.\r\n\r\n**Ação de remediação**\r\n- [Configure políticas de Conditional Access conforme as práticas recomendadas](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-token-protection#create-a-conditional-access-policy)\r\n- [Proteção de token no Conditional Access do Microsoft Entra explicada](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-token-protection)\r\n- [Configurar controles de sessão no Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-session)\r\n\r\n",
      "TestImplementationCost": "Medium",
      "TestId": 21941,
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Políticas de proteção de token estão configuradas"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": null,
      "TestResult": "\n❌ **Falha**: A lista de senhas banidas personalizada não está habilitada ou está vazia.\n\n## Configurações de Senhas Banidas Personalizadas\n\n| Imposto | Lista de Senhas Banidas (Amostra) | Total de Termos |\n| :--- | :--- | :--- |\n| [Não](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/AuthenticationMethodsMenuBlade/~/PasswordProtection/fromNav/) |  | 0 |\n\n\n",
      "TestDescription": "Organizações que não preenchem e impõem a lista de senhas banidas personalizada se expõem a uma cadeia de ataque sistemática onde atores de ameaça exploram padrões previsíveis de senhas organizacionais. Esses atores de ameaça geralmente começam com fases de reconhecimento, coletando inteligência de fontes abertas (OSINT) em sites, redes sociais e registros públicos para identificar componentes prováveis de senhas. Com esse conhecimento, eles lançam ataques de password spray que testam variações de senhas específicas da organização em múltiplas contas de usuários, mantendo-se abaixo dos limites de bloqueio para evitar a detecção. Sem a proteção oferecida pela lista de senhas banidas personalizada, os funcionários frequentemente adicionam termos organizacionais familiares às suas senhas, como locais, nomes de produtos e termos da indústria, criando vetores de ataque consistentes.\n\nA lista de senhas banidas personalizada ajuda as organizações a fechar essa lacuna crítica para evitar senhas facilmente adivinháveis que poderiam levar ao acesso inicial e subsequente movimentação lateral dentro do ambiente.\n\n**Ação de remediação**\n\n- [Saiba como habilitar a proteção de senha banida personalizada e adicionar termos organizacionais](https://learn.microsoft.com/entra/identity/authentication/tutorial-configure-custom-password-protection?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21848",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Adicionar termos organizacionais à lista de senhas banidas"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma política de SSO de plataforma encontrada ou atribuída.\n\n\n",
      "TestDescription": "Se as políticas de SSO de plataforma não forem aplicadas em dispositivos macOS, os endpoints podem depender de mecanismos de autenticação inseguros ou inconsistentes, permitindo que invasores ignorem o Acesso Condicional e as políticas de conformidade. Isso abre as portas para a movimentação lateral em serviços de nuvem e recursos locais, especialmente quando identidades federadas são usadas. Agentes de ameaças podem persistir aproveitando tokens roubados ou credenciais em cache e exfiltrar dados sensíveis através de aplicativos não gerenciados ou sessões de navegador. A ausência de imposição de SSO também prejudica as políticas de proteção de aplicativos e as avaliações de postura do dispositivo, tornando difícil detectar e conter violações. Em última análise, a falha em configurar e atribuir políticas de SSO de plataforma para macOS compromete a segurança da identidade e enfraquece a postura de Zero Trust da organização.\n\nA aplicação de políticas de SSO de plataforma em dispositivos macOS garante uma autenticação consistente e segura em aplicativos e serviços. Isso fortalece a proteção da identidade, apoia a aplicação do Acesso Condicional e alinha-se ao Zero Trust, reduzindo a dependência de credenciais locais e melhorando as avaliações de postura.\n\n**Ação de correção**\n\nUse o Intune para configurar e atribuir políticas de SSO de plataforma para dispositivos macOS para aplicar a autenticação segura e fortalecer a proteção da identidade:\n- [Configurar SSO de plataforma para macOS no Intune](https://learn.microsoft.com/intune/intune-service/configuration/platform-sso-macos?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) – *Orientações passo a passo para habilitar o SSO de plataforma em dispositivos macOS.*\n- [Visão geral e opções de Logon Único (SSO) para dispositivos Apple no Microsoft Intune](https://learn.microsoft.com/intune/intune-service/configuration/use-enterprise-sso-plug-in-ios-ipados-macos?pivots=macos&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) – *Visão geral das opções de SSO disponíveis para plataformas Apple.*\n",
      "TestImplementationCost": "Medium",
      "TestId": "24568",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "O SSO de plataforma está configurado para fortalecer a autenticação em dispositivos macOS"
    },
    {
      "TestResult": "\n❌ A política de filtragem de conteúdo web não está configurada.\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Failed",
      "TestRisk": "Medium",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "",
      "TestId": "25408",
      "TestTitle": "As políticas de filtragem de conteúdo web estão configuradas",
      "TestDescription": "As políticas de filtragem de conteúdo web são a base do controle de acesso à internet no Global Secure Access. Sem políticas configuradas, os usuários têm acesso irrestrito a todos os destinos da internet, expondo a organização a malware, sites de phishing e conteúdo inadequado. Crie políticas de filtragem para bloquear categorias de sites perigosos e estabelecer controles básicos de acesso à internet.\n\n**Ação de remediação**\n\n- [Configure políticas de filtragem de conteúdo web](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-web-content-filtering?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": null,
      "TestResult": "\n❌ **Falha**: Foram encontrados domínios ou usuários com expiração de senha habilitada.\n\nVerifique as configurações de expiração de senha no portal.\n",
      "TestDescription": "Quando as políticas de expiração de senha permanecem ativadas, os atores de ameaça podem explorar os padrões previsíveis de rotação de senha que os usuários normalmente seguem quando forçados a alterar as senhas regularmente. Os usuários frequentemente criam senhas mais fracas fazendo modificações mínimas nas existentes, como incrementar números ou adicionar caracteres sequenciais. Os atores de ameaça podem facilmente antecipar e explorar esses tipos de alterações por meio de ataques de preenchimento de credenciais (credential stuffing) ou campanhas direcionadas de pulverização de senhas (password spraying). Esses padrões previsíveis permitem que os atores de ameaça estabeleçam persistência por meio de:\n\n- Credenciais comprometidas\n- Privilégios escalonados ao visar contas administrativas com senhas rotacionadas fracas\n- Manutenção de acesso de longo prazo prevendo variações futuras de senha\n\nPesquisas mostram que os usuários criam senhas mais fracas e previsíveis quando são forçados a expirar. Essas senhas previsíveis são mais fáceis de quebrar para invasores experientes, pois eles costumam fazer modificações simples nas senhas existentes em vez de criar senhas inteiramente novas e fortes. Além disso, quando os usuários são obrigados a alterar as senhas com frequência, eles podem recorrer a práticas inseguras, como anotar senhas ou armazená-las em locais de fácil acesso, criando mais vetores de ataque para os atores de ameaça explorarem durante o reconhecimento físico ou campanhas de engenharia social.\n\n**Ação de correção**\n\n- [Defina a política de expiração de senha para sua organização](https://learn.microsoft.com/microsoft-365/admin/manage/set-password-expiration-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n    - Entre no [centro de administração do Microsoft 365](https://admin.microsoft.com/). Vá para **Configurações** > **Configurações da Organização** > **Segurança e Privacidade** > **Política de expiração de senha**. Certifique-se de que a configuração **Definir senhas para nunca expirarem** esteja marcada.\n- [Desative a expiração de senha usando o Microsoft Graph](https://learn.microsoft.com/graph/api/domain-update?view=graph-rest-1.0&preserve-view=true&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- [Defina senhas de usuários individuais para nunca expirarem usando o Microsoft Graph PowerShell](https://learn.microsoft.com/microsoft-365/admin/add-users/set-password-to-never-expire?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n    - `Update-MgUser -UserId <UserID> -PasswordPolicies DisablePasswordExpiration`\n",
      "TestImplementationCost": "Low",
      "TestId": "21811",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "A expiração de senha está desabilitada"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma etiqueta de âmbito personalizada foi encontrada ou nenhuma está atribuída.\n\n\n",
      "TestDescription": "Se as Tags de Escopo (scope tags) do Intune não forem configuradas corretamente para a administração delegada, os atacantes que obtenham acesso privilegiado ao Intune ou ao Microsoft Entra ID podem escalar privilégios e aceder a configurações de dispositivos sensíveis em todo o tenant. Sem Tags de Escopo granulares, os limites administrativos são pouco claros, permitindo que os atacantes se movam lateralmente, manipulem políticas de dispositivos, exfiltrem dados de configuração ou implementem definições maliciosas em todos os utilizadores e dispositivos. Uma única conta de administrador comprometida pode afetar todo o ambiente. A ausência de administração delegada também prejudica o acesso com o menor privilégio, tornando difícil conter violações e garantir a responsabilidade. Os atacantes podem explorar funções de administrador global ou atribuições de controlo de acesso baseado em funções (RBAC) mal configuradas para contornar políticas de conformidade e ganhar um controlo amplo sobre a gestão de dispositivos.\n\nA aplicação de Tags de Escopo segmenta o acesso administrativo e alinha-o com os limites organizacionais. Isto limita o raio de impacto de contas comprometidas, apoia o acesso com o menor privilégio e alinha-se com os princípios Zero Trust de segmentação, controlo baseado em funções e contenção.\n\n**Ação de correção**\n\nUtilize Tags de Escopo e funções RBAC do Intune para limitar o acesso de administrador com base na função, geografia ou unidade de negócio:\n- [Saiba como criar e implementar Tags de Escopo para TI distribuída](https://learn.microsoft.com/intune/intune-service/fundamentals/scope-tags?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Implementar o controlo de acesso baseado em funções com o Microsoft Intune](https://learn.microsoft.com/intune/intune-service/fundamentals/role-based-access-control?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24555",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "A configuração de Tags de Escopo é aplicada para apoiar a administração delegada e o acesso com o menor privilégio"
    },
    {
      "TestResult": "\nAplicativo(s) inativo(s) com altos privilégios foram encontrados\n\n\n## Aplicativos com permissões privilegiadas do Graph\n\n| | Nome | Risco | Permissão Delegada | Permissão de Aplicativo | Tenant proprietário | Último logon|\n| :--- | :--- | :--- | :--- | :--- | :--- | :--- |\n| ❌ | [Graph Explorer](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/7c5a3bce-0478-40c4-be1d-657b55e4d655/appId/de8bc8b5-d9f9-48b1-a8ad-b748da725064) | High | openid, profile, User.Read, offline_access, User.Read.All, Directory.Read.All |  | PRDTRS01 | Unknown | \n| ❌ | [Key Cloak](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/f0312aa4-239e-4865-a530-5e339981edf0/appId/8235c322-0cfb-497a-a625-07000f1dd652) | High | Mail.Send, SMTP.Send, User.Read | Mail.Send | JC2Sec | Unknown | \n| ❌ | [Passbolt](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/5e8325d5-72ec-462c-a8b1-861020c76036/appId/708a5782-0e81-4c4a-849f-006f92a8cf24) | High |  | Mail.Send | JC2Sec | Unknown | \n| ❌ | [audit_cloud](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/40159f6d-95b0-4298-b3a0-fe5d0215766d/appId/37fb1f87-f350-4263-91df-f3b7c180e05b) | High |  | Reports.Read.All, DeviceManagementManagedDevices.Read.All, DeviceManagementConfiguration.Read.All, SecurityEvents.Read.All, Calendars.Read, DeviceManagementApps.Read.All, User.Read.All, Directory.Read.All, Policy.Read.All | JCADVISOR CONSULTORIA | Unknown | \n| ❌ | [VPN Server](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/383251dd-0e36-42e5-887b-d73c815250db/appId/273ffb4d-3d35-497a-84e2-d19128bfad8c) | High |  | Directory.Read.All | JCADVISOR CONSULTORIA | Unknown | \n| ✅ | [Amazon Alexa Connect](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/b9646c43-0f3a-4e17-92f1-a1450d044c32/appId/65ad87c3-6b07-40fa-93e6-e2a734bf2e9f) | High | People.Read, Contacts.Read, Calendars.Read.Shared, User.Read, Calendars.ReadWrite, Calendars.ReadWrite.Shared, offline_access |  | Amazon | 2023-01-18 | \n| ✅ | [SharePoint Online Client Extensibility Web Application Principal Helper](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/602547da-0cc6-4460-b5ab-46a46ea60d14/appId/563b9ed9-af42-4793-bcc7-1d5cae067152) | High | Directory.AccessAsUser.All |  | JCADVISOR CONSULTORIA | 2023-05-12 | \n| ✅ | [MyFiles](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/167d40d1-6b85-4dbd-8351-c3c1c79154f0/appId/d5e6af94-cdf0-4cf4-bc48-f9bfba16b189) | High | Files.ReadWrite, offline_access, User.Read |  | Microsoft Accounts | 2024-01-21 | \n| ✅ | [v1-app-registration-866c2573-b902-499d-a324-dc411b3ccd6d](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/a6e9bc42-4782-4e63-9783-4518aa521003/appId/4b20c8c0-cf01-4a55-aff2-327c328a6a45) | High |  | User.Read.All, Directory.Read.All, Directory.Read.All | JCADVISOR CONSULTORIA | 2024-02-08 | \n| ✅ | [Backup Service](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/6f97503e-0119-4629-9a6e-d06e63a2a057/appId/fc6e7496-1729-4d2b-8ed2-3afd50dd9a6a) | High | User.Read | User.ReadWrite.All, full_access_as_app, ChannelMessage.Read.All, Sites.Manage.All, TermStore.ReadWrite.All, Sites.FullControl.All, Directory.Read.All, Sites.ReadWrite.All, Files.ReadWrite.All, Group.ReadWrite.All | Acronis Inc. | 2024-10-10 | \n| ✅ | [Zoho Sign](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/e0bd303b-4530-4f33-9a4f-8e37a7bfbfdb/appId/a67ee0a9-b008-4e90-986d-1eb8d55a81d6) | High | Contacts.Read, Files.ReadWrite.All, offline_access, User.ReadBasic.All |  | Zoho Corporation Private Limited | 2025-04-08 | \n| ✅ | [Trend Micro Vision One](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/998076d2-5bd0-4d39-91b0-41e98b0e5365/appId/450abcc8-585c-4dbc-824a-e1b4af453d14) | High |  | Reports.Read.All, MailboxSettings.Read, Sites.Read.All, Group.Read.All, Organization.Read.All, People.Read.All, ThreatAssessment.Read.All, ActivityFeed.Read, Member.Read.Hidden, AuditLog.Read.All, UserAuthenticationMethod.Read.All, SecurityEvents.Read.All, User.Read.All, Directory.Read.All, IdentityRiskEvent.Read.All, Place.Read.All, Policy.Read.All | TMCAS | 2025-07-16 | \n| ✅ | [Trend Micro Vision One (US)](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/9efbcaa0-965c-4ac5-b3cc-972f3760cb33/appId/2b40c1f1-6456-47c7-9363-9e8ffb179e5f) | High | User.Read | Directory.ReadWrite.All | trendmicroincjprd | 2025-07-16 | \n| ✅ | [Trend Micro Vision One (US)](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/c374179b-cab1-4c7a-a780-64e0287f8357/appId/1e8e8130-8e25-48c9-bb32-9106a54526cd) | High | User.Read | Directory.Read.All | trendmicroincjprd | 2025-07-16 | \n| ✅ | [3CX Phone System](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/725b22c1-3198-49fa-b0a6-e928d57541b8/appId/84047e82-3acb-4aab-a81f-ad7b0c18500e) | High | User.Read | Mail.Send, User.Read.All | JCADVISOR CONSULTORIA | 2025-08-06 | \n| ✅ | [Lusha](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/983024ab-0f09-49a9-b22b-0b0a0a62d578/appId/c84e8334-222b-4dfb-9597-ecee04bc002f) | High | openid, profile, email, offline_access, User.Read, People.Read, Contacts.Read, Mail.Read, Calendars.ReadWrite, Mail.Send, Mail.ReadWrite |  | Lusha | 2025-08-24 | \n| ✅ | [Prowler](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/f2df545a-e19c-4af9-84a0-211ad81add28/appId/b1ac8e74-4764-4853-b2e2-108822a78f6f) | High | Directory.Read.All, Policy.Read.All, User.Read, UserAuthenticationMethod.Read.All |  | JCADVISOR CONSULTORIA | 2025-09-05 | \n| ✅ | [Atlassian Cloud](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/cd8213ca-7977-4274-b52c-9bcb946cbd97/appId/366ce19c-456c-40fa-a0dd-09e1043d5423) | High | email, openid, People.Read, User.Read, offline_access |  | Atlassian | 2026-01-06 | \n| ✅ | [MSFT Power Platform - Azure AD](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/880547df-d5c5-489d-94dd-534ace773d4b/appId/2bed6734-1911-40e6-ac44-00d79d70d2bc) | High | Directory.ReadWrite.All, Group.ReadWrite.All, User.ReadWrite.All, offline_access |  | Microsoft Accounts | 2026-01-14 | \n| ✅ | [Backup Service](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/e0149848-9f0d-4783-afed-68f44affc4fa/appId/15405a9d-0877-4397-9d7b-53ff6c718509) | High | User.Read | User.ReadWrite.All, Sites.Manage.All, TermStore.ReadWrite.All, full_access_as_app, ChannelMessage.Read.All, Sites.ReadWrite.All, Files.ReadWrite.All, Group.ReadWrite.All, Sites.FullControl.All, Directory.Read.All | Acronis Inc. | 2026-01-21 | \n| ✅ | [Cloudflare One Read-Only](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/d122ef6f-f0ea-438c-a111-b98cc89c566c/appId/a0c6b68f-ef48-42cc-b06c-7b8a89d79db3) | High | offline_access, profile | IdentityRiskyUser.Read.All, Application.Read.All, Group.Read.All, Organization.Read.All, RoleManagement.Read.All, CrossTenantInformation.ReadBasic.All, GroupMember.Read.All, Mail.ReadWrite, Calendars.Read, Files.Read.All, MailboxSettings.Read, AuditLog.Read.All, InformationProtectionPolicy.Read.All, UserAuthenticationMethod.Read.All, User.Read.All, Directory.Read.All, Domain.Read.All | CASB Production | 2026-01-21 | \n| ✅ | [GraphPowerBI](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/25ec645b-aa7c-4177-9aba-e782e87e844f/appId/81b12ea0-78bd-4de5-b406-15317e82c5ae) | High | AuditLogsQuery-Entra.Read.All, Directory.Read.All, User.Read, User.Read.All | AuditLogsQuery-Entra.Read.All, AuditLog.Read.All, User.Read.All, AuditLogsQuery.Read.All, Directory.Read.All, AuthenticationContext.Read.All | JC2Sec | 2026-03-03 | \n| ✅ | [Services Desk - Freshservice](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/0e4f0ba8-986a-47ef-a1e7-64a771c56c24/appId/371c5a86-51b1-4079-8b1b-558d2f199bab) | High |  | User.Read.All | JC2Sec | 2026-04-14 | \n| ✅ | [webviewer-powerbi](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/55d3edcd-5021-41a4-818c-8a2080384b43/appId/0f38d262-a372-4a0a-af1e-92b2b338fafb) | Unranked |  | Tenant.Read.All | JC2Sec | 2026-04-27 | \n| ✅ | [BloqueioCLT](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/56107465-251a-4d72-b19b-39b042749172/appId/b069cced-026b-4f5a-97c2-b67f8a6a3277) | High | Policy.Read.All, Policy.Read.ConditionalAccess, Policy.Read.DeviceConfiguration, Policy.Read.IdentityProtection, Policy.Read.PermissionGrant, Policy.ReadWrite.AccessReview, Policy.ReadWrite.ApplicationConfiguration, Policy.ReadWrite.AuthenticationFlows, Policy.ReadWrite.AuthenticationMethod, Policy.ReadWrite.Authorization, Policy.ReadWrite.ConditionalAccess, Policy.ReadWrite.ConsentRequest, Policy.ReadWrite.CrossTenantAccess, Policy.ReadWrite.CrossTenantCapability, Policy.ReadWrite.DeviceConfiguration, Policy.ReadWrite.ExternalIdentities, Policy.ReadWrite.FeatureRollout, Policy.ReadWrite.FedTokenValidation, Policy.ReadWrite.IdentityProtection, Policy.ReadWrite.MobilityManagement, Policy.ReadWrite.PermissionGrant, Policy.ReadWrite.SecurityDefaults, Policy.ReadWrite.TrustFramework, User.Read | Policy.Read.DeviceConfiguration, Policy.ReadWrite.Authorization, Policy.ReadWrite.DeviceConfiguration, Policy.ReadWrite.ExternalIdentities, Policy.Read.ConditionalAccess, Policy.ReadWrite.ApplicationConfiguration, Policy.ReadWrite.ConsentRequest, Policy.ReadWrite.CrossTenantAccess, Policy.ReadWrite.FedTokenValidation, Policy.ReadWrite.PermissionGrant, Policy.ReadWrite.SecurityDefaults, Policy.Read.PermissionGrant, Policy.ReadWrite.AuthenticationMethod, Policy.ReadWrite.IdentityProtection, Policy.Read.All, Policy.ReadWrite.CrossTenantCapability, Policy.Read.IdentityProtection, Policy.ReadWrite.ConditionalAccess, Policy.ReadWrite.FeatureRollout, Policy.ReadWrite.AuthenticationFlows | JCADVISOR CONSULTORIA | 2026-04-28 | \n| ✅ | [CSPM - JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/2c2c526c-91c2-4069-85a5-fb747d195109/appId/7d41d250-3a87-4381-86f0-cac11c4c054a) | High | Directory.Read.All, Policy.Read.All, User.Read, UserAuthenticationMethod.Read.All |  | JCADVISOR CONSULTORIA | 2026-05-04 | \n| ✅ | [ZeroTrustAssessment](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/2919ea4b-3b81-4ac6-a5e4-f6d65d21dd07/appId/1dfa9dbb-d208-48e9-96ad-64e8347af93f) | High |  | AuditLog.Read.All, AuditLogsQuery-Endpoint.Read.All, DeviceManagementConfiguration.Read.All, RoleManagement.Read.Directory, UserAuthenticationMethod.Read.All, AuditLogsQuery-OneDrive.Read.All, AuditLogsQuery-SharePoint.Read.All, AuditLogsQuery-Entra.Read.All, DeviceManagementServiceConfig.Read.All, Reports.Read.All, DeviceManagementManagedDevices.Read.All, RoleManagement.Read.All, DeviceManagementApps.Read.All, SecurityEvents.Read.All, AttackSimulation.Read.All, AuditLogsQuery-Exchange.Read.All, AuditLogsQuery.Read.All, Directory.Read.All, Policy.Read.All, Policy.Read.AuthenticationMethod | JC2Sec | 2026-05-04 | \n\n",
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "TestStatus": "Failed",
      "TestRisk": "Medium",
      "TestCategory": "Controle de acesso",
      "TestImpact": "High",
      "TestMinimumLicense": [
        "AAD_PREMIUM"
      ],
      "TestPillar": "Identity",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "21770",
      "TestTitle": "Aplicativos inativos não possuem permissões da API Microsoft Graph altamente privilegiadas",
      "TestDescription": "Atacantes podem explorar aplicativos válidos, mas inativos, que ainda possuem privilégios elevados. Esses aplicativos podem ser usados para obter acesso inicial sem levantar alarmes, pois são aplicativos legítimos. A partir daí, os invasores podem usar os privilégios do aplicativo para planejar ou executar outros ataques. Os atacantes também podem manter o acesso manipulando o aplicativo inativo, como por exemplo, adicionando credenciais. Essa persistência garante que, mesmo que seu método de acesso primário seja detectado, eles possam recuperar o acesso mais tarde.\n\n**Ação de remediação**\n\n- [Desativar entidades de serviço (service principals) privilegiadas](https://learn.microsoft.com/graph/api/serviceprincipal-update?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- Investigar se o aplicativo possui casos de uso legítimos\n- [Se a entidade de serviço não tiver casos de uso legítimos, exclua-a](https://learn.microsoft.com/graph/api/serviceprincipal-delete?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n\n",
      "SkippedReason": null
    },
    {
      "TestResult": "\n❌ Os logs do Global Secure Access não estão adequadamente integrados a um espaço de trabalho do Log Analytics para visibilidade das operações de segurança.\n\n\n## [Configurações de diagnóstico](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/DiagnosticSettings)\n\n| Categoria de log | AzureSentinel_trustway |\n| :--- | :---: |\n| NetworkAccessTrafficLogs | ❌ Desabilitado |\n| EnrichedOffice365AuditLogs | ❌ Desabilitado |\n| RemoteNetworkHealthLogs | ❌ Desabilitado |\n| NetworkAccessAlerts | ❌ Desabilitado |\n| NetworkAccessConnectionEvents | ❌ Desabilitado |\n| NetworkAccessGenerativeAIInsights | ❌ Desabilitado |\n| Workspace | ✅ [trustway](https://portal.azure.com/#resource/subscriptions/866c2573-b902-499d-a324-dc411b3ccd6d/resourceGroups/louvre/providers/Microsoft.OperationalInsights/workspaces/trustway/overview) |\n\n**Resumo:**\n\n- Total de configurações de diagnóstico: 1\n- Configurações de diagnóstico que atendem aos critérios (todas as seis categorias + workspace): 0\n\n",
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestStatus": "Failed",
      "TestRisk": "Medium",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access",
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "25419",
      "TestTitle": "A atividade de acesso à rede está visível para operações de segurança para detecção e resposta a ameaças",
      "TestDescription": "Sem logs do Global Secure Access integrados a um espaço de trabalho do Microsoft Sentinel, as equipes de operações de segurança carecem de visibilidade centralizada sobre padrões de tráfego de rede, tentativas de conexão e anomalias de acesso no Private Access, Internet Access e encaminhamento de tráfego do Microsoft 365. Atores de ameaça que comprometem credenciais de usuário ou dispositivos podem usar esses caminhos de acesso à rede para executar reconhecimento, se mover lateralmente ou exfiltrar dados sem detecção.\n\nSem essa integração:\n\n- As equipes de segurança não podem correlacionar atividades em nível de rede com sinais baseados em identidade no Microsoft Entra ID ou detecções de endpoint.\n- Os sistemas de gerenciamento de informações e eventos de segurança (SIEM) não podem aplicar análises comportamentais, correlação de inteligência de ameaças ou playbooks de resposta automatizados ao tráfego do Global Secure Access.\n- As equipes de segurança não podem investigar padrões históricos de acesso à rede ou caçar ameaças entre sinais de rede e identidade.\n\n**Ação de remediação**\n\n- [Configure as configurações de diagnóstico do Microsoft Entra](https://learn.microsoft.com/entra/global-secure-access/how-to-sentinel-integration?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para enviar logs do Global Secure Access a um espaço de trabalho do Log Analytics para integração com o Microsoft Sentinel.\n- [Ative todas as categorias de log de identidade do Global Secure Access necessárias](https://learn.microsoft.com/entra/identity/monitoring-health/concept-diagnostic-settings-logs-options?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci), incluindo `NetworkAccessTrafficLogs`, `EnrichedOffice365AuditLogs`, `RemoteNetworkHealthLogs`, `NetworkAccessAlerts`, `NetworkAccessConnectionEvents` e `NetworkAccessGenerativeAIInsights` nas configurações de diagnóstico.\n- [Integre os logs de atividade do Microsoft Entra com o Azure Monitor](https://learn.microsoft.com/entra/identity/monitoring-health/howto-integrate-activity-logs-with-azure-monitor-logs?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para coleta centralizada de logs.\n- [Configure um espaço de trabalho do Microsoft Sentinel](https://learn.microsoft.com/azure/sentinel/quickstart-onboard?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) e instale a solução Global Secure Access do content hub.\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Failed",
      "TestCategory": "Proteção de Informações",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma regra de fluxo de email com proteção de direitos está configurada; emails sensíveis não são automaticamente protegidos em trânsito.\n\n### Rules by action type\n\n| Action type | Count |\n| :--- | :--- |\n| OME encryption rules | 0 |\n| RMS template application | 0 |\n| Classification rules | 0 |\n\n### Summary\n\n| Metric | Count |\n| :--- | :--- |\n| Total protection rules | 0 |\n| Enabled rules | 0 |\n| Disabled rules | 0 |\n| External email protection | ❌ No |\n",
      "TestDescription": "Sem regras de fluxo de email, as organizações dependem dos usuários para aplicar manualmente rótulos de sensibilidade ou criptografar mensagens. Essa abordagem pode levar a inconsistências e erros, o que pode resultar em emails sensíveis sendo enviados sem proteção apropriada e aumentar o risco de acesso não autorizado e exfiltração de dados.\n\nAs regras de fluxo de email ajudam a adicionar automaticamente criptografia e definir permissões para emails que atendem a certas condições, tais como:\n- Email enviado para pessoas fora da empresa  \n- Email que contém informações sensíveis  \n- Email que deve seguir requisitos baseados em departamento  \nIsso garante que mensagens importantes sejam protegidas sem depender dos usuários para protegé-las manualmente.\n\n**Ação de remediação**\n\n- [Configurar Criptografia de Mensagem e regras de fluxo de email para usar o Criptografia de Mensagem do Microsoft Purview](https://learn.microsoft.com/purview/set-up-new-message-encryption-capabilities?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#next-steps-define-mail-flow-rules-to-use-microsoft-purview-message-encryption)\n",
      "TestImplementationCost": "Medium",
      "TestId": "35029",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E5",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Mail flow rules apply rights protection to sensitive messages"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\nNem todos os aplicativos empresariais possuem pelo menos dois proprietários.\n\n## Propriedade de Aplicativos Empresariais\n\n| App name | Multi-tenant | Permission  | Classification | Owner count |\n| :-------- | :------------ | :---------- | :------------- | :----------- |\n| [Domain Watchdog](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/af800961-bf36-4eb8-82f4-ca46220c73ab) | False | User.Read | Low | 0 |\n| [Pickit App](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/44a3cdb4-6407-41c6-91b8-b6ce99446d17) | False | User.Read | Low | 0 |\n| [ImmuniWeb](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/8cacdcd5-cab4-4750-99ba-d5472f83b746) | False | openid, User.Read | Low | 0 |\n| [Gmail](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/ff405636-b4d9-4918-8899-85569acf7a52) | False | EAS.AccessAsUser.All, offline_access | Low | 0 |\n| [Bizagi Accounts 2.0](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/6644b99a-59db-425c-852f-d64d29454914) | False | email, openid, profile | Low | 0 |\n| [Inovenow](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/3cb4d846-81f9-4e0f-833a-782ef9896f62) | False | email, openid, profile | Low | 0 |\n| [pam360](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/623159bd-a3c1-4f17-8371-d22b0bb385f8) | True | offline_access, SMTP.Send, User.Read | Low | 0 |\n| [Wazuh](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/b7ac79e7-37fb-4302-93c4-382ad0ecbb71) | False | ActivityFeed.Read, ActivityFeed.ReadDlp, ServiceHealth.Read, User.Read | Low | 0 |\n| [Clicksign](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/e6c435d8-19c9-45e7-bc0a-630b534c52b6) | False | email, openid, profile | Low | 0 |\n| [Elasticsearch (Elastic Cloud)](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/57b8b8b9-40ab-4b17-a53a-43d4f2ef2785) | False | email, openid, profile, User.Read | Low | 0 |\n| [TeamViewer](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/f39d4c6a-29a3-4c3e-83c8-06c0f7e7867d) | False | email, openid, profile | Low | 0 |\n| [Adobe Identity Management (OIDC)](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/6ce393be-4b69-4e1d-8868-dc45abc2793e) | False | email, offline_access, openid, profile | Low | 0 |\n| [Harvest](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/77222617-31ac-4b6e-95fb-7bd40f665e53) | False | Calendars.Read, offline_access, openid, profile, User.Read | Low | 0 |\n| [Supportbench](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/13b65912-679a-4fd9-9681-449ec994bdbb) | False | Calendars.ReadWrite, openid, profile, User.Read | Low | 0 |\n| [securiti](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/cc60521b-b916-437c-87b9-70bf61e02aec) | False | User.Read | Low | 0 |\n| [lusha-sso](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/c252f2c8-82ee-4c05-8851-723fd6d5260b) | False | offline_access, openid, profile | Low | 0 |\n| [Trello](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/a005abe2-621f-4d5c-8ed1-1e7803d069b7) | False | offline_access, openid, profile | Low | 0 |\n| [Mural](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/c9670585-97ef-4ef0-984d-19a30d781ee8) | False | email, offline_access, openid, profile | Low | 0 |\n| [Promptfoo Test Agent (Microsoft Copilot Studio)](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/5bb541e5-cff9-4929-a658-5f75154e1a1b) | False | offline_access, openid, profile, User.Read | Low | 0 |\n| [Relokia OAuth](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/d72396a5-b66c-43e1-abf6-0f9a3cd0c1c3) | False | email, openid, profile | Low | 0 |\n| [biquata](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/ddaca9bb-ee23-4d83-833c-603fe3847739) | False | offline_access, openid, profile | Low | 0 |\n| [Miro](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/c358565e-1d26-4677-8c5c-229e8258d7b5) | False | email, offline_access, openid, profile, User.Read | Low | 0 |\n| [Clara BR](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/2148de88-b2c4-455f-979a-a23e72109476) | False | email, openid, profile | Low | 0 |\n| [Aikido Security](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/897ae385-fe56-4a1a-a2e9-8287648ea4c2) | False | email, openid, profile | Low | 0 |\n| [BizagiLogin](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/0d70d232-c090-4bf2-b639-8cb831575403) | False | email, openid, profile | Low | 0 |\n| [Snyk Azure Marketplace Listing](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/b80127ac-ef1d-4478-b7bf-841900254e02) | False | User.Read | Low | 0 |\n| [Wazuh](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/efbafba2-d347-4a1e-9b07-cc81249783f3) | False | ActivityFeed.Read, ActivityFeed.ReadDlp, User.Read | Low | 0 |\n| [webviewer-powerbi](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/55d3edcd-5021-41a4-818c-8a2080384b43) | False | Tenant.Read.All | Unranked | 0 |\n| [ZapSign](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/0549f9bb-ed6e-4d02-b02f-ff90a6349112) | False | email, offline_access, openid, profile, User.Read | Low | 0 |\n| [Tempo Timesheets](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/4627bf39-5e1a-4f68-86ec-19744dc6ae1c) | False | Calendars.Read, email, offline_access, openid, profile, User.Read | Low | 0 |\n| [Microsoft Tech Community](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/8a65d5c8-1e37-43be-9ffe-d40e2dd19cf6) | False | email, offline_access, openid, profile, User.Read | Low | 0 |\n| [Tempo](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/objectId/f751e945-613c-42b8-8385-1529b5b0d6ba) | False | Calendars.Read, email, offline_access, openid, profile, User.Read | Low | 0 |\n\n",
      "TestDescription": "Aplicativos empresariais sem proprietários tornam-se ativos órfãos que os agentes de ameaças podem explorar. Esses aplicativos geralmente mantêm permissões elevadas e acesso a recursos sensíveis, ao mesmo tempo em que carecem de supervisão adequada e governança de segurança.\n\nAplicativos sem proprietários criam pontos cegos no monitoramento de segurança, onde invasores podem estabelecer persistência aproveitando as permissões de aplicativos existentes para acessar dados ou criar contas de backdoor. A ausência de propriedade também impede revisões de acesso e auditorias de permissão adequadas, permitindo que aplicativos com permissões excessivas ou configurações desatualizadas permaneçam não gerenciados.\n\nAtribuir proprietários permite o gerenciamento eficaz do ciclo de vida do aplicativo e garante a supervisão de segurança adequada.\n\n**Ação de correção**\n\n- [Atribuir proprietários de aplicativos empresariais](https://learn.microsoft.com/entra/identity/enterprise-apps/assign-app-owners?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "24518",
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Aplicativos empresariais possuem proprietários"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Failed",
      "TestCategory": "Global Secure Access",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma rede privada está configurada em seu locatário.\n\n\n## Redes privadas\n\nNenhuma rede privada está configurada no momento. Para habilitar o Intelligent Local Access, você precisa configurar pelo menos uma rede privada no Global Secure Access.\n\n",
      "TestDescription": "O Intelligent Local Access (ILA) direciona o tráfego do Microsoft Entra Private Access localmente em vez de passar pela nuvem, melhorando o desempenho enquanto mantém a aplicação de políticas. Sem ILA, os usuários podem desabilitar o cliente Global Secure Access para melhorar o desempenho e contornar as políticas de Conditional Access. Configure redes privadas para seus sites de usuários para garantir roteamento local mantendo os controles de segurança.\n\n**Ação de remediação**\n\n- [Habilite a Rede Local Inteligente](https://learn.microsoft.com/entra/global-secure-access/enable-intelligent-local-access?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "25405",
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "O Intelligent Local Access está habilitado e configurado"
    },
    {
      "TestResult": "\n❌ **Falha**: O local nomeado de rede compatível não existe ou não está configurado corretamente.\n\n\n### [Global Secure Access Signaling Status](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/Security.ReactView)\n\n| Setting | Value |\n| :------ | :---- |\n| Signaling status | ✅ Enabled |\n### [Local nomeado de rede compatível](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/NamedLocations)\n\n❌ O local nomeado de rede compatível não foi encontrado. Habilite a sinalização do Global Secure Access para criar automaticamente esse local.\n### [Políticas de Conditional Access](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/Policies)\n\nForam encontradas 4 políticas habilitadas de Conditional Access, mas não é possível avaliar o uso da rede compatível sem um local de rede compatível válido.\n\n**Summary:**\n\n- Global Secure Access signaling enabled: True\n- Compliant network location exists: False\n- Policies using standard pattern (block all except compliant): 0\n- Policies using alternative patterns: 0\r\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Failed",
      "TestRisk": "Medium",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "AAD_PREMIUM",
        "AAD_PREMIUM_P2"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "",
      "TestId": "25379",
      "TestTitle": "As políticas de Conditional Access usam controles de rede compatível",
      "TestDescription": "Sem controles de rede compatível nas políticas de Conditional Access, as organizações não conseguem impor que os usuários se conectem a recursos corporativos através do serviço Global Secure Access. Essa limitação deixa o tráfego de autenticação vulnerável a interceptação e ataques de repetição de qualquer localização de rede.\n\nUm agente de ameaça que obtém credenciais válidas de usuário por phishing ou roubo de credenciais pode autenticar de qualquer localização na internet, contornando os controles de rede do Global Secure Access. Uma vez autenticado, o agente de ameaça pode acessar aplicações e serviços integrados ao Microsoft Entra ID, exfiltrar dados ou estabelecer persistência criando credenciais adicionais ou modificando permissões de usuário.\n\nA verificação de rede compatível reduz esse risco exigindo que o tráfego de autenticação se origine no serviço Global Secure Access, que marca solicitações de autenticação com sinais de identidade de rede específicos do locatário. Esse requisito permite que o Microsoft Entra ID Conditional Access verifique se os usuários se conectam pelo caminho de rede protegido da organização antes de conceder acesso.\n\n**Ação de remediação**\n- Habilite a sinalização do Global Secure Access para Conditional Access. Para mais informações, veja [Habilitar verificação de rede compatível com Conditional Access](https://learn.microsoft.com/entra/global-secure-access/how-to-compliant-network?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enable-global-secure-access-signaling-for-conditional-access).\n- Crie uma política de Conditional Access que exija rede compatível para acesso. Para mais informações, veja [Proteja seus recursos por trás da rede compatível](https://learn.microsoft.com/entra/global-secure-access/how-to-compliant-network?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#protect-your-resources-behind-the-compliant-network).\n- Implemente clientes Global Secure Access nos dispositivos. Para mais informações, veja [Visão geral de clientes do Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/concept-clients?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Entenda a aplicação da verificação de rede compatível. Para mais informações, veja [Aplicação da verificação de rede compatível](https://learn.microsoft.com/entra/global-secure-access/how-to-compliant-network?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci#compliant-network-check-enforcement).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\nO Consentimento Específico do Recurso não está restrito.\n\nO estado atual é ManagedByMicrosoft.\n\n",
      "TestDescription": "Permitir que proprietários de grupos consintam com aplicativos no Microsoft Entra ID cria um caminho de escalonamento lateral que permite que atores de ameaça persistam e roubem dados sem credenciais de administrador. Se um invasor comprometer uma conta de proprietário de grupo, ele poderá registrar ou usar um aplicativo malicioso e consentir com permissões de alta prioridade da Graph API com escopo para o grupo. Invasores podem potencialmente ler todas as mensagens do Teams, acessar arquivos do SharePoint ou gerenciar a participação no grupo. Esta ação de consentimento cria uma identidade de aplicativo de longa duração com permissões delegadas ou de aplicativo. O invasor mantém a persistência com tokens OAuth, rouba dados confidenciais de canais e arquivos de equipe e personifica usuários por meio de mensagens ou permissões de e-mail. Sem a aplicação centralizada de políticas de consentimento de aplicativos, as equipes de segurança perdem visibilidade e os aplicativos maliciosos se espalham sem serem detectados, permitindo ataques de vários estágios em plataformas de colaboração.\n\n**Ação de correção**\nConfigure a pré-aprovação de permissões de Consentimento Específico de Recurso (RSC).\n- [Pré-aprovação de permissões RSC](https://learn.microsoft.com/microsoftteams/platform/graph-api/rsc/preapproval-instruction-docs?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21810",
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "O consentimento específico do recurso está restrito"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\n❌ **Falha**: Nenhum local nomeado confiável foi encontrado no Microsoft Entra ID.\n\n## Locais Nomeados Configurados\n\nTotal de locais nomeados: [0](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ConditionalAccessMenuBlade/~/NamedLocations)\n\n| Nome | Tipo | Confiável | Criado em | Modificado em |\n| :--- | :--- | :--- | :--- | :--- |\n\n",
      "TestDescription": "Sem locais nomeados configurados no Microsoft Entra ID, atores de ameaça podem explorar a ausência de inteligência de localização para realizar ataques sem acionar detecções de risco baseadas em localização ou controles de segurança. Quando as organizações não definem locais nomeados para redes confiáveis, escritórios regionais e regiões geográficas conhecidas, o Microsoft Entra ID Protection não consegue avaliar sinais de risco baseados em localização. A ausência dessas políticas pode levar a um aumento de falsos positivos que criam fadiga de alertas e potencialmente mascaram ameaças genuínas. Essa lacuna de configuração impede que o sistema distinga entre locais legítimos e ilegítimos. Por exemplo, logins legítimos de redes corporativas e tentativas de autenticação suspeitas de locais de alto risco (redes de proxy anônimas, nós de saída Tor ou regiões onde a organização não possui presença comercial). Atores de ameaça podem usar essa incerteza para realizar ataques de credential stuffing, campanhas de password spray e tentativas de acesso inicial a partir de infraestruturas maliciosas sem acionar detecções baseadas em localização que normalmente sinalizariam tal atividade como suspeita. As organizações também podem perder a capacidade de implementar políticas de segurança adaptativas que poderiam aplicar automaticamente requisitos de autenticação mais rígidos ou bloquear o acesso inteiramente de regiões geográficas não confiáveis. Atores de ameaça podem manter persistência e realizar movimentação lateral a partir de qualquer local global sem encontrar barreiras de segurança baseadas em localização, as quais deveriam servir como uma camada extra de defesa contra tentativas de acesso não autorizado.\n\n**Ação de correção**\n\n- [Configurar locais nomeados para definir intervalos de IP confiáveis e regiões geográficas para detecção aprimorada de riscos baseada em localização e imposição de políticas de Acesso Condicional](https://learn.microsoft.com/entra/identity/conditional-access/concept-assignment-network?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21865",
      "TestSfiPillar": "Proteger redes",
      "TestTags": [
        "Identidade"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identidade"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Locais nomeados estão configurados"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\nNenhuma política de Termos e Condições existe ou nenhuma está atribuída.\n\n\n",
      "TestDescription": "Se as políticas de Termos e Condições não estiverem configuradas e atribuídas no Intune, usuários podem acessar recursos corporativos sem concordar com os termos legais, de segurança ou de uso exigidos. Essa omissão expõe a organização a riscos de conformidade, responsabilidades legais e possível uso indevido de recursos.\n\nA aplicação de Termos e Condições garante que os usuários reconheçam e aceitem as políticas da empresa antes de acessar dados sensíveis ou sistemas, apoiando a conformidade regulatória e o uso responsável dos recursos.\n\n**Ação de remediação**\n\nCrie e atribua políticas de Termos e Condições no Intune para exigir a aceitação do usuário antes de conceder acesso a recursos corporativos:  \n- [Criar política de termos e condições](https://learn.microsoft.com/intune/intune-service/enrollment/terms-and-conditions-create?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24794",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Políticas de Termos e Condições protegem o acesso a dados sensíveis"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Colaboração externa",
      "SkippedReason": null,
      "TestResult": "\nO tenant permite que qualquer usuário (incluindo outros convidados) convide novos convidados.\n",
      "TestDescription": "Contas de usuários externos são frequentemente usadas para fornecer acesso a parceiros de negócios. Se essas contas forem comprometidas em sua organização de origem, os atacantes podem usar as credenciais válidas para obter acesso inicial ao seu ambiente.\n\nPermitir que usuários externos convidem outros usuários externos aumenta o risco de acesso não autorizado. Se um invasor comprometer a conta de um usuário externo, ele poderá usá-la para criar mais contas externas, multiplicando seus pontos de acesso e tornando mais difícil detectar a intrusão.\n\n**Ação de remediação**\n\n- [Restringir quem pode convidar convidados apenas a usuários atribuídos a funções de administrador específicas](https://learn.microsoft.com/entra/external-id/external-collaboration-settings-configure?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#to-configure-guest-invite-settings)\n",
      "TestImplementationCost": "Low",
      "TestId": "21791",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Convidados não podem convidar outros convidados"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Monitoramento",
      "SkippedReason": null,
      "TestResult": "\nEncontradas 11 recomendações do Entra não atendidas.\n\n\n## Recomendações do Entra não atendidas\n\n| Nome de exibição | Status | Insights | Prioridade |\n| :--- | :--- | :--- | :--- |\n| Protect your tenant with Insider Risk condition in Conditional Access policy | active | You have 73 of 73 users that aren’t covered by the Insider Risk condition in a Conditional Access policy. | medium |\n| Protect all users with a user risk policy  | active | You have 73 of 73 users that don’t have a user risk policy enabled.  | high |\n| Protect all users with a sign-in risk policy | active | You have 73 of 73 users that don't have a sign-in risk policy turned on. | high |\n| Do not expire passwords | active | Your current policy is set to let passwords expire. | high |\n| Ensure all users can complete multifactor authentication | active | You have 19 of 73 users that aren’t registered with MFA.  | high |\n| Enable policy to block legacy authentication | active | You have 1 of 73 users that don’t have legacy authentication blocked.  | high |\n| Renew expiring application credentials | active | Your tenant has applications with credentials that will expire soon. | high |\n| Remove unused applications | active | This recommendation will surface if your tenant has applications that have not been used for over 90 days. Applications that were created but never used, client applications which have not been issued a token or resource apps that have not been a target of a token request, will show under this recommendation. | medium |\n| Convert from per-user MFA to Conditional Access MFA | active | 4 users are currently configured for per-user Multi-Factor Authentication (MFA). However, there are 45 users configured for Conditional Access (CA) MFA. The per-user MFA configuration supersedes the MFA settings applied via CA policies, potentially creating unnecessary MFA prompts. | medium |\n| Minimize MFA prompts for your users signing in from known devices | active | Your current Remember MFA setting is configured to 7 days. Change the configuration setting to 90 days (the maximum value) to reduce recurring MFA requests on known devices. | low |\n| Start your Defender for Identity deployment, installing Sensors on Domain Controllers and other eligible servers. | active | Installing Microsoft Defender for Identity sensors provides you with the ability to detect advanced threats in your entire identity infrastructure. Actionable security alerts are generated through the analysis of network traffic and security events. | low |\n\n",
      "TestDescription": "As recomendações do Microsoft Entra oferecem às organizações oportunidades para implementar as melhores práticas e otimizar sua postura de segurança. Não agir sobre esses itens pode resultar em um aumento da superfície de ataque, operações subotimizadas ou uma experiência de usuário insatisfatória.\n\n**Ação de correção**\n\n- [Abordar todas as recomendações ativas ou adiadas no centro de administração do Microsoft Entra](https://learn.microsoft.com/entra/identity/monitoring-health/overview-recommendations?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#how-does-it-work)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21866",
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": [
        "Identidade"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identidade"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Todas as recomendações do Microsoft Entra foram atendidas"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Dispositivos",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma política de Firewall do macOS foi encontrada ou nenhuma está atribuída.\n\n",
      "TestDescription": "Sem uma política de firewall gerida de forma centralizada, os dispositivos macOS podem depender de definições predefinidas ou modificadas pelo utilizador, que muitas vezes não cumprem os padrões de segurança corporativos. Isto expõe os dispositivos a ligações de entrada não solicitadas, permitindo que agentes de ameaças explorem vulnerabilidades, estabeleçam tráfego de comando e controlo (C2) de saída para exfiltração de dados e se movam lateralmente dentro da rede — aumentando significativamente o alcance e o impacto de uma violação.\n\nA aplicação de políticas de Firewall no macOS garante um controlo consistente sobre o tráfego de entrada e saída, reduzindo a exposição a acessos não autorizados e apoiando o Zero Trust através de proteção ao nível do dispositivo e segmentação de rede.\n\n**Ação de correção**\n\nConfigure e atribua perfis de **Firewall do macOS** no Intune para bloquear tráfego não autorizado e aplicar proteções de rede consistentes em todos os dispositivos macOS geridos:\n\n- [Configurar o firewall integrado em dispositivos macOS](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-firewall-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Atribuir políticas no Intune](https://learn.microsoft.com/intune/intune-service/configuration/device-profile-assign?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assign-a-policy-to-users-or-groups)\n\nPara mais informações, consulte:\n- [Definições de firewall do macOS disponíveis](https://learn.microsoft.com/intune/intune-service/protect/endpoint-security-firewall-profile-settings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#macos-firewall-profile)\n",
      "TestImplementationCost": "Low",
      "TestId": "24552",
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "High",
      "TestRisk": "Medium",
      "TestTitle": "Políticas de Firewall do macOS protegem contra acesso não autorizado à rede"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\n❌ **Falha**: Foram encontrados aplicativos ou entidades de serviço com certificados que expiram em mais de 180 dias.\n\n\n",
      "TestDescription": "Certificados, se não forem armazenados com segurança, podem ser extraídos e explorados por atacantes, levando ao acesso não autorizado. Certificados de longa duração têm maior probabilidade de serem expostos ao longo do tempo. Quando as credenciais são expostas, os atacantes ganham a capacidade de misturar suas atividades com operações legítimas, facilitando a evasão dos controles de segurança. Se um invasor comprometer o certificado de um aplicativo, ele poderá escalar seus privilégios no sistema, levando a um acesso e controle mais amplos.\n\n**Ação de remediação**\n\n- [Definir configuração de aplicativo baseada em certificado](https://devblogs.microsoft.com/identity/app-management-policy/)\n- [Definir autoridades de certificação confiáveis para aplicativos e entidades de serviço no tenant](https://learn.microsoft.com/graph/api/resources/certificatebasedapplicationconfiguration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Definir políticas de gerenciamento de aplicativos](https://learn.microsoft.com/graph/api/resources/applicationauthenticationmethodpolicy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Impor padrões de segredos e certificados](https://learn.microsoft.com/entra/identity/enterprise-apps/tutorial-enforce-secret-standards?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Crie uma função personalizada de privilégio mínimo para rotacionar credenciais de aplicativos](https://learn.microsoft.com/entra/identity/role-based-access-control/custom-create?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21773",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identidade"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identidade"
      ],
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Aplicativos não possuem certificados com expiração superior a 180 dias"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": null,
      "TestResult": "\nEncontrados usuários que não registraram métodos de autenticação resistente a phishing.\n\n## Métodos de autenticação resistente a phishing\n\nEncontrados usuários que não registraram métodos de autenticação resistente a phishing.\n\nUsuário | Último acesso | Método resistente a phishing registrado |\n| :--- | :--- | :---: |\n|[Alessandra Tamborelli Bianchi](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/ecea0e4c-9cac-4409-8cec-358894ffbc1c/hidePreviewBanner~/true)| 04/14/2025 21:06:36 | ❌ |\n|[Assessement MS365](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/bf184034-2139-4b39-9c5d-45025d4f1d8d/hidePreviewBanner~/true)| 2026-04-05 | ❌ |\n|[Auto Pilot](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/3e8190bb-b1c0-459c-8660-b9c9e4c27562/hidePreviewBanner~/true)| 2024-05-08 | ❌ |\n|[Canal de Denúncia](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/e068a492-e0bc-4dc3-9a76-8193798d5713/hidePreviewBanner~/true)| 01/15/2026 13:48:24 | ❌ |\n|[Carol Herling | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/4398d011-0839-444b-8daa-a511f497c721/hidePreviewBanner~/true)| Unknown | ❌ |\n|[Comunicação | JCAdvisor](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/fcb0306f-e8c1-47ed-9d88-03277278f0f0/hidePreviewBanner~/true)| 2025-11-06 | ❌ |\n|[CONTAS | JCA](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/3f2b1124-31f5-4e59-83ee-2b977df56008/hidePreviewBanner~/true)| Unknown | ❌ |\n|[Contato | JCAdvisor](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/1bbfd124-0d40-421b-8ac2-1796d5cc5283/hidePreviewBanner~/true)| 2024-12-04 | ❌ |\n|[CSPM](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/503c4675-69d9-44fa-930e-a0998c32b1ae/hidePreviewBanner~/true)| 2024-08-02 | ❌ |\n|[Customer Success | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/c40ab0da-dc45-49b4-a843-02b90f402904/hidePreviewBanner~/true)| 2026-06-05 | ❌ |\n|[DMARC](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/0e6e54a7-a70a-4980-8dd5-787df4bbbafe/hidePreviewBanner~/true)| Unknown | ❌ |\n|[DPO](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/9be368b1-5e24-48b4-86e6-b82e078a6bb2/hidePreviewBanner~/true)| Unknown | ❌ |\n|[Exemplo de booking](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/c8ff45a5-0fb9-454e-95aa-e686d6f392be/hidePreviewBanner~/true)| Unknown | ❌ |\n|[Infraestrutura | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/71cf95ea-82b6-4c80-9282-8b383aba51df/hidePreviewBanner~/true)| 2025-01-08 | ❌ |\n|[JC2SEC | 365Lens](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/3fef541b-a481-4ce1-b21e-4c122cba7fda/hidePreviewBanner~/true)| Unknown | ❌ |\n|[Lucimara Chiavaloni Ferreira - AeC](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/9fc840f0-f304-459d-9ea8-d4ac7be1a3a4/hidePreviewBanner~/true)| 04/15/2026 17:10:28 | ❌ |\n|[luisvega](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/f60e92cf-edec-44f2-9ae0-fea58858f9c8/hidePreviewBanner~/true)| Unknown | ❌ |\n|[Margarete Lumika Shiguenaga - AeC](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/95770780-583f-4510-8aae-01964f858046/hidePreviewBanner~/true)| 2026-03-04 | ❌ |\n|[margarete.shiguenaga](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/660d1609-9057-4372-933e-ce785ec48124/hidePreviewBanner~/true)| Unknown | ❌ |\n|[NEWE SOC](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/4b7da1cd-af93-4977-aeab-60d3c8a7a08a/hidePreviewBanner~/true)| Unknown | ❌ |\n|[Power BI | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/fc0fcf0f-455a-4051-a750-50d7c88f5fca/hidePreviewBanner~/true)| 2026-04-05 | ❌ |\n|[Promtpfoo Teste](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/b9e9e109-f61d-4c10-8d15-d8613d20d232/hidePreviewBanner~/true)| 2025-03-09 | ❌ |\n|[Risk Argus](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/31956732-be45-42b0-83b5-e9d83b9103b0/hidePreviewBanner~/true)| 05/23/2024 11:56:55 | ❌ |\n|[Rodrigo Fernandes Marangoni - AeC](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/e2356631-f8e9-4834-a580-2852a5e40e16/hidePreviewBanner~/true)| 02/27/2026 13:50:33 | ❌ |\n|[Site JCAdvisor](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/8ccc8dca-41fa-447d-a0e1-d7edd0f29aae/hidePreviewBanner~/true)| 04/28/2026 18:29:12 | ❌ |\n|[SOC | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/cf142c03-c4b7-4e9e-9e1f-a6ebb53485b1/hidePreviewBanner~/true)| 08/29/2025 13:50:45 | ❌ |\n|[SOC Manager](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/b463a051-3785-482e-95f4-825e7bca5708/hidePreviewBanner~/true)| Unknown | ❌ |\n|[Suporte Administrador | JCAdvisor](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/6d35d1c1-e2c7-42b8-9e57-995e1d52bbff/hidePreviewBanner~/true)| 2026-07-05 | ❌ |\n|[Suporte N1 | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/e22d0df1-4c61-4979-b5e1-853faf98f1d8/hidePreviewBanner~/true)| 2026-06-05 | ❌ |\n|[Suporte Newe | JCAdvisor](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/dfca4486-950c-4051-bc8f-7f076c91963b/hidePreviewBanner~/true)| 2026-04-05 | ❌ |\n|[Suporte Técnico | JCAdvisor](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/759eb8a4-d759-443b-9d82-d5baf826f18a/hidePreviewBanner~/true)| 2025-12-09 | ❌ |\n|[Suporte Tecnico N1](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/b5b3352e-d67d-4bcb-bf3b-112d88ea2256/hidePreviewBanner~/true)| 07/26/2024 14:39:42 | ❌ |\n|[temporario jc2sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/a8a7ac9c-41ee-4021-99c4-ba07c25cc850/hidePreviewBanner~/true)| 2026-04-05 | ❌ |\n|[TI Corporativa | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/595d6937-e199-4072-ac96-37f1a64c4ba8/hidePreviewBanner~/true)| Unknown | ❌ |\n|[TPRM | Orientações Gerais | Crefisa](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/f1850bbb-6947-47b1-b997-17f2324138b9/hidePreviewBanner~/true)| Unknown | ❌ |\n|[Alice Coelho | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/c5448a3f-8241-4054-a914-7dd3f1ce8121/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[André Corradini | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/d7fca4d9-0785-4847-98aa-47e0bb053495/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Anielle Trizzi | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/6fb62761-befb-4081-9373-0df8c2043f8a/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Arthur Silva | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/2b531e92-d651-4af1-9fe5-040bfde2151f/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Beatriz Godoy | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/a205f935-877d-4411-bf85-90cc8acca072/hidePreviewBanner~/true)| 2026-01-05 | ✅ |\n|[Bruno Corrêa | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/995eab40-5783-4e0b-a6c6-b0f9f8582aab/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Carlos Alberto | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/eaa93fe2-7162-4581-bac3-2a42030cda9b/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Carolina de Moraes | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/638fceb5-4d71-4045-ae6c-2d7b047e2a95/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Cauê Moraes | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/3eba751c-a4a2-48af-a9aa-91564125a18e/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Ederson Martins | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/07d06319-671d-4ebb-bc38-899acf9701ae/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Eduardo Cintra | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/e33826c7-c2a4-47fb-9424-b13945279163/hidePreviewBanner~/true)| 2026-06-05 | ✅ |\n|[Erika Maia | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/25f7d4e2-f128-4f38-82b4-e3db4d4ea9e8/hidePreviewBanner~/true)| 2026-04-05 | ✅ |\n|[Fernanda Almeida | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/a8a7a102-880e-4994-a265-cb90704ae28b/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Fernanda Matsunaga | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/b6ed9836-7dc8-4c03-9247-36b9c7c4bb3e/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Gabriel Lorenzi | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/5109b9a1-c835-4bce-9dc1-343312d476fa/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Gabriel Romano | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/b06541bf-8c9a-4926-b42a-4167b932a8b8/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Gestão de Pessoas | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/14e02617-9305-4dde-a4f2-70691d6fbac4/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Gustavo Fenner | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/49ae424a-8b19-4eed-bb18-7371cdcefc49/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Gustavo Oliveira | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/3daea060-acce-4702-8c5a-f047cff8fd29/hidePreviewBanner~/true)| 2026-06-05 | ✅ |\n|[Gustavo Ribeiro | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/76d2e7cd-1bdd-4704-b324-3bc50de97f77/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Henry Paulo | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/01ac3636-77a3-4408-b8ce-5c7d7e507781/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Ingresso Dominio | JCAdvisor](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/7d287d43-b736-4b5d-87bd-53d77999f5d1/hidePreviewBanner~/true)| 03/24/2026 18:20:07 | ✅ |\n|[Jessica Ferro | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/60894d8c-f826-4fc2-9f79-a8bef46f1bd1/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[João Noberto | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/3ba8d82c-d4a7-4d0a-b443-07fd038b5f1c/hidePreviewBanner~/true)| 2026-06-05 | ✅ |\n|[João Silveira | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/b6bddb1f-0b9c-4ab4-971c-78de83c6fa5a/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Kaio França | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/bb2b3447-d215-4395-ac91-2720e397d61d/hidePreviewBanner~/true)| 2026-06-05 | ✅ |\n|[Kevin Pazello | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/7a41ed21-88da-4043-be83-7c7aaeec32e9/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Laís Ferreira | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/aa108741-6b80-4011-8445-df8a4adc96b5/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Letícia Godoy | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/4dac8c45-f657-4405-9543-91a1fa84ef3d/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Letícia Martins | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/51ecbf15-f5d1-4bbe-8205-ffcbb75fc20d/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Luana Duarte | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/38dfb106-50c6-4fff-b4f9-aa2250c76813/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Marcos Julião | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/fcc90617-74b9-4e8c-a6bb-d21370d05f55/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Matheus Xavier | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/4c00a7ad-000f-45fb-a1cf-294cf186993e/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Maxwell Batistoni | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/344a50a3-7afc-492a-a42a-6e5480a87116/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Mayara Rangel | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/72f1bb00-a1f1-440c-b4c6-bb2ee9b12d55/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Monique Ruivo | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/51328e86-c3c1-4a9d-9865-1e59598f4c1f/hidePreviewBanner~/true)| 2026-06-05 | ✅ |\n|[Pedro Lopes | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/80652076-4e5d-4670-844f-9c139ac344b3/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Robson Franco | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/fd5ea3f3-1741-4c8e-9b0b-bbaa1244b751/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Sabrili Scatambulo | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/daaff34d-86e4-4649-8aed-58c358a66c9f/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Vinicius  Fiacadori | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/482f6d4d-3432-4bdb-8715-108cd1cb75d3/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n|[Wilian Jesus | JC2Sec](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/UserAuthMethods/userId/bfc89f19-af27-4289-9b0e-b07b8ff5ba49/hidePreviewBanner~/true)| 2026-07-05 | ✅ |\n\n",
      "TestDescription": "Atacantes podem ganhar acesso se a MFA não for aplicada ou se métodos fracos forem permitidos. Técnicas de phishing sofisticadas e SIM swapping podem comprometer métodos baseados em SMS ou voz. Ao utilizar sessões de usuários interceptadas, criminosos evadem a detecção e mantêm acesso contínuo.\n\n**Ação de remediação**\n\n- [Implantar autenticação multifator](https://learn.microsoft.com/entra/identity/authentication/howto-mfa-getstarted?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Exigir MFA resistente a phishing para todos os usuários](https://learn.microsoft.com/entra/identity/conditional-access/policy-all-users-mfa-strength?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21801",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Credential"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Usuários possuem métodos de autenticação fortes configurados"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Failed",
      "TestCategory": "Recursos avançados de rótulos",
      "SkippedReason": null,
      "TestResult": "\n❌ O recurso de superusuário está desabilitado sem membros configurados, OU o recurso está ativado sem membros.\n\n## Configuração de Superusuário do Azure Information Protection\n\n**Recurso de Superusuário:** Disabled\n\n**Superusuários Configurados:** 0\n\n**Nota:** A configuração de superusuário não está disponível por meio do portal do Azure e deve ser gerenciada via PowerShell usando o módulo AipService.\n\n",
      "TestDescription": "O recurso de superusuario do servico de Gerenciamento de Direitos do Azure concede a contas designadas a capacidade de descriptografar conteudo que sua organizacao criptografou usando esse servico, independentemente das permissoes originais atribuidas. Superusuarios podem ser necessarios para descoberta eletronica, recuperacao de dados, investigacoes de conformidade e migracao de conteudo. O recurso de superusuario garante que pessoas e servicos autorizados sempre possam ler e inspecionar os dados que o servico de Gerenciamento de Direitos do Azure criptografa para sua organizacao.\n\nQuando voce usa um grupo para designar contas de superusuario, a associacao desse grupo deve ser cuidadosamente controlada e limitada, por exemplo, a contas de servico usadas por ferramentas de conformidade ou plataformas de descoberta eletronica. A menos que voce tenha um requisito tecnico ou necessidade de negocio que exija esse recurso habilitado o tempo todo, a Microsoft recomenda mante-lo desabilitado por padrao e habilita-lo apenas quando necessario. Quando voce usa um grupo para designar contas de superusuario, use o Microsoft Entra Privileged Identity Management (PIM) para reduzir riscos com acesso just-in-time quando necessario e minimizacao de privilegio permanente.\n\n**Ação de remediação**\n\n- [Configurar superusuarios do Gerenciamento de Direitos do Azure para servicos de descoberta ou recuperacao de dados](https://learn.microsoft.com/purview/encryption-super-users?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#security-best-practices-for-the-super-user-feature)\n",
      "TestImplementationCost": "Medium",
      "TestId": "35011",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E5",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "A associação de superusuário está configurada para o Microsoft Purview Information Protection"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\nO Azure AD PowerShell não foi bloqueado pela organização.\n",
      "TestDescription": "Atores de ameaça frequentemente visam interfaces de gerenciamento legadas, como o módulo Azure AD PowerShell (AzureAD e AzureADPreview), que não suportam autenticação moderna, imposição de Acesso Condicional ou log de auditoria avançado. O uso contínuo desses módulos expõe o ambiente a riscos, incluindo autenticação fraca, bypass de controles de segurança e visibilidade incompleta das ações administrativas. Atacantes podem explorar essas fraquezas para obter acesso não autorizado, escalar privilégios e realizar alterações maliciosas.\n\nBloqueie o módulo Azure AD PowerShell e imponha o uso do Microsoft Graph PowerShell ou Microsoft Entra PowerShell para garantir que apenas canais de gerenciamento seguros, suportados e auditáveis estejam disponíveis, fechando lacunas críticas na cadeia de ataque.\n\n**Ação de correção**\n\n- [Desativar o logon de usuário para o aplicativo](https://learn.microsoft.com/entra/identity/enterprise-apps/disable-user-sign-in-portal?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21844",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Bloquear o módulo legado Azure AD PowerShell"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\n❌ **Falha**: Nenhuma política de Acesso Condicional para bloquear autenticação legada foi encontrada.\n",
      "TestDescription": "Protocolos de autenticação legada, como autenticação básica para SMTP e IMAP, não suportam recursos modernos de segurança como a autenticação multifator (MFA). Isso torna as contas vulneráveis a ataques de força bruta e pulverização de senhas (password spray).\n\nAtacantes que ganham acesso através de autenticação legada podem se mover lateralmente e manter persistência sem disparar alertas de segurança modernos que exigem MFA ou conformidade do dispositivo.\n\n**Ação de remediação**\n- [Implantar uma política de Acesso Condicional para Bloquear autenticação legada](https://learn.microsoft.com/entra/identity/conditional-access/policy-block-legacy-authentication?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21796",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "High",
      "TestRisk": "Medium",
      "TestTitle": "A política de bloqueio de autenticação legada está configurada"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\nNenhum perfil de marca do Company Portal com configurações de suporte existe ou nenhum está atribuído.\n\n\n## Perfis de Marca do Company Portal\n\n| Nome do Perfil | Propriedades de Marca | Status | Alvo de Atribuição |\n| :----------- | :------------------ | :----- | :---------------- |\n| [Default Branding profile.](https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/TenantAdminMenu/~/companyPortalBranding) | **Nome do Perfil**: JC2Sec, **Telefone de Contato**: Não configurado, **Email de Contato**: Não configurado | N/A | N/A |\n| [JC2Sec](https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/TenantAdminMenu/~/companyPortalBranding) | **Nome do Perfil**: JC2Sec, **Telefone de Contato**: 19991007159, **Email de Contato**: suporte.n1@jcadvisor.com.br | ✅ Atribuído | **Included:** Colaboradores - JC2SEC |\n\n\n",
      "TestDescription": "Se a marca do Company Portal do Intune não estiver configurada para representar os detalhes da sua organização, os usuários podem encontrar uma interface genérica e faltar informações de suporte direto. Isso reduz a confiança do usuário, aumenta a sobrecarga de suporte e pode causar confusão ou atrasos na resolução de problemas.\n\nPersonalizar o Company Portal com a marca da sua organização e detalhes de contato de suporte melhora a confiança do usuário, agiliza o suporte e reforça a legitimidade das comunicações de gerenciamento de dispositivos.\n\n\n**Ação de remediação**\n\nConfigure o Company Portal do Intune com a marca da sua organização e informações de contato de suporte para melhorar a experiência do usuário e reduzir a sobrecarga de suporte:  \n- [Configurar o Company Portal do Intune](https://learn.microsoft.com/intune/intune-service/apps/company-portal-app?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24823",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Configurações de marca e suporte do Company Portal melhoram a experiência e a confiança do usuário"
    },
    {
      "TestResult": "\n⚠️ Nenhum conector de rede privada está configurado.\n\n[Para configurar conectores de rede privada: Global Secure Access > Conectar > Conectores](https://entra.microsoft.com/#view/Microsoft_Entra_GSA_Connect/Connectors.ReactView/fromNav/globalSecureAccess)\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Failed",
      "TestRisk": "Medium",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "25391",
      "TestTitle": "Os conectores de rede privada estão ativos e saudáveis para manter o acesso Zero Trust a recursos internos",
      "TestDescription": "Quando os conectores de rede privada do Microsoft Entra estiverem inativos ou não saudáveis, as organizações podem recorrer a métodos de acesso menos seguros. Essa condição cria oportunidades para agentes de ameaça direcionarem serviços expostos externamente ou usarem credenciais comprometidas.\n\nSem conectores funcionais:\n\n- A autenticação e autorização baseadas em token para todos os cenários do Microsoft Entra Private Access ficam eliminadas.\n- Agentes de ameaça podem contornar os limites de segurança pretendidos para acessar recursos além do escopo autorizado.\n- O serviço não consegue rotear solicitações corretamente, interrompendo diretamente os controles de acesso à rede.\n\n**Ação de remediação**\n\n- [Configure conectores para alta disponibilidade](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-connectors?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Monitore a integridade dos conectores no centro de administração do Microsoft Entra em Global Secure Access > Conectar > Conectores.\n- [Solucione problemas de instalação e conectividade dos conectores](https://learn.microsoft.com/entra/global-secure-access/troubleshoot-connectors?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Colaboração externa",
      "SkippedReason": null,
      "TestResult": "\n❌ O acesso de usuários convidados não está restrito.\n",
      "TestDescription": "Contas de usuários externos são frequentemente usadas para fornecer acesso a parceiros de negócios. Se essas contas forem comprometidas em sua organização de origem, os atacantes podem usar as credenciais válidas para obter acesso inicial ao seu ambiente.\n\nContas externas com permissões para ler objetos do diretório fornecem aos atacantes um acesso inicial mais amplo se comprometidas. Essas contas permitem que os criminosos coletem informações adicionais do diretório para reconhecimento (reconnaissance).\n\n**Ação de remediação**\n\n- [Restringir o acesso de convidados aos seus próprios objetos de diretório](https://learn.microsoft.com/entra/external-id/external-collaboration-settings-configure?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#to-configure-guest-user-access)\n",
      "TestImplementationCost": "Low",
      "TestId": "21792",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Convidados possuem acesso restrito a objetos do diretório"
    },
    {
      "TestPillar": "Devices",
      "TestStatus": "Failed",
      "TestCategory": "Tenant",
      "SkippedReason": null,
      "TestResult": "\n❌ Nenhuma notificação de registo de dispositivos encontrada ou atribuída.\n\n",
      "TestDescription": "Sem notificações de registo de dispositivos, os utilizadores podem não ter conhecimento de que o seu dispositivo foi registado no Intune — particularmente em casos de registo não autorizado ou inesperado. Esta falta de visibilidade pode atrasar o reporte de atividades suspeitas por parte do utilizador e aumentar o risco de dispositivos não geridos ou comprometidos ganharem acesso a recursos corporativos. Atacantes que obtenham credenciais de utilizador ou explorem fluxos de auto-registo podem integrar dispositivos silenciosamente, contornando o escrutínio do utilizador e permitindo a exposição de dados ou movimento lateral.\n\nAs notificações de registo proporcionam aos utilizadores uma melhor visibilidade sobre a atividade de integração de dispositivos. Ajudam a detetar registos não autorizados, reforçam práticas de aprovisionamento seguras e apoiam os princípios Zero Trust de visibilidade, verificação e envolvimento do utilizador.\n\n**Ação de correção**\n\nConfigure as notificações de registo do Intune para alertar os utilizadores quando o seu dispositivo for registado e reforçar as práticas de integração seguras:\n- [Configurar notificações de registo no Intune](https://learn.microsoft.com/intune/intune-service/enrollment/enrollment-notifications?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "24572",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Intune",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Notificações de registo de dispositivos são impostas para garantir a consciencialização do utilizador"
    },
    {
      "TestResult": "\n❌ Nenhum aplicativo Quick Access encontrado com a etiqueta 'NetworkAccessQuickAccessApplication'.\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Failed",
      "TestRisk": "Medium",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "",
      "TestId": "25399",
      "TestTitle": "O DNS privado está configurado para resolução de nomes internos",
      "TestDescription": "Sem configuração de DNS privado, usuários remotos não conseguem resolver nomes de domínio internos por meio do Microsoft Entra Private Access e precisam confiar em servidores DNS públicos. Agentes de ameaça podem explorar essa falha por meio de ataques de spoofing DNS que redirecionam usuários para sites maliciosos, permitindo a captura de credenciais e exfiltração de dados. As organizações também perdem visibilidade sobre consultas DNS e não conseguem aplicar políticas de segurança consistentes.\n\n**Ação de remediação**\n\n- [Configure DNS privado para resolução de nomes internos](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-quick-access?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#add-private-dns-suffixes)\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Failed",
      "TestCategory": "Colaboração externa",
      "SkippedReason": null,
      "TestResult": "\nListas de permissão/bloqueio de domínios para restringir colaboração externa não estão configuradas.\n",
      "TestDescription": "Limitar o acesso de convidados a uma lista conhecida e aprovada de tenants (tenants) ajuda a evitar que atores de ameaça explorem o acesso irrestrito para estabelecer acesso inicial por meio de contas externas comprometidas ou criando contas em tenants não confiáveis. Atores de ameaça que ganham acesso por meio de um domínio irrestrito podem descobrir recursos internos, usuários e aplicativos para realizar ataques adicionais.\n\nAs organizações devem realizar um inventário e configurar uma lista de permissão (allowlist) ou de bloqueio (blocklist) para controlar convites de colaboração B2B de organizações específicas. Sem esses controles, atores de ameaça podem usar técnicas de engenharia social para obter convites de usuários internos legítimos.\n\n**Ação de correção**\n\n- Saiba como [configurar uma lista de domínios aprovados](https://learn.microsoft.com/entra/external-id/allow-deny-list?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#add-an-allowlist).\n",
      "TestImplementationCost": "High",
      "TestId": "21874",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "Free",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "O acesso de convidados é limitado a tenants aprovados"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Investigar",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\nForam encontradas Entidades de Serviço com credenciais configuradas no tenant, o que representa um risco de segurança.\n\n\n## Entidades de Serviço com credenciais configuradas no tenant\n\n\n| Nome da Entidade de Serviço | Tipo de Credencial | Data de Expiração da Credencial | Status de Expiração |\n| :-------------------------- | :----------------- | :------------------------------ | :------------------ |\n| [Acronis Cyber Protect Cloud](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/6e86df2a-cb0f-40ed-aa4f-49946dfc4e29/appId/ca10e8b2-8cd2-4973-b6c4-40e57ffbab20) | Credenciais de Senha | 2029-01-30 | ✅ Atual |\n| [Key Cloak](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/87e10597-c491-4802-967c-fd2bd7792adc/appId/3d2e56a5-7c93-4f98-98dd-3d0bb09fca17) | Credenciais de Senha | 2028-09-16 | ✅ Atual |\n| [P2P Server](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/927d089e-02d2-4459-a10b-564d9e0c58a8/appId/ec9962e3-5170-42a2-a042-bf348b84df9b) | Credenciais de Senha | 2026-06-10 | ✅ Atual |\n| [Services Desk - Freshservice](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/0e4f0ba8-986a-47ef-a1e7-64a771c56c24/appId/371c5a86-51b1-4079-8b1b-558d2f199bab) | Credenciais de Senha | 2029-03-23 | ✅ Atual |\n| [Acronis Cyber Protect Cloud](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/6e86df2a-cb0f-40ed-aa4f-49946dfc4e29/appId/ca10e8b2-8cd2-4973-b6c4-40e57ffbab20) | Credenciais de Chave | 2029-01-30 | ✅ Atual |\n| [Key Cloak](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/87e10597-c491-4802-967c-fd2bd7792adc/appId/3d2e56a5-7c93-4f98-98dd-3d0bb09fca17) | Credenciais de Chave | 2028-09-16 | ✅ Atual |\n| [P2P Server](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/927d089e-02d2-4459-a10b-564d9e0c58a8/appId/ec9962e3-5170-42a2-a042-bf348b84df9b) | Credenciais de Chave | 2026-06-10 | ✅ Atual |\n| [Services Desk - Freshservice](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/0e4f0ba8-986a-47ef-a1e7-64a771c56c24/appId/371c5a86-51b1-4079-8b1b-558d2f199bab) | Credenciais de Chave | 2029-03-23 | ✅ Atual |\n\n\n",
      "TestDescription": "Entidades de serviço sem credenciais de autenticação adequadas (certificados ou segredos de cliente) criam vulnerabilidades de segurança que permitem que atores de ameaças personifiquem essas identidades. Isso pode levar ao acesso não autorizado, movimentação lateral dentro do seu ambiente, escalonamento de privilégios e acesso persistente que é difícil de detectar e remediar.\n\n**Ação de correção**\n\n- Para as entidades de serviço da sua organização: [Adicionar certificados ou segredos de cliente ao registro do aplicativo](https://learn.microsoft.com/entra/identity-platform/how-to-add-credentials?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- Para entidades de serviço externas: Revise e remova quaisquer credenciais desnecessárias para reduzir o risco de segurança\n",
      "TestImplementationCost": "Medium",
      "TestId": "21896",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Entidades de serviço não possuem certificados ou credenciais associadas a elas"
    },
    {
      "TestResult": "\n⚠️ O aplicativo Quick Access não está configurado no tenant. Os clientes devem revisar a documentação sobre como ativar o Quick Access.\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Investigate",
      "TestRisk": "Medium",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "25480",
      "TestTitle": "O Quick Access tem atribuições de usuários ou grupos",
      "TestDescription": "Quando o Quick Access não tem atribuições de usuário ou grupo, o serviço impede conexões aos nomes de domínio totalmente qualificados (FQDNs) e endereços IP que você configura nos segmentos de aplicação. Essa restrição interrompe o acesso aos recursos internos, como compartilhamentos de arquivos, aplicações da web e bancos de dados. Quando os usuários não conseguem alcançar recursos através do cliente Global Secure Access, eles podem procurar métodos de acesso alternativos que contornam controles de segurança, como políticas do Conditional Access e autenticação multifator.\n\nSe você não atribuir usuários ao Quick Access:\n\n- Os usuários autorizados não conseguem alcançar recursos internos através do Private Access, criando lacunas na continuidade de negócios.\n- Os administradores podem implementar soluções temporárias que enfraquecem a postura de segurança da organização.\n\n**Ação de remediação**\n\n- [Atribua usuários e grupos ao Quick Access](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-quick-access?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para ativar a conectividade do Private Access aos segmentos de aplicação configurados.\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\n✅ **Passou**: A política de gerenciamento de aplicativos está habilitada e configurada.\n\n\n",
      "TestDescription": "Sem políticas adequadas de gerenciamento de aplicativos, atacantes podem explorar credenciais fracas ou mal configuradas para obter acesso não autorizado aos recursos organizacionais. Aplicativos que usam segredos de senha ou certificados de longa duração criam janelas de ataque estendidas. Se um aplicativo usa segredos de cliente codificados em arquivos de configuração ou possui requisitos de senha fracos, os invasores podem extrair essas credenciais. A falta de gerenciamento do ciclo de vida das credenciais permite que credenciais comprometidas permaneçam ativas indefinidamente.\n\nConfigurar políticas de gerenciamento de aplicativos apropriadas ajuda as organizações a se manterem à frente dessas ameaças.\n\n**Ação de remediação**\n\n- [Saiba como impor padrões de segredos e certificados usando políticas de gerenciamento de aplicativos](https://learn.microsoft.com/entra/identity/enterprise-apps/tutorial-enforce-secret-standards?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21775",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Impor padrões para segredos e certificados de aplicativos"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Colaboração externa",
      "SkippedReason": null,
      "TestResult": "\n✅ **Passou**: Não foram encontrados usuários convidados como proprietários de aplicativos no tenant.\n",
      "TestDescription": "Sem restrições que impeçam os usuários convidados de registrar e possuir aplicativos, atores de ameaça podem explorar contas de usuários externos para estabelecer acesso de backdoor persistente aos recursos organizacionais por meio de registros de aplicativos que podem escapar do monitoramento de segurança tradicional. Quando os usuários convidados possuem aplicativos, contas de convidados comprometidas podem ser usadas para explorar aplicativos de propriedade de convidados que podem ter permissões amplas. Essa vulnerabilidade permite que atores de ameaça solicitem acesso a dados organizacionais sensíveis, como e-mails, arquivos e informações de usuários, sem o mesmo nível de escrutínio dedicado a aplicativos de propriedade de usuários internos.\n\nEste vetor de ataque é perigoso porque os aplicativos de propriedade de convidados podem ser configurados para solicitar permissões de alto privilégio e, uma vez concedido o consentimento, fornecer aos atores de ameaça tokens OAuth legítimos. Além disso, aplicativos de propriedade de convidados podem servir como infraestrutura de comando e controle, permitindo que atores de ameaça mantenham o acesso mesmo após a conta de convidado comprometida ser detectada e remediada. As credenciais e permissões do aplicativo podem persistir independentemente da conta de usuário convidado original, permitindo que atores de ameaça mantenham o acesso. Aplicativos de propriedade de convidados também complicam os esforços de auditoria de segurança e governança, pois as organizações podem ter visibilidade limitada sobre o propósito e a postura de segurança dos aplicativos registrados por usuários externos. Essas fraquezas ocultas no gerenciamento do ciclo de vida do aplicativo dificultam a avaliação do verdadeiro escopo do acesso a dados concedido a entidades que não pertencem à Microsoft por meio de registros de aplicativos aparentemente legítimos.\n\n**Ação de correção**\n- Remova usuários convidados como proprietários de aplicativos e entidades de serviço e implemente controles para evitar a propriedade futura de aplicativos por usuários convidados.\n- [Restringir as permissões de acesso de usuários convidados](https://learn.microsoft.com/entra/identity/users/users-restrict-guest-permissions?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21868",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": [
        "Identidade"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identidade"
      ],
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Convidados não possuem aplicativos no tenant"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": null,
      "TestResult": "\nA duração do Bloqueio Inteligente está configurada para 60 segundos ou mais.\n## Configurações do Bloqueio Inteligente\n\n| Configuração | Valor |\n| :---- | :---- |\n| [Duração do Bloqueio (segundos)](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/AuthenticationMethodsMenuBlade/~/PasswordProtection/fromNav/) | 60 |\n\n",
      "TestDescription": "Quando a duração do Bloqueio Inteligente (Smart Lockout) é configurada abaixo do padrão de 60 segundos, atores de ameaça podem explorar períodos de bloqueio mais curtos para realizar ataques de password spray e credential stuffing de forma mais eficaz. Janelas de bloqueio reduzidas permitem que os atacantes retomem as tentativas de autenticação mais rapidamente, aumentando sua probabilidade de sucesso e, potencialmente, evitando sistemas de detecção que dependem de períodos de observação mais longos.\n\n**Ação de remediação**\n\n- [Definir a duração do Bloqueio Inteligente para 60 segundos ou mais](https://learn.microsoft.com/entra/identity/authentication/howto-password-smart-lockout?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#manage-microsoft-entra-smart-lockout-values)\n",
      "TestImplementationCost": "Low",
      "TestId": "21849",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "A duração do bloqueio inteligente está definida para um mínimo de 60 segundos"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "SharePoint Online",
      "SkippedReason": null,
      "TestResult": "\n✅ O suporte de rotulagem de PDF está habilitado no SharePoint Online e OneDrive, permitindo que os usuários classifiquem e protejam arquivos PDF.\n\n### Resumo de configuração do SharePoint Online\n\n**Configurações de locatário:**\n* EnableSensitivityLabelforPDF: True\n\n[Gerenciar proteção de informações no Centro de Administração do SharePoint](https://admin.microsoft.com/sharepoint?page=classicSettings&modern=true)\n\n",
      "TestDescription": "Quando a rotulagem de PDF está desabilitada (o padrão) no SharePoint, os arquivos PDF não podem ser rotulados ou exibir rótulos existentes, criando uma lacuna de proteção. Diferentemente dos arquivos do Office, os PDFs podem circular externamente sem marcadores de classificação visíveis, tornando impossível para os destinatários determinar os requisitos de manipulação ou para as políticas de prevenção de perda de dados (DLP) detectar conteúdo sensível.\n\nAo habilitar a rotulagem de PDF para o SharePoint e o OneDrive, estende-se o suporte de rótulo de sensibilidade a PDFs, permitindo que os usuários apliquem rótulos usando o Office na web e o SharePoint, e suporta outros métodos de rotulagem, como políticas de aplicação automática de rótulos para classificar automaticamente o conteúdo de PDF.\n\n**Ação de remediação**\n\n- [Habilitar rótulos de sensibilidade para arquivos PDF no SharePoint e OneDrive](https://learn.microsoft.com/purview/sensitivity-labels-sharepoint-onedrive-files?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#adding-support-for-pdf)\n",
      "TestImplementationCost": "Low",
      "TestId": "35006",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "MIP_P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "A rotulagem de PDF está habilitada no SharePoint"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": null,
      "TestResult": "\nO recurso de relatar atividade suspeita no app Authenticator está [ativado para todos os usuários](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/AuthenticationMethodsMenuBlade/~/AuthMethodsSettings).\n",
      "TestDescription": "Atores de ameaça dependem cada vez mais de bombardeio de solicitações (prompt bombing) e proxies de phishing em tempo real para coagir ou enganar os usuários a aprovar desafios fraudulentos de autenticação multifator (MFA). Sem o recurso **Relatar atividade suspeita** do aplicativo Microsoft Authenticator ativado, um invasor pode iterar até que um usuário fadigado aceite a solicitação. Esse tipo de ataque pode levar ao escalonamento de privilégios, persistência, movimentação lateral em cargas de trabalho sensíveis, exfiltração de dados ou ações destrutivas.\n\nQuando o relatório está ativado para todos os usuários, qualquer solicitação inesperada por push ou telefone pode ser sinalizada ativamente, elevando imediatamente o usuário a um risco alto e gerando uma detecção de risco de alta fidelidade (userReportedSuspiciousActivity) que políticas de Acesso Condicional baseadas em risco ou outras automações de resposta podem usar para bloquear ou exigir remediação segura.\n\n**Ação de correção**\n\n- [Ativar a configuração de relatar atividade suspeita no aplicativo Microsoft Authenticator](https://learn.microsoft.com/entra/identity/authentication/howto-mfa-mfasettings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#report-suspicious-activity)\n",
      "TestImplementationCost": "Low",
      "TestId": "21841",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Configuração de relatar atividade suspeita no app Microsoft Authenticator está ativada"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\nNenhum aplicativo ADAL encontrado no tenant.\n",
      "TestDescription": "A Microsoft encerrou o suporte e as correções de segurança para o ADAL em 30 de junho de 2023. O uso continuado do ADAL ignora as proteções de segurança modernas disponíveis apenas no MSAL, incluindo a imposição de Acesso Condicional, Avaliação de Acesso Contínuo (CAE) e proteção avançada de tokens. Os aplicativos ADAL criam vulnerabilidades de segurança ao usar padrões de autenticação legados mais fracos, muitas vezes chamando endpoints obsoletos do Azure AD Graph, e impedindo a adoção de fluxos de autenticação endurecidos que poderiam mitigar futuros avisos de segurança.\n\n**Ação de remediação**\n\n- [Migrar aplicativos para a Biblioteca de Autenticação da Microsoft (MSAL)](https://learn.microsoft.com/entra/identity-platform/msal-migration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "High",
      "TestId": "21780",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Nenhum uso de ADAL no tenant"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Colaboração externa",
      "SkippedReason": null,
      "TestResult": "\nConvidados não possuem sessões de logon de longa duração.\n\n## Políticas de Acesso Condicional Analisadas\n\n| Nome da Política | Frequência de Logon | Status |\n| :--- | :--- | :--- |\n\n",
      "TestDescription": "Contas de convidados com sessões de logon estendidas aumentam a superfície de ataque. Quando as sessões persistem além do tempo necessário, atores de ameaça podem tentar acesso inicial via credential stuffing, pulverização de senhas ou engenharia social. Uma vez dentro, podem manter o acesso por longos períodos sem novos desafios de autenticação. Essas sessões estendidas permitem:\n\n- Acesso não autorizado a artefatos do Microsoft Entra, permitindo identificar recursos sensíveis.\n- Persistência na rede usando tokens de autenticação legítimos, dificultando a detecção.\n- Uma janela maior para escalar privilégios acessando recursos compartilhados ou explorando relações de confiança.\n\nSem controles de sessão adequados, invasores podem realizar movimentação lateral por toda a infraestrutura, acessando dados críticos muito além do escopo original da conta de convidado.\n\n**Ação de correção**\n- [Configurar políticas adaptativas de tempo de vida de sessão](https://learn.microsoft.com/entra/identity/conditional-access/howto-conditional-access-session-lifetime?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para que as políticas de frequência de logon tenham sessões mais curtas.\n",
      "TestImplementationCost": "Low",
      "TestId": "21824",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Convidados não possuem sessões de logon de longa duração"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Colaboração externa",
      "SkippedReason": null,
      "TestResult": "\nResumo da avaliação das políticas de atribuição.\n\n\n## Políticas de atribuição avaliadas\n| Pacote de acesso | Política de atribuição | Escopo de destino | Status |\n| :--- | :--- | :--- | :--- |\n| [](https://entra.microsoft.com/#view/Microsoft_AAD_ERM/DashboardBlade/~/elmEntitlement/menuId/) |  |  |  |\n\n",
      "TestDescription": "Pacotes de acesso configurados para permitir \"Todos os usuários\" em vez de organizações conectadas específicas expõem sua organização a acesso externo não controlado. Atores de ameaça podem explorar isso solicitando acesso por meio de contas externas comprometidas de organizações não autorizadas, contornando o princípio do privilégio mínimo. Isso permite o acesso inicial, reconhecimento, escalonamento de privilégios e movimentação lateral dentro do seu ambiente.\n\n**Ação de correção**\n\n- [Definir organizações confiáveis como organizações conectadas](https://learn.microsoft.com/entra/id-governance/entitlement-management-organization?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#view-the-list-of-connected-organizations)\n- [Configurar pacotes de acesso para permitir apenas organizações conectadas específicas](https://learn.microsoft.com/entra/id-governance/entitlement-management-access-package-create?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#allow-users-not-in-your-directory-to-request-the-access-package)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21875",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": [
        "P2",
        "Governance"
      ],
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Todas as políticas de atribuição do gerenciamento de direitos para usuários externos exigem organizações conectadas"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "Proteção de Informações",
      "SkippedReason": null,
      "TestResult": "\n✅ A justificativa de rebaixamento é aplicada em pelo menos uma política de rótulo de sensibilidade habilitada.\n\n\n\n### Configuração de Justificativa de Rebaixamento\n| Nome da política | Justificativa de rebaixamento | Escopo | Rótulos | Cargas de trabalho |\n| :--- | :--- | :--- | :--- | :--- |\n| [Política Padrão de Classificação](https://purview.microsoft.com/informationprotection/labelpolicies) | ✅ | Global | 4 | Exchange |\n\n### Resumo\n| Métrica | Contagem |\n| :--- | :--- |\n| Total de políticas de rótulo habilitadas | 1 |\n| Políticas que exigem justificativa de rebaixamento | 1 |\n| Políticas que NÃO exigem justificativa de rebaixamento | 0 |\n| Percentual com justificativa de rebaixamento | 100% |\n",
      "TestDescription": "Quando os usuarios nao sao obrigados a fornecer justificativa para alterar um rotulo, eles podem substituir silenciosamente um rotulo por outro de menor sensibilidade. Por exemplo, trocar o rotulo \"Confidencial\", que aplica configuracoes adicionais de protecao, por \"Geral\". Essa acao cria risco de seguranca e conformidade. Exigir um motivo de justificativa torna esse risco mais evidente para os usuarios e os obriga a registrar uma razao, criando uma trilha de auditoria visivel.\n\nContas comprometidas ou funcionarios em desligamento podem rebaixar rotulos para facilitar exfiltracao de dados. Exigir justificativa e um controle leve que aumenta a responsabilidade com baixo impacto nos fluxos de trabalho do usuario.\n\n**Ação de remediação**\n\n- [Publicar rotulos de sensibilidade criando uma politica de rotulo](https://learn.microsoft.com/purview/create-sensitivity-labels?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#publish-sensitivity-labels-by-creating-a-label-policy)\n- [O que as politicas de rotulo podem fazer](https://learn.microsoft.com/purview/sensitivity-labels?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#what-label-policies-can-do)\n- [Revisar atividades de rotulagem no Activity Explorer](https://learn.microsoft.com/purview/data-classification-activity-explorer-available-events?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#protection-removed)\n",
      "TestImplementationCost": "Low",
      "TestId": "35018",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E3",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Os usuários devem fornecer justificativa para rebaixar rótulos de sensibilidade"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "Proteção de Informações",
      "SkippedReason": null,
      "TestResult": "\n✅ Políticas de retenção de email estão configuradas e habilitadas para o Exchange Online, gerenciando automaticamente o ciclo de vida da mensagem e aplicando cronogramas de retenção exigidos por conformidade.\n\n\n### [Retention policies with Exchange scope](https://purview.microsoft.com/datalifecyclemanagement/retention)\n\n| Policy name | Enabled | Exchange scope | Mode |\n| :--- | :--- | :--- | :--- |\n| pilot_default_tests | ✅ Yes | All | Enforce |\n| Piloto | ✅ Yes | Gabriel Lorenzi | JC2Sec | Enforce |\n| Piloto Gabriel | ✅ Yes | Gabriel Lorenzi | JC2Sec | Enforce |\n\n\n### Retention rules for Exchange policies\n\n| Rule name | Parent policy | Enabled | Retention action | Retention period |\n| :--- | :--- | :--- | :--- | :--- |\n| ctptr-0b3f1a99-e403-4359-8275-da118413b0a0 | Piloto Gabriel | ✅ Yes | Keep | Indefinite (Days) |\n| ctptr-3cec9213-7427-4fa8-883b-f18267f16278 | Piloto | ✅ Yes | Keep | Indefinite (Days) |\n| pilot_default_tests | pilot_default_tests | ✅ Yes | Keep | 2555 (Days) |\n\n### Summary\n\n| Metric | Value |\n| :--- | :--- |\n| Total retention policies | 3 |\n| Enabled Exchange policies | 3 |\n| Active retention rules (Exchange) | 3 |\n",
      "TestDescription": "Sem políticas de retenção, os emails persistem indefinidamente nas caixas de correio dos usuários, criando responsabilidade por violações regulatórias (GDPR, HIPAA, SOX), aumento de custos de descoberta eletrônica e despesas de armazenamento descontroladas.\n\nAs políticas de retenção gerenciam automaticamente o ciclo de vida do email excluindo ou preservando mensagens com base em requisitos de conformidade, reduzindo o risco legal e garantindo que as obrigações de manter registros regulatórios sejam atendidas.\n\n**Ação de remediação**\n\n- [Criar e gerenciar políticas de retenção](https://learn.microsoft.com/purview/create-retention-policies?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "35028",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E3",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Email retention policies are configured"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Acesso privilegiado",
      "SkippedReason": null,
      "TestResult": "\nAlertas de ativação estão configurados para a função de Administrador Global.\n\n| Função | Destinatários Padrão | Destinatários Adicionais |\n| :--- | :--- | :--- |\n\n",
      "TestDescription": "Sem alertas de ativação para atribuições de função de Administrador Global, atores de ameaça podem escalar privilégios sem serem detectados. Essa falta de visibilidade cria um ponto cego onde os invasores podem ativar a função mais privilegiada e realizar ações maliciosas, como criar contas de backdoor, modificar políticas de segurança ou acessar dados confidenciais.\n\nO monitoramento desses alertas de ativação pode ajudar as equipes de segurança a distinguir entre atividades de escalonamento de privilégios autorizadas e não autorizadas.\n\n**Ação de correção**\n\n- [Configure notificações para funções privilegiadas](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-how-to-change-default-settings?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#require-justification-on-active-assignment)\n",
      "TestImplementationCost": "Low",
      "TestId": "21819",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P2",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Alerta de ativação para atribuições de função de Administrador Global"
    },
    {
      "TestResult": "\nℹ️ Nenhum conector de rede privada encontrado neste locatário.\n\n\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Passed",
      "TestRisk": "Medium",
      "TestCategory": "Private Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "25392",
      "TestTitle": "Os conectores de rede privada estão executando a versão mais recente",
      "TestDescription": "O conector de rede privada é um componente essencial do Microsoft Entra Private Access e do Application Proxy. Para manter a segurança, estabilidade e desempenho, todas as máquinas de conector devem executar a versão mais recente do software.\n\nSe seus conectores não estiverem executando a versão mais recente:\n\n- Eles podem estar sem patches críticos de segurança, deixando os conectores vulneráveis a explorações conhecidas.\n- Você não recebe as últimas melhorias de desempenho e correções de bugs, o que pode afetar a confiabilidade.\n- Problemas de compatibilidade podem surgir com o serviço Global Secure Access à medida que ele evolui.\n\n**Ação de remediação**\n\n- [Configure conectores de rede privada para Microsoft Entra Private Access e Microsoft Entra Application Proxy](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-connectors?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Verifique se todos os seus conectores estão atualizados e instale as últimas [atualizações de conectores](https://learn.microsoft.com/entra/global-secure-access/concept-connectors?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#connector-updates).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\n✅ Todas as contas de convidados no tenant possuem um padrinho atribuído.\n",
      "TestDescription": "Convidar convidados externos é benéfico para a colaboração organizacional. No entanto, na ausência de um padrinho (sponsor) interno atribuído para cada convidado, essas contas podem persistir no diretório sem uma responsabilidade clara. Essa negligência cria um risco: atores de ameaças poderiam potencialmente comprometer uma conta de convidado não utilizada ou não monitorada e, em seguida, estabelecer um ponto de entrada inicial dentro do tenant. Uma vez concedido o acesso como um aparente usuário \"legítimo\", um invasor pode explorar recursos acessíveis e tentar a escalada de privilégios, o que poderia, em última análise, expor informações confidenciais ou sistemas críticos. Uma conta de convidado não monitorada pode, portanto, tornar-se o vetor de acesso não autorizado a dados ou de uma violação de segurança significativa. Uma sequência típica de ataque pode seguir o seguinte padrão, tudo realizado sob o disfarce de um colaborador externo padrão:\n\n1. Acesso inicial obtido através de credenciais de convidado comprometidas.\n2. Persistência devido à falta de supervisão.\n3. Escalada adicional ou movimentação lateral se a conta do convidado possuir associações a grupos ou permissões elevadas.\n4. Execução de objetivos maliciosos.\n\nExigir que cada conta de convidado seja atribuída a um padrinho mitiga diretamente esse risco. Tal requisito garante que cada usuário externo esteja vinculado a uma parte interna responsável, da qual se espera que monitore e ateste regularmente a necessidade contínua de acesso do convidado. O recurso de padrinho (sponsor) no Microsoft Entra ID apoia a responsabilidade rastreando o convidador e prevenindo a proliferação de contas de convidados \"órfãs\". Quando um padrinho gerencia o ciclo de vida da conta do convidado, como remover o acesso quando a colaboração termina, a oportunidade para atores de ameaças explorarem contas negligenciadas é substancialmente reduzida. Esta prática recomendada é consistente com a orientação da Microsoft de exigir o apadrinhamento para convidados de negócios como parte de uma estratégia eficaz de governança de acesso de convidados. Ela estabelece um equilíbrio entre permitir a colaboração e reforçar a segurança, pois garante que a presença e as permissões de cada usuário convidado permaneçam sob supervisão interna contínua.\n\n**Ação de correção**\n- Para cada usuário convidado que não possui padrinho, atribua um padrinho no Microsoft Entra ID.\n    - [Adicionar um padrinho a um usuário convidado no centro de administração do Microsoft Entra](https://learn.microsoft.com/entra/external-id/b2b-sponsors?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n    - [Adicionar um padrinho a um usuário convidado usando o Microsoft Graph](https://learn.microsoft.com/graph/api/user-post-sponsors?view=graph-rest-1.0&preserve-view=true&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21877",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "Free",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Todos os convidados possuem um padrinho"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\n## Resumo de Avaliação\n\nEstes aplicativos não exigem atribuição e possuem trabalhos de provisionamento sem filtros de escopo adequados.\n\n\n",
      "TestDescription": "Quando os aplicativos empresariais carecem tanto de requisitos de atribuição explícitos QUANTO de controles de provisionamento com escopo, atores de ameaça podem explorar essa vulnerabilidade dupla para obter acesso não autorizado a aplicativos e dados sensíveis. O risco mais alto ocorre quando os aplicativos são configurados com a configuração padrão: \"Atribuição necessária\" definida como \"Não\" *e* o provisionamento não é obrigatório ou não possui escopo definido. Essa combinação perigosa permite que atores de ameaça que comprometam qualquer conta de usuário dentro do tenant acessem imediatamente aplicativos com amplas bases de usuários, expandindo sua superfície de ataque e o potencial para movimentação lateral dentro da organização.\n\nEmbora um aplicativo com atribuição aberta, mas com escopo de provisionamento adequado (como filtros baseados em departamento ou requisitos de associação a grupos), mantenha controles de segurança por meio da camada de provisionamento, aplicativos que carecem de ambos os controles criam caminhos de acesso irrestritos que atores de ameaça podem explorar. Quando os aplicativos provisionam contas para todos os usuários sem restrições de atribuição, atores de ameaça podem abusar de contas comprometidas para realizar atividades de reconhecimento, enumerar dados sensíveis em múltiplos sistemas ou usar os aplicativos como pontos de apoio para novos ataques contra recursos conectados. Este modelo de acesso irrestrito é perigoso para aplicativos que possuem permissões elevadas ou estão conectados a sistemas de negócios críticos. Atores de ameaça podem usar qualquer conta de usuário comprometida para acessar informações sensíveis, modificar dados ou realizar ações não autorizadas.\n\n**Ação de correção**\n- Avalie os requisitos de negócios para determinar o método de controle de acesso apropriado. [Restringir um aplicativo do Microsoft Entra a um conjunto de usuários](https://learn.microsoft.com/entra/identity-platform/howto-restrict-your-app-to-a-set-of-users?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Configure aplicativos empresariais para exigir atribuição para aplicativos sensíveis. [Saiba mais sobre a propriedade \"Atribuição necessária\" de aplicativos empresariais](https://learn.microsoft.com/entra/identity/enterprise-apps/application-properties?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#assignment-required).\n- Implemente o provisionamento com escopo baseado em grupos, departamentos ou atributos. [Criar filtros de escopo](https://learn.microsoft.com/entra/identity/app-provisioning/define-conditional-rules-for-provisioning-user-accounts?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-scoping-filters).\n",
      "TestImplementationCost": "Medium",
      "TestId": "21869",
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Aplicativos empresariais devem exigir atribuição explícita ou provisionamento com escopo"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": null,
      "TestResult": "\n## Resumo de Configuração\n\n| Configuração | Status |\n| :--- | :--- |\n| Passe de Acesso Temporário | Ativado ✅ |\n\n",
      "TestDescription": "Sem o Passe de Acesso Temporário (TAP) ativado, as organizações enfrentam desafios significativos para realizar o bootstrapping seguro das credenciais de usuário, criando uma vulnerabilidade onde os usuários dependem de mecanismos de autenticação fracos durante sua configuração inicial. Quando os usuários não podem registrar credenciais resistentes a phishing, como chaves de segurança FIDO2 ou Windows Hello for Business, por falta de métodos de autenticação forte existentes, eles permanecem expostos a ataques baseados em credenciais, incluindo phishing e pulverização de senhas. Atores de ameaça podem explorar essa lacuna de registro visando os usuários em seu estado mais vulnerável, quando possuem opções limitadas e dependem de combinações tradicionais de usuário + senha. Essa exposição permite o comprometimento de contas durante a fase crítica de configuração, permitindo a manipulação do processo de registro para métodos de autenticação forte e ganhando acesso persistente.\n\nAtive o TAP e use-o com o registro de informações de segurança para proteger essa lacuna potencial em suas defesas.\n\n**Ação de correção**\n\n- [Saiba como ativar o Passe de Acesso Temporário na política de métodos de autenticação](https://learn.microsoft.com/entra/identity/authentication/howto-authentication-temporary-access-pass?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enable-the-temporary-access-pass-policy)\n- [Saiba como atualizar as políticas de força de autenticação para incluir o Passe de Acesso Temporário](https://learn.microsoft.com/entra/identity/authentication/concept-authentication-strength-advanced-options?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Saiba como criar uma política de Acesso Condicional para registro de informações de segurança com imposição de força de autenticação](https://learn.microsoft.com/entra/identity/conditional-access/policy-all-users-security-info-registration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21845",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "O passe de acesso temporário está ativado"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Colaboração externa",
      "SkippedReason": null,
      "TestResult": "\nNenhuma política de atribuição de pacotes de acesso encontrada no tenant.\n",
      "TestDescription": "Políticas de atribuição de pacotes de acesso que permitem que usuários externos solicitem acesso devem exigir aprovação. Sem uma etapa de aprovação, usuários externos podem auto-provisionar acesso a recursos organizacionais sem supervisão. Exigir aprovação garante que um aprovador designado revise cada solicitação, proporcionando uma oportunidade para validar a identidade do solicitante e a justificativa comercial antes de conceder o acesso.\n\n**Ação de correção**\n\n- [Configurar aprovação para políticas de atribuição de pacotes de acesso](https://learn.microsoft.com/entra/id-governance/entitlement-management-access-package-approval-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Revisar políticas de pacotes de acesso para usuários externos](https://learn.microsoft.com/entra/id-governance/entitlement-management-access-package-request-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21879",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P2",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Todas as políticas de atribuição de pacotes de acesso que se aplicam a usuários externos exigem aprovação"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "Configuração de política de rótulos",
      "SkippedReason": null,
      "TestResult": "\n✅ A herança de rótulo de email de anexos está configurada. Pelo menos uma política de rótulo tem a configuração `attachmentaction` habilitada e os rótulos com escopo de Arquivos e Emails estão disponíveis para herdar de anexos para mensagens de email.\n\n\n### [Políticas com configuração attachmentaction](https://purview.microsoft.com/informationprotection/labelpolicies)\n\n| Nome da política | Herdar rótulo de anexos |\n| :---------- | :----------------------------- |\n| Política Padrão de Classificação | automatic |\n\n### [Rótulos com duplo escopo (prontos para herança)](https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels)\n\n| Nome do rótulo | Tipo de conteúdo | Prioridade |\n| :--------- | :----------- | :------- |\n| Uso Interno | Files & Emails | 1 |\n| Uso Restrito | Files & Emails | 2 |\n| [Pública] | Files & Emails | 3 |\n| [Interna] | Files & Emails | 4 |\n| [Restrita] | Files & Emails | 5 |\n| [Confidencial] | Files & Emails | 6 |\n\n**Resumo:**\n\n- Políticas com attachmentaction habilitado: 1\n- Rótulos com escopo de Arquivos e Emails: 6\n- Configuração de herança encontrada: Sim\n\n",
      "TestDescription": "Quando os usuários anexam documentos sensíveis a emails, o email deve herdar o rótulo de sensibilidade mais alto dos anexos para manter uma proteção consistente. Sem essa configuração habilitada, os usuários podem enviar emails sem rótulo que contém anexos sensíveis, criando uma incompatibilidade entre a sensibilidade do email e seu conteúdo real.\n\nA herança de rótulo de email aplica automaticamente o rótulo de prioridade mais alta do anexo à mensagem de email, garantindo que os níveis de proteção corresponderm e impedem a exposição de dados acidental.\n\n**Ação de remediação**\n\n- [Publicar rótulos de sensibilidade](https://learn.microsoft.com/purview/create-sensitivity-labels?tabs=modern-label-scheme&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#publish-sensitivity-labels-by-creating-a-label-policy) para [Configurar herança de rótulo de anexos de email](https://learn.microsoft.com/purview/sensitivity-labels-office-apps?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#configure-label-inheritance-from-email-attachments).\n",
      "TestImplementationCost": "Low",
      "TestId": "35014",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E3",
      "TestImpact": "High",
      "TestRisk": "Medium",
      "TestTitle": "As políticas de rótulo de email herdam sensibilidade de anexos"
    },
    {
      "TestResult": "\n✅ Os logs de implantação do GSA são preenchidos e implantações recentes foram bem-sucedidas.\n\n\n## [Logs de Implantação](https://entra.microsoft.com/#view/Microsoft_Azure_Network_Access/DeploymentLogs.ReactView)\n\n**Resumo de Implantação (Últimos 30 Dias):**\n\n| Metric | Value |\n| :--- | :--- |\n| Total Deployments | 0 |\n| Succeeded | 0 |\n| Failed | 0 |\n| In Progress | 0 |\n| Failure Rate | 0% |\n\n**Implantações recentes:**\n\nNenhuma implantação encontrada nos últimos 30 dias.\n\n",
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestStatus": "Passed",
      "TestRisk": "Medium",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Internet_Access",
        "Entra_Premium_Private_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "25422",
      "TestTitle": "Os logs de implantação do Global Secure Access estão preenchidos e revisados",
      "TestDescription": "Os logs de implantação do Global Secure Access rastreiam o status e o progresso das mudanças de configuração em toda a rede global. Essas mudanças incluem redistribuições de perfil de encaminhamento, atualizações de rede remota, mudanças de perfil de filtragem e mudanças nas configurações do Conditional Access. Se os logs de implantação mostram implantações falhadas, atores de ameaça podem explorar configurações de segurança inconsistentes em que alguns locais de borda tên políticas desatualizadas ou mal configuradas.\n\nSe você não monitorar os logs de implantação:\n\n- As implantações falhadas podem deixar lacunas de segurança, como perfis de encaminhamento desatualizados que não roteia m o tráfego através de inspeção de segurança, ou perfis de filtragem que não bloqueiam destinos maliciosos.\n- Os administradores podem não estar cientes de configurações desatualizadas, acreditando que as mudanças são aplicadas uniformemente.\n- As falhas de implantação que criam lacunas exploitáveis podem passar despercebidas.\n\n**Ação de remediação**\n\n- Siga as etapas em [Como usar os logs de implantação do Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/how-to-view-deployment-logs?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para:\n    - Acessar e revisar logs de implantação no centro de administração do Microsoft Entra para identificar implantações falhadas.\n    - Para implantações falhadas, examine a mensagem de erro no campo `status.message` e repita a mudança de configuração que acionou a falha.\n    - Monitore notificações de implantação que aparecem no centro de administração ao fazer mudanças de configuração para capturar falhas em tempo real.\n- Se as implantações continuarem falhando para redes remotas, [revise a configuração de rede remota subjacente](https://learn.microsoft.com/entra/global-secure-access/how-to-manage-remote-networks?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para erros.\n- Para falhas de implantação do perfil de encaminhamento, [verifique a configuração de encaminhamento de tráfego](https://learn.microsoft.com/entra/global-secure-access/concept-traffic-forwarding?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Governança de identidade",
      "SkippedReason": null,
      "TestResult": "\n✅ Todas as políticas de gerenciamento de direitos possuem datas de expiração configuradas.\nNenhuma política de gerenciamento de direitos foi encontrada com data de expiração configurada.\n",
      "TestDescription": "Políticas de gerenciamento de direitos (Entitlement management) sem datas de expiração criam acesso persistente que atores de ameaças podem explorar. Quando as atribuições de usuários não têm limites de tempo, credenciais comprometidas mantêm acesso indefinido, permitindo que invasores estabeleçam persistência, escalem privilégios através de pacotes de acesso adicionais e realizem atividades maliciosas de longo prazo enquanto permanecem indetectados.\n\n**Ação de correção**\n\n- [Configurar definições de expiração para pacotes de acesso](https://learn.microsoft.com/entra/id-governance/entitlement-management-access-package-lifecycle-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#specify-a-lifecycle)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21878",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": [
        "P2",
        "Governance"
      ],
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Todas as políticas de gerenciamento de direitos possuem uma data de expiração"
    },
    {
      "TestResult": "\n✅ A sinalização do Global Secure Access está habilitada.\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Passed",
      "TestRisk": "Medium",
      "TestCategory": "Rede",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Private_Access",
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "",
      "TestId": "25370",
      "TestTitle": "A restauração do IP de origem está habilitada",
      "TestDescription": "<!-- This file is a duplicate of 25380.md. Docs files reference 25380.md.-->\nQuando organizações implantam o Global Secure Access como seu proxy de rede em nuvem, a infraestrutura do Secure Service Edge da Microsoft roteia o tráfego do usuário. Se você não habilitar a restauração de IP de origem, todas as solicitações de autenticação virão do endereço IP do proxy em vez do IP público real de saída do usuário.\n\nSem essa proteção:\n\n- Atores de ameaça que comprometem credenciais de usuário podem autenticar de qualquer local enquanto contornam controles de Conditional Access baseados em IP e políticas de local nomeado.\n- As detecções de risco do Microsoft Entra ID Protection perdem visibilidade do IP de origem original do usuário, o que degrada a precisão dos algoritmos de pontuação de risco.\n- Os logs de entrada e trilhas de auditoria deixam de mostrar a fonte verdadeira das tentativas de autenticação, dificultando a investigação de incidentes e a análise forense.\n\n**Ação de remediação**\n\n- Habilite a sinalização do Global Secure Access no Conditional Access. Para mais informações, veja [Restauração de IP de origem](https://learn.microsoft.com/entra/global-secure-access/how-to-source-ip-restoration?wt_mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "SkippedReason": null
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": null,
      "TestResult": "\nO Passe de Acesso Temporário está configurado apenas para uso único.\n\n\n",
      "TestDescription": "Quando o Passe de Acesso Temporário (TAP) está configurado para permitir múltiplos usos, atores de ameaça que comprometem a credencial podem reutilizá-la repetidamente durante seu período de validade, estendendo sua janela de acesso não autorizado além do evento de configuração único pretendido. Isso cria uma oportunidade para estabelecer persistência registrando métodos extras de autenticação forte sob a conta comprometida. Um TAP reutilizável em mãos erradas permite atividades de reconhecimento em múltiplas sessões e serve como um mecanismo de backdoor confiável, aparecendo como uma ferramenta administrativa legítima nos logs de segurança.\n\n**Ação de correção**\n\n- [Configurar o Passe de Acesso Temporário para uso único na política de métodos de autenticação](https://learn.microsoft.com/entra/identity/authentication/howto-authentication-temporary-access-pass?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enable-the-temporary-access-pass-policy)\n",
      "TestImplementationCost": "Low",
      "TestId": "21846",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Restringir Passe de Acesso Temporário a Uso Único"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "Configuração de rótulos de sensibilidade",
      "SkippedReason": null,
      "TestResult": "\n✅ Os rótulos de contêiner estão configurados para Teams, grupos e sites do SharePoint.\n\n\n## Resumo\n\n| Métrica | Valor |\n|:---|:---|\n| Total de rótulos de sensibilidade | 7 |\n| Rótulos habilitados para contêiner | 6 |\n\n## [Detalhes dos rótulos de contêiner](https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels)\n\n| Nome do rótulo | Tipo de conteúdo | Nome de exibição | É pai | Prioridade |\n|:---|:---|:---|:---|:---|\n| [Uso Interno](https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels) | File, Email, Site, UnifiedGroup, Teamwork | Uso Interno | False | 1 |\n| [Uso Restrito](https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels) | File, Email, Site, UnifiedGroup, Teamwork | Uso Restrito | False | 2 |\n| [Público](https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels) | File, Email, Site, UnifiedGroup | \\[Pública\\] | False | 3 |\n| [Interno](https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels) | File, Email, Site, UnifiedGroup | \\[Interna\\] | False | 4 |\n| [Confidencial](https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels) | File, Email, Site, UnifiedGroup | \\[Restrita\\] | False | 5 |\n| [Restrito](https://purview.microsoft.com/informationprotection/informationprotectionlabels/sensitivitylabels) | File, Email, Site, UnifiedGroup | \\[Confidencial\\] | False | 6 |\n\n",
      "TestDescription": "Rótulos de contêiner estendem rótulos de sensibilidade além de itens individuais para espaços de colaboração inteiros, como Microsoft Teams, Microsoft 365 Groups e sites do SharePoint. Esses rótulos controlam configurações no nível de espaço, como compartilhamento externo, acesso de convidado, restrições de dispositivo e privacidade.\n\nSem rótulos de contêiner, os usuários podem ser capazes de criar Teams com acesso a convidado externo mesmo ao lidar com informações confidenciais. Essa ação cria riscos de exfiltração de dados onde documentos adequadamente rotulados existem em espaços de trabalho inadequadamente seguros. Rótulos de contêiner podem ajudar a garantir que a segurança do espaço de trabalho corresponda à sensibilidade do conteúdo armazenado, por exemplo, impedir que documentos rotulados como \"Altamente Confidencial\" residam em sites de Teams que permitem compartilhamento externo.\n\n**Ação de remediação**\n\n- [Use rótulos de sensibilidade para proteger o conteúdo no Microsoft Teams, grupos do Microsoft 365 e sites do SharePoint](https://learn.microsoft.com/purview/sensitivity-labels-teams-groups-sites?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "35012",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E5",
      "TestImpact": "High",
      "TestRisk": "Medium",
      "TestTitle": "Os rótulos de contêiner estão configurados para Teams, grupos e sites"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "Rótulos de sensibilidade",
      "SkippedReason": null,
      "TestResult": "\n✅ 4 rótulos de sensibilidade são publicados em políticas com escopo global, dentro o limite recomendado de 25.\n\n### [Políticas de rótulo global](https://purview.microsoft.com/informationprotection/labelpolicies)\n\n| Nome da política | Cargas de trabalho globais | Rótulos publicados | Exemplo de rótulos |\n| :--- | :--- | :---: | :--- |\n| [Política Padrão de Classificação](https://purview.microsoft.com/informationprotection/labelpolicies) | Exchange | 4 | Confidencial, Interno, Restrito, Público |\n\n### Resumo\n\n* **Total de rótulos únicos publicados globalmente:** 4\n* **Máximo recomendado:** 25\n* **Status:** Aprovado\n\n*Nota: Os rótulos que aparecem em várias políticas globais são contados uma vez (desduplicados).*\n\n",
      "TestDescription": "Publicar muitos rótulos globalmente cria confusão e parálise de decisão para usuários, reduzindo a adoção e aumentando a classificação incorreta. Quando os usuários enfrentam mais de 25 rótulos, eles lutam para identificar a classificação apropriada, levando a rótulos incorretos ou evitando completamente o recurso.\n\nA Microsoft recomenda não mais de 25 rótulos nas políticas globais, idealmente organizados como cinco rótulos principais com até cinco sub-rótulos cada um. Use políticas definidas para publicar rótulos especializados apenas para usuários, grupos ou departamentos específicos, mantendo o conjunto de rótulos globais focado em cenários comuns.\n\n**Ação de remediação**\n\n- [Limitações de rótulo de sensibilidade por locatário](https://learn.microsoft.com/purview/sensitivity-labels?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#sensitivity-label-limitations-per-tenant)\n- [Criar e publicar rótulos de sensibilidade](https://learn.microsoft.com/microsoft-365/compliance/create-sensitivity-labels?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "35015",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E3",
      "TestImpact": "High",
      "TestRisk": "Medium",
      "TestTitle": "Os rótulos de sensibilidade publicados globalmente não excedem o máximo recomendado"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Governança de identidade",
      "SkippedReason": null,
      "TestResult": "\r\nTodas as políticas de atribuição de pacotes de acesso para usuários externos incluem expiração ou revisões de acesso.\n\n## [Políticas de atribuição de pacotes de acesso para usuários externos](https://entra.microsoft.com/#view/Microsoft_AAD_ERM/DashboardBlade/~/elmEntitlement)\n\nNenhuma política de atribuição de pacotes de acesso encontrada para usuários externos.\n\r\n\r\n",
      "TestDescription": "Pacotes de acesso para usuários convidados sem datas de expiração ou revisões de acesso permitem acesso indefinido aos recursos organizacionais. Contas de convidados comprometidas ou obsoletas permitem que agentes de ameaça mantenham acesso persistente e não detectado para movimentação lateral, escalação de privilégios e exfiltração de dados. Sem validação periódica, as organizações não conseguem identificar quando os relacionamentos de negócio mudam ou quando o acesso de convidado não é mais necessário.\r\n\r\n**Ação de remediação**\r\n\r\n- [Configurar configurações de ciclo de vida](https://learn.microsoft.com/entra/id-governance/entitlement-management-access-package-lifecycle-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\r\n- [Configurar revisões de acesso](https://learn.microsoft.com/entra/id-governance/entitlement-management-access-reviews-create?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\r\n",
      "TestImplementationCost": "Medium",
      "TestId": "21929",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": [
        "P2",
        "Governance"
      ],
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Todos os pacotes de gerenciamento de direitos aplicáveis a convidados têm expirações ou revisões de acesso configuradas em suas políticas de atribuição"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\nO acesso de convidados é limitado a tenants aprovados.\n## Restrições de colaboração\n\n| Domínio | Status |\n| :--- | :--- |\n\n",
      "TestDescription": "Sem limitar o acesso de convidados a tenants (tenants) aprovados, atores de ameaça podem explorar o acesso irrestrito para estabelecer acesso inicial por meio de contas externas comprometidas ou criando contas em tenants não confiáveis. As organizações podem configurar uma lista de permissões ou bloqueios para controlar convites de colaboração B2B de organizações específicas. Sem esses controles, atores de ameaça podem usar técnicas de engenharia social para obter convites de usuários internos legítimos. Uma vez que os invasores ganham acesso de convidado por meio de domínios irrestritos, eles podem realizar atividades de descoberta para enumerar recursos internos, usuários e aplicativos. A conta de convidado comprometida serve como um ponto de apoio persistente, permitindo a exfiltração de dados de sites do SharePoint, canais do Teams e outros recursos. A partir daí, os invasores podem tentar movimentação lateral explorando relações de confiança ou usando permissões de convidado para acessar dados sensíveis.\n\n**Ação de correção**\n\n- [Configurar listas de permissão ou negação baseadas em domínio](https://learn.microsoft.com/en-us/entra/external-id/allow-deny-list)\n\n",
      "TestImplementationCost": "High",
      "TestId": "21822",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "O acesso de convidados é limitado a tenants aprovados"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "Criptografia de Mensagens do Purview",
      "SkippedReason": null,
      "TestResult": "\n✅ SimplifiedClientAccessEnabled é true (botão Proteger habilitado) e AzureRMSLicensingEnabled é true (base de criptografia ativa).\n\n\n### Status do SimplifiedClientAccess de OME\n\n| Configuração | Valor |\n| :------ | :---- |\n| SimplifiedClientAccessEnabled | True |\n| AzureRMSLicensingEnabled | True |\n| InternalLicensingEnabled | True |\n\n\n**Resumo:**\n\n* Status do botão Proteger: ✅ Habilitado\n\n",
      "TestDescription": "A configuração SimplifiedClientAccessEnabled controla se o botão Proteger aparece no Outlook na web. Este botão permite que os usuários adicionem rapidamente criptografia aos seus emails. Se a configuração não está ativada, os usuários não podem usar o botão Proteger e devem encontrar outras maneiras de criptografar suas mensagens.\n\nPara habilitar essa configuração, AzureRMSLicensingEnabled também deve estar ativa. O serviço de criptografia de Gerenciamento de Direitos do Azure fornece a tecnologia de criptografia necessária para o botão Proteger funcionar.\n\n**Ação de remediação**\n\n- [Gerenciar a exibição do botão Criptografar no Outlook na web](https://learn.microsoft.com/purview/manage-office-365-message-encryption?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#manage-the-display-of-the-encrypt-button-in-outlook-on-the-web)\n",
      "TestImplementationCost": "Low",
      "TestId": "35026",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E3",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Microsoft Purview Message Encryption is configured with simplified client access"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": null,
      "TestResult": "\nO limite do bloqueio inteligente está definido para 10 ou abaixo.\n## Configuração do Bloqueio Inteligente\n\n| Configuração | Valor |\n| :---- | :---- |\n| [Limite de bloqueio](https://entra.microsoft.com/#view/Microsoft_AAD_IAM/AuthenticationMethodsMenuBlade/~/PasswordProtection/fromNav/) | 10 tentativas|\n\n",
      "TestDescription": "Quando o limite do bloqueio inteligente é definido para mais de 10, atores de ameaça podem explorar a configuração para realizar reconhecimento, identificar contas de usuários válidas sem acionar as proteções de bloqueio e estabelecer o acesso inicial sem serem detectados. Uma vez que os atacantes ganham o acesso inicial, eles podem se mover lateralmente pelo ambiente usando a conta comprometida para acessar recursos e escalar privilégios.\n\nO bloqueio inteligente ajuda a impedir que maus atores tentem adivinhar as senhas dos seus usuários ou usem métodos de força bruta para entrar. O bloqueio inteligente reconhece logins provenientes de usuários válidos e os trata de forma diferente dos logins de atacantes e outras fontes desconhecidas. Um limite superior a 10 oferece proteção insuficiente contra ataques automatizados de password spray, tornando mais fácil para os atores de ameaça comprometerem contas enquanto evitam os mecanismos de detecção.\n\n**Ação de remediação**\n\n- [Definir o limite do bloqueio inteligente do Microsoft Entra para 10 ou menos](https://learn.microsoft.com/entra/identity/authentication/howto-password-smart-lockout?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n",
      "TestImplementationCost": "Low",
      "TestId": "21850",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "O limite do bloqueio inteligente está definido para 10 ou menos"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "Proteção de Informações",
      "SkippedReason": null,
      "TestResult": "\n✅ Rótulos padrão estão configurados para pelo menos uma carga de trabalho (Outlook, Teams/OneDrive, SharePoint/Grupos Microsoft 365 ou Power BI) em pelo menos uma política de rótulo de sensibilidade ativa.\n\n\n\n### [Políticas de rótulo habilitadas](https://purview.microsoft.com/informationprotection/labelpolicies)\n| Nome da política | Documentos/Emails | Outlook | Power BI | SharePoint/Grupos | Escopo | Rótulos |\n| :--- | :--- | :--- | :--- | :--- | :--- | :--- |\n| Política Padrão de Classificação | ✅ | ✅ | ✅ | ✅ | Global | 4 |\n\n\n### Resumo\n| Métrica | Contagem |\n| :--- | :--- |\n| Total de políticas de rótulo habilitadas | 1 |\n| Políticas com rótulos padrão | 1 |\n| Padrão de Documentos/Emails | 1 |\n| Padrão do Outlook | 1 |\n| Padrão do Power BI | 1 |\n| Padrão do SharePoint/Grupos | 1 |\n",
      "TestDescription": "Definir um rótulo padrão garante um nível de base de configurações de proteção para todos os itens novos e editados que suportam rótulos de sensibilidade, e para novos contêneres, como Teams. Os usuários podem substitui manualmente o rótulo se necessário, e outros métodos de rotulagem, como rotulagem automática, podem substituir o rótulo padrão por um rótulo com um nível de sensibilidade mais alto. Definir um rótulo de sensibilidade padrão estende seu alcance de rotulagem e reduz a fadiga de decisão para os usuários, garantindo que o conteúdo tenha pelo menos um nível mínimo de proteção.\n\nO conteúdo sem rótulo pode contornar políticas de prevenção de perda de dados (DLP) e outras soluções de proteção que dependem de detecção de rótulo. Se apropriado, defina um rótulo de sensibilidade padrão diferente para documentos sem rótulo e componentes e páginas Loop, emails e convites de reunião, novos contêneres e também um rótulo padrão para conteúdo do Power BI.\n\n**Ação de remediação**\n\n- [Publicar rótulos de sensibilidade criando uma política de rótulo](https://learn.microsoft.com/purview/create-sensitivity-labels?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#publish-sensitivity-labels-by-creating-a-label-policy)\n- [Política de rótulo padrão para Fabric e Power BI](https://learn.microsoft.com/fabric/governance/sensitivity-label-default-label-policy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "35017",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E3",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Um rótulo de sensibilidade padrão está configurado nas políticas de rótulo"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Colaboração externa",
      "SkippedReason": null,
      "TestResult": "\nO autoatendimento para inscrição de convidados via fluxo de usuário está desativado.\n\n",
      "TestDescription": "Quando o autoatendimento para inscrição de convidados (self-service sign-up) está habilitado, atores de ameaça podem explorar isso para estabelecer acesso não autorizado criando contas de convidado legítimas sem a necessidade de aprovação. Essas contas podem ser limitadas a serviços específicos para reduzir a detecção e ignorar controles baseados em convites que validam a legitimidade do usuário externo.\n\nUma vez criadas, essas contas fornecem acesso persistente aos recursos organizacionais. Invasores podem usá-las para reconhecimento, mapeamento de sistemas internos e planejamento de vetores de ataque. Essa persistência permite que os adversários mantenham o acesso mesmo após reinicializações ou trocas de credenciais, enquanto a conta de convidado oferece uma identidade aparentemente legítima que pode evitar o monitoramento de segurança focado em ameaças externas.\n\nAlém disso, identidades de convidados comprometidas podem ser usadas para persistência de credenciais e potencial escalonamento de privilégios, servindo como base para movimentação lateral.\n\n**Ação de correção**\n- [Configurar o autoatendimento para inscrição de convidados com o Microsoft Entra External ID](https://learn.microsoft.com/entra/external-id/external-collaboration-settings-configure?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#to-configure-guest-self-service-sign-up)\n",
      "TestImplementationCost": "Low",
      "TestId": "21823",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "O autoatendimento para inscrição de convidados via fluxo de usuário está desativado"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Colaboração externa",
      "SkippedReason": null,
      "TestResult": "\nIdentidades de convidados inativas foram analisadas.\n\n## Contas de convidados inativas no tenant\n\n| Nome de exibição | UPN | Último login | Data de criação |\n| :----------- | :------------------ | :---------------- | :----------- |\n\n",
      "TestDescription": "Quando identidades de convidados permanecem ativas, mas sem uso por longos períodos, atores de ameaça podem explorar essas contas dormentes como vetores de entrada na organização. Contas de convidados inativas representam uma superfície de ataque significativa porque muitas vezes mantêm permissões de acesso persistentes a recursos, aplicativos e dados, enquanto permanecem sem monitoramento pelas equipes de segurança. Atores de ameaça frequentemente visam essas contas por meio de preenchimento de credenciais (credential stuffing), pulverização de senhas (password spraying) ou comprometendo a organização de origem do convidado para obter acesso lateral. Uma vez que uma conta de convidado inativa é comprometida, os atacantes podem utilizar as concessões de acesso existentes para:\n- Mover-se lateralmente dentro do tenant (tenant).\n- Escalar privilégios por meio de associações a grupos ou permissões de aplicativos.\n- Estabelecer persistência por meio de técnicas como a criação de mais entidades de serviço ou modificação de permissões existentes.\n\nA dormência prolongada dessas contas fornece aos atacantes um tempo de permanência estendido para realizar reconhecimento, exfiltrar dados sensíveis e estabelecer backdoors sem detecção, já que as organizações normalmente concentram os esforços de monitoramento em usuários internos ativos em vez de contas de convidados externos.\n\n**Ação de correção**\n- [Monitorar e limpar contas de convidados obsoletas](https://learn.microsoft.com/entra/identity/users/clean-up-stale-guest-accounts?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21858",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Free",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Identidades de convidados inativas são desativadas ou removidas do tenant"
    },
    {
      "TestPillar": "Data",
      "TestStatus": "Passed",
      "TestCategory": "SharePoint Online",
      "SkippedReason": null,
      "TestResult": "\n✅ A capacidade de rótulo de sensibilidade padrão está habilitada para as bibliotecas de documentos do SharePoint, permitindo rotulagem de linha de base automática.\n\n### Resumo de configuração do SharePoint Online\n\n**Configurações de locatário:**\n* DisableDocumentLibraryDefaultLabeling: False\n\n",
      "TestDescription": "Quando você configura o SharePoint com um rótulo padrão para bibliotecas de documentos, qualquer novo arquivo carregado na biblioteca, ou arquivos existentes editados na biblioteca terão esse rótulo aplicado se ainda não tiverem um rótulo de sensibilidade, ou tiverem um rótulo de sensibilidade mas com prioridade mais baixa. Essa rotulagem baseada em local oferece um nível de proteção de linha de base e uma forma de rotulagem automática sem inspeção de conteúdo. Quando os arquivos não são rotulados, arquivos importantes podem contornar a proteção e permanecer vulneráveis.\n\nEssa configuração é mais adequada para bibliotecas de documentos que contém arquivos com o mesmo nível de sensibilidade. Ela pode ser complementada com políticas de aplicação automática de rótulos que usam inspeção de conteúdo, e rotulagem manual com um rótulo de sensibilidade de prioridade mais alta, se necessário.\n\n**Ação de remediação**\n\n- [Configurar um rótulo de sensibilidade padrão para uma biblioteca de documentos do SharePoint](https://learn.microsoft.com/purview/sensitivity-labels-sharepoint-default-label?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "35008",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Microsoft 365 E5",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Os rótulos de sensibilidade padrão estão configurados para bibliotecas de documentos do SharePoint"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": null,
      "TestResult": "\nO tenant está configurado para impedir que usuários comuns registrem aplicativos.\n\n**[Usuários podem registrar aplicativos](https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserManagementMenuBlade/~/UserSettings/menuId/UserSettings)** → **Não** ✅\n",
      "TestDescription": "Se usuários não privilegiados puderem criar aplicativos e entidades de serviço, essas contas podem ser configuradas incorretamente ou receber mais permissões do que o necessário, criando novos vetores para atacantes. Crimsonais podem explorar essas contas para estabelecer credenciais válidas no ambiente e ignorar alguns controles de segurança.\n\nSe essas contas não privilegiadas receberem erroneamente permissões elevadas de proprietário de aplicativo, os atacantes podem usá-las para escalar seu nível de acesso. Invasores que comprometem contas não privilegiadas podem adicionar suas próprias credenciais ou alterar as permissões associadas aos aplicativos criados por esses usuários para garantir persistência indetectada.\n\nAlém disso, atacantes podem usar entidades de serviço para se misturar a processos e atividades legítimas do sistema. Como as entidades de serviço frequentemente realizam tarefas automatizadas, atividades maliciosas sob essas contas podem não ser sinalizadas como suspeitas.\n\n**Ação de remediação**\n\n- [Bloquear usuários não privilegiados de criar aplicativos](https://learn.microsoft.com/entra/identity/role-based-access-control/delegate-app-roles?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21807",
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "TestTags": [
        "Application"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Criação de novos aplicativos e entidades de serviço é restrita a usuários privilegiados"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Passed",
      "TestCategory": "Controle de acesso",
      "SkippedReason": null,
      "TestResult": "\n## Detalhes da Sessão Privilegiada\n\n| Função | Frequência de Logon | Status |\n| :--- | :--- | :--- |\n\n",
      "TestDescription": "Quando usuários privilegiados têm permissão para manter sessões de logon de longa duração sem reautenticação periódica, atores de ameaça ganham janelas estendidas de oportunidade para explorar credenciais comprometidas ou sequestrar sessões ativas. Uma vez que uma conta privilegiada é comprometida por técnicas como roubo de credenciais, phishing ou fixação de sessão, os tempos limite de sessão estendidos permitem que os invasores mantenham persistência no ambiente por períodos prolongados. Com sessões de longa duração, os atores de ameaça podem realizar movimentação lateral entre sistemas, escalar privilégios e acessar recursos sensíveis sem acionar outro desafio de autenticação. A duração estendida da sessão também aumenta a janela para ataques de sequestro de sessão (session hijacking), onde tokens de sessão podem ser roubados para personificar o usuário privilegiado. Uma vez estabelecido em uma sessão privilegiada, um invasor pode:\n\n- Criar contas de backdoor\n- Modificar políticas de segurança\n- Acessar dados sensíveis\n- Estabelecer mais mecanismos de persistência\n\nA falta de requisitos de reautenticação periódica significa que, mesmo que o comprometimento inicial seja detectado, o ator de ameaça pode continuar operando sem ser notado usando a sessão privilegiada sequestrada até que ela expire naturalmente ou o usuário encerre a sessão manualmente.\n\n**Ação de correção**\n\n- [Saiba mais sobre as políticas de tempo de vida de sessão adaptativas do Acesso Condicional](https://learn.microsoft.com/entra/identity/conditional-access/concept-session-lifetime?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Configure a frequência de logon para usuários privilegiados com políticas de Acesso Condicional](https://learn.microsoft.com/entra/identity/conditional-access/howto-conditional-access-session-lifetime?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21825",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Usuários privilegiados possuem sessões de logon de curta duração"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Este teste verifica se todos os grupos incluídos em políticas de Acesso Condicional pertencem a uma Unidade Administrativa (AU) de gerenciamento restrito. Unidades administrativas de gerenciamento restrito ajudam a proteger grupos sensíveis, limitando quem pode gerenciar sua associação apenas a administradores específicos, reduzindo o risco de modificações não autorizadas que poderiam levar a escalonamento de privilégios.\n\n**Ação de correção**\n- [Unidades administrativas de gerenciamento restrito no Microsoft Entra ID](https://learn.microsoft.com/entra/identity/role-based-access-control/restricted-management-administrative-units?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- Garanta que grupos usados em políticas críticas de Acesso Condicional sejam membros de uma UA de gerenciamento restrito.\n\n",
      "TestImplementationCost": "Low",
      "TestId": "21832",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Todos os grupos em políticas de Acesso Condicional pertencem a uma unidade administrativa de gerenciamento restrito"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.",
      "TestDescription": "Permitir perguntas de segurança como um método de redefinição de senha por autoatendimento (SSPR) enfraquece o processo de redefinição de senha porque as respostas são frequentemente fáceis de adivinhar, reutilizadas em vários sites ou descobertas por meio de inteligência de fontes abertas (OSINT). Agentes de ameaças enumeram ou aplicam phishing em usuários, derivam respostas prováveis (nomes de familiares, escolas e locais) e, em seguida, acionam fluxos de redefinição de senha para contornar métodos mais fortes explorando essa barreira baseada em conhecimento, que é mais fraca. Depois de redefinirem com sucesso uma senha em uma conta que não está protegida por autenticação multifator, eles podem: obter credenciais primárias válidas, estabelecer tokens de sessão e expandir lateralmente registrando métodos de autenticação mais duráveis, adicionar regras de encaminhamento ou exfiltrar dados sensíveis.\n\nEliminar este método remove um elo fraco no processo de redefinição de senha. Algumas organizações podem ter motivos comerciais específicos para deixar as perguntas de segurança ativadas, mas isso não é recomendado.\n\n**Ação de correção**\n\n- [Desabilitar perguntas de segurança na política de SSPR](https://learn.microsoft.com/entra/identity/authentication/concept-authentication-security-questions?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Selecionar métodos de autenticação e opções de registro](https://learn.microsoft.com/entra/identity/authentication/tutorial-enable-sspr?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#select-authentication-methods-and-registration-options)\n",
      "TestImplementationCost": "Medium",
      "TestId": "22072",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Redefinição de senha por autoatendimento não usa perguntas de segurança"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Monitoramento",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Eventos de criação de tenant (tenant) devem ser monitorados e triados para detectar a criação não autorizada de tenants. Usuários com permissões suficientes podem criar novos tenants, que poderiam ser usados para estabelecer ambientes sombra (shadow environments) fora do monitoramento de segurança da sua organização. O roteamento de logs de auditoria para um SIEM e a configuração de alertas para eventos de criação de tenant permitem que as equipes de segurança investiguem e respondam rapidamente a atividades potencialmente maliciosas.\n\n**Ação de remediação**\n\n- [Revisar e restringir permissões para criar tenants](https://learn.microsoft.com/entra/identity/role-based-access-control/permissions-reference?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Transmitir logs de auditoria para um hub de eventos para integração com SIEM](https://learn.microsoft.com/entra/identity/monitoring-health/howto-stream-logs-to-event-hub?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Configurar monitoramento e alertas para eventos de auditoria](https://learn.microsoft.com/entra/identity/monitoring-health/overview-monitoring-health?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21789",
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Eventos de criação de tenant são triados"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.",
      "TestDescription": "O logon único contínuo do Microsoft Entra (Seamless SSO) é um recurso de autenticação herdado projetado para fornecer acesso sem senha para dispositivos ingressados no domínio que não possuem ingresso híbrido no Microsoft Entra ID. O SSO contínuo depende da autenticação Kerberos e é benéfico principalmente para sistemas operacionais mais antigos, como Windows 7 e Windows 8.1, que não oferecem suporte a Tokens de Atualização Primários (PRT). Se esses sistemas herdados não estiverem mais presentes no ambiente, continuar a usar o SSO contínuo introduz complexidade desnecessária e exposição potencial de segurança. Agentes de ameaça podem explorar tickets Kerberos mal configurados ou obsoletos, ou comprometer a conta de computador `AZUREADSSOACC` no Active Directory, que detém a chave de descriptografia Kerberos usada pelo Microsoft Entra ID. Uma vez comprometidos, os atacantes podem personificar usuários, contornar controles de autenticação modernos e ganhar acesso não autorizado aos recursos na nuvem. Desabilitar o SSO contínuo em ambientes onde ele não é mais necessário reduz a superfície de ataque e reforça o uso de mecanismos de autenticação modernos baseados em token que oferecem proteções mais fortes.\n\n**Ação de correção**\n\n- [Revisar como o SSO contínuo funciona](https://learn.microsoft.com/entra/identity/hybrid/connect/how-to-connect-sso-how-it-works?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Desabilitar o SSO contínuo](https://learn.microsoft.com/entra/identity/hybrid/connect/how-to-connect-sso-faq?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#how-can-i-disable-seamless-sso-)\n- [Limpar dispositivos obsoletos no Microsoft Entra ID](https://learn.microsoft.com/entra/identity/devices/manage-stale-devices?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21985",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Desativar o SSO contínuo se não houver uso"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para lançamento futuro.\n",
      "TestDescription": "**Ação de correção**\n\n",
      "TestImplementationCost": "Low",
      "TestId": "21890",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Exigir notificações de redefinição de senha para funções de usuário"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Monitoramento",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Protocolos de autenticação legada, como autenticação básica para SMTP e IMAP, não suportam recursos modernos de segurança como a autenticação multifator (MFA), que é crucial para proteger contra acesso não autorizado. Essa falta de proteção torna as contas que usam esses protocolos vulneráveis a ataques baseados em senha e fornece aos atacantes um meio de obter acesso inicial usando credenciais roubadas ou adivinhadas.\n\nQuando um invasor obtém acesso não autorizado a credenciais, ele pode usá-las para acessar serviços vinculados. Atacantes que ganham acesso via autenticação legada podem fazer alterações no Microsoft Exchange, como configurar regras de encaminhamento de e-mail, permitindo que mantenham acesso contínuo a comunicações sensíveis.\n\n**Ação de remediação**\n- [Protocolos do Exchange podem ser desativados no Exchange Online](https://learn.microsoft.com/exchange/clients-and-mobile-in-exchange-online/disable-basic-authentication-in-exchange-online?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Protocolos de autenticação legada podem ser bloqueados com Acesso Condicional](https://learn.microsoft.com/entra/identity/conditional-access/policy-block-legacy-authentication?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Workbook de logons usando autenticação legada para ajudar a determinar a segurança da desativação](https://learn.microsoft.com/entra/identity/monitoring-health/workbook-legacy-authentication?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21795",
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "High",
      "TestRisk": "Medium",
      "TestTitle": "Nenhuma atividade de logon por autenticação legada"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "**Ação de remediação**\n\n",
      "TestImplementationCost": "Low",
      "TestId": "21983",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Nenhuma recomendação do Entra de prioridade Média ativa encontrada"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "...\n\n**Ação de correção**\n\n",
      "TestImplementationCost": "High",
      "TestId": "21897",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "High",
      "TestRisk": "Medium",
      "TestTitle": "Toda atribuição de aplicativo e associação de grupo é governada"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Acesso privilegiado",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Atores de ameaça que obtêm acesso privilegiado a um tenant podem manipular configurações de identidade, acesso e segurança. Esse tipo de ataque pode resultar em comprometimento de todo o ambiente e perda de controle sobre os ativos organizacionais. Tome medidas para proteger tarefas de gerenciamento de alto impacto associadas a políticas de Acesso Condicional, configurações de acesso entre tenants, exclusões definitivas e locais de rede críticos para a segurança.\n\nAções protegidas permitem que administradores assegurem essas tarefas com controles de segurança extras, como métodos de autenticação mais fortes (MFA sem senha ou MFA resistente a phishing), o uso de dispositivos de Estação de Trabalho de Acesso Privilegiado (PAW) ou tempos limite de sessão mais curtos.\n\n**Ação de correção**\n\n- [Adicionar, testar ou remover ações protegidas no Microsoft Entra ID](https://learn.microsoft.com/entra/identity/role-based-access-control/protected-actions-add?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21831",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": null,
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": null,
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Ações protegidas estão habilitadas para tarefas de gerenciamento de alto impacto"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Este teste verifica se o acesso de convidados (guests) está restrito no diretório.\n\n**Ação de correção**\n\n",
      "TestImplementationCost": "Medium",
      "TestId": "21821",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "O acesso de convidados está restrito"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Este teste verifica o uso do Microsoft Entra Privileged Identity Management (PIM) para o gerenciamento de funções privilegiadas. O uso do PIM permite o acesso \"just-in-time\", reduzindo a exposição contínua de permissões administrativas e mitigando o risco em caso de comprometimento de credenciais.\n\n**Ação de correção**\n\n",
      "TestImplementationCost": "Low",
      "TestId": "21876",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Usar PIM para funções privilegiadas do Microsoft Entra"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para lançamento futuro.\n",
      "TestDescription": "**Ação de correção**\n\n",
      "TestImplementationCost": "Medium",
      "TestId": "21882",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Sem grupos aninhados no PIM para grupos"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Monitoramento",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Atacantes podem obter acesso se a autenticação multifator (MFA) não for aplicada universalmente ou se houver exceções em vigor. Eles podem explorar vulnerabilidades de métodos de MFA mais fracos, como SMS e chamadas telefônicas, por meio de técnicas de engenharia social, como SIM swapping ou phishing para interceptar códigos.\n\nUma vez dentro, os criminosos podem disfarçar suas atividades como ações legítimas de usuários para evitar detecção. A partir daí, podem tentar manipular as configurações de MFA para estabelecer persistência.\n\n**Ação de remediação**\n\n- [Implantar autenticação multifator](https://learn.microsoft.com/entra/identity/authentication/howto-mfa-getstarted?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Implantar autenticação sem senha resistente a phishing](https://learn.microsoft.com/entra/identity/authentication/how-to-plan-prerequisites-phishing-resistant-passwordless-authentication?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Implantar política de Acesso Condicional para exigir MFA resistente a phishing para todos](https://learn.microsoft.com/entra/identity/conditional-access/policy-all-users-mfa-strength?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21800",
      "TestSfiPillar": "Monitorar e detectar ciberameaças",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Toda a atividade de logon utiliza métodos de autenticação fortes"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\r\nPlanejado para lançamento futuro.\r\n",
      "TestDescription": "...\r\n\r\n**Ação de remediação**\r\n\r\n",
      "TestImplementationCost": "Low",
      "TestId": "21899",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Todas as atribuições de função privilegiada têm um destinatário que pode receber notificações"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Os aplicativos de linha de negócio (LOB) e de parceiros devem utilizar a Biblioteca de Autenticação da Microsoft (MSAL) para garantir suporte às funcionalidades modernas de segurança, como Acesso Condicional e autenticação sem senha.\n\n**Ação de remediação**\n- Migre os aplicativos para a MSAL.\n",
      "TestImplementationCost": "High",
      "TestId": "21778",
      "TestSfiPillar": "",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Aplicativos de linha de negócio e parceiros usam MSAL"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Este teste verifica se as funções privilegiadas do Microsoft Entra ID possuem revisões de acesso (Access Reviews) configuradas. As revisões de acesso garantem que apenas os usuários que realmente precisam de permissões administrativas continuem a tê-las, reduzindo a superfície de ataque ao remover acessos desnecessários ou obsoletos.\n\n**Ação de correção**\n\n- [Configurar revisões de acesso para funções do Microsoft Entra](https://learn.microsoft.com/entra/id-governance/access-reviews-overview?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21855",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Funções privilegiadas possuem revisões de acesso"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Este teste verifica se as identidades de convidados (guests) têm seu ciclo de vida gerenciado por meio de revisões de acesso. A colaboração externa é fundamental, mas contas de convidados que não são mais necessárias representam um risco de segurança. As revisões de acesso automatizam o processo de validar se o acesso externo ainda é necessário.\n\n**Ação de correção**\n\n- [Gerenciar o acesso de convidados com as revisões de acesso do Microsoft Entra](https://learn.microsoft.com/entra/id-governance/create-access-review?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21857",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Identidades de convidados têm o ciclo de vida gerenciado com revisões de acesso"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Este teste avalia se as permissões concedidas a parceiros por meio de Privilégios de Administração Delegada Granular (GDAP) seguem o princípio do privilégio mínimo. O GDAP permite que as organizações concedam acesso específico e limitado no tempo aos provedores de serviços, em vez de usar a função de Administrador Global altamente privilegiada e permanente.\n\n**Ação de correção**\n\n- [Revisar e gerenciar relacionamentos GDAP](https://learn.microsoft.com/partner-center/gdap-introduction?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21859",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Privilégio mínimo de administrador GDAP"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Gerenciamento de aplicativos",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Certifique-se de que as versões mais recentes dos Aplicativos Microsoft estejam sendo utilizadas no tenant para garantir as correções de segurança mais recentes.\n\n**Ação de remediação**\n- Atualize os aplicativos para as versões mais recentes.\n",
      "TestImplementationCost": "Medium",
      "TestId": "21779",
      "TestSfiPillar": "",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Usar versões recentes de Aplicativos Microsoft"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Colaboração externa",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Contas de usuários externos são frequentemente usadas para fornecer acesso a parceiros de negócios que pertencem a organizações que têm um relacionamento comercial com a sua organização. Se essas contas forem comprometidas em sua organização de origem, atacantes podem usar as credenciais válidas para obter acesso inicial ao seu ambiente, muitas vezes contornando as defesas tradicionais devido à sua aparente legitimidade.\n\nAtacantes podem ganhar acesso com contas de usuários externos se a autenticação multifator (MFA) não for universalmente imposta ou se houver exceções em vigor. Eles também podem ganhar acesso explorando vulnerabilidades de métodos de MFA mais fracos, como SMS e chamadas telefônicas, usando técnicas de engenharia social, como SIM swapping ou phishing, para interceptar códigos de autenticação.\n\nUma vez que um atacante ganha acesso a uma conta sem MFA ou a uma sessão com métodos de MFA fracos, ele pode tentar manipular as configurações de MFA (por exemplo, registrando métodos controlados pelo atacante) para estabelecer persistência e planejar e executar ataques futuros com base nos privilégios das contas comprometidas.\n\n**Ação de remediação**\n\n- [Implantar uma política de Acesso Condicional para impor a força da autenticação para convidados](https://learn.microsoft.com/entra/identity/conditional-access/policy-guests-mfa-strength?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci).\n- Para organizações com uma relação comercial mais próxima e verificação de suas práticas de MFA, considere implantar configurações de acesso entre tenants para aceitar a reivindicação de MFA.\n   - [Configurar as definições de acesso entre tenants para colaboração B2B](https://learn.microsoft.com/entra/external-id/cross-tenant-access-settings-b2b-collaboration?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#to-change-inbound-trust-settings-for-mfa-and-device-claims)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21851",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestTags": [
        "Aplicativo"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identidade"
      ],
      "TestMinimumLicense": "Free",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "O acesso de convidados é protegido por métodos de autenticação forte"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\r\nPlanejado para lançamento futuro.\r\n",
      "TestDescription": "...\r\n\r\n**Ação de remediação**\r\n\r\n",
      "TestImplementationCost": "High",
      "TestId": "21898",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "Todos os recursos de ciclo de vida de acesso suportados são gerenciados com pacotes de gerenciamento de direitos"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Gerenciamento de credenciais",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para uma versão futura.\n",
      "TestDescription": "Sem o Self-Service Password Reset (SSPR) habilitado, usuários com problemas relacionados à senha devem entrar em contato com o suporte do help desk, o que pode causar atrasos operacionais e perda de produtividade. Também existem vulnerabilidades de segurança potenciais durante o período estendido necessário para redefinições de senha administrativas. Esses atrasos não apenas reduzem a eficiência dos funcionários (especialmente em funções urgentes), mas também aumentam os custos de suporte e sobrecarregam os recursos de TI. Durante esses períodos, atores de ameaça podem explorar contas bloqueadas por meio de ataques de engenharia social direcionados ao pessoal do help desk. Atacantes podem potencialmente convencer a equipe de suporte a redefinir senhas de contas que não controlam legitimamente, permitindo o acesso inicial às credenciais do usuário.\n\nQuando os usuários não conseguem redefinir suas próprias senhas por meio de processos seguros e automatizados, eles frequentemente recorrem a soluções alternativas inseguras. Exemplos incluem o compartilhamento de contas com colegas, o uso de senhas fracas que são mais fáceis de lembrar ou a anotação de senhas em locais descobertos, tudo isso expandindo a superfície de ataque para técnicas de coleta de credenciais. A falta de SSPR força os usuários a manter senhas estáticas por períodos mais longos entre as redefinições administrativas. Esse tipo de política de senha aumenta a probabilidade de que credenciais comprometidas de violações anteriores ou ataques de password spray permaneçam válidas e utilizáveis por atores de ameaça. A ausência de recursos de redefinição de senha controlados pelo usuário também atrasa o tempo de resposta para que os usuários protejam suas contas quando suspeitam de comprometimento. Esse atraso permite que os atores de ameaça mantenham persistência estendida em contas comprometidas para realizar reconhecimento, estabelecer outros métodos de acesso ou exfiltrar dados sensíveis antes que a conta seja eventualmente redefinida por canais administrativos.\n\n**Ação de correção**\n\n- [Habilitar o Self-Service Password Reset (redefinição de senha de autoatendimento)](https://learn.microsoft.com/entra/identity/authentication/tutorial-enable-sspr?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "TestImplementationCost": "Low",
      "TestId": "21870",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": "P1",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "Habilitar redefinição de senha de autoatendimento (SSPR)"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Planned",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "UnderConstruction",
      "TestResult": "\nPlanejado para lançamento futuro.\n",
      "TestDescription": "**Ação de correção**\n\n",
      "TestImplementationCost": "Medium",
      "TestId": "21887",
      "TestSfiPillar": "Proteger identidades e segredos",
      "TestTags": [
        "Identity"
      ],
      "TestSkipped": "UnderConstruction",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestMinimumLicense": null,
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "URIs de redirecionamento registradas devem ter registros DNS e propriedades adequadas"
    },
    {
      "TestPillar": "Identity",
      "TestStatus": "Skipped",
      "TestCategory": "Controle de acesso",
      "SkippedReason": "Este teste é para tenants licenciados para o Entra Workload ID. Consulte [Licenciamento do Entra Workload ID](https://learn.microsoft.com/entra/workload-id/workload-identities-faqs)",
      "TestResult": "\nIgnorado. Este teste é para tenants licenciados para o Entra Workload ID. Consulte [Licenciamento do Entra Workload ID](https://learn.microsoft.com/entra/workload-id/workload-identities-faqs)\n",
      "TestDescription": "Configure políticas de Acesso Condicional baseadas em risco para identidades de carga de trabalho (workload identities) no Microsoft Entra ID para garantir que apenas cargas de trabalho confiáveis e verificadas utilizem recursos confidenciais. Sem essas políticas, atores de ameaças podem comprometer identidades de carga de trabalho com detecção mínima e realizar novos ataques. Sem controles condicionais para detectar atividades anômalas e outros riscos, não há verificação contra operações maliciosas, como falsificação de tokens, acesso a recursos confidenciais e interrupção de cargas de trabalho. A falta de mecanismos automáticos de contenção aumenta o tempo de permanência do invasor (dwell time) e afeta a confidencialidade, integridade e disponibilidade de serviços críticos.\n\n**Ação de correção**\nCrie uma política de Acesso Condicional baseada em risco para identidades de carga de trabalho.\n- [Criar uma política de Acesso Condicional baseada em risco](https://learn.microsoft.com/entra/identity/conditional-access/workload-identity?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#create-a-risk-based-conditional-access-policy)\n",
      "TestImplementationCost": "Low",
      "TestId": 21883,
      "TestSfiPillar": "Acelerar resposta e remediação",
      "TestTags": null,
      "TestSkipped": "NotLicensedEntraWorkloadID",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Workload",
      "TestImpact": "High",
      "TestRisk": "Medium",
      "TestTitle": "Identidades de Carga de Trabalho configuradas com políticas baseadas em risco"
    },
    {
      "TestResult": "\nIgnorado. Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)\n",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestStatus": "Skipped",
      "TestRisk": "Medium",
      "TestCategory": "Prevenção contra Perda de Dados (DLP)",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "EXCHANGE_S_ENTERPRISE"
      ],
      "TestPillar": "Data",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Low",
      "TestSkipped": "NoCompatibleLicenseFound",
      "TestId": "35032",
      "TestTitle": "Adaptive Protection is enabled in data loss prevention policies",
      "TestDescription": "A Proteção Adaptativa garante que as políticas de Prevenção contra Perda de Dados (DLP) sejam adaptadas ao perfil de risco de cada usuário, em vez de aplicar as mesmas regras a todos. Sem a Proteção Adaptativa, as organizações perdem a oportunidade de impedir ameaças internas porque não podem responder a indicadores comportamentais como acesso incomum a dados ou atividades arriscadas.\n\nAo integrar o Gerenciamento de Riscos Internos com DLP, a Proteção Adaptativa usa aprendizado de máquina para identificar os usuários como risco alto, moderado ou baixo. Isso permite que a Proteção Adaptativa aplique automaticamente controles DLP mais rigorosos aos de risco mais alto, enquanto permite mais flexibilidade para outros, uma abordagem que ajuda a proteger dados sensíveis e suporta eficiência operacional.\n\n**Ação de remediação**\n\n- [Ajude a mitigar dinamicamente os riscos com Proteção Adaptativa](https://learn.microsoft.com/purview/insider-risk-management-adaptive-protection?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": "Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"
    },
    {
      "TestResult": "\nIgnorado. Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)\n",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestStatus": "Skipped",
      "TestRisk": "Medium",
      "TestCategory": "Proteção de Informações",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "EXCHANGE_S_ENTERPRISE"
      ],
      "TestPillar": "Data",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "NoCompatibleLicenseFound",
      "TestId": "35023",
      "TestTitle": "OCR is enabled for sensitive information detection",
      "TestDescription": "OCR (reconhecimento ótico de caracteres) estende a detecção de tipo de informação sensível e classificador treinável para imagens no Exchange, SharePoint, OneDrive, Teams e dispositivos de endpoint. Sem OCR, as políticas DLP e as políticas de aplicação automática de rótulos não podem digitalizar o conteúdo baseado em imagem, documentos digitalizados, screenshots e faturas, deixando dados sensíveis em imagens desprotegidos. OCR requer faturamento de pagamento conforme uso do Azure para o Microsoft Syntex e é configurado no nível do locatário.\n\n**Ação de remediação**\n\n- [Saiba mais sobre e configure o reconhecimento ótico de caracteres no Microsoft Purview](https://learn.microsoft.com/purview/ocr-learn-about?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": "Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nNenhuma política de WAF do Application Gateway encontrada anexada aos Application Gateways.\n",
      "TestDescription": "O Web Application Firewall (WAF) do Azure Application Gateway oferece desafio JavaScript como mecanismo de defesa contra bots automatizados e navegadores headless. Esse desafio funciona entregando um pequeno trecho de JavaScript que precisa ser executado pelo navegador cliente para comprovar que a requisição vem de um navegador real com capacidade de executar JavaScript, e nao de um cliente HTTP simples ou bot.\n\nQuando uma requisicao aciona o desafio JavaScript, o WAF responde com uma pagina de desafio contendo codigo JavaScript que o navegador deve executar para obter um cookie de desafio valido. Se o cliente executar o JavaScript com sucesso e retornar com um cookie valido, as requisicoes seguintes passam normalmente ate o cookie expirar. Bots e ferramentas automatizadas que nao conseguem executar JavaScript falham nesse desafio e sao bloqueados de acessar recursos protegidos. Esse mecanismo e especialmente eficaz contra bots de credential stuffing, raspadores web e bots de negacao de servico distribuida que usam bibliotecas HTTP simples sem mecanismo JavaScript.\n\nA configuracao `jsChallengeCookieExpirationInMins` controla por quanto tempo o cookie de desafio permanece valido antes de o cliente precisar concluir outro desafio. O desafio JavaScript oferece um meio-termo entre permitir todo o trafego e bloquear imediatamente bots suspeitos: ele valida a capacidade do navegador sem exigir interacao do usuario, como CAPTCHA. Ao configurar regras personalizadas com a acao de desafio JavaScript, as organizacoes podem proteger endpoints sensiveis, como paginas de login, endpoints de API e recursos de alto valor, contra abuso automatizado, mantendo uma experiencia fluida para usuarios legitimos.\n\n**Ação de remediação**\n\n- [O que é o Azure Web Application Firewall no Azure Application Gateway?](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview) - Visao geral das capacidades do WAF no Application Gateway, incluindo regras e acoes personalizadas\n- [Criar e usar regras personalizadas do Web Application Firewall v2 no Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/create-custom-waf-rules) - Orientacao passo a passo para criar regras personalizadas com diferentes acoes, incluindo desafio JavaScript\n- [Regras personalizadas do Web Application Firewall](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/custom-waf-rules-overview) - Documentacao detalhada dos tipos de regras personalizadas e das acoes disponiveis\n- [Visao geral da protecao contra bots para o WAF do Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/bot-protection-overview) - Visao geral dos recursos de protecao contra bots, incluindo acoes de desafio\n\n",
      "TestImplementationCost": "Low",
      "TestId": 27017,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Azure WAF",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "O desafio JavaScript está habilitado no WAF do Application Gateway"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nNenhuma política de WAF do Azure Front Door anexada ao Azure Front Door encontrada.\n",
      "TestDescription": "O Web Application Firewall (WAF) do Azure Front Door oferece desafio JavaScript como mecanismo de defesa contra bots automatizados e navegadores headless na rede global de borda. O desafio JavaScript funciona ao entregar um pequeno trecho de JavaScript que precisa ser executado pelo navegador cliente para comprovar que a requisicao vem de um navegador real com capacidade de executar JavaScript, e nao de um cliente HTTP simples ou bot.\n\nQuando uma requisicao aciona um desafio JavaScript, o WAF responde com uma pagina de desafio contendo codigo JavaScript que o navegador deve executar para obter um cookie de desafio valido. Bots e ferramentas automatizadas que nao conseguem executar JavaScript falham nesse desafio e sao bloqueados de acessar recursos protegidos.\n\nA configuracao `javascriptChallengeExpirationInMinutes` controla por quanto tempo o cookie de desafio permanece valido antes de o cliente precisar concluir outro desafio. O desafio JavaScript oferece um meio-termo entre permitir todo o trafego e bloquear imediatamente bots suspeitos.\n\nEsta verificacao identifica politicas de WAF do Azure Front Door que estao anexadas a um Azure Front Door e valida se pelo menos uma regra personalizada com acao de desafio JavaScript esta configurada e habilitada.\n\n**Ação de remediação**\n\n- [Web Application Firewall do Azure no Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview)\n- [Regras personalizadas do Web Application Firewall para Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-custom-rules)\n- [Configurar desafio JavaScript para o WAF do Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-tuning#javascript-challenge)\n- [Tutorial: Criar uma politica de Web Application Firewall no Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-create-portal)\n\n",
      "TestImplementationCost": "Low",
      "TestId": 27019,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Azure WAF",
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "O desafio JavaScript está habilitado no WAF do Azure Front Door"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nNenhuma política de WAF do Azure Front Door anexada ao Azure Front Door encontrada.\n",
      "TestDescription": "O Web Application Firewall (WAF) do Azure Front Door oferece desafio CAPTCHA como mecanismo de defesa contra bots sofisticados e ferramentas automatizadas na rede global de borda. O desafio CAPTCHA funciona apresentando aos usuarios um quebra-cabeca visual ou de audio que exige capacidade cognitiva humana para ser resolvido, comprovando que a requisicao vem de uma pessoa real e nao de um bot ou script automatizado. Quando uma requisicao aciona um desafio CAPTCHA, o WAF responde com uma pagina de desafio contendo o quebra-cabeca CAPTCHA que o usuario deve resolver para obter um cookie de desafio valido. Se o usuario concluir o CAPTCHA com sucesso, as requisicoes seguintes passam normalmente ate o cookie expirar. Bots e ferramentas automatizadas que nao conseguem resolver o CAPTCHA sao bloqueados de acessar recursos protegidos na borda antes que o trafego alcance os servidores de origem. O desafio CAPTCHA e mais eficaz do que o desafio JavaScript contra bots avancados que usam navegadores headless com suporte completo a JavaScript, pois exige cognicao humana para ser concluido. A configuracao `captchaExpirationInMinutes` na politica controla por quanto tempo o cookie CAPTCHA permanece valido antes de o usuario precisar concluir outro desafio. O desafio CAPTCHA oferece o nivel mais forte de verificacao interativa disponivel no WAF do Azure Front Door: ele confirma presenca humana por meio de um desafio interativo, em vez de apenas verificar capacidade do navegador como no desafio JavaScript. Ao configurar regras personalizadas com acao de desafio CAPTCHA no WAF do Azure Front Door, as organizacoes podem proteger endpoints altamente sensiveis, como paginas de login, formularios de cadastro, fluxos de redefinicao de senha e paginas de pagamento, contra abuso automatizado, garantindo que apenas humanos verificados acessem esses recursos em localizacoes de borda distribuidas globalmente.\n\n**Ação de remediação**\n\n- [Web Application Firewall do Azure no Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview)\n- [Regras personalizadas do Web Application Firewall para Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-custom-rules)\n- [Tutorial: Criar uma politica de Web Application Firewall no Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-create-portal)\n- [Configurar desafio CAPTCHA para o WAF do Azure Front Door](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/waf-front-door-tuning#captcha-challenge)\n\n",
      "TestImplementationCost": "Low",
      "TestId": 27020,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": "Azure WAF",
      "TestImpact": "Medium",
      "TestRisk": "Medium",
      "TestTitle": "O desafio CAPTCHA está habilitado no WAF do Azure Front Door"
    },
    {
      "TestPillar": "Network",
      "TestStatus": "Skipped",
      "TestCategory": "Segurança de rede do Azure",
      "SkippedReason": "Este teste não se aplica ao ambiente atual.",
      "TestResult": "\nIgnorado. Este teste não se aplica ao ambiente atual.\n",
      "TestDescription": "Quando a proteção Azure DDoS está habilitada para endereços IP públicos, o log de diagnóstico fornece visibilidade crítica sobre padrões de ataque, ações de mitigação e fluxo de tráfego. Sem esses logs, as equipes de segurança perdem observabilidade para entender ataques, validar a mitigação e conduzir análise pós-incidente. A proteção DDoS gera notificações, logs de fluxo de mitigação e relatórios de mitigação, todos essenciais para detecção, investigação, conformidade e ajuste das políticas de proteção.\n\n**Ação de remediação**\n\nConfigure as definições de diagnóstico para IPs públicos protegidos por DDoS\n- [Configurar log de diagnóstico do Azure DDoS Protection](https://learn.microsoft.com/en-us/azure/ddos-protection/diagnostic-logging)\n\nVisualize e configure logs de diagnóstico de DDoS no portal do Azure\n- [Visualizar e configurar logs de diagnóstico de DDoS](https://learn.microsoft.com/en-us/azure/ddos-protection/diagnostic-logging#configure-ddos-diagnostic-logs)\n\nCrie um workspace do Log Analytics para armazenar logs da proteção DDoS\n- [Criar um workspace do Log Analytics](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/quick-create-workspace)\n\nMonitore e analise a telemetria de ataques DDoS\n- [Azure DDoS Protection monitoring and logging](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview#monitoring-and-logging)\n\nView and analyze DDoS logs for incident investigation\n- [Tutorial: View and analyze DDoS logs](https://learn.microsoft.com/en-us/azure/ddos-protection/view-logs)\n\n",
      "TestImplementationCost": "Low",
      "TestId": 26886,
      "TestSfiPillar": "Proteger redes",
      "TestTags": null,
      "TestSkipped": "NotApplicable",
      "TestAppliesTo": null,
      "TestMinimumLicense": [
        "DDoS_Network_Protection",
        "DDoS_IP_Protection"
      ],
      "TestImpact": "Low",
      "TestRisk": "Medium",
      "TestTitle": "O registro de diagnóstico está habilitado para IPs públicos protegidos por DDoS"
    },
    {
      "TestResult": "\nIgnorado. Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)\n",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestStatus": "Skipped",
      "TestRisk": "Medium",
      "TestCategory": "Classificação Avançada",
      "TestImpact": "Medium",
      "TestMinimumLicense": [
        "EXCHANGE_S_ENTERPRISE"
      ],
      "TestPillar": "Data",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "High",
      "TestSkipped": "NoCompatibleLicenseFound",
      "TestId": "35036",
      "TestTitle": "Classificadores treináveis são usados em políticas de prevenção de perda de dados e identificação automática de rótulos",
      "TestDescription": "Os classificadores treináveis são classificadores baseados em aprendizado de máquina que reconhecem o conteúdo por significado e contexto, em vez de padrões fixos. Diferentemente dos tipos de informação sensível que combinam formatos predefinidos, os classificadores treináveis podem identificar conteúdo não estruturado como planos estratégicos, relatórios financeiros ou documentos de RH. O uso de classificadores treináveis em políticas de aplicação automática de rótulos e regras de prevenção de perda de dados (DLP) estende a proteção ao conteúdo comercial sensível que as regras baseadas em padrões não podem capturar de forma confiável.\n\n**Ação de remediação**\n\n- [Saiba mais sobre classificadores treináveis](https://learn.microsoft.com/purview/classifier-learn-about?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Comece com classificadores treináveis](https://learn.microsoft.com/purview/trainable-classifiers-get-started-with?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": "Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"
    },
    {
      "TestResult": "\nIgnorado. Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)\n",
      "TestSfiPillar": "Proteger tenants e sistemas em produção",
      "TestStatus": "Skipped",
      "TestRisk": "Medium",
      "TestCategory": "Proteção de Informações",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "EXCHANGE_S_ENTERPRISE"
      ],
      "TestPillar": "Data",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "NoCompatibleLicenseFound",
      "TestId": "35022",
      "TestTitle": "On-demand scans are configured for sensitive information discovery",
      "TestDescription": "As políticas de aplicação automática de rótulo apenas classificam conteúdo novo e modificado. Os arquivos e emails existentes permanecem não classificados e invisíveis para as políticas DLP que dependem de detecção de rótulo. Varreduras sob demanda permitem que você acionte manualmente a detecção de tipos de informação sensível em locais especificados para descobrir e classificar retroativamente o conteúdo histórico, oferecendo uma visão completa de sua postura de proteção de informações em vez de cobertura prospectiva.\n\n**Ação de remediação**\n\n- [Classificação sob demanda no Microsoft Purview](https://learn.microsoft.com/purview/on-demand-classification?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n",
      "SkippedReason": "Este teste requer uma das seguintes licenças: (\"EXCHANGE_S_ENTERPRISE\"). Certifique-se de que seu tenant possui as licenças adequadas para executar este teste. Consulte [Licenças e Planos de Serviço](https://learn.microsoft.com/entra/identity/users/licensing-service-plan-reference)"
    },
    {
      "TestResult": "\nIgnorado. Este teste não se aplica ao ambiente atual.\n",
      "TestSfiPillar": "Proteger redes",
      "TestStatus": "Skipped",
      "TestRisk": "Medium",
      "TestCategory": "Global Secure Access",
      "TestImpact": "Low",
      "TestMinimumLicense": [
        "Entra_Premium_Internet_Access"
      ],
      "TestPillar": "Network",
      "TestTags": null,
      "TestAppliesTo": null,
      "TestImplementationCost": "Medium",
      "TestSkipped": "NotApplicable",
      "TestId": 27001,
      "TestTitle": "As regras de bypass de inspeção de TLS são revisadas regularmente",
      "TestDescription": "A inspeção de bypass de Transport Layer Security (TLS) cria exceções em que o tráfego criptografado ignora a inspeção profunda de pacotes. Sem revisão periódica, regras temporárias se tornam permanentes, aplicações são desativadas e regras obsoletas permanecem ativas. Agentes mal-intencionados exploram esses canais sem inspeção para ocultar comando e controle, exfiltração de dados e roubo de credenciais via HTTPS.\n\n**Ação de remediação**\n\n- Estabeleça um processo trimestral de revisão das regras de bypass de inspeção TLS, documente a justificativa de negócio de cada regra e remova as que não forem mais necessárias.\n- [Revise e gerencie políticas de inspeção TLS](https://learn.microsoft.com/graph/api/resources/networkaccess-tlsinspectionpolicy?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) no centro de administração Microsoft Entra em **Global Secure Access** > **Secure** > **TLS inspection**.\n- Revise as etapas em [Configurar políticas de inspeção de Transport Layer Security](https://learn.microsoft.com/entra/global-secure-access/how-to-transport-layer-security?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci) para entender como modificar ou remover regras de bypass como parte do processo de revisão.\n",
      "SkippedReason": "Este teste não se aplica ao ambiente atual."
    }
  ],
  "TenantInfo": {
    "OverviewAuthMethodsPrivilegedUsers": {
      "nodes": [
        {
          "target": "Single factor",
          "source": "Users",
          "value": 0
        },
        {
          "target": "Phishable",
          "source": "Users",
          "value": 0
        },
        {
          "target": "Phone",
          "source": "Phishable",
          "value": 0
        },
        {
          "target": "Authenticator",
          "source": "Phishable",
          "value": 0
        },
        {
          "target": "Phish resistant",
          "source": "Users",
          "value": 0
        },
        {
          "target": "Passkey",
          "source": "Phish resistant",
          "value": 0
        },
        {
          "target": "WHfB",
          "source": "Phish resistant",
          "value": 0
        }
      ],
      "description": "Métodos de autenticação mais fortes registrados por usuários privilegiados."
    },
    "OverviewAuthMethodsAllUsers": {
      "nodes": [
        {
          "target": "Single factor",
          "source": "Users",
          "value": 17
        },
        {
          "target": "Phishable",
          "source": "Users",
          "value": 92
        },
        {
          "target": "Phone",
          "source": "Phishable",
          "value": 56
        },
        {
          "target": "Authenticator",
          "source": "Phishable",
          "value": 36
        },
        {
          "target": "Phish resistant",
          "source": "Users",
          "value": 41
        },
        {
          "target": "Passkey",
          "source": "Phish resistant",
          "value": 0
        },
        {
          "target": "WHfB",
          "source": "Phish resistant",
          "value": 41
        }
      ],
      "description": "Métodos de autenticação mais fortes registrados por todos os usuários."
    },
    "ConfigDeviceEnrollmentRestriction": [
      {
        "Platform": "iOS/iPadOS",
        "Priority": "Default",
        "Name": "All users",
        "MDM": "Allowed",
        "MinVer": "",
        "MaxVer": "",
        "PersonallyOwned": "Allowed",
        "BlockedManufacturers": "",
        "Scope": "",
        "AssignedTo": "All devices"
      },
      {
        "Platform": "Windows",
        "Priority": "Default",
        "Name": "All users",
        "MDM": "Allowed",
        "MinVer": "",
        "MaxVer": "",
        "PersonallyOwned": "Allowed",
        "BlockedManufacturers": "",
        "Scope": "",
        "AssignedTo": "All devices"
      },
      {
        "Platform": "Android device administrator",
        "Priority": "Default",
        "Name": "All users",
        "MDM": "Allowed",
        "MinVer": "",
        "MaxVer": "",
        "PersonallyOwned": "Allowed",
        "BlockedManufacturers": "",
        "Scope": "",
        "AssignedTo": "All devices"
      },
      {
        "Platform": "macOS",
        "Priority": "Default",
        "Name": "All users",
        "MDM": "Allowed",
        "MinVer": null,
        "MaxVer": null,
        "PersonallyOwned": "Allowed",
        "BlockedManufacturers": "",
        "Scope": "",
        "AssignedTo": "All devices"
      },
      {
        "Platform": "Android Enterprise (work profile)",
        "Priority": "Default",
        "Name": "All users",
        "MDM": "Allowed",
        "MinVer": "",
        "MaxVer": "",
        "PersonallyOwned": "Allowed",
        "BlockedManufacturers": "",
        "Scope": "",
        "AssignedTo": "All devices"
      }
    ],
    "ConfigWindowsEnrollment": [
      {
        "Type": "MDM",
        "PolicyName": "Microsoft Intune Enrollment",
        "AppliesTo": "None",
        "Groups": "Not Applicable"
      },
      {
        "Type": "MDM",
        "PolicyName": "SentinelOne",
        "AppliesTo": "None",
        "Groups": "Not Applicable"
      },
      {
        "Type": "MDM",
        "PolicyName": "Microsoft Intune",
        "AppliesTo": "All",
        "Groups": "Not Applicable"
      }
    ],
    "OverviewCaDevicesAllUsers": {
      "nodes": [
        {
          "target": "Unmanaged",
          "source": "User sign in",
          "value": 1454
        },
        {
          "target": "Managed",
          "source": "User sign in",
          "value": null
        },
        {
          "target": "Non-compliant",
          "source": "Managed",
          "value": 946
        },
        {
          "target": "Compliant",
          "source": "Managed",
          "value": 4181
        }
      ],
      "description": "Nos últimos 30 dias, 0% das entradas foram de dispositivos em conformidade."
    },
    "DeviceOverview": {
      "DesktopDevicesSummary": {
        "totalDevices": 143.0,
        "nodes": [
          {
            "target": "Windows",
            "source": "Desktop devices",
            "value": 143.0
          },
          {
            "target": "macOS",
            "source": "Desktop devices",
            "value": 0
          },
          {
            "target": "Entra joined",
            "source": "Windows",
            "value": 91.0
          },
          {
            "target": "Entra registered",
            "source": "Windows",
            "value": 52.0
          },
          {
            "target": "Entra hybrid joined",
            "source": "Windows",
            "value": 0
          },
          {
            "target": "Compliant",
            "source": "Entra joined",
            "value": 39.0
          },
          {
            "target": "Non-compliant",
            "source": "Entra joined",
            "value": 52.0
          },
          {
            "target": "Unmanaged",
            "source": "Entra joined",
            "value": 0.0
          },
          {
            "target": "Compliant",
            "source": "Entra hybrid joined",
            "value": null
          },
          {
            "target": "Non-compliant",
            "source": "Entra hybrid joined",
            "value": null
          },
          {
            "target": "Unmanaged",
            "source": "Entra hybrid joined",
            "value": 0
          },
          {
            "target": "Compliant",
            "source": "Entra registered",
            "value": 1.0
          },
          {
            "target": "Non-compliant",
            "source": "Entra registered",
            "value": 7.0
          },
          {
            "target": "Unmanaged",
            "source": "Entra registered",
            "value": 44.0
          },
          {
            "target": "Compliant",
            "source": "macOS",
            "value": 0
          },
          {
            "target": "Non-compliant",
            "source": "macOS",
            "value": 0
          },
          {
            "target": "Unmanaged",
            "source": "macOS",
            "value": 0
          }
        ],
        "description": "Dispositivos desktop (Windows e macOS) por tipo de ingresso e status de conformidade.",
        "entrajoined": 91.0,
        "entrareigstered": 52.0,
        "entrahybridjoined": 0
      },
      "ManagedDevices": {
        "@odata.context": "https://graph.microsoft.com/beta/$metadata#microsoft.graph.managedDeviceOverview",
        "id": "00f3858d-ee81-4987-804b-3982060997c9",
        "enrolledDeviceCount": 48,
        "mdmEnrolledCount": 0,
        "dualEnrolledDeviceCount": 47,
        "managedDeviceModelsAndManufacturers": null,
        "lastModifiedDateTime": "2026-05-07T22:48:29.0041436Z",
        "deviceOperatingSystemSummary": {
          "androidCount": 0,
          "iosCount": 0,
          "macOSCount": 0,
          "windowsMobileCount": 0,
          "windowsCount": 48,
          "unknownCount": 0,
          "androidDedicatedCount": 0,
          "androidDeviceAdminCount": 0,
          "androidFullyManagedCount": 0,
          "androidWorkProfileCount": 0,
          "androidCorporateWorkProfileCount": 0,
          "configMgrDeviceCount": 0,
          "aospUserlessCount": 0,
          "aospUserAssociatedCount": 0,
          "linuxCount": 0,
          "chromeOSCount": 0
        },
        "deviceExchangeAccessStateSummary": {
          "allowedDeviceCount": 0,
          "blockedDeviceCount": 0,
          "quarantinedDeviceCount": 0,
          "unknownDeviceCount": 0,
          "unavailableDeviceCount": 48
        },
        "desktopCount": 48,
        "mobileCount": 0,
        "totalCount": 48
      },
      "MobileSummary": {
        "totalDevices": 1.0,
        "description": "Dispositivos móveis por status de conformidade.",
        "nodes": [
          {
            "target": "Android",
            "source": "Mobile devices",
            "value": 1.0
          },
          {
            "target": "iOS",
            "source": "Mobile devices",
            "value": 0
          },
          {
            "target": "Android (Company)",
            "source": "Android",
            "value": 0
          },
          {
            "target": "Android (Personal)",
            "source": "Android",
            "value": 1.0
          },
          {
            "target": "iOS (Company)",
            "source": "iOS",
            "value": 0
          },
          {
            "target": "iOS (Personal)",
            "source": "iOS",
            "value": 0
          },
          {
            "target": "Compliant",
            "source": "Android (Company)",
            "value": null
          },
          {
            "target": "Non-compliant",
            "source": "Android (Company)",
            "value": null
          },
          {
            "target": "Compliant",
            "source": "Android (Personal)",
            "value": null
          },
          {
            "target": "Non-compliant",
            "source": "Android (Personal)",
            "value": 1.0
          },
          {
            "target": "Compliant",
            "source": "iOS (Company)",
            "value": null
          },
          {
            "target": "Non-compliant",
            "source": "iOS (Company)",
            "value": null
          },
          {
            "target": "Compliant",
            "source": "iOS (Personal)",
            "value": null
          },
          {
            "target": "Non-compliant",
            "source": "iOS (Personal)",
            "value": null
          }
        ]
      },
      "DeviceCompliance": {
        "@odata.context": "https://graph.microsoft.com/beta/$metadata#deviceManagement/deviceCompliancePolicyDeviceStateSummary/$entity",
        "inGracePeriodCount": 0,
        "configManagerCount": 0,
        "id": "565b870a-482c-4416-a171-8344e10c258f",
        "unknownDeviceCount": 1,
        "notApplicableDeviceCount": 0,
        "compliantDeviceCount": 40,
        "remediatedDeviceCount": 0,
        "nonCompliantDeviceCount": 7,
        "errorDeviceCount": 0,
        "conflictDeviceCount": 0
      },
      "DeviceOwnership": {
        "personalCount": 5,
        "corporateCount": 56
      }
    },
    "OverviewCaMfaAllUsers": {
      "nodes": [
        {
          "target": "No CA applied",
          "source": "User sign in",
          "value": 2760
        },
        {
          "target": "CA applied",
          "source": "User sign in",
          "value": 3821
        },
        {
          "target": "No MFA",
          "source": "CA applied",
          "value": 5
        },
        {
          "target": "MFA",
          "source": "CA applied",
          "value": 3816
        }
      ],
      "description": "Nos últimos 30 dias, 58% das entradas foram protegidas por políticas de acesso condicional que exigem multifator."
    },
    "TenantOverview": {
      "UserCount": 149,
      "GuestCount": 16,
      "GroupCount": 297,
      "ApplicationCount": 40,
      "DeviceCount": 176,
      "ManagedDeviceCount": 48
    },
    "ConfigDeviceAppProtectionPolicies": [
      {
        "Platform": null,
        "Name": null,
        "AppsPublic": "",
        "AppsCustom": "",
        "BackupOrgDataToICloudOrGoogle": "",
        "SendOrgDataToOtherApps": "",
        "AppsToExempt": "",
        "SaveCopiesOfOrgData": "",
        "AllowUserToSaveCopiesToSelectedServices": "",
        "DataProtectionTransferTelecommunicationDataTo": null,
        "DataProtectionReceiveDataFromOtherApps": null,
        "DataProtectionOpenDataIntoOrgDocuments": "",
        "DataProtectionAllowUsersToOpenDataFromSelectedServices": "",
        "DataProtectionRestrictCutCopyBetweenOtherApps": "",
        "DataProtectionCutCopyCharacterLimitForAnyApp": "",
        "DataProtectionEncryptOrgData": "",
        "DataProtectionSyncPolicyManagedAppDataWithNativeApps": "",
        "DataProtectionPrintingOrgData": "",
        "DataProtectionRestrictWebContentTransferWithOtherApps": "",
        "DataProtectionOrgDataNotifications": "",
        "ConditionalLaunchAppMaxPinAttempts": "",
        "ConditionalLaunchAppOfflineGracePeriodBlockAccess": "",
        "ConditionalLaunchAppOfflineGracePeriodWipeData": "",
        "ConditionalLaunchAppDisabedAccount": "",
        "ConditionalLaunchAppMinAppVersion": "",
        "ConditionalLaunchDeviceRootedJailbrokenDevices": null,
        "ConditionalLaunchDevicePrimaryMtdService": "",
        "ConditionalLaunchDeviceMaxAllowedDeviceThreatLevel": "",
        "ConditionalLaunchDeviceMinOsVersion": "",
        "ConditionalLaunchDeviceMaxOsVersion": "",
        "Scope": "",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      },
      {
        "Platform": null,
        "Name": null,
        "AppsPublic": "",
        "AppsCustom": "",
        "BackupOrgDataToICloudOrGoogle": "",
        "SendOrgDataToOtherApps": "",
        "AppsToExempt": "",
        "SaveCopiesOfOrgData": "",
        "AllowUserToSaveCopiesToSelectedServices": "",
        "DataProtectionTransferTelecommunicationDataTo": null,
        "DataProtectionReceiveDataFromOtherApps": null,
        "DataProtectionOpenDataIntoOrgDocuments": "",
        "DataProtectionAllowUsersToOpenDataFromSelectedServices": "",
        "DataProtectionRestrictCutCopyBetweenOtherApps": "",
        "DataProtectionCutCopyCharacterLimitForAnyApp": "",
        "DataProtectionEncryptOrgData": "",
        "DataProtectionSyncPolicyManagedAppDataWithNativeApps": "",
        "DataProtectionPrintingOrgData": "",
        "DataProtectionRestrictWebContentTransferWithOtherApps": "",
        "DataProtectionOrgDataNotifications": "",
        "ConditionalLaunchAppMaxPinAttempts": "",
        "ConditionalLaunchAppOfflineGracePeriodBlockAccess": "",
        "ConditionalLaunchAppOfflineGracePeriodWipeData": "",
        "ConditionalLaunchAppDisabedAccount": "",
        "ConditionalLaunchAppMinAppVersion": "",
        "ConditionalLaunchDeviceRootedJailbrokenDevices": null,
        "ConditionalLaunchDevicePrimaryMtdService": "",
        "ConditionalLaunchDeviceMaxAllowedDeviceThreatLevel": "",
        "ConditionalLaunchDeviceMinOsVersion": "",
        "ConditionalLaunchDeviceMaxOsVersion": "",
        "Scope": "",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      },
      {
        "Platform": null,
        "Name": null,
        "AppsPublic": "",
        "AppsCustom": "",
        "BackupOrgDataToICloudOrGoogle": "",
        "SendOrgDataToOtherApps": "",
        "AppsToExempt": "",
        "SaveCopiesOfOrgData": "",
        "AllowUserToSaveCopiesToSelectedServices": "",
        "DataProtectionTransferTelecommunicationDataTo": null,
        "DataProtectionReceiveDataFromOtherApps": null,
        "DataProtectionOpenDataIntoOrgDocuments": "",
        "DataProtectionAllowUsersToOpenDataFromSelectedServices": "",
        "DataProtectionRestrictCutCopyBetweenOtherApps": "",
        "DataProtectionCutCopyCharacterLimitForAnyApp": "",
        "DataProtectionEncryptOrgData": "",
        "DataProtectionSyncPolicyManagedAppDataWithNativeApps": "",
        "DataProtectionPrintingOrgData": "",
        "DataProtectionRestrictWebContentTransferWithOtherApps": "",
        "DataProtectionOrgDataNotifications": "",
        "ConditionalLaunchAppMaxPinAttempts": "",
        "ConditionalLaunchAppOfflineGracePeriodBlockAccess": "",
        "ConditionalLaunchAppOfflineGracePeriodWipeData": "",
        "ConditionalLaunchAppDisabedAccount": "",
        "ConditionalLaunchAppMinAppVersion": "",
        "ConditionalLaunchDeviceRootedJailbrokenDevices": null,
        "ConditionalLaunchDevicePrimaryMtdService": "",
        "ConditionalLaunchDeviceMaxAllowedDeviceThreatLevel": "",
        "ConditionalLaunchDeviceMinOsVersion": "",
        "ConditionalLaunchDeviceMaxOsVersion": "",
        "Scope": "",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      }
    ],
    "ConfigDeviceCompliancePolicies": [
      {
        "Platform": "Windows 10 and later",
        "PolicyName": "Device Name Compliance Policy",
        "DefenderForEndPoint": "",
        "MinOsVersion": null,
        "MaxOsVersion": null,
        "RequirePswd": "",
        "MinPswdLength": null,
        "PasswordType": null,
        "PswdExpiryDays": null,
        "CountOfPreviousPswdToBlock": null,
        "RequireEncryption": "",
        "RootedJailbrokenDevices": "Not Applicable",
        "MaxDeviceThreatLevel": "Not Applicable",
        "RequireFirewall": "",
        "MaxInactivityMin": null,
        "ActionForNoncomplianceDaysPushNotification": "",
        "ActionForNoncomplianceDaysSendEmail": "Immediately",
        "ActionForNoncomplianceDaysRemoteLock": "",
        "ActionForNoncomplianceDaysBlock": "Immediately",
        "ActionForNoncomplianceDaysRetire": "",
        "Scope": "Default",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      },
      {
        "Platform": "Windows 10 and later",
        "PolicyName": "BitLocker Compliance Policy for Windows",
        "DefenderForEndPoint": "",
        "MinOsVersion": null,
        "MaxOsVersion": null,
        "RequirePswd": "",
        "MinPswdLength": null,
        "PasswordType": null,
        "PswdExpiryDays": null,
        "CountOfPreviousPswdToBlock": null,
        "RequireEncryption": "",
        "RootedJailbrokenDevices": "Not Applicable",
        "MaxDeviceThreatLevel": "Not Applicable",
        "RequireFirewall": "",
        "MaxInactivityMin": null,
        "ActionForNoncomplianceDaysPushNotification": "",
        "ActionForNoncomplianceDaysSendEmail": "Immediately",
        "ActionForNoncomplianceDaysRemoteLock": "",
        "ActionForNoncomplianceDaysBlock": "Immediately",
        "ActionForNoncomplianceDaysRetire": "",
        "Scope": "Default",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      },
      {
        "Platform": "Windows 10 and later",
        "PolicyName": "[Old] Sentinel Agent Discovery Verification Policy",
        "DefenderForEndPoint": "",
        "MinOsVersion": null,
        "MaxOsVersion": null,
        "RequirePswd": "",
        "MinPswdLength": null,
        "PasswordType": null,
        "PswdExpiryDays": null,
        "CountOfPreviousPswdToBlock": null,
        "RequireEncryption": "",
        "RootedJailbrokenDevices": "Not Applicable",
        "MaxDeviceThreatLevel": "Not Applicable",
        "RequireFirewall": "",
        "MaxInactivityMin": null,
        "ActionForNoncomplianceDaysPushNotification": "",
        "ActionForNoncomplianceDaysSendEmail": "",
        "ActionForNoncomplianceDaysRemoteLock": "",
        "ActionForNoncomplianceDaysBlock": "Immediately",
        "ActionForNoncomplianceDaysRetire": "",
        "Scope": "Default",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      }
    ]
  },
  "EndOfJson": "EndOfJson"
}
