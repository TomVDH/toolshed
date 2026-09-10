---
# toolshed-9grg
title: Truth in the tree
status: todo
type: milestone
created_at: 2026-09-10T09:25:27Z
updated_at: 2026-09-10T09:25:27Z
---

There is no mechanical way to tell a shipped spec from an unbuilt one.

## Evidence

- Of the six specs carrying frontmatter, every one still reads pre-implementation:
  `status: design — ready for implementation`, `design, locked`, `design,
  approved`. None says shipped. That includes v3 and beans, both shipped.
- 11 of 14 plans have **zero** ticked checkboxes, including every shipped v3
  plan (`stop-the-bleeding` 79/79 unticked, `structure-and-truth` 128/128).
- This is precisely how `remise` and the board move-history ledger stayed
  invisible from 2026-08-01 until now.
- `README.md` is titled for the old repo name, lists adjudant at 3.0.0, links a
  directory that no longer exists, and presents two sunset plugins as live.
- Retired verb names (`tidy repo`, `sitrep`) still appear in live reference docs
  as if current.

Unticked boxes currently carry no signal. That is the actual defect.
