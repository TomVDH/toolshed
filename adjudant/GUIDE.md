# Using Adjudant

A walkthrough, from installing it to living with it. For the terse reference, see [README.md](README.md).

## What it's for

You work in a code project. The thinking around that project — why you made a decision, what you tried last week, what's half-finished — usually lives in your head or scrolls out of a chat. Adjudant writes it down, in an Obsidian vault, in a consistent shape, and keeps it current without you managing it.

The mental model: **your code project is the work, the vault is its memory.** You keep coding; adjudant keeps the record.

You don't have to open Obsidian for any of this. The vault is plain markdown files. Obsidian just makes them nice to browse.

## 1. Install and link

Install once per machine:

```
/plugin marketplace add TomVDH/toolshed
/plugin install adjudant
```

Link each project once:

```
/adjudant connect
```

`connect` looks at your project, proposes a vault location, a slug, a type, and a status, and shows you one card to confirm. Approve it and it writes:

- `.claude/adjudant` — a small breadcrumb pointing at the vault. Every later verb reads this, so you never type vault paths.
- A project folder in the vault, with a `brief.md`, a `sessions/` folder, and the scaffolding.
- Today's session note.

`connect` is idempotent. Running it again on a linked project changes nothing.

**No vault yet?** Point `connect` at where you want one and it scaffolds it.

## 2. A normal session

After connect, most of adjudant is invisible. As you work:

- A **session note** for today is created and kept updated. Commits, decisions, and notes you write land in it.
- When you write a decision or a note into the vault, adjudant checks its shape first. If a required field is missing, the write is blocked with a message saying what's wrong, so it never lands malformed.
- A **handoff** file tracks where things stand, so the next session (or the same project on another machine) starts oriented.

You don't call a verb for any of that. It rides on hooks.

## 3. Tasks and the board

Task notes live under the project's `tasks/` folder. Run `/adjudant board` once and a **kanban board** opens on them. Writing a task note never creates a board by itself — until v3 it did, which is how projects that never asked for one grew a `board/` folder anyway. From then on:

- The board reseeds itself at session end, once it exists.
- Open it with `/adjudant board serve` — a single HTML file, drag cards between columns, changes save to disk.
- A card you drag writes its new status back into the task note, so the board and your notes never disagree.

You can also edit the board's `kanban.md` inside Obsidian; the drag is read back the same way.

Projects that never grow tasks never grow board files. Nothing to clean up.

## 4. Checking in

One verb, `/adjudant status`. It brings the derived state up to date (the
brief's date, the handoff, the project's row in the index), then tells you
where things stand in three bands:

- **Wrong now** — the vault is claiming something that is false today. A note
  off-schema, a status that disagrees with the folder the project sits in.
- **Going stale** — true now, decaying. A handoff nobody has touched, a project
  that has gone quiet past its threshold.
- **Worth a look** — a question rather than a defect. A filename that broke the
  naming rule, an open loop the last dream flagged.

It also carries the orientation you want after a break: where you left off,
what's done, your git branch and dev-server state. Start here when you come
back to a project cold.

Add `status repo` to also audit the code repo's structure, or `status all` for
both. Add `--no-sync` if you want the report without the writes.

## 5. Keeping the vault clean

Two verbs, in a deliberate ladder from safe to careful. Match the verb to how much you want to trust it:

| Verb | Cadence | What it touches | Risk |
|---|---|---|---|
| `clean` | routine (daily/weekly) | indexes, wikilink form, dates, off-schema frontmatter | none — it never breaks anything, and it cannot create a file |
| `clean --deep` | sparing (quarterly) | nothing; it reports folder shape, file types, naming, broken wikilinks | none — every finding is yours to act on |
| `dream` | as needed | the actual prose — stale, redundant, or orphaned content | semantic, LLM-judged; you approve every change |

`clean` **previews first**: it shows you exactly what it would change and waits. Apply only happens on your say-so, and it backs up what it touches. It may rewrite a file and remove one; it may not add one, which is enforced in the code rather than promised here. `dream` is the deepest: it reads the content itself, hands you a catalog of what looks stale, and changes nothing until you judge each item.

Heavy verbs estimate their cost before running. If `dream` would pull a large vault into the conversation, it tells you the size and asks before proceeding.

## 6. Diagrams

```
/adjudant draw diagram <name>     # a mermaid diagram
/adjudant draw canvas <name>      # an Obsidian canvas
/adjudant draw base <name>        # an Obsidian base (a live table view)
```

Hand-author them, or let adjudant generate one from your vault's own data (project relations, the board, the cleanup tiers).

## 7. Project lifecycle

Projects don't stay active forever. The vault carries the state in the folder:
`projects/` holds the live ones, `projects/_fridge/` the paused ones, and
`projects/_archive/` the finished and the abandoned.

Moving a project between them is a folder move you make yourself. No verb does
it. `/adjudant status` reports a project whose declared status and zone disagree,
so a move you forget still gets noticed.

## Living with it

- **Two machines.** The breadcrumb stores the vault's name as well as its path, so a project synced to another machine re-finds its vault even when the absolute path differs. Pull before you start; adjudant does the rest.
- **The voice.** Adjudant sets a direct, no-filler register for the session and refuses to write slop phrases into vault notes. If you'd rather it didn't, add `voice: off` to `.claude/adjudant` (per project) or set `ADJUDANT_VOICE_DISABLE=1` (per machine).
- **Turning down the noise.** Everything ambient is opt-out via the breadcrumb. The reference docs under `skills/adjudant/reference/` document each knob.

## When something looks wrong

- **A write got blocked.** The message names the missing or malformed field. Fix the frontmatter and write again, or run `/adjudant status` to see every drifted note at once.
- **The board didn't appear.** It's born on the first real task note under `tasks/`. No tasks, no board, by design.
- **A verb can't find the vault.** The breadcrumb is missing or points nowhere. Re-run `/adjudant connect`.
- **You want the details.** `/adjudant status` for state, `reference/internals.md` for how the machinery is wired.

## 8. The advisor (opt-in)

By default adjudant only speaks when spoken to. Turn the advisor on and it
also *notices* — open loops, missing notes, work that contradicts a decision,
context that has gone stale:

```
/adjudant status --advisor on
```

The flag is visible twice: `advisor: on` in `.claude/adjudant`, and a marker
line in AGENTS.md, so neither you nor a future session can forget it is
active. Every session start announces it.

- Urgent findings (contradicting a locked decision, diverging from the plan)
  surface inline, at most a sentence or two, marked with `❦`.
- Everything else is proposed as a board card or held for the next `status`.
- Nothing is ever written without your yes.

Every `/adjudant status` carries the context-integrity pulse: expired facts,
dangling supersessions, drift between the plan and the work.
`/adjudant status --advisor off` removes the flag, the marker, and the
behaviour.

## 9. Naming things

Kebab-case is the vault's naming rule, and most of it is on you to follow.
Ask for a name at write time:

```
/adjudant status --slug Fix the parser rewrite
fix-the-parser-rewrite
```

Use it before you create a note, task, source, or decision, and the name is
right the first time.

Every `status` report also lists filenames whose title broke the rule, with the
corrected name for each, under **worth a look**. It never renames anything:
renaming breaks every wikilink pointing at the file, and that repair is yours to
make: `clean --deep` reports the name, and you decide. Docs are exempt, because
the standard wants those UPPERCASE.

## 10. Branches and worktrees

In a repo that tracks work in beans, the bean type decides where the code
goes. A `feature` bean gets its own branch, `feature/<bean-id>`, checked out
in a worktree at `.worktrees/<bean-id>`. The main checkout stays on `main`.
Tasks and bugs commit on `main`, or on their parent feature's branch when
that feature is in progress. Epics are containers and get no branch. When
the feature is done, push the branch, open a PR, merge it on GitHub, then
remove the worktree and delete the branch.

The session-start banner says this in one line every session. `/adjudant
connect` writes the full rule into a new project's `AGENTS.md`. Nothing
blocks a commit that breaks it; instead `/adjudant status` reports drift:
a main checkout that wandered off `main`, a feature in progress with no
branch, a branch with no worktree, a worktree or branch that outlived its
bean, and a dirty `main` while a feature is in progress. The two "outlived"
findings land under **going stale**, the rest under **worth a look**.

One thing to know before your first worktree: `.claude/adjudant` is usually
git-ignored, so a fresh worktree has no breadcrumb of its own. It does not
need one. A linked worktree's `.git` is a file naming the main checkout, and
that is enough: the statusline reads the main checkout's breadcrumb from the
first repaint, and the session-start hook links it in
(`.claude/adjudant -> <main>/.claude/adjudant`) so the banner, the hooks and
`status` all find it. A link rather than a copy, so a later `connect` on main
flows through.

## 11. The statusline

The bar at the bottom of Claude Code is adjudant's too. It shows the git
segment (branch, dirt, diff size, time since the last commit, ahead/behind,
a `⎇` on a regular checkout or a `⑂` inside a worktree; the name opens
the folder on Cmd+click), the vault or beans slot (open items, what is in
motion, a handoff age), the model and context, and the day's cost. Install
it once per machine with `statusline/install.sh` from the installed plugin
(the README has the one-liner) and add the `statusLine` block it prints to
`~/.claude/settings.json`.

After that nothing is yours to maintain: each session start points the shim
in `~/.claude` at the plugin copy that is installed right now. Two things
worth knowing. The `!` in front of the branch is the branch rule from
section 10 breaking: the main checkout is off `main`, the worktree you are
in belongs to a finished bean, or a feature in progress has no branch. And
in a fresh worktree the bar is quiet about all of that until you copy
`.claude/adjudant` in, for the same reason the banner is.

The beans count also reacts to writes. Add a bean and the count flashes
`+1` in green for eight seconds; remove one and it flashes `−1` in red;
close one and it flashes `✓1`; reopen one, `↺1`. Then the plain count is
back. Nothing writes to the bar to make this happen: it remembers the last
counts it saw and notices the difference on the next repaint, so a bean
created by hand, by `beans create`, or by the board all flash the same.
