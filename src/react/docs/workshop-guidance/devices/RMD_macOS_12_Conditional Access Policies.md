# Conditional Access Policies

**Last Updated:** May 2025  
**Implementation Effort:** Medium – IT teams must configure Intune compliance policies and Conditional Access rules in Microsoft Entra, which requires planning and testing but not ongoing manual effort.  
**User Impact:** Medium – Users might be required to register their Dispositivos, install the Company Portal, or update security settings.

## Introduction

Conditional Access (CA) is a core enforcement mechanism in Microsoft Entra ID (formerly Azure AD) that allows organizations to control access to apps and resources based on real-time conditions. For macOS Dispositivos managed by Intune, Conditional Access ensures that only trusted, compliant, and identity-verified endpoints can access corporate data. This section helps administrators evaluate their Conditional Access strategy for macOS and align it with Zero Trust principles.

## Why This Matters

- **Enforces Controle de Acesso based on Dispositivos compliance and user identity**.
- **Supports Zero Trust** by requiring continuous evaluation of trust signals.
- **Reduces risk** by blocking access from unmanaged or non-compliant Dispositivos.
- **Improves visibility** into access patterns and policy effectiveness.
- **Enables adaptive access** based on risk, location, or session context.

## Key Considerations

### Dispositivos Compliance Integration

- Conditional Access policies can require that macOS Dispositivos be marked as **compliant in Intune** before access is granted.
- This ensures that only Dispositivos meeting your FileVault, OS version, and password policies can access sensitive resources.

From a Zero Trust perspective: This enforces **explicit verification** of Dispositivos posture before granting access.

### App-Based Targeting

- CA policies can be scoped to specific apps (e.g., Microsoft 365, Salesforce, ServiceNow).
- This allows you to apply stricter controls to high-risk or high-value applications.

From a Zero Trust perspective: This supports **least privilege** by tailoring Controle de Acessos to the sensitivity of the resource.

### User and Group Scoping

- Policies can be applied to all users or scoped to specific groups, departments, or roles.
- Use this to apply more stringent controls to executives, finance, or privileged IT users.

From a Zero Trust perspective: This enables **risk-based access** and **role-aware enforcement**.

### Conditions and Controls

Common conditions include:

- **Dispositivos platform** (macOS)  
- **Location** (trusted vs. untrusted networks)  
- **Sign-in risk** (if using Microsoft Defender for Identity)  

Common controls include:

- **Require compliant Dispositivos**  
- **Require MFA**  
- **Require app protection policy**  

From a Zero Trust perspective: These controls enforce **adaptive access** based on real-time context.

### macOS-Specific Considerations

- Ensure that Dispositivos are **Entra-joined** and enrolled in Intune to meet compliance requirements.
- Use **Platform SSO** and the **SSO app extension** to ensure seamless authentication and policy enforcement.
- Monitor for Dispositivos that are accessing resources but are not enrolled or compliant.

### Auditoria and Reporting

- Use the **Microsoft Entra admin center** to review sign-in logs, policy impact, and blocked access attempts.
- Analyze trends to refine policies and reduce false positives.

From a Zero Trust perspective: Auditoria supports **continuous trust evaluation** and **policy tuning**.

## Zero Trust Considerations

- **Verify explicitly**: Access is granted only after confirming user identity, Dispositivos compliance, and session context.
- **Assume breach**: CA policies block access from unmanaged or risky endpoints.
- **Least privilege**: Access is scoped to the user, Dispositivos, and app context.
- **Continuous trust**: Policies are evaluated at every sign-in, not just at enrollment.
- **Defense in depth**: CA works alongside compliance policies, SSO, and Dispositivos restrictions to enforce layered security.

## Recommendations

- **Require compliant macOS Dispositivos** for access to all corporate resources.
- **Use MFA and Dispositivos compliance** as baseline controls for all users.
- **Apply stricter policies** to high-risk apps and privileged user groups.
- **Use Platform SSO and SSO extensions** to ensure seamless policy enforcement.
- **Monitor sign-in logs** and refine policies based on real-world usage and risk.
- **Test policies in report-only mode** before enforcing them in production.

## References

- [Conditional Access Overview](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)  
- [Conditional Access for macOS Dispositivos](https://learn.microsoft.com/en-us/mem/intune/protect/conditional-access-intune-common-ways-use)  
- [Monitor Conditional Access Policies](https://learn.microsoft.com/en-us/entra/identity/conditional-access/monitor-conditional-access)  
- [Platform SSO and Compliance Integration](https://learn.microsoft.com/en-us/entra/identity/Dispositivos/macos-psso)
