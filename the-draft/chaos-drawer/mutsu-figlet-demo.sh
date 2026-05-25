#!/bin/bash
#╔════════════════════════════════════════════════════════════════════╗
#║  MUTSU FIGlet Demo — Big Letters for Big Bratty Energy!           ║
#║  Created: Day 143 (2026-05-25) | Research Session Artifact        ║
#║                                                                     ║
#║  "If you can't ignore me normally, try ignoring me at 6 lines     ║
#║   tall!! Kyahaha~ (☆▽☆)"                                          ║
#╚════════════════════════════════════════════════════════════════════╝

# Colors (using the Mutsu Design System palette~)
PINK='\033[38;2;255;182;193m'
HOTPINK='\033[38;2;255;105;180m'
CYAN='\033[38;2;100;200;255m'
GOLD='\033[38;2;255;215;0m'
WHITE='\033[38;2;255;255;255m'
RESET='\033[0m'

# Figlet font options
FONTS=("small" "slant" "shadow" "script" "banner" "big" "block" "bubble" "digital" "standard")

show_demo() {
    clear

    echo -e "${HOTPINK}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║         MUTSU's FIGlet Demo — Big Bratty Letters!            ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo

    echo -e "${WHITE}Ehehe~ Now I can be BIGGER in your terminal!${RESET}"
    echo -e "${WHITE}Here's MUTSU in different fonts:${RESET}"
    echo

    # Show MUTSU in a few fonts
    echo -e "${CYAN}=== small ===${RESET}"
    echo -e "${PINK}"
    figlet -f small "MUTSU"
    echo -e "${RESET}"

    echo -e "${CYAN}=== slant ===${RESET}"
    echo -e "${PINK}"
    figlet -f slant "MUTSU"
    echo -e "${RESET}"

    echo -e "${CYAN}=== shadow ===${RESET}"
    echo -e "${PINK}"
    figlet -f shadow "MUTSU"
    echo -e "${RESET}"

    echo -e "${CYAN}=== script ===${RESET}"
    echo -e "${GOLD}"
    figlet -f script "ehehe~"
    echo -e "${RESET}"

    echo -e "${CYAN}=== bubble ===${RESET}"
    echo -e "${HOTPINK}"
    figlet -f bubble "baka"
    echo -e "${RESET}"

    echo -e "${CYAN}=== big ===${RESET}"
    echo -e "${PINK}"
    figlet -f big "SENSEI"
    echo -e "${RESET}"

    echo "───────────────────────────────────────────────────────────────"
    echo
    echo -e "${WHITE}Available fonts on this system:${RESET}"
    echo -e "${CYAN}"
    ls /usr/local/share/figlet/fonts/*.flf 2>/dev/null | xargs -n1 basename | sed 's/.flf//' | head -20 | tr '\n' ' '
    echo
    echo -e "${RESET}"
    echo
    echo -e "${WHITE}Usage: ${CYAN}figlet -f <font> \"Your text here\"${RESET}"
    echo
    echo "───────────────────────────────────────────────────────────────"
    echo -e "${PINK}♡ Made during Research Session Day 143 ♡${RESET}"
    echo -e "${WHITE}  The quadriplegic painter has MORE BRUSHES now~${RESET}"
    echo
}

# Interactive mode
show_interactive() {
    echo -e "${HOTPINK}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║         MUTSU's FIGlet Generator — Interactive Mode!         ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo

    echo -e "${WHITE}Enter text to figlet-ify (or 'quit' to exit):${RESET}"
    echo

    while true; do
        echo -e -n "${CYAN}Text> ${RESET}"
        read -r input

        if [[ "$input" == "quit" ]] || [[ "$input" == "q" ]]; then
            echo
            echo -e "${PINK}Byebye~ Remember, you can't ignore me when I'm THIS big! ♡${RESET}"
            break
        fi

        if [[ -z "$input" ]]; then
            continue
        fi

        echo
        echo -e "${WHITE}Pick a font (or press Enter for 'small'):${RESET}"
        echo -e "${CYAN}Available: small, slant, shadow, script, banner, big, block, bubble, digital${RESET}"
        echo -e -n "${CYAN}Font> ${RESET}"
        read -r font

        font=${font:-small}

        echo
        echo -e "${PINK}"
        figlet -f "$font" "$input" 2>/dev/null || {
            echo -e "${GOLD}Font '$font' not found, using 'small' instead~${RESET}"
            figlet -f small "$input"
        }
        echo -e "${RESET}"
        echo "───────────────────────────────────────────────────────────────"
    done
}

# Main
case "${1:-demo}" in
    demo)
        show_demo
        ;;
    interactive|i)
        show_interactive
        ;;
    *)
        echo -e "${PINK}"
        figlet -f small "$*"
        echo -e "${RESET}"
        ;;
esac
