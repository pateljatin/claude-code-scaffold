#!/usr/bin/env bash
# Apply the claude-code-scaffold templates to an existing project directory.
# Usage: ./setup.sh [target-directory]
set -euo pipefail

SCAFFOLD_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-$(pwd)}"

prompt_required() {
    local question="$1"
    local answer=""
    while [[ -z "$answer" ]]; do
        read -rp "$question: " answer
    done
    echo "$answer"
}

echo ""
echo "claude-code-scaffold setup"
echo ""

PROJECT_NAME=$(prompt_required "Project name (e.g. my-app)")
AUTHOR_NAME=$(prompt_required "Your name or handle")
DESCRIPTION=$(prompt_required "One-line project description")
STACK=$(prompt_required "Primary stack (e.g. Next.js, Python/FastAPI, Go)")
GITHUB_USER=$(prompt_required "GitHub username")

echo ""
echo "Target directory: $TARGET"
read -rp "Apply scaffold here? [y/N] " confirm
if [[ ! "$confirm" =~ ^[yY]$ ]]; then
    echo "Aborted."
    exit 0
fi

mkdir -p \
    "$TARGET/.claude/hooks" \
    "$TARGET/.claude/commands" \
    "$TARGET/.claude/agents" \
    "$TARGET/.github/workflows" \
    "$TARGET/docs/claude"

substitute() {
    local src="$1"
    local dst="$2"
    sed \
        -e "s/YOUR_PROJECT/$PROJECT_NAME/g" \
        -e "s/YOUR_AUTHOR/$AUTHOR_NAME/g" \
        -e "s/YOUR_DESCRIPTION/$DESCRIPTION/g" \
        -e "s/YOUR_STACK/$STACK/g" \
        -e "s/YOUR_GITHUB_USERNAME/$GITHUB_USER/g" \
        "$src" > "$dst"
    echo "  wrote ${dst#$TARGET/}"
}

FILES=(
    "CLAUDE.md:CLAUDE.md"
    ".claudeignore:.claudeignore"
    ".claude/settings.json:.claude/settings.json"
    ".claude/hooks/post-compact-reinject.ps1:.claude/hooks/post-compact-reinject.ps1"
    ".claude/hooks/banned-word-check.ps1:.claude/hooks/banned-word-check.ps1"
    ".claude/hooks/stop-baseline-check.ps1:.claude/hooks/stop-baseline-check.ps1"
    ".claude/hooks/permission-request-router.ps1:.claude/hooks/permission-request-router.ps1"
    ".claude/hooks/session-start-habits.ps1:.claude/hooks/session-start-habits.ps1"
    ".claude/commands/scaffold.md:.claude/commands/scaffold.md"
    ".claude/commands/new-feature.md:.claude/commands/new-feature.md"
    ".claude/commands/post-merge.md:.claude/commands/post-merge.md"
    ".claude/commands/commit-push-pr.md:.claude/commands/commit-push-pr.md"
    ".claude/commands/go.md:.claude/commands/go.md"
    ".claude/agents/verify-app.md:.claude/agents/verify-app.md"
    ".claude/agents/security-reviewer.md:.claude/agents/security-reviewer.md"
    ".claude/agents/test-writer.md:.claude/agents/test-writer.md"
    ".github/workflows/claude-pr-assistant.yml:.github/workflows/claude-pr-assistant.yml"
    "docs/claude/project-context.md:docs/claude/project-context.md"
    "docs/claude/architecture.md:docs/claude/architecture.md"
    "docs/claude/db-patterns.md:docs/claude/db-patterns.md"
    "docs/claude/security.md:docs/claude/security.md"
    "docs/claude/spec-rules.md:docs/claude/spec-rules.md"
)

for mapping in "${FILES[@]}"; do
    src="${mapping%%:*}"
    dst="${mapping##*:}"
    substitute "$SCAFFOLD_ROOT/$src" "$TARGET/$dst"
done

# Append Claude-specific ignores to .gitignore if not already present
GITIGNORE="$TARGET/.gitignore"
APPEND_BLOCK="
# Claude Code (added by scaffold)
.claude/settings.local.json
.claude/worktrees/
.claude/shell-snapshots/"

if [[ -f "$GITIGNORE" ]]; then
    if ! grep -q "settings\.local\.json" "$GITIGNORE"; then
        echo "$APPEND_BLOCK" >> "$GITIGNORE"
        echo "  appended Claude entries to .gitignore"
    fi
else
    echo "$APPEND_BLOCK" > "$GITIGNORE"
    echo "  wrote .gitignore"
fi

echo ""
echo "Scaffold applied."

read -rp "Create GitHub repo '$GITHUB_USER/$PROJECT_NAME' now? [y/N] " create_repo
if [[ "$create_repo" =~ ^[yY]$ ]]; then
    gh repo create "$GITHUB_USER/$PROJECT_NAME" --public --source "$TARGET" --remote origin --push
fi

echo ""
echo "Next: open Claude Code in $TARGET and run /scaffold to finish configuration."
