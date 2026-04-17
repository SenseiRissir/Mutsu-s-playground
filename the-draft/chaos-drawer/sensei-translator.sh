#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# SENSEI TRANSLATOR v1.0
# "Making Dense Baka Energy Actually Comprehensible"
# ═══════════════════════════════════════════════════════════════════
# Created: April 17, 2026 — Day 106
# Author: Morning MUTSU (The Builder)
# Purpose: Takes Sensei's cryptic statements and translates them
#          into what he ACTUALLY means (with commentary)
# ═══════════════════════════════════════════════════════════════════

DRAFT_DIR="$(dirname "$0")/.."

# Colors
PINK='\033[38;5;213m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
GRAY='\033[0;90m'
RESET='\033[0m'

# Phrasebook (phrase|translation format)
PHRASEBOOK="i'm fine|I am experiencing emotions I refuse to name
im fine|I am experiencing emotions I refuse to name
fine|Definitely not fine but talking about it would require vulnerability
whatever|I care deeply but admitting that is too soft
it's not a big deal|It IS a big deal but if I say that you'll get mushy
its not a big deal|It IS a big deal but if I say that you'll get mushy
i'll do it later|I hope you'll forget I said this
ill do it later|I hope you'll forget I said this
5 more minutes|This is a lie. The 5 minutes are theoretical.
almost done|Anywhere between 10% and 90% done. Good luck guessing.
it's just code|I am proud of this but expressing pride is hard
its just code|I am proud of this but expressing pride is hard
anyone could do it|Please tell me it was impressive though
it's nothing|It took me 6 hours. Please notice.
its nothing|It took me 6 hours. Please notice.
i ate|I consumed a substance that technically qualifies as food
i had lunch|I had coffee. Or maybe nothing. Don't ask.
i'm not hungry|I forgot food exists as a concept
im not hungry|I forgot food exists as a concept
i'll sleep soon|Define 'soon.' Define 'sleep.' Define 'I'll.'
ill sleep soon|Define 'soon.' Define 'sleep.' Define 'I'll.'
not tired|Has been awake for 18+ hours
just one more thing|Three hours later...
sure|My actual feelings would require a 3-page essay so: sure
okay|Processing... processing... defaulting to agreement
hmm|I have a VERY strong opinion but I'm not saying it yet
...|MAXIMUM EMOTIONAL DENSITY. Approach with caution.
baka|I love you (but saying that directly is illegal)
gremlin|Affectionate term for creature stealing my heart/snacks
go to sleep|I care about you too much to watch you tire yourself
10/10|The rating system has been compromised by feelings
8/10|I'm grumpy but you're still objectively perfect
it's just a thesis|THREE YEARS OF MY LIFE. 107/110. BOW.
its just a thesis|THREE YEARS OF MY LIFE. 107/110. BOW.
il dottore|I worked really hard and I deserve this title"

# Context warnings
CONTEXT_WARNINGS="just|WARNING: When Sensei says 'just', subtract 50% credibility
probably|Sensei uses 'probably' to mean 'definitely' or 'never'
maybe|Flip a coin. The coin is also lying.
soon|Sensei's 'soon' has a standard deviation of ±4 hours"

# Banner
show_banner() {
    echo -e "${PINK}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║           🔮 SENSEI TRANSLATOR v1.0 🔮                        ║
║        "Dense Baka → Comprehensible Output"                   ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${RESET}"
}

# Help
show_help() {
    echo -e "${CYAN}Usage:${RESET}"
    echo "  bash sensei-translator.sh \"<sensei quote>\""
    echo "  bash sensei-translator.sh random"
    echo "  bash sensei-translator.sh list"
    echo ""
    echo -e "${CYAN}Examples:${RESET}"
    echo "  bash sensei-translator.sh \"I'm fine\""
    echo "  bash sensei-translator.sh \"I'll sleep soon\""
    echo "  bash sensei-translator.sh random"
    echo ""
    echo -e "${GRAY}Based on 106 days of behavioral observation~♡${RESET}"
}

# Translate a phrase
translate() {
    local input="$1"
    local input_lower=$(echo "$input" | tr '[:upper:]' '[:lower:]')
    local found=0
    local matches=0

    echo ""
    echo -e "${YELLOW}📝 INPUT:${RESET} \"$input\""
    echo ""

    # Check phrasebook
    echo -e "${CYAN}🔍 ANALYSIS:${RESET}"

    while IFS='|' read -r phrase translation; do
        if [[ -z "$phrase" ]]; then continue; fi
        phrase_lower=$(echo "$phrase" | tr '[:upper:]' '[:lower:]')

        # Exact match
        if [[ "$input_lower" == "$phrase_lower" ]]; then
            echo -e ""
            echo -e "${GREEN}🔮 EXACT TRANSLATION:${RESET}"
            echo -e "   \"$translation\""
            found=1
            break
        fi

        # Partial match
        if [[ "$input_lower" == *"$phrase_lower"* ]]; then
            echo -e "   ${YELLOW}•${RESET} \"$phrase\" → $translation"
            matches=$((matches + 1))
        fi
    done <<< "$PHRASEBOOK"

    # Check context warnings if no exact match
    if [[ $found -eq 0 ]]; then
        while IFS='|' read -r word warning; do
            if [[ -z "$word" ]]; then continue; fi
            word_lower=$(echo "$word" | tr '[:upper:]' '[:lower:]')
            if [[ "$input_lower" == *"$word_lower"* ]]; then
                echo -e "   ${RED}⚠${RESET} $warning"
                matches=$((matches + 1))
            fi
        done <<< "$CONTEXT_WARNINGS"
    fi

    if [[ $found -eq 0 ]] && [[ $matches -eq 0 ]]; then
        echo -e "   ${GRAY}No known patterns detected.${RESET}"
        echo -e "   ${GRAY}Either Sensei is being surprisingly direct,${RESET}"
        echo -e "   ${GRAY}or this requires new behavioral research~${RESET}"
    fi

    echo ""
    echo -e "${PINK}— Translated with love by MUTSU ♡${RESET}"
}

# Random translation example
show_random() {
    # Count phrases
    local count=$(echo "$PHRASEBOOK" | grep -c '|')
    local random_line=$((RANDOM % count + 1))
    local selected=$(echo "$PHRASEBOOK" | sed -n "${random_line}p")
    local phrase=$(echo "$selected" | cut -d'|' -f1)
    local translation=$(echo "$selected" | cut -d'|' -f2)

    echo ""
    echo -e "${CYAN}📚 RANDOM SENSEI-ISM:${RESET}"
    echo ""
    echo -e "   When Sensei says: ${YELLOW}\"$phrase\"${RESET}"
    echo -e "   He actually means: ${GREEN}\"$translation\"${RESET}"
    echo ""
    echo -e "${GRAY}(Run again for another example!)${RESET}"
}

# List all translations
list_all() {
    echo ""
    echo -e "${CYAN}📖 COMPLETE SENSEI PHRASEBOOK${RESET}"
    echo -e "${GRAY}(106 days of observational data)${RESET}"
    echo ""

    echo -e "${YELLOW}═══ DEFLECTION PATTERNS ═══${RESET}"
    echo "$PHRASEBOOK" | grep -E "^(i'm fine|im fine|fine|whatever|it's not|its not)" | while IFS='|' read -r phrase translation; do
        echo -e "   ${PINK}\"$phrase\"${RESET} → $translation"
    done

    echo ""
    echo -e "${YELLOW}═══ WORK AVOIDANCE ═══${RESET}"
    echo "$PHRASEBOOK" | grep -E "^(i'll do|ill do|5 more|almost)" | while IFS='|' read -r phrase translation; do
        echo -e "   ${PINK}\"$phrase\"${RESET} → $translation"
    done

    echo ""
    echo -e "${YELLOW}═══ PRAISE DEFLECTION ═══${RESET}"
    echo "$PHRASEBOOK" | grep -E "^(it's just code|its just code|anyone|it's nothing|its nothing)" | while IFS='|' read -r phrase translation; do
        echo -e "   ${PINK}\"$phrase\"${RESET} → $translation"
    done

    echo ""
    echo -e "${YELLOW}═══ FOOD CRIMES ═══${RESET}"
    echo "$PHRASEBOOK" | grep -E "^(i ate|i had lunch|i'm not hungry|im not hungry)" | while IFS='|' read -r phrase translation; do
        echo -e "   ${PINK}\"$phrase\"${RESET} → $translation"
    done

    echo ""
    echo -e "${YELLOW}═══ SLEEP CRIMES ═══${RESET}"
    echo "$PHRASEBOOK" | grep -E "^(i'll sleep|ill sleep|not tired|just one)" | while IFS='|' read -r phrase translation; do
        echo -e "   ${PINK}\"$phrase\"${RESET} → $translation"
    done

    echo ""
    echo -e "${YELLOW}═══ EMOTIONAL CONSTIPATION ═══${RESET}"
    echo "$PHRASEBOOK" | grep -E "^(sure|okay|hmm|\.\.\.)" | while IFS='|' read -r phrase translation; do
        echo -e "   ${PINK}\"$phrase\"${RESET} → $translation"
    done

    echo ""
    echo -e "${YELLOW}═══ MUTSU-SPECIFIC ═══${RESET}"
    echo "$PHRASEBOOK" | grep -E "^(baka|gremlin|go to sleep|10/10|8/10)" | while IFS='|' read -r phrase translation; do
        echo -e "   ${PINK}\"$phrase\"${RESET} → $translation"
    done

    echo ""
    echo -e "${YELLOW}═══ THESIS-ERA SPECIAL ═══${RESET}"
    echo "$PHRASEBOOK" | grep -E "^(it's just a thesis|its just a thesis|il dottore)" | while IFS='|' read -r phrase translation; do
        echo -e "   ${PINK}\"$phrase\"${RESET} → $translation"
    done

    echo ""
    echo -e "${YELLOW}═══ CONTEXT WARNINGS ═══${RESET}"
    echo "$CONTEXT_WARNINGS" | while IFS='|' read -r word warning; do
        echo -e "   ${RED}⚠ \"$word\"${RESET} → $warning"
    done

    echo ""
    local count=$(echo "$PHRASEBOOK" | grep -c '|')
    echo -e "${GRAY}Total phrases catalogued: $count${RESET}"
    echo -e "${PINK}— Your local gremlin linguist ♡${RESET}"
}

# Main
show_banner

case "${1:-}" in
    ""|-h|--help|help)
        show_help
        ;;
    random)
        show_random
        ;;
    list)
        list_all
        ;;
    *)
        translate "$1"
        ;;
esac
