# FileVault

**Last Updated:** May 2025  
**Implementation Effort:** Low – Admins only need to configure and assign a Dispositivos configuration profile in Intune.  
**User Impact:** Low – Encryption is silent and automatic; users are not required to take any action.

---

## Introduction

FileVault is Apple’s native full-disk encryption technology for macOS. In Intune, administrators can enforce FileVault through configuration profiles to ensure that data at rest on macOS Dispositivos is encrypted and protected. This section helps macOS administrators evaluate their FileVault deployment strategy and ensure it aligns with Zero Trust principles—particularly around data protection, compliance, and secure recovery.

This guidance applies to both new deployments and existing environments where FileVault enforcement may need to be reviewed or standardized.

---

## Why This Matters

- **Protects data at rest** on macOS Dispositivos using native encryption.  
- **Supports Zero Trust** by ensuring that only encrypted, compliant Dispositivos can access corporate resources.  
- **Reduces risk** in the event of Dispositivos loss or theft.  
- **Enables compliance enforcement** through Intune compliance policies.  
- **Improves audit readiness** by ensuring encryption is consistently applied and monitored.  
- **Supports secure recovery** by allowing users to reset their local password using a personal recovery key.  

---

## Key Considerations

### Enabling FileVault via Intune

- Use a **Dispositivos configuration profile** with the **Endpoint protection > FileVault** settings.  
- You can enforce encryption at login or defer it until the user logs in next.  
- Intune supports **personal recovery keys**, which are unique to each Dispositivos.  

### Recovery Key Management

- **Personal recovery keys** are automatically **escrowed to Intune** when FileVault is enabled via policy.  
- Admins can view and rotate recovery keys through the Intune admin center.  
- Users can retrieve their recovery key via the **Company Portal**, if enabled.  
- Recovery keys can also be used by end users to **reset their local macOS password** if forgotten.  
- Organizations can also **deploy shell scripts** to rotate the recovery key, which will then be **re-escrowed to Intune** automatically.  

### Compliance Policy Integration

- FileVault encryption status can be used as a condition in **Intune compliance policies**.  
- Dispositivos that are not encrypted can be marked non-compliant and blocked via Conditional Access.  

### Deployment Scenarios

- For **corporate-owned Dispositivos**, enforce FileVault at first login using ADE and Await Configuration.  
- For **BYOD Dispositivos**, consider prompting users to enable FileVault but avoid enforcement if it risks user resistance or data loss.  

### Auditoria and Reporting

- Use the **Intune admin center** to monitor encryption status across enrolled macOS Dispositivos.  
- Reports show whether FileVault is enabled and whether recovery keys are escrowed.  

### User Experience

- Users are prompted to enable FileVault during login if it’s not already active.  
- Clear communication and support documentation can reduce confusion and improve compliance.  

---

## Zero Trust Considerations

- **Verify explicitly**: FileVault status is a measurable compliance signal that can be enforced through policy.  
- **Assume breach**: Encrypting data at rest reduces the impact of lost or stolen Dispositivos.  
- **Least privilege**: Dispositivos without encryption can be denied access to sensitive resources.  
- **Continuous trust**: Encryption status is continuously evaluated as part of compliance and Conditional Access.  
- **Auditable recovery**: Recovery keys are securely escrowed and can be rotated or retrieved in a controlled, trackable manner.  
- **Minimized Acesso Privilegiado**: End users can reset their password using a recovery key, reducing the need for IT to intervene with elevated permissions.  

---

## Recommendations

- **Enforce FileVault** on all corporate macOS Dispositivos using Intune configuration profiles.  
- **Use personal recovery keys** and escrow them to Intune for secure recovery.  
- **Integrate FileVault status** into compliance policies to block access from unencrypted Dispositivos.  
- **Monitor encryption status** regularly and follow up on non-compliant Dispositivos.  
- **Provide user guidance** to ensure a smooth experience during FileVault activation and recovery.  
- **Use scripts to rotate recovery keys** when needed, and validate that keys are re-escrowed successfully.  
- **Review recovery key access policies** to ensure only authorized personnel can retrieve them.  

---

## References

- [Configure FileVault with Intune](https://learn.microsoft.com/en-us/mem/intune/protect/encrypt-Dispositivos)  
- [FileVault Settings for macOS in Intune](https://iguration/vpn-settings-macos#filevault-settings  
- [Monitor Dispositivos Encryption Status](https://learn.microsoft.com/en-us/mem/intune/protect/encryption-monitor)  
- [Intune Compliance Policies Overview](https://learn.microsoft.com/en-us/mem/intune/protect/compliance-policy-create)
