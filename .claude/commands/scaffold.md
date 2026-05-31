---
description: Interactively configure this scaffold for a new project
---

You are setting up a Claude Code scaffold for a new project. Ask the user each question below one at a time, wait for their answer, then move to the next. Do not ask multiple questions at once.

Questions to ask:

1. "What is your project name? (used in CLAUDE.md and docs, e.g. my-app)"
2. "Your name or handle? (shown as author in docs and the GitHub workflow)"
3. "One-line description of the project?"
4. "Primary stack? (e.g. Next.js, Python/FastAPI, Go, Rails, other)"
5. "Your GitHub username? (used in the PR assistant workflow and site install command)"

Once you have all five answers, do the following without asking for further confirmation:

1. In CLAUDE.md: replace `YOUR_PROJECT` with the project name.
2. In all files under docs/claude/: replace `YOUR_PROJECT` with the project name and `YOUR_AUTHOR` with the author name.
3. In .github/workflows/claude-pr-assistant.yml: no substitution needed; the workflow uses repository context automatically.
4. In site/index.html: replace `YOUR_GITHUB_USERNAME` with the GitHub username, `YOUR_PROJECT` with the project name, and `YOUR_AUTHOR` with the author name.
5. Update docs/claude/project-context.md: fill in the description field with the one-line description and note the stack under "Key Constraints."
6. Create a .claude/context.md file with this content:

```
Project: [project name]
Author: [author name]
Stack: [stack]
Description: [description]
```

After writing all files, ask: "Want me to run `gh repo create [github-username]/[project-name] --public` to create the GitHub repo now?"

If yes, run it. If no, skip.

Then say:

"Done. Your scaffold is configured. To apply this scaffold to a different existing project in the future, run:

  Windows: setup.ps1
  Mac/Linux: ./setup.sh

Both scripts walk through the same questions non-interactively and copy the configured files."
