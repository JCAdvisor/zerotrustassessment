
<#
.SYNOPSIS

#>



function Test-Assessment-24823 {
    [ZtTest(
    	Category = 'Locatário',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('Intune'),
    	Pillar = 'Dispositivos',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger locatários e isolar sistemas de produção',
    	TenantType = ('Workforce'),
    	TestId = 24823,
    	Title = 'Configurações de marca e suporte do Company Portal melhoram a experiência e a confiança do usuário',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    # Funções auxiliares
    function Test-PolicyAssignment {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $false)]
            [array]$Policies
        )

        # Retorna falso se $Policies for nulo ou vazio
        if (-not $Policies) {
            return $false
        }

        # Verifica se pelo menos uma política possui atribuições
        $assignedPolicies = $Policies | Where-Object {
            $_.PSObject.Properties.Match("assignments") -and $_.assignments -and $_.assignments.Count -gt 0
        }

        return $assignedPolicies.Count -gt 0
    }
    #endregion Helper Functions

    #region Coleta de Dados
    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    if( -not (Get-ZtLicense Intune) ) {
        Add-ZtTestResultDetail -SkippedBecause NotLicensedIntune
        return
    }

    $activity = "Verificando se as configurações de marca e suporte do Company Portal estão personalizadas"
    Write-ZtProgress -Activity $activity -Status "Obtendo perfis de marca"

    # Recuperar a configuração de todos os perfis de marca do Company Portal
    $brandingProfiles_Uri = "deviceManagement/intuneBrandingProfiles?`$select=id,isDefaultProfile,profileName,displayName,contactITPhoneNumber,contactITEmailAddress"
    $brandingProfiles = Invoke-ZtGraphRequest -RelativeUri $brandingProfiles_Uri -ApiVersion beta

    # Inicializar variáveis para perfis padrão e não padrão
    $defaultProfile = $null
    $nonDefaultProfiles = @()

    # Separar perfis padrão e não padrão usando switch
    foreach ($brandingProfile in $brandingProfiles) {
        switch ($brandingProfile.isDefaultProfile) {
            $true {
                $defaultProfile = $brandingProfile
            }
            $false {
                $nonDefaultProfiles += $brandingProfile
            }
        }
    }

    # Buscar atribuições para perfis não padrão
    $nonDefaultProfilesWithAssignments = @()
    foreach ($brandingProfile in $nonDefaultProfiles) {
        Write-ZtProgress -Activity $activity -Status "Obtendo atribuições para o perfil: $($brandingProfile.profileName)"

        $assignmentsUri = "deviceManagement/intuneBrandingProfiles/{0}/assignments" -f $brandingProfile.id
        $assignments = Invoke-ZtGraphRequest -RelativeUri $assignmentsUri -ApiVersion beta

        $isAssigned = $false
        if ($assignments -and $assignments.Count -gt 0) {
            $isAssigned = $true
        }

        # Adicionar informações de atribuição ao objeto de perfil
        $profileWithAssignments = $brandingProfile |
            Add-Member -NotePropertyName 'assignments' -NotePropertyValue $assignments -Force -PassThru |
                Add-Member -NotePropertyName 'isAssigned' -NotePropertyValue $isAssigned -Force -PassThru

        $nonDefaultProfilesWithAssignments += $profileWithAssignments
    }

    #endregion Data Collection

    #region Assessment Logic
    $passed = $false
    $testResultMarkdown = ""

    # Verificar se o perfil padrão possui todas as propriedades de marca obrigatórias
    $defaultProfileHasAllProperties = $false
    if ($defaultProfile) {
        $defaultProfileHasAllProperties = ($defaultProfile.displayName -and
            $defaultProfile.contactITPhoneNumber -and
            $defaultProfile.contactITEmailAddress)
    }

    # Verificar se algum perfil não padrão possui todas as propriedades de marca e está devidamente atribuído
    $nonDefaultProfilesWithAllProperties = $false
    if ($nonDefaultProfilesWithAssignments.Count -gt 0) {
        # Filtrar perfis que tenham todas as propriedades de marca
            $_.displayName -and $_.contactITPhoneNumber -and $_.contactITEmailAddress
        }

    # Usar a função Test-PolicyAssignment para verificar se algum desses perfis está atribuído
    $nonDefaultProfilesWithAllProperties = Test-PolicyAssignment -Policies $profilesWithAllProperties


    # Passa se o perfil padrão tiver todas as propriedades OU qualquer perfil não padrão tiver todas as propriedades e estiver atribuído
    $passed = $defaultProfileHasAllProperties -or $nonDefaultProfilesWithAllProperties

    if ($passed) {
        $testResultMarkdown = "Pelo menos um perfil de marca do Company Portal com configurações de suporte existe e está atribuído. Ou o perfil de marca personalizado padrão possui as propriedades necessárias.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "Nenhum perfil de marca do Company Portal com configurações de suporte existe ou nenhum está atribuído.`n`n%TestResult%"
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    # Construir as seções detalhadas do markdown

    # Função auxiliar para criar um resumo das propriedades de marca
    function Get-BrandingPropertiesSummary {
        param($BrandingProfile)

        $brandingProperties = @()
        if ($BrandingProfile.displayName) {
            $brandingProperties += "**Nome do Perfil**: $($BrandingProfile.displayName)"
        }
        else {
            $brandingProperties += "**Nome do Perfil**: Não configurado"
        }
        if ($BrandingProfile.contactITPhoneNumber) {
            $brandingProperties += "**Telefone de Contato**: $($BrandingProfile.contactITPhoneNumber)"
        }
        else {
            $brandingProperties += "**Telefone de Contato**: Não configurado"
        }
        if ($BrandingProfile.contactITEmailAddress) {
            $brandingProperties += "**Email de Contato**: $($BrandingProfile.contactITEmailAddress)"
        }
        else {
            $brandingProperties += "**Email de Contato**: Não configurado"
        }

        if ($brandingProperties.Count -gt 0) {
            $brandingProperties -join ", "
        }
    }

    # Definir variáveis para inserir na string de formato
    $reportTitle = "Perfis de Marca do Company Portal"
    $tableRows = ""

    # Criar uma única tabela com todos os perfis
    $formatTemplate = @'

## {0}

| Nome do Perfil | Propriedades de Marca | Status | Alvo de Atribuição |
| :----------- | :------------------ | :----- | :---------------- |
{1}

'@

    # Combinar todos os perfis para processamento
    $allProfiles = @()
    if ($defaultProfile) {
        $allProfiles += $defaultProfile
    }
    $allProfiles += $nonDefaultProfilesWithAssignments

    # Processar todos os perfis em um único loop
    foreach ($brandingProfile in $allProfiles) {

        $profileName = $brandingProfile.profileName

        $portalLink = 'https://intune.microsoft.com/#view/Microsoft_Intune_DeviceSettings/TenantAdminMenu/~/companyPortalBranding'

        $brandingPropertiesText = Get-BrandingPropertiesSummary -BrandingProfile $brandingProfile

        if ($brandingProfile.isDefaultProfile) {
            $status = "N/A"
            $assignmentTarget = "N/A"
        }
        else {
            $status = if ($brandingProfile.isAssigned) {
                "✅ Atribuído"
            }
            else {
                "❌ Não atribuído"
            }
            $assignmentTarget = Get-PolicyAssignmentTarget -Assignments $brandingProfile.assignments
        }

        $tableRows += @"
| [$(Get-SafeMarkdown($profileName))]($portalLink) | $(Get-SafeMarkdown($brandingPropertiesText)) | $status | $assignmentTarget |`n
"@
    }

    # Formatar o template substituindo os placeholders pelos valores
    $mdInfo = $formatTemplate -f $reportTitle, $tableRows

    # Substituir o placeholder pelas informações detalhadas
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '24823'
        Status = $passed
        Result = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
