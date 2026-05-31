param()

# Bash equivalent: see inline comments

$inputJson = [Console]::In.ReadToEnd()
$inputData = $inputJson | ConvertFrom-Json -ErrorAction SilentlyContinue

$banned = @(
    [char]0x2014,        # em-dash (U+2014)
    "AI-powered",
    "leverage",
    "seamless",
    "robust",
    "revolutionary",
    "transformative",
    "ecosystem"
)

$text = ""
if ($inputData.tool_input) {
    $text = ($inputData.tool_input | ConvertTo-Json -Depth 10 -Compress)
}

foreach ($word in $banned) {
    if ($text.Contains($word)) {
        $response = @{ decision = "block"; reason = "Banned word or pattern detected: '$word'" } | ConvertTo-Json
        Write-Output $response
        exit 2
    }
}

exit 0
