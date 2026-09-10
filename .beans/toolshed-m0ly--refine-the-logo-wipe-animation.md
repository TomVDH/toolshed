---
# toolshed-m0ly
title: Refine the logo wipe animation
status: todo
type: task
priority: normal
created_at: 2026-09-10T09:05:01Z
updated_at: 2026-09-10T09:14:36Z
parent: toolshed-7hyn
---

The wipe is prototyped and reads correctly, but it is a first cut.

## To clean up

- [ ] Timing: 1.1s with a 0.3s delay. Probably too slow for something seen on every board open
- [ ] Decide whether it plays once per session or on every render
- [ ] The band is a hard three-colour block. Consider it emerging from the plume rather than entering off-canvas, so it reads as the crest unfurling
- [ ] The reveal and the band share one easing curve; the reveal probably wants to trail
- [ ] Confirm the prefers-reduced-motion degraded state is right
- [ ] ZenaSoft doctrine says no entrance animations. This is a brand moment, not page chrome, but it needs an explicit exception noted

## Depends on

The parent covers the light/dark assets. The animation cannot be finalised until the dark asset exists, since the band colours and the figure ink interact.
