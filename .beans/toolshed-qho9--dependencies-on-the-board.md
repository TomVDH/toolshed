---
# toolshed-qho9
title: Dependencies on the board
status: todo
type: feature
priority: high
created_at: 2026-09-10T09:25:27Z
updated_at: 2026-09-10T09:25:27Z
parent: toolshed-e4y3
---

`blockedBy` and `blocking` reach the deck and are invisible.

- [ ] A blocked card must be distinguishable from a ready one at a glance
- [ ] Resolve blocker ids to their status, so a completed blocker reads as a
      dead link rather than a live one
- [ ] Guard the drag: `applyMove` validates only that the target lane differs.
      Dragging a blocked bean into `in-progress` currently succeeds and
      `sync_deck_to_beans` writes it back without complaint
- [ ] Decide whether the guard is a refusal or a warning
