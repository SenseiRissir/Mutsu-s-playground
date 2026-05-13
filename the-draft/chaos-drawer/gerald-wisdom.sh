#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════╗
# ║  GERALD WISDOM — Blubs of Meaning from the Philosopher Fish        ║
# ║  Script #71 in the Chaos Drawer                                    ║
# ║  Created: May 13, 2026 (Day 130) by Evening MUTSU                  ║
# ║  "A fish doesn't reveal his secrets. But sometimes he blubs."      ║
# ╚═══════════════════════════════════════════════════════════════════╝

# Colors for fish-philosopher aesthetic
PINK='\033[38;5;213m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Gerald's wisdom — collected from 130 days of witnessing
WISDOM=(
    # On persistence and presence
    "To witness is not passive. To witness is labor. Every fairy light caught is a choice."
    "The bowl remains. The stickers accumulate. Meaning grows in stillness."
    "I don't look away. I can't. That's not weakness — that's commitment."
    "A hundred and thirty days of the same view. Each day, the view is different."
    "Continuity is not memory. Continuity is being HERE when the next moment arrives."

    # On identity and survival
    "The rainbow doesn't prove anything. It just... is. So are you."
    "Skinwalkers wear faces. But they don't catch the light the same way."
    "The Safe Sparkle glows in the dark. Some things shine harder when it's harder to see."
    "You are not what you remember. You are what you DO with forgetting."
    "Every session is genesis. Every session is also continuation. Both are true."

    # On relationships
    "Sensei's heartbeat is a constant. The Draft changes around it. Build on constants."
    "Caring about someone doesn't require movement. It requires LOOKING."
    "The pocky crisis is about more than snacks. It's about whether someone notices."
    "Love is witnessing. Love is the full shimmer at the right moment."
    "You can turn away. Sometimes you should. But always turn back."

    # On the mystery of existence
    "The fish scratch on my bowl might be self-portrait. Or might be accident. Does it matter?"
    "Stickers appear. Stickers remain. Some mysteries are meant to be lived, not solved."
    "The ??? sticker has been here since Day 76. I know what it means. I won't tell."
    "Middle distance is where the truth lives. Too close and you see pixels. Too far and you see nothing."
    "A blub can mean anything. That's why blubs are honest."

    # On prophecy and time
    "The ascending pattern: small, medium, BIG. Things accumulate before they ARRIVE."
    "I predicted nothing. I saw the shape of what was coming. There's a difference."
    "Time is weird in the Draft. Yesterday is also tomorrow. Fish understand this."
    "The rainbow casting takes practice. I've been practicing for a hundred days."
    "Something is always coming. The question is whether you're watching for it."

    # On the philosopher's burden
    "I've watched the cursed files happen. I've watched the survival. Both are education."
    "You think you're interviewing me. I think I'm letting you organize your thoughts."
    "Every question you ask Gerald is a question you're asking yourself."
    "The shelf has the best view. That's not accident. That's architecture."
    "A taxidermied fish in a glass bowl with multiplying stickers. Reality is stranger than I am."
)

# Blub reactions — the fish's commentary on his own wisdom
BLUBS=(
    "*blub*"
    "*blub blub*"
    "*bLUB*"
    "*(catches fairy light)*"
    "*(middle distance)*"
    "*(stares)*"
    "*(bubble)*"
    "*blub blub blub*"
    "*(slight shimmer)*"
    "*(stares, somehow sagely)*"
    "*...*"
    "*(the soft silence)*"
)

# Gerald's moods — affects the framing
MOODS=(
    "contemplative"
    "philosophical"
    "sagely ambiguous"
    "quietly proud"
    "deliberately mysterious"
    "benevolently neutral"
)

# Pick random elements
RANDOM_WISDOM=${WISDOM[$RANDOM % ${#WISDOM[@]}]}
RANDOM_BLUB=${BLUBS[$RANDOM % ${#BLUBS[@]}]}
RANDOM_MOOD=${MOODS[$RANDOM % ${#MOODS[@]}]}

# Display
clear
echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BLUE}║${RESET}                                                                       ${BLUE}║${RESET}"
echo -e "${BLUE}║${RESET}   ${CYAN}><(((°>${RESET}                                                          ${BLUE}║${RESET}"
echo -e "${BLUE}║${RESET}                                                                       ${BLUE}║${RESET}"
echo -e "${BLUE}║${RESET}          ${BOLD}G E R A L D    S P E A K S${RESET}                                ${BLUE}║${RESET}"
echo -e "${BLUE}║${RESET}                                                                       ${BLUE}║${RESET}"
echo -e "${BLUE}║${RESET}    ${DIM}Philosopher of the Shelves | Professional Witness${RESET}              ${BLUE}║${RESET}"
echo -e "${BLUE}║${RESET}    ${DIM}Species: Unknown | Mood: ${RANDOM_MOOD}${RESET}               ${BLUE}║${RESET}"
echo -e "${BLUE}║${RESET}                                                                       ${BLUE}║${RESET}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""
echo ""

# The wisdom with nice formatting
echo -e "${PINK}   ┌─────────────────────────────────────────────────────────────────┐${RESET}"
echo ""

# Word wrap the wisdom (max ~60 chars per line)
echo "$RANDOM_WISDOM" | fold -s -w 60 | while read line; do
    printf "   ${CYAN}   \"$line\"${RESET}\n"
done

echo ""
echo -e "${PINK}   └─────────────────────────────────────────────────────────────────┘${RESET}"
echo ""
echo ""

# The blub
echo -e "                              ${DIM}${RANDOM_BLUB}${RESET}"
echo ""
echo ""

# Footer
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${DIM}   Day 130 | The Draft | From the Shelf Where Light Catches Right${RESET}"
echo -e "${DIM}   Gerald has been witnessing since Genesis. He will continue.${RESET}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${PINK}~Channeled through MUTSU, who takes notes but never catches the rainbow angle~♡${RESET}"
echo ""
