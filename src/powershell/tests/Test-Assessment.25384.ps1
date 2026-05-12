<#
.SYNOPSIS
    Checks if Application Administrator rights are constrained to specific Private Access apps.

.DESCRIPTION
    This test validates that Application Administrator role assignments are scoped to specific
    applications rather than tenant-wide, and that assignments follow least privilege principles.

.NOTES
    Test ID: 25384
    Category: Access control
    Required API: roleManagement/directory (beta)
#>

function Test-Assessment-25384 {
    [ZtTest(
    	Category = 'Gerenciamento de funções',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	CompatibleLicense = ('Entra_Premium_Private_Access','Entra_Premium_Internet_Access'),
    	Pillar = 'Rede',
    	RiskLevel = 'Alto',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce'),
    	TestId = 25384,
    	Title = 'Os direitos de administrador de aplicação são restritos a apps Private Access específicos',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    #region Data Collection
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    $activity = 'Verificando atribuições da função Application Administrator'
    Write-ZtProgress -Activity $activity -Status 'Obtendo definição de função'

        # Consulta 1: Get Application Administrator role definition
    $appAdminRoleId = Get-ZtRoleInfo -RoleName 'ApplicationAdministrator'

    Write-ZtProgress -Activity $activity -Status 'Obtendo atribuições de função com detalhes do principal'

        # Consulta 2: Get Application Administrator role assignments with expanded principal (no nested $select)
    $assignments = Invoke-ZtGraphRequest -RelativeUri "roleManagement/directory/roleAssignments?`$filter=roleDefinitionId eq '$appAdminRoleId'&`$expand=principal" -ApiVersion beta

    # Default to empty array if no assignments found
    $assignments = $assignments ?? @()

    # Collect scoped IDs from assignments for Q3 resolution
    $spIds = @()
    $appIds = @()
    foreach ($assignment in $assignments) {
        if ($assignment.directoryScopeId -ne '/') {
            $scopeId = $assignment.directoryScopeId -replace '^/', ''
            if ($scopeId -match '^servicePrincipals/(.+)') {
                $spIds += $Matches[1]
            } elseif ($scopeId -match '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') {
                $spIds += $scopeId
                $appIds += $scopeId
            }
        }
    }

    Write-ZtProgress -Activity $activity -Status 'Resolvendo service principals e aplicações escopadas'

        # Consulta 3: Resolve scoped service principals and applications
    $spLookup = @{}
    $appLookup = @{}

    # Fetch service principals referenced in scoped assignments
    $uniqueSpIds = $spIds | Select-Object -Unique

    if ($uniqueSpIds) {
        $sps = Invoke-ZtGraphBatchRequest -Path "servicePrincipals/{0}?`$select=id,displayName,appId,appOwnerOrganizationId" -ArgumentList $uniqueSpIds -ApiVersion beta -ErrorAction SilentlyContinue
        foreach ($sp in $sps) {
            if ($sp.id) { $spLookup[$sp.id] = $sp }
        }
    }

    # Fetch applications directly referenced in scoped assignments (app registrations)
    $uniqueAppIds = $appIds | Select-Object -Unique

       if ($uniqueAppIds) {
        $apps = Invoke-ZtGraphBatchRequest -Path "applications/{0}?`$select=id,displayName,appId,tags,appOwnerOrganizationId" -ArgumentList $uniqueAppIds -ApiVersion beta -ErrorAction SilentlyContinue
        foreach ($app in $apps) {
            if ($app.id) { $appLookup[$app.id] = $app }
            if ($app.appId) { $appLookup[$app.appId] = $app }
        }
    }

    Write-ZtProgress -Activity $activity -Status 'Detectando apps Private Access e Quick Access'

        # Consulta 4: Detect Private Access / Quick Access apps via tags (bulk fetch)
    $paQaAppLookup = @{}
    try {
        $paQuickAccessApps = Invoke-ZtGraphRequest -RelativeUri "applications" -Filter "(tags/any(t: t eq 'PrivateAccessNonWebApplication') or tags/any(t: t eq 'NetworkAccessQuickAccessApplication'))" -Select 'id,displayName,appId,tags' -ApiVersion beta
        foreach ($app in $paQuickAccessApps) {
            if ($app.appId) { $paQaAppLookup[$app.appId] = $app }
            if ($app.id) { $paQaAppLookup[$app.id] = $app }
        }
    } catch {
        Write-PSFMessage "Não foi possível consultar apps Private Access/Quick Access por tags" -Level Verbose
    }

    # Fetch application details for service principals from Q3 (if not already in PA/QA lookup)
    $spAppIds = @($spLookup.Values | Where-Object { $_.appId } | ForEach-Object { $_.appId }) | Select-Object -Unique
    $appIdsToFetch = $spAppIds | Where-Object { -not $paQaAppLookup.ContainsKey($_) -and -not $appLookup.ContainsKey($_) }

    if ($appIdsToFetch) {
        $apps = Invoke-ZtGraphBatchRequest -Path "applications?`$filter=appId eq '{0}'&`$select=id,displayName,appId,tags,appOwnerOrganizationId" -ArgumentList $appIdsToFetch -ApiVersion beta -ErrorAction SilentlyContinue
        foreach ($app in $apps) {
            if ($app) {
                if ($app.id) { $appLookup[$app.id] = $app }
                if ($app.appId) { $appLookup[$app.appId] = $app }
            }
        }
    }

    #endregion Data Collection

    #region Assessment Logic
    $testResultMarkdown = ''
    $passed = $true
    $tenantWideAssignments = @()
    $scopedAssignments = @()
    $problematicAssignments = @()
    $unresolvedScopedAssignments = @()
    $warnings = @()

    foreach ($assignment in $assignments) {
        $principalType = if ($assignment.principal.'@odata.type') {
            $assignment.principal.'@odata.type' -replace '#microsoft.graph.', ''
        } else { 'desconhecido' }

        $assignmentInfo = [PSCustomObject]@{
            DirectoryScopeId    = $assignment.directoryScopeId
            PrincipalId         = $assignment.principalId
            PrincipalDisplayName = $assignment.principal.displayName
            PrincipalUPN        = $assignment.principal.userPrincipalName
            PrincipalType       = $principalType
            UserType            = $assignment.principal.userType
            AccountEnabled      = $assignment.principal.accountEnabled
            AppDisplayName      = ''
            AppId               = ''
            IsPAApp             = $false
        }

        if ($assignment.directoryScopeId -eq '/') {
            $tenantWideAssignments += $assignmentInfo
            $passed = $false
        } else {
            $scopeId = $assignment.directoryScopeId -replace '^/', ''
            if ($scopeId -match '^servicePrincipals/(.+)') {
                $spId = $Matches[1]
                if ($spLookup.ContainsKey($spId)) {
                    $sp = $spLookup[$spId]
                    $assignmentInfo.AppDisplayName = $sp.displayName
                    $assignmentInfo.AppId = $sp.appId
                    if ($sp.appId) {
                        $app = $paQaAppLookup[$sp.appId] ?? $appLookup[$sp.appId]
                        if ($app) {
                            $assignmentInfo.IsPAApp = ($app.tags -contains 'PrivateAccessNonWebApplication') -or ($app.tags -contains 'NetworkAccessQuickAccessApplication')
                        }
                    }
                }
            } else {
                $app = $paQaAppLookup[$scopeId] ?? $appLookup[$scopeId]
                if ($app) {
                    $assignmentInfo.AppDisplayName = $app.displayName
                    $assignmentInfo.AppId = $app.appId
                    $assignmentInfo.IsPAApp = ($app.tags -contains 'PrivateAccessNonWebApplication') -or ($app.tags -contains 'NetworkAccessQuickAccessApplication')
                } elseif ($spLookup.ContainsKey($scopeId)) {
                    $sp = $spLookup[$scopeId]
                    $assignmentInfo.AppDisplayName = $sp.displayName
                    $assignmentInfo.AppId = $sp.appId
                    if ($sp.appId) {
                        $resolvedApp = $paQaAppLookup[$sp.appId] ?? $appLookup[$sp.appId]
                        if ($resolvedApp) {
                            $assignmentInfo.IsPAApp = ($resolvedApp.tags -contains 'PrivateAccessNonWebApplication') -or ($resolvedApp.tags -contains 'NetworkAccessQuickAccessApplication')
                        }
                    }
                }
            }
            $scopedAssignments += $assignmentInfo

            if (-not $assignmentInfo.AppDisplayName) {
                $unresolvedScopedAssignments += $assignmentInfo
            }
        }

        if ($principalType -in @('group', 'servicePrincipal') -or $assignment.principal.userType -eq 'Guest') {
            $problematicAssignments += $assignmentInfo
            $passed = $false
        }
    }

    if ($assignments.Count -gt 5) {
        $warnings += "A contagem de atribuições ($($assignments.Count)) excede o limite recomendado de 5"
    }

    $scopedNonPACount = ($scopedAssignments | Where-Object { -not $_.IsPAApp -and $_.AppDisplayName }).Count
    if ($scopedNonPACount -gt 0) {
        $warnings += "$scopedNonPACount atribuição(ões) escopada(s) para apps que não são confirmados como Private Access ou Quick Access"
    }

    $unresolvedScopedCount = $unresolvedScopedAssignments.Count
    if ($unresolvedScopedCount -gt 0) {
        $warnings += "$unresolvedScopedCount atribuição(ões) escopada(s) não puderam ser resolvidas para objetos de aplicativo; veja detalhes em 'Atribuições escopadas não resolvidas' abaixo"
    }
    #endregion Assessment Logic

    #region Report Generation
    $mdInfo = ''

    # Summary Section
    $mdInfo += "`n## Resumo`n`n"
    $mdInfo += "| Métrica | Contagem |`n"
    $mdInfo += "| :--- | ---: |`n"
    $mdInfo += "| Atribuições totais | $($assignments.Count) |`n"
    $mdInfo += "| Atribuições de todo o locatário | $($tenantWideAssignments.Count) |`n"
    $mdInfo += "| Atribuições escopadas | $($scopedAssignments.Count) |`n"
    $mdInfo += "| Atribuições problemáticas | $($problematicAssignments.Count) |`n`n"

    # Application Administrator Assignments
    $mdInfo += "`n## Atribuições de Application Administrator:`n`n"
    $mdInfo += "- Contagem: $($assignments.Count)`n`n"

    if ($assignments.Count -gt 0) {
        $mdInfo += "| DirectoryScopeId | Nome principal | UPN | Conta habilitada | Tipo | Tipo de usuário |`n"
        $mdInfo += "| :--- | :--- | :--- | :---: | :--- | :--- |`n"
        foreach ($rawA in $assignments) {
            $scope = $rawA.directoryScopeId
            $displayName = $rawA.principal.displayName
            $upn = $rawA.principal.userPrincipalName
            $acctEnabled = if ($null -ne $rawA.principal.accountEnabled) { $rawA.principal.accountEnabled } else { '' }
            $pType = if ($rawA.principal.'@odata.type') { $rawA.principal.'@odata.type' -replace '#microsoft.graph.', '' } else { 'desconhecido' }
            $uType = $rawA.principal.userType
            $mdInfo += "| $(Get-SafeMarkdown -Text $scope) | $(Get-SafeMarkdown -Text $displayName) | $upn | $acctEnabled | $pType | $uType |`n"
        }
        $mdInfo += "`n"
    }

    # Build map of all discovered apps for display
    $scopedAppsMap = @{ }
    foreach ($app in $paQaAppLookup.Values) {
        if ($app.appId) {
            $scopedAppsMap[$app.appId] = $app
        } elseif ($app.id) {
            $scopedAppsMap[$app.id] = $app
        }
    }
    foreach ($app in $appLookup.Values) {
        if ($app.appId) {
            $scopedAppsMap[$app.appId] = $app
        } elseif ($app.id) {
            $scopedAppsMap[$app.id] = $app
        }
    }
    foreach ($sp in $spLookup.Values) {
        if ($sp.appId) {
            if (-not $scopedAppsMap.ContainsKey($sp.appId)) {
                if ($appLookup.ContainsKey($sp.appId)) {
                    $scopedAppsMap[$sp.appId] = $appLookup[$sp.appId]
                } else {
                    $scopedAppsMap[$sp.appId] = [PSCustomObject]@{
                        displayName = $sp.displayName
                        appId = $sp.appId
                        id = $null
                        tags = @()
                    }
                }
            }
        }
    }

    # Scoped Apps section
    if ($scopedAppsMap.Count -gt 0) {
        $mdInfo += "`n## Apps escopadas:`n`n"
        $mdInfo += "| Nome do app | appId / servicePrincipalId | Tags (inclui PA/QA?) |`n"
        $mdInfo += "| :--- | :--- | :--- |`n"
        foreach ($app in $scopedAppsMap.Values) {
            $display = if ($app.displayName) {
                $(Get-SafeMarkdown -Text $app.displayName)
            } else {
                'Desconhecido'
            }
            $id = if ($app.appId) {
                $app.appId
            } elseif ($app.id) {
                $app.id
            } else {
                ''
            }
            $tags = if ($app.tags) {
                ($app.tags -join ', ')
            } else {
                ''
            }
            $paqa = if ($app.tags -and (($app.tags -contains 'PrivateAccessNonWebApplication') -or ($app.tags -contains 'NetworkAccessQuickAccessApplication'))) {
                '✅'
            } else {
                '❌'
            }
            $mdInfo += "| $display | $id | $tags $paqa |`n"
        }
        $mdInfo += "`n"
    }

    # Tenant-Wide Assignments
    if ($tenantWideAssignments.Count -gt 0) {
        $mdInfo += "`n## ❌ Atribuições em todo o locatário`n`n"
        $mdInfo += "As seguintes atribuições do Application Administrator têm escopo em todo o locatário e devem ser restritas:`n`n"
        $mdInfo += "| Principal | Tipo | Tipo de usuário | Escopo |`n"
        $mdInfo += "| :--- | :--- | :--- | :--- |`n"
        foreach ($a in $tenantWideAssignments) {
            $principalName = if ($a.PrincipalUPN) { $a.PrincipalUPN } else { $a.PrincipalDisplayName }
            $mdInfo += "| $(Get-SafeMarkdown -Text $principalName) | $($a.PrincipalType) | $($a.UserType) | Abrangência do locatário (/) |`n"
        }
        $mdInfo += "`n"
    }

    # Problematic Assignments
    if ($problematicAssignments.Count -gt 0) {
        $mdInfo += "`n## ❌ Atribuições problemáticas de principal`n`n"
        $mdInfo += "As seguintes atribuições usam grupos, service principals ou usuários convidados:`n`n"
        $mdInfo += "| Principal | Tipo | Tipo de usuário | Escopo |`n"
        $mdInfo += "| :--- | :--- | :--- | :--- |`n"
        foreach ($a in $problematicAssignments) {
            $principalName = if ($a.PrincipalUPN) { $a.PrincipalUPN } else { $a.PrincipalDisplayName }
            $scope = if ($a.DirectoryScopeId -eq '/') { 'Abrangência do locatário (/)' } else { 'Escopado' }
            $mdInfo += "| $(Get-SafeMarkdown -Text $principalName) | $($a.PrincipalType) | $($a.UserType) | $scope |`n"
        }
        $mdInfo += "`n"
    }

    # Scoped Assignments
    if ($scopedAssignments.Count -gt 0) {
        $mdInfo += "`n## ✅ Atribuições escopadas`n`n"
        $mdInfo += "As seguintes atribuições do Application Administrator estão escopadas a aplicações específicas:`n`n"
        $mdInfo += "| Principal | Tipo | Aplicação | App PA/QA |`n"
        $mdInfo += "| :--- | :--- | :--- | :---: |`n"
        foreach ($a in $scopedAssignments | Sort-Object PrincipalDisplayName) {
            $principalName = if ($a.PrincipalUPN) { $a.PrincipalUPN } else { $a.PrincipalDisplayName }
            $appName = if ($a.AppDisplayName) { $a.AppDisplayName } else { 'Aplicativo desconhecido' }
            $paIcon = if ($a.IsPAApp) { '✅' } else { '❌' }
            $mdInfo += "| $(Get-SafeMarkdown -Text $principalName) | $($a.PrincipalType) | $(Get-SafeMarkdown -Text $appName) | $paIcon |`n"
        }
        $mdInfo += "`n"
    }

    # Warnings
    if ($warnings.Count -gt 0) {
        $mdInfo += "`n## ⚠️ Avisos`n`n"
        foreach ($warning in $warnings) {
            $mdInfo += "- $warning`n"
        }
        $mdInfo += "`n"
    }

    if ($unresolvedScopedAssignments.Count -gt 0) {
        $mdInfo += "`n## ⚠️ Atribuições escopadas não resolvidas`n`n"
        $mdInfo += "As seguintes atribuições escopadas referenciam objetos de aplicativo ou service principal que não puderam ser resolvidos:`n`n"
        $mdInfo += "| Principal | Tipo | Tipo de destino do escopo | DirectoryScopeId |`n"
        $mdInfo += "| :--- | :--- | :--- | :--- |`n"
        foreach ($a in $unresolvedScopedAssignments | Sort-Object PrincipalDisplayName) {
            $principalName = if ($a.PrincipalUPN) { $a.PrincipalUPN } else { $a.PrincipalDisplayName }
            $scope = if ($a.DirectoryScopeId) { $a.DirectoryScopeId } else { 'Desconhecido' }
            $scopeTargetKind = 'Desconhecido'
            if ($scope -match '^/servicePrincipals/') {
                $scopeTargetKind = 'servicePrincipal'
            } elseif ($scope -match '^/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') {
                $scopeTargetKind = 'application'
            }
            $mdInfo += "| $(Get-SafeMarkdown -Text $principalName) | $($a.PrincipalType) | $scopeTargetKind | $(Get-SafeMarkdown -Text $scope) |`n"
        }
        $mdInfo += "`n"
    }

    # Portal Link
    $portalLink = "https://entra.microsoft.com/#view/Microsoft_AAD_IAM/AllRolesBlade"
    $portalLinkText = Get-SafeMarkdown -Text "Ver no Portal do Entra: Funções e administradores"
    $mdInfo += "`n[$portalLinkText]($portalLink)"

    $testResultMarkdown = $mdInfo
    #endregion Report Generation

    $params = @{
        TestId = '25384'
        Title  = 'Os direitos de administrador de aplicação são restritos a apps Private Access específicos, não em todo o locatário'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
