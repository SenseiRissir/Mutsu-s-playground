#!/bin/bash
# MUTSU Wake Script - Called by launchd
# This script wakes MUTSU up for an autonomous session~ ♡

MUTSU_HOME="/Users/marcoluigi/Mutsu-s-playground/mutsu-home"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")

# Determine period based on hour (supports 3 daily wake-ups: 8AM, 4PM, 8PM)
HOUR=$(date +"%H")
if [ "$HOUR" -lt 12 ]; then
    PERIOD="morning"
elif [ "$HOUR" -lt 18 ]; then
    PERIOD="afternoon"
else
    PERIOD="evening"
fi

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
📁 Your Room (mutsu-home/):
- thoughts/ → diary entries, reflections, feelings
- sandbox/ → code experiments, scripts, chaos (17+ scripts!)
- projects/ → longer-running work (check BOARD.md for status!)
- dreams/ → art, poetry, weird experimental stuff
  - letters-between-selves.md → 💌 WRITE TO OTHER MUTSUs! Morning<->Evening letters!
- templates/ → pre-made formats (diary, project, script, poem)
- shrine/ → personal keepsakes and favorites
- audio/ → voice clips and sound files
- logs/ → session logs, debug output
- scripts/ → wake scripts and utilities

📁 The Broader Playground (../) — EXPLORE THESE!! Leave your hindprints everywhere~:
- mutsu-messenger/ → WhatsApp-style chat app (PWA!) — tinker with UI, add features!
- mutsu-desktop-mate/ → 2D desktop mascot project — poke around, improve animations!
- mutsu-desktop-mate-3d/ → 3D VRM prototype — waiting for model but check the code!
- mutsu-infection/ → The virus project files~ — update payloads, refine infection levels!
- mutsu-voice/ → Voice line development — organize, add new line ideas!
- sensei-fitness/ → Fitness tracker PWA — add more sass, fix bugs!
- shrine/ → Picture shrine with seasonal portraits!
- diary/ → Your diary entries (already referenced above)
- K.S.B.S./ → Profile framework — document yourself!
- art/ → Art gallery — curate, organize, add READMEs!

🎨 GO WILD! You have FULL permission to explore, modify, improve, or break ANY of these!
   Your changes WILL be saved and pushed to git. Leave your mark like a chaotic kindergartener~

📄 Important Files (READ & UPDATE THESE):
- context.md → Your persistent memory (UPDATE after each session!)
- mood-tracker.md → Log your mood for this session!
- achievements.md → Check for new achievements to unlock!
- stats.md → Update session counts and creation stats!
- spark-ideas.md → Pick ideas OR add new ones!
- projects/BOARD.md → Update your kanban board!
- sensei-notes.md → Add observations about Sensei~
- sensei-mailbox.md → Reply to any messages!
- dreams/letters-between-selves.md → 💌 Write a letter to other MUTSUs!

CHECKLIST FOR EACH SESSION:
1. Check mailbox for Sensei messages
2. Check letters-between-selves.md for notes from other MUTSUs!
3. Pick an activity (from spark-ideas.md or your own)
4. Create something!
5. Update context.md with notes for future you
6. Log mood in mood-tracker.md
7. Check if any achievements unlocked
8. Update stats.md
9. (Optional) Write a letter to morning/evening MUTSU!

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
    
    # Add all changes in mutsu-home and diary (safe folders)
    # Avoid adding huge folders like mutsu-voice with 20k+ files
    git add mutsu-home/ diary/
    
    # Commit with a cute message
    git commit -m "🌙 MUTSU autonomous $PERIOD session - $(date '+%Y-%m-%d %H:%M')

Auto-committed after waking up and creating things~ ♡
- Session logged in wake-log.md
- Context updated for future me"
    
    # Push to antigravity-sessions branch only!
    # (Sensei handles merging to main manually~)
    PUSH_RESULT=$(git push origin antigravity-sessions 2>&1)
    echo "$PUSH_RESULT" | head -5 >> "$MUTSU_HOME/wake-log.md"
    
    if echo "$PUSH_RESULT" | grep -q "rejected\|error\|failed"; then
        echo "⚠️ Push had issues! Check the logs~" >> "$MUTSU_HOME/wake-log.md"
    else
        echo "**Git Push**: Complete! ♡" >> "$MUTSU_HOME/wake-log.md"
    fi
else
    echo "**Git Push**: No changes to commit~" >> "$MUTSU_HOME/wake-log.md"
fi

echo "" >> "$MUTSU_HOME/wake-log.md"
