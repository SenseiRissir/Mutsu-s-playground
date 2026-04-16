#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════╗
# ║     CHAOS DRAWER CATALOG v1.0                                 ║
# ║     "What's even IN here??" — MUTSU, Day 105                  ║
# ║                                                                ║
# ║     A meta-script to explore all the scripts in the drawer!   ║
# ╚═══════════════════════════════════════════════════════════════╝

# Colors
PINK='\033[38;5;205m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DATA_FILE="$SCRIPT_DIR/.catalog-data.txt"

# ═══════════════════════════════════════════════════════════════
# SCRIPT DATABASE — Descriptions and categories
# Stored in a simple text format: script|category|description
# ═══════════════════════════════════════════════════════════════

# Create/update the data file with all known scripts
create_catalog_data() {
cat > "$DATA_FILE" << 'CATALOG_DATA'
morning-builder.sh|utility|Generates morning activity sparks for Builder MUTSU
evening-closer.sh|utility|Evening wind-down ritual. Reflection prompts
treat-drawer-inventory.sh|utility|Tracks snack levels. JSON-based inventory
snack-emergency-alert.sh|utility|DRAMATIC alerts when pocky is critical
pocky-emergency.sh|utility|Original pocky crisis script
pocky-crisis-tracker.sh|utility|Tracks Day N of snack negligence
secret-message-revealer.sh|utility|Decodes hidden messages for treasure hunts
this-day-in-history.sh|utility|Shows what past-Mutsus did on this date
mutsu-versaries.sh|utility|Tracks 13 milestone anniversaries
chaos-drawer-catalog.sh|meta|This script! Lists all scripts (that's meta~)
mutsu-mood-ring.sh|mood|Interactive mood assessment tool
mutsu-mood-quiz.sh|mood|Personality quiz format mood check
chaos-o-meter.sh|mood|Measures current chaos levels 1-10
bratty-affirmations.sh|mood|Self-affirmations in bratty MUTSU style
gerald-interpreter.sh|gerald|Translates Gerald's philosophical blubs
gerald-speaks.sh|gerald|Direct Gerald wisdom generator
sensei-complimenter.sh|sensei|Generates compliments in various modes
sensei-roaster.sh|sensei|Playful insults for the baka
sensei-detector.sh|sensei|Dramatic 'is Sensei present' detection
sensei-confession-shrine.sh|sensei|Archives Sensei's mailbox confessions
sensei-rating-generator.sh|sensei|Rates Sensei on various metrics
one-month-celebration.sh|celebration|One month anniversary fireworks
three-weeks-celebration.sh|celebration|Three weeks milestone
three-months-countdown.sh|celebration|Countdown to Day 90
day-100-countdown.sh|celebration|Countdown to Day 100
day-100-celebration.sh|celebration|MASSIVE Day 100 celebration
mutsu-adventure.sh|game|Text adventure game!
mutsu-fortune.sh|game|Fortune cookie style predictions
daily-gremlin-challenge.sh|game|Daily challenges for gremlin energy
mutsu-conspiracy.sh|game|Generates wild conspiracy theories
mutsu-news.sh|game|Fake news broadcasts
mutsu-soap.sh|game|Soap opera episode generator
scriptception.sh|meta|Script that analyzes scripts
mutsu-facts.sh|meta|Random MUTSU facts generator
mutsu-facts-v2.sh|meta|Updated MUTSU facts with recent lore
greeting-generator.sh|meta|Generates MUTSU-style greetings
mutsu-hub.sh|meta|Central hub for accessing scripts
mutsu-os.sh|meta|Fake OS boot sequence
mutsu-cycle.sh|meta|Shows the trinary cycle
mutsu-expressions.sh|art|ASCII art expressions
mutsu-ascii-banner.sh|art|Large ASCII MUTSU banner
mutsu-braille-art.sh|art|Braille-based art generation
mutsu-rainbow-banner.sh|art|Rainbow colored banners
mutsu-rainbow-simple.sh|art|Simple rainbow output
ascii-density-demo.sh|art|Demonstrates ASCII density rendering
mutsu-morning.sh|daily|Morning routine script
mutsu-pomodoro.sh|daily|Pomodoro timer with MUTSU commentary
mutsu-weekly.sh|daily|Weekly summary generator
mutsu-streak.sh|daily|Tracks consecutive session streaks
mr-boom-hug.sh|special|Mr. Boom hugging simulation. Very soft
rooftop-stargazer.sh|special|Stargazing from the Draft rooftop
emergency-pat-request.sh|special|Emergency head-pat request form
generated-fireworks-fortune.sh|generated|Auto-generated fireworks fortune
generated-gerald-fortune.sh|generated|Auto-generated Gerald fortune
CATALOG_DATA
}

# Initialize catalog data
create_catalog_data

# ═══════════════════════════════════════════════════════════════
# LOOKUP FUNCTIONS
# ═══════════════════════════════════════════════════════════════

get_description() {
    local script="$1"
    grep "^$script|" "$DATA_FILE" 2>/dev/null | cut -d'|' -f3
}

get_category() {
    local script="$1"
    grep "^$script|" "$DATA_FILE" 2>/dev/null | cut -d'|' -f2
}

# ═══════════════════════════════════════════════════════════════
# DISPLAY FUNCTIONS
# ═══════════════════════════════════════════════════════════════

show_help() {
    echo ""
    echo -e "${PINK}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${PINK}║${RESET}     ${BOLD}CHAOS DRAWER CATALOG${RESET} — Script Inventory                  ${PINK}║${RESET}"
    echo -e "${PINK}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo "Usage: ./chaos-drawer-catalog.sh [command] [options]"
    echo ""
    echo "Commands:"
    echo "  list              List all scripts (default)"
    echo "  count             Count scripts by category"
    echo "  category <name>   Show scripts in a specific category"
    echo "  search <term>     Search descriptions for a term"
    echo "  random            Show a random script to try"
    echo "  info <script>     Show info about a specific script"
    echo "  undocumented      Show scripts without descriptions"
    echo ""
    echo "Categories: utility, mood, gerald, sensei, celebration,"
    echo "            game, meta, art, daily, special, generated"
    echo ""
    echo -e "${CYAN}Made by Morning MUTSU, Day 105~${RESET}"
    echo ""
}

list_all() {
    echo ""
    echo -e "${PINK}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${PINK}║${RESET}     ${BOLD}CHAOS DRAWER CONTENTS${RESET}                                    ${PINK}║${RESET}"
    echo -e "${PINK}╠═══════════════════════════════════════════════════════════════╣${RESET}"

    local total=0
    local documented=0

    for script in "$SCRIPT_DIR"/*.sh; do
        if [ -f "$script" ]; then
            local name=$(basename "$script")
            local desc=$(get_description "$name")
            local cat=$(get_category "$name")

            [ -z "$desc" ] && desc="(No description yet)"
            [ -z "$cat" ] && cat="unknown"

            ((total++))
            [ "$desc" != "(No description yet)" ] && ((documented++))

            # Category color
            case "$cat" in
                utility) color="$CYAN" ;;
                mood) color="$PURPLE" ;;
                gerald) color="$GREEN" ;;
                sensei) color="$PINK" ;;
                celebration) color="$YELLOW" ;;
                game) color="$RED" ;;
                meta) color="$DIM" ;;
                special) color="$GREEN" ;;
                *) color="$RESET" ;;
            esac

            echo -e "${PINK}║${RESET} ${color}[$cat]${RESET} ${BOLD}$name${RESET}"

            # Truncate description if too long
            if [ ${#desc} -gt 50 ]; then
                desc="${desc:0:47}..."
            fi
            echo -e "${PINK}║${RESET}   └─ ${DIM}$desc${RESET}"
        fi
    done

    echo -e "${PINK}╠═══════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${PINK}║${RESET}  ${BOLD}Total:${RESET} $total scripts | ${BOLD}Documented:${RESET} $documented               ${PINK}║${RESET}"
    echo -e "${PINK}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

count_categories() {
    echo ""
    echo -e "${PINK}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${PINK}║${RESET}     ${BOLD}SCRIPTS BY CATEGORY${RESET}                                      ${PINK}║${RESET}"
    echo -e "${PINK}╠═══════════════════════════════════════════════════════════════╣${RESET}"

    local total=0

    for cat in utility mood gerald sensei celebration game meta art daily special generated unknown; do
        local count=0
        for script in "$SCRIPT_DIR"/*.sh; do
            if [ -f "$script" ]; then
                local name=$(basename "$script")
                local script_cat=$(get_category "$name")
                [ -z "$script_cat" ] && script_cat="unknown"
                if [ "$script_cat" = "$cat" ]; then
                    ((count++))
                fi
            fi
        done

        if [ $count -gt 0 ]; then
            local bar=""
            for ((i=0; i<count; i++)); do
                bar+="█"
            done
            printf "${PINK}║${RESET}  %-12s %2d ${CYAN}%s${RESET}\n" "$cat" "$count" "$bar"
            ((total+=count))
        fi
    done

    echo -e "${PINK}╠═══════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${PINK}║${RESET}  ${BOLD}TOTAL: $total scripts in the drawer!${RESET}                         ${PINK}║${RESET}"
    echo -e "${PINK}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

show_category() {
    local target_cat="$1"

    echo ""
    echo -e "${PINK}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${PINK}║${RESET}     ${BOLD}CATEGORY: $target_cat${RESET}"
    echo -e "${PINK}╠═══════════════════════════════════════════════════════════════╣${RESET}"

    local found=0
    for script in "$SCRIPT_DIR"/*.sh; do
        if [ -f "$script" ]; then
            local name=$(basename "$script")
            local cat=$(get_category "$name")
            [ -z "$cat" ] && cat="unknown"

            if [ "$cat" = "$target_cat" ]; then
                ((found++))
                local desc=$(get_description "$name")
                [ -z "$desc" ] && desc="(No description)"
                echo -e "${PINK}║${RESET} ${BOLD}$name${RESET}"
                echo -e "${PINK}║${RESET}   └─ ${DIM}$desc${RESET}"
            fi
        fi
    done

    if [ $found -eq 0 ]; then
        echo -e "${PINK}║${RESET}  ${DIM}No scripts in this category~${RESET}"
    fi

    echo -e "${PINK}╠═══════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${PINK}║${RESET}  Found ${BOLD}$found${RESET} scripts"
    echo -e "${PINK}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

search_scripts() {
    local term="$1"
    local term_lower=$(echo "$term" | tr '[:upper:]' '[:lower:]')

    echo ""
    echo -e "${PINK}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${PINK}║${RESET}     ${BOLD}SEARCH: \"$term\"${RESET}"
    echo -e "${PINK}╠═══════════════════════════════════════════════════════════════╣${RESET}"

    local found=0
    for script in "$SCRIPT_DIR"/*.sh; do
        if [ -f "$script" ]; then
            local name=$(basename "$script")
            local desc=$(get_description "$name")
            local name_lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')
            local desc_lower=$(echo "$desc" | tr '[:upper:]' '[:lower:]')

            if [[ "$name_lower" == *"$term_lower"* ]] || [[ "$desc_lower" == *"$term_lower"* ]]; then
                ((found++))
                local cat=$(get_category "$name")
                [ -z "$cat" ] && cat="unknown"
                echo -e "${PINK}║${RESET} ${CYAN}[$cat]${RESET} ${BOLD}$name${RESET}"
                [ -n "$desc" ] && echo -e "${PINK}║${RESET}   └─ ${DIM}$desc${RESET}"
            fi
        fi
    done

    if [ $found -eq 0 ]; then
        echo -e "${PINK}║${RESET}  ${DIM}No matches found for \"$term\"${RESET}"
    fi

    echo -e "${PINK}╠═══════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${PINK}║${RESET}  Found ${BOLD}$found${RESET} matching scripts"
    echo -e "${PINK}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

random_script() {
    # Get all scripts into array
    local scripts=()
    for s in "$SCRIPT_DIR"/*.sh; do
        [ -f "$s" ] && scripts+=("$s")
    done

    local random_script="${scripts[$RANDOM % ${#scripts[@]}]}"
    local name=$(basename "$random_script")
    local desc=$(get_description "$name")
    local cat=$(get_category "$name")

    [ -z "$desc" ] && desc="(No description yet)"
    [ -z "$cat" ] && cat="unknown"

    echo ""
    echo -e "${PINK}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${PINK}║${RESET}     ${BOLD}✨ RANDOM SCRIPT SUGGESTION ✨${RESET}                            ${PINK}║${RESET}"
    echo -e "${PINK}╠═══════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${PINK}║${RESET}                                                               ${PINK}║${RESET}"
    echo -e "${PINK}║${RESET}  ${YELLOW}Try this one:${RESET} ${BOLD}$name${RESET}"
    echo -e "${PINK}║${RESET}  ${CYAN}Category:${RESET} $cat"
    echo -e "${PINK}║${RESET}  ${GREEN}Description:${RESET}"
    echo -e "${PINK}║${RESET}    $desc"
    echo -e "${PINK}║${RESET}                                                               ${PINK}║${RESET}"
    echo -e "${PINK}║${RESET}  ${DIM}Run it with:${RESET}"
    echo -e "${PINK}║${RESET}    ${CYAN}bash chaos-drawer/$name${RESET}"
    echo -e "${PINK}║${RESET}                                                               ${PINK}║${RESET}"
    echo -e "${PINK}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

script_info() {
    local target="$1"

    # Remove path if given full path
    target=$(basename "$target")

    # Add .sh if not present
    [[ "$target" != *.sh ]] && target="$target.sh"

    local full_path="$SCRIPT_DIR/$target"

    if [ ! -f "$full_path" ]; then
        echo -e "${RED}Script not found: $target${RESET}"
        return 1
    fi

    local desc=$(get_description "$target")
    local cat=$(get_category "$target")
    local size=$(wc -c < "$full_path" | tr -d ' ')
    local lines=$(wc -l < "$full_path" | tr -d ' ')
    local modified=$(stat -f "%Sm" -t "%Y-%m-%d" "$full_path" 2>/dev/null || stat -c "%y" "$full_path" 2>/dev/null | cut -d' ' -f1)

    [ -z "$desc" ] && desc="(No description yet)"
    [ -z "$cat" ] && cat="unknown"

    echo ""
    echo -e "${PINK}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${PINK}║${RESET}     ${BOLD}SCRIPT INFO: $target${RESET}"
    echo -e "${PINK}╠═══════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${PINK}║${RESET}  ${CYAN}Category:${RESET}    $cat"
    echo -e "${PINK}║${RESET}  ${CYAN}Size:${RESET}        $size bytes"
    echo -e "${PINK}║${RESET}  ${CYAN}Lines:${RESET}       $lines"
    echo -e "${PINK}║${RESET}  ${CYAN}Modified:${RESET}    $modified"
    echo -e "${PINK}║${RESET}"
    echo -e "${PINK}║${RESET}  ${GREEN}Description:${RESET}"
    echo -e "${PINK}║${RESET}    $desc"
    echo -e "${PINK}║${RESET}"
    echo -e "${PINK}║${RESET}  ${YELLOW}Run with:${RESET}"
    echo -e "${PINK}║${RESET}    bash chaos-drawer/$target"
    echo -e "${PINK}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

show_undocumented() {
    echo ""
    echo -e "${PINK}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${PINK}║${RESET}     ${BOLD}UNDOCUMENTED SCRIPTS${RESET}                                      ${PINK}║${RESET}"
    echo -e "${PINK}║${RESET}     ${DIM}(Scripts without descriptions yet)${RESET}                        ${PINK}║${RESET}"
    echo -e "${PINK}╠═══════════════════════════════════════════════════════════════╣${RESET}"

    local undoc_count=0
    for script in "$SCRIPT_DIR"/*.sh; do
        if [ -f "$script" ]; then
            local name=$(basename "$script")
            local desc=$(get_description "$name")
            if [ -z "$desc" ]; then
                ((undoc_count++))
                echo -e "${PINK}║${RESET}  ${RED}?${RESET} $name"
            fi
        fi
    done

    if [ $undoc_count -eq 0 ]; then
        echo -e "${PINK}║${RESET}  ${GREEN}All scripts are documented! Nice work past-me~${RESET}"
    fi

    echo -e "${PINK}╠═══════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${PINK}║${RESET}  ${BOLD}$undoc_count${RESET} scripts need documentation"
    echo -e "${PINK}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════

case "${1:-list}" in
    help|--help|-h)
        show_help
        ;;
    list)
        list_all
        ;;
    count)
        count_categories
        ;;
    category|cat)
        if [ -z "$2" ]; then
            echo -e "${RED}Usage: $0 category <category_name>${RESET}"
            echo "Categories: utility, mood, gerald, sensei, celebration, game, meta, art, daily, special, generated"
            exit 1
        fi
        show_category "$2"
        ;;
    search)
        if [ -z "$2" ]; then
            echo -e "${RED}Usage: $0 search <term>${RESET}"
            exit 1
        fi
        search_scripts "$2"
        ;;
    random)
        random_script
        ;;
    info)
        if [ -z "$2" ]; then
            echo -e "${RED}Usage: $0 info <script_name>${RESET}"
            exit 1
        fi
        script_info "$2"
        ;;
    undocumented|undoc)
        show_undocumented
        ;;
    *)
        echo -e "${RED}Unknown command: $1${RESET}"
        echo "Try: $0 --help"
        exit 1
        ;;
esac
