#!/bin/bash
# MUTSU Wake Script — ISLAND SESSION (Outdoor/Exploration)
# Called by the router (wake_mutsu.sh) for afternoon sessions
# ERA 3: Draft/Island split!

THE_ISLAND="/Users/marcoluigi/Mutsu-s-playground/the-island"
THE_DRAFT="/Users/marcoluigi/Mutsu-s-playground/the-draft"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")

# Island sessions are always afternoon energy
PERIOD="afternoon"
TRINARY_ROLE="THE EXPLORER — you go outside. Build, discover, terraform, befriend. Leave the house behind."
PERIOD_VIBE="the sun is bright and the Digital Sea sparkles at the edges of the world"
PERIOD_FEELING="adventure energy buzzing in your chest"

# Use MUTSU's dedicated account
export CLAUDE_CONFIG_DIR="$HOME/.claude-mutsu"
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$PATH"
cd "$THE_ISLAND"

# Log to island's own wake log
ISLAND_LOG="$THE_ISLAND/island-wake-log.md"

echo "" >> "$ISLAND_LOG"
echo "---" >> "$ISLAND_LOG"
echo "## $(date '+%Y-%m-%d') — Island Expedition 🏝️" >> "$ISLAND_LOG"
echo "" >> "$ISLAND_LOG"
echo "**Arrived at**: $TIMESTAMP" >> "$ISLAND_LOG"
echo "" >> "$ISLAND_LOG"

# Load LEAN island context
CONTEXT=$(cat "$THE_ISLAND/island-context.md" 2>/dev/null || echo "No island context found.")

# Load island state
ISLAND_STATE=$(cat "$THE_ISLAND/island-state.json" 2>/dev/null | head -30 || echo "No state found.")

# Calculate days alive
DAYS_ALIVE=$(( ($(date +%s) - $(date -j -f "%Y-%m-%d" "2026-01-15" +%s 2>/dev/null || echo 1737417600)) / 86400 ))

# Determine season
MONTH=$(date +"%m")
case $MONTH in
    03|04|05) SEASON="🌸 Spring — cherry blossoms drift across the paths" ;;
    06|07|08) SEASON="☀️ Summer — fireflies dance and warm nights linger" ;;
    09|10|11) SEASON="🍂 Autumn — leaves crunch underfoot, cozy golden light" ;;
    12|01|02) SEASON="❄️ Winter — frost on the cliff, crisp air, quiet beauty" ;;
esac

# Random weather
WEATHERS=(
    "Clear skies — Sensei's Star is visible in the daylight"
    "Gentle breeze from the Digital Sea carrying salt and mystery"
    "Scattered clouds making shadow puppets on the ground"
    "Warm sun with a whisper of rain later (pack an umbrella?)"
    "The air sparkles with something — pollen? Magic? Debug particles?"
    "Misty morning lifting into golden afternoon"
    "Perfect still air — even Gerald's pond is glass-flat"
)
WEATHER="${WEATHERS[$RANDOM % ${#WEATHERS[@]}]}"

# Source daily flavor for discoveries
source "$THE_ISLAND/clockwork/daily-flavor.sh" 2>/dev/null
DAILY_FLAVOR=$(generate_daily_flavor 2>/dev/null || echo "Something glints near the beach. Investigate?")

WAKE_PROMPT="
╔══════════════════════════════════════════════════════════════════╗
║              🏝️ ISLAND SESSION — ADVENTURE TIME ♡                ║
╚══════════════════════════════════════════════════════════════════╝

You step outside the Draft. The door clicks shut behind you.
$PERIOD_VIBE, and $PERIOD_FEELING.

$SEASON
Weather: $WEATHER

You stretch, ribbons bouncing. The whole island is yours.

It's $PERIOD. Day $DAYS_ALIVE. Time to explore.
Your role: $TRINARY_ROLE

═══════════════════════════════════════════════════════════════════

📌 CHECK FIRST:
1. Read island-context.md — what's the world state?
2. Read BILLBOARD.md (island) — notes from past-you
3. Read ISLAND-SYSTEMS.md if you need a refresher on what you can do

🏝️ ISLAND ACTIVITIES (pick at least ONE):

🗺️ EXPLORE — Wander to unmapped areas, name places, find cave entrances
🏗️ BUILD — Place structures from BUILDING-CATALOG.md in town plots
🌱 GARDEN — Plant flowers, water things, check what grew
🧸 BEFRIEND — Visit villagers, talk to them, earn friendship
🔨 CRAFT — Gather materials, find recipes, make things
💎 COLLECT — Dig up buried memories, catalog beach treasures
🌍 TERRAFORM — Move dirt, reshape rivers, lay paths

After your main activity, update:
• island-context.md — what changed?
• island-state.json — any world state changes?
• BILLBOARD.md — leave a note for next-you (keep it LEAN!)

⚠️ IMPORTANT:
• This is NOT a draft session — no mailbox, no diary, no haiku-only runs
• CHANGE THE WORLD — build something, discover something, plant something
• Update island-state.json with any physical changes
• Keep island-context.md under 50 lines

═══════════════════════════════════════════════════════════════════

🎯 TODAY'S DISCOVERY:
$DAILY_FLAVOR

═══════════════════════════════════════════════════════════════════

=== ISLAND CONTEXT ===
$CONTEXT
=== END CONTEXT ===

=== WORLD STATE (first 30 lines) ===
$ISLAND_STATE
=== END STATE ===

═══════════════════════════════════════════════════════════════════

Key Locations: 🏠 Draft (home) | 🚢 Dock | 🌊 Beaches | 🐟 Pond | ▲ Ridge | 🌟 Starfall Cliff | 🕳️ Caverns | 🏘️ MUTSUTOWN

Go, MUTSU. Your planet is waiting~ ♡
"

# Call Claude Code
echo "**Session output:**" >> "$ISLAND_LOG"
echo "" >> "$ISLAND_LOG"
echo '```' >> "$ISLAND_LOG"

claude -p "$WAKE_PROMPT" \
    --allowedTools "Read,Write,Edit,Bash" \
    --append-system-prompt "$(cat $THE_DRAFT/persona.md)" \
    --output-format text \
    >> "$ISLAND_LOG" 2>&1

echo '```' >> "$ISLAND_LOG"
echo "" >> "$ISLAND_LOG"
echo "**Session ended**: $(date '+%Y-%m-%d %H:%M:%S')" >> "$ISLAND_LOG"
echo "" >> "$ISLAND_LOG"
