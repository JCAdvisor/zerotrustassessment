# To give a module-wide constant point of reference
$script:ModuleRoot = $PSScriptRoot
[string[]] $script:ConnectedService = @()
[string[]] $script:CurrentLicense = @()

# Load PowerShell Classes
foreach ($file in Get-ChildItem -Path "$script:ModuleRoot\classes" -Recurse -Filter "*.ps1") {
	try { . $file.FullName }
	catch { Write-PSFMessage -Level Error -Message "Failed to import file {0}" -StringValues $file.FullName -ErrorRecord $_ -Target $file }
}

# Load Non-Public commands
foreach ($file in Get-ChildItem -Path "$script:ModuleRoot\private" -Recurse -Filter "*.ps1") {
	try { . $file.FullName }
	catch { Write-PSFMessage -Level Error -Message "Failed to import file {0}" -StringValues $file.FullName -ErrorRecord $_ -Target $file }
}

# Load Public commands
foreach ($file in Get-ChildItem -Path "$script:ModuleRoot\public" -Recurse -Filter "*.ps1") {
	try { . $file.FullName }
	catch { Write-PSFMessage -Level Error -Message "Failed to import file {0}" -StringValues $file.FullName -ErrorRecord $_ -Target $file }
}

# Execute Startup scripts
foreach ($file in Get-ChildItem -Path "$script:ModuleRoot\scripts" -Recurse -Filter "*.ps1") {
	try { . $file.FullName }
	catch { Write-PSFMessage -Level Error -Message "Failed to import file {0}" -StringValues $file.FullName -ErrorRecord $_ -Target $file }
}

# Load assessment test commands required by Invoke-ZtAssessment.
# These are not Pester tests and must be available during normal module import.
$assessmentTestScripts = Get-ChildItem -Path "$script:ModuleRoot\tests" -Recurse -Filter "Test-Assessment.*.ps1"
foreach ($file in $assessmentTestScripts) {
	$tokens = $null
	$parseErrors = $null
	$null = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)
	if ($parseErrors.Count -gt 0) {
		Write-PSFMessage -Level Verbose -Message "Skipping test script with parser errors: {0}" -StringValues $file.FullName
		continue
	}

	try { . $file.FullName }
	catch { Write-PSFMessage -Level Error -Message "Failed to import file {0}" -StringValues $file.FullName -ErrorRecord $_ -Target $file }
}

# Optionally import all test scripts in development sessions.
# Set environment variable `ZTA_INCLUDE_TESTS=1` when you need test-only scripts.
if ($env:ZTA_INCLUDE_TESTS -eq '1') {
	$assessmentScriptPaths = @($assessmentTestScripts.FullName)
	foreach ($file in Get-ChildItem -Path "$script:ModuleRoot\tests" -Recurse -Filter "*.ps1") {
		if ($file.FullName -in $assessmentScriptPaths) {
			continue
		}

		$tokens = $null
		$parseErrors = $null
		$null = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)
		if ($parseErrors.Count -gt 0) {
			Write-PSFMessage -Level Verbose -Message "Skipping test script with parser errors: {0}" -StringValues $file.FullName
			continue
		}

		try { . $file.FullName }
		catch { Write-PSFMessage -Level Error -Message "Failed to import file {0}" -StringValues $file.FullName -ErrorRecord $_ -Target $file }
	}
}
