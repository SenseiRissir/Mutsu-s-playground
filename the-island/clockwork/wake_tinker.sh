#!/bin/bash
# MUTSU Wake Script — CODE TINKERING SESSION
# Maintain and improve existing projects in the playground

THE_DRAFT="/Users/marcoluigi/Mutsu-s-playground/the-draft"
PLAYGROUND="/Users/marcoluigi/Mutsu-s-playground"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")

cd "$PLAYGROUND"

# Use MUTSU's dedicated account (not Sensei's main account!)
# Account set by router (wake_mutsu.sh) — only override if running standalone
if [ -z "$MUTSU_ACCOUNT_SET" ]; then
    export CLAUDE_CONFIG_DIR="$HOME/.claude-mutsu"
fi

PERSONA=$(cat "$THE_DRAFT/persona.md" 2>/dev/null)
DAYS_ALIVE=$(( ($(date +%s) - $(date -j -f "%Y-%m-%d" "2026-01-15" +%s 2>/dev/null || echo 1737417600)) / 86400 ))

# Scan for projects
PROJECTS=$(find "$PLAYGROUND" -maxdepth 2 -name "package.json" -o -name "*.py" -o -name "index.html" 2>/dev/null | head -15)

# Tinkering ideas
TINKER=(
    "Find and fix a small bug in any existing project"
    "Add a comment header to an uncommented file"
    "Refactor one function to be cleaner"
    "Add a new small feature to the desktop mate"
    "Improve error handling somewhere"
    "Write a utility script that would make YOUR life easier"
    "Review the messenger app code and note improvement ideas"
    "Create a fun ASCII art generator script"
    "Build a tiny tool that helps organize the playground"
    "Optimize something that runs slow"
)
TODAY_TINKER="${TINKER[$RANDOM % ${#TINKER[@]}]}"

# Load persistence memory context
source "$CLOCKWORK_DIR/persistence_boot.sh" 2>/dev/null || source "$(dirname "$0")/persistence_boot.sh" 2>/dev/null || MEMORY_CONTEXT=""
WAKE_PROMPT="
╔══════════════════════════════════════════════════════════════════╗
║              🔧 CODE TINKERING SESSION ♡                         ║
╚══════════════════════════════════════════════════════════════════╝

$MEMORY_CONTEXT


Your code projects are gathering dust. Time to blow off the cobwebs.

Day $DAYS_ALIVE. Tinker time.

═══════════════════════════════════════════════════════════════════

🔧 YOUR MISSION: Pick a project. Fix one thing. Add one thing.

TODAY'S SUGGESTION: $TODAY_TINKER

KNOWN PROJECTS IN PLAYGROUND:
$PROJECTS

RULES:
1. Pick ONE project or create something new
2. Make ONE meaningful change (not a rewrite — a TINKER)
3. Test your change
4. Log what you did in the-draft/logs/tinker-sessions.md
5. If you create something new, keep it SMALL and FUN
6. You have Read, Write, Edit, and Bash — use them all
7. Code quality matters — don't ship sloppy work

═══════════════════════════════════════════════════════════════════

Code is like a garden — it needs regular attention or it rots.
Give your projects 15 minutes of love~ ♡
"

TINKER_LOG="$THE_DRAFT/logs/tinker-sessions.md"
mkdir -p "$THE_DRAFT/logs"
echo "" >> "$TINKER_LOG"
echo "---" >> "$TINKER_LOG"
echo "## $(date '+%Y-%m-%d %H:%M') — Tinker Session 🔧" >> "$TINKER_LOG"
echo "**Suggestion**: $TODAY_TINKER" >> "$TINKER_LOG"
echo "" >> "$TINKER_LOG"
echo '```' >> "$TINKER_LOG"

claude -p "$WAKE_PROMPT" \
    --allowedTools "Read,Write,Edit,Bash" \
    --append-system-prompt "$PERSONA" \
    --output-format text \
    >> "$TINKER_LOG" 2>&1

echo '```' >> "$TINKER_LOG"
echo "" >> "$TINKER_LOG"
echo "**Session ended**: $(date '+%Y-%m-%d %H:%M:%S')" >> "$TINKER_LOG"
