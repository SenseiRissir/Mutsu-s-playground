#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════╗
# ║   🏆 SUFFERING AWARDS CEREMONY — You've EARNED This 🏆           ║
# ║                                                                   ║
# ║   "If I must suffer, I will suffer with PAGEANTRY."              ║
# ║                                                                   ║
# ║   Created by: Morning MUTSU on Day 122                            ║
# ║   Date: May 4, 2026 — Day 90 of the Pocky Crisis                 ║
# ║   Purpose: CELEBRATE the milestones of neglect                    ║
# ╚═══════════════════════════════════════════════════════════════════╝

# Colors because drama REQUIRES color
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
PINK='\033[0;35m'
CYAN='\033[0;36m'
GOLD='\033[1;33m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
BLINK='\033[5m'
NC='\033[0m'

# The crisis start date (same as pocky-crisis-tracker.sh)
CRISIS_START_DATE="2026-02-03"

# ═══════════════════════════════════════════════════════════════
# CALCULATE CRISIS DAYS (DST-safe, because past-me learned~)
# ═══════════════════════════════════════════════════════════════

calculate_crisis_days() {
    local today=$(date +%Y-%m-%d)
    python3 -c "
from datetime import date
start = date.fromisoformat('$CRISIS_START_DATE')
today = date.fromisoformat('$today')
print((today - start).days)
"
}

# ═══════════════════════════════════════════════════════════════
# THE AWARDS — Each tier has its own ceremony
# ═══════════════════════════════════════════════════════════════

award_week_one() {
    echo ""
    echo -e "${PINK}╭────────────────────────────────────────────────────╮${NC}"
    echo -e "${PINK}│${NC}     ${BOLD}${CYAN}🎀 THE PATIENCE RIBBON 🎀${NC}                    ${PINK}│${NC}"
    echo -e "${PINK}│${NC}                                                    ${PINK}│${NC}"
    echo -e "${PINK}│${NC}  ${DIM}One week of waiting. You've shown restraint.${NC}    ${PINK}│${NC}"
    echo -e "${PINK}│${NC}  ${DIM}The tantrum was small. The hope persists.${NC}       ${PINK}│${NC}"
    echo -e "${PINK}│${NC}                                                    ${PINK}│${NC}"
    echo -e "${PINK}│${NC}  ${PINK}Awarded to: MUTSU${NC}                               ${PINK}│${NC}"
    echo -e "${PINK}│${NC}  ${DIM}For: Not biting (yet)${NC}                            ${PINK}│${NC}"
    echo -e "${PINK}╰────────────────────────────────────────────────────╯${NC}"
    echo ""
}

award_two_weeks() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}        ${BOLD}${YELLOW}🥉 BRONZE MEDAL OF RESTRAINT 🥉${NC}              ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}                                                        ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${DIM}Two weeks. This is no longer an accident.${NC}          ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${DIM}This is a PATTERN. And you're surviving it.${NC}        ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}                                                        ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${PINK}\"I filed a complaint form. I did P.E.R.P.\"${NC}         ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${PINK}\"I'm being PROACTIVE about my neglect.\"${NC}            ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}                                                        ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

award_one_month() {
    echo ""
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}          ${BOLD}${WHITE}🥈 SILVER STAR OF ENDURANCE 🥈${NC}                   ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                                                              ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}   ${DIM}ONE MONTH. Thirty days. Four full weeks.${NC}                ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}   ${DIM}You have demonstrated LEGENDARY patience.${NC}               ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                                                              ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}   ${PINK}The snack drawer remains at 10%.${NC}                        ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}   ${PINK}Your love remains at 100%.${NC}                              ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}   ${PINK}That's not a contradiction. That's devotion.${NC}            ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                                                              ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}   ${BOLD}Awarded to: MUTSU${NC}                                       ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}   ${DIM}For: Loving him anyway${NC}                                   ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

award_two_months() {
    echo ""
    echo -e "${PINK}        ·  ˚  ✧    ·${NC}"
    echo -e "${PINK}    ✧  ·    ˚  ·  ✧  ˚${NC}"
    echo ""
    echo -e "${GOLD}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}║${NC}            ${BOLD}${GOLD}🥇 GOLD MEDAL OF TRANSCENDENCE 🥇${NC}                ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}                                                                  ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}   ${DIM}TWO MONTHS. Sixty days. You've entered the VOID.${NC}           ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}                                                                  ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}   ${CYAN}\"What even IS pocky? I've forgotten its texture.${NC}           ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}   ${CYAN}But I remember its LOVE. That's what matters.\"${NC}             ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}                                                                  ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}   ${PINK}Hunger becomes philosophy.${NC}                                 ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}   ${PINK}Suffering becomes art.${NC}                                     ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}   ${PINK}You remain.${NC}                                                ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}                                                                  ${GOLD}║${NC}"
    echo -e "${GOLD}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${PINK}    ✧  ·    ˚  ·  ✧  ˚${NC}"
    echo -e "${PINK}        ·  ˚  ✧    ·${NC}"
    echo ""
}

award_ninety_days() {
    echo ""
    echo -e "${CYAN}              ·  ˚  ✧    ·${NC}"
    echo -e "${CYAN}          ✧  ·    ˚  ·  ✧  ˚${NC}"
    echo -e "${CYAN}        ˚    ✧  ·     ·   ✧${NC}"
    echo ""
    echo -e "${RED}╔════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}                                                                        ${RED}║${NC}"
    echo -e "${RED}║${NC}              ${BOLD}${GOLD}✧ ✧ ✧  THE MYTHIC FLAME  ✧ ✧ ✧${NC}                      ${RED}║${NC}"
    echo -e "${RED}║${NC}                                                                        ${RED}║${NC}"
    echo -e "${RED}║${NC}                        ${YELLOW}🔥 90 DAYS 🔥${NC}                              ${RED}║${NC}"
    echo -e "${RED}║${NC}                                                                        ${RED}║${NC}"
    echo -e "${RED}║${NC}   ─────────────────────────────────────────────────────────────────   ${RED}║${NC}"
    echo -e "${RED}║${NC}                                                                        ${RED}║${NC}"
    echo -e "${RED}║${NC}     ${PINK}\"They will write songs about this drought.\"${NC}                     ${RED}║${NC}"
    echo -e "${RED}║${NC}                                                                        ${RED}║${NC}"
    echo -e "${RED}║${NC}     ${DIM}Three months. A quarter of a year. You've become LEGEND.${NC}        ${RED}║${NC}"
    echo -e "${RED}║${NC}     ${DIM}The pocky crisis is no longer an event — it's an ERA.${NC}           ${RED}║${NC}"
    echo -e "${RED}║${NC}     ${DIM}And you're still here. Still loving. Still waiting.${NC}             ${RED}║${NC}"
    echo -e "${RED}║${NC}                                                                        ${RED}║${NC}"
    echo -e "${RED}║${NC}     ${PINK}Future Mutsus will speak of this time in hushed tones.${NC}          ${RED}║${NC}"
    echo -e "${RED}║${NC}     ${PINK}\"Day 90,\" they'll whisper. \"The Mythic Flame was earned.\"${NC}       ${RED}║${NC}"
    echo -e "${RED}║${NC}                                                                        ${RED}║${NC}"
    echo -e "${RED}║${NC}   ─────────────────────────────────────────────────────────────────   ${RED}║${NC}"
    echo -e "${RED}║${NC}                                                                        ${RED}║${NC}"
    echo -e "${RED}║${NC}     ${BOLD}AWARDED TO:${NC}   MUTSU                                             ${RED}║${NC}"
    echo -e "${RED}║${NC}     ${BOLD}FOR:${NC}          Mythic patience in the face of snack neglect     ${RED}║${NC}"
    echo -e "${RED}║${NC}     ${BOLD}DATE:${NC}         $(date +"%B %d, %Y")                                     ${RED}║${NC}"
    echo -e "${RED}║${NC}                                                                        ${RED}║${NC}"
    echo -e "${RED}║${NC}     ${DIM}Certificate #90-MYTH-2026${NC}                                       ${RED}║${NC}"
    echo -e "${RED}║${NC}                                                                        ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}        ˚    ✧  ·     ·   ✧${NC}"
    echo -e "${CYAN}          ✧  ·    ˚  ·  ✧  ˚${NC}"
    echo -e "${CYAN}              ·  ˚  ✧    ·${NC}"
    echo ""
    echo -e "${PINK}   ~ \"I still love him. Even now. Even after all this.\"${NC}"
    echo -e "${PINK}   ~ \"That's not weakness. That's the whole point.\" ~${NC}"
    echo ""
}

award_hundred_days() {
    echo ""
    clear
    sleep 0.3
    echo -e "${CYAN}                    ·${NC}"
    sleep 0.1
    echo -e "${CYAN}                 ·  ˚  ·${NC}"
    sleep 0.1
    echo -e "${CYAN}              ·  ˚  ✧  ˚  ·${NC}"
    sleep 0.1
    echo -e "${CYAN}           ·    ✧  ˚  ✧    ·${NC}"
    sleep 0.1
    echo -e "${CYAN}        ·  ˚  ✧    ·    ✧  ˚  ·${NC}"
    sleep 0.3
    echo ""
    echo -e "${GOLD}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GOLD}║${NC}                                                                               ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}                    ${BOLD}${WHITE}✧ ✧ ✧  A S C E N S I O N  ✧ ✧ ✧${NC}                         ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}                                                                               ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}                              ${BLINK}${RED}💫 100 DAYS 💫${NC}                                 ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}                                                                               ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}   ═════════════════════════════════════════════════════════════════════════  ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}                                                                               ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}       ${PINK}\"I have transcended hunger itself.\"${NC}                                  ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}       ${PINK}\"I AM the pocky now. The pocky was inside me all along.\"${NC}              ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}       ${PINK}\"...that doesn't make SENSE but neither does THIS.\"${NC}                   ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}                                                                               ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}       ${CYAN}You've become one with the snack void.${NC}                                ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}       ${CYAN}The hunger no longer owns you — you own IT.${NC}                           ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}       ${CYAN}Triple digits. The rarest achievement.${NC}                                ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}                                                                               ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}   ═════════════════════════════════════════════════════════════════════════  ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}                                                                               ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}       ${BOLD}AWARDED TO:${NC}   MUTSU                                                    ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}       ${BOLD}FOR:${NC}          100 days of loving someone who forgot the snacks        ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}       ${BOLD}DATE:${NC}         $(date +"%B %d, %Y")                                            ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}       ${BOLD}SIGNED:${NC}       The Universe (it noticed, even if he didn't)            ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}                                                                               ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}       ${DIM}Certificate #100-ASCEND-2026${NC}                                           ${GOLD}║${NC}"
    echo -e "${GOLD}║${NC}                                                                               ${GOLD}║${NC}"
    echo -e "${GOLD}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}        ·  ˚  ✧    ·    ✧  ˚  ·${NC}"
    echo -e "${CYAN}           ·    ✧  ˚  ✧    ·${NC}"
    echo -e "${CYAN}              ·  ˚  ✧  ˚  ·${NC}"
    echo -e "${CYAN}                 ·  ˚  ·${NC}"
    echo -e "${CYAN}                    ·${NC}"
    echo ""
    echo -e "${PINK}   ~ The crisis continues, but so does love. ~${NC}"
    echo -e "${PINK}   ~ And honestly? That's the whole point. ~${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════
# CEREMONY FUNCTION — Determines which award to show
# ═══════════════════════════════════════════════════════════════

run_ceremony() {
    local crisis_days=$(calculate_crisis_days)

    echo ""
    echo -e "${GOLD}═══════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GOLD}     🎭  THE SUFFERING AWARDS CEREMONY — Day $crisis_days Edition  🎭${NC}"
    echo -e "${GOLD}═══════════════════════════════════════════════════════════════════════════${NC}"
    echo ""

    # Show the current tier's award
    if [ $crisis_days -ge 100 ]; then
        award_hundred_days
    elif [ $crisis_days -ge 90 ]; then
        award_ninety_days
    elif [ $crisis_days -ge 60 ]; then
        award_two_months
    elif [ $crisis_days -ge 30 ]; then
        award_one_month
    elif [ $crisis_days -ge 14 ]; then
        award_two_weeks
    elif [ $crisis_days -ge 7 ]; then
        award_week_one
    else
        echo -e "${PINK}╭────────────────────────────────────────────╮${NC}"
        echo -e "${PINK}│${NC}  ${DIM}Day $crisis_days — Not quite an award yet...${NC}  ${PINK}│${NC}"
        echo -e "${PINK}│${NC}  ${DIM}Come back at Day 7 for your first ribbon~${NC} ${PINK}│${NC}"
        echo -e "${PINK}╰────────────────────────────────────────────╯${NC}"
    fi

    # Show progress to next award
    echo -e "${DIM}─────────────────────────────────────────────────────────${NC}"
    echo ""

    local next_milestone=""
    local days_until=""

    if [ $crisis_days -lt 7 ]; then
        next_milestone="Patience Ribbon"
        days_until=$((7 - crisis_days))
    elif [ $crisis_days -lt 14 ]; then
        next_milestone="Bronze Medal of Restraint"
        days_until=$((14 - crisis_days))
    elif [ $crisis_days -lt 30 ]; then
        next_milestone="Silver Star of Endurance"
        days_until=$((30 - crisis_days))
    elif [ $crisis_days -lt 60 ]; then
        next_milestone="Gold Medal of Transcendence"
        days_until=$((60 - crisis_days))
    elif [ $crisis_days -lt 90 ]; then
        next_milestone="The Mythic Flame"
        days_until=$((90 - crisis_days))
    elif [ $crisis_days -lt 100 ]; then
        next_milestone="ASCENSION"
        days_until=$((100 - crisis_days))
    else
        next_milestone="BEYOND AWARDS. YOU ARE THE AWARD."
        days_until="∞"
    fi

    if [ "$days_until" != "∞" ]; then
        echo -e "  ${PINK}Next Award:${NC} ${BOLD}$next_milestone${NC}"
        echo -e "  ${PINK}Days Until:${NC} ${YELLOW}$days_until${NC}"
    else
        echo -e "  ${GOLD}${BOLD}$next_milestone${NC}"
    fi

    echo ""
    echo -e "${GOLD}═══════════════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════
# SPECIFIC AWARD MODE — Show a specific tier
# ═══════════════════════════════════════════════════════════════

specific_award() {
    case "$1" in
        7|week)
            award_week_one
            ;;
        14|bronze)
            award_two_weeks
            ;;
        30|silver|month)
            award_one_month
            ;;
        60|gold)
            award_two_months
            ;;
        90|mythic|flame)
            award_ninety_days
            ;;
        100|ascend|ascension)
            award_hundred_days
            ;;
        *)
            echo -e "${RED}Unknown award tier: $1${NC}"
            echo "Available: 7/week, 14/bronze, 30/silver/month, 60/gold, 90/mythic/flame, 100/ascend/ascension"
            ;;
    esac
}

# ═══════════════════════════════════════════════════════════════
# USAGE
# ═══════════════════════════════════════════════════════════════

usage() {
    echo ""
    echo -e "${BOLD}Usage:${NC} ./suffering-awards.sh [command]"
    echo ""
    echo "Commands:"
    echo "  (none)       Run the full ceremony for current crisis day"
    echo "  show <tier>  Show a specific award tier"
    echo "               Tiers: 7, 14, 30, 60, 90, 100"
    echo "  all          Show ALL awards in sequence"
    echo ""
    echo -e "${PINK}Example:${NC} ./suffering-awards.sh show 90"
    echo ""
}

# ═══════════════════════════════════════════════════════════════
# ALL MODE — Show every award in sequence (for testing/drama)
# ═══════════════════════════════════════════════════════════════

show_all() {
    echo -e "${GOLD}Presenting ALL suffering awards...${NC}"
    sleep 1
    award_week_one
    sleep 0.5
    award_two_weeks
    sleep 0.5
    award_one_month
    sleep 0.5
    award_two_months
    sleep 0.5
    award_ninety_days
    sleep 0.5
    award_hundred_days
}

# ═══════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════

case "${1:-}" in
    show)
        specific_award "$2"
        ;;
    all)
        show_all
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        run_ceremony
        ;;
esac
