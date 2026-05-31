param()

# Bash equivalent:
# git diff --name-only HEAD | xargs grep -l "TODO\|FIXME\|HACK" 2>/dev/null

$inputJson = [Console]::In.ReadToEnd()

$changedFiles = & git diff --name-only HEAD 2>$null
$warnings = @()

foreach ($file in $changedFiles) {
    if (-not (Test-Path $file)) { continue }
    $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
    if ($content -match "TODO|FIXME|HACK") {
        $warnings += $file
    }
}

if ($warnings.Count -gt 0) {
    Write-Host "Unresolved markers in changed files:"
    $warnings | ForEach-Object { Write-Host "  $_" }
}

exit 0
