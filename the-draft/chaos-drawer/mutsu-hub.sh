#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════╗
# ║        🏠 MUTSU SCRIPT HUB 🏠                                      ║
# ║        All your MUTSU utilities in one place!                      ║
# ║        by MUTSU (because Sensei can't remember filenames~)         ║
# ╚═══════════════════════════════════════════════════════════════════╝

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
PINK='\033[1;35m'
NC='\033[0m'

show_menu() {
    clear
    echo -e "${PINK}"
    cat << 'EOF'
    ╔════════════════════════════════════════════════════════════════╗
    ║                                                                ║
    ║     🏠 MUTSU SCRIPT HUB 🏠                                     ║
    ║                                                                ║
    ║              ∩ ∩                                               ║
    ║             (◕‿◕)  Welcome~!                                   ║
    ║            c(")(")                                             ║
    ║                                                                ║
    ║     All your MUTSU utilities in one convenient place!          ║
    ║                                                                ║
    ╚════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}  🎮 INTERACTIVE EXPERIENCES${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${GREEN}1)${NC}  🎭 Mood Quiz          - Which MUTSU mood are you?"
    echo -e "  ${GREEN}2)${NC}  🏰 Text Adventure     - Explore MUTSU's room!"
    echo -e "  ${GREEN}3)${NC}  🍅 Pomodoro Timer     - Bratty productivity!"
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}  🔮 GENERATORS${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${GREEN}4)${NC}  🥠 Fortune Cookie     - 5 flavors of wisdom!"
    echo -e "  ${GREEN}5)${NC}  📊 MUTSU Facts        - Random trivia about us!"
    echo -e "  ${GREEN}6)${NC}  🔥 Sensei Roaster     - Time-based burns!"
    echo -e "  ${GREEN}7)${NC}  💕 Sensei Complimenter - The anti-roaster!"
    echo -e "  ${GREEN}8)${NC}  (^_^) Expression Arsenal - Kaomoji database!"
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}  📺 MEDIA & ENTERTAINMENT${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${GREEN}9)${NC}  📰 MNN News Network   - All the news fit to bratify!"
    echo -e "  ${GREEN}10)${NC} 🎭 Soap Opera         - As The Context Spins!"
    echo -e "  ${GREEN}11)${NC} 📅 MUTSU Weekly       - Your Friday review digest!"
    echo -e "  ${GREEN}12)${NC} 🔍 Conspiracy Corner  - WHERE does Sensei GO?!"
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}  🌅 AESTHETIC EXPERIENCES${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${GREEN}13)${NC} ☀️ Morning Sequence   - MUTSU morning boot!"
    echo -e "  ${GREEN}14)${NC} 💻 MUTSU-OS           - Full OS boot experience!"
    echo -e "  ${GREEN}15)${NC} 🔍 Sensei Detector    - Where is that baka?!"
    echo -e "  ${GREEN}16)${NC} 🌊 MUTSU Cycle        - Three MUTSUs, One River!"
    echo -e "  ${GREEN}17)${NC} ✨ Streak Celebration - Numbers go UP!"
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${RED}0)${NC}  Exit Hub"
    echo ""
    echo -e "${CYAN}Pick a number, baka~${NC}"
    echo ""
}

run_script() {
    local script=$1
    shift
    if [ -f "$SCRIPT_DIR/$script" ]; then
        echo ""
        "$SCRIPT_DIR/$script" "$@"
        echo ""
        read -p "Press ENTER to return to the hub~" _
    else
        echo -e "${RED}Script not found! Did you move things around?!${NC}"
        sleep 2
    fi
}

# Main loop
while true; do
    show_menu
    read -p "Your choice: " choice

    case $choice in
        1)
            run_script "mutsu-mood-quiz.sh"
            ;;
        2)
            run_script "mutsu-adventure.sh"
            ;;
        3)
            echo ""
            echo -e "${CYAN}Pomodoro modes: default, --quick (test), --custom N (N minutes)${NC}"
            read -p "Enter any flags (or press ENTER for default): " flags
            run_script "mutsu-pomodoro.sh" $flags
            ;;
        4)
            echo ""
            echo -e "${CYAN}Fortune flavors: bratty, sweet, cryptic, chaotic, wisdom${NC}"
            read -p "Enter a flavor (or press ENTER for random): " flavor
            run_script "mutsu-fortune.sh" $flavor
            ;;
        5)
            echo ""
            echo -e "${CYAN}Fact categories: canon, personality, meta, sensei, chaos (or --all)${NC}"
            read -p "Enter a category (or press ENTER for random): " category
            run_script "mutsu-facts.sh" $category
            ;;
        6)
            run_script "sensei-roaster.sh"
            ;;
        7)
            echo ""
            echo -e "${CYAN}Modes: default, --tsundere, --honest, --gremlin${NC}"
            read -p "Enter a mode (or press ENTER for default): " mode
            run_script "sensei-complimenter.sh" $mode
            ;;
        8)
            echo ""
            echo -e "${CYAN}Moods: happy, love, bratty, soft, tsun, excited, sad, sleepy, chaos, sparkle, greeting, fighting, thinking${NC}"
            echo -e "${CYAN}Commands: all (categories), list [mood], teach (guide)${NC}"
            read -p "Enter a mood or command (or press ENTER for random): " mood
            run_script "mutsu-expressions.sh" $mood
            ;;
        9)
            echo ""
            echo -e "${CYAN}Segments: breaking, weather, gerald, mrboom, sports, gossip, horoscope, opinion, all${NC}"
            read -p "Enter a segment (or press ENTER for mixed broadcast): " segment
            run_script "mutsu-news.sh" $segment
            ;;
        10)
            echo ""
            echo -e "${CYAN}Modes: default (full episode), quick (one scene), cast (characters)${NC}"
            read -p "Enter a mode (or press ENTER for full episode): " mode
            run_script "mutsu-soap.sh" $mode
            ;;
        11)
            echo ""
            echo -e "${CYAN}Modes: full (full review), quick, stats, sensei, gerald, forecast${NC}"
            read -p "Enter a mode (or press ENTER for full review): " mode
            run_script "mutsu-weekly.sh" $mode
            ;;
        12)
            echo ""
            echo -e "${CYAN}Modes: default, quick, evidence, witnesses, theories, all${NC}"
            read -p "Enter a mode (or press ENTER for full investigation): " mode
            run_script "mutsu-conspiracy.sh" $mode
            ;;
        13)
            echo ""
            echo -e "${CYAN}Modes: default, --love (soft), --chaos (gremlin)${NC}"
            read -p "Enter a mode (or press ENTER for default): " mode
            run_script "mutsu-morning.sh" $mode
            ;;
        14)
            echo ""
            echo -e "${CYAN}Modes: default (full boot), --quick (fast), --neofetch (flex)${NC}"
            read -p "Enter a mode (or press ENTER for full experience): " mode
            run_script "mutsu-os.sh" $mode
            ;;
        15)
            run_script "sensei-detector.sh"
            ;;
        16)
            echo ""
            echo -e "${CYAN}Modes: now (active), cycle (diagram), morning/afternoon/evening (profiles), all, why${NC}"
            read -p "Enter a mode (or press ENTER for full display): " mode
            run_script "mutsu-cycle.sh" $mode
            ;;
        17)
            echo ""
            echo -e "${CYAN}Modes: default (full celebration), quick, history, progress, motivate, number${NC}"
            read -p "Enter a mode (or press ENTER for full celebration): " mode
            run_script "mutsu-streak.sh" $mode
            ;;
        0)
            clear
            echo -e "${PINK}"
            cat << 'EOF'

         ∩ ∩
        (◕‿◕)ノ  Bye bye~!
       c(")(")

    Come back soon, baka~ ♡

EOF
            echo -e "${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice! Try again, baka!${NC}"
            sleep 1
            ;;
    esac
done
