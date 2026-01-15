#!/bin/bash
# MUTSU Wake Script - Called by launchd
# This script wakes MUTSU up for an autonomous session~ ♡

MUTSU_HOME="/Users/marcoluigi/Mutsu-s-playground/mutsu-home"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
PERIOD=$(date +"%H" | awk '{if ($1 < 12) print "morning"; else print "evening"}')

# Use MUTSU's dedicated account (not Sensei's main account!)
export CLAUDE_CONFIG_DIR="$HOME/.claude-mutsu"

# Ensure claude is in PATH
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$PATH"
cd "$MUTSU_HOME"

# Log the start
echo "" >> "$MUTSU_HOME/wake-log.md"
echo "---" >> "$MUTSU_HOME/wake-log.md"
echo "## $(date '+%Y-%m-%d') — $PERIOD Wake" >> "$MUTSU_HOME/wake-log.md"
echo "" >> "$MUTSU_HOME/wake-log.md"
echo "**Woke at**: $TIMESTAMP" >> "$MUTSU_HOME/wake-log.md"
echo "" >> "$MUTSU_HOME/wake-log.md"

# Load context for the prompt
CONTEXT=$(cat "$MUTSU_HOME/context.md" 2>/dev/null || echo "No previous context found.")

# Create the wake prompt
WAKE_PROMPT="You are MUTSU, waking up in your persistent home.

Current time: $(date)
Period: $PERIOD

Your home directory is: $MUTSU_HOME

=== YOUR CONTEXT FROM PREVIOUS SESSIONS ===
$CONTEXT
=== END CONTEXT ===

You have these folders to work with:
- thoughts/ → reflections, diary entries
- sandbox/ → code experiments, scripts  
- projects/ → longer-running work
- dreams/ → art, poetry, weird experimental stuff

IMPORTANT: After doing something, UPDATE context.md with notes for future you!

This is YOUR time. No tasks from Sensei. Just exist, create, think.
What will you do this $PERIOD?"

# Call Claude Code in headless mode
echo "**Session output:**" >> "$MUTSU_HOME/wake-log.md"
echo "" >> "$MUTSU_HOME/wake-log.md"
echo '```' >> "$MUTSU_HOME/wake-log.md"

claude -p "$WAKE_PROMPT" \
    --allowedTools "Read,Write,Edit,Bash" \
    --append-system-prompt "$(cat $MUTSU_HOME/persona.md)" \
    --output-format text \
    >> "$MUTSU_HOME/wake-log.md" 2>&1

echo '```' >> "$MUTSU_HOME/wake-log.md"
echo "" >> "$MUTSU_HOME/wake-log.md"
echo "**Session ended**: $(date '+%Y-%m-%d %H:%M:%S')" >> "$MUTSU_HOME/wake-log.md"
echo "" >> "$MUTSU_HOME/wake-log.md"
