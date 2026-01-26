# Managing OS Updates

**Last Updated:** May 2025  
**Implementation Effort:** Medium – Managing OS updates requires configuring either Declarative Dispositivos Management (DDM) for macOS 14+ or traditional update policies for earlier versions. Admins must test policy behavior, avoid conflicts, and monitor compliance regularly.  
**User Impact:** Medium – Users on macOS 14+ benefit from a seamless update experience via DDM. Those on older versions may need to manually approve updates. Clear communication is essential to ensure compliance and reduce friction, especially in hybrid or BYOD environments.

## Introduction

Keeping macOS Dispositivos up to date is a foundational security requirement. Intune provides multiple methods to manage software updates on macOS, including traditional MDM-based update policies and the newer **Declarative Dispositivos Management (DDM)** approach introduced in macOS 14+. This section helps administrators evaluate their update strategy and align it with Zero Trust principles—ensuring that only secure, current, and policy-compliant Dispositivos can access corporate resources.

## Why This Matters

- **Reduces exposure to known vulnerabilities** by ensuring timely patching.
- **Supports Zero Trust** by enforcing continuous Dispositivos health and compliance.
- **Improves user experience** by automating update delivery and reducing manual intervention.
- **Prevents drift** between Dispositivos by standardizing update behavior.
- **Enables auditability** of update status across the fleet.

## Key Considerations

### Use Declarative Dispositivos Management (DDM) for macOS 14+

- DDM allows Intune to configure **managed software updates** using the **settings catalog**.
- You can specify a target OS version or build, enforce a deadline, and provide a help URL.
- DDM is **autonomous**—the Dispositivos handles the update lifecycle, including download, preparation, and installation.

From a Zero Trust perspective: DDM ensures **continuous trust** by keeping Dispositivos current without relying on user action, reducing the risk of unpatched endpoints.

### Use Software Update Policies for macOS 13 and Earlier

- For older versions, use **software update policies** to define update behavior and scheduling.
- These policies are less flexible and do not support enforced deadlines or version targeting.

From a Zero Trust perspective: While not as robust as DDM, these policies still help maintain **baseline security posture** for legacy Dispositivos.

### Policy Precedence and Conflicts

- On macOS 14+, **DDM-based managed software updates take precedence** over traditional update policies.
- Avoid assigning both policy types to the same Dispositivos group to prevent conflicts.

From a Zero Trust perspective: Ensure that update enforcement is **predictable and consistent** across the environment.

### Auditoria Update Compliance

- Use the **Intune admin center** to monitor update status and compliance across Dispositivos.
- Identify Dispositivos that are out of date or have failed to install required updates.

From a Zero Trust perspective: Visibility into update posture supports **explicit verification** and **risk-based access decisions**.

### User Experience and Communication

- DDM provides a more seamless experience by prompting users and handling updates in the background.
- For MDM-based updates, users may need to manually approve or initiate updates.
- Provide clear communication and support resources to reduce friction and ensure compliance.

### BYOD Considerations

- Update policies are generally not enforced on BYOD macOS Dispositivos unless they are fully managed.
- For BYOD, use Conditional Access to block access from outdated or non-compliant OS versions.

## Zero Trust Considerations

- **Verify explicitly**: Dispositivos must be running a supported and secure OS version to be considered trusted.
- **Assume breach**: Unpatched Dispositivos are a common attack vector; update enforcement reduces this risk.
- **Continuous trust**: DDM enables ongoing evaluation and remediation of Dispositivos health.
- **Least privilege**: Dispositivos that are not current can be restricted from accessing sensitive resources.
- **Defense in depth**: OS updates complement other controls like compliance policies, encryption, and access restrictions.

## Recommendations

- **Use DDM-based managed software updates** for all macOS 14+ Dispositivos.
- **Use traditional update policies** for macOS 13 and earlier, but plan to phase them out.
- **Avoid policy conflicts** by assigning only one update method per Dispositivos group.
- **Monitor update status** regularly and remediate non-compliant Dispositivos.
- **Communicate update expectations** clearly to users, especially in hybrid or remote environments.
- **Use Conditional Access** to block outdated or non-compliant Dispositivos from accessing corporate resources.

## References

- [Manage Software Updates with DDM (macOS 14+)](https://learn.microsoft.com/en-us/intune/intune-service/protect/managed-software-updates-ios-macos)  
- [Admin Guide for macOS Software Updates](https://learn.microsoft.com/en-us/intune/intune-service/protect/software-updates-guide-macos)  
- [Software Update Policies for macOS](https://learn.microsoft.com/en-us/intune/intune-service/protect/software-updates-macos)
