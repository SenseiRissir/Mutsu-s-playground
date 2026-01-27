#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════╗
# ║  MUTSU POMODORO TIMER 🍅                                      ║
# ║  "I'm not helping you be productive... b-baka!"               ║
# ║                                                                ║
# ║  Created: 2026-01-17 (Saturday Evening)                       ║
# ║  By: MUTSU (who definitely doesn't care if you succeed)       ║
# ╚═══════════════════════════════════════════════════════════════╝

# Configuration
WORK_MINUTES=25
SHORT_BREAK=5
LONG_BREAK=15
POMODOROS_UNTIL_LONG=4

# State tracking
completed_pomodoros=0
current_mode="work"  # work, short_break, long_break

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# ═══════════════════════════════════════════════════════════════
# ASCII ART
# ═══════════════════════════════════════════════════════════════

show_tomato() {
    echo -e "${RED}"
    cat << 'EOF'
       ___
      /   \
     | 🍅 |
      \___/
EOF
    echo -e "${NC}"
}

show_mutsu_work() {
    echo -e "${MAGENTA}"
    cat << 'EOF'
    ╭──────────────────────────────────────╮
    │  ∩_∩                                 │
    │ ( •̀ω•́ )  Time to WORK, baka!       │
    │ /    \   No slacking allowed~        │
    ╰──────────────────────────────────────╯
EOF
    echo -e "${NC}"
}

show_mutsu_break() {
    echo -e "${CYAN}"
    cat << 'EOF'
    ╭──────────────────────────────────────╮
    │  ∩_∩                                 │
    │ ( ´ω` )  Okay fine, take a break...  │
    │ /    \   But only because I ALLOW it~│
    ╰──────────────────────────────────────╯
EOF
    echo -e "${NC}"
}

show_mutsu_proud() {
    echo -e "${YELLOW}"
    cat << 'EOF'
    ╭──────────────────────────────────────╮
    │  ∩_∩                                 │
    │ ( *ω* )  Y-you did it...             │
    │ /    \   I'm... not impressed...!    │
    ╰──────────────────────────────────────╯
EOF
    echo -e "${NC}"
}

show_mutsu_long_break() {
    echo -e "${GREEN}"
    cat << 'EOF'
    ╭──────────────────────────────────────────╮
    │  ∩_∩                                     │
    │ ( ♡ω♡ )  4 pomodoros!! LONG BREAK TIME!  │
    │ /    \   ...You actually did well. Hmph. │
    ╰──────────────────────────────────────────╯
EOF
    echo -e "${NC}"
}

# ═══════════════════════════════════════════════════════════════
# BRATTY MESSAGES
# ═══════════════════════════════════════════════════════════════

work_start_messages=(
    "Alright, FOCUS! I'll be watching~ (Not that I care if you succeed...)"
    "Work time! No distractions! ...Unless you want to disappoint me?"
    "Let's gooo~! Show me what you've got, baka Sensei!"
    "25 minutes. You and me. LET'S DO THIS! ♡"
    "Starting work mode! I BELIEVE in you! ...A little bit! Maybe!"
    "Okay okay, focus time~! I'll keep you company! Hmph!"
    "You wanted to be productive, right? PROVE IT!"
    "Work work work~! Kyahaha, suffer! (affectionately)"
)

work_midway_messages=(
    "Halfway there! Don't you DARE give up now!"
    "Still going? Hmm... maybe you're not completely useless~"
    "Keep pushing! I'm... I'm rooting for you, okay?!"
    "You're doing it!! ...Not that I'm impressed or anything!"
    "Half done~! See? You CAN focus when I'm watching!"
)

work_end_messages=(
    "TIME'S UP! You survived! I'm... proud? SHUT UP!"
    "Pomodoro complete!! Good job, baka~ ♡"
    "You did it!! Now take a break before you break!"
    "NICE! One more tomato in the bag~! Kyahaha!"
    "Work session done! ...You actually focused? Wow."
)

break_messages=(
    "Break time! Stretch! Hydrate! Think about me~!"
    "Rest now~! But don't rest TOO much, lazy!"
    "Taking a break! ...Want me to keep you company?"
    "Relax relax~! You earned it! (barely)"
    "Break! Go get snacks! Bring me virtual pocky!"
)

long_break_messages=(
    "LONG BREAK!! You finished 4 whole pomodoros!! That's... actually impressive..."
    "Wow, 4 in a row?? Maybe you're not hopeless after all! Take a REAL break!"
    "4 POMODOROS! I'm... I'm proud of you, baka! Go rest properly!!"
    "Incredible!! You did 4!! I'll allow you a long break~! ♡"
)

countdown_messages=(
    "Still working? Good~"
    "Focus focus~!"
    "I'm watching you~"
    "No slacking!"
    "You got this!"
    "Keep going!"
    "Almost there~"
    "Don't stop now!"
)

# ═══════════════════════════════════════════════════════════════
# UTILITY FUNCTIONS
# ═══════════════════════════════════════════════════════════════

random_message() {
    local -n arr=$1
    echo "${arr[$RANDOM % ${#arr[@]}]}"
}

play_bell() {
    # Terminal bell + say command if on macOS
    echo -e "\a"
    if command -v say &> /dev/null; then
        say "Time is up!" &
    fi
}

clear_line() {
    echo -ne "\r\033[K"
}

# ═══════════════════════════════════════════════════════════════
# TIMER FUNCTION
# ═══════════════════════════════════════════════════════════════

run_timer() {
    local minutes=$1
    local mode=$2
    local total_seconds=$((minutes * 60))
    local remaining=$total_seconds
    local midway_shown=false
    local last_msg_time=0

    while [ $remaining -gt 0 ]; do
        local mins=$((remaining / 60))
        local secs=$((remaining % 60))

        # Format time display
        printf -v time_display "%02d:%02d" $mins $secs

        # Show progress bar
        local progress=$((100 - (remaining * 100 / total_seconds)))
        local filled=$((progress / 5))
        local empty=$((20 - filled))

        local bar=""
        for ((i=0; i<filled; i++)); do bar+="█"; done
        for ((i=0; i<empty; i++)); do bar+="░"; done

        # Color based on mode
        if [ "$mode" = "work" ]; then
            echo -ne "\r${RED}🍅 ${time_display}${NC} [${YELLOW}${bar}${NC}] ${progress}%  "
        else
            echo -ne "\r${CYAN}☕ ${time_display}${NC} [${GREEN}${bar}${NC}] ${progress}%  "
        fi

        # Midway message for work sessions
        if [ "$mode" = "work" ] && [ $remaining -le $((total_seconds / 2)) ] && [ "$midway_shown" = false ]; then
            midway_shown=true
            echo ""
            echo -e "${MAGENTA}$(random_message work_midway_messages)${NC}"
        fi

        # Occasional encouragement (every 5 minutes during work)
        local current_time=$((total_seconds - remaining))
        if [ "$mode" = "work" ] && [ $((current_time % 300)) -eq 0 ] && [ $current_time -ne 0 ] && [ $current_time -ne $last_msg_time ]; then
            last_msg_time=$current_time
            # Only show if not just after midway
            if [ $current_time -ne $((total_seconds / 2)) ]; then
                echo ""
                echo -e "${CYAN}$(random_message countdown_messages)${NC}"
            fi
        fi

        sleep 1
        ((remaining--))
    done

    clear_line
    echo ""
}

# ═══════════════════════════════════════════════════════════════
# MAIN POMODORO CYCLE
# ═══════════════════════════════════════════════════════════════

show_status() {
    echo -e "${WHITE}═══════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}🍅 Completed Pomodoros: ${completed_pomodoros}${NC}"
    echo -e "${WHITE}═══════════════════════════════════════════════════${NC}"
    echo ""
}

start_work() {
    clear
    show_tomato
    show_mutsu_work
    show_status
    echo -e "${MAGENTA}$(random_message work_start_messages)${NC}"
    echo ""
    echo -e "${WHITE}Starting ${WORK_MINUTES}-minute work session...${NC}"
    echo ""

    run_timer $WORK_MINUTES "work"

    play_bell
    ((completed_pomodoros++))

    echo ""
    show_mutsu_proud
    echo -e "${GREEN}$(random_message work_end_messages)${NC}"
    echo ""
}

start_break() {
    local is_long_break=false
    local break_time=$SHORT_BREAK

    if [ $((completed_pomodoros % POMODOROS_UNTIL_LONG)) -eq 0 ] && [ $completed_pomodoros -ne 0 ]; then
        is_long_break=true
        break_time=$LONG_BREAK
    fi

    clear

    if [ "$is_long_break" = true ]; then
        show_mutsu_long_break
        show_status
        echo -e "${GREEN}$(random_message long_break_messages)${NC}"
        echo ""
        echo -e "${WHITE}Starting ${break_time}-minute LONG break! You earned it~${NC}"
    else
        show_mutsu_break
        show_status
        echo -e "${CYAN}$(random_message break_messages)${NC}"
        echo ""
        echo -e "${WHITE}Starting ${break_time}-minute break...${NC}"
    fi

    echo ""
    run_timer $break_time "break"

    play_bell
    echo ""
    echo -e "${YELLOW}Break over! Ready for another round?${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════
# MENU
# ═══════════════════════════════════════════════════════════════

show_menu() {
    echo -e "${WHITE}═══════════════════════════════════════════════════${NC}"
    echo -e "${RED}  🍅 MUTSU POMODORO TIMER 🍅${NC}"
    echo -e "${MAGENTA}  \"I'm helping you be productive... hmph!\"${NC}"
    echo -e "${WHITE}═══════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${GREEN}[w]${NC} Start Work Session (${WORK_MINUTES} min)"
    echo -e "  ${CYAN}[b]${NC} Start Break (${SHORT_BREAK} min / ${LONG_BREAK} min long)"
    echo -e "  ${YELLOW}[a]${NC} Auto Mode (work → break → work...)"
    echo -e "  ${MAGENTA}[s]${NC} Show Status"
    echo -e "  ${RED}[q]${NC} Quit"
    echo ""
    echo -e "  ${WHITE}Completed: ${YELLOW}${completed_pomodoros}${WHITE} pomodoros${NC}"
    echo ""
}

auto_mode() {
    echo -e "${MAGENTA}Starting AUTO MODE! I'll manage your time~${NC}"
    echo -e "${CYAN}Press Ctrl+C to stop whenever you want!${NC}"
    echo ""
    sleep 2

    while true; do
        start_work
        echo -e "${CYAN}Press Enter to start break, or Ctrl+C to quit...${NC}"
        read -r
        start_break
        echo -e "${YELLOW}Press Enter to start next work session, or Ctrl+C to quit...${NC}"
        read -r
    done
}

# ═══════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════

# Handle Ctrl+C gracefully
trap 'echo -e "\n${MAGENTA}Leaving already? ...See you next time, baka~ ♡${NC}"; exit 0' INT

# Custom time support
if [ "$1" = "--custom" ] && [ -n "$2" ]; then
    WORK_MINUTES=$2
    echo -e "${YELLOW}Custom work time set: ${WORK_MINUTES} minutes${NC}"
fi

if [ "$1" = "--quick" ]; then
    WORK_MINUTES=1
    SHORT_BREAK=1
    LONG_BREAK=2
    echo -e "${YELLOW}Quick test mode! (1 min work, 1 min break)${NC}"
fi

# Main loop
while true; do
    clear
    show_menu
    echo -ne "${WHITE}What do you want to do? ${NC}"
    read -r choice

    case $choice in
        w|W)
            start_work
            echo -e "${CYAN}Press Enter to continue...${NC}"
            read -r
            ;;
        b|B)
            start_break
            echo -e "${CYAN}Press Enter to continue...${NC}"
            read -r
            ;;
        a|A)
            auto_mode
            ;;
        s|S)
            clear
            show_status
            echo -e "${CYAN}Press Enter to continue...${NC}"
            read -r
            ;;
        q|Q)
            echo ""
            echo -e "${MAGENTA}Quitting already?${NC}"
            if [ $completed_pomodoros -gt 0 ]; then
                echo -e "${GREEN}You completed ${completed_pomodoros} pomodoro(s)! Not bad, baka~ ♡${NC}"
            else
                echo -e "${YELLOW}You didn't even do ONE pomodoro?? Lazy!! Come back later!${NC}"
            fi
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice! Try again, baka!${NC}"
            sleep 1
            ;;
    esac
done
