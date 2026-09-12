---
# toolshed-w0t3
title: 'Board 4.1.26: one ColorSym vocabulary on rail, card and sheet'
status: completed
type: feature
priority: normal
created_at: 2026-09-11T07:57:50Z
updated_at: 2026-09-11T09:05:52Z
parent: toolshed-2z4w
---

Tom: increase the ColorSym symbols slightly and their punch; bring them in as the type chips on the cards and in the detail pane; use them wherever we have them.

- [x] Masks defined once on .sym, keyed by data-sym; catSym assigns 1..8 by index beside the hue
- [x] Rail key mark 18 -> 20px; card face 14px mark on every typed card of a multi-type deck (word still only on exceptions); sheet 16px
- [x] Palette +0.03 chroma; avocado, petrol and teal lightness trimmed to hold 3:1 on all six surfaces
- [x] Guards updated (data-sym instead of nth-child) and one new: the mark is the same on rail, card and sheet
- [x] reference/board.md paragraph

## Summary of Changes

The 8px squares on the card foot and in the sheet became the same ColorSym mark the rail key wears. Version 4.1.23. Tests 1600.
