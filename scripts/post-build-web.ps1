# Post-build script for Flutter web: inject cache-busting into index.html
# Run after: flutter build web
# Ensures each deployment loads fresh flutter_bootstrap.js instead of cached old version

param(
    [string]$BuildDir = "build/web"
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$buildWeb = Join-Path $projectRoot $BuildDir
$bootstrapPath = Join-Path $buildWeb "flutter_bootstrap.js"
$indexPath = Join-Path $buildWeb "index.html"

if (-not (Test-Path $bootstrapPath)) {
    Write-Error "flutter_bootstrap.js not found at $bootstrapPath. Run 'flutter build web' first."
}
if (-not (Test-Path $indexPath)) {
    Write-Error "index.html not found at $indexPath. Run 'flutter build web' first."
}

# Extract serviceWorkerVersion from flutter_bootstrap.js (changes every build)
$bootstrapContent = Get-Content $bootstrapPath -Raw
if ($bootstrapContent -match 'serviceWorkerVersion:\s*"(\d+)"') {
    $version = $Matches[1]
} else {
    # Fallback: use timestamp
    $version = [int][double]::Parse((Get-Date -UFormat %s))
    Write-Warning "Could not extract serviceWorkerVersion; using timestamp: $version"
}

# Inject cache-busting query param into index.html
$indexContent = Get-Content $indexPath -Raw
$oldScript = 'src="flutter_bootstrap.js"'
$newScript = "src=`"flutter_bootstrap.js?v=$version`""
if ($indexContent -match [regex]::Escape($oldScript)) {
    $indexContent = $indexContent -replace [regex]::Escape($oldScript), $newScript
    Set-Content $indexPath $indexContent -NoNewline
    Write-Host "Post-build: injected cache-busting v=$version into index.html"
} else {
    Write-Warning "flutter_bootstrap.js script tag not found in expected format; cache-busting may already be applied."
}

# Print build verification info
$versionJson = Join-Path $buildWeb "version.json"
if (Test-Path $versionJson) {
    $ver = Get-Content $versionJson | ConvertFrom-Json
    Write-Host "Build version: $($ver.version)+$($ver.build_number) (cache key: $version)"
}
