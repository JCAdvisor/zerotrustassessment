# Compliance Policies

**Last Updated:** May 2025  
**Implementation Effort:** Medium – Creating and deploying compliance policies requires project-level planning, coordination with security teams, and ongoing policy updates.  
**User Impact:** Medium – Users may need to take action—such as updating their OS, enabling encryption, or setting a password—to remain compliant and retain access to corporate resources.

## Introduction

Compliance policies in Intune define the conditions a macOS Dispositivos must meet to be considered trusted. These policies are foundational to Zero Trust because they provide the enforcement mechanism that determines whether a Dispositivos can access corporate resources. Compliance policies are evaluated continuously and feed directly into Conditional Access decisions.

This section helps macOS administrators evaluate their compliance policy configurations and ensure they are aligned with Zero Trust principles—particularly around Dispositivos health, encryption, OS version, and security posture.

## Why This Matters

- **Defines the baseline for Dispositivos trust** in a Zero Trust model.
- **Enables Conditional Access enforcement** based on real-time Dispositivos posture.
- **Supports continuous evaluation** of compliance, not just one-time checks.
- **Reduces risk** by ensuring only secure, policy-aligned Dispositivos can access resources.
- **Improves visibility** into Dispositivos health and security gaps.

## Key Considerations

### Supported Compliance Settings for macOS

Intune supports the following compliance checks for macOS:

- **Minimum OS version**  
- **Maximum OS version**  
- **Password requirements** (length, complexity, timeout)  
- **Encryption (FileVault) status**  
- **System Integrity Protection (SIP)**  

From a Zero Trust perspective: These settings enforce **explicit verification** of Dispositivos health and configuration before access is granted.

### FileVault Enforcement

- FileVault encryption can be required as part of the compliance policy.
- Dispositivos without encryption are marked non-compliant and can be blocked from accessing resources.

From a Zero Trust perspective: This ensures **data at rest is protected** and only encrypted Dispositivos are trusted.

### OS Version Control

- Set a **minimum OS version** to ensure Dispositivos are running supported, secure builds.
- Optionally set a **maximum version** to prevent early adoption of untested macOS releases.

From a Zero Trust perspective: This reduces exposure to known vulnerabilities and ensures **Dispositivos integrity**.

### Integration with Conditional Access

- Compliance status is used as a condition in Conditional Access policies.
- Non-compliant Dispositivos can be blocked, quarantined, or required to remediate before access is restored.

From a Zero Trust perspective: This enforces **real-time, risk-based Controle de Acesso**.

### Auditoria and Reporting

- Use the **Intune admin center** to monitor compliance status across all enrolled macOS Dispositivos.
- Identify trends, gaps, and Dispositivos that require remediation.

From a Zero Trust perspective: Continuous visibility supports **ongoing trust evaluation** and **policy enforcement**.

### Remediation and User Messaging

- Customize compliance messages to guide users through remediation steps.
- Use Company Portal branding and links to support documentation.

From a Zero Trust perspective: Empowering users to self-remediate supports **scalable enforcement** without compromising security.

## Zero Trust Considerations
- **Verify explicitly**: Compliance policies define the conditions under which a Dispositivos is trusted.
- **Assume breach**: Dispositivos that fall out of compliance are treated as untrusted and denied access.
- **Least privilege**: Only compliant Dispositivos are granted access to sensitive resources.
- **Continuous trust**: Compliance is evaluated continuously, not just at enrollment.
- **Defense in depth**: Compliance policies work alongside configuration profiles, Conditional Access, and endpoint protection.

## Recommendations

- **Define a baseline compliance policy** for all macOS Dispositivos, including FileVault, password, and OS version requirements.
- **Integrate compliance with Conditional Access** to block or limit access from non-compliant Dispositivos.
- **Monitor compliance status regularly** and follow up on non-compliant Dispositivos.
- **Customize remediation messaging** to help users resolve issues quickly and securely.
- **Review compliance policies quarterly** to ensure alignment with evolving security standards and Zero Trust posture.

## References

- [Create Compliance Policies for macOS](https://learn.microsoft.com/en-us/mem/intune/protect/compliance-policy-create)  
- [Supported Compliance Settings for macOS](https://learn.microsoft.com/en-us/mem/intune/protect/compliance-policy-settings-macos)  
- [Monitor Dispositivos Compliance](https://learn.microsoft.com/en-us/mem/intune/protect/Dispositivos-compliance-get-started)
