<#
.SYNOPSIS

#>

function Test-Assessment-21848 {
    [ZtTest(
    	Category = 'Gerenciamento de credenciais',
    	ImplementationCost = 'Baixo',
    	MinimumLicense = ('P1'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger identidades e segredos',
    	TenantType = ('Workforce','External'),
    	TestId = 21848,
    	Title = 'Adicionar termos organizacionais à lista de senhas banidas',
    	UserImpact = 'Baixo'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose

    #region Coleta de Dados
    $activity = "Verificando se as senhas banidas personalizadas estão habilitadas"
    Write-ZtProgress -Activity $activity -Status "Obtendo política"

    # Recupera as configurações de proteção de senha
    $settings = Invoke-ZtGraphRequest -RelativeUri "settings" -ApiVersion beta

    if ($settings) {
        # O ID de modelo '5cf42378-d67d-4f36-ba46-e8b86229381d' é específico para configurações de proteção de senha
        $passwordProtectionSettings = $settings | Where-Object { $_.templateId -eq '5cf42378-d67d-4f36-ba46-e8b86229381d' }
    }
    else {
        $passwordProtectionSettings = $null
    }
    #endregion Coleta de Dados

    #region Lógica de Avaliação
    $passed = $false
    if ($null -ne $passwordProtectionSettings) {
        $enableBannedPasswordCheck = ($passwordProtectionSettings.values | Where-Object { $_.name -eq "EnableBannedPasswordCheck" }).value -eq "True"
        $bannedPasswordList = ($passwordProtectionSettings.values | Where-Object { $_.name -eq "BannedPasswordList" }).value
        
        if ($enableBannedPasswordCheck -and -not [string]::IsNullOrEmpty($bannedPasswordList)) {
            $passed = $true
        }
    }

    $testResultMarkdown = ""
    if ($passed) {
        $testResultMarkdown = "✅ **Passou**: A lista de senhas banidas personalizada está habilitada e contém termos.`n%TestResult%"
    }
    else {
        $testResultMarkdown = "❌ **Falha**: A lista de senhas banidas personalizada não está habilitada ou está vazia.`n%TestResult%"
    }
    #endregion Lógica de Avaliação

    #region Geração de Relatório
    $reportTitle = "Configurações de Senhas Banidas Personalizadas"
    $tableRows = ""

    $formatTemplate = @'

## {0}

| Imposto | Lista de Senhas Banidas (Amostra) | Total de Termos |
| :--- | :--- | :--- |
{1}

'@

    $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_IAM/AuthenticationMethodsMenuBlade/~/PasswordProtection/fromNav/'

    $enforced = if ($enableBannedPasswordCheck) { "Sim" } else { "Não" }

    if ($bannedPasswordList) {
        $bannedPasswordArray = $bannedPasswordList -split '\t'
    }
    else {
        $bannedPasswordArray = @()
    }

    $maxDisplay = 10
    if ($bannedPasswordArray.Count -gt $maxDisplay) {
        $displayList = $bannedPasswordArray[0..($maxDisplay-1)] + "...e mais $($bannedPasswordArray.Count - $maxDisplay)"
    }
    else {
        $displayList = $bannedPasswordArray
    }

    $tableRows += @"
| [$enforced]($portalLink) | $($displayList -join ', ') | $($bannedPasswordArray.Count) |`n
"@

    $mdInfo = $formatTemplate -f $reportTitle, $tableRows
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Geração de Relatório

    $params = @{
        TestId = '21848'
        Status = $passed
        Result = $testResultMarkdown
    }
    Add-ZtTestResultDetail @params
}
