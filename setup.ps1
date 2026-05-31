#Requires -Version 5.1
<#
.SYNOPSIS
    Apply the claude-code-scaffold templates to an existing project directory.
.EXAMPLE
    .\setup.ps1
    .\setup.ps1 -Target C:\projects\my-app
#>
param(
    [string]$Target = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
$ScaffoldRoot = $PSScriptRoot

function Prompt-Required([string]$Question) {
    do {
        $answer = Read-Host $Question
    } while ([string]::IsNullOrWhiteSpace($answer))
    return $answer.Trim()
}

Write-Host "`nclaude-code-scaffold setup`n" -ForegroundColor Cyan

$projectName   = Prompt-Required "Project name (e.g. my-app)"
$authorName    = Prompt-Required "Your name or handle"
$description   = Prompt-Required "One-line project description"
$stack         = Prompt-Required "Primary stack (e.g. Next.js, Python/FastAPI, Go)"
$githubUser    = Prompt-Required "GitHub username"

Write-Host "`nTarget directory: $Target"
$confirm = Read-Host "Apply scaffold here? [y/N]"
if ($confirm -notmatch "^[yY]") {
    Write-Host "Aborted."
    exit 0
}

$dirs = @(
    ".claude\hooks",
    ".claude\commands",
    ".claude\agents",
    ".github\workflows",
    "docs\claude"
)
foreach ($d in $dirs) {
    New-Item -ItemType Directory -Path (Join-Path $Target $d) -Force | Out-Null
}

function Copy-AndSubstitute([string]$Src, [string]$Dst) {
    $content = Get-Content $Src -Raw -Encoding UTF8
    $content = $content `
        -replace "YOUR_PROJECT",        $projectName `
        -replace "YOUR_AUTHOR",         $authorName `
        -replace "YOUR_DESCRIPTION",    $description `
        -replace "YOUR_STACK",          $stack `
        -replace "YOUR_GITHUB_USERNAME",$githubUser
    [System.IO.File]::WriteAllText($Dst, $content, [System.Text.Encoding]::UTF8)
}

$fileMappings = @{
    "CLAUDE.md"                                          = "CLAUDE.md"
    ".claudeignore"                                      = ".claudeignore"
    ".claude\settings.json"                              = ".claude\settings.json"
    ".claude\hooks\post-compact-reinject.ps1"            = ".claude\hooks\post-compact-reinject.ps1"
    ".claude\hooks\banned-word-check.ps1"                = ".claude\hooks\banned-word-check.ps1"
    ".claude\hooks\stop-baseline-check.ps1"              = ".claude\hooks\stop-baseline-check.ps1"
    ".claude\hooks\permission-request-router.ps1"        = ".claude\hooks\permission-request-router.ps1"
    ".claude\hooks\session-start-habits.ps1"             = ".claude\hooks\session-start-habits.ps1"
    ".claude\commands\scaffold.md"                       = ".claude\commands\scaffold.md"
    ".claude\commands\new-feature.md"                    = ".claude\commands\new-feature.md"
    ".claude\commands\post-merge.md"                     = ".claude\commands\post-merge.md"
    ".claude\commands\commit-push-pr.md"                 = ".claude\commands\commit-push-pr.md"
    ".claude\commands\go.md"                             = ".claude\commands\go.md"
    ".claude\agents\verify-app.md"                       = ".claude\agents\verify-app.md"
    ".claude\agents\security-reviewer.md"                = ".claude\agents\security-reviewer.md"
    ".claude\agents\test-writer.md"                      = ".claude\agents\test-writer.md"
    ".github\workflows\claude-pr-assistant.yml"          = ".github\workflows\claude-pr-assistant.yml"
    "docs\claude\project-context.md"                    = "docs\claude\project-context.md"
    "docs\claude\architecture.md"                       = "docs\claude\architecture.md"
    "docs\claude\db-patterns.md"                        = "docs\claude\db-patterns.md"
    "docs\claude\security.md"                           = "docs\claude\security.md"
    "docs\claude\spec-rules.md"                         = "docs\claude\spec-rules.md"
}

foreach ($entry in $fileMappings.GetEnumerator()) {
    $src = Join-Path $ScaffoldRoot $entry.Key
    $dst = Join-Path $Target       $entry.Value
    Copy-AndSubstitute $src $dst
    Write-Host "  wrote $($entry.Value)"
}

# Append Claude-specific ignores to existing .gitignore, if any
$gitignorePath = Join-Path $Target ".gitignore"
$appendBlock = @"

# Claude Code (added by scaffold)
.claude/settings.local.json
.claude/worktrees/
.claude/shell-snapshots/
"@
if (Test-Path $gitignorePath) {
    $existing = Get-Content $gitignorePath -Raw
    if ($existing -notmatch "settings\.local\.json") {
        Add-Content -Path $gitignorePath -Value $appendBlock -Encoding UTF8
        Write-Host "  appended Claude entries to .gitignore"
    }
} else {
    Set-Content -Path $gitignorePath -Value $appendBlock.TrimStart() -Encoding UTF8
    Write-Host "  wrote .gitignore"
}

Write-Host "`nScaffold applied." -ForegroundColor Green

$createRepo = Read-Host "`nCreate GitHub repo '$githubUser/$projectName' now? [y/N]"
if ($createRepo -match "^[yY]") {
    & gh repo create "$githubUser/$projectName" --public --source $Target --remote origin --push
}

Write-Host "`nNext: open Claude Code in $Target and run /scaffold to finish configuration."
