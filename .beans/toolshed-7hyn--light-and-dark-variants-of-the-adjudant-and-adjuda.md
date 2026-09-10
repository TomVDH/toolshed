---
# toolshed-7hyn
title: Light and dark variants of the ADJUDANT and ADJUDANTE logo assets
status: todo
type: feature
priority: high
created_at: 2026-09-10T09:00:14Z
updated_at: 2026-09-10T09:14:36Z
---

The two logo SVGs are single, fixed-colour assets. They only work on the light scheme.

## The problem, measured

The figure is filled `#26211a`. That is *exactly* ZenaSoft dark `--bg` (`oklch(22% 0.014 70)` in the board ships as `#1f1a14`, the source token is `oklch(25% 0.014 70)` = `#26211a`). On a dark surface the head is the background colour, so the figure disappears and only the red plume is left floating.

## What is needed

- [ ] A light-scheme asset (current one is already this)
- [ ] A dark-scheme asset with the ink inverted toward `--text`
- [ ] Decide the mechanism: two assets swapped by `prefers-color-scheme`, or one asset whose ink is `currentColor`
- [ ] `currentColor` flattens the figure to one tone and loses the `#24292c` / `#d2d7d8` detail, so check that against the two-asset cost first

## Constraints

- `board.html` is offline-locked (validator 24), so any asset must be inline SVG or a `data:` URI, never a file reference
- Raw SVG is 80 KB against a 71 KB template. Integer-rounded it is 36 KB; a 96px PNG data-URI is 6.4 KB
- The plume colours (`#7c1b16`, `#bd281c`, `#dd4d25`) already work on both schemes and need no variant
