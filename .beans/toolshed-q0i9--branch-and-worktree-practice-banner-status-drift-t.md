---
# toolshed-q0i9
title: 'Branch and worktree practice: banner, status drift, templates'
status: in-progress
type: feature
priority: high
created_at: 2026-09-11T04:27:54Z
updated_at: 2026-09-11T04:27:54Z
parent: toolshed-z6tz
---

Feature beans get a `feature/<bean-id>` branch, always in a `.worktrees/<bean-id>` worktree. Tasks and bugs commit on main unless their parent feature is in progress. Epics are containers and get no branch. Merge-back is a GitHub PR. Adjudant states this every session, provisions it into linked projects, and `status` reports drift. Nothing blocks.

- [ ] `.worktrees/` in toolshed `.gitignore`
- [ ] session-start banner `- Git:` line, gated on `.git` presence, no subprocess
- [ ] `status.py`: `_git_practice`, six `git-*` drift signals, beans fetched once in `run()`
- [ ] `reference/status.md`, `reference/repo-standards.md` (`### Git practice`), `reference/connect.md`
- [ ] `validate.py` REPO_STANDARD_CATEGORIES gains `git practice`
- [ ] `templates/AGENTS.md` `## Git practice` section
- [ ] `posttooluse-commit-log.py` names the branch in the session-note line
- [ ] GUIDE.md, README.md, toolshed AGENTS.md, PRODUCT.md
- [ ] tests: hook_shell, status, connect, commit_log, validate
- [ ] release 4.1.18, PR, merge, worktree removed
