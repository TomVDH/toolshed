---
# toolshed-3og7
title: 'Board visual polish: priority icons, scrolling, cards, detail view, brand animation'
status: completed
type: feature
priority: normal
created_at: 2026-09-12T08:16:07Z
updated_at: 2026-09-12T18:41:04Z
parent: toolshed-e4y3
---

JIRA-style priority arrows, dynamic lane scrolling, larger card type symbols (no words), colored detail header, filter button intensity, brand animation purple accent and hover replay


## Checklist

- [x] Lane scrolling: replace hardcoded `calc(100vh - 17rem)` with JS-measured masthead height, use `100dvh`
- [x] Priority icons: JIRA-style arrows/chevrons via CSS mask data URIs (critical=‼, high=↑, low=↓, lowest=⬇)
- [x] Brand animation: replace first band color with purple aubergine, add hover replay
- [x] Type filter buttons: remove underline, use color intensity for selection
- [x] Detail view: colored type header bar, larger labels, stronger section demarcation
- [x] Cards: type symbol 22px (from 14px), remove category word
- [x] Test updates: structural guards in test_board.py match new template
- [x] Version bump to 4.1.33
- [ ] Browser verification: light/dark, mobile, reduced-motion

## Precedents

- The board is offline-locked (validator 24). All icons must be inline SVG data URIs — no external resources.
- Priority icons follow the JIRA arrow/chevron scale, not the text-word system.
- The brand band is 3 stripes. The first is the purple accent. The animation replays on hover but respects `prefers-reduced-motion`.
- Type filter selection uses color intensity, not underlines.
- Card type symbols are large and standalone — no accompanying text label on the card face.
