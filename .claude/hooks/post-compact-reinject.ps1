param()

# Bash equivalent: cat .claude/context.md 2>/dev/null

$contextFile = Join-Path (Get-Location) ".claude\context.md"
if (Test-Path $contextFile) {
    Write-Output (Get-Content $contextFile -Raw)
}
