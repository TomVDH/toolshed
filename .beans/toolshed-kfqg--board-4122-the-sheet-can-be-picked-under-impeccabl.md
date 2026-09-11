---
# toolshed-kfqg
title: 'Board 4.1.22: the sheet can be picked under impeccable live'
status: completed
type: task
priority: normal
created_at: 2026-09-11T08:22:02Z
updated_at: 2026-09-11T08:22:02Z
parent: toolshed-cwfk
---

Tom: the flyout displays over impeccable when open, so it cannot be selected for a round.

- [x] openSheet uses show() when the injected live script is on the page, showModal() otherwise; signal read at open time
- [x] .sheet[open]:not(:modal) pinned fixed right at z 40, where the modal one sits
- [x] Guard and reference/board.md section

## Summary of Changes

A modal dialog lives in the top layer above the picker. Under live the sheet leaves the top layer; shipped boards are unchanged. Version 4.1.22.
