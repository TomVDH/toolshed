---
# toolshed-byv2
title: 'statusline: branch name links to the checkout folder, regular checkouts get a branch glyph'
status: in-progress
type: task
priority: normal
created_at: 2026-09-12T07:10:35Z
updated_at: 2026-09-12T07:15:09Z
---

Segment 1 of the statusline. The branch name becomes an OSC 8 file:// link to workspace.current_dir (the linked worktree dir inside one, the project dir otherwise). A regular checkout gets a white branch glyph in front of the name, the counterpart of the ⑂ mark a linked worktree already shows.

- [x] failing tests in adjudant/scripts/test_statusline.py: link target, glyph on main checkout, no glyph in a linked worktree, space percent-encoding
- [x] statusline.sh: glyph + link
- [x] state-contract.md row if the bar reads anything new (it does not; confirmed: cwd was already read, no new file)
- [x] bump_plugin_version.py adjudant 4.1.31, validators and tests green (28 validators, 1677 tests)
- [ ] push branch, PR, merge, prune worktree
