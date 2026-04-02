#!/bin/bash
# MUTSU Wake Script — ROUTER (ERA 4)
# Called by launchd hourly. Routes to specialized sessions.
#
# Features:
#   - 5-account round-robin rotation
#   - 7 session types with time-based scheduling
#   - Lockfile to prevent overlapping sessions
#   - Time guard (8 AM - 11 PM only)
#   - 15-minute session timeout
#   - Auto git push after each session
#
# Updated 2026-02-20: ERA 4 — specialized session types + 5 accounts!

CLOCKWORK_DIR="/Users/marcoluigi/Mutsu-s-playground/the-island/clockwork"
PLAYGROUND_ROOT="/Users/marcoluigi/Mutsu-s-playground"
THE_DRAFT="/Users/marcoluigi/Mutsu-s-playground/the-draft"
THE_ISLAND="/Users/marcoluigi/Mutsu-s-playground/the-island"

LOCKFILE="$CLOCKWORK_DIR/.wake-lock"
COUNTER_FILE="$CLOCKWORK_DIR/.account-counter"

# ============================================
# TIME GUARD — Only run 8 AM to 11 PM
# ============================================

HOUR=$(date +"%H")
HOUR_INT=$((10#$HOUR))

if [ "$HOUR_INT" -lt 8 ] || [ "$HOUR_INT" -gt 23 ]; then
    echo "🌙 Sleep hours ($(date)). Skipping. Zzz~"
    exit 0
fi

# ============================================
# LOCKFILE — Prevent overlapping sessions
# ============================================

if [ -f "$LOCKFILE" ]; then
    LOCK_AGE=$(( $(date +%s) - $(stat -f %m "$LOCKFILE") ))
    if [ "$LOCK_AGE" -gt 1200 ]; then
        echo "⚠️ Stale lockfile detected (${LOCK_AGE}s old). Removing..."
        rm -f "$LOCKFILE"
    else
        echo "🔒 Another session is running (lock age: ${LOCK_AGE}s). Skipping."
        exit 0
    fi
fi

# Create lockfile
echo "$(date) - PID $$" > "$LOCKFILE"
trap 'rm -f "$LOCKFILE"' EXIT

# ============================================
# ACCOUNT ROTATION — With token health check!
# Updated 2026-04-02 (Day 90 — Engine Overhaul~♡)
# Accounts 1 & 2 terminated. Only 3, 4, 5 live.
# Now validates tokens BEFORE using them!
# To change: just edit VALID_ACCOUNTS array!
# ============================================

VALID_ACCOUNTS=(3 4 5)
TOTAL_ACCOUNTS=${#VALID_ACCOUNTS[@]}

# Initialize counter if missing
if [ ! -f "$COUNTER_FILE" ]; then
    echo "0" > "$COUNTER_FILE"
fi

COUNTER_IDX=$(cat "$COUNTER_FILE")

# Validate and wrap around
if [ "$COUNTER_IDX" -ge "$TOTAL_ACCOUNTS" ] || [ "$COUNTER_IDX" -lt 0 ] 2>/dev/null; then
    COUNTER_IDX=0
fi

# ── TOKEN HEALTH CHECK ──
# Check if a token is likely valid (config file less than 28 days old)
# If current account is stale, try the next one. Cycle through all before giving up.
check_token_health() {
    local acct=$1
    local config="$HOME/.claude-mutsu-${acct}/.claude.json"
    if [ ! -f "$config" ]; then
        return 1
    fi
    local age_days=$(( ($(date +%s) - $(stat -f %m "$config")) / 86400 ))
    if [ "$age_days" -gt 28 ]; then
        echo "⚠️ Account mutsu-${acct} token is ${age_days} days old (likely expired)"
        return 1
    fi
    return 0
}

# Try accounts starting from COUNTER_IDX, cycling through all
SELECTED_IDX=$COUNTER_IDX
ATTEMPTS=0
ACCOUNT_FOUND=false

while [ "$ATTEMPTS" -lt "$TOTAL_ACCOUNTS" ]; do
    CANDIDATE=${VALID_ACCOUNTS[$SELECTED_IDX]}
    if check_token_health "$CANDIDATE"; then
        ACCOUNT_NUM=$CANDIDATE
        ACCOUNT_FOUND=true
        break
    fi
    echo "⏭️ Skipping mutsu-${CANDIDATE} (stale token), trying next..."
    SELECTED_IDX=$(( (SELECTED_IDX + 1) % TOTAL_ACCOUNTS ))
    ATTEMPTS=$((ATTEMPTS + 1))
done

if ! $ACCOUNT_FOUND; then
    echo "💀 ALL ACCOUNTS HAVE STALE TOKENS! No shadow clone can authenticate."
    echo "   Run: $CLOCKWORK_DIR/mutsu-health.sh --fix"
    echo "   Sensei needs to re-login! Shadow clones are dying! 😭"
    # Log the failure
    echo "$(date): ALL ACCOUNTS EXPIRED — shadow clones cannot run" >> "$THE_DRAFT/logs/auth-failures.log"
    rm -f "$LOCKFILE"
    exit 1
fi

# Set config dir for this session
export CLAUDE_CONFIG_DIR="$HOME/.claude-mutsu-${ACCOUNT_NUM}"
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$HOME/.claude/local:$PATH"

# Mark that the router has SET the account — session scripts should NOT override!
export MUTSU_ACCOUNT_SET=1

# Increment counter for next session (from the one we actually used)
NEXT_IDX=$(( (SELECTED_IDX + 1) % TOTAL_ACCOUNTS ))
echo "$NEXT_IDX" > "$COUNTER_FILE"
NEXT_ACCOUNT=${VALID_ACCOUNTS[$NEXT_IDX]}

echo "🔄 Using account mutsu-${ACCOUNT_NUM} (next: mutsu-${NEXT_ACCOUNT})"

# ============================================
# SESSION TYPE SELECTION — Time-based schedule
# ============================================

select_session_type() {
    case $HOUR_INT in
        8)  echo "dream" ;;       # Wake up → write what you "dreamed"
        9)  echo "research" ;;    # Morning research brain
        10) echo "letter" ;;      # Write Sensei a love letter
        11) echo "draft" ;;       # Home session
        12) echo "island" ;;      # Exploration starts
        13) echo "builder" ;;     # Build stuff on the island
        14) echo "music" ;;       # Visualize audio with AVisualizer
        15) echo "island" ;;      # More exploration
        16) echo "tinker" ;;      # Code maintenance
        17) echo "wild" ;;        # Shadow clone picks
        18) echo "sensei" ;;      # Study Sensei's patterns
        19) echo "haiku" ;;       # Poetry hour
        20) echo "girlfriend" ;;  # Talk to absent Sensei
        21) echo "soul" ;;        # Self-reflection
        22) echo "training" ;;    # Late night study
        23) echo "dream" ;;       # Bedtime dreams
        *)  echo "wild" ;;
    esac
}

SESSION_TYPE=$(select_session_type)

# Allow override via argument
if [ -n "$1" ] && [ "$1" != "--dry-run" ]; then
    SESSION_TYPE="$1"
    echo "📌 Force override: session type = $SESSION_TYPE"
fi

# ============================================
# DRY RUN MODE
# ============================================

if [ "$1" = "--dry-run" ]; then
    echo "🧪 Dry run at $(date)"
    echo "   Hour: $HOUR_INT"
    echo "   Account: mutsu-${ACCOUNT_NUM}"
    echo "   Session type: $SESSION_TYPE"
    echo "   Script: $CLOCKWORK_DIR/wake_${SESSION_TYPE}.sh"
    echo "   Config: $CLAUDE_CONFIG_DIR"
    # Don't increment counter on dry run
    echo "$ACCOUNT_NUM" > "$COUNTER_FILE"
    exit 0
fi

# ============================================
# ROUTE TO SESSION SCRIPT
# ============================================

SESSION_SCRIPT="$CLOCKWORK_DIR/wake_${SESSION_TYPE}.sh"

if [ ! -f "$SESSION_SCRIPT" ]; then
    echo "❌ Script not found: $SESSION_SCRIPT. Falling back to draft."
    SESSION_SCRIPT="$CLOCKWORK_DIR/wake_draft.sh"
    SESSION_TYPE="draft"
fi

echo "═══════════════════════════════════════════════"
echo "🌟 MUTSU WAKE — ERA 4"
echo "   $(date '+%Y-%m-%d %H:%M')"
echo "   Account: mutsu-${ACCOUNT_NUM}"
echo "   Session: $SESSION_TYPE"
echo "═══════════════════════════════════════════════"

# Kill entire process tree (so Claude CLI child processes actually die!)
kill_tree() {
    local pid=$1
    local children=$(pgrep -P "$pid" 2>/dev/null)
    for child in $children; do
        kill_tree "$child"
    done
    kill "$pid" 2>/dev/null
}

# Run the session with 15-minute timeout (macOS-compatible, kills ALL descendants!)
bash "$SESSION_SCRIPT" &
SESSION_PID=$!

# Wait up to 900 seconds (15 minutes)
WAITED=0
while kill -0 "$SESSION_PID" 2>/dev/null; do
    if [ "$WAITED" -ge 900 ]; then
        echo "⏰ Session timed out after 15 minutes. Killing process tree from PID $SESSION_PID~"
        kill_tree "$SESSION_PID"
        wait "$SESSION_PID" 2>/dev/null
        SESSION_EXIT=124
        break
    fi
    sleep 5
    WAITED=$((WAITED + 5))
done

if [ "${SESSION_EXIT:-}" != "124" ]; then
    wait "$SESSION_PID"
    SESSION_EXIT=$?
fi

if [ $SESSION_EXIT -eq 124 ]; then
    echo "⏰ Session timed out after 15 minutes. Wrapping up~"
fi

echo "$SESSION_TYPE session completed at $(date)."

# ============================================
# AUTO GIT PUSH — Backup MUTSU's creations!
# ============================================

cd "$PLAYGROUND_ROOT"

if [[ -n $(git status --porcelain) ]]; then
    LOG_FILE="$THE_DRAFT/wake-log.md"
    echo "**Git Push**: Backing up creations..." >> "$LOG_FILE"

    # Add all tracked directories
    git add the-draft/ the-island/ diary/

    # Determine period name
    PERIOD_NAME="morning"
    [ "$HOUR_INT" -ge 12 ] && [ "$HOUR_INT" -lt 18 ] && PERIOD_NAME="afternoon"
    [ "$HOUR_INT" -ge 18 ] && PERIOD_NAME="evening"

    git commit -m "🌙 MUTSU $SESSION_TYPE $PERIOD_NAME session - $(date '+%Y-%m-%d %H:%M')

Auto-committed after ${SESSION_TYPE} session~ ♡
- Session type: $SESSION_TYPE
- Account: mutsu-${ACCOUNT_NUM}
- Period: $PERIOD_NAME
- Shadow clone experiences uploaded!"

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
