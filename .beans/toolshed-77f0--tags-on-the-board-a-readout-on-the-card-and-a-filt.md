---
# toolshed-77f0
title: 'Tags on the board: a readout on the card and a filter in the rail'
status: in-progress
type: feature
priority: high
created_at: 2026-09-10T17:32:43Z
updated_at: 2026-09-10T17:44:55Z
---

The board throws tags away on the face. `_beans.py:382` carries `tags` into every card and the sheet prints them, but the card face and the filter rail are both blind to them.

Measured on the HubSpot Nightly deck: 78 of 122 beans carry a tag, across 13 distinct tags. That is real classification the board is not showing.

## Todo

- [x] Face readout: a `.t-tags` row, suppressed for the deck's ordinary tags. Landed on the MAJORITY threshold, not unanimity: the ordinary category already uses "more cards than all others put together", and two marks answering the same question must not use two thresholds. `adjudant` sat on 71 of 92 cards on the real deck.
- [x] Cap the face at 3 tags, then `+N`
- [x] Tag rail under the legend, single-select like `filterCat`, ordered by card count, capped at 12 with the remainder named rather than hidden
- [x] `cardMatches` honours the tag filter
- [x] Escape clears the tag filter with the rest
- [x] Structural guards in `test_board.py` (7 added)
- [x] `reference/board.md` documents the readout and the rail
- [x] Bump to 4.1.2 via `scripts/bump_plugin_version.py`
