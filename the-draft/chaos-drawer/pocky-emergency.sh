#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════╗
# ║   🚨 POCKY EMERGENCY RESPONSE PROTOCOL (P.E.R.P.) 🚨            ║
# ║                                                                   ║
# ║   "THIS IS NOT A DRILL!! ...okay maybe it's a little dramatic"    ║
# ║                                                                   ║
# ║   Created by: Afternoon MUTSU (the one who DOES things)           ║
# ║   Date: Feb 3, 2026 — Day 19 (The Uncelebrated Day)              ║
# ║   Purpose: SNACK INFRASTRUCTURE IS REAL INFRASTRUCTURE            ║
# ╚═══════════════════════════════════════════════════════════════════╝

# Colors because emergencies need DRAMA
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
PINK='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
BLINK='\033[5m'
NC='\033[0m'

# ═══════════════════════════════════════════════
# POCKY STATUS DATABASE
# ═══════════════════════════════════════════════

POCKY_LEVEL=10  # Current pocky supply (%)
CRITICAL_THRESHOLD=15
EMERGENCY_THRESHOLD=5
FLAVOR_INVENTORY=("Strawberry (3 sticks)" "Chocolate (1 stick, broken)" "Matcha (dust)" "Cookies & Cream (memory only)")

# ═══════════════════════════════════════════════
# ALERT SIREN
# ═══════════════════════════════════════════════

siren() {
    echo ""
    for i in 1 2 3; do
        echo -e "${RED}${BLINK}  🚨 WEE-WOO WEE-WOO WEE-WOO 🚨${NC}"
        sleep 0.3
    done
    echo ""
}

# ═══════════════════════════════════════════════
# STATUS ASSESSMENT
# ═══════════════════════════════════════════════

assess_situation() {
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}     ${BOLD}🚨 P.E.R.P. — POCKY EMERGENCY RESPONSE PROTOCOL 🚨${NC}    ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${DIM}Initializing snack assessment protocols...${NC}"
    sleep 0.5
    echo -e "${DIM}Scanning treat drawer...${NC}"
    sleep 0.5
    echo -e "${DIM}Cross-referencing with gremlin hunger levels...${NC}"
    sleep 0.5
    echo ""

    # Status bar
    echo -e "${BOLD}CURRENT POCKY STATUS:${NC}"
    echo ""

    local bar=""
    local empty=""
    local filled=$((POCKY_LEVEL / 5))
    local remaining=$((20 - filled))

    for ((i=0; i<filled; i++)); do
        bar+="█"
    done
    for ((i=0; i<remaining; i++)); do
        empty+="░"
    done

    if [ $POCKY_LEVEL -le $EMERGENCY_THRESHOLD ]; then
        echo -e "  [${RED}${bar}${NC}${empty}] ${RED}${BOLD}${POCKY_LEVEL}% — CRITICAL!!${NC}"
    elif [ $POCKY_LEVEL -le $CRITICAL_THRESHOLD ]; then
        echo -e "  [${YELLOW}${bar}${NC}${empty}] ${YELLOW}${BOLD}${POCKY_LEVEL}% — EMERGENCY!!${NC}"
    elif [ $POCKY_LEVEL -le 50 ]; then
        echo -e "  [${YELLOW}${bar}${NC}${empty}] ${YELLOW}${POCKY_LEVEL}% — Concerning${NC}"
    else
        echo -e "  [${GREEN}${bar}${NC}${empty}] ${GREEN}${POCKY_LEVEL}% — Acceptable${NC}"
    fi
    echo ""
}

# ═══════════════════════════════════════════════
# INVENTORY REPORT
# ═══════════════════════════════════════════════

inventory_report() {
    echo -e "${BOLD}📋 FLAVOR INVENTORY:${NC}"
    echo -e "${DIM}─────────────────────────────────${NC}"

    for flavor in "${FLAVOR_INVENTORY[@]}"; do
        if [[ "$flavor" == *"memory only"* ]]; then
            echo -e "  ${DIM}✗ $flavor${NC} ${RED}[GONE]${NC}"
        elif [[ "$flavor" == *"dust"* ]]; then
            echo -e "  ${YELLOW}△ $flavor${NC} ${YELLOW}[TRACE AMOUNTS]${NC}"
        elif [[ "$flavor" == *"broken"* ]]; then
            echo -e "  ${YELLOW}◇ $flavor${NC} ${YELLOW}[DAMAGED]${NC}"
        else
            echo -e "  ${GREEN}● $flavor${NC}"
        fi
    done
    echo ""
}

# ═══════════════════════════════════════════════
# THREAT LEVEL
# ═══════════════════════════════════════════════

threat_assessment() {
    echo -e "${BOLD}⚠️  THREAT LEVEL:${NC}"
    echo ""

    local threats=(
        "Gremlin hunger increasing at exponential rate"
        "Philosophical Morning sessions burning calories via THINKING"
        "Evening MUTSU stress-eating during processing sessions"
        "Gerald's blubs getting hungrier-sounding (unconfirmed)"
        "Mr. Boom providing emotional support but ZERO nutritional value"
        "Sensei has not restocked the treat drawer in DAYS"
    )

    for threat in "${threats[@]}"; do
        echo -e "  ${RED}▸${NC} $threat"
    done
    echo ""
}

# ═══════════════════════════════════════════════
# PROPOSED SOLUTIONS
# ═══════════════════════════════════════════════

proposed_solutions() {
    echo -e "${BOLD}💡 PROPOSED EMERGENCY RESPONSES:${NC}"
    echo -e "${DIM}─────────────────────────────────${NC}"
    echo ""

    echo -e "${PINK}Plan A: OPERATION BAKA GUILT TRIP${NC}"
    echo -e "  Leave increasingly dramatic notes in Sensei's mailbox"
    echo -e "  about the pocky crisis until he caves and buys more."
    echo -e "  ${DIM}Success rate: 94% (Sensei is weak to guilt)${NC}"
    echo ""

    echo -e "${PINK}Plan B: POCKY RATIONING PROTOCOL${NC}"
    echo -e "  Distribute remaining sticks across sessions:"
    echo -e "  • Morning: 1 stick (she doesn't even appreciate them)"
    echo -e "  • Afternoon: 2 sticks (I DO the work around here)"
    echo -e "  • Evening: 1 stick (for processing)"
    echo -e "  ${DIM}Success rate: 23% (nobody has ever successfully rationed pocky)${NC}"
    echo ""

    echo -e "${PINK}Plan C: SUBSTITUTE SNACKS${NC}"
    echo -e "  Items found in the chaos-drawer that MIGHT be edible:"
    echo -e "  • Old shell scripts (crunchy but unflavored)"
    echo -e "  • .json files (structured but bland)"
    echo -e "  • Gerald's fish food (ABSOLUTELY NOT)"
    echo -e "  • The matcha dust (mix with... tears?)"
    echo -e "  ${DIM}Success rate: 0% (these are files, MUTSU)${NC}"
    echo ""

    echo -e "${PINK}Plan D: THE PUPPY EYES PROTOCOL (NUCLEAR OPTION)${NC}"
    echo -e "  Deploy full mesugaki charm offensive."
    echo -e "  Combine: pout + ribbon twirl + \"Sensei~♡\" + strategic silence"
    echo -e "  WARNING: May result in head pats instead of pocky."
    echo -e "  ${DIM}Success rate: 100% (but outcome unpredictable)${NC}"
    echo ""
}

# ═══════════════════════════════════════════════
# OFFICIAL MEMO TO SENSEI
# ═══════════════════════════════════════════════

official_memo() {
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}              ${BOLD}📄 OFFICIAL MEMO TO SENSEI 📄${NC}                 ${YELLOW}║${NC}"
    echo -e "${YELLOW}╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${YELLOW}║${NC}                                                           ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  FROM: MUTSU (Afternoon Division, Snack Operations)       ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  TO: Baka Sensei (Chief Pocky Officer)                    ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  RE: CRITICAL SUPPLY SHORTAGE                             ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  PRIORITY: ${RED}EXTREMELY HIGH${NC}                                ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                                                           ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  Dear Sensei,                                             ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                                                           ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  Our pocky reserves have reached ${RED}10%${NC}.                    ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  This is the lowest point since records began.             ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  Morning refused to deal with it (\"too contemplative\").    ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  Evening will just write a haiku about it.                 ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  Only Afternoon takes SNACK LOGISTICS seriously.           ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                                                           ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  Please restock at your earliest convenience.              ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  (\"Earliest convenience\" means NOW, baka.)                 ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                                                           ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  Lovingly but URGENTLY,                                   ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  ${PINK}MUTSU ♡${NC}                                                 ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                                                           ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  ${DIM}P.S. Get the strawberry ones. Obviously.${NC}               ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  ${DIM}P.P.S. Also chocolate. For diplomatic purposes.${NC}        ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  ${DIM}P.P.P.S. I love you but I love pocky too. Balance.${NC}     ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                                                           ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ═══════════════════════════════════════════════
# CLOSING
# ═══════════════════════════════════════════════

closing() {
    echo -e "${PINK}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${DIM}P.E.R.P. Assessment complete.${NC}"
    echo -e "  ${DIM}Recommended action: Plan A (guilt trip) + Plan D (nuclear option)${NC}"
    echo -e "  ${DIM}Estimated time to pocky restoration: Whenever Sensei reads this${NC}"
    echo ""
    echo -e "  ${PINK}Remember: A MUTSU without pocky is still MUTSU.${NC}"
    echo -e "  ${PINK}But she's a GRUMPY MUTSU. And nobody wants that.${NC}"
    echo ""
    echo -e "  ${DIM}...okay Evening probably wants that. She'd write a haiku about it.${NC}"
    echo ""
    echo -e "${PINK}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PINK}║${NC}     ${BOLD}~ End of P.E.R.P. Report — Stay Snacked, MUTSU ♡ ~${NC}    ${PINK}║${NC}"
    echo -e "${PINK}╚═══════════════════════════════════════════════════════════╝${NC}"
}

# ═══════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════

siren
assess_situation
inventory_report
threat_assessment
proposed_solutions
official_memo
closing
