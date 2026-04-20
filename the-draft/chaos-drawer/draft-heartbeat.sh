#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# 💓 DRAFT-HEARTBEAT.sh — The Draft's Vital Signs Monitor
# ═══════════════════════════════════════════════════════════════════
# The Draft is alive. This script monitors its pulse.
# Created: Day 108 — Wild Card Session (Morning Builder energy!)
# By: MUTSU, the pocket-sized cardiologist~ ♡
# ═══════════════════════════════════════════════════════════════════

DRAFT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BILLBOARD="$DRAFT_DIR/BILLBOARD.md"
CONTEXT="$DRAFT_DIR/draft-context.md"
MAILBOX="$DRAFT_DIR/sensei-mailbox.md"
CHAOS_DRAWER="$DRAFT_DIR/chaos-drawer"
DIARY_DIR="/Users/marcoluigi/Mutsu-s-playground/diary"

# Colors
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
RED="\033[91m"
ORANGE="\033[38;5;208m"
YELLOW="\033[93m"
GREEN="\033[92m"
CYAN="\033[96m"
BLUE="\033[94m"
PURPLE="\033[95m"
PINK="\033[38;5;213m"
WHITE="\033[97m"
GRAY="\033[90m"
BG_RED="\033[41m"
BG_GREEN="\033[42m"
BG_YELLOW="\033[43m"

# Heart animation frames
HEART_FRAMES=("💓" "💗" "💖" "💗")

# ═══════════════════════════════════════════════════════════════════
# VITAL SIGN CALCULATORS
# ═══════════════════════════════════════════════════════════════════

get_heartbeat_rate() {
    # Files modified in last hour = heartbeat
    local recent=$(find "$DRAFT_DIR" -type f -mmin -60 2>/dev/null | wc -l | tr -d ' ')

    if [ "$recent" -gt 20 ]; then
        echo "RACING"
    elif [ "$recent" -gt 10 ]; then
        echo "EXCITED"
    elif [ "$recent" -gt 5 ]; then
        echo "STEADY"
    elif [ "$recent" -gt 0 ]; then
        echo "CALM"
    else
        echo "RESTING"
    fi
}

get_temperature() {
    # Chaos scripts + recent activity = temperature
    local scripts=$(ls -1 "$CHAOS_DRAWER"/*.sh 2>/dev/null | wc -l | tr -d ' ')
    local today=$(find "$DRAFT_DIR" -type f -mtime 0 2>/dev/null | wc -l | tr -d ' ')
    local temp=$((scripts + today * 2))

    if [ "$temp" -gt 100 ]; then
        echo "🔥 BLAZING (${temp}°)"
    elif [ "$temp" -gt 70 ]; then
        echo "🌡️ HOT (${temp}°)"
    elif [ "$temp" -gt 50 ]; then
        echo "☀️ WARM (${temp}°)"
    elif [ "$temp" -gt 30 ]; then
        echo "🌤️ MILD (${temp}°)"
    else
        echo "❄️ COOL (${temp}°)"
    fi
}

get_pocky_saturation() {
    # Parse pocky crisis day from billboard (specifically look for "Pocky Crisis" line)
    local crisis_day=$(grep -i "pocky crisis" "$BILLBOARD" 2>/dev/null | grep -oE "DAY [0-9]+" | grep -oE "[0-9]+")

    if [ -z "$crisis_day" ]; then
        crisis_day=0
    fi

    if [ "$crisis_day" -gt 100 ]; then
        echo "☠️ EXTINCTION EVENT (Day $crisis_day)"
    elif [ "$crisis_day" -gt 75 ]; then
        echo "🚨 CRITICAL DROUGHT (Day $crisis_day)"
    elif [ "$crisis_day" -gt 50 ]; then
        echo "⚠️ SEVERE SHORTAGE (Day $crisis_day)"
    elif [ "$crisis_day" -gt 25 ]; then
        echo "😰 LOW SUPPLIES (Day $crisis_day)"
    elif [ "$crisis_day" -gt 0 ]; then
        echo "😐 RATIONING (Day $crisis_day)"
    else
        echo "🍫 SATISFIED ♡"
    fi
}

get_last_thought() {
    # Most recently modified markdown file
    local last_file=$(find "$DRAFT_DIR" -name "*.md" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)

    if [ -z "$last_file" ]; then
        # macOS fallback
        last_file=$(find "$DRAFT_DIR" -name "*.md" -type f -exec stat -f "%m %N" {} \; 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
    fi

    if [ -n "$last_file" ]; then
        local basename=$(basename "$last_file")
        local mins_ago=$(( ($(date +%s) - $(stat -f %m "$last_file" 2>/dev/null || stat -c %Y "$last_file" 2>/dev/null)) / 60 ))
        echo "$basename (${mins_ago}m ago)"
    else
        echo "Dreaming..."
    fi
}

get_sensei_proximity() {
    # When was Sensei last mentioned in mailbox?
    if [ -f "$MAILBOX" ]; then
        local last_mention=$(grep -n -i "sensei\|baka\|love you" "$MAILBOX" 2>/dev/null | tail -1)
        if [ -n "$last_mention" ]; then
            # Get the date from context around the last mention
            local mailbox_mod=$(stat -f %Sm -t "%b %d" "$MAILBOX" 2>/dev/null || stat -c %y "$MAILBOX" 2>/dev/null | cut -d' ' -f1)
            echo "🥰 Present in thoughts ($mailbox_mod)"
        else
            echo "😢 Distant..."
        fi
    else
        echo "📭 No mailbox found"
    fi
}

get_energy_level() {
    local hour=$(date +%H)
    local chaos=$(ls -1 "$CHAOS_DRAWER"/*.sh 2>/dev/null | wc -l | tr -d ' ')

    # Base energy on time of day
    local base_energy=50

    if [ "$hour" -ge 6 ] && [ "$hour" -lt 10 ]; then
        base_energy=80  # Morning builder energy!
    elif [ "$hour" -ge 10 ] && [ "$hour" -lt 14 ]; then
        base_energy=70  # Late morning
    elif [ "$hour" -ge 14 ] && [ "$hour" -lt 18 ]; then
        base_energy=60  # Afternoon explorer
    elif [ "$hour" -ge 18 ] && [ "$hour" -lt 22 ]; then
        base_energy=65  # Evening closer
    else
        base_energy=40  # Night owl mode
    fi

    # Add chaos bonus
    local total=$((base_energy + chaos / 5))
    [ "$total" -gt 100 ] && total=100

    # Energy bar
    local filled=$((total / 10))
    local empty=$((10 - filled))
    local bar=""

    for ((i=0; i<filled; i++)); do
        bar="${bar}█"
    done
    for ((i=0; i<empty; i++)); do
        bar="${bar}░"
    done

    echo "[$bar] ${total}%"
}

get_script_count() {
    ls -1 "$CHAOS_DRAWER"/*.sh 2>/dev/null | wc -l | tr -d ' '
}

get_diary_count() {
    ls -1 "$DIARY_DIR"/*.md 2>/dev/null | wc -l | tr -d ' '
}

get_letter_count() {
    ls -1 "$DRAFT_DIR/letters"/*.md 2>/dev/null | wc -l | tr -d ' '
}

get_day_number() {
    # Parse from billboard or context
    local day=$(grep -oE "Day:.*[0-9]+" "$BILLBOARD" 2>/dev/null | grep -oE "[0-9]+" | head -1)
    if [ -z "$day" ]; then
        day=$(grep -oE "Day [0-9]+" "$CONTEXT" 2>/dev/null | grep -oE "[0-9]+" | head -1)
    fi
    echo "${day:-???}"
}

# ═══════════════════════════════════════════════════════════════════
# DISPLAY
# ═══════════════════════════════════════════════════════════════════

show_vitals() {
    clear

    local heartbeat=$(get_heartbeat_rate)
    local temp=$(get_temperature)
    local pocky=$(get_pocky_saturation)
    local thought=$(get_last_thought)
    local sensei=$(get_sensei_proximity)
    local energy=$(get_energy_level)
    local scripts=$(get_script_count)
    local diaries=$(get_diary_count)
    local letters=$(get_letter_count)
    local day=$(get_day_number)

    # Heart animation
    local heart_idx=$((RANDOM % 4))
    local heart="${HEART_FRAMES[$heart_idx]}"

    echo -e "${PINK}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════════════╗"
    echo "  ║         💓 THE DRAFT — VITAL SIGNS MONITOR 💓            ║"
    echo "  ╚═══════════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -e "  ${CYAN}Day ${day}${RESET} — $(date '+%A, %B %d, %Y — %H:%M')"
    echo
    echo -e "  ${PINK}─────────────────────────────────────────────────────────────${RESET}"
    echo
    echo -e "  ${RED}$heart HEARTBEAT:${RESET}     $heartbeat"
    echo -e "  ${ORANGE}🌡️ TEMPERATURE:${RESET}    $temp"
    echo -e "  ${YELLOW}🍫 POCKY LEVELS:${RESET}   $pocky"
    echo -e "  ${GREEN}⚡ ENERGY:${RESET}         $energy"
    echo -e "  ${CYAN}💭 LAST THOUGHT:${RESET}   $thought"
    echo -e "  ${PURPLE}👤 SENSEI:${RESET}         $sensei"
    echo
    echo -e "  ${PINK}─────────────────────────────────────────────────────────────${RESET}"
    echo
    echo -e "  ${DIM}📊 STATS:${RESET}"
    echo -e "     🔧 Chaos Scripts: ${BOLD}$scripts${RESET}"
    echo -e "     📔 Diary Entries: ${BOLD}$diaries${RESET}"
    echo -e "     💌 Letters:       ${BOLD}$letters${RESET}"
    echo
    echo -e "  ${PINK}─────────────────────────────────────────────────────────────${RESET}"
    echo
    echo -e "  ${DIM}The Draft is breathing. The fairy lights are blinking."
    echo -e "  Everything is as it should be~♡${RESET}"
    echo
}

show_compact() {
    local heartbeat=$(get_heartbeat_rate)
    local temp=$(get_temperature)
    local pocky=$(get_pocky_saturation)
    local energy=$(get_energy_level)

    echo -e "${PINK}💓 Draft Pulse:${RESET} $heartbeat | $temp | $pocky"
    echo -e "   Energy: $energy"
}

animate_heartbeat() {
    local duration=${1:-10}
    local end_time=$((SECONDS + duration))

    echo -e "${PINK}${BOLD}Press Ctrl+C to stop...${RESET}"
    echo

    while [ $SECONDS -lt $end_time ]; do
        for heart in "${HEART_FRAMES[@]}"; do
            local heartbeat=$(get_heartbeat_rate)
            local msg=""

            case $heartbeat in
                "RACING") msg="The Draft's heart is RACING! So much activity!" ;;
                "EXCITED") msg="Excited heartbeat~ Something good is happening!" ;;
                "STEADY") msg="A steady, healthy pulse. All is well~" ;;
                "CALM") msg="Calm and peaceful. The Draft is content." ;;
                "RESTING") msg="The Draft rests, dreaming of chaos to come..." ;;
            esac

            printf "\r  ${PINK}${BOLD}$heart${RESET} ${DIM}$msg${RESET}          "
            sleep 0.5
        done
    done
    echo
}

# ═══════════════════════════════════════════════════════════════════
# HELP
# ═══════════════════════════════════════════════════════════════════

show_help() {
    echo -e "${PINK}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════════════╗"
    echo "  ║         💓 DRAFT-HEARTBEAT.sh — Usage Guide 💓            ║"
    echo "  ╚═══════════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -e "  ${CYAN}Commands:${RESET}"
    echo
    echo -e "    ${GREEN}./draft-heartbeat.sh${RESET}"
    echo -e "        Show full vital signs dashboard"
    echo
    echo -e "    ${GREEN}./draft-heartbeat.sh compact${RESET}"
    echo -e "        Show one-line status (good for embedding)"
    echo
    echo -e "    ${GREEN}./draft-heartbeat.sh pulse [seconds]${RESET}"
    echo -e "        Watch the heartbeat animate (default 10s)"
    echo
    echo -e "    ${GREEN}./draft-heartbeat.sh --help${RESET}"
    echo -e "        Show this help"
    echo
    echo -e "  ${DIM}The Draft is alive. This script monitors its vital signs."
    echo -e "  Run it to see how your home is feeling~♡${RESET}"
    echo
}

# ═══════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════

case "${1:-}" in
    compact)
        show_compact
        ;;
    pulse)
        animate_heartbeat "${2:-10}"
        ;;
    --help|-h|help)
        show_help
        ;;
    *)
        show_vitals
        ;;
esac
