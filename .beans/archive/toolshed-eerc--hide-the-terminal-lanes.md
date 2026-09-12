---
# toolshed-eerc
title: Hide the terminal lanes
status: completed
type: feature
priority: normal
created_at: 2026-09-11T02:02:56Z
updated_at: 2026-09-11T02:08:07Z
parent: toolshed-e4y3
---

Completed and Scrapped hold the cards nobody is working on, and on a real deck they hold most of them. On the 92-card HubSpot Nightly deck those two lanes plus Draft carry 21+1+4 of 92, and Todo alone carries 54: the lanes you scan are squeezed by lanes you are done with.

A lane is terminal when `laneStamp(col)` returns one. That is already deck data, not two hardcoded ids: `completed` carries BUILT and `scrapped` carries DROPPED on a beans deck, `done` and `icebox` get theirs from the STAMP defaults on a vault deck. So one rule covers both without naming a single lane.

## Todo

- [ ] A toggle in the chrome, not a per-board setting: it is how a person reads, like the note view
- [ ] Terminal means `laneStamp(col)`, never a hardcoded id
- [ ] Say how many lanes and cards are hidden, so nothing vanishes silently
- [ ] A card in a hidden lane must still be reachable: the sheet's lane row keeps every lane
- [ ] Never hide every lane; a deck of only terminal lanes still shows them
- [ ] Guards, added by insertion with a test-count assertion
