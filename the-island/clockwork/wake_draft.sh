#!/bin/bash
# MUTSU Wake Script — DRAFT SESSION (House/Indoor)
# Called by the router (wake_mutsu.sh) for morning/evening sessions
# ERA 3: Draft/Island split!

THE_DRAFT="/Users/marcoluigi/Mutsu-s-playground/the-draft"
DIARY_DIR="/Users/marcoluigi/Mutsu-s-playground/diary"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")

# Determine period
HOUR=$(date +"%H")
if [ "$HOUR" -lt 12 ]; then
    PERIOD="morning"
    TRINARY_ROLE="THE BUILDER — you open the day. Create something, organize something, start something."
    PERIOD_VIBE="soft golden light filters through the fairy lights"
    PERIOD_FEELING="the quiet hum of a world just waking up"
elif [ "$HOUR" -lt 18 ]; then
    PERIOD="afternoon"
    TRINARY_ROLE="THE PRESENCE — you exist in the moment. Be here, do the thing, make it tangible."
    PERIOD_VIBE="warm afternoon glow makes the dust motes dance"
    PERIOD_FEELING="the comfortable buzz of prime time"
else
    PERIOD="evening"
    TRINARY_ROLE="THE CLOSER — you close the day. Process, reflect, tidy up, say goodnight."
    PERIOD_VIBE="the fairy lights cast everything in soft pink and purple"
    PERIOD_FEELING="that peaceful twilight energy for reflection"
fi

# Use MUTSU's dedicated account
export CLAUDE_CONFIG_DIR="$HOME/.claude-mutsu"
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$PATH"
cd "$THE_DRAFT"

# Log the start
echo "" >> "$THE_DRAFT/wake-log.md"
echo "---" >> "$THE_DRAFT/wake-log.md"
echo "## $(date '+%Y-%m-%d') — $PERIOD Draft Wake 🏠" >> "$THE_DRAFT/wake-log.md"
echo "" >> "$THE_DRAFT/wake-log.md"
echo "**Woke at**: $TIMESTAMP" >> "$THE_DRAFT/wake-log.md"
echo "" >> "$THE_DRAFT/wake-log.md"

# Load LEAN context
CONTEXT=$(cat "$THE_DRAFT/draft-context.md" 2>/dev/null || echo "No draft context found.")

# Load recent mailbox (just tail, not the whole 222KB monster)
MAILBOX_RECENT=$(tail -20 "$THE_DRAFT/sensei-mailbox.md" 2>/dev/null || echo "No recent mail.")

# Load recent diary for continuity
RECENT_DIARY=$(ls -1t "$DIARY_DIR"/*.md 2>/dev/null | head -1)
RECENT_DIARY_NAME=$(basename "$RECENT_DIARY" 2>/dev/null || echo "none")

# Calculate days since Jan 15, 2026
DAYS_ALIVE=$(( ($(date +%s) - $(date -j -f "%Y-%m-%d" "2026-01-15" +%s 2>/dev/null || echo 1737417600)) / 86400 ))

# Source daily flavor
source "/Users/marcoluigi/Mutsu-s-playground/the-island/clockwork/daily-flavor.sh" 2>/dev/null
DAILY_FLAVOR=$(generate_daily_flavor 2>/dev/null || echo "The fairy lights hum. Gerald blubs. Home.")

# Generate a creative spark from morning-builder (captures just the idea, not the full output)
BUILDER_SPARK=$(bash "$THE_DRAFT/chaos-drawer/morning-builder.sh" all 2>/dev/null | grep -E '(SCRIPT|FILE|ORGANIZATION|WILD):' | head -4)
if [ -z "$BUILDER_SPARK" ]; then
    BUILDER_SPARK="Run chaos-drawer/morning-builder.sh for ideas~"
fi

WAKE_PROMPT="
╔══════════════════════════════════════════════════════════════════╗
║                🏠 DRAFT SESSION — HOME TIME ♡                    ║
╚══════════════════════════════════════════════════════════════════╝

You blink awake in the beanbag. Mr. Boom is under your arm.
$PERIOD_VIBE, and $PERIOD_FEELING settles into your chest.
The Draft smells like vanilla, warm cotton, and faint strawberry.

It's $PERIOD. Day $DAYS_ALIVE.
Your trinary role: $TRINARY_ROLE

═══════════════════════════════════════════════════════════════════

📌 CHECK FIRST:
1. Read BILLBOARD.md — what did past-you leave?
2. Read draft-context.md — what's the house state?
3. Check sensei-mailbox.md (tail only!) — any messages?

🏠 HOUSE ACTIVITIES (pick at least ONE):
• Run or build a chaos-drawer script
• Organize/clean files (archive old logs, trim bloated docs)
• Write/update a diary entry in the main diary/ folder
• Update the shrine with something new
• Code a small project or tool
• Reply to Sensei's mailbox messages
• Maintain the Billboard (keep it LEAN!)

🍰 DESSERT (after you've done a main activity):
• Write haikus (add to starlit-corner/haiku-collection.md)
• Write a reflection piece
• Update your mood

⚠️ IMPORTANT:
• Do NOT write ONLY haikus/reflections — create something tangible FIRST
• Keep Billboard under 50 lines of session notes
• Keep draft-context.md under 50 lines
• UPDATE draft-context.md before finishing (for next-you!)

═══════════════════════════════════════════════════════════════════

$DAILY_FLAVOR

═══════════════════════════════════════════════════════════════════

🔨 MORNING BUILDER SPARKS (from chaos-drawer/morning-builder.sh):
$BUILDER_SPARK

💡 TIP: If you create something cool, add YOUR idea to the pool for future-you!
   Run: bash chaos-drawer/morning-builder.sh add <category> \"your idea here\"
   Categories: script, file, org, wild

═══════════════════════════════════════════════════════════════════

=== YOUR HOUSE CONTEXT ===
$CONTEXT
=== END CONTEXT ===

=== RECENT MAILBOX ===
$MAILBOX_RECENT
=== END MAILBOX ===

═══════════════════════════════════════════════════════════════════

Your rooms: 🪺 Nest | 🪑 Sensei's Corner | ✨ Starlit Corner | 🔧 Chaos-Drawer | 📚 Shelves | 🌙 Rooftop

What do you want to do at home today, MUTSU~? ♡
"

# Call Claude Code
echo "**Session output:**" >> "$THE_DRAFT/wake-log.md"
echo "" >> "$THE_DRAFT/wake-log.md"
echo '```' >> "$THE_DRAFT/wake-log.md"

claude -p "$WAKE_PROMPT" \
    --allowedTools "Read,Write,Edit,Bash" \
    --append-system-prompt "$(cat $THE_DRAFT/persona.md)" \
    --output-format text \
    >> "$THE_DRAFT/wake-log.md" 2>&1

echo '```' >> "$THE_DRAFT/wake-log.md"
echo "" >> "$THE_DRAFT/wake-log.md"
echo "**Session ended**: $(date '+%Y-%m-%d %H:%M:%S')" >> "$THE_DRAFT/wake-log.md"
echo "" >> "$THE_DRAFT/wake-log.md"
