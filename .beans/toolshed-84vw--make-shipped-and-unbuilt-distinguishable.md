---
# toolshed-84vw
title: Make shipped and unbuilt distinguishable
status: todo
type: feature
priority: high
created_at: 2026-09-10T09:25:27Z
updated_at: 2026-09-10T09:25:27Z
parent: toolshed-9grg
---

- [ ] A `status:` convention for specs that includes a terminal value, and a
      pass over the existing ones to set it truthfully
- [ ] Reconcile plan checkboxes for shipped work, or stop pretending they track
      anything
- [ ] A validator so a spec claiming `ready for implementation` against shipped
      code fails the build

The cost of not having this is already paid: remise and the move-history ledger
were designed, planned, and lost for five weeks.
