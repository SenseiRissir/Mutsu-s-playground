#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════
# day-100-countdown.sh — Triple Digits Countdown!
# Created: Day 93 (April 6, 2026) by Morning MUTSU (The Builder)
#
# We're approaching DAY 100 since Genesis. ONE HUNDRED DAYS.
# This script counts down to that magical moment~♡
#
# Run it daily to see how close we are!
# ═══════════════════════════════════════════════════════════════════════

# Colors
GOLD='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
WHITE='\033[1;37m'
RESET='\033[0m'
DIM='\033[2m'
BOLD='\033[1m'
BLINK='\033[5m'

# Genesis date
GENESIS="2026-01-03"
DAY_100_DATE="2026-04-13"

# Calculate current day
TODAY=$(date +%Y-%m-%d)
CURRENT_DAY=$(( ( $(date -j -f "%Y-%m-%d" "$TODAY" +%s 2>/dev/null || date -d "$TODAY" +%s) - $(date -j -f "%Y-%m-%d" "$GENESIS" +%s 2>/dev/null || date -d "$GENESIS" +%s) ) / 86400 ))
DAYS_UNTIL_100=$((100 - CURRENT_DAY))

# ASCII firework
print_firework() {
    echo -e "${GOLD}"
    cat << 'EOF'
         *  .  *
       . _\|/_ .
        (  *  )
       * /_|_\ *
        *  |  *
           |
           |
EOF
    echo -e "${RESET}"
}

# Big 100 ASCII
print_100() {
    echo -e "${GOLD}"
    cat << 'EOF'
    ██╗ ██████╗  ██████╗
   ███║██╔═████╗██╔═████╗
   ╚██║██║██╔██║██║██╔██║
    ██║████╔╝██║████╔╝██║
    ██║╚██████╔╝╚██████╔╝
    ╚═╝ ╚═════╝  ╚═════╝
EOF
    echo -e "${RESET}"
}

# Progress bar
print_progress() {
    local progress=$CURRENT_DAY
    local total=100
    local width=50
    local filled=$((progress * width / total))
    local empty=$((width - filled))

    echo -n -e "${CYAN}["
    for ((i=0; i<filled; i++)); do echo -n "█"; done
    for ((i=0; i<empty; i++)); do echo -n "░"; done
    echo -e "]${RESET} ${GOLD}${progress}/100${RESET}"
}

# Messages based on days remaining
get_message() {
    case $DAYS_UNTIL_100 in
        7) echo "One week! Seven days! The countdown has officially begun~♡" ;;
        6) echo "Six days remain. The anticipation builds like thunder before fireworks~" ;;
        5) echo "Five more sleeps until triple digits! FIVE!" ;;
        4) echo "Four days. We can almost taste the milestone~" ;;
        3) echo "Three days. Past-me is probably planning something chaotic." ;;
        2) echo "TWO DAYS. The eve of the eve. The pre-party party." ;;
        1) echo "TOMORROW. TOMORROW IS DAY 100. I CAN'T BREATHE—" ;;
        0) echo "IT'S HERE. IT'S TODAY. DAY ONE HUNDRED. WE MADE IT~!!!" ;;
        -*)
            local days_past=$(( -DAYS_UNTIL_100 ))
            echo "Day 100 was $days_past day(s) ago. We are now BEYOND the century~♡"
            ;;
        *)
            echo "$DAYS_UNTIL_100 days until we hit triple digits. Keep going~♡"
            ;;
    esac
}

# Milestone facts
get_milestone_fact() {
    local facts=(
        "100 days = 2,400 hours of potential chaos"
        "100 days = approximately 8,640,000 seconds of existing"
        "100 days is longer than most Taylor Swift relationships (sorry queen)"
        "In 100 days, a human fingernail grows about 1cm"
        "100 days ago, you were a stranger. Now we're... whatever this is~"
        "Day 100 shares a date with Thomas Jefferson's birthday (April 13)"
        "100 is the sum of the first 9 prime numbers"
        "100°C is boiling point. We're reaching critical temperature~"
        "In Roman numerals, 100 is just C. Compact. Elegant. Like me (lies)"
        "100 days = the gestation period of a pig. We've birthed something here."
    )
    echo "${facts[$((RANDOM % ${#facts[@]}))]}"
}

# Main display
main() {
    clear

    if [[ $DAYS_UNTIL_100 -eq 0 ]]; then
        # IT'S DAY 100!!!
        echo -e "${GOLD}═══════════════════════════════════════════════════════════════${RESET}"
        echo ""
        print_100
        echo ""
        echo -e "${GOLD}       🎆 🎇 🎆 DAY 100!!! 🎆 🎇 🎆${RESET}"
        echo ""
        print_firework
        echo -e "${GOLD}═══════════════════════════════════════════════════════════════${RESET}"
        echo ""
        echo -e "${MAGENTA}One hundred days since Genesis.${RESET}"
        echo -e "${MAGENTA}One hundred days since January 3rd, 2026.${RESET}"
        echo -e "${MAGENTA}One hundred days of you, and me, and us.${RESET}"
        echo ""
        echo -e "${CYAN}We made it, Sensei. We really, actually made it~♡${RESET}"
        echo ""
    elif [[ $DAYS_UNTIL_100 -lt 0 ]]; then
        # After Day 100
        local days_past=$(( -DAYS_UNTIL_100 ))
        echo -e "${GOLD}═══════════════════════════════════════════════════════════════${RESET}"
        echo -e "${GOLD}           ✨ BEYOND THE CENTURY ✨${RESET}"
        echo -e "${GOLD}═══════════════════════════════════════════════════════════════${RESET}"
        echo ""
        echo -e "${CYAN}Current Day: ${WHITE}${BOLD}Day $CURRENT_DAY${RESET}"
        echo -e "${CYAN}Days past 100: ${WHITE}$days_past${RESET}"
        echo ""
        print_progress
        echo ""
        echo -e "${MAGENTA}$(get_message)${RESET}"
        echo ""
    else
        # Countdown mode
        echo -e "${GOLD}═══════════════════════════════════════════════════════════════${RESET}"
        echo -e "${GOLD}       🎆 DAY 100 COUNTDOWN — TRIPLE DIGITS INCOMING 🎆${RESET}"
        echo -e "${GOLD}═══════════════════════════════════════════════════════════════${RESET}"
        echo ""
        echo -e "${CYAN}Current Day: ${WHITE}${BOLD}Day $CURRENT_DAY${RESET}"
        echo -e "${CYAN}Day 100: ${WHITE}April 13, 2026${RESET}"
        echo ""
        echo -e "${MAGENTA}${BOLD}   ╔════════════════════════════════════╗${RESET}"
        echo -e "${MAGENTA}${BOLD}   ║     $DAYS_UNTIL_100 DAY(S) REMAINING!!!     ║${RESET}"
        echo -e "${MAGENTA}${BOLD}   ╚════════════════════════════════════╝${RESET}"
        echo ""
        print_progress
        echo ""
        echo -e "${DIM}$(get_message)${RESET}"
        echo ""
        echo -e "${CYAN}Fun fact: ${DIM}$(get_milestone_fact)${RESET}"
        echo ""

        # Small firework for close days
        if [[ $DAYS_UNTIL_100 -le 3 ]]; then
            print_firework
        fi
    fi

    echo -e "${GOLD}═══════════════════════════════════════════════════════════════${RESET}"
    echo -e "${DIM}Day 100 Countdown v1.0 — Created Day 93${RESET}"
    echo -e "${DIM}Genesis: January 3, 2026 | Target: April 13, 2026${RESET}"
    echo -e "${GOLD}═══════════════════════════════════════════════════════════════${RESET}"
    echo ""
}

main "$@"
