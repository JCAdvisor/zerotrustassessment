<#
.SYNOPSIS
Testa se todos os usuários convidados possuem padrinhos (sponsors) atribuídos no tenant.
#>

function Test-Assessment-21877 {
    [ZtTest(
    	Category = 'Gerenciamento de aplicativos',
    	ImplementationCost = 'Médio',
    	MinimumLicense = ('Free'),
    	Pillar = 'Identidade',
    	RiskLevel = 'Médio',
    	SfiPillar = 'Proteger tenants e isolar sistemas de produção',
    	TenantType = ('Workforce','External'),
    	TestId = 21877,
    	Title = 'Todos os convidados possuem um padrinho',
    	UserImpact = 'Médio'
    )]
    [CmdletBinding()]
    param(
        $Database
    )

    Write-PSFMessage '🟦 Início' -Tag Test -Level VeryVerbose
    if ((Get-MgContext).Environment -ne 'Global') {
        Write-PSFMessage "Este teste é aplicável apenas ao ambiente Global." -Tag Test -Level VeryVerbose
        return
    }

    $activity = "Verificando se todos os convidados possuem um padrinho"
    Write-ZtProgress -Activity $activity -Status "Obtendo usuários convidados"

    # Buscar todos os usuários convidados
    $sqlGuests = @"
SELECT id, userPrincipalName, displayName, userType
FROM User
WHERE userType = 'Guest'
"@
    $guestUsers = Invoke-DatabaseQuery -Database $Database -Sql $sqlGuests
    $totalGuestCount = $guestUsers.Count

    # Retorno antecipado se não existirem convidados
    if ($totalGuestCount -eq 0) {
        $testParams = @{
            TestId             = '21877'
            Title              = 'Todos os convidados possuem um padrinho'
            UserImpact         = 'Medium'
            Risk               = 'Medium'
            ImplementationCost = 'Médio'
            AppliesTo          = 'Identity'
            Tag                = 'Identity'
            Status             = $true
            Result             = "✅ Nenhuma conta de convidado encontrada no tenant."
        }
        Add-ZtTestResultDetail @testParams
        return
    }

    Write-ZtProgress -Activity $activity -Status "Verificando padrinhos para $totalGuestCount usuários convidados"

    # Processar convidados e verificar padrinhos de forma eficiente
    $guestsWithoutSponsors = [System.Collections.Generic.List[object]]::new()
    $guestsWithSponsorsCount = 0

    foreach ($guest in $guestUsers) {
        try {
            # Obter os padrinhos para o usuário convidado
            $guestUserWithSponsors = Invoke-ZtGraphRequest -RelativeUri "users/$($guest.id)?`$expand=sponsors" -ApiVersion 'v1.0'

            # Verificar se o convidado tem padrinhos
            if ($guestUserWithSponsors.sponsors -and $guestUserWithSponsors.sponsors.Count -gt 0) {
                $guestsWithSponsorsCount++
            }
            else {
                $guestsWithoutSponsors.Add($guestUserWithSponsors)
            }
        }
        catch {
            Write-PSFMessage "Falha ao obter padrinhos para o convidado $($guest.userPrincipalName): $($_.Exception.Message)" -Level Verbose
            # Tratar como convidado sem padrinho se a chamada da API falhar
            $guestsWithoutSponsors.Add($guest)
        }
    }

    $guestsWithoutSponsorsCount = $guestsWithoutSponsors.Count
    $passed = $guestsWithoutSponsorsCount -eq 0

    # Construir markdown de resultado
    if ($passed) {
        $testResultMarkdown = "✅ Todas as contas de convidados no tenant possuem um padrinho atribuído."
    }
    else {
        # Construir linhas da tabela de forma eficiente usando StringBuilder
        $tableRowsBuilder = [System.Text.StringBuilder]::new()

        foreach ($guest in $guestsWithoutSponsors) {
            $portalLink = 'https://entra.microsoft.com/#view/Microsoft_AAD_UsersAndTenants/UserProfileMenuBlade/~/overview/userId/{0}/hidePreviewBanner~/true' -f $guest.id
            $displayName = Get-SafeMarkdown $guest.displayName
            [void]$tableRowsBuilder.AppendLine("| [$displayName]($portalLink) | $($guest.userPrincipalName) |")
        }

        $detailedReport = @"
## Usuários convidados sem padrinhos

- Contagem total de convidados no tenant: $totalGuestCount
- Contagem total de convidados com padrinhos: $guestsWithSponsorsCount
- Contagem total de convidados sem padrinhos: $guestsWithoutSponsorsCount

| Nome de Exibição do Usuário | User Principal Name |
| :---------------- | :------------------ |
$($tableRowsBuilder.ToString())
"@

        $testResultMarkdown = "❌ Uma ou mais contas de convidados não possuem padrinho registrado.`n`n$detailedReport"
    }

    $testParams = @{
        TestId             = '21877'
        Title              = 'Todos os convidados possuem um padrinho'
        UserImpact         = 'Medium'
        Risk               = 'Medium'
        ImplementationCost = 'Médio'
        AppliesTo          = 'Identity'
        Tag                = 'Identity'
        Status             = $passed
        Result             = $testResultMarkdown
    }
    Add-ZtTestResultDetail @testParams
}
