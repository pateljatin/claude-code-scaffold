---
description: Post-merge checklist after pulling from main or merging a PR
disable-model-invocation: true
---

Run this after merging a PR or pulling from main.

1. Pull latest: `git pull origin main`
2. Delete the merged local branch if it still exists.
3. Run the test suite. Report any failures before continuing.
4. Check for dependency updates: package.json, requirements.txt, go.mod, Gemfile, etc.
5. Review open issues or the next planned task.
6. Update CLAUDE.md or docs/claude/ if the architecture changed.

Report failures immediately. Do not proceed to the next task if tests are red.
