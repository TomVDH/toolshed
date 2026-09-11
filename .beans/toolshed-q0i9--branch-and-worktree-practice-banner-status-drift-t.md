---
# toolshed-q0i9
title: 'Branch and worktree practice: banner, status drift, templates'
status: completed
type: feature
priority: high
created_at: 2026-09-11T04:27:54Z
updated_at: 2026-09-11T04:42:09Z
parent: toolshed-z6tz
---

Feature beans get a `feature/<bean-id>` branch, always in a `.worktrees/<bean-id>` worktree. Tasks and bugs commit on main unless their parent feature is in progress. Epics are containers and get no branch. Merge-back is a GitHub PR. Adjudant states this every session, provisions it into linked projects, and `status` reports drift. Nothing blocks.

- [x] `.worktrees/` in toolshed `.gitignore`
- [x] session-start banner `- Git:` line, gated on `.git` presence, no subprocess
- [x] `status.py`: `_git_practice`, six `git-*` drift signals, beans fetched once in `run()`
- [x] `reference/status.md`, `reference/repo-standards.md` (`### Git practice`), `reference/connect.md`
- [x] `validate.py` REPO_STANDARD_CATEGORIES gains `git practice`
- [x] `templates/AGENTS.md` `## Git practice` section
- [x] `posttooluse-commit-log.py` names the branch in the session-note line
- [x] GUIDE.md, README.md, toolshed AGENTS.md, PRODUCT.md
- [x] tests: hook_shell, status, connect, commit_log, validate
- [x] release 4.1.18, PR, merge, worktree removed

## Summary of Changes

Shipped as adjudant 4.1.18 on `feature/toolshed-q0i9`, the first worktree under the rule it introduces.

- `session-start.sh` prints one `- Git:` line in beans-tracked repos (stat-gated, no subprocess).
- `status.py` `_git_practice` judges the main checkout from anywhere and reports `git-main-off-main`, `git-branch-missing`, `git-worktree-stale`, `git-branch-stale`, `git-branch-no-worktree`, `git-dirty-main`. `run()` fetches beans once.
- `posttooluse-commit-log.py` appends ` (on feature/x)` to the session-note line off main.
- `templates/AGENTS.md` carries `## Git practice`; `repo-standards.md` carries the contract; validator 12 requires it.
- Toolshed `AGENTS.md` and `PRODUCT.md` drop "no PR workflow".
- 30 new tests; 1627 total, 28 validators green.

Epics get no branch (containers, never worked on directly), a refinement of the original feature/epic choice.
