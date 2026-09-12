---
# toolshed-6smq
title: 'statusline: 1M tag next to the model, drift paints the checkout glyph red'
status: completed
type: task
priority: normal
created_at: 2026-09-12T07:35:13Z
updated_at: 2026-09-12T07:41:51Z
---

Segment 4: when context_window.context_window_size is 1000000 or more, the bar says 1M after the model. Segment 1: the branch-rule breach recolours the checkout glyph (⎇ or ⑂) in the diff-red instead of putting a red ! in front; a detached HEAD carries no mark, as before, since the rules need a branch name.

- [x] failing tests: 1M on 1000000, absent on 200000 and when the field is missing; red ⎇ on a drifting checkout, red ⑂ in a drifting worktree, no bang, detached HEAD unmarked
- [x] statusline.sh: ctx_size from the jq pass, 1M tag, glyph recolour, dead bang fallback removed
- [x] README glyph table, GUIDE §11, internals.md
- [x] bump 4.1.32, validators and full suite green (28 validators, 1679 tests)
- [x] push, PR, merge

## Summary of Changes

- statusline.sh: ctx_size read in the jq pass; 1M after the model when context_window_size >= 1000000.
- statusline.sh: drift recolours the checkout glyph (⎇ or ⑂) red in place; the red ! and its dead detached-HEAD fallback are gone.
- test_statusline.py: two new tests, drift helper reads the raw bar and looks for the red glyph.
- README, GUIDE §11, internals.md updated. Released as 4.1.32.
