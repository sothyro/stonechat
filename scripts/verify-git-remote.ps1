# Ensure Git remote points to Stonechat repository.
# Run from project root: .\scripts\verify-git-remote.ps1

$correctUrl = "https://github.com/sothyro/stonechat.git"
$projectRoot = Split-Path -Parent $PSScriptRoot

Push-Location $projectRoot
try {
    $current = git remote get-url origin 2>$null
    if ($current -ne $correctUrl) {
        Write-Host "Updating origin from: $current"
        git remote set-url origin $correctUrl
        Write-Host "Set origin to: $correctUrl"
    }
    Write-Host "`nCurrent remotes:"
    git remote -v
} finally {
    Pop-Location
}
