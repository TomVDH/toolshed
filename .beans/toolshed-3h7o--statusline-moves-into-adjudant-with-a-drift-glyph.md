---
# toolshed-3h7o
title: Statusline moves into adjudant with a drift glyph
status: in-progress
type: feature
priority: high
created_at: 2026-09-11T04:28:02Z
updated_at: 2026-09-11T05:02:12Z
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
- [ ] release 4.1.19, PR, merge, worktree removed
