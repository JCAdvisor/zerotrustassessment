function Resolve-ZtLevelName {
	<#
	.SYNOPSIS
	Normalizes level names from Portuguese or English to English canonical form.

	.DESCRIPTION
	Converts Portuguese level names to their English equivalents for consistent processing.
	Supports RiskLevel, ImplementationCost, and UserImpact parameters.

	.PARAMETER Level
	The level name to normalize. Can be in Portuguese or English.
	Supported values: 'Low', 'Baixo', 'Medium', 'Médio', 'High', 'Alto'

	.EXAMPLE
	Resolve-ZtLevelName -Level 'Médio'
	Returns: 'Medium'

	.EXAMPLE
	'Baixo', 'Alto' | Resolve-ZtLevelName
	Returns: 'Low', 'High'
	#>
	[CmdletBinding()]
	param(
		[Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[string]
		$Level
	)

	process {
		$normalizationMap = @{
			'Low'     = 'Low'
			'Baixo'   = 'Low'
			'Medium'  = 'Medium'
			'Médio'   = 'Medium'
			'High'    = 'High'
			'Alto'    = 'High'
		}

		if ($normalizationMap.ContainsKey($Level)) {
			$normalizationMap[$Level]
		} else {
			Write-PSFMessage -Level Warning -Message "Unknown level name: $Level. Returning as-is." -Target $Level
			$Level
		}
	}
}
