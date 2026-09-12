---
# toolshed-odnx
title: Statusline flashes bean deltas after a write
status: completed
type: feature
priority: normal
created_at: 2026-09-11T05:37:06Z
updated_at: 2026-09-11T07:04:34Z
parent: toolshed-z6tz
---

After a bean is added, removed or closed, the statusline shows the delta for a few seconds next to the beans count (`+1`, `−1`, `✓1`), then settles back to the regular readout. No hook: the bar already reads `.beans/` every repaint, so it remembers the last counts in its cache dir, compares, and flashes on change.

- [x] beans awk pass returns the total bean count as an eighth field
- [x] S2 remembers open/doing/total per beans dir in `$CACHE_DIR`, flashes the delta for `BEANS_FLASH_TTL` seconds
- [x] tests in `test_statusline.py`: first paint is silent, add flashes `+1`, remove flashes `−1`, close flashes `✓1`, flash expires, a second change restarts it
- [x] docs: state-contract (cache file), GUIDE section 11
- [x] release 4.1.20, PR, merge

## Summary of Changes

Shipped as adjudant 4.1.20 on `feature/toolshed-odnx`.

- The beans awk pass returns the total as an eighth field.
- S2 keeps `open doing total flash_ts flash_text` per beans dir in `~/.claude/statusline-cache/beans-{key}`; one `read` per repaint, one redirect on change. First sight records silently. `+N` green, `−N` red, `✓N` vault-write green, `↺N` tan; 8 seconds (`ADJUDANT_BEANS_FLASH_TTL` for tests).
- 10 new tests in `test_statusline.py`; suite 1665.
