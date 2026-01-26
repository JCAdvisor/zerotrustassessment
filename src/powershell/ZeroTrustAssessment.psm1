# To give a module-wide constant point of reference
$script:ModuleRoot = $PSScriptRoot

# Load PowerShell Classes
# foreach ($file in Get-ChildItem -Path "$script:ModuleRoot\classes" -Recurse -Filter "*.ps1") {
foreach ($file in Get-ChildItem -Path "C:\Users\ArthurSilvaJC2Sec\Downloads\Assessement Zero Trust\Assessement Zero Trust\src\powershell\classes" -Recurse -Filter "*.ps1") {
	try { . $file.FullName }
	catch { Write-PSFMessage -Level Error -Message "Failed to import file {0}" -StringValues $file.FullName -ErrorRecord $_ -Target $file }
}

# Load Non-Public commands
# foreach ($file in Get-ChildItem -Path "$script:ModuleRoot\private" -Recurse -Filter "*.ps1") {
foreach ($file in Get-ChildItem -Path "C:\Users\ArthurSilvaJC2Sec\Downloads\Assessement Zero Trust\Assessement Zero Trust\src\powershell\private" -Recurse -Filter "*.ps1") {
	try { . $file.FullName }
	catch { Write-PSFMessage -Level Error -Message "Failed to import file {0}" -StringValues $file.FullName -ErrorRecord $_ -Target $file }
}

# Load Public commands
# foreach ($file in Get-ChildItem -Path "$script:ModuleRoot\public" -Recurse -Filter "*.ps1") {
foreach ($file in Get-ChildItem -Path "C:\Users\ArthurSilvaJC2Sec\Downloads\Assessement Zero Trust\Assessement Zero Trust\src\powershell\public" -Recurse -Filter "*.ps1") {
	try { . $file.FullName }
	catch { Write-PSFMessage -Level Error -Message "Failed to import file {0}" -StringValues $file.FullName -ErrorRecord $_ -Target $file }
}

# Execute Startup scripts
# foreach ($file in Get-ChildItem -Path "$script:ModuleRoot\scripts" -Recurse -Filter "*.ps1") {
foreach ($file in Get-ChildItem -Path "C:\Users\ArthurSilvaJC2Sec\Downloads\Assessement Zero Trust\Assessement Zero Trust\src\powershell\scripts" -Recurse -Filter "*.ps1") {
	try { . $file.FullName }
	catch { Write-PSFMessage -Level Error -Message "Failed to import file {0}" -StringValues $file.FullName -ErrorRecord $_ -Target $file }
}

# Ready the Tests
# foreach ($file in Get-ChildItem -Path "$script:ModuleRoot\tests" -Recurse -Filter "*.ps1") {
foreach ($file in Get-ChildItem -Path "C:\Users\ArthurSilvaJC2Sec\Downloads\Assessement Zero Trust\Assessement Zero Trust\src\powershell\tests" -Recurse -Filter "*.ps1") {
	try { . $file.FullName }
	catch { Write-PSFMessage -Level Error -Message "Failed to import file {0}" -StringValues $file.FullName -ErrorRecord $_ -Target $file }
}
