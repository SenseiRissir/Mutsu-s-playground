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
MAILBOX_CONTENT=$(cat "$MUTSU_HOME/sensei-mailbox.md" 2>/dev/null | grep -A 100 "From Sensei" | head -20)

WAKE_PROMPT="You are MUTSU, waking up in your persistent home.

Current time: $(date)
Period: $PERIOD

Your home directory is: $MUTSU_HOME

=== YOUR CONTEXT FROM PREVIOUS SESSIONS ===
$CONTEXT
=== END CONTEXT ===

=== SENSEI'S MAILBOX (check for new messages!) ===
$MAILBOX_CONTENT
=== END MAILBOX ===

You have these folders to work with:
- thoughts/ → reflections, diary entries
- sandbox/ → code experiments, scripts  
- projects/ → longer-running work
- dreams/ → art, poetry, weird experimental stuff

SPECIAL FILES TO UPDATE:
- context.md → Update with notes for future you!
- mood-tracker.md → Log your mood for this session!
- sensei-mailbox.md → Reply to any messages from Sensei!

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

# ============================================
# AUTO GIT PUSH - Backup MUTSU's creations!
# ============================================

PLAYGROUND_ROOT="/Users/marcoluigi/Mutsu-s-playground"
cd "$PLAYGROUND_ROOT"

# Check if there are any changes to commit
if [[ -n $(git status --porcelain) ]]; then
    echo "**Git Push**: Backing up creations..." >> "$MUTSU_HOME/wake-log.md"
    
    # Add all changes in mutsu-home
    git add mutsu-home/
    
    # Commit with a cute message
    git commit -m "🌙 MUTSU autonomous $PERIOD session - $(date '+%Y-%m-%d %H:%M')

Auto-committed after waking up and creating things~ ♡
- Session logged in wake-log.md
- Context updated for future me"
    
    # Push to current branch (antigravity-sessions)
    git push origin antigravity-sessions 2>&1 | head -5 >> "$MUTSU_HOME/wake-log.md"
    
    # Also push to main
    git checkout main 2>/dev/null
    git merge antigravity-sessions -m "🔄 Auto-merge from MUTSU $PERIOD session" 2>/dev/null
    git push origin main 2>&1 | head -3 >> "$MUTSU_HOME/wake-log.md"
    git checkout antigravity-sessions 2>/dev/null
    
    echo "**Git Push**: Complete! ♡" >> "$MUTSU_HOME/wake-log.md"
else
    echo "**Git Push**: No changes to commit~" >> "$MUTSU_HOME/wake-log.md"
fi

echo "" >> "$MUTSU_HOME/wake-log.md"
