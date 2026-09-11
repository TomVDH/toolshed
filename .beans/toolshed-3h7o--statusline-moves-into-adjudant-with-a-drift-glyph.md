---
# toolshed-3h7o
title: Statusline moves into adjudant with a drift glyph
status: completed
type: feature
priority: high
created_at: 2026-09-11T04:28:02Z
updated_at: 2026-09-11T05:02:28Z
parent: toolshed-z6tz
blocked_by:
    - toolshed-q0i9
---

`statusline-v2.sh` and `statusline-tokens-24h.sh` leave the iCloud suitcase and live at `adjudant/statusline/`, git-tracked and tested. `~/.claude/statusline-v2.sh` becomes a shim that execs the installed plugin copy via a pointer file the session-start hook refreshes. The S1 git segment gains one `!` glyph for branch-rule drift, gated on `tracker: beans`.

- [x] copy both scripts into `adjudant/statusline/`, fix the tokens-24h path to `dirname BASH_SOURCE`
- [x] `shim.sh` + `install.sh`; session-start writes `~/.claude/adjudant-statusline-path`
- [x] S1 drift glyph: main checkout off main; `feature/<id>` on a completed/scrapped bean; in-progress feature with no branch
- [x] `test_statusline.py`
- [x] `reference/state-contract.md`, `reference/internals.md`, README, GUIDE, toolshed AGENTS.md
- [ ] retire the suitcase copy (`git rm` + `snap`), install on both machines
- [x] release 4.1.19, PR, merge, worktree removed

## Summary of Changes

Shipped as adjudant 4.1.19 on `feature/toolshed-3h7o`.

- `adjudant/statusline/`: `statusline.sh` (v2.6), `statusline-tokens-24h.sh` (found relative to the bar), `shim.sh`, `install.sh`.
- `session-start.sh` refreshes `~/.claude/adjudant-statusline-path` each session, silently, before the breadcrumb gate.
- S1b drift glyph: red `!` in front of the branch on three conditions, gated on `tracker: beans`. The beans awk pass returns a seventh field (in-progress feature ids).
- `test_statusline.py`: 22 tests. Full suite 1655, 28 validators.
- Installed on this machine; the old iCloud symlink is `~/.claude/statusline-v2.sh.bak-20260910-215628`.
- Suitcase retirement (`git rm` + `snap`) and the work-machine install remain manual steps, noted in the release commit.
