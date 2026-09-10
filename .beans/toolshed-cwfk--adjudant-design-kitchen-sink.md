---
# toolshed-cwfk
title: Adjudant Design Kitchen Sink
status: todo
type: feature
priority: normal
created_at: 2026-09-10T09:05:21Z
updated_at: 2026-09-10T09:14:36Z
---

One page that renders every piece of the Adjudant Classic design system at once, in both schemes, in every state. The board is currently the only place the system exists, which means the only way to check a token change is to scaffold a board and hunt for the affected component.

## Why

- A contrast regression is only caught today if it happens to hit one of the four tokens test_board measures. Everything else is unmeasured
- The system now has real surface area: three radii collapsed to zero, a rail component used twice, a markdown reader with eight block types, priority and category marks, lane stamps, four save states, a card sheet with six sections
- The ZenaSoft port moved four token slots for this surface. The next port, or the next theme, needs somewhere to see the whole thing at once

## What goes on it

- [ ] The full token scale, light and dark, with measured contrast printed beside each pair
- [ ] Type roles: serif display, uppercase serif labels, body sans, the mono allowlist
- [ ] The brand lockup, both figures, and the wipe
- [ ] Board components: lane well, lane head with stamp and wip count, card face in every combination (note, no note, category mark, priority, long title)
- [ ] Card sheet: every section, plus the sparse card where most sections are hidden
- [ ] The rail, as lane picker and as note toggle
- [ ] Markdown reader: every block type it supports, plus what it deliberately does not
- [ ] All four save states, the notice, the fatal state, the empty and filtered lane states
- [ ] Focus rings on every interactive element

## Constraints

- Same offline lock as the board: no fetched fonts, no external assets, single file
- Should be generated from the same template source rather than hand-maintained, or it will drift the first time a token moves
