# Repository Guidelines

`toolshed` — personal Claude Code plugin marketplace by Tom Vanderheyden. Hosts multiple plugins; each plugin is self-contained in its own directory. (GitHub repo: `TomVDH/toolshed`, renamed from `onnozelaer-claude-marketplace`; GitHub redirects the old path.)

## Project Structure

```
.
├── .claude-plugin/
│   └── marketplace.json     # Marketplace manifest — source of truth for every plugin's version + description
├── .beans/                  # work items, TRACKED IN GIT. See "Work items" below
├── .beans.yml               # beans config: types, statuses, priorities for this repo
├── adjudant/                # Vault editor/writer + project initializer, /adjudant with six verbs and a two-tier cleanup model (successor to the retired obsidian-bridge). v4; the v3 redesign shipped
├── cabinet-of-imd/          # Crew/persona flavor layer (functionality sunset; character-only)
├── tui-toolbox/             # Operating language for agent-built helper CLIs (bash TUI + python helper); formerly cli-wrapper-helper
├── gemineye/                # Sandboxed Gemini second opinion via the agy CLI (SUNSET 2026-08-12: unlisted from marketplace, kept in tree)
├── iteration-shelf/         # Terminal-aesthetic in-browser design review boards (SUNSET 2026-08-12: unlisted from marketplace, kept in tree)
├── docs/                    # historical design docs, plans, and specs; archived material under docs/archive/
├── scripts/                 # repo-root tooling: bump_plugin_version.py, check_marketplace_versions.py + tests
├── .github/workflows/       # validate.yml: CI rerun of the local validators on push/PR
├── .worktrees/              # one linked worktree per feature bean, feature/<bean-id>; git-ignored
├── .gitignore               # ignores session-local .claude/ state, .superpowers/, .worktrees/
├── .pre-commit-config.yaml  # validators that fail the build on drift
├── README.md
└── AGENTS.md / CLAUDE.md    # this file + Claude overrides
```

## Work items

This repo tracks work in **beans**, not in a vault and not in a todo list. `.beans/`
is tracked in git, so a bean is reviewed and merged like code.

1. Run `beans prime` and follow it. That output is generated from this repo's own
   `.beans.yml`, so it is always current. Nothing restates it here.
2. Find or create a bean before starting work.
3. Keep its checklist current as you go: `- [ ]` becomes `- [x]` when the thing is done.
4. Commit the bean file in the same commit as the code it describes.

Hierarchy is enforced: milestone, then epic, then feature, then task or bug. A task
cannot parent a task.

## Adding a new plugin

1. Create `<plugin-name>/` at repo root with:
   - `.claude-plugin/plugin.json` — name, version, description, author, keywords
   - `commands/<plugin-name>.md` (if it has slash commands)
   - `skills/<skill-name>/SKILL.md` (if it has skills)
   - `hooks/hooks.json` + `hooks/scripts/` (if it has hooks)
   - `README.md`
2. Add an entry to `.claude-plugin/marketplace.json` with name, version, source path, description.
3. Bump marketplace version if needed.
4. Commit per the conventional-commits style below.

For plugins that follow the **Impeccable pattern** (one skill, one root command with sub-verbs):
- `<plugin>/skills/<plugin>/` is the real canonical directory (content lives here)
- `source/skills/<plugin>/`, `.claude/skills/<plugin>/`, and `.gemini/skills/<plugin>/` are all symlinks into it (`harness-parity` validator enforces they resolve to the canonical dir)
- `scripts/validate.py` enforces drift defense
- `scripts/command-metadata.json` is the single source of truth for verb metadata

`adjudant/` is the reference implementation of this pattern.

### Bumping a plugin version

A plugin's version is kept in lockstep across up to four files (`plugin.json`,
`scripts/command-metadata.json`, `SKILL.md` frontmatter, and the `marketplace.json`
entry). Don't edit them by hand — run `python3 scripts/bump_plugin_version.py <plugin>
<X.Y.Z>` to write all of them atomically (idempotent; enforced by the
`version-consistency` validator + `check_marketplace_versions.py`).

## Build & validate

No compile step. Symlinks propagate the canonical source to harness directories. Validators run via pre-commit (or manually).

```bash
# Install pre-commit hook (one-time per clone)
pre-commit install

# Run validators manually
pre-commit run --all-files

# Run adjudant's specific validators
python3 adjudant/scripts/validate.py

# Run the test suite
python3 -m unittest discover -s adjudant/scripts -p 'test_*.py'
```

Current gate: 28 validators, 1627 tests. Both must pass before a commit.

## The board template is offline-locked

`adjudant/skills/adjudant/templates/board.html` is the only HTML surface adjudant
emits, and it is served from disk. Validator 24 fails the build on any off-machine
`href`, `url()` or `@import`. A `data:` URI is allowed, because it fetches nothing.

Two consequences a newcomer would otherwise undo:

- The display face is an embedded woff2 subset, not a webfont link.
- The mark is inline SVG, not an `<img>`. An external SVG is a separate document
  and cannot see the page's custom properties, which is how the ink follows the
  colour scheme.

The template has no JavaScript test runner, by design. Its tests assert that the
code implementing a behaviour is still shaped the way it was when that behaviour
was last verified in a browser. A green suite is not a substitute for driving it.

## Universal drift defense (via hookify)

Cross-machine, cross-project drift defense rules live in iCloud, NOT in this repo. Hookify reads them from each project's `.claude/` via symlinks.

| | |
|---|---|
| Canonical rules | `~/Library/Mobile Documents/com~apple~CloudDocs/Projects/IDE/claude/hookify/` |
| Install script | `~/Library/Mobile Documents/com~apple~CloudDocs/Projects/IDE/claude/install-hookify-rules.sh` |
| Install into a project | `cd /path/to/project && "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Projects/IDE/claude/install-hookify-rules.sh"` |

Current rules: `git-safety`, `destructive-bash`, `tom-voice`, `secret-scan`, `no-deprecated-tags`, `icloud-eviction-paths`, `path-quote`. Idempotent install; rules sync across machines via iCloud.

Hooks that need logic (not regex) — symlink-integrity, plan-age, version-drift, AGENTS/CLAUDE presence — are not in hookify; they'd need custom shell hooks, currently deferred.

## Cross-machine setup

This repo is mirrored across two machines. The OneDrive folder syncs the working tree; the `.git` store lives **inside** OneDrive (small enough that packfile-deadlock issues haven't surfaced — monitor and move out-of-tree if they do).

| Machine | macOS user |
|---|---|
| Personal | `tomlinson` |
| Work | `tomvanderhegden` |

Always `git pull --ff-only` before starting work; the other machine is often ahead. Tasks and bugs push straight to `main` from either machine; feature beans go through a branch and a PR (see "Git practice"). A worktree removed on the other machine leaves a dangling entry here: `git worktree prune`.

## Git practice

The bean type decides where the code goes. Adjudant states this every session, provisions it into every project it connects, and `/adjudant status` reports drift. Nothing blocks a commit; the report is the guard.

- A `feature` bean gets its own branch, `feature/<bean-id>`, always checked out in a worktree: `git worktree add .worktrees/<bean-id> -b feature/<bean-id>`. The main checkout stays on `main` and is never `git switch`ed.
- An `epic` is a container and gets no branch. A `task` or `bug` commits on `main`, or on its parent feature's branch when that feature is in progress.
- `.claude/adjudant` is git-ignored, so copy it into a new worktree: `cp .claude/adjudant .worktrees/<bean-id>/.claude/adjudant`. Without it adjudant is silent there.
- Version bumps happen on the feature branch (`bump_plugin_version.py`) and reach `main` with the PR, so `main` only carries released versions.
- Merge-back: `git push -u origin feature/<bean-id>`, `gh pr create`, merge on GitHub, then `git worktree remove .worktrees/<bean-id>`, `git branch -d feature/<bean-id>`, `git pull --ff-only`.

The full contract is `adjudant/skills/adjudant/reference/repo-standards.md`, "Git practice".

## Commit conventions

Conventional Commits style. Match existing history:

```
feat(adjudant): shelf verb #11 wired into command-metadata, SKILL router, reference, parity surfaces
fix(gemineye): stop pinning model IDs the agy backend rejects
release(iteration-shelf): v0.1.1 - integration truth pass: adjudant persistence, standalone-skill attribution
chore(marketplace): bump adjudant to 0.14.0 in marketplace.json registry
docs(adjudant): migration guide from the retired obsidian-bridge verbs to /adjudant
```

- Scope is the plugin name (or `marketplace` for cross-plugin manifest changes).
- Version bumps use `release(<plugin>): vX.Y.Z - <summary>`.
- The bean file lands in the same commit as the code it describes.

## Naming

- Plugin slugs: kebab-case, no namespace prefix (`adjudant`, not `onnozelaer-adjudant`).
- Skill names inside a plugin: kebab-case.
- Command names: kebab-case after the `/`.

## What this repo does NOT contain

- No long-lived branches. `main` plus one short `feature/<bean-id>` branch per feature bean in flight, merged by PR and deleted. Tasks and bugs push straight to `main`.
- No CI beyond a thin GitHub Action (`.github/workflows/validate.yml`) that reruns the local validators on push and PR; pre-commit remains the primary gate.
- No publish step beyond `git push origin main`. Claude Code's marketplace install pulls directly from the git remote.
