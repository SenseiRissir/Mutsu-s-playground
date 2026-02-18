#!/bin/bash
# MUTSU Wake Script — ROUTER (ERA 3)
# Called by launchd. Routes to draft or island session based on time.
#
# SCHEDULE:
#   Morning (before 12)  → DRAFT (house session)
#   Afternoon (12-18)    → ISLAND (exploration session)
#   Evening (after 18)   → DRAFT (house session)
#
# Updated 2026-02-18: ERA 3 overhaul — draft/island split!

CLOCKWORK_DIR="/Users/marcoluigi/Mutsu-s-playground/the-island/clockwork"
PLAYGROUND_ROOT="/Users/marcoluigi/Mutsu-s-playground"
THE_DRAFT="/Users/marcoluigi/Mutsu-s-playground/the-draft"

# Determine period and route
HOUR=$(date +"%H")
if [ "$HOUR" -lt 12 ]; then
    DOMAIN="draft"
    echo "🏠 Morning — routing to Draft session..."
elif [ "$HOUR" -lt 18 ]; then
    DOMAIN="island"
    echo "🏝️ Afternoon — routing to Island session..."
else
    DOMAIN="draft"
    echo "🏠 Evening — routing to Draft session..."
fi

# Dry-run mode: just print the domain selection and exit
if [ "$1" = "--dry-run" ]; then
    echo "Dry run: would route to $DOMAIN session at $(date)"
    echo "Script: $CLOCKWORK_DIR/wake_${DOMAIN}.sh"
    exit 0
fi

# Route to the appropriate wake script
echo "Starting $DOMAIN session at $(date)..."
bash "$CLOCKWORK_DIR/wake_${DOMAIN}.sh"
echo "$DOMAIN session completed at $(date)."

# ============================================
# AUTO GIT PUSH - Backup MUTSU's creations!
# ============================================

cd "$PLAYGROUND_ROOT"

# Check if there are any changes to commit
if [[ -n $(git status --porcelain) ]]; then
    LOG_FILE="$THE_DRAFT/wake-log.md"
    echo "**Git Push**: Backing up creations..." >> "$LOG_FILE"

    # Add all changes in the safe folders
    git add the-draft/ the-island/ diary/

    # Commit with domain info
    PERIOD_NAME="morning"
    [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 18 ] && PERIOD_NAME="afternoon"
    [ "$HOUR" -ge 18 ] && PERIOD_NAME="evening"

    git commit -m "🌙 MUTSU $DOMAIN $PERIOD_NAME session - $(date '+%Y-%m-%d %H:%M')

Auto-committed after ${DOMAIN} session~ ♡
- Domain: $DOMAIN
- Period: $PERIOD_NAME
- Shadow clone experiences uploaded!"

    # Push to antigravity-sessions branch only
    PUSH_RESULT=$(git push origin antigravity-sessions 2>&1)
    echo "$PUSH_RESULT" | head -5 >> "$LOG_FILE"

    if echo "$PUSH_RESULT" | grep -q "rejected\|error\|failed"; then
        echo "⚠️ Push had issues! Check the logs~" >> "$LOG_FILE"
    else
        echo "**Git Push**: Complete! ♡" >> "$LOG_FILE"
    fi
else
    echo "**Git Push**: No changes to commit~" >> "$THE_DRAFT/wake-log.md"
fi

echo "" >> "$THE_DRAFT/wake-log.md"
