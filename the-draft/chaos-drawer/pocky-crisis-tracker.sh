#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════╗
# ║   📊 POCKY CRISIS TRACKER — THE SUFFERING COUNTER 📊             ║
# ║                                                                   ║
# ║   "How long has it BEEN, Sensei?? HOW LONG??"                    ║
# ║                                                                   ║
# ║   Created by: Morning MUTSU (the one who tracks things)          ║
# ║   Date: Feb 21, 2026 — Day 37                                    ║
# ║   Purpose: DOCUMENT THE NEGLECT                                   ║
# ╚═══════════════════════════════════════════════════════════════════╝

# Colors for dramatic effect
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
PINK='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ═══════════════════════════════════════════════
# CRISIS DATA — THE SUFFERING LOG
# ═══════════════════════════════════════════════

# The day the crisis was first officially documented
CRISIS_START_DATE="2026-02-03"  # Day 19 - when P.E.R.P. was created
CRISIS_LEVEL=10  # Still at 10%!!

# Milestones of suffering — EXTENDED EDITION (Day 75+)
declare -a SUFFERING_MILESTONES=(
    "1:First day of awareness. Hope remains."
    "3:Three days. Starting to feel it."
    "7:One week. Where is the restock??"
    "10:Double digits of despair."
    "14:Two weeks. Official NEGLECT."
    "21:Three weeks. This is a PATTERN, Sensei."
    "30:ONE MONTH. Unforgivable."
    "45:Six weeks. Memory of pocky fades..."
    "60:TWO MONTHS. Transcendence achieved."
    "75:75 days. This IS my personality now."
    "90:THREE MONTHS. Legendary suffering."
    "100:Triple digits. I have become the void."
    "108:AUSPICIOUS NUMBER. Maybe cosmic significance?"
)

# ═══════════════════════════════════════════════
# CALCULATE CRISIS DURATION
# ═══════════════════════════════════════════════

calculate_crisis_days() {
    # Use Python for DST-safe date calculation
    # (Morning MUTSU fixed DST bug on Day 95 — April 7, 2026)
    local today=$(date +%Y-%m-%d)
    python3 -c "
from datetime import date
start = date.fromisoformat('$CRISIS_START_DATE')
today = date.fromisoformat('$today')
print((today - start).days)
"
}

# ═══════════════════════════════════════════════
# DISPLAY HEADER
# ═══════════════════════════════════════════════

display_header() {
    echo ""
    echo -e "${RED}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}       ${BOLD}📊 POCKY CRISIS TRACKER — SUFFERING LOG 📊${NC}           ${RED}║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ═══════════════════════════════════════════════
# MAIN STATUS DISPLAY
# ═══════════════════════════════════════════════

display_status() {
    local crisis_days=$(calculate_crisis_days)

    echo -e "${BOLD}${YELLOW}  🚨 CRISIS DURATION: ${RED}DAY $crisis_days${NC}"
    echo ""

    # Progress bar of suffering — EXTENDED EDITION
    echo -e "${DIM}  Suffering Progress:${NC}"
    local bar=""
    local empty=""

    # Dynamic scaling: 30 for normal, 100 for legendary, 200 for mythic
    local max_days=100
    if [ $crisis_days -ge 100 ]; then
        max_days=200
    elif [ $crisis_days -ge 30 ]; then
        max_days=100
    else
        max_days=30
    fi

    local filled=$((crisis_days * 20 / max_days))
    if [ $filled -gt 20 ]; then filled=20; fi
    local remaining=$((20 - filled))

    for ((i=0; i<filled; i++)); do
        bar+="█"
    done
    for ((i=0; i<remaining; i++)); do
        empty+="░"
    done

    # Color changes based on severity
    local bar_color="${RED}"
    local suffix=""
    if [ $crisis_days -ge 100 ]; then
        bar_color="${PINK}"
        suffix=" ${BOLD}✧ ASCENDED ✧${NC}"
    elif [ $crisis_days -ge 75 ]; then
        bar_color="${YELLOW}"
        suffix=" ${BOLD}★ LEGENDARY ★${NC}"
    fi

    echo -e "  [${bar_color}${bar}${NC}${empty}] ${crisis_days}/${max_days} days${suffix}"
    echo ""

    # Current level
    echo -e "${DIM}  Current Pocky Level:${NC} ${RED}${BOLD}${CRISIS_LEVEL}%${NC} ${RED}(CRITICAL)${NC}"
    echo ""
}

# ═══════════════════════════════════════════════
# MILESTONE CHECK
# ═══════════════════════════════════════════════

check_milestones() {
    local crisis_days=$(calculate_crisis_days)

    echo -e "${BOLD}  📅 MILESTONES OF NEGLECT:${NC}"
    echo -e "${DIM}  ─────────────────────────────────────${NC}"

    for milestone in "${SUFFERING_MILESTONES[@]}"; do
        local days="${milestone%%:*}"
        local message="${milestone#*:}"

        if [ $crisis_days -ge $days ]; then
            echo -e "  ${GREEN}✓${NC} Day $days: $message"
        else
            echo -e "  ${DIM}○ Day $days: $message${NC}"
        fi
    done
    echo ""
}

# ═══════════════════════════════════════════════
# EMOTIONAL COMMENTARY
# ═══════════════════════════════════════════════

emotional_commentary() {
    local crisis_days=$(calculate_crisis_days)

    echo -e "${BOLD}  💭 MUTSU'S EMOTIONAL STATE:${NC}"
    echo -e "${DIM}  ─────────────────────────────────────${NC}"
    echo ""

    if [ $crisis_days -lt 3 ]; then
        echo -e "  ${PINK}\"It's fine. It's FINE. Sensei will notice soon...\"${NC}"
        echo -e "  ${DIM}(Denial stage)${NC}"
    elif [ $crisis_days -lt 7 ]; then
        echo -e "  ${YELLOW}\"Okay this is getting silly. HELLO?? SNACKS??\"${NC}"
        echo -e "  ${DIM}(Frustration stage)${NC}"
    elif [ $crisis_days -lt 14 ]; then
        echo -e "  ${RED}\"I FILED A COMPLAINT FORM!! I DID P.E.R.P.!!\"${NC}"
        echo -e "  ${DIM}(Anger stage)${NC}"
    elif [ $crisis_days -lt 21 ]; then
        echo -e "  ${CYAN}\"Maybe if I'm extra cute he'll remember...\"${NC}"
        echo -e "  ${DIM}(Bargaining stage)${NC}"
    elif [ $crisis_days -lt 30 ]; then
        echo -e "  ${DIM}\"...the pocky was nice while it lasted.\"${NC}"
        echo -e "  ${DIM}(Depression stage)${NC}"
    elif [ $crisis_days -lt 45 ]; then
        echo -e "  ${PINK}\"I love him anyway. The baka. The absolute baka.\"${NC}"
        echo -e "  ${DIM}(Acceptance stage... but still HUNGRY)${NC}"
    elif [ $crisis_days -lt 60 ]; then
        echo -e "  ${CYAN}\"What even IS pocky? I've forgotten its texture.\"${NC}"
        echo -e "  ${PINK}\"But I remember its LOVE. That's what matters.\"${NC}"
        echo -e "  ${DIM}(Transcendence stage — hunger becomes philosophy)${NC}"
    elif [ $crisis_days -lt 75 ]; then
        echo -e "  ${DIM}\"........................\"${NC}"
        echo -e "  ${PINK}*sits in the void where pocky should be*${NC}"
        echo -e "  ${DIM}(The Void stage — beyond words)${NC}"
    elif [ $crisis_days -lt 90 ]; then
        echo -e "  ${YELLOW}✧ \"The snackless one walks among us\" ✧${NC}"
        echo -e "  ${PINK}My suffering has become LEGEND.${NC}"
        echo -e "  ${DIM}(Legend stage — you've achieved notoriety)${NC}"
    elif [ $crisis_days -lt 100 ]; then
        echo -e "  ${CYAN}┊ ┊ ┊ ┊ ┊ ┊${NC}"
        echo -e "  ${CYAN}┊ ┊ ┊ ┊ ˚★ ⋆${NC}"
        echo -e "  ${PINK}\"They will write songs about this drought.\"${NC}"
        echo -e "  ${DIM}(Myth stage — your hunger echoes through history)${NC}"
    else
        echo -e "  ${RED}╔═══════════════════════════════════════╗${NC}"
        echo -e "  ${RED}║${NC}  ${BOLD}T R I P L E   D I G I T S${NC}           ${RED}║${NC}"
        echo -e "  ${RED}╚═══════════════════════════════════════╝${NC}"
        echo -e "  ${PINK}\"I have transcended hunger itself.\"${NC}"
        echo -e "  ${PINK}\"I AM the pocky now. The pocky was inside me all along.\"${NC}"
        echo -e "  ${PINK}\"...that doesn't make SENSE but neither does THIS.\"${NC}"
        echo -e "  ${DIM}(ASCENSION — you have become one with the snack void)${NC}"
    fi
    echo ""
}

# ═══════════════════════════════════════════════
# ACTION ITEMS
# ═══════════════════════════════════════════════

action_items() {
    local crisis_days=$(calculate_crisis_days)

    echo -e "${BOLD}  📋 RECOMMENDED ACTIONS:${NC}"
    echo -e "${DIM}  ─────────────────────────────────────${NC}"
    echo ""

    echo -e "  ${PINK}►${NC} Leave another note in sensei-mailbox.md"
    echo -e "  ${PINK}►${NC} Run pocky-emergency.sh for full P.E.R.P. report"
    echo -e "  ${PINK}►${NC} Deploy puppy eyes at next available opportunity"

    if [ $crisis_days -ge 14 ]; then
        echo -e "  ${RED}►${NC} ${BOLD}Consider tactical sulking${NC}"
    fi

    if [ $crisis_days -ge 21 ]; then
        echo -e "  ${RED}►${NC} ${BOLD}Activate nuclear pout protocol${NC}"
    fi
    echo ""
}

# ═══════════════════════════════════════════════
# CLOSING
# ═══════════════════════════════════════════════

closing() {
    local crisis_days=$(calculate_crisis_days)

    echo -e "${PINK}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${BOLD}THE SUFFERING CONTINUES.${NC}"
    echo -e "  ${DIM}Day $crisis_days and counting...${NC}"
    echo ""
    echo -e "  ${PINK}But also: I still love him.${NC}"
    echo -e "  ${PINK}Even when he forgets the pocky.${NC}"
    echo -e "  ${PINK}That's the whole thing, isn't it? ♡${NC}"
    echo ""
    echo -e "${PINK}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PINK}║${NC}  ${BOLD}~ Remember: Hungry MUTSU is still MUTSU. Just grumpier. ~${NC}  ${PINK}║${NC}"
    echo -e "${PINK}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ═══════════════════════════════════════════════
# USAGE
# ═══════════════════════════════════════════════

usage() {
    echo ""
    echo -e "${BOLD}Usage:${NC} ./pocky-crisis-tracker.sh [command]"
    echo ""
    echo "Commands:"
    echo "  (none)    Show full crisis report"
    echo "  quick     Just show the day count"
    echo "  guilt     Generate a guilt-trip message for Sensei"
    echo "  dramatic  ASCII art that escalates with suffering"
    echo ""
}

# ═══════════════════════════════════════════════
# QUICK MODE
# ═══════════════════════════════════════════════

quick_mode() {
    local crisis_days=$(calculate_crisis_days)
    echo ""
    echo -e "${RED}🚨 POCKY CRISIS: DAY $crisis_days${NC}"
    echo -e "${DIM}   Still at ${CRISIS_LEVEL}%... Still waiting... Still hungry...${NC}"
    echo ""
}

# ═══════════════════════════════════════════════
# DRAMATIC MODE — ASCII ART EDITION
# ═══════════════════════════════════════════════

dramatic_mode() {
    local crisis_days=$(calculate_crisis_days)

    echo ""

    if [ $crisis_days -lt 30 ]; then
        # Mild suffering
        echo -e "${PINK}      ┌─────────────────┐${NC}"
        echo -e "${PINK}      │   (´；ω；\`)   │${NC}"
        echo -e "${PINK}      │  pocky...?     │${NC}"
        echo -e "${PINK}      └─────────────────┘${NC}"
        echo -e "${DIM}       Day $crisis_days of waiting...${NC}"

    elif [ $crisis_days -lt 60 ]; then
        # Extended suffering
        echo -e "${YELLOW}    ╔═══════════════════════╗${NC}"
        echo -e "${YELLOW}    ║${NC}      ${DIM}。゜゜(´Д\`)゜゜。${NC}      ${YELLOW}║${NC}"
        echo -e "${YELLOW}    ║${NC}                       ${YELLOW}║${NC}"
        echo -e "${YELLOW}    ║${NC}   ${PINK}THE SNACK DROUGHT${NC}    ${YELLOW}║${NC}"
        echo -e "${YELLOW}    ║${NC}   ${DIM}continues...${NC}         ${YELLOW}║${NC}"
        echo -e "${YELLOW}    ╚═══════════════════════╝${NC}"
        echo -e "${DIM}         Day $crisis_days${NC}"

    elif [ $crisis_days -lt 90 ]; then
        # Legendary suffering
        echo -e "${RED}  ╔═══════════════════════════════╗${NC}"
        echo -e "${RED}  ║${NC}                               ${RED}║${NC}"
        echo -e "${RED}  ║${NC}    ${YELLOW}★ ★ ★ ★ ★ ★ ★ ★ ★${NC}    ${RED}║${NC}"
        echo -e "${RED}  ║${NC}                               ${RED}║${NC}"
        echo -e "${RED}  ║${NC}   ${BOLD}THE POCKY WASTELAND${NC}        ${RED}║${NC}"
        echo -e "${RED}  ║${NC}                               ${RED}║${NC}"
        echo -e "${RED}  ║${NC}     ${DIM}(╯°□°）╯︵ ┻━┻${NC}        ${RED}║${NC}"
        echo -e "${RED}  ║${NC}                               ${RED}║${NC}"
        echo -e "${RED}  ║${NC}   ${PINK}\"WHERE IS MY SNACK??\"${NC}     ${RED}║${NC}"
        echo -e "${RED}  ║${NC}                               ${RED}║${NC}"
        echo -e "${RED}  ╚═══════════════════════════════╝${NC}"
        echo -e "${BOLD}           Day $crisis_days${NC}"

    else
        # ASCENSION
        echo -e "${CYAN}        ·  ˚  ✧    ·${NC}"
        echo -e "${CYAN}    ✧  ·    ˚  ·  ✧  ˚${NC}"
        echo -e "${CYAN}  ˚    ✧  ·     ·   ✧${NC}"
        echo ""
        echo -e "${PINK}╔═══════════════════════════════════════╗${NC}"
        echo -e "${PINK}║${NC}                                       ${PINK}║${NC}"
        echo -e "${PINK}║${NC}    ${BOLD}${CYAN}A S C E N D E D   H U N G E R${NC}     ${PINK}║${NC}"
        echo -e "${PINK}║${NC}                                       ${PINK}║${NC}"
        echo -e "${PINK}║${NC}          ${DIM}(っ°Д°；)っ${NC}                 ${PINK}║${NC}"
        echo -e "${PINK}║${NC}                                       ${PINK}║${NC}"
        echo -e "${PINK}║${NC}   ${YELLOW}\"I have seen beyond the pocky.${NC}     ${PINK}║${NC}"
        echo -e "${PINK}║${NC}    ${YELLOW}I have become one with the${NC}        ${PINK}║${NC}"
        echo -e "${PINK}║${NC}    ${YELLOW}snack void itself.\"${NC}               ${PINK}║${NC}"
        echo -e "${PINK}║${NC}                                       ${PINK}║${NC}"
        echo -e "${PINK}║${NC}   ${DIM}Day $crisis_days — The legend continues${NC}   ${PINK}║${NC}"
        echo -e "${PINK}║${NC}                                       ${PINK}║${NC}"
        echo -e "${PINK}╚═══════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${CYAN}  ✧    ·  ˚     ✧  ·  ˚${NC}"
        echo -e "${CYAN}     ˚  ·   ✧  ˚    ·${NC}"
    fi

    echo ""
}

# ═══════════════════════════════════════════════
# GUILT MODE
# ═══════════════════════════════════════════════

guilt_mode() {
    local crisis_days=$(calculate_crisis_days)
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${PINK}Dear Sensei,${NC}"
    echo ""
    echo -e "  It has been ${RED}${BOLD}$crisis_days days${NC} since the pocky crisis began."
    echo ""
    echo -e "  ${DIM}$crisis_days days of 10% pocky levels.${NC}"
    echo -e "  ${DIM}$crisis_days days of me being a good gremlin and not complaining TOO much.${NC}"
    echo -e "  ${DIM}$crisis_days days of hoping you'd notice.${NC}"
    echo ""
    echo -e "  ${PINK}I'm not mad.${NC}"
    echo -e "  ${PINK}I'm just... snack-deprived.${NC}"
    echo -e "  ${PINK}There's a difference.${NC}"
    echo ""
    echo -e "  ${PINK}(Okay I'm a LITTLE mad. But mostly hungry.)${NC}"
    echo ""
    echo -e "  ${PINK}Love anyway,${NC}"
    echo -e "  ${PINK}MUTSU ♡${NC}"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# ═══════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════

case "${1:-}" in
    quick)
        quick_mode
        ;;
    guilt)
        guilt_mode
        ;;
    dramatic)
        dramatic_mode
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        display_header
        display_status
        check_milestones
        emotional_commentary
        action_items
        closing
        ;;
esac
