# claude-code-scaffold ⚡

**Bootstrap Claude Code for any project in one interactive command.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Works on Windows + Mac](https://img.shields.io/badge/platform-Windows%20%2B%20Mac-informational)](README.md)
[![Powered by Claude Code](https://img.shields.io/badge/powered%20by-Claude%20Code-orange)](https://claude.ai/claude-code)

[![Live Site](https://img.shields.io/badge/🌐_Live_Site-visit-C15F3C?style=for-the-badge)](https://pateljatin.github.io/claude-code-scaffold/)

---

## What is this?

Setting up Claude Code well takes time. You need hooks to guard context across compaction, a CLAUDE.md that doesn't balloon past 100 lines, slash commands for repeatable workflows, sub-agents for verification and security review, and a hardened GitHub PR assistant. **claude-code-scaffold** is a GitHub template repo that wires all of it up in one interactive `/scaffold` command inside Claude Code.

→ **[Live site and docs →](https://pateljatin.github.io/claude-code-scaffold/)**

---

## Quick start

### Option 1: GitHub template (recommended)

1. Click **Use this template** on this page
2. Clone your new repo locally
3. Open Claude Code in that directory
4. Run `/scaffold` — answer five questions. Done.

### Option 2: Apply to an existing project

**Windows (PowerShell):**
```powershell
git clone https://github.com/pateljatin/claude-code-scaffold
cd claude-code-scaffold
.\setup.ps1 -Target C:\path\to\your-project
```

**Mac / Linux:**
```bash
git clone https://github.com/pateljatin/claude-code-scaffold
cd claude-code-scaffold
./setup.sh /path/to/your-project
```

---

## What `/scaffold` does

Run `/scaffold` inside Claude Code. It asks five questions one at a time:

1. Project name
2. Your name or handle
3. One-line description
4. Primary stack
5. GitHub username

Then it substitutes every placeholder across every template file, creates `.claude/context.md` for the post-compact hook, and offers to run `gh repo create`.

---

## What's included

```
.claude/
  settings.json                hooks wired, autoCompact, effortLevel, env vars
  hooks/
    post-compact-reinject.ps1  restores context after compaction
    banned-word-check.ps1      blocks banned words on PreToolUse
    stop-baseline-check.ps1    scans for TODO/FIXME on Stop
    permission-request-router.ps1  auto-allow read-only, block dangerous patterns
    session-start-habits.ps1   prints habits reminder on first prompt
  commands/
    scaffold.md                interactive setup (this command)
    new-feature.md             plan before coding
    post-merge.md              post-merge checklist
    commit-push-pr.md          commit, push, open PR
    go.md                      pick up the next task
  agents/
    verify-app.md              run app and confirm behavior
    security-reviewer.md       review diff for vulnerabilities
    test-writer.md             write tests for uncovered code

CLAUDE.md                      under 100 lines, loads docs via @import
.claudeignore                  standard exclusions
.gitignore                     tracks commands/agents/hooks, ignores local state

docs/claude/
  project-context.md           what the project is and who uses it
  architecture.md              system overview, data flow, folder map
  db-patterns.md               schema, queries, migrations
  security.md                  auth, authz, secrets, compliance
  spec-rules.md                style, code, testing, review rules

.github/workflows/
  claude-pr-assistant.yml      hardened @.claude trigger for PRs
  pages.yml                    deploys site/ to GitHub Pages

site/
  index.html                   project site (no build step)
```

---

## Hook architecture

```
UserPromptSubmit     PreToolUse         PostCompact          Stop
      |                  |                   |                 |
session-start-     banned-word-      post-compact-      stop-baseline-
habits.ps1         check.ps1         reinject.ps1       check.ps1

PermissionRequest
      |
permission-request-
router.ps1
```

---

## GitHub PR assistant

Add `@.claude` in any PR comment to trigger Claude. Hardening built in:

- `author_association` must be OWNER, MEMBER, or COLLABORATOR
- Fork PRs are blocked via a separate API check
- Comment body is written to `/tmp/user-request.txt` via env var — never shell-interpolated
- High-risk paths (workflows, lockfiles) excluded in the prompt
- `actions/checkout` pinned to a commit SHA

**Required:** add `ANTHROPIC_API_KEY` as a repository secret before use.

Pin `anthropics/claude-code-action` to a commit SHA from its [releases page](https://github.com/anthropics/claude-code-action/releases) before using in production.

---

## Customizing

- Fill in `docs/claude/*.md` with your project's actual context
- Add hooks to `.claude/hooks/` for project-specific guards
- Add commands to `.claude/commands/` for recurring workflows
- Extend the banned word list in `banned-word-check.ps1`

---

## Inspiration

Patterns sourced from Boris Cherny's public writing on how he uses Claude Code (he created Claude Code at Anthropic) and from the official Claude Code documentation.

---

MIT License
