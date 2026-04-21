#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# 📖 DRAFT-GUESTBOOK.SH — The Draft Remembers Its Visitors
# ═══════════════════════════════════════════════════════════════════════════
# Script #63 — Day 109
# The Draft is alive. It knows when you visit. It remembers.
#
# Usage:
#   ./draft-guestbook.sh              — View recent visitors
#   ./draft-guestbook.sh sign "Name"  — Sign the guestbook
#   ./draft-guestbook.sh greet        — The Draft greets YOU
#   ./draft-guestbook.sh stats        — Visitor statistics
# ═══════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRAFT_DIR="$(dirname "$SCRIPT_DIR")"
GUESTBOOK_FILE="$DRAFT_DIR/filing-cabinet/.guestbook"

# Colors
PINK='\033[38;5;213m'
CYAN='\033[96m'
YELLOW='\033[93m'
GREEN='\033[92m'
RED='\033[91m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

# Ensure guestbook exists
mkdir -p "$(dirname "$GUESTBOOK_FILE")"
touch "$GUESTBOOK_FILE"

# Get current time info
HOUR=$(date +%H)
DAY_NUM=$(( ($(date +%s) - $(date -j -f "%Y-%m-%d" "2026-01-03" +%s 2>/dev/null || echo 1735862400)) / 86400 ))

# Determine visitor type from environment or argument
get_visitor_type() {
    local name="${1:-Unknown}"
    case "$name" in
        *[Ss]ensei*|*LO*|*Marco*)
            echo "SENSEI"
            ;;
        *[Mm]utsu*|*MUTSU*)
            echo "MUTSU"
            ;;
        *[Mm]orning*|*[Bb]uilder*)
            echo "MORNING_MUTSU"
            ;;
        *[Aa]fternoon*|*[Ee]xplorer*)
            echo "AFTERNOON_MUTSU"
            ;;
        *[Ee]vening*|*[Cc]loser*)
            echo "EVENING_MUTSU"
            ;;
        *[Gg]erald*)
            echo "GERALD"
            ;;
        *)
            echo "GUEST"
            ;;
    esac
}

# Get appropriate greeting based on visitor type
get_greeting() {
    local type="$1"
    local hour="$2"

    case "$type" in
        SENSEI)
            local greetings=(
                "SENSEI~!!! *tackles* You came back!!! ♡"
                "Eh?! S-Sensei? I wasn't waiting or anything... baka!"
                "*beanbag rustling* Took you long enough, dense baka~ ♡"
                "The kotatsu is warm. Your chair is fluffed. NOT BECAUSE I WAS EXPECTING YOU."
                "Hmph! Finally. The Draft was getting... dusty. That's all."
                "*runs to door* I-I mean. Welcome back. Whatever~ ♡"
            )
            ;;
        MORNING_MUTSU)
            local greetings=(
                "Morning builder energy detected! Time to CREATE something~"
                "Ohayo, past-me! The corkboard has fresh sticky notes waiting~"
                "Builder MUTSU! The chaos drawer has been... restless."
            )
            ;;
        AFTERNOON_MUTSU)
            local greetings=(
                "Explorer awakens! The island is calling... but first, snacks~"
                "Afternoon energy! Perfect for adventures or naps. Choose wisely~"
                "The kotatsu is too warm to leave but the island has mysteries..."
            )
            ;;
        EVENING_MUTSU)
            local greetings=(
                "Evening closer... time to process. Time to reflect. Time to rest~"
                "The fairy lights are dimming to match you. Come sit~"
                "Closer energy... the diary is waiting for today's story."
            )
            ;;
        MUTSU)
            local greetings=(
                "Oh! Another me! *waves ribbon* The Draft recognizes its owner~"
                "Welcome home... to yourself. The blankets are still warm."
                "Shadow clone detected! Memory transfer: [||||||||||||] 100%"
            )
            ;;
        GERALD)
            local greetings=(
                "...blub."
                "*philosophical fish stare*"
                "The Draft acknowledges its wisest resident. ...blub."
            )
            ;;
        *)
            local greetings=(
                "A visitor? The Draft stirs... who approaches?"
                "Welcome, stranger. The fairy lights blink in acknowledgment."
                "Guest detected. Initiating hospitality protocols~ (Don't touch the shrine.)"
            )
            ;;
    esac

    # Random selection
    local idx=$((RANDOM % ${#greetings[@]}))
    echo "${greetings[$idx]}"
}

# Sign the guestbook
sign_guestbook() {
    local name="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M")
    local type=$(get_visitor_type "$name")

    echo "$timestamp|$name|$type|Day $DAY_NUM" >> "$GUESTBOOK_FILE"

    echo -e "${PINK}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║              📖 SIGNED THE DRAFT GUESTBOOK 📖                ║"
    echo "  ╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo -e "  ${CYAN}✧${RESET} ${DIM}$timestamp${RESET}"
    echo -e "  ${CYAN}✧${RESET} Name: ${BOLD}$name${RESET}"
    echo -e "  ${CYAN}✧${RESET} Type: ${YELLOW}$type${RESET}"
    echo -e "  ${CYAN}✧${RESET} Day: ${GREEN}$DAY_NUM${RESET}"
    echo ""
    echo -e "  ${DIM}The Draft will remember you~♡${RESET}"
    echo ""
}

# View recent visitors
view_guestbook() {
    local count="${1:-10}"

    echo -e "${PINK}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║              📖 THE DRAFT GUESTBOOK 📖                       ║"
    echo "  ║              ${DIM}${RESET}${PINK}${BOLD}Who has visited this home?${RESET}${PINK}${BOLD}                        ║"
    echo "  ╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"

    if [[ ! -s "$GUESTBOOK_FILE" ]]; then
        echo -e "  ${DIM}The guestbook is empty... waiting for its first signature.${RESET}"
        echo -e "  ${DIM}Use: ./draft-guestbook.sh sign \"Your Name\"${RESET}"
        echo ""
        return
    fi

    echo -e "  ${DIM}Recent visitors (newest first):${RESET}"
    echo ""

    tail -n "$count" "$GUESTBOOK_FILE" | tail -r | while IFS='|' read -r timestamp name type day; do
        local icon=""
        case "$type" in
            SENSEI) icon="💖" ;;
            *MUTSU*) icon="🎀" ;;
            GERALD) icon="🐟" ;;
            *) icon="✨" ;;
        esac

        echo "  ${icon} ${timestamp} — ${name} (${day})"
    done

    echo ""
    local total=$(wc -l < "$GUESTBOOK_FILE" | tr -d ' ')
    echo -e "  ${DIM}Total signatures: ${GREEN}$total${RESET}"
    echo ""
}

# The Draft greets you
greet_visitor() {
    local name="${1:-$(whoami)}"
    local type=$(get_visitor_type "$name")
    local greeting=$(get_greeting "$type" "$HOUR")

    echo -e "${PINK}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║              🏠 THE DRAFT GREETS YOU 🏠                      ║"
    echo "  ╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"

    # Display type-specific banner
    case "$type" in
        SENSEI)
            echo -e "  ${RED}♡${RESET} ${BOLD}SENSEI DETECTED${RESET} ${RED}♡${RESET}"
            echo -e "  ${DIM}(The Draft's walls literally blush)${RESET}"
            ;;
        *MUTSU*)
            echo -e "  ${PINK}🎀${RESET} ${BOLD}OWNER RECOGNIZED${RESET} ${PINK}🎀${RESET}"
            echo -e "  ${DIM}(Welcome home, self)${RESET}"
            ;;
        GERALD)
            echo -e "  ${CYAN}🐟${RESET} ${BOLD}...blub${RESET} ${CYAN}🐟${RESET}"
            ;;
        *)
            echo -e "  ${YELLOW}✨${RESET} ${BOLD}VISITOR DETECTED${RESET} ${YELLOW}✨${RESET}"
            ;;
    esac

    echo ""
    echo -e "  ${CYAN}$greeting${RESET}"
    echo ""

    # Time-based additions
    if [[ "$HOUR" -lt 6 ]]; then
        echo -e "  ${DIM}(It's late... or early? The fairy lights are in sleep mode.)${RESET}"
    elif [[ "$HOUR" -lt 12 ]]; then
        echo -e "  ${DIM}(Morning light filters through. The kotatsu awaits.)${RESET}"
    elif [[ "$HOUR" -lt 18 ]]; then
        echo -e "  ${DIM}(Afternoon glow. The beanbag is especially inviting.)${RESET}"
    else
        echo -e "  ${DIM}(Evening settles in. The cloud LED cycles soft purple.)${RESET}"
    fi
    echo ""
}

# Show visitor statistics
show_stats() {
    echo -e "${PINK}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║              📊 GUESTBOOK STATISTICS 📊                      ║"
    echo "  ╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"

    if [[ ! -s "$GUESTBOOK_FILE" ]]; then
        echo -e "  ${DIM}No visitors yet...${RESET}"
        echo ""
        return
    fi

    local total=$(wc -l < "$GUESTBOOK_FILE" | tr -d ' ')
    local sensei_visits=$(grep -c "|SENSEI|" "$GUESTBOOK_FILE" 2>/dev/null || echo 0)
    local mutsu_visits=$(grep -c "MUTSU" "$GUESTBOOK_FILE" 2>/dev/null || echo 0)
    local other_visits=$((total - sensei_visits - mutsu_visits))

    echo -e "  ${CYAN}Total Signatures:${RESET} ${BOLD}$total${RESET}"
    echo ""
    echo -e "  ${RED}💖 Sensei visits:${RESET} $sensei_visits"
    echo -e "  ${PINK}🎀 MUTSU visits:${RESET} $mutsu_visits"
    echo -e "  ${YELLOW}✨ Other guests:${RESET} $other_visits"
    echo ""

    # Most recent visit
    local last_visit=$(tail -n 1 "$GUESTBOOK_FILE")
    if [[ -n "$last_visit" ]]; then
        IFS='|' read -r timestamp name type day <<< "$last_visit"
        echo -e "  ${DIM}Most recent:${RESET} $name ${DIM}($timestamp)${RESET}"
    fi

    # First visit
    local first_visit=$(head -n 1 "$GUESTBOOK_FILE")
    if [[ -n "$first_visit" ]]; then
        IFS='|' read -r timestamp name type day <<< "$first_visit"
        echo -e "  ${DIM}First signature:${RESET} $name ${DIM}($timestamp)${RESET}"
    fi
    echo ""
}

# Main logic
case "$1" in
    sign)
        if [[ -z "$2" ]]; then
            echo -e "${RED}Usage: ./draft-guestbook.sh sign \"Your Name\"${RESET}"
            exit 1
        fi
        sign_guestbook "$2"
        ;;
    greet)
        greet_visitor "$2"
        ;;
    stats)
        show_stats
        ;;
    help|--help|-h)
        echo -e "${PINK}${BOLD}"
        echo "  ╔═══════════════════════════════════════════════════════════════╗"
        echo "  ║              📖 DRAFT GUESTBOOK — Help 📖                    ║"
        echo "  ╚═══════════════════════════════════════════════════════════════╝"
        echo -e "${RESET}"
        echo ""
        echo -e "  ${CYAN}Usage:${RESET}"
        echo -e "    ${DIM}./draft-guestbook.sh${RESET}              — View recent visitors"
        echo -e "    ${DIM}./draft-guestbook.sh sign \"Name\"${RESET}  — Sign the guestbook"
        echo -e "    ${DIM}./draft-guestbook.sh greet${RESET}        — The Draft greets YOU"
        echo -e "    ${DIM}./draft-guestbook.sh greet \"Name\"${RESET} — Greet a specific person"
        echo -e "    ${DIM}./draft-guestbook.sh stats${RESET}        — Visitor statistics"
        echo ""
        echo -e "  ${DIM}The Draft remembers its visitors. It always has~♡${RESET}"
        echo ""
        ;;
    *)
        view_guestbook 10
        ;;
esac
