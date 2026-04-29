# Used in the Test-Functions to declare their metadata
class ZtTest : System.Attribute
{
	[string]$Category
	[ValidateSet('Low','Baixo','Medium','Médio','High','Alto')][string]$ImplementationCost
	[string[]]$MinimumLicense

	[string[]]$CompatibleLicense

	[string[]]$Service

	[string]$Pillar
	[ValidateSet('Low','Baixo','Medium','Médio','High','Alto')][string]$RiskLevel
	[string]$SfiPillar
	[ValidateSet('Workforce','External')][string[]]$TenantType
	[int]$TestId
	[string]$Title
	[ValidateSet('Low','Baixo','Medium','Médio','High','Alto')][string]$UserImpact

}
<#
Example Usage:

function Get-Test {
	[ZtTest(
		Category = 'Access control',
		ImplementationCost = 'Low',
		Pillar = 'Identity',
		RiskLevel = 'High',
		SfiPillar = "Protect identities and secrets",
		TenantType = ('Workforce', 'External'),
		TestId = 21786,
		Title = "User sign-in activity uses token protection",
		UserImpact = 'Low'
	)]
	[CmdletBinding()]
	param ()
}
#>
