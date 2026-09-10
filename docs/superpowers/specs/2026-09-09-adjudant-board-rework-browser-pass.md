# Board template rework: browser pass

**Date:** 2026-09-09 · **Version:** adjudant 3.6.0 · **Template:**
`adjudant/skills/adjudant/templates/board.html`

`test_board.py`'s template guards are structural, not behavioural: they assert
that the code implementing a behaviour is still present and still shaped the way
it was when that behaviour was last driven in a real browser. This is that
browser pass. It lives here rather than in `.superpowers/`, which is gitignored,
so the other machine can read it. The previous board browser report is
unreachable for exactly that reason.

## Fixture

Rendered from the **live** `hubspot-nightly` beans deck, not a synthetic one:
89 cards, `tracker: beans`, lanes `draft / todo / in-progress / completed /
scrapped`, categories `task` (78), `epic` (9), `milestone` (1), `feature` (1),
priorities `critical` (1), `high` (9), `deferred` (20), `low` (14), 45 with none.
A `wip: 4` was set on `in-progress` and one epic was given a long note and two
refs, so the clamp and the reference list were both exercised. Rendered into a
scratch dir via `board.render_template`; nothing was written to the real vault or
the real repo.

## Verified in Chromium

| Behaviour | Result |
|---|---|
| Card face renders title, clamped note, id | Pass. Note clamps at two lines |
| `epic` / `feature` / `milestone` marked, `task` unmarked | Pass. `baseCategory` resolved to `task` at 78 of 89 |
| Priority on the face, `high`/`critical` loud, `deferred`/`low` quiet | Pass |
| Terminal marker once per lane head, not per card | Pass. `BUILT` on Completed, `DROPPED` on Scrapped |
| WIP limit renders `0 / 4` and reddens over the limit | Pass |
| Click a card face opens the sheet | Pass |
| Sheet shows note, refs, id, category, priority, source | Pass. `From: beans` |
| Lane row moves the card | Pass. Todo 52 to 51, In progress 0/4 to 1/4, sheet stayed open, lane row updated |
| Unsaved override disclosed | Pass. `Moved here from: Todo` appeared after the move |
| Move announced in the live region | Pass |
| Move persisted as the moves-only shape | Pass |
| `Esc` closes and focus returns to the card that opened it | Pass, after the fix below |
| Deck replaced under an open sheet closes it | Pass. Sheet closed and announced |
| `[` / `]` on a focused card | Pass. todo to in-progress |
| Drag from the wrapper with the button inside it | Pass. `dataTransfer` carried the key, drop landed the card |
| Tab title takes the board's name | Pass, after the fix below |
| Light and dark | Pass, both |
| 375x812 | Pass. One lane in view, sheet goes full width |

## Found and fixed during the pass

1. **The `close` event is not a reliable place for bookkeeping.** Focus did not
   return to the opening card, and `sheetKey` stayed stale. Isolating it showed a
   **brand-new, unrelated `<dialog>` also failed to fire `close`** in the same
   context: a `close` event is a queued element task, and a throttled or hidden
   page may never deliver it. `requestAnimationFrame` never fired there either,
   which rules it out as a workaround. Fixed by moving all bookkeeping and the
   focus restore into `closeSheet()`, routing `Esc` through a `keydown` handler
   (user input is always delivered), and keeping the `close` listener only as a
   net for any other route.
2. **The tab title was the static `Work-Order Board`** from the template's
   `<title>`, so every board in a portfolio shared one tab name. `render()` now
   sets `document.title` from the deck.
3. **The sheet had no edge.** `--lift` casts downward, which is right for a card
   and leaves a right-edge sheet with nothing separating it from the board. Given
   its own leftward shadow.

## Second pass: every bean field, and the Markdown reader (3.5.0)

Fixture extended: the live 89-bean repo plus three beans from a throwaway lab
repo, one of them carrying every property beans supports (tags, parent,
blocked_by, blocking, a multi-paragraph body, `critical` priority). 92 cards,
categories `bug / epic / task / milestone / feature`.

| Behaviour | Result |
|---|---|
| Every bean property reaches the opened card | Pass. Tags, Parent, Blocked by, Id, Category, Priority, From, Created, Updated, Slug, File, Etag all rendered |
| A row appears only when the card carries that field | Pass |
| `body` reaches `notes` | Pass. 90 of 92 cards have one; the board used to show all of them empty |
| Note renders as Markdown | Pass. A 6,025-character body rendered as `H4 P P H5 P P PRE … UL … BLOCKQUOTE HR` |
| `Pretty` / `Raw` toggle, remembered across reloads | Pass. Preference is per browser, not per board |
| Card face shows note text with syntax stripped | Pass. `## Scope …` reads as `Scope …` |
| Lane rail: one row, scrolls rather than wraps | Pass at 5 lanes and at a synthetic 7-lane vault deck |
| Note toggle drawn as the same control | Pass |

### Found and fixed during this pass

1. **The Markdown reader hung the page.** Emphasis was matched with
   `([\s\S]+?)` closed by a backreference, which backtracks catastrophically
   the moment a delimiter is unpaired. Bean bodies are full of snake_case, so a
   single `_` in `created_at` sent the lazy run to the end of the note and failed
   back, at every start position, on every call. Over 92 real bodies it did not
   finish in 45 seconds. Rewritten so every branch matches through a negated
   character class, which cannot backtrack: **7ms for all 92 cards, 146,123
   characters**. The `_` forms also gained flanking rules, so `created_at` and
   `blocked_by` stay identifiers while `_emphasis_` still reads.
2. **The sheet was filled before it was opened.** `renderSheet()` ran ahead of
   `showModal()`, so the lane rail's scroll-into-view did its arithmetic against
   a `display:none` element measuring zero. The dialog is now opened first (same
   task, so nothing paints between), and the arithmetic was replaced with
   `scrollIntoView({block:"nearest",inline:"nearest"})` so the browser does it.

## Third pass: sheet delineation (3.5.1)

Whitespace alone was carrying every boundary in the sheet body, so it read as one
undifferentiated column of label, content, label, content. Sections now separate
with a hairline rule.

The inline padding moved from `.sheet-body` onto `.sheet-sec`, so a section's rule
runs the **full width of the sheet** the way the sheet head's own rule already
does; inset rules would have introduced a second, weaker kind of line. The space
around each rule is asymmetric (`--s5` above, `--s4` below), so a rule reads as
belonging to the section beneath it, and the gap above a label stays larger than
the gap under it.

Sub-rows inside Relations (Parent / Blocked by / Blocking / References) stay
rule-free, which gives two levels: rules for regions, whitespace for rows.

| Behaviour | Result |
|---|---|
| Five regions delineated on a fully-loaded card | Pass, light and dark |
| Sparse card (no note, tags or relations) | Pass. Lane, rule, Details. `firstVisibleHasRule: false` |
| A hidden section contributes no rule | Pass. `display:none` renders no border, and section one is never hidden, so no stray leading rule is possible |
| 375x812 | Pass. Full-bleed rules read architecturally; the long `File` value wraps |

Deliberately left alone: the thin scrollbar under the lane rail when it overflows
on a narrow screen. It is the platform's own overflow affordance and the only cue
that the rail scrolls; hiding it to look tidier is the trade craft-floor warns
against under "reinventing standard affordances".

## Fourth pass: the ZenaSoft skin (3.6.0)

The board now wears ZenaSoft, the author's own 70s corporate-paper memo identity,
as **Adjudant Classic**. Ported from the ZenaSoft `DESIGN.md` in the HubSpot
Nightly repo, whose own references are IBM annual reports c.1973, Container Corp
of America, Mobil corporate guidelines and Knoll spec sheets: corporate
modernism, not nostalgia.

Taken unchanged: the whole light neutral scale, the accent
`oklch(52% 0.17 38)`, the warm hue 70-75, zero radius everywhere, the two-grid
paper texture, the ease curve, the mono rationing, and the no-entrance-animation
rule (the sheet's slide-in was removed to honour it).

**Four slots had to move, each a fact about this surface rather than a
disagreement with that document.** Every number below was measured with
`test_board`'s own OKLCH-to-sRGB and WCAG functions before a line was written:

| Slot | ZenaSoft | Here | Why |
|---|---|---|---|
| `--text-faint` light | 58% | 48% | A form sets its faint slot at label size; this board sets 11.5px counts, ids and field labels in it, so the 4.5:1 body floor applies. 58% measured **2.99:1** on the well |
| dark neutrals | 25 / 28 / 32 | 22 / 24 / 28 | ZenaSoft's dark puts `surface-2` **above** `surface`, inverting its own light order. A lane well must stay recessive under a card in both schemes |
| dark `--text-dim` / `--text-faint` | 65% / 50% | 78% / 68% | Measured **3.93** and **2.12** against that scale |
| dark `--accent` | locked at 52% | 68% | Locking the accent across themes is right for a light-first identity. Here the accent is also the focus ring, and **2.13:1** fails SC 1.4.11 |

`--park` was lifted to a compliant neutral as well; it had been failing its own
floor since before this work.

**The accent was initially unspent.** After the port, a scripted sweep of every
painted element found the orange appearing **nowhere** on screen, because the
board's focus ring, connected-save state and drop lane are all transient.
ZenaSoft's own accent list includes the active sidebar TOC node and a
`::selection` tint, so both were wired: the rail's live segment is this board's
active node. That is reading their doctrine, not inventing.

**Fonts are named, never fetched.** ZenaSoft loads Mozilla Headline and IBM Plex
from Google Fonts; validator 24 fails the build on any off-machine `href`, so the
stacks are declared and resolve through ZenaSoft's own fallbacks. Georgia is
everywhere, so the serif display lands.

### Known departure from the source document

ZenaSoft keeps the cream paper as the identity **regardless of OS preference**
and makes dark an opt-in toggle. The board still follows `prefers-color-scheme`,
because it has no theme toggle and forcing light on a dark-set OS with no escape
is worse than following the preference. Both schemes are palette-complete and
both clear the contrast floors. A toggle would close this.

## Not verified here

- **`prefers-reduced-motion`.** The rule is present and correct
  (`.sheet[open]{animation:none}`) but was not exercised; the pane offers no
  emulation for it.
- **Connect file / disk write.** The File System Access picker cannot be driven
  headlessly. That code path is unchanged by this rework and is covered by the
  seven structural persistence guards.

## Re-run this pass when the template changes

```bash
python3 adjudant/scripts/board.py serve --dir <scratch>/board --port 8791
```
