---
# toolshed-my5j
title: 'Board 4.1.24: the refined marks, two drawings per figure'
status: completed
type: feature
priority: normal
created_at: 2026-09-11T08:55:32Z
updated_at: 2026-09-11T08:55:32Z
parent: toolshed-2z4w
---

Tom delivered four refined SVGs: ADJUDANT, ADJUDANT INV, ADJUDANTE, ADJUDANTE INV.

- [x] MARK carries light and dark drawings per figure; paintMark picks by prefers-color-scheme, repaints on change, holds the figure across a flip
- [x] Paths scaled to a 100-wide box at 2dp; eight crown flecks (<=3px at 300px) and the invisible fill:none silhouettes dropped
- [x] --mark-ink/--mark-shade/--mark-eye tokens and the recolour retired; one band for both figures
- [x] Guards rewritten; reference/board.md section rewritten
- [x] Rendered all four at 240px and 56px on their grounds

## Summary of Changes

The dark scheme shows the artist's inverse drawing instead of a recoloured light one. Version 4.1.24.
