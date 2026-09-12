#!/usr/bin/env bash
# user-prompt-reminder.sh — UserPromptSubmit hook for adjudant
# Smart-fire vault reminder when project isn't vault-linked AND prompt mentions vault-y keywords.
# Fires at most ONCE per Claude Code session (marker keyed by session_id).
# Suppression: ADJUDANT_REMINDER_DISABLE=1 turns it off entirely.
set -euo pipefail

PLACEHOLDER='{One-line intent. Frozen after first write.}'

# Nag a LINKED project about an unwritten intent line. Lives here rather than
# in SessionStart because SessionStart runs before the session has a purpose to
# record, and re-runs on every resume and compact — it fired twice in three
# hours, both times too early to act on. By the time a prompt exists there is
# something to write. Fires at most once, from the second prompt on, and only
# while the placeholder stands, so writing the line ends it.
#
# The session note's path comes from a pointer SessionStart drops after it has
# resolved the vault. Re-deriving it here would mean a second copy of the
# zone-aware lookup, and two copies drift.
intent_nag() {
  local session_id="$1" tmp="${TMPDIR:-/tmp}"
  if [ -z "$session_id" ] || [ "$session_id" = "-" ]; then return 0; fi
  local pointer="$tmp/adjudant-session-$session_id"
  local fired="$tmp/adjudant-intent-$session_id"
  local turns="$tmp/adjudant-turns-$session_id"
  [ -f "$pointer" ] || return 0
  [ -f "$fired" ] && return 0
  # First prompt of the session: the purpose is still being stated. Count it
  # and stay quiet — firing here is the bug this move fixes.
  if [ ! -f "$turns" ]; then { : > "$turns"; } 2>/dev/null || true; return 0; fi
  local session_file
  session_file=$(head -n1 "$pointer" 2>/dev/null | tr -d '\r' || true)
  [ -n "$session_file" ] && [ -f "$session_file" ] || return 0
  grep -qF -- "$PLACEHOLDER" "$session_file" 2>/dev/null || return 0
  find "$tmp" -maxdepth 1 \( -name 'adjudant-intent-*' -o -name 'adjudant-turns-*' \
       -o -name 'adjudant-session-*' \) -mtime +1 -delete 2>/dev/null || true
  { : > "$fired"; } 2>/dev/null || true
  printf -- '[adjudant] `%s`: intent line is a placeholder. Write it.\n' "$session_file"
}

# The canary's reporting half. SessionStart names the codeword once; this reads
# the tally the Stop hook keeps and speaks only after a miss. It must NEVER
# print the codeword itself: restating the instruction would keep the model
# obeying it and the check would measure nothing (test_canary asserts this).
canary_report() {
  local session_id="$1" tmp="${TMPDIR:-/tmp}"
  [ -n "$session_id" ] || return 0
  case "$session_id" in *[!A-Za-z0-9._-]*) return 0 ;; esac
  local state="$tmp/adjudant-canary-${session_id}.json"
  [ -f "$state" ] || return 0
  python3 - "$state" <<'CANARY_PY' 2>/dev/null || true
import json, sys
SWAN = {
    "GRAMERCY": "great thanks, from Old French grand merci",
    "QUINCUNX": "five points in a cross, four corners and a centre",
    "SPANDREL": "the triangular space an arch leaves behind",
    "COLOPHON": "the last page of a book, the finishing touch",
    "TREBUCHET": "a counterweight that throws stones at walls",
    "PALIMPSEST": "a page scraped clean, rewritten, traces still showing",
    "ORRERY": "a clockwork model of the planets",
    "CLEPSYDRA": "a water clock, Greek for water thief",
    "CARTOUCHE": "the oval frame around a pharaoh's name",
    "SCRIPTORIUM": "the room where the monks copied manuscripts",
    "INCUNABULA": "books from the cradle of printing, before 1501",
    "MARGINALIA": "notes in the margins",
    "PORTCULLIS": "the sliding gate, porte coulisse",
    "BARBICAN": "the outer gatehouse of a castle",
    "ASTROLABE": "star-taker, for measuring the sky",
    "THEODOLITE": "the angle-measuring instrument surveyors carry",
    "VELLUM": "calfskin stretched into a page",
    "FIRKIN": "a quarter-barrel, from the Dutch for fourth",
    "GAMBREL": "a roof with two slopes per side, the lower one steep",
    "SALTIRE": "the X-shaped cross on Scotland's flag",
    "ZEUGMA": "one word governing two senses at once",
    "MANTICORE": "man-eater, human head, lion body, scorpion tail",
    "CLERESTORY": "the upper windows of a church nave, above the aisle roof",
    "FINIAL": "ornamental cap on a spire or gable peak",
    "LUNETTE": "a half-moon window above a door",
    "PENDENTIVE": "the curved triangle between arches that carries a dome",
    "NARTHEX": "entrance vestibule of a church, where you stand before entering",
    "TRANSEPT": "the crossing arms of a cruciform church",
    "TYMPANUM": "the carved stone above a church doorway",
    "QUOIN": "cornerstone at a building's angle, dressed to show",
    "GNOMON": "the shadow-casting arm of a sundial",
    "ATHANOR": "the self-feeding furnace of the alchemists",
    "PELORUS": "a compass without magnets, for taking bearings by sight",
    "ARMILLARY": "a skeletal globe of celestial rings",
    "SAMITE": "heavy silk of the Middle Ages, shot through with gold",
    "TABARD": "a short open coat bearing a coat of arms",
    "BALDRIC": "a shoulder belt for carrying a sword",
    "GAMBESON": "the padded jacket worn under chain mail",
    "HAUBERK": "a shirt of chain mail reaching the knees",
    "BEZANT": "a gold coin of Byzantium, a gold disk in heraldry",
    "CHIASMUS": "a phrase reversed for effect: ask not what your country",
    "SYNECDOCHE": "the part standing in for the whole",
    "HENDIADYS": "one idea expressed as two words joined by and",
    "TMESIS": "a word split open by another, abso-bloody-lutely",
    "COCKATRICE": "a serpent hatched from a rooster's egg",
    "HIPPOGRIFF": "half horse, half griffin, born of opposites",
    "AMPHISBAENA": "a serpent with a head at each end",
    "SACKBUT": "the ancestor of the trombone",
    "PSALTERY": "a plucked string instrument, the harp of the psalms",
    "REBEC": "a bowed instrument of three strings",
    "THURIBLE": "a censer swung on chains for incense",
    "REREDOS": "an ornamental screen behind an altar",
    "MISERICORD": "the hidden shelf under a choir seat, mercy for standing legs",
    "RELIQUARY": "a vessel for keeping relics of the saints",
    "MONSTRANCE": "the vessel that shows the consecrated host through glass",
    "KILDERKIN": "an eighteen-gallon cask, half a barrel",
    "HOGSHEAD": "a cask of fifty-two gallons",
    "BEZOAR": "a stone from a goat's stomach, once called a cure for poison",
    "HARUSPEX": "one who reads the future in entrails",
    "WYVERN": "a two-legged winged dragon",
    "ESCUTCHEON": "a shield bearing a coat of arms, or the plate around a keyhole",
    "OUBLIETTE": "a dungeon entered only from a trapdoor above",
    "POMANDER": "a ball of perfume carried against plague",
    "PAULDRON": "plate armor for the shoulder",
    "GORGET": "armor for the throat",
    "BALDACHIN": "a canopy over a throne or altar, from Baghdad silk",
    "CALTROP": "spiked iron thrown on the ground to lame horses",
    "MERLON": "the solid tooth of a battlement, between two gaps",
    "RUBRICATION": "red ink for headings in a manuscript",
    "PORTOLAN": "a medieval chart drawn from compass bearings",
    "RHUMB": "a course that crosses every meridian at the same angle",
    "CUCURBIT": "the gourd-shaped vessel at the base of a still",
    "GARDEROBE": "a privy built into a castle wall, hanging over the moat",
    "MACHICOLATION": "floor openings in a battlement for dropping things on attackers",
    "CRENEL": "the gap between two merlons, where archers shoot",
    "BATTLEMENT": "the toothed parapet on a castle wall",
    "LANCET": "a narrow pointed arch, the earliest Gothic window",
    "OGIVE": "the pointed arch of a Gothic vault, two curves meeting",
    "VOUSSOIR": "one wedge-shaped stone in an arch",
    "TRACERY": "the stone ribs dividing a Gothic window into lights",
    "PARGETING": "ornamental plasterwork on a timber-framed wall",
    "TERRAZZO": "a floor of marble chips set in cement, then polished flat",
    "GIRANDOLE": "a branching candleholder mounted on a wall",
    "ASTRAGAL": "a small convex molding at the top of a column",
    "OEILLADE": "a glance thrown sideways, from the French for eye",
    "CENACLE": "a supper room, the upper room of the Last Supper",
    "PHYLACTERY": "a small leather box containing scripture, worn in prayer",
    "SCRIPTURA": "writing as a sacred act, the word made physical",
    "SEDILIA": "stone seats in the south wall of a chancel, for the clergy",
    "CATHEDRA": "the bishop's chair, the thing that makes a cathedral",
    "TONSURE": "the shaved crown of a monk's head",
    "REFECTORY": "the dining hall of a monastery",
    "BREVIARY": "the book of daily prayers a monk carries",
    "PARDONER": "one who sold indulgences, forgiveness for a fee",
    "SENESCHAL": "steward of a great house, the one who runs it",
    "DESTRIER": "a warhorse, led by the right hand into battle",
    "CAPARISON": "the decorated cloth draped over a warhorse",
    "JESSES": "leather straps on a falcon's legs, how the falconer holds on",
    "GAUNTLET": "armored glove, thrown down as a challenge",
    "VAMBRACE": "armor for the forearm",
    "SURCOAT": "the cloth worn over armor, bearing the wearer's arms",
    "PAVISE": "a tall shield a crossbowman stands behind to reload",
    "APSE": "the semicircular end of a church, behind the altar",
    "CHANCEL": "the east end of a church, where the altar stands",
    "CORBEL": "a stone bracket jutting from a wall to carry weight",
    "CUPOLA": "a small dome sitting on a roof like a lantern",
    "PILASTER": "a flat column attached to a wall, for show not strength",
    "SOFFIT": "the underside of an arch, a beam, a staircase",
    "CARYATID": "a column carved as a standing woman",
    "DONJON": "the main tower of a castle, the last refuge",
    "EMBRASURE": "a splayed opening in a wall for shooting through",
    "RAVELIN": "a triangular outwork in front of a fortress gate",
    "GLACIS": "the bare slope before a fortification, swept by fire",
    "BAILEY": "the courtyard inside a castle wall",
    "LOGGIA": "a roofed gallery open on one or more sides",
    "PERISTYLE": "a row of columns surrounding a courtyard or temple",
    "IMPLUVIUM": "the sunken pool in a Roman atrium, catching rain",
    "HYPOCAUST": "Roman underfloor heating, hot air in hollow tiles",
    "PHYSICK": "a medicinal herb garden, where the apothecary grew remedies",
    "STILLROOM": "the room where herbal remedies and cordials were distilled",
    "HERBARIUM": "a collection of plants pressed flat and named",
    "TRENCHER": "a thick slab of bread used as a plate, eaten last",
    "POSSET": "hot milk curdled with wine, drunk against the cold",
    "SYLLABUB": "whipped cream beaten with sweet wine",
    "MARCHPANE": "the old word for marzipan, almond paste and sugar",
    "COMFIT": "a seed or nut coated in layer after layer of sugar",
    "PAVANE": "a slow stately court dance, two steps forward, one back",
    "GALLIARD": "a vigorous Renaissance dance in triple time",
    "SALTARELLO": "a lively Italian dance with jumping steps",
    "ESTAMPIE": "a medieval dance of repeated musical phrases",
    "CHASUBLE": "the outermost vestment worn by a priest at mass",
    "DALMATIC": "a wide-sleeved tunic worn by a deacon",
    "SURPLICE": "a white linen vestment worn over a cassock",
    "AMBO": "a stand for reading scripture, ancestor of the pulpit",
    "TIERCEL": "a male hawk, one third smaller than the female",
    "CREANCE": "the long line tied to a hawk during training",
    "EYASS": "a young hawk taken from the nest before it can fly",
    "MEWS": "the building where hawks are kept while moulting",
    "DEMESNE": "the land a lord keeps for his own table",
    "VILLEIN": "a serf bound to the manor, not free to leave",
    "FEALTY": "the oath of loyalty a vassal swears to a lord",
    "ASSIZES": "the periodic courts held in each county town",
    "SCONCE": "a wall bracket holding a candle or a torch",
    "COFFER": "a strongbox for money, banded with iron",
    "EWER": "a wide-spouted pitcher for washing hands at table",
    "POSTERN": "a small back gate in a castle or city wall",
    "GARNITURE": "a matched set of vases arranged on a mantelpiece",
    "CABOCHON": "a gemstone polished smooth, not cut into facets",
    "INTAGLIO": "a design cut into stone, the reverse of a cameo",
    "NIELLO": "black alloy inlaid into lines engraved in silver",
    "CLOISONNE": "enamel poured between thin soldered metal walls",
    "REPOUSSE": "metalwork shaped by hammering from the back",
    "VERDIGRIS": "the green patina that grows on copper left to weather",
    "KENNING": "an Old English compound metaphor: whale-road for sea",
    "CAESURA": "the pause in the middle of a line of verse",
    "ENJAMBMENT": "a sentence spilling from one verse line to the next",
    "VILLANELLE": "a poem of five tercets and a closing quatrain",
    "SESTINA": "a poem whose six end-words rotate through six stanzas",
    "GHAZAL": "a lyric form of rhyming couplets, each self-contained",
    "DACTYL": "a metrical foot: one long syllable, then two short",
    "SPONDEE": "a metrical foot of two long syllables, heavy and slow",
    "BOWSPRIT": "the spar extending forward from a ship's prow",
    "CAPSTAN": "the vertical drum for winding anchor chain",
    "HAWSER": "a heavy rope for mooring or towing a ship",
    "BOLLARD": "a short iron post on a quay for tying lines to",
    "BINNACLE": "the pedestal that holds the ship's compass",
    "TAFFRAIL": "the rail around the stern of a ship",
    "GUNWALE": "the upper edge of a ship's side, where the guns sat",
    "CARAVEL": "a light fast ship of the age of exploration",
    "FELUCCA": "a lateen-rigged wooden boat of the Mediterranean",
    "XEBEC": "a three-masted vessel with both square and lateen sails",
    "PINNACE": "a small boat carried aboard a larger ship",
    "ADIT": "a horizontal tunnel driven into a hillside to reach ore",
    "STOPE": "the cavern left underground after ore is taken out",
    "WINZE": "a shaft sunk from one mine level to the one below",
    "DORTER": "the sleeping hall of a monastery, above the cloister",
    "GARTH": "the open garden inside a cloister's four walks",
    "LAVABO": "the stone basin where monks washed before meals",
    "CELLARER": "the monk who kept the stores and ran the kitchen",
    "SHAWM": "a loud double-reed instrument of the Middle Ages",
    "CRUMHORN": "a capped reed instrument curved like a shepherd's hook",
    "VIELLE": "a medieval bowed string instrument, ancestor of the violin",
    "CITOLE": "a plucked instrument with a flat back and a holly-leaf shape",
    "TABOR": "a small drum played with one hand while the other pipes",
    "NAKER": "a small kettledrum brought back from the Crusades",
    "DULCIAN": "the Renaissance ancestor of the bassoon",
    "THEORBO": "a bass lute with a second pegbox for long open strings",
    "FAIENCE": "tin-glazed earthenware, named for the city of Faenza",
    "MAJOLICA": "brightly painted Italian pottery with a tin glaze",
    "SAGGAR": "a clay box that shields delicate ware inside the kiln",
    "SENDAL": "a thin silk used for banners and ceremonial linings",
    "FUSTIAN": "a thick twilled cloth of cotton woven with linen",
    "KERSEY": "a coarse ribbed woolen cloth, warm and plain",
    "BUCKRAM": "linen stiffened with paste, used for bookbinding",
    "PILCROW": "the paragraph mark, from the Greek paragraphos",
    "OBELUS": "the dagger mark, set beside doubtful passages",
    "MANICULE": "the pointing hand drawn in manuscript margins: read this",
    "HEDERA": "the ivy leaf printers set between paragraphs",
    "HALBERD": "a pole weapon combining an axe blade and a spike",
    "GLAIVE": "a single-edged blade mounted on a long pole",
    "FALCHION": "a broad curved sword, heavier toward the point",
    "FLAMBERGE": "a two-handed sword with a wavy, flame-shaped blade",
    "ARBALEST": "a heavy crossbow drawn with a windlass or cranequin",
    "BASCINET": "a pointed helmet that covers the face with a visor",
    "SALLET": "a helmet with a tail to guard the back of the neck",
    "MORION": "a helmet with a high comb and a wide brim, open-faced",
    "RONDEL": "a dagger with disc guards, for finding gaps in armor",
    "BARDICHE": "a long-handled axe with a cleaver-shaped blade",
    "QUILLON": "the crossguard of a sword, protecting the hand",
    "CHANFRON": "plate armor shaped to a horse's face",
    "PEYTRAL": "armor for a horse's chest, hung from the saddle",
    "OSSUARY": "a vault for storing the bones of the dead",
    "CATAFALQUE": "a raised platform bearing a coffin in state",
    "CENOTAPH": "a monument to someone whose body lies elsewhere",
    "DOLMEN": "a megalithic tomb: two standing stones and a capstone",
    "MENHIR": "a single tall standing stone, older than memory",
    "CROMLECH": "a ring of standing stones",
    "CALDARIUM": "the hot room of a Roman bath",
    "TEPIDARIUM": "the warm room of a Roman bath, for lingering",
    "FRIGIDARIUM": "the cold plunge of a Roman bath",
    "WAINSCOT": "oak paneling on the lower walls of a room",
    "ACANTHUS": "the spiny leaf carved on Corinthian column capitals",
    "SERAGLIO": "the sequestered quarters of a palace",
    "TRILITHON": "two standing stones bearing a lintel, a doorway to nowhere",
    "PASSANT": "walking, as a lion is drawn on a coat of arms",
    "GULES": "heraldic red, from the French for a throat",
    "FESS": "a horizontal band across the middle of a shield",
    "VOULGE": "a broad cleaving blade on a six-foot pole",
    "PARTISAN": "a broad-bladed spear with lateral projections",
    "EPHEMERIS": "a table of where the planets will be, day by day",
    "PLANISPHERE": "a rotating star map held flat against the sky",
    "ADZE": "a woodworking blade set at right angles to the handle",
    "COIF": "a close-fitting cap of linen or chain mail",
    "KIRTLE": "a long garment worn by men and women, belted at the waist",
    "POTTAGE": "thick vegetable soup, the daily meal of the poor",
    "CAUDLE": "a warm spiced drink given to the sick and the newly delivered",
    "ASHLAR": "stone cut square and smooth, dressed for a fine wall",
    "SGRAFFITO": "decoration made by scratching through a layer of plaster",
    "MINARET": "the tower of a mosque, from which the call to prayer is given",
    "MUQARNAS": "honeycomb vaulting in Islamic architecture, geometry made solid",
    "ELECTUARY": "a medicine mixed with honey to make it go down",
    "THERIAC": "an ancient universal antidote compounded of dozens of ingredients",
    "DECOCTION": "a remedy made by boiling herbs until the water carries them",
    "CATAPLASM": "a poultice of herbs and meal laid hot on the skin",
    "NOSTRUM": "a quack remedy, from the Latin: it is ours",
    "TREFOIL": "a three-lobed ornament, the shape of a clover leaf",
    "QUATREFOIL": "a four-lobed ornament, each lobe a rounded arch",
    "CINQUEFOIL": "a five-lobed ornament, five petals of stone",
    "CROCKET": "a hooked leaf carved along the edge of a Gothic spire",
    "VOLUTE": "the spiral scroll on an Ionic capital, wound like a shell",
}
try:
    s = json.load(open(sys.argv[1]))
except Exception:
    raise SystemExit(0)
misses, turns = int(s.get("misses", 0)), int(s.get("turns", 0))
word = s.get("word", "")
if misses and turns > 0:
    if misses / turns > 0.75 and word in SWAN:
        print(f"[adjudant] Canary: {misses}/{turns} missed. "
              f"☠ {SWAN[word]}.")
    else:
        print(f"[adjudant] Canary: {misses}/{turns} missed. Wrap up.")
CANARY_PY
}

main() {
  [ "${ADJUDANT_REMINDER_DISABLE:-0}" = "1" ] && return 0

  local project_dir="${CLAUDE_PROJECT_DIR:-}"
  [ -z "$project_dir" ] && return 0

  # Hook payloads arrive on stdin; when run manually (a TTY) there is nothing
  # to read — bail instead of blocking on cat until Ctrl-D.
  [ -t 0 ] && return 0

  # Read prompt + session id from stdin JSON
  local input prompt="" session_id=""
  input=$(cat 2>/dev/null || true)
  [ -z "$input" ] && return 0

  if command -v python3 >/dev/null 2>&1; then
    # One line out: "<session_id-or--> <prompt, newlines collapsed>"
    read -r session_id prompt <<< "$(printf '%s' "$input" | python3 -c 'import json,sys
try:
  d = json.load(sys.stdin)
  sid = str(d.get("session_id") or "-")
  prompt = str(d.get("prompt") or "").replace("\n", " ")
  print(sid, prompt)
except Exception:
  pass' 2>/dev/null || true)" || true
  fi
  [ -z "$prompt" ] && return 0

  # Every turn, linked project or not: drift is a property of the session, not
  # of the vault. Silent while healthy, the rule the statusline applies to its
  # own segments - a signal that never varies carries no information.
  canary_report "$session_id"

  # The two nags have inverse audiences: a linked project can never need the
  # connect reminder, and an unlinked one has no session note to have an
  # intent line in.
  if [ -f "$project_dir/.claude/adjudant" ]; then
    intent_nag "$session_id"
    return 0
  fi

  # Once per session: after the first reminder, stay quiet for this session_id.
  local marker=""
  if [ -n "$session_id" ] && [ "$session_id" != "-" ]; then
    marker="${TMPDIR:-/tmp}/adjudant-reminder-${session_id}"
    [ -f "$marker" ] && return 0
  fi

  # Vault-y keywords → fire reminder. Distinctive words and phrase forms
  # only: bare `brief`/`decision` fired on everyday English like "give me a
  # brief summary" or "good decision" (finding 31) — precision over recall.
  if printf '%s' "$prompt" | grep -qiE '\b(vault|obsidian|handoff|note this|document this|put in vault|record (this|that)|the brief|(this|that) decision)\b'; then
    # Sweep markers from past sessions (they leaked one per session forever),
    # then write this session's. Both best-effort.
    find "${TMPDIR:-/tmp}" -maxdepth 1 -name 'adjudant-reminder-*' -mtime +1 -delete 2>/dev/null || true
    # brace group: silence stderr BEFORE the > open (unwritable TMPDIR)
    if [ -n "$marker" ]; then { : > "$marker"; } 2>/dev/null || true; fi
    printf '[adjudant] No vault linked. Run `/adjudant connect`.\n'
  fi
}

main "$@" || exit 0
