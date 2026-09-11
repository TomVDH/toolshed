# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

**Primary: Tom Vanderheyden**, working across two machines (personal `tomlinson`, work `tomvanderhegden`), driving several repos at once through Claude Code. He already knows beans, adjudant, lanes, etags. He wants density and speed.

**Also: ZenaTech colleagues**, marketing and ops. They open a board someone hands them. They do not know what a bean is. Confirmed by the user, 2026-09-10.

**Also: coding agents.** Every adjudant verb is invoked by an agent as often as by a person, and the board is scaffolded by one. Agent-facing output is a first-class audience, not a side effect.

## Product Purpose

Adjudant operates an Obsidian vault from a code project: six verbs, one command. The board verb scaffolds a self-hosted kanban seeded from `tasks/` notes or from beans, and writes a card's lane back to its source.

Success is that a repo's work items, its vault, and its documentation stop disagreeing with each other, and that a person arriving cold can see the state of a project without being walked through it.

## Positioning

The board is **one self-contained HTML file that works from disk, forever, with no server and no network**. That is the mechanism a hosted tracker cannot copy: it can be mailed, committed, opened in five years, and read on a plane.

It is also **honest about its own data**. The histogram names bulk writes rather than drawing them as activity; the sheet shows the raw bean body rather than its rendering; a copy that failed says so.

## Operating Context

- Two machines, pushed directly to `main`, no PR workflow. Pull `--ff-only` before starting.
- The vault is Obsidian, in iCloud. The HubSpot repo is in OneDrive; reads there are slow and sometimes evicted.
- Work items live in **beans**, tracked in git, committed alongside the code they describe.
- Boards are served by `board.py serve` on localhost, or opened straight off disk.
- The board is often read on a phone.

## Capabilities and Constraints

**Binding, all four confirmed by the user on 2026-09-10:**

1. **Adjudant Classic stands as is.** The ZenaSoft 70s palette in OKLCH, square corners (`--r-*: 0px`), no shadow vocabulary (`--lift: none`), Mozilla Headline Condensed as the display face.
2. **Fully offline, one file.** Validator 24 fails the build on any off-machine `href`, `url()` or `@import`. The font is an embedded woff2 subset; the mark is inline SVG; there is no chart library.
3. **Keyboard and screen-reader parity.** Every action reachable without a mouse, every visual state with a text equivalent.
4. **The card face stays minimal.** Title, two-line note, id. A mark appears only when it discriminates: no chip printed on every card in the deck.

**Other constraints:**

- A plugin version lives in four files; only `scripts/bump_plugin_version.py` may write it.
- The board template has no JS test runner by design. Its tests assert the code's shape, not its behaviour, so a green suite never substitutes for driving it in a browser.
- The board writes exactly one field back: a card's lane.

## Brand Commitments

- **Adjudant**, with **Adjudante** as a deliberate easter egg: she appears one time in three, and always on 8 March.
- The mark is a figure plus wordmark, drawn as vector paths. The three-colour band is the favicon and the wipe.
- Voice is locked in `reference/voice.md`: ASD-STE100 register, no em dashes, no filler superlatives, no glazing.

## Evidence on Hand

- Real decks: the 92-card HubSpot Nightly beans deck, and toolshed's own 20 beans.
- `adjudant/skills/adjudant/reference/board.md` documents every decision in the board with its measurement.
- **Do not fabricate**: there are no users beyond the three above, no adoption numbers, no testimonials.

## Product Principles

1. **Measure, then decide.** Every design call in this board is backed by a number taken from a real deck at the size it is used.
2. **Say what is true, including about yourself.** A bulk write is labelled, a failed copy says failed, a stale filter clears itself.
3. **The cards are the product.** Everything above them is apparatus and must cost as little screen as it can.
4. **One rule, not two hardcoded ids.** Terminal lanes come from stamps, ordinary tags from a majority, so a renamed lane or a different tracker keeps working.
5. **It must still work with nothing.** No network, no server, no fonts installed, no localStorage.

## Accessibility & Inclusion

WCAG 2.1 AA is the floor and is enforced in tests: `--text-faint` is pinned at 4.5:1 against three surfaces in both schemes, and the focus ring is forbidden from using a category hue because the palette measures 1.65:1 to 2.28:1. `prefers-reduced-motion` removes the one entrance animation and lifts the clip that hides the wordmark.
