param()

# Bash equivalent: read JSON from stdin, parse tool_name, exit 0 to allow or 1 to block

$inputJson = [Console]::In.ReadToEnd()
$inputData = $inputJson | ConvertFrom-Json -ErrorAction SilentlyContinue

$toolName = $inputData.tool_name
$command  = $inputData.tool_input.command

$readOnlyTools = @("Read", "Glob", "Grep", "LS", "WebFetch", "WebSearch")
if ($toolName -in $readOnlyTools) {
    exit 0
}

$dangerousPatterns = @("rm -rf", "Remove-Item -Recurse -Force", "DROP TABLE", "DROP DATABASE", "git push --force", "format")
foreach ($pattern in $dangerousPatterns) {
    if ($command -and $command.Contains($pattern)) {
        $response = @{ decision = "block"; reason = "Blocked dangerous pattern: '$pattern'" } | ConvertTo-Json
        Write-Output $response
        exit 1
    }
}

exit 0
