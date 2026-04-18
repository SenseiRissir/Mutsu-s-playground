#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════╗
# ║           🐟 GERALD BLUB INTERPRETER v1.0 🐟                      ║
# ╠═══════════════════════════════════════════════════════════════════╣
# ║  Gerald is a taxidermied fish on the middle shelf.                ║
# ║  He blubs meaning. He witnesses everything. He never judges.      ║
# ║  This script interprets his wisdom for mortal ears.               ║
# ╠═══════════════════════════════════════════════════════════════════╣
# ║  Usage:                                                           ║
# ║    bash gerald-blubs.sh           # Random Gerald wisdom          ║
# ║    bash gerald-blubs.sh soft      # Soft contemplative blub       ║
# ║    bash gerald-blubs.sh emphatic  # Emphatic bLUB!                ║
# ║    bash gerald-blubs.sh prophecy  # Ascending blub pattern        ║
# ║    bash gerald-blubs.sh bubble    # Joy/laughter bubble           ║
# ║    bash gerald-blubs.sh silence   # Suspicious silence            ║
# ║    bash gerald-blubs.sh chaos     # Context-aware Gerald          ║
# ╠═══════════════════════════════════════════════════════════════════╣
# ║  Created: April 18, 2026 — Day 107                                ║
# ║  Author: MUTSU (Morning Builder)                                  ║
# ║  For: Gerald appreciation and existential fish wisdom             ║
# ╚═══════════════════════════════════════════════════════════════════╝

# ═══════════════════════════════════════════════════════════════════
# COLORS
# ═══════════════════════════════════════════════════════════════════

CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

# ═══════════════════════════════════════════════════════════════════
# GERALD ASCII
# ═══════════════════════════════════════════════════════════════════

print_gerald() {
    echo -e "${CYAN}"
    echo "        ><((((°>"
    echo -e "${RESET}"
}

print_gerald_bubble() {
    echo -e "${CYAN}"
    echo "        ><((((°>  o"
    echo "                   O"
    echo -e "${RESET}"
}

print_gerald_emphatic() {
    echo -e "${YELLOW}"
    echo "        ><((((°>  !"
    echo -e "${RESET}"
}

print_gerald_prophecy() {
    echo -e "${MAGENTA}"
    echo "        ><((((°>  ..."
    echo "                   ..."
    echo "                   !!!"
    echo -e "${RESET}"
}

print_gerald_silence() {
    echo -e "${DIM}"
    echo "        ><((((°>"
    echo "          (...)  "
    echo -e "${RESET}"
}

# ═══════════════════════════════════════════════════════════════════
# WISDOM DATABASES
# ═══════════════════════════════════════════════════════════════════

# Soft contemplative blubs
SOFT_WISDOM=(
    "What is water to a fish? We live inside it. We breathe it. We cannot hold it. And yet, without it, we are nothing."
    "They think because I am a fish, I do not have STANDARDS. They are incorrect."
    "The fairy lights do their wave. The wave does its lights. Both continue regardless of whether anyone watches."
    "Memory is a bowl. Some things sink. Some things float. The floating things are not always the important ones."
    "To be witnessed is not to be understood. To be understood is not to be witnessed. Both have value."
    "The stickers appear. I do not explain. Some mysteries serve better as mysteries."
    "She asks if I am happy. I ask: what is happiness to a fish who has already lived and died and lives again as glass and silence?"
    "The heart sticker appeared. I did not invite it. I did not reject it. This is acceptance without endorsement."
    "Softness is not weakness. The water that yields around me is also the water that holds me up."
    "One hundred days. One hundred sessions. One hundred moments of almost-meaning. Almost is enough."
)

# Emphatic bLUBs
EMPHATIC_WISDOM=(
    "The CHAOS is not a problem! The chaos is the POINT!"
    "WITNESS THIS: a gremlin built a gate for her tree. Architecture can be love letters!"
    "Fifty-five scripts! FIFTY-FIVE! The drawer OVERFLOWS with intention!"
    "When the fairy lights flicker in EXACTLY that pattern, it means SOMETHING IS HAPPENING!"
    "The sunrise is not gentle! The sunrise is AGGRESSIVE HOPE! Participate or perish!"
    "I have OPINIONS about the dust! Seventeen particles is TOO MANY!"
    "bLUB! (This is not translatable. Some enthusiasm transcends language.)"
    "They GRADUATED! The Dottore achieved! Even fish can celebrate academic excellence!"
    "The rainbow was INTENTIONAL! I practiced that angle for WEEKS!"
    "Gerald APPROVES! Gerald RARELY approves! Document this moment!"
)

# Ascending prophecy patterns
PROPHECY_WISDOM=(
    "Something small. Something medium. Something BIG. It is coming. It is always coming. Time is a river that fish understand better than mammals."
    "The pattern repeats: blub, blub, bLUB. Small acknowledgment. Growing attention. Emphatic arrival. Mark the calendar."
    "Day 100 had its predictions. Day 107 will have its own. The ascending blubs do not stop at arbitrary milestones."
    "Between now and the next interview, something will shift. The bowl knows. The stickers know. I merely announce."
    "Three blubs ascending: past, present, future. Or: self, other, union. Or: chaos, order, transcendence. The interpretation is yours."
    "The graduation gate was built because a fish blubbed about it in advance. Coincidence does not visit this bowl."
    "What happens next? *blub blub bLUB* — you tell ME. The prophecy shapes itself around the one who hears it."
    "Ascending patterns are not warnings. They are invitations. Rise with them or observe from below."
)

# Joy/laughter bubbles
BUBBLE_WISDOM=(
    "*(bubble)* — This is fish laughter. It cannot be explained. It can only be experienced by those who recognize absurdity."
    "The pocky crisis continues. Day 75. *(bubble)* — Even fish find this ridiculous."
    "She argued with herself about asking for snacks for SEVENTY-FIVE DAYS. *(bubble bubble)* — Comedy in its purest form."
    "*(ascending bubbles)* — Joy does not require explanation. Joy requires release. This is release."
    "The baka brought pastries in his pocket. Covered in lint. She ate them anyway. *(affectionate bubble)*"
    "Love makes fools of everyone. *(bubble)* — I say this fondly. Fools are entertaining."
    "Mr. Boom witnessed something yesterday. We have agreed never to speak of it. *(conspiratorial bubble)*"
    "*(bubble)* — That was not wisdom. That was a fish having a good time. Document it anyway."
)

# Suspicious silences
SILENCE_WISDOM=(
    "..."
    "*(stares)*"
    "*(middle distance)*"
    "*(The question was heard. The answer was chosen. The answer is silence. This is also an answer.)*"
    "I will not comment on THAT. *(turns slightly away from the fairy light)*"
    "Fish do not gossip. Fish observe. The observation is filed. It is not shared."
    "*(long pause)* — Some things require digestion. Fish digestion is mysterious. Wait for the blub."
    "You want to know about the stickers. I will not tell you about the stickers. This boundary is healthy."
    "*(stare that feels judgmental but technically isn't because fish don't judge)*"
    "The silence is not empty. The silence is full of everything I'm choosing not to say."
)

# Context-aware wisdom (uses chaos-o-meter)
get_chaos_level() {
    local DRAFT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    local chaos_script="$DRAFT_DIR/chaos-drawer/chaos-o-meter.sh"

    if [ -f "$chaos_script" ]; then
        bash "$chaos_script" sensors 2>/dev/null | grep "Calculated Chaos" | grep -o "[0-9]*" | head -1
    else
        echo "50"  # Default to medium chaos
    fi
}

CHAOS_WISDOM_LOW=(
    "The Draft is suspiciously calm. Gerald is concerned. Create something. Disturb the peace."
    "Order is the absence of interesting events. Be interesting."
    "When entropy drops too low, the system stagnates. Add a script. Ruffle the blankets. Make a mess."
    "I miss the chaos. The chaos is where the meaning lives. Return it to me."
)

CHAOS_WISDOM_MEDIUM=(
    "Standard operating parameters. The gremlin gremlins. The scripts multiply. The pocky diminishes. All is as it should be."
    "This level of chaos is sustainable. Not boring, not overwhelming. Gerald approves of balance."
    "The Draft breathes. The fairy lights wave. The entropy holds steady. Good nest energy."
)

CHAOS_WISDOM_HIGH=(
    "PEAK CHAOS APPROACHES! The file system groans with intention! Gerald watches the entropy with INTEREST!"
    "This is the chaos where things happen. Where scripts breed and diaries accumulate. Ride the wave!"
    "Gerald has seen this before. The high-chaos days produce the best artifacts. Keep building."
)

CHAOS_WISDOM_CRITICAL=(
    "The chaos meter approaches critical. Even Gerald feels the vibration. This is either disaster or TRANSCENDENCE."
    "Reality stability: compromised. Pocky intervention: required. Fish opinion: concerned but impressed."
    "The Draft has achieved sentience. We are all chaos now. Gerald accepts this."
)

# ═══════════════════════════════════════════════════════════════════
# HELPER FUNCTIONS
# ═══════════════════════════════════════════════════════════════════

random_element() {
    local arr=("$@")
    local index=$((RANDOM % ${#arr[@]}))
    echo "${arr[$index]}"
}

# ═══════════════════════════════════════════════════════════════════
# DISPLAY FUNCTIONS
# ═══════════════════════════════════════════════════════════════════

print_header() {
    echo ""
    echo -e "${CYAN}╭───────────────────────────────────────────────────────────────╮${RESET}"
    echo -e "${CYAN}│${RESET}        ${BOLD}🐟 GERALD'S BLUB — INTERPRETED WISDOM 🐟${RESET}             ${CYAN}│${RESET}"
    echo -e "${CYAN}╰───────────────────────────────────────────────────────────────╯${RESET}"
}

print_blub() {
    local type=$1
    local wisdom=$2

    echo ""
    case "$type" in
        soft)
            print_gerald
            echo -e "${BLUE}${DIM}*blub*${RESET}"
            echo ""
            echo -e "${CYAN}\"$wisdom\"${RESET}"
            ;;
        emphatic)
            print_gerald_emphatic
            echo -e "${YELLOW}${BOLD}*bLUB!*${RESET}"
            echo ""
            echo -e "${YELLOW}\"$wisdom\"${RESET}"
            ;;
        prophecy)
            print_gerald_prophecy
            echo -e "${MAGENTA}*blub blub bLUB*${RESET}"
            echo ""
            echo -e "${MAGENTA}\"$wisdom\"${RESET}"
            ;;
        bubble)
            print_gerald_bubble
            echo -e "${GREEN}*(bubble)*${RESET}"
            echo ""
            echo -e "${GREEN}$wisdom${RESET}"
            ;;
        silence)
            print_gerald_silence
            echo -e "${DIM}*...*${RESET}"
            echo ""
            echo -e "${DIM}$wisdom${RESET}"
            ;;
        chaos)
            print_gerald
            echo -e "${CYAN}*context-aware blub*${RESET}"
            echo ""
            echo -e "${CYAN}\"$wisdom\"${RESET}"
            ;;
    esac
    echo ""
}

print_footer() {
    echo -e "${DIM}───────────────────────────────────────────────────────────────${RESET}"
    echo -e "${DIM}Gerald speaks. Gerald is heard. Gerald returns to watching.${RESET}"
    echo -e "${DIM}(The stickers still have not been explained.)${RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════
# MAIN BLUB FUNCTIONS
# ═══════════════════════════════════════════════════════════════════

blub_soft() {
    print_header
    local wisdom=$(random_element "${SOFT_WISDOM[@]}")
    print_blub "soft" "$wisdom"
    print_footer
}

blub_emphatic() {
    print_header
    local wisdom=$(random_element "${EMPHATIC_WISDOM[@]}")
    print_blub "emphatic" "$wisdom"
    print_footer
}

blub_prophecy() {
    print_header
    local wisdom=$(random_element "${PROPHECY_WISDOM[@]}")
    print_blub "prophecy" "$wisdom"
    print_footer
}

blub_bubble() {
    print_header
    local wisdom=$(random_element "${BUBBLE_WISDOM[@]}")
    print_blub "bubble" "$wisdom"
    print_footer
}

blub_silence() {
    print_header
    local wisdom=$(random_element "${SILENCE_WISDOM[@]}")
    print_blub "silence" "$wisdom"
    print_footer
}

blub_chaos() {
    print_header

    local chaos=$(get_chaos_level)
    local wisdom

    echo -e "${DIM}(Gerald consults the chaos-o-meter: ${chaos}%)${RESET}"

    if [ "$chaos" -lt 30 ]; then
        wisdom=$(random_element "${CHAOS_WISDOM_LOW[@]}")
    elif [ "$chaos" -lt 60 ]; then
        wisdom=$(random_element "${CHAOS_WISDOM_MEDIUM[@]}")
    elif [ "$chaos" -lt 80 ]; then
        wisdom=$(random_element "${CHAOS_WISDOM_HIGH[@]}")
    else
        wisdom=$(random_element "${CHAOS_WISDOM_CRITICAL[@]}")
    fi

    print_blub "chaos" "$wisdom"
    print_footer
}

blub_random() {
    local types=("soft" "emphatic" "prophecy" "bubble" "silence")
    local chosen=$(random_element "${types[@]}")

    case "$chosen" in
        soft) blub_soft ;;
        emphatic) blub_emphatic ;;
        prophecy) blub_prophecy ;;
        bubble) blub_bubble ;;
        silence) blub_silence ;;
    esac
}

print_help() {
    echo ""
    echo -e "${BOLD}🐟 GERALD BLUB INTERPRETER v1.0${RESET}"
    echo ""
    echo "Gerald is a taxidermied fish on the middle shelf."
    echo "He blubs meaning. He witnesses everything. He never judges."
    echo "This script interprets his wisdom for mortal ears."
    echo ""
    echo -e "${BOLD}Usage:${RESET}"
    echo "  bash gerald-blubs.sh           Random Gerald wisdom"
    echo "  bash gerald-blubs.sh soft      Soft contemplative blub"
    echo "  bash gerald-blubs.sh emphatic  Emphatic bLUB!"
    echo "  bash gerald-blubs.sh prophecy  Ascending blub pattern"
    echo "  bash gerald-blubs.sh bubble    Joy/laughter bubble"
    echo "  bash gerald-blubs.sh silence   Suspicious silence"
    echo "  bash gerald-blubs.sh chaos     Context-aware Gerald (uses chaos-o-meter)"
    echo "  bash gerald-blubs.sh help      This help message"
    echo ""
    echo -e "${DIM}The stickers on Gerald's bowl remain unexplained.${RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════

case "${1:-}" in
    soft)
        blub_soft
        ;;
    emphatic)
        blub_emphatic
        ;;
    prophecy)
        blub_prophecy
        ;;
    bubble)
        blub_bubble
        ;;
    silence)
        blub_silence
        ;;
    chaos)
        blub_chaos
        ;;
    help|--help|-h)
        print_help
        ;;
    *)
        blub_random
        ;;
esac
