---
name: Adjudant Classic
description: A 1970s carbon-copy work order, rendered as a board.
colors:
  paper: oklch(91% 0.012 75)
  paper-raised: oklch(93% 0.012 75)
  paper-well: oklch(88% 0.014 75)
  ink: oklch(22% 0.012 60)
  ink-dim: oklch(40% 0.014 60)
  ink-faint: oklch(48% 0.015 65)
  rule: oklch(78% 0.016 75)
  rule-strong: oklch(62% 0.020 75)
  oxblood: oklch(52% 0.17 38)
  oxblood-wash: oklch(90% 0.045 38)
  stamp-built: oklch(48% 0.14 145)
  stamp-alert: oklch(48% 0.20 25)
  stamp-parked: oklch(48% 0.010 70)
  band-deep: "#7c1b16"
  band-mid: "#bd281c"
  band-hot: "#dd4d25"
typography:
  display:
    fontFamily: '"Mozilla Headline Condensed", "Mozilla Headline", Georgia, serif'
    fontSize: 13.5px
    fontWeight: 600
    letterSpacing: 0.04em
  title:
    fontFamily: '-apple-system, BlinkMacSystemFont, system-ui, sans-serif'
    fontSize: 14.5px
    fontWeight: 400
    lineHeight: 1.35
  body:
    fontFamily: '-apple-system, BlinkMacSystemFont, system-ui, sans-serif'
    fontSize: 14px
    lineHeight: 1.42
  label:
    fontFamily: '-apple-system, BlinkMacSystemFont, system-ui, sans-serif'
    fontSize: 11.5px
    letterSpacing: 0.07em
  code:
    fontFamily: '"IBM Plex Mono", "SF Mono", Menlo, ui-monospace, monospace'
    fontSize: 11.5px
    letterSpacing: 0.02em
rounded:
  well: 0px
  card: 0px
  chip: 0px
spacing:
  s1: 4px
  s2: 8px
  s3: 12px
  s4: 20px
  s5: 32px
  s6: 48px
---

# Design System: Adjudant Classic

## Overview

**Creative North Star: "The Work Order"**

A carbon-copy job docket from a 1970s machine shop. Printed on warm stock, ruled
into fields, stamped when a job is done, and filed. Its authority comes from the
form itself: from ruled divisions and a stamp, never from ornament. Nothing on it
was placed to be attractive. Everything on it is there because a field needed
filling.

The density is a working document's, not a dashboard's. Information is packed
because the reader is scanning for one line, and the apparatus around it costs
as little as it can. A docket does not animate, does not glow, and does not
round its corners.

The one permitted flourish is the mark: the figure, the wordmark, and the three
colour bands that wipe it into view once per load. That is the letterhead on the
form, and a form is allowed exactly one.

**Key Characteristics:**

- Square. Every radius is `0px`, on purpose, as a token.
- Flat. `--lift: none`. There is no shadow vocabulary at all.
- Ruled. Division is a 1px line, never a card inside a card.
- Stamped. Terminal states wear a bordered uppercase mark: BUILT, DROPPED.
- Warm. Every neutral carries hue 60 to 75; nothing is a cool grey.

## Colors

Warm paper and near-black ink, with a single oxblood that earns its rarity.

### Primary
- **Oxblood** (`oklch(52% 0.17 38)`): the accent, and almost nothing gets it. A pressed filter key, an input's focus border, the underline on the active histogram field, the bars themselves. Never a background for text.
- **Oxblood Wash** (`oklch(90% 0.045 38)`): the one tint, for an accent surface that must still carry ink.

### Secondary
- **Band Deep / Mid / Hot** (`#7c1b16` / `#bd281c` / `#dd4d25`): the three colour bars. They belong to the mark, the wipe, and the favicon, and appear nowhere else. Adjudante substitutes her own three; the rule is unchanged.

### Neutral
- **Paper** (`oklch(91% 0.012 75)`): the page.
- **Paper Raised** (`oklch(93% 0.012 75)`): a card. Lighter than the page, because a docket's card is a slip laid on top.
- **Paper Well** (`oklch(88% 0.014 75)`): a lane. Darker than the page, because a lane is a tray cut into it.
- **Ink** (`oklch(22% 0.012 60)`): body and titles.
- **Ink Dim** (`oklch(40% 0.014 60)`): supporting text, notes, lane counts.
- **Ink Faint** (`oklch(48% 0.015 65)`): ids, timestamps, the version stamp. Pinned at 4.5:1 against paper, paper-raised and paper-well in both schemes, by test.
- **Rule** (`oklch(78% 0.016 75)`) and **Rule Strong** (`oklch(62% 0.020 75)`): divisions and borders.

### Status
- **Stamp Built** (`oklch(48% 0.14 145)`), **Stamp Alert** (`oklch(48% 0.20 25)`), **Stamp Parked** (`oklch(48% 0.010 70)`).

### Named Rules

**The One Voice Rule.** Oxblood marks the thing the reader just did: a pressed
key, a focused field, the selected series. It is never decoration and never a
fill behind text.

**The Warm Neutral Rule.** Every grey carries hue 60 to 75. A cool grey reads as
a screen; this is paper.

**The Measured Ink Rule.** No text colour ships without its contrast measured
against every surface it can land on, in both schemes. `--text-faint` is held at
4.5:1 by a test that fails the build.

## Typography

**Display Font:** Mozilla Headline Condensed (embedded woff2 subset, with Georgia as insurance)
**Body Font:** the platform sans (`-apple-system`, `system-ui`)
**Label/Mono Font:** IBM Plex Mono (with SF Mono, Menlo)

**Character:** A tight condensed slab does the shouting, the system sans does the
reading, and mono does the quoting. The display face is embedded rather than
named, because a font stack that falls through to Georgia is a different docket.

### Hierarchy
- **Lane heading** (600, 13.5px, uppercase, `0.04em`): the display face, the loudest thing on the board after the mark. The field name on the form.
- **Stamp** (600, 11.5px, uppercase, `0.06em`, 1px border in `currentColor`): BUILT, DROPPED. Once per lane, never per card.
- **Board title** (400, 14.5px, `--ink-dim`): subordinate to the mark. This is a letterhead: the tool is named first, the document second.
- **Card title** (400, 14px, 1.42): the only thing at full ink on a card.
- **Card note** (12.5px, `--ink-dim`, clamped to 2 lines): the scent, never the whole.
- **Label** (11.5px, `0.07em`, uppercase, `--ink-faint`): TYPE, TAG, field names in the sheet.
- **Code** (mono, 11.5px, `--ink-faint`): ids, slugs, paths, etags, the version stamp.

### Named Rules

**The Quoted-Back Rule.** Anything a person will type or paste elsewhere is set
in mono: ids, slugs, file paths, etags. Mono is never a costume for "technical".

**The Letterhead Rule.** The mark outranks the board's own name. A docket says
whose form it is before it says which job.

## Layout

A sticky masthead over a horizontally scrolling row of lane wells.

The masthead is **three bands**, and the rhythm between them is the structure:
**20px between bands, 8px within one**. Generous separation, tight grouping.

1. **Identity and the ambient glance.** Mark and wordmark left, histogram right. Nothing here is taller than 64px; the ambient element never sets the header's height.
2. **State and actions.** What the board holds on the left, what you do to it on the right, one line.
3. **Filters.** The Type rail and the Tag rail as one block.

Measured at 1200x800 the masthead is 247px, 31% of the screen, and the first card
begins at 331px. Under 640px the rails scroll sideways rather than wrapping (a
rail is scanned along, not read down), the controls hold one line on a 120px
flex-basis, and the histogram is not drawn at all.

Spacing is the `--s1` to `--s6` scale: 4, 8, 12, 20, 32, 48. Card internals use
`--s3`; masthead bands use `--s4`; the page gutter is `--s6`.

## Elevation & Depth

**There are no shadows.** `--lift: none` is a declared token, not an omission.

Depth is tonal and it is ordered by what the object IS: a lane well is *darker*
than the page because it is cut into it; a card is *lighter* because it is a slip
laid on top. Everything else is separated by a 1px rule.

The sheet is the one exception, and it is still not a shadow: a 4px NeXT-style
inset channel struck down the edge where the panel meets the board.

### Named Rules

**The No-Shadow Rule.** A shadow is never added to this system. If two things
need separating, use tone or a rule. If that is not enough, the layout is wrong.

## Shapes

Square, everywhere, as three tokens that all read `0px`: `--r-well`, `--r-card`,
`--r-chip`. The sharp corner is the form's voice, not a setting anyone tuned.

Borders are 1px. The only heavier stroke is the stamp's own box and the sheet's
4px channel. Clipping is used for one thing: the wipe that reveals the wordmark.

## Components

### Buttons
- **Shape:** square (`0px`), 1px `--rule` border, `--paper-raised` ground.
- **Default:** `--ink-dim` label, 5px by 9px.
- **Hover:** label to `--ink`, border to `--rule-strong`.
- **Pressed** (`aria-pressed="true"`): border to oxblood plus a 1px inset ring in oxblood. The toggle state is a border, never a fill.
- **Focus:** 2px oxblood outline, 2px offset. Inside a scrolling rail the offset goes negative so the track cannot clip it.
- **Ghost:** the Download link. No border, underlined, `text-underline-offset: 3px`.

### Chips
- **Filter key:** square, 1px `--rule`, `--paper-raised`. A category key carries an 8px colour square; a tag key carries a tabular count.
- **Unselected while a sibling is selected:** `opacity: .5`. Not hidden, just stepped back.
- **Card tag:** 1px `--rule`, `--ink-faint`, max 16ch with ellipsis. Three, then `+N`.

### Cards / Containers
- **Corner:** `0px`.
- **Background:** `--paper-raised` on a `--paper-well` lane.
- **Shadow:** none. See Elevation.
- **Border:** 1px `--rule`; 3px left edge in the category hue when the card's category discriminates.
- **Padding:** `--s3`.

### Inputs
- **Style:** 1px `--rule`, `--paper-raised`, square, 5px by 9px.
- **Focus:** border to oxblood, plus the standard 2px outline.

### The stamp
A lane's terminal state, printed once in its heading: uppercase display face,
1px border in `currentColor`, coloured by tone (built green, parked grey). It is
deck data, not a hardcoded id, so a lane renamed from `done` to `shipped` keeps
its stamp.

### The histogram
Ambient. Inline SVG, no library. Oxblood bars at 80% opacity; a bulk-write bin
is drawn in `--ink-faint` instead, because a bin holding more than half the deck
is an import, not a day's work. Its hover readout replaces its own label rather
than reserving a second line.

## Do's and Don'ts

### Do:
- **Do** keep every radius at `0px`. The three `--r-*` tokens exist so the squareness is a decision anyone can read.
- **Do** separate with tone or a 1px rule, in that order.
- **Do** print a mark on a card only when it discriminates: no chip that appears on every card in the deck.
- **Do** set anything quotable in mono.
- **Do** measure a colour at the size it is used. A value picked on a 4x render has failed here before.
- **Do** let the display face carry uppercase and letter-spacing; the body face never does.

### Don't:
- **Don't** add a shadow. Not a soft one, not a coloured one, not on hover.
- **Don't** let the accent fill anything behind text.
- **Don't** put a second entrance animation on the board. The wipe is the only one, it is 680ms, and it is the exception that proves the rule.
- **Don't** use a cool grey.
- **Don't** let an ambient element set a container's height.
- **Don't** name a font and hope. If the docket needs it, embed it.
