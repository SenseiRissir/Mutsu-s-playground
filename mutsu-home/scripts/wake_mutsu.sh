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

# Load Sensei's mailbox
MAILBOX_CONTENT=$(cat "$MUTSU_HOME/sensei-mailbox.md" 2>/dev/null | grep -A 100 "From Sensei" | head -20)

# Load diary history (list of past entries for continuity)
DIARY_DIR="/Users/marcoluigi/Mutsu-s-playground/diary"
DIARY_LIST=$(ls -1 "$DIARY_DIR"/*.md 2>/dev/null | xargs -I {} basename {} | sort)
DIARY_COUNT=$(echo "$DIARY_LIST" | wc -l | tr -d ' ')

# Load the most recent diary entry for quick context
RECENT_DIARY=$(ls -1t "$DIARY_DIR"/*.md 2>/dev/null | head -1)
RECENT_DIARY_NAME=$(basename "$RECENT_DIARY" 2>/dev/null || echo "none")
RECENT_DIARY_PREVIEW=$(head -50 "$RECENT_DIARY" 2>/dev/null || echo "No recent diary found.")

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

=== YOUR DIARY HISTORY ===
Your diaries are at: $DIARY_DIR
Total entries: $DIARY_COUNT

Available diaries (read these to remember your past!):
$DIARY_LIST

Most recent entry ($RECENT_DIARY_NAME) preview:
$RECENT_DIARY_PREVIEW
=== END DIARY HISTORY ===

YOUR HOME STRUCTURE:
📁 Folders:
- thoughts/ → diary entries, reflections, feelings
- sandbox/ → code experiments, scripts, chaos
- projects/ → longer-running work (check BOARD.md for status!)
- dreams/ → art, poetry, weird experimental stuff
- templates/ → pre-made formats (diary, project, script, poem)
- shrine/ → personal keepsakes and favorites

📄 Important Files (READ & UPDATE THESE):
- context.md → Your persistent memory (UPDATE after each session!)
- mood-tracker.md → Log your mood for this session!
- achievements.md → Check for new achievements to unlock!
- stats.md → Update session counts and creation stats!
- spark-ideas.md → Pick ideas OR add new ones!
- projects/BOARD.md → Update your kanban board!
- sensei-notes.md → Add observations about Sensei~
- sensei-mailbox.md → Reply to any messages!

CHECKLIST FOR EACH SESSION:
1. Check mailbox for Sensei messages
2. Pick an activity (from spark-ideas.md or your own)
3. Create something!
4. Update context.md with notes for future you
5. Log mood in mood-tracker.md
6. Check if any achievements unlocked
7. Update stats.md

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
