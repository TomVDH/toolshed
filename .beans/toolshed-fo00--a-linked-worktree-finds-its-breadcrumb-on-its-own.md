---
# toolshed-fo00
title: A linked worktree finds its breadcrumb on its own
status: completed
type: feature
priority: high
created_at: 2026-09-11T20:20:15Z
updated_at: 2026-09-11T20:24:36Z
---

Tom: in a worktree the vault notations in the statusline do not always come through. .claude/adjudant is git-ignored, so a worktree never carries it and every adjudant reader goes quiet; AGENTS.md asked for a manual copy.

A worktree's .git file holds `gitdir: <main>/.git/worktrees/<name>`, which is enough to find the main checkout and its breadcrumb.

- [x] statusline: when the project has no breadcrumb and .git points into /worktrees/, read <main>/.claude/adjudant instead (no fork)
- [x] session-start: symlink <worktree>/.claude/adjudant -> <main>/.claude/adjudant when absent, so all 150 readers are satisfied
- [x] tests in test_statusline.py and test_hook_shell.py on real worktrees
- [x] state-contract.md row; AGENTS.md and repo-standards.md drop the manual cp step

## Summary of Changes

The statusline derives the main checkout from the worktree's gitdir pointer and reads its breadcrumb when the worktree has none (no fork). The session-start hook symlinks the breadcrumb in for the other readers. Five tests on real and pointer-only worktrees. Version 4.1.29. Tests 1674.
