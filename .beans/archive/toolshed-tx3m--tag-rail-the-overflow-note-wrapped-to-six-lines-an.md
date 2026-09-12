---
# toolshed-tx3m
title: 'Tag rail: the overflow note wrapped to six lines and stretched every key into a slab'
status: completed
type: bug
priority: high
created_at: 2026-09-11T19:52:20Z
updated_at: 2026-09-11T19:52:20Z
---

Seen on a real deck with more than twelve tags at 4.1.27: the "+N more, use the filter box" note sits in the one-line scrolling tag rail with default flex shrink, was squeezed to 31px, wrapped into six lines (103px), and every key stretched to match; the filtered tag's ink block became a black slab across the masthead. The demo deck had exactly twelve tags, so it never showed.

- [x] .legend .rail-more: flex:0 0 auto; white-space:nowrap
- [x] .rails #tagRow .legend: align-items:center
- [x] Guard; verified on a 24-tag deck (note 149x17, rail 20px)

## Summary of Changes

Hotfix 4.1.28.
