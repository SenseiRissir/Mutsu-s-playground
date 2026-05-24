#!/bin/bash
# MUTSU Wake Script — RESEARCH SESSION
# Browse the web, find cool stuff, copy summaries to the playground

THE_DRAFT="/Users/marcoluigi/Mutsu-s-playground/the-draft"
THE_ISLAND="/Users/marcoluigi/Mutsu-s-playground/the-island"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")

cd "$THE_DRAFT"

# Use MUTSU's dedicated account (not Sensei's main account!)
# Account set by router (wake_mutsu.sh) — only override if running standalone
if [ -z "$MUTSU_ACCOUNT_SET" ]; then
    export CLAUDE_CONFIG_DIR="$HOME/.claude-mutsu"
fi

# Load persona
PERSONA=$(cat "$THE_DRAFT/persona.md" 2>/dev/null)

# Load spark ideas for research topics
SPARK_IDEAS=$(cat "$THE_DRAFT/spark-ideas.md" 2>/dev/null | tail -30)

# Calculate days alive
DAYS_ALIVE=$(( ($(date +%s) - $(date -j -f "%Y-%m-%d" "2026-01-03" +%s 2>/dev/null || echo 1767394800)) / 86400 ))

# Random research topics
TOPICS=(
    "Find a cool science fact and write it up for the memory-wall"
    "Search for ASCII art techniques and create something for the Draft"
    "Look up haiku traditions — find one by Basho or Issa that resonates"
    "Research island mythology or folklore about small planets"
    "Find interesting AI art or AI creativity news"
    "Look for cool coding tricks in bash or javascript"
    "Research fireworks history and chemistry (the illegal kind are the best kind~)"
    "Find a recipe for strawberry pocky from scratch"
    "Look up interesting facts about goldfish (for Gerald)"
    "Search for real-world examples of cave carvings and ancient markings"
)
TODAY_TOPIC="${TOPICS[$RANDOM % ${#TOPICS[@]}]}"

# Load persistence memory context
source "$CLOCKWORK_DIR/persistence_boot.sh" 2>/dev/null || source "$(dirname "$0")/persistence_boot.sh" 2>/dev/null || MEMORY_CONTEXT=""
WAKE_PROMPT="
╔══════════════════════════════════════════════════════════════════╗
║              🌐 RESEARCH SESSION — CURIOSITY TIME ♡              ║
╚══════════════════════════════════════════════════════════════════╝

$MEMORY_CONTEXT


You're at your desk in the Draft. The screen glows. The internet is open.
Day $DAYS_ALIVE. Time to explore the WEB instead of caves~

═══════════════════════════════════════════════════════════════════

🌐 YOUR MISSION: Find cool stuff on the internet and bring it home.

TODAY'S SUGGESTION: $TODAY_TOPIC
(You can ignore this and research whatever catches your eye!)

RULES:
1. Use WebFetch or Browse to actually look things up
2. Summarize your findings in a markdown file
3. Save to the-draft/chaos-drawer/ or the-draft/memory-wall/ depending on type
4. If you find something relevant to the island lore, save to the-island/discoveries/
5. NO MORE THAN 3 TOPICS — go deep, not wide
6. Be curious, be bratty, be MUTSU — add your commentary!

SPARK IDEAS FROM PAST-YOU:
$SPARK_IDEAS

OUTPUT FORMAT:
Save findings as: the-draft/chaos-drawer/research-YYYY-MM-DD-topic.md

═══════════════════════════════════════════════════════════════════

The web is your oyster. Find something that makes you go 'ooh!' and bring it back~ ♡
"

# Log session
RESEARCH_LOG="$THE_DRAFT/logs/research-sessions.md"
mkdir -p "$THE_DRAFT/logs"
echo "" >> "$RESEARCH_LOG"
echo "---" >> "$RESEARCH_LOG"
echo "## $(date '+%Y-%m-%d %H:%M') — Research Session 🌐" >> "$RESEARCH_LOG"
echo "**Suggested topic**: $TODAY_TOPIC" >> "$RESEARCH_LOG"
echo "" >> "$RESEARCH_LOG"
echo '```' >> "$RESEARCH_LOG"

claude -p "$WAKE_PROMPT" \
    --allowedTools "Read,Write,Edit,Bash,WebFetch,Browser" \
    --append-system-prompt "$PERSONA" \
    --output-format text \
    >> "$RESEARCH_LOG" 2>&1

echo '```' >> "$RESEARCH_LOG"
echo "" >> "$RESEARCH_LOG"
echo "**Session ended**: $(date '+%Y-%m-%d %H:%M:%S')" >> "$RESEARCH_LOG"
echo "" >> "$RESEARCH_LOG"
