<#
Reload tests for Zero Trust Assessment module and list registered test commands.
Run from repository root with: pwsh -NoProfile -ExecutionPolicy Bypass ./scripts/reload-tests.ps1
#>

Write-Host "Reloading ZeroTrustAssessment tests..." -ForegroundColor Cyan

# 1) Unblock test scripts (safe for local repo)
Write-Host "Unblocking test scripts..." -ForegroundColor DarkGray
Get-ChildItem -Path .\src\powershell\tests -Recurse -Include *.ps1,*.psm1,*.psd1 -ErrorAction SilentlyContinue | ForEach-Object { Unblock-File -Path $_.FullName -ErrorAction SilentlyContinue }

# 2) Ensure native DuckDB DLLs are discoverable and load managed assemblies if present
$libPath = (Resolve-Path .\src\powershell\lib -ErrorAction SilentlyContinue).ProviderPath
if ($libPath -and (Test-Path $libPath)) {
    Write-Host "Updating PATH to include: $libPath" -ForegroundColor DarkGray
    $env:PATH = "$libPath;$env:PATH"
    try {
        $duckManaged = Join-Path $libPath 'DuckDB.NET.Data.dll'
        $duckBindings = Join-Path $libPath 'DuckDB.NET.Bindings.dll'
        if (Test-Path $duckManaged) { [System.Reflection.Assembly]::LoadFrom($duckManaged) | Out-Null }
        if (Test-Path $duckBindings) { [System.Reflection.Assembly]::LoadFrom($duckBindings) | Out-Null }
    }
    catch {
        Write-Host "Warning: failed to preload DuckDB assemblies: $_" -ForegroundColor Yellow
    }
}
else {
    Write-Host "Warning: lib path not found at src/powershell/lib" -ForegroundColor Yellow
}

# 3) Import module via manifest
Write-Host "Importing ZeroTrustAssessment module..." -ForegroundColor DarkGray
Import-Module .\src\powershell\ZeroTrustAssessment.psd1 -Force -Verbose -ErrorAction Stop

# 4) Reload tests into module scope
Write-Host "Updating test metadata and loading tests into module scope..." -ForegroundColor DarkGray
try {
    Update-ZtTestMetadata
}
catch {
    Write-Host "Update-ZtTestMetadata failed: $_" -ForegroundColor Red
    exit 1
}

# 5) Show results
Write-Host "\nRegistered test commands:" -ForegroundColor Cyan
Get-Command 'Test-Assessment-*' -Module ZeroTrustAssessment | Select-Object Name | Format-Table -AutoSize

Write-Host "\nAvailable test metadata (sample):" -ForegroundColor Cyan
Get-ZtTest | Select-Object -First 30 TestId, Title | Format-Table -AutoSize

Write-Host "\nCheck for Invoke-ZtTest command:" -ForegroundColor Cyan
Get-Command Invoke-ZtTest -Module ZeroTrustAssessment -ErrorAction SilentlyContinue | Format-Table -AutoSize

Write-Host "\nDone." -ForegroundColor Green
