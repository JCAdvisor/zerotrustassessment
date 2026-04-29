function Resolve-ZtPillarName {
	<#
	.SYNOPSIS
	Normalizes pillar names from Portuguese or English to English canonical form.

	.DESCRIPTION
	Converts Portuguese pillar names to their English equivalents for consistent processing.
	Supports both single values and arrays.

	.PARAMETER Pillar
	The pillar name to normalize. Can be in Portuguese or English.
	Supported values: 'Identity', 'Identidade', 'Network', 'Rede', 'Devices', 'Dispositivos', 'Data', 'Dados', 'All'

	.EXAMPLE
	Resolve-ZtPillarName -Pillar 'Identidade'
	Returns: 'Identity'

	.EXAMPLE
	'Identidade', 'Rede' | Resolve-ZtPillarName
	Returns: 'Identity', 'Network'
	#>
	[CmdletBinding()]
	param(
		[Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[string]
		$Pillar
	)

	process {
		$normalizationMap = @{
			'Identity'     = 'Identity'
			'Identidade'   = 'Identity'
			'Network'      = 'Network'
			'Rede'         = 'Network'
			'Devices'      = 'Devices'
			'Dispositivos' = 'Devices'
			'Data'         = 'Data'
			'Dados'        = 'Data'
			'All'          = 'All'
		}

		if ($normalizationMap.ContainsKey($Pillar)) {
			$normalizationMap[$Pillar]
		} else {
			Write-PSFMessage -Level Warning -Message "Unknown pillar name: $Pillar. Returning as-is." -Target $Pillar
			$Pillar
		}
	}
}
