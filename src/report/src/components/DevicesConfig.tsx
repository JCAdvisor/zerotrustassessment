import { reportData } from "@/config/report-data";
import { Table, TableHeader, TableBody, TableRow, TableHead, TableCell } from "@/components/ui/table";
import { translateText } from "@/lib/pt";

export default function DevicesConfig() {
    const enrollment = reportData.TenantInfo?.ConfigWindowsEnrollment;
    const enrollmentRestrictions = reportData.TenantInfo?.ConfigDeviceEnrollmentRestriction;
    const compliancePolicies = reportData.TenantInfo?.ConfigDeviceCompliancePolicies;
    const appProtectionPolicies = reportData.TenantInfo?.ConfigDeviceAppProtectionPolicies;
    return (
        <div className="p-4">
            <h2 className="text-lg font-semibold mb-4">Inscrição automática do Windows</h2>
            <p className="text-sm text-gray-600 mb-4">
                Configure os dispositivos Windows para se inscreverem quando entrarem ou forem registrados no Azure Active Directory. Recomendamos aplicar isso a todos, em vez de a grupos selecionados, e usar restrições de inscrição para controlar a entrada de usuários.
            </p>
            {enrollment && enrollment.length > 0 ? (
                <Table>
                    <TableHeader>
                        <TableRow>
                            <TableHead>Tipo</TableHead>
                            <TableHead>Nome da política</TableHead>
                            <TableHead>Aplica-se a</TableHead>
                            <TableHead>Grupos</TableHead>
                        </TableRow>
                    </TableHeader>
                    <TableBody>
                        {enrollment.map((row, idx) => (
                            <TableRow key={idx}>
                                <TableCell>{translateText(row.Type)}</TableCell>
                                <TableCell>{translateText(row.PolicyName)}</TableCell>
                                <TableCell>{translateText(row.AppliesTo)}</TableCell>
                                <TableCell>{translateText(row.Groups)}</TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            ) : (
                <p>Nenhuma configuração de inscrição do Windows encontrada.</p>
            )}

            <h2 className="text-lg font-semibold mb-4 mt-8">Restrições de plataforma para inscrição de dispositivos</h2>
            <p className="text-sm text-gray-600 mb-4">
                As restrições de inscrição de dispositivos permitem impedir que dispositivos se inscrevam no Intune com base em determinados atributos. As restrições de plataforma limitam a inscrição com base na plataforma, versão, fabricante ou tipo de propriedade do dispositivo.
            </p>
            {enrollmentRestrictions && enrollmentRestrictions.length > 0 ? (
                <Table>
                    <TableHeader>
                        <TableRow>
                            <TableHead>Plataforma</TableHead>
                            <TableHead>Prioridade</TableHead>
                            <TableHead>Nome</TableHead>
                            <TableHead>MDM</TableHead>
                            <TableHead>Versão mín.</TableHead>
                            <TableHead>Versão máx.</TableHead>
                            <TableHead>De propriedade pessoal</TableHead>
                            <TableHead>Fabricantes bloqueados</TableHead>
                            <TableHead>Escopo</TableHead>
                            <TableHead>Atribuído a</TableHead>
                        </TableRow>
                    </TableHeader>
                    <TableBody>
                        {enrollmentRestrictions.map((row, idx) => (
                            <TableRow key={idx}>
                                <TableCell>{translateText(row.Platform)}</TableCell>
                                <TableCell>{translateText(row.Priority)}</TableCell>
                                <TableCell>{translateText(row.Name)}</TableCell>
                                <TableCell>{translateText(row.MDM)}</TableCell>
                                <TableCell>{translateText(row.MinVer)}</TableCell>
                                <TableCell>{translateText(row.MaxVer)}</TableCell>
                                <TableCell>{translateText(row.PersonallyOwned)}</TableCell>
                                <TableCell>{translateText(row.BlockedManufacturers)}</TableCell>
                                <TableCell>{translateText(row.Scope)}</TableCell>
                                <TableCell>{translateText(row.AssignedTo)}</TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            ) : (
                <p>Nenhuma restrição de inscrição de dispositivo encontrada.</p>
            )}

            <h2 className="text-lg font-semibold mb-4 mt-8">Políticas de conformidade</h2>
            <p className="text-sm text-gray-600 mb-4">
                As políticas de conformidade definem as regras e configurações que os dispositivos devem atender para serem considerados em conformidade. Essas políticas ajudam a garantir que os dispositivos que acessam os recursos da organização atendam aos requisitos mínimos de segurança.
            </p>
            {compliancePolicies && compliancePolicies.length > 0 ? (
                <div className="overflow-x-auto">
                    <Table>
                        <TableHeader>
                            <TableRow>
                                <TableCell className="font-semibold">Configuração</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableHead key={idx} className="min-w-[150px]">
                                        {translateText(policy.PolicyName)}
                                    </TableHead>
                                ))}
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            <TableRow>
                                <TableCell className="font-medium">Platform</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{translateText(policy.Platform)}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Defender ATP</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{translateText(policy.DefenderForEndPoint)}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Versão mín. do SO</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{translateText(policy.MinOsVersion)}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Versão máx. do SO</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{translateText(policy.MaxOsVersion)}</TableCell>
                                ))}
                            </TableRow>
                            <TableRow>
                                <TableCell className="font-medium">Exigir senha</TableCell>
                                {compliancePolicies.map((policy, idx) => (
                                    <TableCell key={idx}>{translateText(policy.RequirePswd)}</TableCell>
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
                App protection policies (APP) are rules that ensure an organization's data remains safe or contained in a managed app. A policy can be a rule that is enforced when the user attempts to access or move "corporate" data, or a set of actions that are prohibited or monitored when the user is inside the app. A managed app is an app that has app protection policies applied to it, and can be managed by Intune.
            </p>
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
