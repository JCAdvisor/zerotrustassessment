# MAM Overview

**Implementation Effort:** Medium – IT and Security Operations teams need to define app protection policies, configure supported apps, and maintain ongoing policy updates and user support.

**User Impact:** Medium – A subset of users, especially those using personal (BYOD) Dispositivos, must follow new app usage rules and may need to install or update apps to comply with protection policies.

## Overview

Mobile Gerenciamento de Aplicativos (MAM) in Microsoft Intune allows organizations to manage and protect corporate data within apps, without requiring full Dispositivos enrollment. This is especially useful in Bring Your Own Dispositivos (BYOD) scenarios, where users access corporate resources like Outlook or Microsoft Teams from personal Dispositivos. MAM works by applying **App Protection Policies (APP)** that control how data is accessed and shared within managed apps—for example, blocking copy/paste, requiring PINs, or encrypting app data.

MAM is supported across Android, iOS/iPadOS, and Windows platforms. It can be used on:
- Personal Dispositivos (unenrolled)
- Organization-owned Dispositivos needing extra app-level security
- Dispositivos managed by other MDM providers

Administrators configure apps in the Intune admin center, then apply protection policies. Users can access apps via the Company Portal or directly from app stores, depending on how the organization distributes them.

MAM supports the Zero Trust principle of **least privilege access** by ensuring that only approved apps can access corporate data, and that data remains protected even on unmanaged Dispositivos. Without MAM, organizations risk data leakage, especially when users access sensitive content from personal Dispositivos without any policy enforcement [1](https://learn.microsoft.com/en-us/intune/intune-service/fundamentals/deployment-guide-enrollment-mamwe).

## Reference

- [Mobile Gerenciamento de Aplicativos (MAM) for unenrolled Dispositivos in Microsoft Intune](https://learn.microsoft.com/en-us/intune/intune-service/fundamentals/deployment-guide-enrollment-mamwe)  
- [Frequently asked questions about MAM and app protection](https://learn.microsoft.com/en-us/intune/intune-service/apps/mam-faq)  
- [What is app management in Microsoft Intune?](https://learn.microsoft.com/en-us/intune/intune-service/apps/app-management)
