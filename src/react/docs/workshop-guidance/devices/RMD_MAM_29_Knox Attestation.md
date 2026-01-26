# Knox Attestation

**Implementation Effort:** Low  
Knox Attestation is a built-in option for supported Samsung Dispositivos and can be enabled through a simple policy configuration in Intune.

**User Impact:** Low  
Users are not affected unless their Dispositivos fails the attestation check, in which case access to corporate data is silently blocked or wiped.

## Overview

**Knox Attestation** is a hardware-backed integrity check available on Samsung Dispositivos that verifies whether the Dispositivos has been tampered with or rooted. In Microsoft Intune, administrators can configure App Protection Policies (APP) to require Knox Attestation as a condition for accessing corporate data. If the Dispositivos fails the attestation check, Intune can automatically wipe organizational data from the app.

This setting is particularly useful in high-security environments where Dispositivos integrity is critical. It ensures that only healthy, unmodified Samsung Dispositivos can access sensitive data, even in BYOD scenarios. Microsoft recommends setting the Knox Attestation policy action to **"Wipe data"** to ensure corporate data is removed if the Dispositivos fails the check.

This feature supports the **Zero Trust principle of "Assume Breach"** by enforcing hardware-level verification of Dispositivos health before granting access to corporate resources.

## Reference

- [Step 3. Apply high data protection | Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-365/solutions/apps-protect-step-3?view=o365-worldwide)
- [Data protection framework using app protection policies - Microsoft Intune](https://learn.microsoft.com/en-us/intune/intune-service/apps/app-protection-framework)
- [App protection policies overview - Microsoft Intune](https://learn.microsoft.com/en-us/intune/intune-service/apps/app-protection-policy)
