---
# toolshed-77f0
title: 'Tags on the board: a readout on the card and a filter in the rail'
status: completed
type: feature
priority: high
created_at: 2026-09-10T17:32:43Z
updated_at: 2026-09-10T17:46:12Z
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

## Summary of Changes

Shipped as adjudant 4.1.2, commit `72f3077`, live on `origin/main`.

**Face.** `.t-tags` between the note and the id. Three chips, then `+N`.

**Suppression.** `deckOrdinaryTags(counts)` drops any tag on more than half the deck. This changed mid-build. The first cut suppressed only tags on *every* card, which is fine in isolation and wrong beside the category rule, which already suppresses at a majority ("more cards than every other category put together"). Two marks answering the same question must not use two thresholds. On the real deck `adjudant` was on 71 of 92 cards: printing it 71 times said nothing, and the 21 cards without it were the informative ones.

**Rail.** `#tagRail` under the legend. Hidden on a tagless deck. Ordered by card count, capped at 12, remainder named not dropped. The active tag is always kept in reach; a deck swap that retires it clears the filter.

**Accessibility.** The face's `aria-label` carries the shown tags, because a label replaces a button's contents rather than adding to them.

7 structural guards. 1563 tests, 28 validators green. Verified in-browser on a 92-card beans deck.
