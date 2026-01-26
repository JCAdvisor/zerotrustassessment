# Review Unenrolled BYOD MAM in the Context of Intune App Protection Policies

**Implementation Effort:** Medium – IT and Security Operations teams must configure app protection policies, define app configuration profiles, and maintain ongoing support for BYOD users.

**User Impact:** High – A large number of non-privileged users with personal (BYOD) Dispositivos must follow new app usage rules, install or update apps, and adapt to new access and security behaviors.

## Overview

Mobile Gerenciamento de Aplicativos (MAM) for unenrolled Dispositivos in Microsoft Intune allows organizations to protect corporate data at the app level without requiring full Dispositivos enrollment. This is especially useful in Bring Your Own Dispositivos (BYOD) scenarios, where users access corporate resources like Outlook or Teams from personal Dispositivos.

MAM uses **App Protection Policies (APP)** to enforce controls such as:
- Requiring PINs to access apps
- Blocking copy/paste between managed and unmanaged apps
- Encrypting app data at rest

These policies apply only to supported apps and do not affect the rest of the Dispositivos. MAM is available on Android and iOS/iPadOS.

When deployed across a large workforce, especially in hybrid or remote environments, the user impact becomes high. Many users must:
- Install the Company Portal or Microsoft Intune app
- Accept new terms of use
- Learn how to use protected apps differently (e.g., no copy/paste)
- Contact support for setup or troubleshooting

This approach supports the Zero Trust principle of **least privilege access** by ensuring that only approved apps can access corporate data, and that data remains protected even if the Dispositivos is unmanaged. Without MAM, organizations risk data leakage from personal Dispositivos that access sensitive content without any policy enforcement.

## Reference

- [Mobile Gerenciamento de Aplicativos (MAM) for unenrolled Dispositivos in Microsoft Intune](https://learn.microsoft.com/en-us/intune/intune-service/fundamentals/deployment-guide-enrollment-mamwe)  
- [App protection policies overview - Microsoft Intune](https://learn.microsoft.com/en-us/intune/intune-service/apps/app-protection-policy)  
- [MAM and Android Enterprise personally owned Dispositivos](https://learn.microsoft.com/en-us/intune/intune-service/apps/android-deployment-scenarios-app-protection-work-profiles)
