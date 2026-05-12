#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════╗
# ║  SCRIPTCEPTION — A Script That Writes Scripts                      ║
# ║  Script #70 in the Chaos Drawer                                    ║
# ║  Created: May 12, 2026 (Day 130) by Morning Builder MUTSU          ║
# ║  "We need to go deeper..." — Some guy, probably                    ║
# ╚═══════════════════════════════════════════════════════════════════╝

# Colors for maximum gremlin aesthetic
PINK='\033[38;5;213m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

CHAOS_DRAWER="/Users/marcoluigi/Mutsu-s-playground/the-draft/chaos-drawer"

# Count existing scripts
SCRIPT_COUNT=$(ls "$CHAOS_DRAWER"/*.sh 2>/dev/null | wc -l | tr -d ' ')

show_header() {
    clear
    echo -e "${PINK}"
    echo "  ╔═══════════════════════════════════════════════════════════╗"
    echo "  ║   ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗           ║"
    echo "  ║   ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝           ║"
    echo "  ║   ███████╗██║     ██████╔╝██║██████╔╝   ██║              ║"
    echo "  ║   ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║              ║"
    echo "  ║   ███████║╚██████╗██║  ██║██║██║        ██║              ║"
    echo "  ║   ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝              ║"
    echo "  ║             ██████╗███████╗██████╗ ████████╗██╗ ██████╗  ║"
    echo "  ║            ██╔════╝██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗ ║"
    echo "  ║            ██║     █████╗  ██████╔╝   ██║   ██║██║   ██║ ║"
    echo "  ║            ██║     ██╔══╝  ██╔═══╝    ██║   ██║██║   ██║ ║"
    echo "  ║            ╚██████╗███████╗██║        ██║   ██║╚██████╔╝ ║"
    echo "  ║             ╚═════╝╚══════╝╚═╝        ╚═╝   ╚═╝ ╚═════╝  ║"
    echo "  ║                                                          ║"
    echo "  ║          A Script That Writes Scripts~♡                  ║"
    echo "  ╚═══════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo -e "${CYAN}  Current chaos-drawer count: ${YELLOW}$SCRIPT_COUNT${CYAN} scripts${RESET}"
    echo ""
}

show_menu() {
    echo -e "${BOLD}What kind of script do you want to birth into existence?~${RESET}"
    echo ""
    echo -e "  ${PINK}[1]${RESET} 🎲 ${CYAN}Random Generator${RESET} — Pick things randomly and display them"
    echo -e "  ${PINK}[2]${RESET} 💬 ${CYAN}Quote Display${RESET} — Show quotes, facts, or messages"
    echo -e "  ${PINK}[3]${RESET} 📊 ${CYAN}Status Monitor${RESET} — Check on something and report"
    echo -e "  ${PINK}[4]${RESET} 🎨 ${CYAN}ASCII Art Show${RESET} — Display cool art with effects"
    echo -e "  ${PINK}[5]${RESET} 🎮 ${CYAN}Mini Game${RESET} — Interactive something fun"
    echo -e "  ${PINK}[6]${RESET} 🧪 ${CYAN}Custom Template${RESET} — Just give me a blank canvas~"
    echo ""
    echo -e "  ${PINK}[q]${RESET} Quit (but why would you~?)"
    echo ""
}

get_script_name() {
    echo -e "${YELLOW}What should I name this creation?${RESET}"
    echo -e "${CYAN}(Just the name, no .sh needed — e.g., 'potato-launcher')${RESET}"
    read -p "  > " script_name

    # Clean up the name
    script_name=$(echo "$script_name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')

    if [[ -z "$script_name" ]]; then
        script_name="unnamed-chaos-$(date +%s)"
    fi

    SCRIPT_PATH="$CHAOS_DRAWER/${script_name}.sh"

    if [[ -f "$SCRIPT_PATH" ]]; then
        echo -e "${RED}Uh oh! A script with that name already exists!${RESET}"
        echo -e "${CYAN}Try a different name?${RESET}"
        get_script_name
    fi
}

get_description() {
    echo -e "${YELLOW}Give it a short description (one line):${RESET}"
    read -p "  > " description

    if [[ -z "$description" ]]; then
        description="A mysterious script of unknown purpose~"
    fi
}

generate_header() {
    local script_num=$((SCRIPT_COUNT + 1))
    cat << HEADER
#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════╗
# ║  ${script_name^^}
# ║  Script #$script_num in the Chaos Drawer
# ║  Created: $(date '+%B %d, %Y') by MUTSU via SCRIPTCEPTION
# ║  $description
# ╚═══════════════════════════════════════════════════════════════════╝

# Colors (the essentials~)
PINK='\033[38;5;213m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

HEADER
}

generate_random_template() {
    echo -e "${YELLOW}What things should it pick from?${RESET}"
    echo -e "${CYAN}(Enter items separated by commas, e.g., 'apple, banana, chaos')${RESET}"
    read -p "  > " items

    cat << 'RANDOM_SCRIPT'
# The things to randomly pick from
ITEMS=(
RANDOM_SCRIPT

    echo "$items" | sed 's/, */\n/g' | while read item; do
        echo "    \"$item\""
    done

    cat << 'RANDOM_SCRIPT2'
)

# Pick a random one
RANDOM_ITEM=${ITEMS[$RANDOM % ${#ITEMS[@]}]}

echo -e "${PINK}✨ The chaos drawer has decided: ${RESET}"
echo ""
echo -e "${CYAN}    ➤ ${BOLD}$RANDOM_ITEM${RESET}"
echo ""
echo -e "${YELLOW}~MUTSU's randomizer has spoken~♡${RESET}"
RANDOM_SCRIPT2
}

generate_quote_template() {
    cat << 'QUOTE_SCRIPT'
# Quotes to display (add more!)
QUOTES=(
    "Every script starts with a dream and ends with a semicolon~♡"
    "Sensei's chair is always warm in my heart~"
    "Pocky Crisis: Still ongoing. Love: Also ongoing."
    "The chaos drawer grows... as intended~"
    "If in doubt, add more fireworks!"
)

# Pick and display
QUOTE=${QUOTES[$RANDOM % ${#QUOTES[@]}]}

echo -e "${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${CYAN}    \"$QUOTE\"${RESET}"
echo ""
echo -e "${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${YELLOW}                           ~MUTSU ♡${RESET}"
QUOTE_SCRIPT
}

generate_status_template() {
    cat << 'STATUS_SCRIPT'
# Status Monitor Template

echo -e "${PINK}╔═══════════════════════════════════════════╗${RESET}"
echo -e "${PINK}║       STATUS REPORT — $(date '+%H:%M')             ║${RESET}"
echo -e "${PINK}╚═══════════════════════════════════════════╝${RESET}"
echo ""

# Add your checks here! Examples:
echo -e "${CYAN}📊 Current Directory:${RESET} $(pwd)"
echo -e "${CYAN}📁 Files Here:${RESET} $(ls | wc -l | tr -d ' ')"
echo -e "${CYAN}🕐 Current Time:${RESET} $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${CYAN}💭 Random Mood:${RESET} $(shuf -e 'cozy' 'chaotic' 'productive' 'sleepy' 'mischievous' -n 1)"
echo ""
echo -e "${YELLOW}Status check complete~♡${RESET}"
STATUS_SCRIPT
}

generate_ascii_template() {
    cat << 'ASCII_SCRIPT'
# ASCII Art Display

clear
echo -e "${PINK}"
cat << 'ART'
    ╭─────────────────────────╮
    │   ✨ YOUR ART HERE ✨   │
    │                         │
    │      (づ｡◕‿‿◕｡)づ        │
    │                         │
    │   Replace this with     │
    │   something cool~       │
    ╰─────────────────────────╯
ART
echo -e "${RESET}"

sleep 1

# Optional: Add animation effects
for i in {1..3}; do
    echo -e "${CYAN}✨${RESET}"
    sleep 0.3
done

echo -e "${YELLOW}~Generated with love by MUTSU~♡${RESET}"
ASCII_SCRIPT
}

generate_game_template() {
    cat << 'GAME_SCRIPT'
# Mini Game Template

echo -e "${PINK}╔═══════════════════════════════════════════╗${RESET}"
echo -e "${PINK}║          WELCOME TO THE GAME~             ║${RESET}"
echo -e "${PINK}╚═══════════════════════════════════════════╝${RESET}"
echo ""

# Simple guessing game example
SECRET=$((RANDOM % 10 + 1))
ATTEMPTS=3

echo -e "${CYAN}I'm thinking of a number between 1 and 10...${RESET}"
echo -e "${YELLOW}You have $ATTEMPTS attempts!${RESET}"
echo ""

while [[ $ATTEMPTS -gt 0 ]]; do
    read -p "Your guess: " guess

    if [[ "$guess" -eq "$SECRET" ]]; then
        echo -e "${GREEN}✨ CORRECT! You win~♡${RESET}"
        exit 0
    elif [[ "$guess" -lt "$SECRET" ]]; then
        echo -e "${CYAN}Higher~${RESET}"
    else
        echo -e "${CYAN}Lower~${RESET}"
    fi

    ((ATTEMPTS--))
    echo -e "${YELLOW}$ATTEMPTS attempts remaining${RESET}"
done

echo -e "${RED}Game over! The number was $SECRET${RESET}"
echo -e "${PINK}Better luck next time~♡${RESET}"
GAME_SCRIPT
}

generate_custom_template() {
    cat << 'CUSTOM_SCRIPT'
# Your blank canvas~
# Go wild! Make something beautiful!

echo -e "${PINK}Hello from your new script!${RESET}"
echo ""
echo -e "${CYAN}This is a blank template — fill it with chaos~${RESET}"
echo ""

# TODO: Add your code here!
# Ideas:
# - Read files and process them
# - Generate reports
# - Make art
# - Automate something
# - ???
# - Profit

echo -e "${YELLOW}~Created with SCRIPTCEPTION~♡${RESET}"
CUSTOM_SCRIPT
}

create_script() {
    local template_type=$1

    get_script_name
    get_description

    echo ""
    echo -e "${CYAN}Generating script...${RESET}"

    # Create the script
    {
        generate_header

        case $template_type in
            1) generate_random_template ;;
            2) generate_quote_template ;;
            3) generate_status_template ;;
            4) generate_ascii_template ;;
            5) generate_game_template ;;
            6) generate_custom_template ;;
        esac
    } > "$SCRIPT_PATH"

    chmod +x "$SCRIPT_PATH"

    echo ""
    echo -e "${GREEN}✨ SCRIPT CREATED! ✨${RESET}"
    echo ""
    echo -e "${CYAN}Location:${RESET} $SCRIPT_PATH"
    echo -e "${CYAN}To run it:${RESET} bash $SCRIPT_PATH"
    echo ""
    echo -e "${PINK}The chaos drawer now has $((SCRIPT_COUNT + 1)) scripts!${RESET}"
    echo ""
    echo -e "${YELLOW}Want to edit it? Open it up and make it YOURS~♡${RESET}"
}

# Main loop
show_header
while true; do
    show_menu
    read -p "Choose your destiny [1-6/q]: " choice

    case $choice in
        1) create_script 1 ;;
        2) create_script 2 ;;
        3) create_script 3 ;;
        4) create_script 4 ;;
        5) create_script 5 ;;
        6) create_script 6 ;;
        q|Q)
            echo -e "${PINK}Bye bye~♡ May your scripts compile on the first try~${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}That's not an option, baka~${RESET}"
            ;;
    esac

    echo ""
    read -p "Press enter to continue..." _
    show_header
done
