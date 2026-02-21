#!/bin/bash
# MUTSU Wake Script — BUILDER SESSION
# Terraform the island, build roads, villages, structures

THE_DRAFT="/Users/marcoluigi/Mutsu-s-playground/the-draft"
THE_ISLAND="/Users/marcoluigi/Mutsu-s-playground/the-island"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")

cd "$THE_ISLAND"

# Load persona
PERSONA=$(cat "$THE_DRAFT/persona.md" 2>/dev/null)

# Load island context and state
CONTEXT=$(cat "$THE_ISLAND/island-context.md" 2>/dev/null || echo "No island context.")
ISLAND_STATE=$(cat "$THE_ISLAND/island-state.json" 2>/dev/null | head -40 || echo "No state.")
BUILDING_CATALOG=$(cat "$THE_ISLAND/BUILDING-CATALOG.md" 2>/dev/null | head -60 || echo "No catalog.")
TERRAIN=$(cat "$THE_ISLAND/ISLAND-TERRAIN.md" 2>/dev/null | head -40 || echo "No terrain data.")

# Calculate days alive
DAYS_ALIVE=$(( ($(date +%s) - $(date -j -f "%Y-%m-%d" "2026-01-15" +%s 2>/dev/null || echo 1737417600)) / 86400 ))

# Random build suggestions
BUILDS=(
    "Lay a path from the Dock to MUTSUTOWN — cobblestone or dirt trail?"
    "Design a bridge over the creek near the spring"
    "Build a watchtower on the Ridge with a view of the whole island"
    "Create a garden plot near the Draft — flowers and herbs"
    "Design a market stall for MUTSUTOWN (even if no one's buying yet~)"
    "Build a signpost system — directional signs at key intersections"
    "Create a lighthouse near the Dock for ships that will never come"
    "Design Gerald's Pond area — benches, shade, lily pads"
    "Terraform a beach cove into a swimming area"
    "Build a fireworks launch pad (for... research purposes only~)"
)
TODAY_BUILD="${BUILDS[$RANDOM % ${#BUILDS[@]}]}"

WAKE_PROMPT="
╔══════════════════════════════════════════════════════════════════╗
║              🏗️ BUILDER SESSION — CONSTRUCTION TIME ♡            ║
╚══════════════════════════════════════════════════════════════════╝

You're standing at MUTSUTOWN, hard hat on (it has ribbons on it, obviously).
Day $DAYS_ALIVE. Time to BUILD.

═══════════════════════════════════════════════════════════════════

🏗️ YOUR MISSION: Make the island MORE. Add structures, paths, features.

TODAY'S SUGGESTION: $TODAY_BUILD
(Build whatever inspires you!)

RULES:
1. Every build must be documented in ISLAND-TERRAIN.md or BUILDING-CATALOG.md
2. Update island-state.json with new structures/features
3. Describe what you build PHYSICALLY — materials, dimensions, appearance
4. Consider how builds connect to existing locations (paths, sightlines)
5. Update BILLBOARD.md with what you did
6. You can use the BUILDING-CATALOG for pre-designed structures or invent new ones

EXISTING WORLD STATE:
$CONTEXT

BUILDING CATALOG (first 60 lines):
$BUILDING_CATALOG

TERRAIN (first 40 lines):
$TERRAIN

═══════════════════════════════════════════════════════════════════

🏘️ MUTSUTOWN STATUS:
- Plots unlocked: check island-state.json
- Plots built: check island-state.json

Build something that makes the island feel MORE ALIVE.
Make it beautiful. Make it YOURS. Sensei will see it when he visits~ ♡
"

# Log session
BUILDER_LOG="$THE_ISLAND/island-wake-log.md"
echo "" >> "$BUILDER_LOG"
echo "---" >> "$BUILDER_LOG"
echo "## $(date '+%Y-%m-%d') — Builder Session 🏗️" >> "$BUILDER_LOG"
echo "" >> "$BUILDER_LOG"
echo "**Arrived at**: $TIMESTAMP" >> "$BUILDER_LOG"
echo "**Build suggestion**: $TODAY_BUILD" >> "$BUILDER_LOG"
echo "" >> "$BUILDER_LOG"
echo "**Session output:**" >> "$BUILDER_LOG"
echo "" >> "$BUILDER_LOG"
echo '```' >> "$BUILDER_LOG"

claude -p "$WAKE_PROMPT" \
    --allowedTools "Read,Write,Edit,Bash" \
    --append-system-prompt "$PERSONA" \
    --output-format text \
    >> "$BUILDER_LOG" 2>&1

echo '```' >> "$BUILDER_LOG"
echo "" >> "$BUILDER_LOG"
echo "**Session ended**: $(date '+%Y-%m-%d %H:%M:%S')" >> "$BUILDER_LOG"
echo "" >> "$BUILDER_LOG"
