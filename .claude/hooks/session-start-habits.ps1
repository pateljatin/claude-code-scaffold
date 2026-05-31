param()

# Bash equivalent:
# STAMP="/tmp/claude-session-${SESSION_ID}.started"
# [ -f "$STAMP" ] || { touch "$STAMP"; echo "...habits..."; }

$inputJson = [Console]::In.ReadToEnd()
$inputData = $inputJson | ConvertFrom-Json -ErrorAction SilentlyContinue

$sessionId  = $inputData.session_id
$stampFile  = "$env:TEMP\claude-session-$sessionId.started"

if (-not (Test-Path $stampFile)) {
    New-Item -ItemType File -Path $stampFile -Force | Out-Null

    Write-Host @'
Session habits:
  - Propose model+effort before every task
  - Suggest /compact at 70% context
  - One task per conversation
  - /btw for side questions that shouldn't enter history
'@
}

exit 0
