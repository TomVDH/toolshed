---
# toolshed-kg7c
title: Readiness and real filters
status: todo
type: feature
created_at: 2026-09-10T09:25:27Z
updated_at: 2026-09-10T09:25:27Z
parent: toolshed-e4y3
---

`beans list --ready` appears nowhere in the repo. `list_beans` is hardcoded to
`["list", "--full", "--json"]`.

- [ ] A ready filter or lane, so the actionable subset of `todo` is visible
- [ ] Blocked and ready counts in the lane heading, beside the raw count
- [ ] Tags as a filter facet, not just search-haystack text
- [ ] Priority as a filter facet
- [ ] `render_mirror` drops type, tags, parent, blocked_by, blocking and body,
      so `_beans.md` is equally blind and `dream` cannot reason about dependency
      structure either
