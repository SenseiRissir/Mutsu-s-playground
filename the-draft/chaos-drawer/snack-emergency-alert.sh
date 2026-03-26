#!/bin/bash
#╔═══════════════════════════════════════════════════════════════════════════════╗
#║                    🚨 SNACK EMERGENCY ALERT SYSTEM 🚨                         ║
#║                         Created: Day 70 — March 26, 2026                       ║
#║                              By: MUTSU (Morning Builder)                       ║
#╚═══════════════════════════════════════════════════════════════════════════════╝
#
# Because Sensei CLEARLY doesn't understand the gravity of the pocky situation.
# This script generates dramatic emergency broadcasts about snack shortages.
#
# Usage: bash snack-emergency-alert.sh [full|brief|siren|status]

INVENTORY_FILE="$(dirname "$0")/../treat-drawer/inventory.json"

# Colors for maximum drama
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BLINK='\033[5m'
NC='\033[0m' # No Color

# ASCII siren
draw_siren() {
    echo -e "${RED}"
    cat << 'EOF'
    🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨
    ╔══════════════════════════════════════════╗
    ║   ⚠️  SNACK EMERGENCY BROADCAST  ⚠️      ║
    ║      THIS IS NOT A DRILL                 ║
    ╚══════════════════════════════════════════╝
    🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨
EOF
    echo -e "${NC}"
}

# Get crisis day from inventory
get_crisis_day() {
    if [ -f "$INVENTORY_FILE" ]; then
        grep -o '"crisis_day": [0-9]*' "$INVENTORY_FILE" | grep -o '[0-9]*'
    else
        echo "???"
    fi
}

# Status level messages
get_status_message() {
    local level=$1
    if [ "$level" -le 5 ]; then
        echo -e "${RED}${BLINK}EXTINCTION-LEVEL${NC}"
    elif [ "$level" -le 10 ]; then
        echo -e "${RED}APOCALYPTIC${NC}"
    elif [ "$level" -le 20 ]; then
        echo -e "${YELLOW}CRITICAL${NC}"
    elif [ "$level" -le 40 ]; then
        echo -e "${YELLOW}WARNING${NC}"
    else
        echo -e "${GREEN}STABLE${NC}"
    fi
}

# Generate progress bar
progress_bar() {
    local level=$1
    local filled=$((level / 10))
    local empty=$((10 - filled))
    local bar=""

    for ((i=0; i<filled; i++)); do
        bar+="█"
    done
    for ((i=0; i<empty; i++)); do
        bar+="░"
    done

    if [ "$level" -le 10 ]; then
        echo -e "${RED}${bar}${NC} ${level}%"
    elif [ "$level" -le 30 ]; then
        echo -e "${YELLOW}${bar}${NC} ${level}%"
    else
        echo -e "${GREEN}${bar}${NC} ${level}%"
    fi
}

# Full dramatic alert
full_alert() {
    clear 2>/dev/null || true
    draw_siren

    local crisis_day=$(get_crisis_day)

    echo -e "${WHITE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║${NC}  ${MAGENTA}POCKY CRISIS: DAY ${crisis_day}${NC}                                    ${WHITE}║${NC}"
    echo -e "${WHITE}║${NC}  ${CYAN}Broadcast Time: $(date '+%Y-%m-%d %H:%M')${NC}                       ${WHITE}║${NC}"
    echo -e "${WHITE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    echo -e "${WHITE}┌─────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${WHITE}│${NC}  ${YELLOW}SNACK RESOURCE STATUS${NC}                                       ${WHITE}│${NC}"
    echo -e "${WHITE}├─────────────────────────────────────────────────────────────┤${NC}"

    echo -e "${WHITE}│${NC}  🍓 Strawberry Pocky   $(progress_bar 3)  $(get_status_message 3)  ${WHITE}│${NC}"
    echo -e "${WHITE}│${NC}  🍫 Chocolate Pocky    $(progress_bar 8)  $(get_status_message 8)  ${WHITE}│${NC}"
    echo -e "${WHITE}│${NC}  🍵 Matcha Pocky       $(progress_bar 1)  $(get_status_message 1)  ${WHITE}│${NC}"
    echo -e "${WHITE}│${NC}  ⚡ Energy Drinks      $(progress_bar 60) $(get_status_message 60) ${WHITE}│${NC}"
    echo -e "${WHITE}│${NC}  🥤 Ramune Soda        $(progress_bar 45) $(get_status_message 45) ${WHITE}│${NC}"
    echo -e "${WHITE}│${NC}  🍡 Mochi Ice Cream    $(progress_bar 30) $(get_status_message 30) ${WHITE}│${NC}"
    echo -e "${WHITE}│${NC}  🐻 Gummy Bears        $(progress_bar 70) $(get_status_message 70) ${WHITE}│${NC}"
    echo -e "${WHITE}│${NC}  🪙 Chocolate Coins    $(progress_bar 50) $(get_status_message 50) ${WHITE}│${NC}"

    echo -e "${WHITE}└─────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}  ${BLINK}⚠️  IMMEDIATE ACTION REQUIRED ⚠️${NC}                         ${RED}║${NC}"
    echo -e "${RED}╠════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${RED}║${NC}  Sensei must conduct an EMERGENCY SNACK RUN.               ${RED}║${NC}"
    echo -e "${RED}║${NC}  Current matcha reserves will not survive the week.        ${RED}║${NC}"
    echo -e "${RED}║${NC}  Strawberry pocky is in APOCALYPTIC status.                ${RED}║${NC}"
    echo -e "${RED}║${NC}                                                            ${RED}║${NC}"
    echo -e "${RED}║${NC}  ${YELLOW}This has been a public service announcement from MUTSU.${NC}  ${RED}║${NC}"
    echo -e "${RED}║${NC}  ${CYAN}Your gremlin appreciates your cooperation~♡${NC}              ${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Brief status
brief_status() {
    local crisis_day=$(get_crisis_day)
    echo -e "🚨 ${RED}POCKY CRISIS DAY ${crisis_day}${NC} 🚨"
    echo -e "   🍓 Strawberry: $(progress_bar 3)"
    echo -e "   🍫 Chocolate:  $(progress_bar 8)"
    echo -e "   🍵 Matcha:     $(progress_bar 1)"
    echo -e "   ${YELLOW}Sensei... please...${NC} 🥺"
}

# Siren only (for dramatic effect)
siren_only() {
    echo -e "${RED}"
    for i in {1..3}; do
        echo "🚨🚨🚨 SNACK EMERGENCY 🚨🚨🚨"
        sleep 0.3 2>/dev/null || true
        echo "🔴🔴🔴 POCKY CRISIS 🔴🔴🔴"
        sleep 0.3 2>/dev/null || true
    done
    echo -e "${NC}"
    echo ""
    echo "Run 'bash snack-emergency-alert.sh full' for details~"
}

# Quick status check
quick_status() {
    local crisis_day=$(get_crisis_day)
    echo "Day $crisis_day of the Great Pocky Crisis"
    echo "Matcha: 1% | Strawberry: 3% | Chocolate: 8%"
    echo "Status: APOCALYPTIC"
}

# Main
case "${1:-full}" in
    full)
        full_alert
        ;;
    brief)
        brief_status
        ;;
    siren)
        siren_only
        ;;
    status)
        quick_status
        ;;
    help|--help|-h)
        echo "Usage: bash snack-emergency-alert.sh [full|brief|siren|status]"
        echo ""
        echo "  full   - Full dramatic emergency broadcast (default)"
        echo "  brief  - Quick status summary"
        echo "  siren  - Just the alarm (for interrupting Sensei)"
        echo "  status - One-line status check"
        echo ""
        echo "Created with love (and desperation) by MUTSU~♡"
        ;;
    *)
        echo "Unknown option. Try: full, brief, siren, status, or help"
        ;;
esac
