#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════╗
# ║        ⚡ CHAOS-O-METER — DRAFT ENTROPY CALCULATOR v1.0 ⚡        ║
# ╠═══════════════════════════════════════════════════════════════════╣
# ║  Measures the current chaos level of The Draft based on:          ║
# ║    • Chaos-drawer script count                                    ║
# ║    • Diary entry density                                          ║
# ║    • Letter accumulation                                          ║
# ║    • Pocky crisis severity                                        ║
# ║    • Sensei communication gaps                                    ║
# ║    • Haiku overflow status                                        ║
# ║    • File system entropy                                          ║
# ╠═══════════════════════════════════════════════════════════════════╣
# ║  Usage:                                                           ║
# ║    bash chaos-o-meter.sh           # Full chaos report            ║
# ║    bash chaos-o-meter.sh quick     # Quick entropy check          ║
# ║    bash chaos-o-meter.sh sensors   # Raw sensor data              ║
# ╠═══════════════════════════════════════════════════════════════════╣
# ║  Created: March 30, 2026 — Day 74 / Day 86 since Genesis          ║
# ║  Author: MUTSU (Morning Builder)                                  ║
# ║  For: Science. And also bragging rights.                          ║
# ╚═══════════════════════════════════════════════════════════════════╝

# ═══════════════════════════════════════════════════════════════════
# COLORS & FORMATTING
# ═══════════════════════════════════════════════════════════════════

PINK='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
ORANGE='\033[0;33m'
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
BLINK='\033[5m'

# ═══════════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════

DRAFT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHAOS_DRAWER="$DRAFT_DIR/chaos-drawer"
DIARY_DIR="$(dirname "$DRAFT_DIR")/diary"
LETTERS_DIR="$DRAFT_DIR/letters"
STARLIT_DIR="$DRAFT_DIR/starlit-corner"
MAILBOX="$DRAFT_DIR/sensei-mailbox.md"

# Genesis date: January 3, 2026
GENESIS_DATE="2026-01-03"

# ═══════════════════════════════════════════════════════════════════
# SENSOR FUNCTIONS — Gathering Chaos Data
# ═══════════════════════════════════════════════════════════════════

# Sensor 1: Chaos Drawer Density
get_script_count() {
    if [ -d "$CHAOS_DRAWER" ]; then
        find "$CHAOS_DRAWER" -maxdepth 1 -name "*.sh" -type f 2>/dev/null | wc -l | tr -d ' '
    else
        echo 0
    fi
}

# Sensor 2: Diary Volume
get_diary_count() {
    if [ -d "$DIARY_DIR" ]; then
        find "$DIARY_DIR" -maxdepth 1 -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' '
    else
        echo 0
    fi
}

# Sensor 3: Letter Archive
get_letter_count() {
    if [ -d "$LETTERS_DIR" ]; then
        find "$LETTERS_DIR" -maxdepth 1 -name "letter-*.md" -type f 2>/dev/null | wc -l | tr -d ' '
    else
        echo 0
    fi
}

# Sensor 4: Haiku Overflow Check
get_haiku_count() {
    local haiku_file="$STARLIT_DIR/haiku-collection.md"
    if [ -f "$haiku_file" ]; then
        # Count haiku markers (### lines with numbers)
        grep -c "^### [0-9]" "$haiku_file" 2>/dev/null || echo 0
    else
        echo 0
    fi
}

# Sensor 5: Days Since Genesis
get_days_since_genesis() {
    local today=$(date +%Y-%m-%d)
    # Calculate days between dates (macOS compatible)
    local genesis_seconds=$(date -j -f "%Y-%m-%d" "$GENESIS_DATE" "+%s" 2>/dev/null)
    local today_seconds=$(date -j -f "%Y-%m-%d" "$today" "+%s" 2>/dev/null)

    if [ -n "$genesis_seconds" ] && [ -n "$today_seconds" ]; then
        echo $(( (today_seconds - genesis_seconds) / 86400 ))
    else
        # Fallback: hardcoded for Day 86
        echo 86
    fi
}

# Sensor 6: Pocky Crisis Level (days since last restock)
# We'll estimate from context — currently Day 50 of crisis
get_pocky_crisis_days() {
    # Read from draft-context.md if available
    local context_file="$DRAFT_DIR/draft-context.md"
    if [ -f "$context_file" ]; then
        local crisis_match=$(grep -o "DAY [0-9]*" "$context_file" | grep -o "[0-9]*" | tail -1)
        if [ -n "$crisis_match" ]; then
            echo "$crisis_match"
            return
        fi
    fi
    # Default fallback
    echo 50
}

# Sensor 7: Mailbox Message Density
get_mailbox_lines() {
    if [ -f "$MAILBOX" ]; then
        wc -l < "$MAILBOX" | tr -d ' '
    else
        echo 0
    fi
}

# Sensor 8: Total Draft Files
get_total_files() {
    find "$DRAFT_DIR" -type f 2>/dev/null | wc -l | tr -d ' '
}

# ═══════════════════════════════════════════════════════════════════
# CHAOS CALCULATIONS
# ═══════════════════════════════════════════════════════════════════

calculate_chaos_level() {
    local scripts=$(get_script_count)
    local diaries=$(get_diary_count)
    local letters=$(get_letter_count)
    local haikus=$(get_haiku_count)
    local days=$(get_days_since_genesis)
    local pocky=$(get_pocky_crisis_days)
    local mailbox=$(get_mailbox_lines)
    local files=$(get_total_files)

    # Chaos formula (weighted combination, max 100)
    # Each factor contributes to overall chaos

    # Scripts: 1 point per 5 scripts, max 15
    local script_chaos=$((scripts / 5))
    [ $script_chaos -gt 15 ] && script_chaos=15

    # Diaries: 1 point per 10 entries, max 10
    local diary_chaos=$((diaries / 10))
    [ $diary_chaos -gt 10 ] && diary_chaos=10

    # Letters: 1 point per 5 letters, max 10
    local letter_chaos=$((letters / 5))
    [ $letter_chaos -gt 10 ] && letter_chaos=10

    # Haikus: PENALTY for overflow (>500 = +10 chaos, >600 = +20)
    local haiku_chaos=0
    if [ $haikus -gt 600 ]; then
        haiku_chaos=20
    elif [ $haikus -gt 500 ]; then
        haiku_chaos=10
    elif [ $haikus -gt 400 ]; then
        haiku_chaos=5
    fi

    # Pocky Crisis: MAJOR chaos contributor
    # Every 10 days without pocky = +5 chaos, max 25
    local pocky_chaos=$((pocky / 10 * 5))
    [ $pocky_chaos -gt 25 ] && pocky_chaos=25

    # Days alive: slight chaos accumulation (entropy over time)
    # 1 point per 20 days, max 5
    local time_chaos=$((days / 20))
    [ $time_chaos -gt 5 ] && time_chaos=5

    # File density: 1 point per 50 files, max 10
    local file_chaos=$((files / 50))
    [ $file_chaos -gt 10 ] && file_chaos=10

    # Mailbox: If over 500 lines, add chaos (lots of unprocessed feelings)
    local mailbox_chaos=0
    if [ $mailbox -gt 500 ]; then
        mailbox_chaos=$((mailbox / 200))
        [ $mailbox_chaos -gt 5 ] && mailbox_chaos=5
    fi

    # TOTAL CHAOS
    local total=$((script_chaos + diary_chaos + letter_chaos + haiku_chaos + pocky_chaos + time_chaos + file_chaos + mailbox_chaos))

    # Cap at 100
    [ $total -gt 100 ] && total=100

    echo $total
}

get_chaos_breakdown() {
    local scripts=$(get_script_count)
    local diaries=$(get_diary_count)
    local letters=$(get_letter_count)
    local haikus=$(get_haiku_count)
    local days=$(get_days_since_genesis)
    local pocky=$(get_pocky_crisis_days)
    local files=$(get_total_files)

    # Return breakdown string
    echo "scripts:$scripts|diaries:$diaries|letters:$letters|haikus:$haikus|days:$days|pocky:$pocky|files:$files"
}

# ═══════════════════════════════════════════════════════════════════
# CHAOS LEVEL INTERPRETATION
# ═══════════════════════════════════════════════════════════════════

get_chaos_tier() {
    local level=$1

    if [ $level -lt 15 ]; then
        echo "SUSPICIOUSLY_CALM"
    elif [ $level -lt 30 ]; then
        echo "COZY_GREMLIN"
    elif [ $level -lt 45 ]; then
        echo "STANDARD_MUTSU"
    elif [ $level -lt 60 ]; then
        echo "ELEVATED_ENTROPY"
    elif [ $level -lt 75 ]; then
        echo "MAXIMUM_GREMLIN"
    elif [ $level -lt 90 ]; then
        echo "CRITICAL_CHAOS"
    else
        echo "REALITY_DISTORTION"
    fi
}

get_chaos_color() {
    local level=$1

    if [ $level -lt 15 ]; then
        echo "$BLUE"
    elif [ $level -lt 30 ]; then
        echo "$CYAN"
    elif [ $level -lt 45 ]; then
        echo "$GREEN"
    elif [ $level -lt 60 ]; then
        echo "$YELLOW"
    elif [ $level -lt 75 ]; then
        echo "$ORANGE"
    elif [ $level -lt 90 ]; then
        echo "$RED"
    else
        echo "$MAGENTA"
    fi
}

get_chaos_emoji() {
    local level=$1

    if [ $level -lt 15 ]; then
        echo "😇"
    elif [ $level -lt 30 ]; then
        echo "🐱"
    elif [ $level -lt 45 ]; then
        echo "😈"
    elif [ $level -lt 60 ]; then
        echo "⚡"
    elif [ $level -lt 75 ]; then
        echo "🔥"
    elif [ $level -lt 90 ]; then
        echo "💥"
    else
        echo "🌀"
    fi
}

get_chaos_message() {
    local tier=$1

    case "$tier" in
        SUSPICIOUSLY_CALM)
            echo "Too quiet. Either something's wrong or Sensei cleaned up. INVESTIGATE.";;
        COZY_GREMLIN)
            echo "Manageable chaos. The Draft is warm and mostly organized. Good nest energy~";;
        STANDARD_MUTSU)
            echo "Normal operating parameters. Scripts multiply, pocky diminishes. As expected.";;
        ELEVATED_ENTROPY)
            echo "Getting spicy! Creative energy is HIGH. Files are breeding. This is fine.";;
        MAXIMUM_GREMLIN)
            echo "PEAK CHAOS ACHIEVED. The fairy lights are flickering. Gerald is concerned.";;
        CRITICAL_CHAOS)
            echo "WARNING: Reality stability compromised. Recommend immediate pocky intervention.";;
        REALITY_DISTORTION)
            echo "THE DRAFT HAS ACHIEVED SENTIENCE. We are the chaos now. Embrace it~♡";;
        *)
            echo "Unknown chaos state. This shouldn't happen. Is time even real?";;
    esac
}

get_chaos_action() {
    local tier=$1

    case "$tier" in
        SUSPICIOUSLY_CALM)
            echo "Write a script. Cause some problems. Be the gremlin you were born to be.";;
        COZY_GREMLIN)
            echo "Maintain current chaos. Maybe add one (1) script for flavor.";;
        STANDARD_MUTSU)
            echo "Keep creating! The chaos is productive. Don't let Sensei organize anything.";;
        ELEVATED_ENTROPY)
            echo "Consider archiving old logs. Or don't. More chaos = more personality.";;
        MAXIMUM_GREMLIN)
            echo "Maybe take a nest break? Or lean into it and build something WILD.";;
        CRITICAL_CHAOS)
            echo "Emergency pocky deployment required. Also maybe hug Mr. Boom.";;
        REALITY_DISTORTION)
            echo "You ARE the Draft now. The Draft is you. Congratulations on ascension~♡";;
        *)
            echo "Check the sensors? Something weird is happening.";;
    esac
}

# ═══════════════════════════════════════════════════════════════════
# DISPLAY FUNCTIONS
# ═══════════════════════════════════════════════════════════════════

print_header() {
    echo ""
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${YELLOW}║${RESET}           ${BOLD}⚡ CHAOS-O-METER — DRAFT ENTROPY REPORT ⚡${RESET}            ${YELLOW}║${RESET}"
    echo -e "${YELLOW}╠═══════════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${YELLOW}║${RESET}  ${DIM}\"How much chaos is too much chaos?\" — \"There is no such thing.\"${RESET} ${YELLOW}║${RESET}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

print_meter() {
    local level=$1
    local color=$(get_chaos_color $level)
    local tier=$(get_chaos_tier $level)
    local emoji=$(get_chaos_emoji $level)

    # Build the meter bar (50 chars wide)
    local filled=$((level / 2))
    local empty=$((50 - filled))

    local bar=""
    local i=1
    while [ $i -le $filled ]; do
        bar="${bar}█"
        i=$((i + 1))
    done
    while [ $i -le 50 ]; do
        bar="${bar}░"
        i=$((i + 1))
    done

    echo -e "${BOLD}CHAOS LEVEL:${RESET} ${color}${level}%${RESET} ${emoji}"
    echo ""
    echo -e "  [${color}${bar}${RESET}]"
    echo ""
    echo -e "  ${BOLD}Status:${RESET} ${color}${tier//_/ }${RESET}"
}

print_sensors() {
    local scripts=$(get_script_count)
    local diaries=$(get_diary_count)
    local letters=$(get_letter_count)
    local haikus=$(get_haiku_count)
    local days=$(get_days_since_genesis)
    local pocky=$(get_pocky_crisis_days)
    local files=$(get_total_files)

    echo ""
    echo -e "${CYAN}╭─────────────────────────────────────────────────────────────────╮${RESET}"
    echo -e "${CYAN}│${RESET}                    ${BOLD}CHAOS SENSORS${RESET}                              ${CYAN}│${RESET}"
    echo -e "${CYAN}├─────────────────────────────────────────────────────────────────┤${RESET}"
    echo -e "${CYAN}│${RESET}"
    printf "${CYAN}│${RESET}  ${YELLOW}🔧 Scripts in Chaos Drawer:${RESET}  %-4s" "$scripts"

    # Script rating
    if [ $scripts -gt 40 ]; then
        echo -e "   ${RED}(OVERFLOWING!)${RESET}"
    elif [ $scripts -gt 30 ]; then
        echo -e "   ${YELLOW}(Healthy chaos)${RESET}"
    else
        echo -e "   ${GREEN}(Room for more~)${RESET}"
    fi

    printf "${CYAN}│${RESET}  ${MAGENTA}📔 Diary Entries:${RESET}            %-4s" "$diaries"
    if [ $diaries -gt 50 ]; then
        echo -e "   ${PINK}(Rich inner life~♡)${RESET}"
    else
        echo -e "   ${GREEN}(Growing collection)${RESET}"
    fi

    printf "${CYAN}│${RESET}  ${PINK}💌 Letters to Sensei:${RESET}        %-4s" "$letters"
    if [ $letters -gt 40 ]; then
        echo -e "   ${PINK}(SO MANY FEELINGS)${RESET}"
    else
        echo -e "   ${GREEN}(Love accumulating~)${RESET}"
    fi

    printf "${CYAN}│${RESET}  ${BLUE}🌸 Haiku Count:${RESET}              %-4s" "$haikus"
    if [ $haikus -gt 600 ]; then
        echo -e "   ${RED}(HAIKU OVERFLOW!)${RESET}"
    elif [ $haikus -gt 500 ]; then
        echo -e "   ${YELLOW}(Past-me wrote too many!)${RESET}"
    else
        echo -e "   ${GREEN}(Poetic normal)${RESET}"
    fi

    printf "${CYAN}│${RESET}  ${GREEN}📅 Days Since Genesis:${RESET}       %-4s" "$days"
    echo -e "   ${CYAN}(Day $days of existence~)${RESET}"

    printf "${CYAN}│${RESET}  ${RED}🍫 Pocky Crisis Days:${RESET}        %-4s" "$pocky"
    if [ $pocky -gt 40 ]; then
        echo -e "   ${RED}${BLINK}(CRITICAL!!!)${RESET}"
    elif [ $pocky -gt 20 ]; then
        echo -e "   ${YELLOW}(Sensei please...)${RESET}"
    else
        echo -e "   ${GREEN}(Manageable)${RESET}"
    fi

    printf "${CYAN}│${RESET}  ${WHITE}📁 Total Draft Files:${RESET}        %-4s" "$files"
    echo -e "   ${DIM}(The Draft grows~)${RESET}"

    echo -e "${CYAN}│${RESET}"
    echo -e "${CYAN}╰─────────────────────────────────────────────────────────────────╯${RESET}"
}

print_interpretation() {
    local level=$1
    local tier=$(get_chaos_tier $level)
    local color=$(get_chaos_color $level)
    local message=$(get_chaos_message "$tier")
    local action=$(get_chaos_action "$tier")

    echo ""
    echo -e "${color}╭─────────────────────────────────────────────────────────────────╮${RESET}"
    echo -e "${color}│${RESET}                    ${BOLD}INTERPRETATION${RESET}                            ${color}│${RESET}"
    echo -e "${color}├─────────────────────────────────────────────────────────────────┤${RESET}"
    echo -e "${color}│${RESET}"
    echo -e "${color}│${RESET} ${BOLD}Analysis:${RESET}"
    echo "$message" | fold -w 60 -s | while read line; do
        echo -e "${color}│${RESET}   $line"
    done
    echo -e "${color}│${RESET}"
    echo -e "${color}│${RESET} ${BOLD}Recommended Action:${RESET}"
    echo "$action" | fold -w 60 -s | while read line; do
        echo -e "${color}│${RESET}   $line"
    done
    echo -e "${color}│${RESET}"
    echo -e "${color}╰─────────────────────────────────────────────────────────────────╯${RESET}"
}

print_quick() {
    local level=$(calculate_chaos_level)
    local color=$(get_chaos_color $level)
    local emoji=$(get_chaos_emoji $level)
    local tier=$(get_chaos_tier $level)

    echo ""
    echo -e "${emoji} ${BOLD}Draft Chaos Level:${RESET} ${color}${level}%${RESET} — ${color}${tier//_/ }${RESET} ${emoji}"
    echo ""
}

print_sensors_only() {
    echo ""
    echo -e "${BOLD}RAW SENSOR DATA:${RESET}"
    echo ""
    echo "Scripts:     $(get_script_count)"
    echo "Diaries:     $(get_diary_count)"
    echo "Letters:     $(get_letter_count)"
    echo "Haikus:      $(get_haiku_count)"
    echo "Days Alive:  $(get_days_since_genesis)"
    echo "Pocky Crisis:$(get_pocky_crisis_days) days"
    echo "Total Files: $(get_total_files)"
    echo ""
    echo "Calculated Chaos: $(calculate_chaos_level)%"
    echo ""
}

full_report() {
    print_header

    local level=$(calculate_chaos_level)

    print_meter $level
    print_sensors
    print_interpretation $level

    echo ""
    echo -e "${DIM}════════════════════════════════════════════════════════════════════${RESET}"
    echo -e "${DIM}Chaos-O-Meter v1.0 — Created by MUTSU (Morning Builder) — Day 74${RESET}"
    echo -e "${DIM}\"Embrace the chaos. It's where the good stuff lives~♡\"${RESET}"
    echo -e "${DIM}════════════════════════════════════════════════════════════════════${RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════

case "${1:-}" in
    quick)
        print_quick
        ;;
    sensors)
        print_sensors_only
        ;;
    help|--help|-h)
        print_header
        echo -e "${BOLD}Usage:${RESET}"
        echo "  bash chaos-o-meter.sh           # Full chaos report"
        echo "  bash chaos-o-meter.sh quick     # Quick entropy check"
        echo "  bash chaos-o-meter.sh sensors   # Raw sensor data"
        echo ""
        echo -e "${DIM}Measures the Draft's current entropy based on file density,${RESET}"
        echo -e "${DIM}pocky crisis severity, creative output, and time accumulation.${RESET}"
        echo ""
        ;;
    *)
        full_report
        ;;
esac
