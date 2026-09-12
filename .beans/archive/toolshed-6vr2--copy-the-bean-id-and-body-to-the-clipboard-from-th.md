---
# toolshed-6vr2
title: Copy the bean id and body to the clipboard from the sheet
status: completed
type: feature
priority: normal
created_at: 2026-09-11T00:49:41Z
updated_at: 2026-09-11T01:02:27Z
---

The sheet shows the id and the body and neither can be taken out of the page. Quoting a bean id into a `beans update` command means retyping it off the screen.

## Todo

- [x] Copy button on the Id fact row
- [x] Copy button beside the Pretty/Raw toggle, copying the RAW body whichever view is showing
- [x] Falls back to execCommand. The textarea goes off-screen, not display:none, because a hidden element cannot be selected
- [x] Confirms in place and announces in the live region
- [x] A failure says Failed and wears .bad; the label always returns to Copy
- [x] 3 guards, plus 7 unrelated guards restored after finding they had been deleted
- [x] Bumped to 4.1.12 and documented

## Summary of Changes

Shipped in 4.1.12.

`copyText` prefers `navigator.clipboard` and falls back to `execCommand`, because a board served from `board.py` is a secure context and one opened as `file://` is not. `copyButton` reports the outcome honestly: **Copied** or **Failed**, the latter wearing `.bad`, both announced in the live region, and the label always returns to **Copy**.

Verified in-browser by stubbing the clipboard: the Id button copies `card.id` exactly, the Note button copies `card.notes` verbatim with code fences and `- [ ]` intact while Pretty was the showing view. The real write was refused with NotAllowedError in the automated context, which exercised the failure path and proved it reports rather than lies.

## Found while doing this

**7 guards had been silently deleted.** `test_board.py` held 151 tests at 4.1.7 and 144 at 4.1.11. The cause was a slice-replace in the 4.1.9 guard rewrite that took everything between two anchors, and the suite stayed green because fewer tests still all passed. Restored: the two wipe guards, the four task-list guards, and the display-face guard. All pass against current code. Total now 1577.
