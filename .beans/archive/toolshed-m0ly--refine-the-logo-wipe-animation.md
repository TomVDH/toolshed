---
# toolshed-m0ly
title: Refine the logo wipe animation
status: completed
type: task
priority: normal
created_at: 2026-09-10T09:05:01Z
updated_at: 2026-09-10T21:52:46Z
parent: toolshed-7hyn
---

The wipe is prototyped and reads correctly, but it is a first cut.

## To clean up

- [x] Timing: 680ms total (620ms + 60ms delay), down from 1050ms. Board chrome, not a splash screen
- [x] Once per page load. render() never recreates the nodes, so it cannot re-fire on a filter or a move. No session flag: at 680ms it does not earn the state
- [x] It unfurls. Was translateX(-100%) to 101%, a finished block dealt in from outside the page. Now clip-path from the left edge, so it grows out of the figure standing there
- [x] THE OPPOSITE, and this was the real bug. Trailing broke it. Measured: the word was 90% drawn 200ms in, under a bar that had not reached it. Locked to one timeline; worst mismatch now 0.0000% over 32 sampled frames
- [x] Confirmed and guarded. clip-path:none must be lifted too, not just the animation stopped, or the wordmark never appears at all
- [x] Exception written into the CSS above the rule, naming why it is allowed and what it must stay under

## Depends on

The parent covers the light/dark assets. The animation cannot be finalised until the dark asset exists, since the band colours and the figure ink interact.

## Summary of Changes

Shipped in adjudant 4.1.7.

**The real bug was not the timing.** The bean guessed the reveal wanted to trail the band. The opposite is true, and trailing was already what it did wrongly. Measured on the shipped 4.1.6 build: the wordmark was 90 percent drawn 200 ms in, sitting under an opaque bar that had not reached it. The band swept on `--ease` while the word faded on the same curve over a different window, so nothing revealed anything, two things just happened near each other.

A wipe is one constraint: **the width of wordmark showing must equal the width the band has vacated, at every instant.** The band occupies `[left, 100%]`, so it has vacated `[0, left]`, so the word's right inset must be exactly `100% - band left inset`. That only holds if both share duration, delay, driver and keyframe split. They do now. Verified across 32 sampled frames: **worst mismatch 0.0000%**.

Also: 1050 ms to 680 ms; the band unfurls out of the figure via clip-path instead of sliding in from off-canvas as a finished block; two curves because it is two gestures, decelerating out of the plume and even on the way off since that half is the wordmark arriving; the doctrine exception is written above the rule.

2 guards, including one that fails if the two animations ever drift apart. 1574 tests, 28 validators green.
