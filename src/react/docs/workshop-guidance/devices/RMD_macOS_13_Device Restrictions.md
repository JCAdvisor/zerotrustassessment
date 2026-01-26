# Dispositivos Restrictions

**Last Updated:** May 2025  
**Implementation Effort:** Medium – Creating and deploying restriction profiles requires IT teams to plan, test, and manage policies across different macOS enrollment types.  
**User Impact:** Medium – Some restrictions directly affect user experience, such as disabling Safari AutoFill, camera access, or Game Center features, which may require user communication or support.

## Introduction

Dispositivos restrictions in Intune allow administrators to configure and enforce security, privacy, and usability settings on managed macOS Dispositivos. These settings help reduce the attack surface, prevent user tampering, and ensure that Dispositivos operate within organizational policy. This section helps macOS administrators evaluate their current Dispositivos restriction configurations and align them with Zero Trust principles.

This guidance applies to corporate-owned macOS Dispositivos enrolled in Intune.

## Why This Matters

- **Reduces the attack surface** by disabling unnecessary features or services.
- **Prevents user tampering** with critical system settings.
- **Supports Zero Trust** by enforcing consistent, policy-driven Dispositivos behavior.
- **Improves compliance** by aligning Dispositivos behavior with organizational security standards.
- **Enhances user safety** by limiting access to risky or unmanaged features.

## Key Considerations

### Configuration Scope

- Dispositivos restrictions are applied using **Dispositivos configuration profiles** in Intune.
- These profiles can be scoped using **Azure AD groups** to target specific Dispositivos types or user roles.

### Zero Trust-Aligned Restriction Settings

The following settings are not explicitly recommended by Microsoft but are widely considered best practices for Zero Trust environments. Each setting includes the security impact of not configuring it:

- **Disable AirDrop** – Prevents peer-to-peer file sharing and data exfiltration.
- **Disable iCloud Drive and iCloud Keychain** – Prevents syncing sensitive data and credentials to unmanaged cloud services.
- **Restrict System Preference Panes** – Prevents users from modifying security, network, or privacy settings.
- **Disable Screen Sharing and Remote Login (SSH)** – Reduces remote attack surface.
- **Block External Drives** – Prevents data exfiltration via USB or Thunderbolt storage.
- **Disable Bluetooth** (if not required) – Reduces wireless attack surface.
- **Block App Store Access** – Prevents installation of unmanaged or unapproved apps.
- **Disable Camera and Microphone** (if not needed) – Reduces surveillance and privacy risks.
- **Disable Safari AutoFill** – Prevents credential leakage via browser autofill.

### Additional Security Controls (Settings Catalog)

- **Gatekeeper**  
  Ensures only apps from the App Store or identified developers can be opened.  
  Managed via custom configuration profile (`com.apple.security`) or script.  
  [Apple Gatekeeper Overview](https://support.apple.com/guide/security/gatekeeper-overview-secb005f6c51/web)

- **Firewall**  
  Blocks incoming connections to unauthorized apps.  
  Managed via configuration profile (`com.apple.alf`) or script.  
  [Apple Firewall Overview](https://support.apple.com/guide/security/firewall-overview-secb7f9dd73a/web)

- **System Integrity Protection (SIP)**  
  Prevents unauthorized modification of system files and processes.  
  Enforced via Intune compliance policy.

- **Password Policy**  
  Enforce complexity, length, and timeout.  
  Configured via Settings Catalog > Password.

- **Disable Remote Login (SSH)**  
  Prevents remote shell access.  
  Configured via Settings Catalog > Remote Access.

### Auditoria and Enforcement

- Use the **Intune admin center** to verify that restriction and configuration profiles are successfully applied.
- Combine with compliance policies to mark Dispositivos non-compliant if critical restrictions are not enforced.

### User Experience Considerations

- Overly restrictive settings can impact productivity or usability.
- Use **targeted assignments** to apply stricter controls only where needed (e.g., high-risk roles or departments).

### BYOD Considerations

- Dispositivos restrictions are generally not applied to BYOD macOS Dispositivos, as these are enrolled via user-initiated enrollment and do not support the same level of control.
- For BYOD, consider using **app protection policies** and Conditional Access instead.

## Zero Trust Considerations

- **Verify explicitly**: Dispositivos restrictions and security controls enforce known-good configurations that can be validated post-enrollment.
- **Assume breach**: Disabling unnecessary services and enforcing runtime protections reduces the potential for lateral movement or data leakage.
- **Least privilege**: Restricting access to system settings and features ensures users only have access to what they need.
- **Defense in depth**: Restrictions, Gatekeeper, firewall, and AV work together to harden the Dispositivos baseline.
- **Continuous trust**: Profiles and scripts are centrally managed and updated, supporting ongoing posture management.

## Recommendations

- **Apply Dispositivos restriction profiles** to all corporate macOS Dispositivos.
- **Use configuration profiles or scripts** to enforce Gatekeeper and firewall settings.
- **Deploy and monitor endpoint protection tools** such as Microsoft Defender for Endpoint.
- **Enable key restrictions** such as disabling AirDrop, iCloud Drive, external media, and remote login.
- **Restrict access to system preferences** to prevent tampering with security settings.
- **Monitor profile deployment status** and remediate Dispositivos where restrictions are not applied.
- **Balance security with usability**—avoid over-restriction, especially for developers or power users.

## References

- [Configure Dispositivos Restrictions for macOS](https://learn.microsoft.com/en-us/mem/intune/configuration/Dispositivos-restrictions-macos)  
- [Create and Assign Configuration Profiles](https://learn.microsoft.com/en-us/mem/intune/configuration/Dispositivos-profile-create)  
- [Use Settings Catalog for macOS](https://learn.microsoft.com/en-us/mem/intune/configuration/settings-catalog)  
- [Apple Gatekeeper Overview](https://support.apple.com/guide/security/gatekeeper-overview-secb005f6c51/web)  
- [Apple Firewall Overview](https://support.apple.com/guide/security/firewall-overview-secb7f9dd73a/web)  
- [Install Microsoft Defender for Endpoint on macOS](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/mac-install-manually)  
- [Use Scope Tags in Intune](https://learn.microsoft.com/en-us/mem/intune/fundamentals/scope-tags)
