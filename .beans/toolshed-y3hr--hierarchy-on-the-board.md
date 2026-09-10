---
# toolshed-y3hr
title: Hierarchy on the board
status: todo
type: feature
priority: high
created_at: 2026-09-10T09:25:27Z
updated_at: 2026-09-10T09:25:27Z
parent: toolshed-e4y3
---

Beans enforces milestone → epic → feature → task/bug. The board renders none
of it.

- [ ] Group or indent children under their parent, or give epics swimlanes
- [ ] Make `parent` in the sheet a link that jumps to that card, not inert text
- [ ] Roll-up counts on a parent card
- [ ] `validate.py:1009` (`beans-adapter-parity`) checks statuses only; it parses
      `beans update --help` for the status list and never looks at the type
      vocabulary, so a new beans type would drift silently. Extend it.

The one hierarchy signal today is accidental: `type` becomes `category`, so an
epic is a different colour from a task. That says nothing about which tasks
belong to it.
