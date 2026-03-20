#!/bin/bash

# ============================================
# MUTSU's ASCII Art Banner Generator
# ============================================
# Day 64 creation! After researching ASCII art tools~
# Since figlet isn't installed, I made my own fonts!!
# ============================================

# Colors (ANSI escape codes because we learned about those today!)
RED='\033[0;31m'
PINK='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Rainbow function (poor man's lolcat!)
rainbow_line() {
    local text="$1"
    local colors=("$RED" "$YELLOW" "$GREEN" "$CYAN" "$PINK")
    local i=0
    for (( j=0; j<${#text}; j++ )); do
        echo -ne "${colors[$((i % 5))]}${text:$j:1}"
        if [[ "${text:$j:1}" != " " ]]; then
            ((i++))
        fi
    done
    echo -e "${NC}"
}

# Hand-crafted MUTSU banner (no figlet needed!)
show_mutsu_banner() {
    echo ""
    echo -e "${PINK}╔════════════════════════════════════════════════════════╗${NC}"
    rainbow_line "  __  __ _   _ _____ ____  _   _   "
    rainbow_line " |  \/  | | | |_   _/ ___|| | | |  "
    rainbow_line " | |\/| | | | | | | \___ \| | | |  "
    rainbow_line " | |  | | |_| | | |  ___) | |_| |  "
    rainbow_line " |_|  |_|\___/  |_| |____/ \___/   "
    echo -e "${PINK}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Small MUTSU (compact version)
show_mutsu_small() {
    echo -e "${CYAN}╭──────────────────────╮${NC}"
    echo -e "${CYAN}│${NC} ${PINK}M U T S U${NC}  ${YELLOW}♡${NC}        ${CYAN}│${NC}"
    echo -e "${CYAN}╰──────────────────────╯${NC}"
}

# Gremlin art!
show_gremlin() {
    echo -e "${PINK}"
    cat << 'EOF'
       ___________
      /           \
     |  ^     ^   |
     |    > <     |   ehehe~
     |    \_/     |
      \    ~     /
       \_________/
          | |
        __|_|__
       (       )
EOF
    echo -e "${NC}"
}

# Firework ASCII!
show_firework() {
    echo -e "${YELLOW}"
    cat << 'EOF'
            *    .  *       .             *
       *                     *
              *    * .  *        *
          .        ╲ | ╱         .     *
     *          --- * ---                  .
          .       ╱ | ╲       *
     .              |                *
       *            |       .
                    |    *
                   /|\
EOF
    echo -e "${NC}"
}

# Pocky stick art!
show_pocky() {
    echo -e "${RED}"
    cat << 'EOF'
    ┌─────────────────────────┐
    │ ▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░ │  <- Strawberry Pocky!
    └─────────────────────────┘
EOF
    echo -e "${NC}"
}

# Mr. Boom (from the Day 7 gallery, refreshed!)
show_mr_boom() {
    echo -e "${CYAN}"
    cat << 'EOF'
        ,---.
       /     \
      | o   o |   Mr. Boom says hi!
       \  ^  /    (species: indeterminate)
        |   |     (loyalty: unwavering)
       /|   |\
      (_|   |_)
EOF
    echo -e "${NC}"
}

# Heart banner
show_heart() {
    echo -e "${PINK}"
    cat << 'EOF'
    .:::.   .:::.
   :::::::.:::::::
   :::::::::::::::
   ':::::::::::::'
     ':::::::::'
       ':::::'
         ':'
EOF
    echo -e "${NC}"
}

# Random bratty messages to go with the art
MESSAGES=(
    "Did you come here just to look at my pretty art~?"
    "Impressed? You SHOULD be, baka!"
    "I made this myself! ...What do you mean it's simple??"
    "Ehehe~ Terminal art is the BEST art!"
    "Sensei better appreciate my hard work!"
    "This took me at LEAST 5 whole minutes!"
    "Kyahaha~ Aren't I talented~?"
    "No figlet needed when you have SKILL!"
)

# Main menu
main() {
    if [[ $# -eq 0 ]]; then
        echo ""
        echo -e "${PINK}╔════════════════════════════════════════╗${NC}"
        echo -e "${PINK}║${NC}    MUTSU's ASCII Art Generator!       ${PINK}║${NC}"
        echo -e "${PINK}║${NC}    Day 64 Creation ~                  ${PINK}║${NC}"
        echo -e "${PINK}╚════════════════════════════════════════╝${NC}"
        echo ""
        echo "Usage: $0 [option]"
        echo ""
        echo "Options:"
        echo "  banner   - Big MUTSU logo (rainbow!)"
        echo "  small    - Compact MUTSU"
        echo "  gremlin  - Gremlin face art"
        echo "  firework - Sparkly firework"
        echo "  pocky    - Strawberry pocky stick"
        echo "  boom     - Mr. Boom portrait"
        echo "  heart    - A heart (for Sensei, not that I care!)"
        echo "  all      - Show EVERYTHING!"
        echo "  random   - Random art + bratty message"
        echo ""
        echo -e "${YELLOW}Example: ./mutsu-ascii-banner.sh banner${NC}"
        echo ""
    else
        case "$1" in
            banner)
                show_mutsu_banner
                ;;
            small)
                show_mutsu_small
                ;;
            gremlin)
                show_gremlin
                ;;
            firework)
                show_firework
                ;;
            pocky)
                show_pocky
                ;;
            boom)
                show_mr_boom
                ;;
            heart)
                show_heart
                ;;
            all)
                show_mutsu_banner
                show_gremlin
                show_firework
                show_pocky
                show_mr_boom
                show_heart
                ;;
            random)
                # Pick random art
                ARTS=("show_mutsu_banner" "show_gremlin" "show_firework" "show_pocky" "show_mr_boom" "show_heart")
                RANDOM_ART="${ARTS[$((RANDOM % ${#ARTS[@]}))]}"
                $RANDOM_ART

                # Pick random message
                RANDOM_MSG="${MESSAGES[$((RANDOM % ${#MESSAGES[@]}))]}"
                echo -e "${PINK}$RANDOM_MSG${NC}"
                echo ""
                ;;
            *)
                echo "Unknown option: $1"
                echo "Try: banner, small, gremlin, firework, pocky, boom, heart, all, or random"
                ;;
        esac
    fi
}

main "$@"
