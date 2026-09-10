---
# toolshed-zzd0
title: Task lists render as checkboxes in the sheet
status: completed
type: bug
priority: high
created_at: 2026-09-10T21:29:58Z
updated_at: 2026-09-10T21:40:15Z
---

The sheet prints `<li>[ ] Test both embeds on the same STG page</li>` -- the literal syntax, with no visual difference between done and not done.

This matters more than it looks. Beans' whole loop is 'keep the bean's todo items current, `- [ ]` -> `- [x]`', and the board is now the front end for that. 10 of 17 toolshed beans carry a checklist.

## Todo

- [x] `mdNodes` recognises a task item and emits a state, not the raw syntax. `[x]` and `[X]` both count as done
- [x] A drawn indicator, not `<input>`. Done steps back to `--text-faint` rather than striking through
- [x] `mdText` strips the marker, AFTER the bullet: the marker only starts the line once the bullet is gone
- [x] The state reaches the accessibility tree: the box is aria-hidden, with a visually hidden "done, " / "to do, " beside it
- [x] Guards in `test_board.py` (4 added)
- [x] Bump to 4.1.6 and document

## Summary of Changes

Shipped in adjudant 4.1.6.

`MD_TASK` recognises a task item inside the list branch of `mdNodes`. `[x]` and `[X]` are done; only a space is open. The list gains `.tasks` and loses its bullets; each item gets a drawn box, a visually hidden state word, and its text in a `.txt` span so done can step back without touching the box.

Deliberate calls:

- **Drawn box, never `<input>`.** This board does not write bean bodies. A checkbox you cannot tick would misrepresent what the page can do.
- **Done steps back to `--text-faint`, no strike-through.** A finished item is still read, and struck text is slower to read when you need to. `--text-faint` is already pinned at 4.5:1 by the contrast test.
- **`--ok` for the check**, because the BUILT stamp already means done on this board.
- **`mdText` strips the marker AFTER the bullet**, since the marker only reaches the start of the line once the bullet is gone. Guarded by index comparison, not just presence.

Verified live on both schemes: 5 task items, 3 done, uppercase `[X]` counted, ordinary lists untouched and unmarked, inline markdown still parsing inside task text, zero `<input>` elements, accessible text reading "to do, Test both embeds on the same STG page...".

4 guards. 1572 tests, 28 validators green.
