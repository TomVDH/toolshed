---
# toolshed-10dm
title: Activity histogram on the board
status: completed
type: feature
priority: normal
created_at: 2026-09-11T01:11:10Z
updated_at: 2026-09-11T02:08:07Z
parent: toolshed-e4y3
---

Pool the timestamps every bean already carries and draw activity over time on the board.

`_beans.to_card` puts `createdAt` and `updatedAt` on every card. Measured on the 92-card HubSpot Nightly deck: **100% coverage on both**, ISO-8601 with a Z suffix (`2026-09-10T03:01:09Z`). The data is already in `board-data.json`, so this reads what is there and adds no plumbing.

## Read this before designing it

The timestamps record **file writes, not human activity**, and on a real deck that difference dominates. Same 92-card deck:

| | |
|---|---|
| distinct `createdAt` days | **4**, with 55 of 92 on one day |
| distinct `updatedAt` days | **2** |
| cards touched 2026-09-10 | **83 of 92** |

That single day is an import plus the churn bug fixed in 4.1.1, not a day somebody moved 83 cards. A naive daily histogram of this deck is one tall bar and some noise, and it would be read as activity.

So the feature is only worth building if it answers that honestly. Options, in order of preference:

1. **Bin by week, not day.** A 24-day span is 24 daily columns; weekly is four, which survives an import spike and still shows a trend.
2. **Say which field is plotted** and let it toggle. `createdAt` is when work was filed, `updatedAt` is when a file last changed. They are different questions and only one of them is "activity".
3. **Mark bulk events rather than hiding them.** A day where more than half the deck shares a timestamp to the minute is an import. Label it.

## Fit

Parented to the v4.3 milestone: this is the board reading more of what beans already knows, which is that milestone's whole thesis.

## Todo

- [ ] Decide daily or weekly binning against a real deck, not a synthetic one
- [ ] Decide whether `createdAt` and `updatedAt` are one chart with a toggle or two
- [ ] Detect and label bulk-write days instead of letting them read as activity
- [ ] Draw it in the chrome, inline SVG, no library: the board is offline-locked
- [ ] Respect `prefers-reduced-motion` if it animates, and carry a text equivalent
- [ ] Handle the empty and single-day cases without drawing a misleading axis
- [ ] Guards in test_board.py, added by insertion with a test-count assertion
