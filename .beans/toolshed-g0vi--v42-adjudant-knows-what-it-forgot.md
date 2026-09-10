---
# toolshed-g0vi
title: v4.2 — Adjudant knows what it forgot
status: todo
type: milestone
priority: high
created_at: 2026-09-10T09:25:27Z
updated_at: 2026-09-10T09:25:27Z
---

The archive verb and the memory that survives it.

This is the oldest outstanding work in the tree and the most load-bearing.

## Evidence

`docs/superpowers/specs/2026-08-01-adjudant-remise-design.md` and
`docs/superpowers/plans/2026-08-01-adjudant-remise.md` are a full design and a
five-task TDD plan targeting v0.27.0. All 11 checkboxes are unticked. There is
no `remise.py`, no `templates/memory.md`, no `archived-context/` anywhere in the
tree. Adjudant is now at 4.1.0.

## Why it blocks other work

`docs/superpowers/specs/2026-07-31-adjudant-parked-work.md` kills the
monster-project narrowing strategies with an explicit trigger: **"Reassess only
after the archive verb ships."** Two specs currently disagree in the tree
because of it. Nothing downstream of that reassessment can start.

`reference/state-contract.md:27` also lists a statusline state
`"remising" (reserved, nothing writes it yet)` — the statusline in iCloud is
already polling for a directory no code creates.
