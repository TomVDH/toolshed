---
date: 2026-09-09
status: design, approved (settled with Tom 2026-09-09; four decisions recorded under "Decisions")
scope: adjudant + Beans — one tracker per repo, board as the Beans front end, statusline S2, and a degrade path that assumes the CLI is missing
plugin: adjudant
version-target: 3.3.0
related: v3 design (2026-09-01) for the six-verb shape; ~/.claude/statusline-v2.sh S2; Beans at github.com/hmans/beans; the beans-prime plugin, installed but inert
---

# Adjudant and Beans: one tracker per repo

## Context

Beans is a CLI issue tracker that stores issues as markdown files in `.beans/`
next to the code. It is installed on this machine as a Homebrew binary, and its
Claude Code plugin, `beans-prime` 1.0.0, is installed too. That plugin is three
files: a manifest, a README, and two hook entries that run `beans prime` at
SessionStart and PreCompact. Its own README says it is not ready for use.

Adjudant already tracks work: vault task notes under `projects/{slug}/tasks/`,
rendered onto a kanban by the `board` verb. So a repo with both installed has
two trackers that do not know about each other, storing the same kind of thing
in two places, in two vocabularies.

This design ends that. It does not sync them.

## The evidence that rules out syncing

The two models do not line up, and Beans is the richer one.

| | Beans | Adjudant task note |
|---|---|---|
| Statuses | `draft`, `todo`, `in-progress`, `completed`, `scrapped` | `backlog`, `next`, `doing`, `review`, `done`, `icebox`, `dropped` |
| Kinds | `bug`, `feature`, `task`, `epic` | `task` only |
| Priority | `critical`, `high`, `normal`, `low`, `deferred` | none |
| Hierarchy | `parent`, plus blocking and blocked-by | none |
| Concurrency | `etag` per issue, `--if-match` on write | none |

Adjudant's `next` and `review` have no Beans equivalent. Beans' `draft`,
`priority`, `parent` and blocking have no adjudant equivalent. A two-way sync
loses data in one direction and invents it in the other.

Adjudant has also already paid for this class of bug twice. v1.0.0 fixed a deck
that diverged from its task notes, and a later fix stopped the board reverting a
status a person had set in Obsidian. Both were one store guessing about another.
A third store would be a third guess.

## Decisions

1. **One tracker per repo.** Where Beans owns the repo, Beans owns the work
   items. Adjudant keeps sessions, decisions, briefs, handoffs, indexes, `draw`
   and the rest of `dream`.
2. **The board becomes the Beans front end.** It seeds from `beans list --json`
   and writes back with `beans update --if-match`. No `beans-serve` binary is
   installed on this machine, so this is the only graphical view of a bean.
3. **The statusline extends S2** rather than adding a segment.
4. **Adjudant must work with no Beans at all.** Stated by the owner as a
   requirement, and load-bearing here because the repo is mirrored across two
   machines and the binary may exist on only one.

## Two facts, never conflated

The design turns on keeping these apart.

**Is this repo Beans-owned?** The breadcrumb key `tracker: beans`. Persistent,
travels with the repo, read in microseconds on paths that already read it.

**Is `beans` on this machine?** `shutil.which("beans")`. Machine-local, never
written to the breadcrumb, never inferred from the breadcrumb.

Conflating them is how a repo that is Beans-owned on one machine becomes a
broken repo on the other. All four combinations have defined behaviour:

| Repo says | Machine has | Behaviour |
|---|---|---|
| vault (default) | no beans | Today's behaviour, byte for byte. No new code runs. |
| vault (default) | beans | Today's behaviour. Presence shows in the session banner only. |
| beans | beans | This design. |
| beans | no beans | Refuse and report. Never fall back to vault. |

### Why the last row refuses

A Beans-owned repo has an empty `tasks/` by design. Falling back to vault
behaviour would reseed the board from that empty folder and replace a deck of
real beans with an empty board. The work would look like it had vanished. It
would be recoverable, because Beans still owns the truth on the other machine,
but the board would be lying, which is the failure this codebase has fixed
twice already.

## Components

### `adjudant/scripts/_beans.py`

New, stdlib only. The only module that runs the `beans` binary.

```
available()                            -> bool          # shutil.which
owns(project_root)                     -> bool          # breadcrumb tracker: beans
list_beans(project_root)               -> Result[list]  # beans list --json
set_status(project_root, id, s, etag)  -> Result[dict]  # beans update --if-match
create(project_root, title, body)      -> Result[dict]  # beans create --json
to_card(bean)                          -> dict          # bean -> board card
COLUMNS                                -> list[dict]    # the Beans lane set
```

Every call is `subprocess.run` with `cwd` at the project root, an explicit
timeout, and `shell=False`. Failures return a typed `Result` carrying the
stderr line, never an exception. Exit codes are already usable: `beans list`
exits 0 in an empty project, 1 when there is no project, and `beans update`
exits 1 on an unknown id.

### `_profile.py` and `build-profile.json`

Beans gains a capability entry: `id: beans`, `probe: beans`, plus its
`check_line`, `sitrep_line` and `session_banner`. That reuses the machinery
that already answers "is this tool on this machine", including its SessionStart
banner and its status line.

`_profile` keeps its stated contract, unchanged: *a probe only, the executable
is never run*. `_profile` reports presence; `_beans` does the driving.

### `connect.py`

Gains `tracker` in the canonical breadcrumb key set. On connect, if
`_beans.available()` and `beans list --json` exits 0 from the project root,
write `tracker: beans`; otherwise `tracker: vault`. A `--tracker` flag forces
either value, which is the escape hatch for a repo that has beans but should
not use it.

The existing writer already carries unknown keys through untouched (audit
2026-07-27 finding 16), so a breadcrumb hand-edited to `tracker: vault`
survives a re-connect.

### `board.py`

One branch at the seeding point and one at the write-back point.

Seeding, when the repo is Beans-owned and the CLI is present: columns come from
`_beans.COLUMNS`, cards from `to_card`. The mapping is direct, with no
translation and therefore no loss:

| Card field | From |
|---|---|
| `id` | bean `id` |
| `title` | bean `title` |
| `column` | bean `status` |
| `category` | bean `type`, so bug / feature / task / epic get the colour chips |
| `related` | bean `parent`, when set |
| `priority` | bean `priority`, rendered only when it is not `normal` |
| `beansEtag` | bean `etag` |

Lane treatment: `completed` carries the BUILT marker, `scrapped` carries
DROPPED and is muted, `draft` is muted.

Write-back replaces `_rewrite_status` with `set_status`, passing the etag the
card was seeded with. Three outcomes: success, etag mismatch, or failure. On
mismatch the bean changed elsewhere, so the board reports it through the notice
it already has and re-seeds. It never guesses. This is stronger than the vault
path, which infers intent from an ancestor snapshot because notes offer nothing
better.

`board-data.json` keeps its format. Only its source changes.

### `board.html`

One addition: a priority marker on the card, rendered only when priority is not
`normal`. It reuses the `.stamp` treatment rather than introducing a fourth
card element.

### `status.py`

- Reports the tracker in the "where you are" band.
- When the repo is Beans-owned and the CLI is missing, raises that in the
  "what is wrong now" band, with the fix.
- `--capture-task` calls `beans create` and prints the new id. With the CLI
  missing it refuses and prints the command to run later, rather than writing a
  vault note Beans will never see.
- Sync writes `projects/{slug}/_beans.md` when the CLI is present, and leaves
  the existing file untouched when it is not. A stale mirror beats an emptied
  one.

### `_beans.md`, the vault mirror

A generated, read-only index of open beans under the vault project, so `dream`
can still reason about the work and the vault is not blind to it. On a machine
without the CLI it is the only record of the work the vault can see, which is
its main job rather than a convenience.

Contents, fixed so the file is diffable and a regeneration that changes nothing
writes nothing:

- A generated-file banner naming the source and the generating verb, so nobody
  edits it by hand expecting the edit to survive.
- `generated: {YYYY-MM-DD}` and the count of beans read.
- One line per bean that is not `completed` or `scrapped`, sorted by status in
  lane order and then by id: `- {id} · {status} · {title}` with the priority
  appended only when it is not `normal`.
- Nothing else. No bodies, no timestamps, no etags. Etags are machine state and
  would churn the file on every regeneration without telling a reader anything.

It joins the write gate's `_SKIP_NAMES` beside `_handoff.md`, `_index.md`,
`_iteration.md` and `brief.md`. It is generated and never hand-authored, so it
needs no FIELD_SCHEMA entry and no template.

It is written through `atomic_write_text` under `file_lock`. Every new vault
write path in this design uses those two, with no exceptions.

### Statusline S2

A beans clause inside the existing segment. It must never shell out on the
render path: `beans list --json` measured 52 to 62 ms over five runs, and the
statusline redraws constantly.

Mechanism: cache keyed on the newest mtime under `.beans/`. Unchanged mtime
reads the cached counts. A moved mtime triggers a background refresh, the way
S4b already refreshes the 24-hour cost. Silent when the repo is not Beans-owned
and silent when the CLI is missing.

Render shape follows S2's existing separators: open count, then in-progress
count.

## Invariants

1. **No hook ever runs `beans`.** Hooks fire on every Write and every Bash
   call. The commit-log hook already spends 45 ms of module imports per Bash
   call; a 52 ms subprocess on that path would be worse. Enforced by a
   validator.
2. **`_beans.py` is the only module that runs the binary.** Nothing else
   imports `subprocess` for this purpose.
3. **The skips are driven by the breadcrumb, not by the CLI.** `clean` and
   `dream` skip `tasks/` because `tracker: beans` says so. A missing binary must
   never make `clean` start judging a folder it was told to ignore, on the
   machine least able to check the result.
4. **No fallback from Beans to vault.** See "Why the last row refuses".
5. **Every new vault write uses `atomic_write_text` under `file_lock`.**

## Drift defense

Two new validators:

- `beans-adapter-parity`: every status the CLI declares in `beans update --help`
  has a lane in `_beans.COLUMNS`. When Beans adds a status the build fails,
  rather than the board quietly filing it under unknown.
- `beans-not-in-hooks`: no file under `hooks/scripts/` mentions `beans`.

## Testing

The suite stays hermetic and stdlib only. `_beans.py` is tested against a fake
`beans` executable placed on a temporary PATH, which also makes the failure
modes reachable: non-zero exit, malformed JSON, timeout, etag mismatch.

Named tests, one per cell of the four-way table, plus:

- the whole suite passes with `beans` scrubbed from PATH
- a Beans-owned repo with no CLI does not modify `board-data.json`
- a Beans-owned repo with no CLI does not modify `_beans.md`
- `clean` still skips `tasks/` with no CLI present
- `capture-task` writes no vault note in a Beans-owned repo

Guards are mutation-proven, matching the repo's existing standard: each safety
guard has a test that fails when the guard is removed.

The board's browser pass is re-run against a Beans-seeded deck, because the
structural guards in `test_board.py` are explicit that a green suite does not
stand in for driving the page.

## Out of scope

- Two-way sync between `.beans/` and vault `tasks/`. Ruled out above.
- Reading or writing `.beans/*.md` directly. That reimplements Beans' ID
  generation, index and etag semantics, and breaks the first time Beans changes
  its own format. The CLI is the supported contract.
- The `beans graphql` endpoint. It needs a running server; `beans-serve` is not
  installed here.
- Replacing or configuring the `beans-prime` plugin. It is inert and separate.
- Migrating existing vault task notes into beans. If that is wanted it is its
  own verb, with a preview and a backup, and its own version.

## Sequencing

Ships as 3.3.0, after the board redesign lands as 3.2.0. This design edits
`board.py` and `board.html`, which are the two files that redesign changes.
