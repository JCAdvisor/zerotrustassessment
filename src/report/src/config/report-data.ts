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
  TestMinimumLicense?: string | null;
  TestSfiPillar: string | null;
  TestPillar: string | null;
  SkippedReason: string | null;
  TestResult: string;
  TestSkipped: string;
  TestStatus: string;
  TestTags: string[] | null;
  TestId: string;
  TestDescription: string;
}

export const reportData: ZeroTrustAssessmentReport = {
  "ExecutedAt": "2025-10-21T08:07:56.502298+11:00",
  "TenantId": "0817c655-a853-4d8f-9723-3a333b5b9235",
  "TenantName": "Pora Inc.",
  "Domain": "elapora.com",
  "Account": "merill@elapora.com",
  "CurrentVersion": "0.18.0",
  "LatestVersion": "0.18.0",
  "TestResultSummary": {
    "IdentityPassed": 0,
    "IdentityTotal": 4,
    "DevicesPassed": 1,
    "DevicesTotal": 1,
    "DataPassed": 0,
    "DataTotal": 0
  },
  "Tests": [
    {
      "TestId": "24546",
      "TestResult": "\nWindows Automatic Enrollment está ativado.\n\n\n## Windows Automatic Enrollment\n\n| Nome da Política | Escopo |\n| :---------- | :--------- |\n| [Microsoft Intune](https://intune.microsoft.com/#view/Microsoft_AAD_IAM/MdmConfiguration.ReactView/appId/0000000a-0000-0000-c000-000000000000/appName/Microsoft%20Intune) | ✅ Grupos Específicos |\n\n\n\n",
      "TestDescription": "Se o registro automático do Windows não estiver habilitado, dispositivos não gerenciados podem se tornar um ponto de entrada para invasores. Agentes de ameaça podem usar esses dispositivos para acessar dados corporativos, contornar políticas de conformidade e introduzir vulnerabilidades no ambiente. Dispositivos ingressados no Microsoft Entra sem estarem registrados no Intune criam lacunas de visibilidade e controle. Esses endpoints não gerenciados podem expor fragilidades no sistema operacional ou em aplicativos mal configurados que invasores podem explorar.\n\nA aplicação do registro automático garante que os dispositivos Windows sejam gerenciados desde o início, permitindo uma aplicação consistente de políticas e maior visibilidade sobre a conformidade. Isso dá suporte ao modelo de Zero Trust ao garantir que todos os dispositivos sejam verificados, monitorados e governados por controles de segurança.\n\nHabilite o registro automático para dispositivos Windows usando o Intune e o Microsoft Entra para garantir que todos os dispositivos ingressados no domínio ou no Entra sejam gerenciados:\n\n**Ação de Remediação**\n\nHabilite o registro automático para dispositivos Windows usando o Intune e o Microsoft Entra para garantir que todos os dispositivos ingressados no domínio ou no Entra estejam gerenciados.  \n- [Habilitar o registro automático do Windows](https://learn.microsoft.com/intune/intune-service/enrollment/windows-enroll?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enable-windows-automatic-enrollment)\n\nPara mais informações, consulte:  \n- [Guia de implementação - Provisionamento para Windows](https://learn.microsoft.com/intune/intune-service/fundamentals/deployment-guide-enroll?tabs=work-profile%2Ccorporate-owned-apple%2Cautomatic-enrollment&wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#enrollment-for-windows)\n",
      "TestSkipped": "",
      "TestTitle": "O registro automático de dispositivos Windows é aplicado para eliminar riscos provenientes de endpoints não gerenciados.",
      "TestStatus": "Aprovado",
      "TestTags": null,
      "TestRisk": "High",
      "TestPillar": "Devices",
      "TestImpact": "Baixo",
      "TestSfiPillar": "Proteger os locatários e isolar os sistemas de produção",
      "TestCategory": "Devices",
      "TestImplementationCost": "Low",
      "SkippedReason": null,
      "TestAppliesTo": null
    },
    {
      "TestTitle": "As políticas de Acesso Condicional para Estações de Trabalho de Acesso Privilegiado (Privileged Access Workstations – PAW) são configuradas",
      "TestDescription": "Se as ativações de funções privilegiadas não forem restritas a Estações de Trabalho de Acesso Privilegiado (PAWs) dedicadas, agentes de ameaça podem explorar dispositivos de endpoint comprometidos para realizar ataques de escalonamento de privilégios a partir de estações de trabalho não gerenciadas ou fora de conformidade. Estações de trabalho padrão de produtividade frequentemente contêm vetores de ataque, como navegação web irrestrita, clientes de e-mail vulneráveis a phishing e aplicativos instalados localmente com possíveis vulnerabilidades. Quando administradores ativam funções privilegiadas a partir dessas estações, agentes de ameaça que obtêm acesso inicial por meio de malware, exploits de navegador ou engenharia social podem então usar credenciais privilegiadas armazenadas localmente em cache ou sequestrar sessões autenticadas existentes para escalar seus privilégios. As ativações de funções privilegiadas concedem amplos direitos administrativos em todo o Microsoft Entra ID e serviços conectados, permitindo que atacantes criem novas contas administrativas, modifiquem políticas de segurança, acessem dados sensíveis em todos os recursos organizacionais e implantem malware ou backdoors em todo o ambiente para estabelecer acesso persistente. Esse movimento lateral de um endpoint comprometido para recursos privilegiados na nuvem representa um caminho crítico de ataque que ignora muitos controles de segurança tradicionais. O Acesso Privilegiado aparenta ser legítimo quando se origina de uma sessão autenticada de um administrador.\n\nSe esta verificação for aprovada, seu tenant possui uma política de Acesso Condicional que restringe o acesso a funções privilegiadas a dispositivos PAW, mas esse não é o único controle necessário para habilitar totalmente uma solução de PAW. Também é necessário configurar uma política de configuração e conformidade de dispositivos no Intune e um filtro de dispositivos.\n\n**Ação de Remediação**\n\n- [Implantar uma solução de estação de trabalho de Acesso Privilegiado](https://learn.microsoft.com/security/privileged-access-workstations/privileged-access-deployment?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n    - Fornece orientações para configurar o Acesso Condicional e as políticas de conformidade e configuração de Dispositivos do Intune.\n- [Configurar filtros de Dispositivos no Acesso Condicional para restringir o Acesso Privilegiado](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-condition-filters-for-Dispositivos?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)",
      "TestImplementationCost": "High",
      "TestId": "21830",
      "TestSfiPillar": "Proteger sistemas de engenharia",
      "SkippedReason": null,
      "TestSkipped": "",
      "TestMinimumLicense": "P1",
      "TestPillar": "Identity",
      "TestCategory": "Gerenciamento de Aplicativos",
      "TestStatus": "Failed",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestResult": "\nNenhuma política de Acesso Condicional encontrada que restrinja funções privilegiadas a dispositivos PAW.\n\n**❌ Foram encontradas 0 política(s) com controle de dispositivos em conformidade direcionadas a todas as funções privilegiadas.**\n\n\n**❌ Foram encontradas 0 política(s) com o filtro de Dispositivos PAW/SAW direcionadas a todas as funções privilegiadas**\n\n\n",
      "TestTags": [
        "Identity"
      ]
    },
    {
      "TestTitle": "As permissões para criar novos locatários estão limitadas à função de Criador de Locatário.",
      "TestDescription": "Um ator de ameaça ou um funcionário bem-intencionado, mas desinformado, pode criar um novo locatário (tenant) do Microsoft Entra se não houver restrições implementadas. Por padrão, o usuário que cria um locatário recebe automaticamente a função de Administrador Global. Sem os controles adequados, essa ação fragmenta o perímetro de identidade ao criar um locatário fora da governança e visibilidade da organização. Isso introduz riscos por meio de uma plataforma de identidade paralela (shadow identity) que pode ser explorada para emissão de tokens, personificação de marca, phishing de consentimento ou infraestrutura de estágio persistente. Como o locatário não autorizado pode não estar vinculado aos planos administrativos ou de auditoria da empresa, as defesas tradicionais ficam cegas à sua criação, atividade e potencial uso indevido.\n\n**Ação de remediação**\n\nAtive a configuração Restringir a criação de locatários por usuários não administradores. Para usuários que precisam da capacidade de criar locatários, atribua a eles a função de Criador de Locatário. Você também pode revisar os eventos de criação de locatários nos logs de auditoria do Microsoft Entra.\n\n- [Restringir as permissões padrão de usuários membros](https://learn.microsoft.com/entra/fundamentals/users-default-permissions?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#restrict-member-users-default-permissions)\n- [Atribuir a função de Criador de Locatário](https://learn.microsoft.com/entra/identity/role-based-access-control/permissions-reference?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#tenant-creator)\n- [Revisar eventos de criação de locatários](https://learn.microsoft.com/entra/identity/Auditoria-health/reference-audit-activities?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#core-directory).",
      "TestImplementationCost": "Medium",
      "TestId": "21787",
      "TestSfiPillar": "Proteger os locatários e isolar os sistemas de produção",
      "SkippedReason": null,
      "TestSkipped": "",
      "TestMinimumLicense": "Free",
      "TestPillar": "Identity",
      "TestCategory": "Acesso Privilegiado",
      "TestStatus": "Failed",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestImpact": "Medium",
      "TestRisk": "High",
      "TestResult": "\nUsuários não privilegiados têm permissão para criar locatários.\n\n\n\n",
      "TestTags": [
        "Identity"
      ]
    },
    {
      "TestTitle": "As funções internas (built-in) privilegiadas do Microsoft Entra são alvo de políticas de Acesso Condicional para impor métodos resistentes a phishing.",
      "TestDescription": "Sem métodos de autenticação resistentes a phishing, os usuários privilegiados ficam mais vulneráveis a ataques de phishing. Esses tipos de ataques enganam os usuários para que revelem suas credenciais e concedam acesso não autorizado a invasores. Se forem usados métodos de autenticação que não são resistentes a phishing, os invasores podem interceptar credenciais e tokens por meio de métodos como ataques de adversário no meio (AiTM), comprometendo a segurança da conta privilegiada.\n\nUma vez que uma conta ou sessão privilegiada é comprometida devido a métodos de autenticação fracos, os invasores podem manipular a conta para manter acesso de longo prazo, criar outros backdoors ou modificar permissões de usuários. Os invasores também podem usar a conta privilegiada comprometida para escalar seu acesso ainda mais, ganhando potencialmente o controle sobre sistemas mais sensíveis.\n\n**Ação de Remediação**\n\n- [Introdução à implantação de autenticação sem senha resistente a phishing](https://learn.microsoft.com/entra/identity/authentication/how-to-plan-prerequisites-phishing-resistant-passwordless-authentication?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Garantir que contas privilegiadas registrem e utilizem métodos resistentes a phishing](https://learn.microsoft.com/entra/identity/authentication/concept-authentication-strengths?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#authentication-strengths)\n- [Implantar uma política de Acesso Condicional voltada para contas privilegiadas que exija credenciais resistentes a phishing](https://learn.microsoft.com/entra/identity/conditional-access/policy-admin-phish-resistant-mfa?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci)\n- [Monitorar a atividade dos métodos de autenticação](https://learn.microsoft.com/entra/identity/Auditoria-health/concept-usage-insights-report?wt.mc_id=zerotrustrecommendations_automation_content_cnl_csasci#authentication-methods-activity)\n",
      "TestImplementationCost": "Medium",
      "TestId": "21783",
      "TestSfiPillar": "Proteger identidades e credenciais",
      "SkippedReason": null,
      "TestSkipped": "",
      "TestMinimumLicense": "P1",
      "TestPillar": "Identity",
      "TestCategory": "Controle de Acesso",
      "TestStatus": "Failed",
      "TestAppliesTo": [
        "Identity"
      ],
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestResult": "\nForam encontradas funções que não possuem políticas para exigir credenciais resistentes a phishing.\n\n\n\n## Políticas de Acesso Condicional com políticas de autenticação resistentes a phishing \n\nNenhuma política de Acesso Condicional foi encontrada com políticas de força de autenticação resistentes a phishing.\n\n\n\n## Privileged Roles\n\nForam encontradas 0 de 28 funções privilegiadas protegidas por autenticação resistente a phishing.\n\n| Role Name | Phishing resistance enforced |\n| :--- | :---: |\n| Application Administrator | ❌ |\n| Application Developer | ❌ |\n| Attribute Provisioning Administrator | ❌ |\n| Attribute Provisioning Reader | ❌ |\n| Authentication Administrator | ❌ |\n| Authentication Extensibility Administrator | ❌ |\n| B2C IEF Keyset Administrator | ❌ |\n| Cloud Application Administrator | ❌ |\n| Cloud Dispositivos Administrator | ❌ |\n| Conditional Access Administrator | ❌ |\n| Directory Writers | ❌ |\n| Domain Name Administrator | ❌ |\n| External Identity Provider Administrator | ❌ |\n| Global Administrator | ❌ |\n| Global Reader | ❌ |\n| Helpdesk Administrator | ❌ |\n| Hybrid Identity Administrator | ❌ |\n| Intune Administrator | ❌ |\n| Lifecycle Workflows Administrator | ❌ |\n| Partner Tier1 Support | ❌ |\n| Partner Tier2 Support | ❌ |\n| Password Administrator | ❌ |\n| Privileged Authentication Administrator | ❌ |\n| Privileged Role Administrator | ❌ |\n| Security Administrator | ❌ |\n| Security Operator | ❌ |\n| Security Reader | ❌ |\n| User Administrator | ❌ |\n## Políticas de Força de Autenticação\n\nFoi encontrada 1 política personalizada de força de autenticação resistente a phishing.\n\n  - [Phishing-resistant MFA](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/AuthStrengths/fromNav/)\n\n\n",
      "TestTags": [
        "AccessControl",
        "Authentication"
      ]
    },
    {
      "TestTitle": "Habilitar método de autenticação por chave de segurança",
      "TestDescription": "A habilitação do método de autenticação por chave de segurança no Microsoft Entra ID mitiga o risco de roubo de credenciais e acesso não autorizado ao exigir uma autenticação resistente a phishing e baseada em hardware. Se essa prática recomendada não for seguida, atores de ameaças podem explorar senhas fracas ou reutilizadas, realizar ataques de credential stuffing e escalar privilégios por meio de contas comprometidas. A cadeia de ataque (kill chain) começa com o reconhecimento, onde os invasores coletam informações sobre contas de usuários, seguido pela colheita de credenciais através de várias técnicas, como engenharia social ou violações de dados. Os invasores então ganham acesso inicial usando credenciais roubadas, movem-se lateralmente dentro da rede explorando relações de confiança e estabelecem persistência para manter o acesso de longo prazo. Sem a autenticação baseada em hardware, como as chaves de segurança FIDO2, os invasores podem burlar defesas básicas de senha e a autenticação multifator, aumentando a probabilidade de exfiltração de dados e interrupção dos negócios. As chaves de segurança fornecem prova criptográfica de identidade que está vinculada a dispositivos específicos e não pode ser replicada ou sofrer phishing, quebrando efetivamente a cadeia de ataque no estágio de acesso inicial. \n\n**Ação de Remediação**\n\n* [Habilitar o método de autenticação por chave de acesso (FIDO2)](https://learn.microsoft.com/en-us/entra/identity/authentication/how-to-enable-passkey-fido2#enable-passkey-fido2-authentication-method)\n\n* [Gerenciamento de política de método de autenticação](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods-manage)\n\n",
      "TestImplementationCost": "Low",
      "TestId": "21838",
      "TestSfiPillar": "Proteger identidades e credenciais",
      "SkippedReason": null,
      "TestSkipped": "",
      "TestMinimumLicense": "Free",
      "TestPillar": "Identity",
      "TestCategory": "Controle de Acesso",
      "TestStatus": "Failed",
      "TestAppliesTo": null,
      "TestImpact": "Low",
      "TestRisk": "High",
      "TestResult": "\nO método de autenticação por chave de segurança não está habilitado; os usuários não podem registrar chaves de segurança FIDO2 para autenticação forte.\n\n\n## Configurações de autenticação de chave de segurança FIDO2\n\n❌ **FIDO2 authentication method**\n- Status: Disabled\n- Include targets: All users\n- Exclude targets: None\n\n\n",
      "TestTags": null
    }
  ],
  "TenantInfo": {
    "ConfigWindowsEnrollment": [
      {
        "Type": "MDM",
        "PolicyName": "Microsoft Intune",
        "AppliesTo": "Selected",
        "Groups": "All active users"
      },
      {
        "Type": "MDM",
        "PolicyName": "Microsoft Intune Enrollment",
        "AppliesTo": "None",
        "Groups": "Not Applicable"
      }
    ],
    "ConfigDeviceCompliancePolicies": [
      {
        "Platform": "iOS/iPadOS",
        "PolicyName": "My iOS policy",
        "DefenderForEndPoint": "Clear",
        "MinOsVersion": "4",
        "MaxOsVersion": "5",
        "RequirePswd": true,
        "MinPswdLength": 5,
        "PasswordType": "Alphanumeric",
        "PswdExpiryDays": 34,
        "CountOfPreviousPswdToBlock": 5,
        "RequireEncryption": "Not Applicable",
        "RootedJailbrokenDevices": "Blocked",
        "MaxDeviceThreatLevel": "Secured",
        "RequireFirewall": "Not Applicable",
        "MaxInactivityMin": 0,
        "ActionForNoncomplianceDaysPushNotification": 2.0,
        "ActionForNoncomplianceDaysSendEmail": 2.0,
        "ActionForNoncomplianceDaysRemoteLock": 2.0,
        "ActionForNoncomplianceDaysBlock": 1.0,
        "ActionForNoncomplianceDaysRetire": 3.0,
        "Scope": "Default",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      },
      {
        "Platform": "Android Enterprise (Personal)",
        "PolicyName": "My android personally-owned",
        "DefenderForEndPoint": "",
        "MinOsVersion": "3",
        "MaxOsVersion": "4",
        "RequirePswd": "Yes",
        "MinPswdLength": 5,
        "PasswordType": null,
        "PswdExpiryDays": 200,
        "CountOfPreviousPswdToBlock": 12,
        "RequireEncryption": "Yes",
        "RootedJailbrokenDevices": "Blocked",
        "MaxDeviceThreatLevel": "Low",
        "RequireFirewall": "Not Applicable",
        "MaxInactivityMin": 5,
        "ActionForNoncomplianceDaysPushNotification": "",
        "ActionForNoncomplianceDaysSendEmail": "",
        "ActionForNoncomplianceDaysRemoteLock": 2.0,
        "ActionForNoncomplianceDaysBlock": 2.0,
        "ActionForNoncomplianceDaysRetire": "Immediately",
        "Scope": "Default",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      },
      {
        "Platform": "Windows 10 and later",
        "PolicyName": "Min Windows Compliance",
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
      },
      {
        "Platform": "macOS",
        "PolicyName": "My macOS policy",
        "DefenderForEndPoint": "",
        "MinOsVersion": "1",
        "MaxOsVersion": "2",
        "RequirePswd": "Yes",
        "MinPswdLength": 6,
        "PasswordType": null,
        "PswdExpiryDays": null,
        "CountOfPreviousPswdToBlock": null,
        "RequireEncryption": "Yes",
        "RootedJailbrokenDevices": "Not Applicable",
        "MaxDeviceThreatLevel": "",
        "RequireFirewall": "Yes",
        "MaxInactivityMin": 15,
        "ActionForNoncomplianceDaysPushNotification": "",
        "ActionForNoncomplianceDaysSendEmail": "",
        "ActionForNoncomplianceDaysRemoteLock": 4.0,
        "ActionForNoncomplianceDaysBlock": "Immediately",
        "ActionForNoncomplianceDaysRetire": 6.0,
        "Scope": "Default",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      },
      {
        "Platform": "Windows 10 and later",
        "PolicyName": "My Windows policy",
        "DefenderForEndPoint": "High",
        "MinOsVersion": null,
        "MaxOsVersion": null,
        "RequirePswd": "Yes",
        "MinPswdLength": 5,
        "PasswordType": null,
        "PswdExpiryDays": 22,
        "CountOfPreviousPswdToBlock": 6,
        "RequireEncryption": "Yes",
        "RootedJailbrokenDevices": "Not Applicable",
        "MaxDeviceThreatLevel": "Not Applicable",
        "RequireFirewall": "Yes",
        "MaxInactivityMin": 1,
        "ActionForNoncomplianceDaysPushNotification": "",
        "ActionForNoncomplianceDaysSendEmail": "",
        "ActionForNoncomplianceDaysRemoteLock": "",
        "ActionForNoncomplianceDaysBlock": "Immediately",
        "ActionForNoncomplianceDaysRetire": "Immediately",
        "Scope": "Default",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      },
      {
        "Platform": "Android device administrator",
        "PolicyName": "My android device policy",
        "DefenderForEndPoint": "Clear",
        "MinOsVersion": "2",
        "MaxOsVersion": "3",
        "RequirePswd": "Yes",
        "MinPswdLength": null,
        "PasswordType": null,
        "PswdExpiryDays": null,
        "CountOfPreviousPswdToBlock": null,
        "RequireEncryption": "Yes",
        "RootedJailbrokenDevices": "Blocked",
        "MaxDeviceThreatLevel": "Low",
        "RequireFirewall": "Not Applicable",
        "MaxInactivityMin": 1,
        "ActionForNoncomplianceDaysPushNotification": 12.0,
        "ActionForNoncomplianceDaysSendEmail": "",
        "ActionForNoncomplianceDaysRemoteLock": "Immediately",
        "ActionForNoncomplianceDaysBlock": "Immediately",
        "ActionForNoncomplianceDaysRetire": "Immediately",
        "Scope": "Default",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      },
      {
        "Platform": "Android Enterprise (Corp)",
        "PolicyName": "My android enterprise policy",
        "DefenderForEndPoint": "Low",
        "MinOsVersion": null,
        "MaxOsVersion": null,
        "RequirePswd": "Yes",
        "MinPswdLength": 4,
        "PasswordType": null,
        "PswdExpiryDays": 200,
        "CountOfPreviousPswdToBlock": null,
        "RequireEncryption": "Yes",
        "RootedJailbrokenDevices": "",
        "MaxDeviceThreatLevel": "",
        "RequireFirewall": "Not Applicable",
        "MaxInactivityMin": 15,
        "ActionForNoncomplianceDaysPushNotification": "",
        "ActionForNoncomplianceDaysSendEmail": "",
        "ActionForNoncomplianceDaysRemoteLock": "",
        "ActionForNoncomplianceDaysBlock": "Immediately",
        "ActionForNoncomplianceDaysRetire": "",
        "Scope": "Default",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      },
      {
        "Platform": "Windows 8.1 and later",
        "PolicyName": "My Windows 8 policy",
        "DefenderForEndPoint": "Not Applicable",
        "MinOsVersion": "1.1",
        "MaxOsVersion": "2.1",
        "RequirePswd": "Yes",
        "MinPswdLength": null,
        "PasswordType": null,
        "PswdExpiryDays": 22,
        "CountOfPreviousPswdToBlock": 10,
        "RequireEncryption": "Yes",
        "RootedJailbrokenDevices": "Not Applicable",
        "MaxDeviceThreatLevel": "Not Applicable",
        "RequireFirewall": "Not Applicable",
        "MaxInactivityMin": 240,
        "ActionForNoncomplianceDaysPushNotification": "",
        "ActionForNoncomplianceDaysSendEmail": "",
        "ActionForNoncomplianceDaysRemoteLock": "",
        "ActionForNoncomplianceDaysBlock": "Immediately",
        "ActionForNoncomplianceDaysRetire": 4.0,
        "Scope": "Default",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      },
      {
        "Platform": "Android (AOSP)",
        "PolicyName": "My android aosp policy",
        "DefenderForEndPoint": "Not Applicable",
        "MinOsVersion": "1",
        "MaxOsVersion": "2",
        "RequirePswd": "Yes",
        "MinPswdLength": 16,
        "PasswordType": null,
        "PswdExpiryDays": "Not Applicable",
        "CountOfPreviousPswdToBlock": "Not Applicable",
        "RequireEncryption": "Yes",
        "RootedJailbrokenDevices": "Blocked",
        "MaxDeviceThreatLevel": "Not Applicable",
        "RequireFirewall": "Not Applicable",
        "MaxInactivityMin": 480,
        "ActionForNoncomplianceDaysPushNotification": "",
        "ActionForNoncomplianceDaysSendEmail": "",
        "ActionForNoncomplianceDaysRemoteLock": "Immediately",
        "ActionForNoncomplianceDaysBlock": "Immediately",
        "ActionForNoncomplianceDaysRetire": "",
        "Scope": "Default",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      }
    ],
    "ConfigDeviceAppProtectionPolicies": [
      {
        "Platform": "Android",
        "Name": "Android Policy",
        "AppsPublic": "Cortana, Microsoft Dynamics 365 for phones, Field Service (Dynamics 365), Dynamics 365 Sales, Microsoft Dynamics 365 for tablets, Microsoft Invoicing, Microsoft Edge, Power Automate, Azure Information Protection, Microsoft Launcher, Microsoft Lists, Microsoft Kaizala, Microsoft Power Apps, Microsoft Excel, Skype for Business, Microsoft 365 (Office) (China), Microsoft Office (HL), Microsoft 365 Copilot, Microsoft Lens, Microsoft OneNote, Microsoft Outlook, Microsoft PowerPoint, Microsoft Word, Microsoft Planner, Microsoft Power BI, Microsoft Defender Endpoint, Microsoft SharePoint, Microsoft OneDrive, Microsoft Teams, Microsoft To-Do, Microsoft Whiteboard, Work Folders, Microsoft 365 Admin, Viva Engage, Microsoft StaffHub",
        "AppsCustom": "com.microsoft.d365.fs.mobile, com.microsoft.ramobile, com.microsoft.stream, com.oracle.java.pdfviewer",
        "BackupOrgDataToICloudOrGoogle": "Allow",
        "SendOrgDataToOtherApps": "Policy managed apps",
        "AppsToExempt": "Trello:app:trello",
        "SaveCopiesOfOrgData": "Block",
        "AllowUserToSaveCopiesToSelectedServices": "Box, Local storage, OneDrive for Business, SharePoint, Photo library",
        "DataProtectionTransferTelecommunicationDataTo": "A specific dialer app",
        "DataProtectionReceiveDataFromOtherApps": "Policy managed apps",
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
        "ConditionalLaunchDeviceRootedJailbrokenDevices": "Block access",
        "ConditionalLaunchDevicePrimaryMtdService": "",
        "ConditionalLaunchDeviceMaxAllowedDeviceThreatLevel": "",
        "ConditionalLaunchDeviceMinOsVersion": "",
        "ConditionalLaunchDeviceMaxOsVersion": "",
        "Scope": "Default",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      },
      {
        "Platform": "iOS/iPadOS",
        "Name": "iOS Policy",
        "AppsPublic": "Adobe Acrobat Reader, Cortana, Microsoft Dynamics 365, Microsoft Invoicing, Microsoft Dynamics 365 for phones, Field Service (Dynamics 365), Dynamics 365 Sales, Skype for Business, Microsoft Kaizala, Microsoft Power Apps, Microsoft Edge, Microsoft 365 Admin, Microsoft Excel, Microsoft Outlook, Microsoft PowerPoint, Microsoft Word, Microsoft Lens, Microsoft 365 Copilot, Microsoft OneNote, Microsoft Planner, Microsoft Power BI, Power Automate, Azure Information Protection, Microsoft Defender Endpoint, Microsoft SharePoint, Microsoft StaffHub, Microsoft OneDrive, Microsoft Teams, Microsoft Lists, Microsoft To-Do, Microsoft Whiteboard, Work Folders, Vera for Intune, Viva Engage",
        "AppsCustom": "com.microsoft.d365.fs.mobile, com.microsoft.ramobile, com.microsoft.stream, com.microsoft.visio, my.merill.net",
        "BackupOrgDataToICloudOrGoogle": "Block",
        "SendOrgDataToOtherApps": "Policy managed apps with OS sharing",
        "AppsToExempt": "",
        "SaveCopiesOfOrgData": "Allow",
        "AllowUserToSaveCopiesToSelectedServices": "Box, Local storage, OneDrive for Business, SharePoint, Photo library",
        "DataProtectionTransferTelecommunicationDataTo": "A specific dialer app",
        "DataProtectionReceiveDataFromOtherApps": "None",
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
        "ConditionalLaunchDeviceRootedJailbrokenDevices": "Wipe data",
        "ConditionalLaunchDevicePrimaryMtdService": "",
        "ConditionalLaunchDeviceMaxAllowedDeviceThreatLevel": "",
        "ConditionalLaunchDeviceMinOsVersion": "",
        "ConditionalLaunchDeviceMaxOsVersion": "",
        "Scope": "Default",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      },
      {
        "Platform": "Windows",
        "Name": "Windows Info Protect",
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
        "Scope": "Default",
        "IncludedGroups": "",
        "ExcludedGroups": ""
      }
    ],
    "ConfigDeviceEnrollmentRestriction": [
      {
        "Platform": "iOS/iPadOS",
        "Priority": 2,
        "Name": "iOS Restriction 2",
        "MDM": "Blocked",
        "MinVer": null,
        "MaxVer": null,
        "PersonallyOwned": "Allowed",
        "BlockedManufacturers": null,
        "Scope": "Default",
        "AssignedTo": "All users"
      },
      {
        "Platform": "Android Enterprise (work profile)",
        "Priority": 1,
        "Name": "Andy Penn",
        "MDM": "Allowed",
        "MinVer": "5.0",
        "MaxVer": "5.1.1",
        "PersonallyOwned": "Allowed",
        "BlockedManufacturers": "Samsung",
        "Scope": "Biscope, Default",
        "AssignedTo": "aad-conditional-access-allow-legacy-auth"
      },
      {
        "Platform": "Android device administrator",
        "Priority": 1,
        "Name": "Andy Penn",
        "MDM": "Allowed",
        "MinVer": "5.0",
        "MaxVer": "6.0",
        "PersonallyOwned": "Allowed",
        "BlockedManufacturers": "Samsung",
        "Scope": "Biscope, Default",
        "AssignedTo": "aad-conditional-access-allow-legacy-auth"
      },
      {
        "Platform": "iOS/iPadOS",
        "Priority": 1,
        "Name": "iOS Restriction",
        "MDM": "Allowed",
        "MinVer": "9.0",
        "MaxVer": "10.0",
        "PersonallyOwned": "Blocked",
        "BlockedManufacturers": null,
        "Scope": "Default",
        "AssignedTo": "aad-conditional-access-excluded, Avanade Users"
      },
      {
        "Platform": "Windows",
        "Priority": 1,
        "Name": "Win1",
        "MDM": "Allowed",
        "MinVer": null,
        "MaxVer": null,
        "PersonallyOwned": "Allowed",
        "BlockedManufacturers": null,
        "Scope": "Biscope, Default",
        "AssignedTo": "All users"
      },
      {
        "Platform": "iOS/iPadOS",
        "Priority": "Default",
        "Name": "All users",
        "MDM": "Allowed",
        "MinVer": "9.0",
        "MaxVer": "10.0",
        "PersonallyOwned": "Blocked",
        "BlockedManufacturers": null,
        "Scope": "",
        "AssignedTo": "All devices"
      },
      {
        "Platform": "Windows",
        "Priority": "Default",
        "Name": "All users",
        "MDM": "Allowed",
        "MinVer": "10.0",
        "MaxVer": "11.0",
        "PersonallyOwned": "Blocked",
        "BlockedManufacturers": null,
        "Scope": "",
        "AssignedTo": "All devices"
      },
      {
        "Platform": "Android device administrator",
        "Priority": "Default",
        "Name": "All users",
        "MDM": "Allowed",
        "MinVer": "7.0",
        "MaxVer": "8.0",
        "PersonallyOwned": "Blocked",
        "BlockedManufacturers": "Samsung",
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
        "PersonallyOwned": "Blocked",
        "BlockedManufacturers": null,
        "Scope": "",
        "AssignedTo": "All devices"
      },
      {
        "Platform": "Android Enterprise (work profile)",
        "Priority": "Default",
        "Name": "All users",
        "MDM": "Allowed",
        "MinVer": "5.0",
        "MaxVer": "6.0",
        "PersonallyOwned": "Blocked",
        "BlockedManufacturers": "Samsung",
        "Scope": "",
        "AssignedTo": "All devices"
      }
    ],
    "DeviceOverview": {
      "DesktopDevicesSummary": {
        "nodes": [
          {
            "source": "Desktop devices",
            "target": "Windows",
            "value": 11.0
          },
          {
            "source": "Desktop devices",
            "target": "macOS",
            "value": 2.0
          },
          {
            "source": "Windows",
            "target": "Entra joined",
            "value": 8.0
          },
          {
            "source": "Windows",
            "target": "Entra hybrid joined",
            "value": 0
          },
          {
            "source": "Windows",
            "target": "Entra registered",
            "value": 3.0
          },
          {
            "source": "macOS",
            "target": "Compliant",
            "value": 1.0
          },
          {
            "source": "macOS",
            "target": "Non-compliant",
            "value": 1.0
          },
          {
            "source": "macOS",
            "target": "Unmanaged",
            "value": null
          },
          {
            "source": "Entra joined",
            "target": "Compliant",
            "value": null
          },
          {
            "source": "Entra joined",
            "target": "Non-compliant",
            "value": 4.0
          },
          {
            "source": "Entra joined",
            "target": "Unmanaged",
            "value": null
          },
          {
            "source": "Entra hybrid joined",
            "target": "Compliant",
            "value": null
          },
          {
            "source": "Entra hybrid joined",
            "target": "Non-compliant",
            "value": null
          },
          {
            "source": "Entra hybrid joined",
            "target": "Unmanaged",
            "value": null
          },
          {
            "source": "Entra registered",
            "target": "Compliant",
            "value": null
          },
          {
            "source": "Entra registered",
            "target": "Non-compliant",
            "value": null
          },
          {
            "source": "Entra registered",
            "target": "Unmanaged",
            "value": null
          }
        ],
        "entrahybridjoined": 0,
        "description": "Desktop devices (Windows and macOS) by join type and compliance status.",
        "totalDevices": 13.0,
        "entrajoined": 9.0,
        "entrareigstered": 4.0
      },
      "MobileSummary": {
        "nodes": [
          {
            "source": "Mobile devices",
            "target": "Android",
            "value": 40
          },
          {
            "source": "Mobile devices",
            "target": "iOS",
            "value": 53
          },
          {
            "source": "Android",
            "target": "Android (Company)",
            "value": 20
          },
          {
            "source": "Android",
            "target": "Android (Personal)",
            "value": 20
          },
          {
            "source": "iOS",
            "target": "iOS (Company)",
            "value": 28
          },
          {
            "source": "iOS",
            "target": "iOS (Personal)",
            "value": 25
          },
          {
            "source": "Android (Company)",
            "target": "Compliant",
            "value": 15
          },
          {
            "source": "Android (Company)",
            "target": "Non-compliant",
            "value": 5
          },
          {
            "source": "Android (Personal)",
            "target": "Compliant",
            "value": 8
          },
          {
            "source": "Android (Personal)",
            "target": "Non-compliant",
            "value": 12
          },
          {
            "source": "iOS (Company)",
            "target": "Compliant",
            "value": 25
          },
          {
            "source": "iOS (Company)",
            "target": "Non-compliant",
            "value": 3
          },
          {
            "source": "iOS (Personal)",
            "target": "Compliant",
            "value": 18
          },
          {
            "source": "iOS (Personal)",
            "target": "Non-compliant",
            "value": 7
          }
        ],
        "description": "Mobile devices by compliance status.",
        "totalDevices": 93
      },
      "ManagedDevices": {
        "@odata.context": "https://graph.microsoft.com/beta/$metadata#microsoft.graph.managedDeviceOverview",
        "id": "4a197fb2-79de-4f46-89e3-bd318ca08984",
        "enrolledDeviceCount": 0,
        "mdmEnrolledCount": 0,
        "dualEnrolledDeviceCount": 0,
        "managedDeviceModelsAndManufacturers": null,
        "lastModifiedDateTime": "2025-10-20T21:07:52.4781572Z",
        "deviceOperatingSystemSummary": {
          "androidCount": 300,
          "iosCount": 340,
          "macOSCount": 10,
          "windowsMobileCount": 0,
          "windowsCount": 1000,
          "unknownCount": 0,
          "androidDedicatedCount": 0,
          "androidDeviceAdminCount": 0,
          "androidFullyManagedCount": 0,
          "androidWorkProfileCount": 0,
          "androidCorporateWorkProfileCount": 0,
          "configMgrDeviceCount": 0,
          "aospUserlessCount": 0,
          "aospUserAssociatedCount": 0,
          "linuxCount": 20,
          "chromeOSCount": 0
        },
        "deviceExchangeAccessStateSummary": {
          "allowedDeviceCount": 0,
          "blockedDeviceCount": 0,
          "quarantinedDeviceCount": 0,
          "unknownDeviceCount": 0,
          "unavailableDeviceCount": 0
        },
        "desktopCount": 20,
        "mobileCount": 30,
        "totalCount": 50
      },
      "DeviceCompliance": {
        "@odata.context": "https://graph.microsoft.com/beta/$metadata#deviceManagement/deviceCompliancePolicyDeviceStateSummary/$entity",
        "inGracePeriodCount": 0,
        "configManagerCount": 0,
        "id": "afaac8a4-5f74-40f5-a213-51af45bedc36",
        "unknownDeviceCount": 0,
        "notApplicableDeviceCount": 0,
        "compliantDeviceCount": 10,
        "remediatedDeviceCount": 0,
        "nonCompliantDeviceCount": 10,
        "errorDeviceCount": 0,
        "conflictDeviceCount": 0
      },
      "DeviceOwnership": {
        "corporateCount": 20,
        "personalCount": 10
      }
    },
    "TenantOverview": {
      "UserCount": 71000,
      "GuestCount": 12,
      "GroupCount": 1890,
      "ApplicationCount": 120,
      "DeviceCount": 20,
      "ManagedDeviceCount": 43
    }
  },
  "EndOfJson": "EndOfJson"
}
