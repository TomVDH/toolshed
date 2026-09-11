---
# toolshed-ondm
title: 'Board 4.1.19: the activity card is a time sheet, both fields at once, no hover readout'
status: completed
type: feature
priority: normal
created_at: 2026-09-11T07:13:10Z
updated_at: 2026-09-11T07:13:10Z
parent: toolshed-2z4w
---

Overdrive round on #spark under impeccable live (session 1d89c800): "redo this entire thing", then "i like option 1" (the punch card), then accepted the two-panel reading at 6 weeks.

- [x] Three charts first (punch card, 124-slot pulse, brush filter), then three readings of the punch card (time sheet, both inks, two panels)
- [x] Accepted variant 3: two panels, Touched and Filed, 6 weeks; carbonized into paintSpark/sparkPanel/sparkDays/sparkRange
- [x] The hover readout is gone: date and count in the cell tooltip and aria-label; nothing changes width on hover (Tom: "twitchy date clock, jumps the layout")
- [x] sparkField, sparkBins, sparkDateText and the Touched/Filed switch removed; no SVG in the card
- [x] Grid pads only to the Sunday closing the current week
- [x] Five guards rewritten; reference/board.md section rewritten

## Summary of Changes

The histogram became a time sheet: two 7x6 day grids side by side, tinted by count, bulk days grey, today ringed, months under. Version 4.1.19.
