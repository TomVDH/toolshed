---
# toolshed-e4y3
title: v4.3 — The board becomes a real Beans front end
status: todo
type: milestone
priority: high
created_at: 2026-09-10T09:25:27Z
updated_at: 2026-09-10T09:25:27Z
---

Today the board extracts everything beans has, renders five lanes plus a
colour and a priority chip, and writes back exactly one field.

## The measured gap

Hierarchy and dependencies survive the trip into `board-data.json` and then die
in the sheet: present as text, absent as structure.

- `parent`, `blockedBy`, `blocking` and `tags` reach the deck (`_beans.to_card`)
  and appear in exactly two places in the 1456-line template: the search
  haystack in `cardMatches`, and label rows in `renderSheet`. They drive no
  layout, no lane, no sort, no colour, no badge, no filter facet.
- `sync_deck_to_beans` passes `--status` and nothing else. There is no code path
  in adjudant that writes a bean's title, body, type, priority, tags, parent or
  dependency links.
- `beans list --ready` appears nowhere in the repo. A `todo` lane of 40 beans of
  which 6 are unblocked renders as 40 undifferentiated cards.
- A blocked bean and a ready bean render identically, and `applyMove` validates
  only that the target lane differs. Dragging a blocked bean into `in-progress`
  succeeds and is written back without complaint.

## The shape of the fix

`board.html` is beans-agnostic by design and that should hold: `board.py`
absorbs beans into the ordinary deck shape first. So the work is to give the
deck a generic vocabulary for hierarchy and blocking, and teach the page to
render it.
