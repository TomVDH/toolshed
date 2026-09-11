---
# toolshed-db67
title: 'Board 4.1.17: underscored type keys on a 70s palette, ColorSym marks, persist rename'
status: completed
type: feature
priority: normal
created_at: 2026-09-11T04:17:19Z
updated_at: 2026-09-11T04:20:23Z
parent: toolshed-2z4w
---

Ships the impeccable live rounds on the board masthead rails.

- [x] ColorSym symbols as CSS masks on the eight type keys (bijective assignment, 18px)
- [x] 70s palette at 56-59% lightness; every hue >= 3:1 on all six surfaces
- [x] Type key is a word on a hue rule, not a pill (variant 8 of 8 studies, accepted under live)
- [x] Tag key states its own rule in ink; never built on an undefined --c
- [x] Persist control reads "Persist board edits?" then "Persisting board edits"
- [x] Three guards: pill-not-box, tag-rule-not-on-hue, 48 palette contrast ratios
- [x] reference/board.md: key section, palette, one-rail note

Follow-up: redo the docket buttons (Persist, Download, Hide closed, histogram field) individually under live.

## Summary of Changes

Accepted variant 8 (underscored) from an eight-study live round on `.rails`; carbonized into the template's real rules. Type key: no box, 2px hue rule, 18px ColorSym mark, ink line when filtered. Tag key: border-strong rule, ink on-state, never built on `--c`. Palette: eight 70s tones at 56-59% lightness, 48 contrast ratios guarded. Persist control renamed. Docs in reference/board.md. Version 4.1.17. Tests 1597.
