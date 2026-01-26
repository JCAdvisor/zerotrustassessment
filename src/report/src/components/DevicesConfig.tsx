import { reportData } from "@/config/report-data";
import { Table, TableHeader, TableBody, TableRow, TableHead, TableCell } from "@/components/ui/table";

export default function DevicesConfig() {
    const enrollment = reportData.TenantInfo?.ConfigWindowsEnrollment;
    const enrollmentRestrictions = reportData.TenantInfo?.ConfigDeviceEnrollmentRestriction;
    const compliancePolicies = reportData.TenantInfo?.ConfigDeviceCompliancePolicies;
    const appProtectionPolicies = reportData.TenantInfo?.ConfigDeviceAppProtectionPolicies;
    return (
        <div className="p-4">
            <h2 className="text-lg font-semibold mb-4">Windows automatic enrollment</h2>
            <p className="text-sm text-gray-600 mb-4">
                Configure os dispositivos Windows para se inscreverem automaticamente quando ingressarem ou forem registrados no Azure Active Directory. Recomendamos definir como Todos, em vez de Grupos selecionados, e usar restrições de inscrição para controlar a entrada de usuários.
            </p>
            {enrollment && enrollment.length > 0 ? (
                <Table>
                    <TableHeader>
                        <TableRow>
                            <TableHead>Type</TableHead>
                            <TableHead>Policy Name</TableHead>
                            <TableHead>Applies To</TableHead>
                            <TableHead>Groups</TableHead>
                        </TableRow>
                    </TableHeader>
                    <TableBody>
                        {enrollment.map((row, idx) => (
                            <TableRow key={idx}>
                                <TableCell>{row.Type}</TableCell>
                                <TableCell>{row.PolicyName}</TableCell>
                                <TableCell>{row.AppliesTo}</TableCell>
                                <TableCell>{row.Groups}</TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            ) : (
                <p>No Windows enrollment configuration found.</p>
            )}

            <h2 className="text-lg font-semibold mb-4 mt-8">Enrollment device platform restrictions</h2>
            <p className="text-sm text-gray-600 mb-4">
                As restrições de inscrição de dispositivos permitem limitar a inscrição no Intune com base em determinados atributos do dispositivo. As restrições de plataforma de dispositivos limitam dispositivos com base na plataforma, versão, fabricante ou tipo de propriedade.
            </p>
            {enrollmentRestrictions && enrollmentRestrictions.length > 0 ? (
                <Table>
                    <TableHeader>
                        <TableRow>
                            <TableHead>Platform</TableHead>
                            <TableHead>Priority</TableHead>
                            <TableHead>Name</TableHead>
                            <TableHead>MDM</TableHead>
                            <TableHead>Min Ver</TableHead>
                            <TableHead>Max Ver</TableHead>
                            <TableHead>Personally owned</TableHead>
                            <TableHead>Blocked manuf.</TableHead>
                            <TableHead>Scope</TableHead>
                            <TableHead>Assigned to</TableHead>
                        </TableRow>
                    </TableHeader>
                    <TableBody>
                        {enrollmentRestrictions.map((row, idx) => (
                            <TableRow key={idx}>
                                <TableCell>{row.Platform}</TableCell>
                                <TableCell>{row.Priority}</TableCell>
                                <TableCell>{row.Name}</TableCell>
                                <TableCell>{row.MDM}</TableCell>
                                <TableCell>{row.MinVer}</TableCell>
                                <TableCell>{row.MaxVer}</TableCell>
                                <TableCell>{row.PersonallyOwned}</TableCell>
                                <TableCell>{row.BlockedManufacturers}</TableCell>
                                <TableCell>{row.Scope}</TableCell>
                                <TableCell>{row.AssignedTo}</TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            ) : (
                <p>No device enrollment restrictions found.</p>
            )}

            <h2 className="text-lg font-semibold mb-4 mt-8">Compliance policies</h2>
            <p className="text-sm text-gray-600 mb-4">
As políticas de conformidade de dispositivos definem as regras e configurações que os dispositivos devem atender para serem considerados compatíveis. Essas políticas ajudam a garantir que os dispositivos que acessam recursos organizacionais atendam aos requisitos mínimos de segurança.            </p>
            {compliancePolicies && compliancePolicies.length > 0 ? (
                <div className="overflow-x-auto">
                    <Table>
                        <TableHeader>
                            <TableRow>
                                <TableHead className="font-semibold">Configurações</TableHead>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableHead key={idx} className="min-w-[150px]">
                                        {policy.PolicyName}
                                    </TableHead>
                                ))}
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            <TableRow>
                                <TableCell className="font-medium">Platform</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.Platform}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Defender ATP</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.DefenderForEndPoint}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Min OS Version</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.MinOsVersion}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Max OS Version</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.MaxOsVersion}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Require Password</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.RequirePswd}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Min Password Length</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.MinPswdLength}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Password Type</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.PasswordType}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Password Expiry Days</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.PswdExpiryDays}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Previous Passwords Blocked</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.CountOfPreviousPswdToBlock}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Max Inactivity Min</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.MaxInactivityMin}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Require Encryption</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.RequireEncryption}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Rooted/Jailbroken</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.RootedJailbrokenDevices}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Max Threat Level</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.MaxDeviceThreatLevel}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Require Firewall</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.RequireFirewall}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Push Notification Days</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ActionForNoncomplianceDaysPushNotification}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Send Email Days</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ActionForNoncomplianceDaysSendEmail}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Remote Lock Days</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ActionForNoncomplianceDaysRemoteLock}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Block Days</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ActionForNoncomplianceDaysBlock}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Retire Days</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ActionForNoncomplianceDaysRetire}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Scope</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.Scope}</TableCell>
                                ))}
                            </TableRow>
                        </TableBody>
                    </Table>
                </div>
            ) : (
                <p>No device compliance policies found.</p>
            )}

            <h2 className="text-lg font-semibold mb-4 mt-8">App protection policies</h2>
            <p className="text-sm text-gray-600 mb-4">
As políticas de proteção de aplicativos (APP) são regras que garantem que os dados da organização permaneçam seguros ou contidos em um aplicativo gerenciado. Uma política pode ser uma regra aplicada quando o usuário tenta acessar ou mover dados “corporativos”, ou um conjunto de ações que são proibidas ou monitoradas enquanto o usuário está dentro do aplicativo. Um aplicativo gerenciado é um aplicativo ao qual foram aplicadas políticas de proteção e que pode ser gerenciado pelo Intune.            </p>
            {appProtectionPolicies && appProtectionPolicies.length > 0 ? (
                <div className="overflow-x-auto">
                    <Table>
                        <TableHeader>
                            <TableRow>
                                <TableHead className="font-semibold">Setting</TableHead>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableHead key={idx} className="min-w-[150px]">
                                        {policy.Name}
                                    </TableHead>
                                ))}
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            <TableRow>
                                <TableCell className="font-medium">Platform</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.Platform}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Public Apps</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.AppsPublic}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Custom Apps</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.AppsCustom}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Backup to Cloud</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.BackupOrgDataToICloudOrGoogle}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Send Data to Other Apps</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.SendOrgDataToOtherApps}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Apps to Exempt</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.AppsToExempt}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Save Copies</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.SaveCopiesOfOrgData}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Allow Save to Selected Services</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.AllowUserToSaveCopiesToSelectedServices}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Transfer Telecom Data To</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.DataProtectionTransferTelecommunicationDataTo}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Receive Data From Other Apps</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.DataProtectionReceiveDataFromOtherApps}</TableCell>
                                ))}
                            </TableRow>
                            {/* <TableRow>
                                <TableCell className="font-medium">Open Data in Org Documents</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.DataProtectionOpenDataIntoOrgDocuments}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Allow Open from Selected Services</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.DataProtectionAllowUsersToOpenDataFromSelectedServices}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Restrict Cut/Copy Between Apps</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.DataProtectionRestrictCutCopyBetweenOtherApps}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Cut/Copy Character Limit</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.DataProtectionCutCopyCharacterLimitForAnyApp}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Encrypt Org Data</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.DataProtectionEncryptOrgData}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Sync with Native Apps</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.DataProtectionSyncPolicyManagedAppDataWithNativeApps}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Printing</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.DataProtectionPrintingOrgData}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Restrict Web Content Transfer</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.DataProtectionRestrictWebContentTransferWithOtherApps}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Org Data Notifications</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.DataProtectionOrgDataNotifications}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Max PIN Attempts</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ConditionalLaunchAppMaxPinAttempts}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Offline Grace Period Block</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ConditionalLaunchAppOfflineGracePeriodBlockAccess}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Offline Grace Period Wipe</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ConditionalLaunchAppOfflineGracePeriodWipeData}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Disabled Account</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ConditionalLaunchAppDisabedAccount}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Min App Version</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ConditionalLaunchAppMinAppVersion}</TableCell>
                                ))}
                            </TableRow> */}
                            <TableRow>
                                <TableCell className="font-medium">Rooted/Jailbroken Devices</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ConditionalLaunchDeviceRootedJailbrokenDevices}</TableCell>
                                ))}
                            </TableRow>
                            {/* <TableRow>
                                <TableCell className="font-medium">Primary MTD Service</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ConditionalLaunchDevicePrimaryMtdService}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Max Device Threat Level</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ConditionalLaunchDeviceMaxAllowedDeviceThreatLevel}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Min OS Version</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ConditionalLaunchDeviceMinOsVersion}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Max OS Version</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ConditionalLaunchDeviceMaxOsVersion}</TableCell>
                                ))}
                            </TableRow> */}
                            <TableRow>
                                <TableCell className="font-medium">Scope</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.Scope}</TableCell>
                                ))}
                            </TableRow>
                            {/* <TableRow>
                                <TableCell className="font-medium">Included Groups</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.IncludedGroups}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Excluded Groups</TableCell>
                                {appProtectionPolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{policy.ExcludedGroups}</TableCell>
                                ))}
                            </TableRow> */}
                        </TableBody>
                    </Table>
                </div>
            ) : (
                <p>No app protection policies found.</p>
            )}
        </div>
    );
}
