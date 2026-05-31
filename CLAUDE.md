# YOUR_PROJECT

@docs/claude/project-context.md
@docs/claude/architecture.md
@docs/claude/spec-rules.md

## Model and Effort (mandatory for every task)

| Complexity | Model | Effort |
|---|---|---|
| File reads, grep, config, simple edits | Haiku | medium |
| Routine P0-P2 bugs, features | Sonnet | medium |
| Architecture, security, planning | Sonnet high or Opus | — |

Never silently use Opus or high effort. Propose and wait for confirmation.

## Session Commands

- `/btw` — side question that never enters conversation history
- `/rewind` — restore to any checkpoint; prefer over correcting Claude twice
- `/dream` — run at session end to consolidate memory and remove stale entries
- `/goal` — set a measurable completion condition; Claude keeps working until it holds

## Token Hygiene

- Suggest `/clear` when switching to an unrelated task
- Suggest `/compact` when context approaches 70%
- One task per conversation

## Code Principles

No comments unless the WHY is non-obvious. No error handling for impossible cases. No scope creep. YAGNI. No half-implementations.

No em-dashes. No "AI-powered," "leverage," "seamless," "robust," "revolutionary," "transformative," or "ecosystem." Oxford comma. US English.

## Compaction Preservation

When compacting, preserve: modified files and their current state, current branch and open PRs, active goal, test commands and last result, failing test names, next planned action.
