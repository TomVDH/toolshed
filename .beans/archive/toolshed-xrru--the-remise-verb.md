---
# toolshed-xrru
title: The remise verb
status: scrapped
type: feature
priority: high
created_at: 2026-09-10T09:25:27Z
updated_at: 2026-09-12T18:52:12Z
parent: toolshed-g0vi
---

Move stale project context out of the working vault into `archived-context/`,
with a preview and a backup, per the existing design.

Design: `docs/superpowers/specs/2026-08-01-adjudant-remise-design.md`
Plan: `docs/superpowers/plans/2026-08-01-adjudant-remise.md` (5 tasks, all unticked)

Includes the four validators the plan names, the transaction pattern, and
writing the `.adjudant-remise-preview` directory the statusline already polls
for (`reference/state-contract.md:27`).

## Reasons for Scrapping

Dream + manual cleanup covers the need. No dedicated verb required.
