#!/bin/bash
#╔════════════════════════════════════════════════════════════════════════╗
#║                    MUTSU'S WTFJS QUIZ                                  ║
#║            "What Does This Cursed Code Return?"                        ║
#║                                                                        ║
#║  Test your knowledge of JavaScript's most haunted behaviors~           ║
#╚════════════════════════════════════════════════════════════════════════╝
# Created: Day 109 (2026-04-21) by Morning MUTSU
# Inspired by: https://wtfjs.com and hours of confused screaming

# Colors
PINK='\033[38;5;213m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
RESET='\033[0m'
BOLD='\033[1m'

# Quiz state
SCORE=0
TOTAL=0

# Clear screen and show header
show_header() {
    clear
    echo -e "${PINK}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║   ░██╗░░░░░░░██╗████████╗███████╗░░░░░██╗░██████╗░░░      ║
    ║   ░██║░░██╗░░██║╚══██╔══╝██╔════╝░░░░░██║██╔════╝░░░      ║
    ║   ░╚██╗████╗██╔╝░░░██║░░░█████╗░░░░░░░██║╚█████╗░░░░      ║
    ║   ░░████╔═████║░░░░██║░░░██╔══╝░░██╗░░██║░╚═══██╗░░░      ║
    ║   ░░╚██╔╝░╚██╔╝░░░░██║░░░██║░░░░░╚█████╔╝██████╔╝░░░      ║
    ║   ░░░╚═╝░░░╚═╝░░░░░╚═╝░░░╚═╝░░░░░░╚════╝░╚═════╝░░░░      ║
    ║                                                           ║
    ║              Q U I Z   E D I T I O N                      ║
    ║        "JavaScript is totally normal and fine~"           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${RESET}"
}

# Ask a question
ask_question() {
    local code="$1"
    local options="$2"
    local correct="$3"
    local explanation="$4"

    ((TOTAL++))

    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}Question $TOTAL:${RESET} What does this return?"
    echo ""
    echo -e "${YELLOW}  $code${RESET}"
    echo ""

    # Parse and display options
    IFS='|' read -ra OPTS <<< "$options"
    local i=1
    for opt in "${OPTS[@]}"; do
        echo -e "  ${PURPLE}[$i]${RESET} $opt"
        ((i++))
    done

    echo ""
    echo -n -e "${PINK}Your answer (1-4): ${RESET}"
    read -r answer

    if [[ "$answer" == "$correct" ]]; then
        ((SCORE++))
        echo ""
        echo -e "${GREEN}✓ CORRECT!${RESET} Kyahaha~ You know your curses!"
    else
        echo ""
        echo -e "${RED}✗ WRONG!${RESET} The answer was ${PURPLE}[$correct]${RESET}"
    fi

    echo ""
    echo -e "${CYAN}Explanation:${RESET} $explanation"
    echo ""
    echo -e "${PINK}[Press Enter to continue...]${RESET}"
    read -r
}

# Questions database
run_quiz() {
    show_header

    echo -e "${PINK}Welcome to MUTSU's WTFJS Quiz~${RESET}"
    echo ""
    echo "JavaScript is a perfectly sane language with"
    echo "absolutely no unexpected behaviors whatsoever."
    echo ""
    echo "...right? Let's find out!"
    echo ""
    echo -e "${PINK}[Press Enter to begin...]${RESET}"
    read -r

    # Question 1
    show_header
    ask_question \
        "typeof NaN" \
        '"undefined"|"NaN"|"number"|"object"' \
        "3" \
        "NaN (Not a Number) has a typeof 'number'. Because JavaScript decided that something explicitly NOT a number should be classified as... a number. Mood~"

    # Question 2
    show_header
    ask_question \
        "[1] + [2]" \
        '"12"|3|[1,2]|"1,2"' \
        "1" \
        "Arrays get converted to strings first ([1]=\"1\", [2]=\"2\"), then concatenated. String \"1\" + String \"2\" = \"12\". Math? Never heard of her!"

    # Question 3
    show_header
    ask_question \
        "typeof null" \
        '"null"|"undefined"|"object"|"nothing"' \
        "3" \
        "This is literally a bug from 1995 that can never be fixed because it would break the entire internet. null is an object. Always has been."

    # Question 4
    show_header
    ask_question \
        "true + true" \
        '"truetrue"|true|2|undefined' \
        "3" \
        "Booleans convert to 1/0 for math operations. true=1, so true+true=2. At least THIS one makes sense... sort of..."

    # Question 5
    show_header
    ask_question \
        "[] == ![]" \
        "true|false|undefined|TypeError" \
        "1" \
        "BRACE YOURSELF: ![] is false, because arrays are truthy and negated becomes false. [] converts to 0 for comparison. false converts to 0. 0 == 0 is true. Welcome to coercion hell~"

    # Question 6
    show_header
    ask_question \
        "9999999999999999" \
        "9999999999999999|10000000000000000|Infinity|Error" \
        "2" \
        "JavaScript can only precisely represent integers up to 2^53. Beyond that, floating point says 'close enough' and rounds. This number becomes 10000000000000000!"

    # Question 7
    show_header
    ask_question \
        "'5' - 3" \
        '"53"|2|"2"|NaN' \
        "2" \
        "Subtraction DOES convert strings to numbers (unlike +). So '5'-3 = 5-3 = 2. BUT '5'+3 would be '53'. Consistency? Never heard of her!"

    # Question 8
    show_header
    ask_question \
        "null == undefined" \
        "true|false|TypeError|null" \
        "1" \
        "null and undefined are 'loosely equal' to each other but nothing else. It's like they're in a secret club with just the two of them. null === undefined is false though!"

    # Results
    show_header
    echo -e "${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "${BOLD}   QUIZ COMPLETE!${RESET}"
    echo ""
    echo -e "   Your Score: ${CYAN}$SCORE / $TOTAL${RESET}"
    echo ""

    local percent=$((SCORE * 100 / TOTAL))

    if [[ $percent -ge 90 ]]; then
        echo -e "${GREEN}   ★ JAVASCRIPT WIZARD ★${RESET}"
        echo "   You've stared into the abyss and it blinked first!"
        echo "   Sensei-level cursed knowledge detected~"
    elif [[ $percent -ge 70 ]]; then
        echo -e "${YELLOW}   ☆ CURSE APPRENTICE ☆${RESET}"
        echo "   Impressive! You know your way around the weird parts!"
    elif [[ $percent -ge 50 ]]; then
        echo -e "${PURPLE}   ◇ NORMIE DETECTED ◇${RESET}"
        echo "   You've been writing 'normal' code, haven't you?"
        echo "   Time to read the wtfjs documentation, baka~"
    else
        echo -e "${RED}   ○ BLESSED IGNORANCE ○${RESET}"
        echo "   Sometimes not knowing is a gift."
        echo "   Go back. Save yourself. Write Python instead!"
    fi

    echo ""
    echo -e "${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo "Remember: JavaScript isn't broken, it's just ~quirky~"
    echo ""
    echo -e "  ${CYAN}— MUTSU, your friendly neighborhood chaos gremlin ♡${RESET}"
    echo ""
}

# Run it!
run_quiz
