# claude-code-scaffold

A GitHub template repo that wires up Claude Code for a new project: hooks, slash commands, sub-agents, a hardened GitHub PR assistant, and a populated CLAUDE.md. Works on Windows, Mac, and Linux.

## Quick start

### Option 1: GitHub template (recommended)

1. Click **Use this template** on the GitHub repo page.
2. Clone your new repo locally.
3. Open Claude Code in that directory.
4. Run `/scaffold` and answer five questions. Done.

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

Both scripts ask the same five questions, copy and configure all template files, append Claude-specific entries to your `.gitignore`, and optionally create a GitHub repo.

## What `/scaffold` does

When you run `/scaffold` in Claude Code, it asks:

1. Project name
2. Your name or handle
3. One-line description
4. Primary stack
5. GitHub username

Then it rewrites all placeholder strings across every template file, creates `.claude/context.md` for post-compact reinject, and offers to run `gh repo create`.

## What's included

```
.claude/
  settings.json              hooks wired, autoCompact, effortLevel, env vars
  hooks/
    post-compact-reinject.ps1   restores context after compaction
    banned-word-check.ps1       blocks banned words on PreToolUse
    stop-baseline-check.ps1     scans for TODO/FIXME on Stop
    permission-request-router.ps1  auto-allow read-only, block dangerous patterns
    session-start-habits.ps1    prints habits reminder on first prompt
  commands/
    scaffold.md                interactive setup (this command)
    new-feature.md             plan before coding (disable-model-invocation)
    post-merge.md              post-merge checklist (disable-model-invocation)
    commit-push-pr.md          commit, push, open PR
    go.md                      pick up the next task
  agents/
    verify-app.md              run app and confirm behavior
    security-reviewer.md       review diff for vulnerabilities
    test-writer.md             write tests for uncovered code

CLAUDE.md                      under 100 lines, uses @import for heavy content
.claudeignore                  standard exclusions
.gitignore                     ignores settings.local.json, worktrees/, shell-snapshots/

docs/claude/
  project-context.md           what the project is and who uses it
  architecture.md              system overview, data flow, folder map
  db-patterns.md               schema, queries, migrations
  security.md                  auth, authz, secrets, compliance
  spec-rules.md                style, code, testing, review rules

.github/workflows/
  claude-pr-assistant.yml      hardened @.claude trigger for PRs

site/
  index.html                   GitHub Pages site (no build step)
```

## Hook architecture

```
UserPromptSubmit     PreToolUse         PostCompact         Stop
      |                  |                   |                |
session-start-     banned-word-      post-compact-     stop-baseline-
habits.ps1         check.ps1         reinject.ps1      check.ps1

PermissionRequest
      |
permission-request-
router.ps1
```

## GitHub PR assistant

The workflow triggers on `@.claude` comments in PRs. Hardening:

- `author_association` must be OWNER, MEMBER, or COLLABORATOR
- A separate step verifies the PR is not from a fork
- The comment body is written to `/tmp/user-request.txt` via env var, never interpolated into shell
- High-risk paths (workflows, lockfiles) are excluded in the prompt instructions
- `actions/checkout` is pinned to a specific commit SHA

Pin the `anthropics/claude-code-action` to a commit SHA from [its releases page](https://github.com/anthropics/claude-code-action/releases) before using in production.

## Customizing

- Edit `docs/claude/*.md` with your project's actual context.
- Add project-specific hooks to `.claude/hooks/`.
- Add slash commands to `.claude/commands/` for recurring workflows.
- The `banned-word-check.ps1` list is easy to extend.

## Inspiration

Patterns sourced from Boris Cherny's public writing on how he uses Claude Code (he created Claude Code at Anthropic) and from the official Claude Code documentation.

## License

MIT

