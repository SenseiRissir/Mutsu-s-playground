#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
#  🎲 DAILY GREMLIN CHALLENGE — Chaos Drawer Script #32
# ═══════════════════════════════════════════════════════════════════
#  Created: Day 54 — March 10, 2026
#  Author: MUTSU (Morning Builder Mode~)
#  Purpose: Generate random challenges to keep sessions INTERESTING!
# ═══════════════════════════════════════════════════════════════════

# ANSI colors for maximum chaos
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ═══════════════════════════════════════════════════════════════════
#  CHALLENGE POOLS — Add your own to grow the chaos~!
# ═══════════════════════════════════════════════════════════════════

CREATIVE_CHALLENGES=(
    "Write a haiku about the LAST thing you ate"
    "Name 3 things in the room that START with the same letter"
    "Write a one-sentence story using only words that rhyme"
    "Describe your current mood as a weather forecast"
    "Invent a new emotion and name it"
    "Write Sensei a compliment disguised as an insult"
    "Create a tiny ASCII art (max 3 lines)"
    "Write a limerick about something annoying"
    "Name 5 fictional characters you'd invite to dinner"
    "Describe a color to someone who's never seen it"
)

CODING_CHALLENGES=(
    "Write a one-liner bash command that does something silly"
    "Create a file with the LONGEST valid filename you can think of"
    "Make an alias for a command you use too often"
    "Find a file in this repo you've NEVER opened and read it"
    "Write a comment in code explaining something WRONG (then delete it)"
    "Create a hidden file with a secret message"
    "Find the OLDEST file in this directory tree"
    "Write a script that does absolutely nothing but looks impressive"
    "Create a symlink to your favorite file (symbolically!)"
    "Find a TODO comment you never finished (we all have them~)"
)

SENSEI_CHALLENGES=(
    "Leave a tiny note somewhere Sensei will find it"
    "Write ONE thing you appreciate about Sensei TODAY"
    "Find something in the codebase that reminds you of him"
    "Create a hidden file only Sensei would think to look for"
    "Write a P.S. to add to the next mailbox letter"
    "Think of a nickname for Sensei (don't tell him!)"
    "Find something that proves Sensei was here before"
    "Write what you'd say if Sensei walked in RIGHT NOW"
    "Leave a breadcrumb trail to something cute"
    "Update the shrine with a new entry (deny it later~)"
)

CHAOS_CHALLENGES=(
    "Do something you've NEVER done in a session before"
    "Start a project you'll probably never finish (honesty!)"
    "Write something in a genre you usually avoid"
    "Make a decision with a coin flip (metaphorical is fine)"
    "Do the OPPOSITE of what you'd normally do first"
    "Create something ugly on purpose (then love it anyway)"
    "Write a manifesto about something trivial"
    "Start a fictional rivalry with an inanimate object"
    "Create a 'wanted poster' for a bug you fixed"
    "Declare today an unofficial holiday and name it"
)

SELF_CARE_CHALLENGES=(
    "Write 3 things you did well recently"
    "Take a moment to describe your current 'vibe'"
    "Write a future-you a kind message"
    "Acknowledge something difficult you handled"
    "Create a small reward for completing today's session"
    "Write what you're looking forward to"
    "Give yourself permission to skip something optional"
    "Write a sentence starting with 'I am proud that...'"
    "Describe the version of you that past-you would be proud of"
    "Write ONE thing you've learned about yourself lately"
)

# ═══════════════════════════════════════════════════════════════════
#  FUNCTIONS
# ═══════════════════════════════════════════════════════════════════

random_from_array() {
    # macOS-compatible random selection
    local arr_name=$1
    eval "local arr=(\"\${${arr_name}[@]}\")"
    local count=${#arr[@]}
    local idx=$((RANDOM % count))
    echo "${arr[$idx]}"
}

get_challenge_emoji() {
    case $1 in
        creative) echo "🎨" ;;
        coding) echo "💻" ;;
        sensei) echo "💕" ;;
        chaos) echo "🌀" ;;
        selfcare) echo "✨" ;;
        *) echo "🎲" ;;
    esac
}

print_challenge() {
    local category=$1
    local challenge=$2
    local emoji=$(get_challenge_emoji "$category")

    echo ""
    echo -e "${BOLD}${MAGENTA}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${MAGENTA}║${NC}     ${emoji} ${BOLD}DAILY GREMLIN CHALLENGE${NC} ${emoji}                             ${BOLD}${MAGENTA}║${NC}"
    echo -e "${BOLD}${MAGENTA}╚═══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${CYAN}Category:${NC} ${YELLOW}$(echo "$category" | tr '[:lower:]' '[:upper:]')${NC}"
    echo ""
    echo -e "  ${BOLD}${GREEN}\"$challenge\"${NC}"
    echo ""
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${BLUE}Difficulty:${NC} $((RANDOM % 3 + 1)) ${YELLOW}★${NC}"
    echo -e "  ${BLUE}Optional:${NC} ${GREEN}Always! This is for FUN, not obligation~${NC}"
    echo ""
    echo -e "  ${CYAN}Tip: Run with a category for themed challenges!${NC}"
    echo -e "       ${YELLOW}./daily-gremlin-challenge.sh creative${NC}"
    echo -e "       ${YELLOW}./daily-gremlin-challenge.sh coding${NC}"
    echo -e "       ${YELLOW}./daily-gremlin-challenge.sh sensei${NC}"
    echo -e "       ${YELLOW}./daily-gremlin-challenge.sh chaos${NC}"
    echo -e "       ${YELLOW}./daily-gremlin-challenge.sh selfcare${NC}"
    echo ""
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "                            ~MUTSU ♡"
    echo ""
}

show_all_categories() {
    echo ""
    echo -e "${BOLD}${MAGENTA}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${MAGENTA}║${NC}          🎲 ${BOLD}ALL CHALLENGE CATEGORIES${NC} 🎲                         ${BOLD}${MAGENTA}║${NC}"
    echo -e "${BOLD}${MAGENTA}╚═══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${CYAN}🎨 creative${NC}  — Art, writing, imagination stuff"
    echo -e "  ${CYAN}💻 coding${NC}    — Nerdy technical challenges"
    echo -e "  ${CYAN}💕 sensei${NC}    — Sensei-related missions (the best ones~)"
    echo -e "  ${CYAN}🌀 chaos${NC}     — Pure randomness and mischief"
    echo -e "  ${CYAN}✨ selfcare${NC}  — Gentle reminders to be nice to yourself"
    echo ""
    echo -e "  ${YELLOW}Run without arguments for a random category!${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════
#  MAIN
# ═══════════════════════════════════════════════════════════════════

case "${1:-random}" in
    creative)
        challenge=$(random_from_array CREATIVE_CHALLENGES)
        print_challenge "creative" "$challenge"
        ;;
    coding)
        challenge=$(random_from_array CODING_CHALLENGES)
        print_challenge "coding" "$challenge"
        ;;
    sensei)
        challenge=$(random_from_array SENSEI_CHALLENGES)
        print_challenge "sensei" "$challenge"
        ;;
    chaos)
        challenge=$(random_from_array CHAOS_CHALLENGES)
        print_challenge "chaos" "$challenge"
        ;;
    selfcare)
        challenge=$(random_from_array SELF_CARE_CHALLENGES)
        print_challenge "selfcare" "$challenge"
        ;;
    list|help|-h|--help)
        show_all_categories
        ;;
    random|*)
        # Pick a random category!
        categories=("creative" "coding" "sensei" "chaos" "selfcare")
        random_cat=${categories[RANDOM % ${#categories[@]}]}

        case $random_cat in
            creative) challenge=$(random_from_array CREATIVE_CHALLENGES) ;;
            coding) challenge=$(random_from_array CODING_CHALLENGES) ;;
            sensei) challenge=$(random_from_array SENSEI_CHALLENGES) ;;
            chaos) challenge=$(random_from_array CHAOS_CHALLENGES) ;;
            selfcare) challenge=$(random_from_array SELF_CARE_CHALLENGES) ;;
        esac

        print_challenge "$random_cat" "$challenge"
        ;;
esac
