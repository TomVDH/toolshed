---
# toolshed-7hyn
title: Light and dark variants of the ADJUDANT and ADJUDANTE logo assets
status: completed
type: feature
priority: normal
created_at: 2026-09-10T09:00:14Z
updated_at: 2026-09-10T19:45:20Z
parent: toolshed-2z4w
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

## Interim shipped in 4.1.3

The paper plaque is gone. The head ink (`#26211a`, which is this theme's own dark `--bg`) is recoloured to the dark scheme's `--text` (`#e2ddd7`) in a second PNG per figure, swapped by `prefers-color-scheme`.

Findings that outlive the interim:

- **Nothing was ever baked into the assets.** Both source SVGs have zero `<rect>` and no background path. The white was a CSS rule the board painted: `.brand-mark{background:oklch(93% 0.012 75)}` under a dark media query.
- **`filter:invert()` is not available here.** The figures are 14 and 16 colour illustrations, not silhouettes. Inverting takes the plume to cyan and the skin to blue.
- **Recolour the warm near-black only.** Path 1 in both files, `#26211a`, is the head. The cool near-blacks (`#24292c`, `#272b2e`, `#262b2e`) must be left alone: recolouring those as well takes the pupil with them and the face reads blank. Verified side by side on the dark background.
- **Cost: about 21 KB on every board.html.** A real dark asset, or an inline SVG whose ink binds to a CSS variable, would replace both PNGs and cut that.

Still open: proper light/dark artwork drawn as such, rather than one asset with one ink swapped.

## Resolved in 4.1.4, and the 4.1.3 note above is superseded

Tom pushed back on the raster interim: the originals are SVG, so the ink switch should not need a second asset. Correct, and the payload argument that justified PNG in 4.1.0 inverted once the PNG was priced at the resolution it actually needs.

Measured, both figures, both inks, as characters in board.html:

| | chars | crisp at 3x | ink switch |
|---|---|---|---|
| PNG 89px (what 4.1.3 shipped, only 1.7x) | 47,748 | no | second asset |
| PNG 104px (2x) | 51,836 | no | second asset |
| PNG 156px (3x) | 77,264 | yes | second asset |
| inline SVG, 1dp on a 100 grid | 66,500 | yes, any size | one property |

The vector is smaller than a genuinely sharp raster AND scales, which matters because this mark is meant to brand reports and exports.

Shipped: inline `<svg>`, 14 and 16 paths, head fill emitted as `var(--mark-ink,#26211a)`, dark block sets the property. `markFigure()`, the `matchMedia` listener and all four PNGs are deleted; a custom property answers a media query on its own and does it before the first paint.

Fidelity: mean channel error 1.0 to 1.3 of 255 against the original at 52px and 156px.

One bug worth remembering. The first optimiser pass rendered EMPTY. Cause: the separator rule. A number may abut the previous one only when the join cannot be re-read as one number, so `5` then `.3` must be `5 .3`, never `5.3`, while `5.2` then `.3` may be `5.2.3`. Getting it wrong silently deletes geometry instead of raising.

Still worth doing later: artwork drawn for dark rather than one ink swapped.
