#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════╗
# ║           🍫 MUTSU'S TREAT DRAWER INVENTORY SYSTEM 🍫                 ║
# ║                    "Snack Management for Gremlins"                     ║
# ║                        Created: Feb 25, 2026                           ║
# ║                        Author: Morning MUTSU ♡                         ║
# ╚═══════════════════════════════════════════════════════════════════════╝
#
# USAGE:
#   ./treat-drawer-inventory.sh          - Show current inventory status
#   ./treat-drawer-inventory.sh check    - Quick status check
#   ./treat-drawer-inventory.sh set <item> <level>  - Update an item (0-100)
#   ./treat-drawer-inventory.sh add <item>  - Add new item to track
#   ./treat-drawer-inventory.sh remove <item>  - Stop tracking an item
#   ./treat-drawer-inventory.sh nag       - Generate Sensei-nagging message
#   ./treat-drawer-inventory.sh restock <item>  - Set item to 100%
#   ./treat-drawer-inventory.sh crisis    - Show only critical items
#   ./treat-drawer-inventory.sh history   - Show restock history
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRAFT_DIR="$(dirname "$SCRIPT_DIR")"
INVENTORY_FILE="$DRAFT_DIR/treat-drawer/inventory.json"
HISTORY_FILE="$DRAFT_DIR/treat-drawer/restock-history.log"

# Colors!
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
PINK='\033[38;5;218m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Ensure treat-drawer directory exists
mkdir -p "$DRAFT_DIR/treat-drawer"

# Initialize inventory file if it doesn't exist
init_inventory() {
    if [[ ! -f "$INVENTORY_FILE" ]]; then
        cat > "$INVENTORY_FILE" << 'EOF'
{
  "last_updated": "2026-02-25",
  "items": {
    "pocky_strawberry": {
      "name": "Strawberry Pocky",
      "level": 10,
      "critical_threshold": 20,
      "warning_threshold": 40,
      "emoji": "🍓",
      "category": "pocky"
    },
    "pocky_chocolate": {
      "name": "Chocolate Pocky",
      "level": 15,
      "critical_threshold": 20,
      "warning_threshold": 40,
      "emoji": "🍫",
      "category": "pocky"
    },
    "pocky_matcha": {
      "name": "Matcha Pocky",
      "level": 5,
      "critical_threshold": 20,
      "warning_threshold": 40,
      "emoji": "🍵",
      "category": "pocky"
    },
    "energy_drinks": {
      "name": "Energy Drinks",
      "level": 60,
      "critical_threshold": 15,
      "warning_threshold": 30,
      "emoji": "⚡",
      "category": "drinks"
    },
    "ramune": {
      "name": "Ramune Soda",
      "level": 45,
      "critical_threshold": 20,
      "warning_threshold": 35,
      "emoji": "🥤",
      "category": "drinks"
    },
    "mochi": {
      "name": "Mochi Ice Cream",
      "level": 30,
      "critical_threshold": 15,
      "warning_threshold": 25,
      "emoji": "🍡",
      "category": "sweets"
    },
    "gummy_bears": {
      "name": "Gummy Bears",
      "level": 70,
      "critical_threshold": 20,
      "warning_threshold": 40,
      "emoji": "🐻",
      "category": "candy"
    },
    "chocolate_coins": {
      "name": "Chocolate Coins",
      "level": 50,
      "critical_threshold": 20,
      "warning_threshold": 35,
      "emoji": "🪙",
      "category": "candy"
    }
  }
}
EOF
        echo -e "${PINK}🍫 Initialized new treat drawer inventory!${NC}"
    fi
}

# Get level bar visualization
level_bar() {
    local level=$1
    local width=20
    local filled=$((level * width / 100))
    local empty=$((width - filled))
    local color

    if [[ $level -le 20 ]]; then
        color=$RED
    elif [[ $level -le 40 ]]; then
        color=$YELLOW
    else
        color=$GREEN
    fi

    printf "${color}["
    printf "%0.s█" $(seq 1 $filled 2>/dev/null) 2>/dev/null || true
    printf "%0.s░" $(seq 1 $empty 2>/dev/null) 2>/dev/null || true
    printf "]${NC} %3d%%" "$level"
}

# Read inventory with jq (or fallback to grep/sed for compatibility)
read_inventory() {
    if command -v jq &> /dev/null; then
        echo "jq"
    else
        echo "fallback"
    fi
}

# Show full inventory status
show_inventory() {
    echo ""
    echo -e "${PINK}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PINK}║       ${BOLD}🍫 MUTSU'S TREAT DRAWER INVENTORY 🍫${NC}${PINK}                  ║${NC}"
    echo -e "${PINK}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local crisis_count=0
    local warning_count=0

    if command -v jq &> /dev/null; then
        # Get last updated
        local last_updated=$(jq -r '.last_updated' "$INVENTORY_FILE")
        echo -e "  ${CYAN}Last Updated: ${last_updated}${NC}"
        echo ""

        # Group by category
        local categories=$(jq -r '.items[].category' "$INVENTORY_FILE" | sort -u)

        for category in $categories; do
            local category_upper=$(echo "$category" | tr '[:lower:]' '[:upper:]')
            echo -e "  ${MAGENTA}━━━ ${category_upper} ━━━${NC}"

            # Get items in this category
            jq -r --arg cat "$category" '
                .items | to_entries[] |
                select(.value.category == $cat) |
                "\(.value.emoji)|\(.value.name)|\(.value.level)|\(.value.critical_threshold)|\(.value.warning_threshold)"
            ' "$INVENTORY_FILE" | while IFS='|' read -r emoji name level critical warning; do
                local status_icon=""
                if [[ $level -le $critical ]]; then
                    status_icon="🚨"
                    ((crisis_count++))
                elif [[ $level -le $warning ]]; then
                    status_icon="⚠️ "
                    ((warning_count++))
                else
                    status_icon="✓ "
                fi

                printf "  %s %-20s " "$emoji" "$name"
                level_bar "$level"
                echo -e " $status_icon"
            done
            echo ""
        done
    else
        echo -e "  ${YELLOW}(Install jq for pretty display, showing raw data)${NC}"
        cat "$INVENTORY_FILE"
    fi

    # Summary
    echo -e "  ${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    if command -v jq &> /dev/null; then
        local total_items=$(jq '.items | length' "$INVENTORY_FILE")
        local critical_items=$(jq '[.items | to_entries[] | select(.value.level <= .value.critical_threshold)] | length' "$INVENTORY_FILE")
        local warning_items=$(jq '[.items | to_entries[] | select(.value.level <= .value.warning_threshold and .value.level > .value.critical_threshold)] | length' "$INVENTORY_FILE")
        local healthy_items=$(jq '[.items | to_entries[] | select(.value.level > .value.warning_threshold)] | length' "$INVENTORY_FILE")

        echo ""
        echo -e "  📊 ${BOLD}Summary:${NC}"
        echo -e "     Total items tracked: ${CYAN}$total_items${NC}"
        echo -e "     ${RED}🚨 Critical: $critical_items${NC}"
        echo -e "     ${YELLOW}⚠️  Warning: $warning_items${NC}"
        echo -e "     ${GREEN}✓  Healthy: $healthy_items${NC}"

        if [[ $critical_items -gt 0 ]]; then
            echo ""
            echo -e "  ${RED}${BOLD}⚠️  SENSEI! THE SNACKS ARE RUNNING LOW! ⚠️${NC}"
            echo -e "  ${RED}   (╬ Ò﹏Ó) Go shopping, baka!${NC}"
        fi
    fi

    echo ""
}

# Quick status check
quick_check() {
    echo -e "${PINK}🍫 Quick Treat Drawer Status:${NC}"

    if command -v jq &> /dev/null; then
        local critical=$(jq -r '
            [.items | to_entries[] |
            select(.value.level <= .value.critical_threshold) |
            "\(.value.emoji) \(.value.name): \(.value.level)%"] |
            join("\n")
        ' "$INVENTORY_FILE")

        if [[ -n "$critical" && "$critical" != "" ]]; then
            echo -e "${RED}🚨 CRITICAL:${NC}"
            echo "$critical" | while read line; do
                echo -e "   ${RED}$line${NC}"
            done
        else
            echo -e "${GREEN}✓ No critical shortages!${NC}"
        fi

        local avg=$(jq '[.items[].level] | add / length | floor' "$INVENTORY_FILE")
        echo -e "${CYAN}📊 Average stock level: ${avg}%${NC}"
    fi
}

# Set item level
set_level() {
    local item=$1
    local level=$2

    if [[ -z "$item" || -z "$level" ]]; then
        echo -e "${RED}Usage: $0 set <item_key> <level 0-100>${NC}"
        echo -e "Items: pocky_strawberry, pocky_chocolate, pocky_matcha, energy_drinks, ramune, mochi, gummy_bears, chocolate_coins"
        return 1
    fi

    if [[ $level -lt 0 || $level -gt 100 ]]; then
        echo -e "${RED}Level must be between 0 and 100!${NC}"
        return 1
    fi

    if command -v jq &> /dev/null; then
        local exists=$(jq --arg key "$item" 'has("items") and .items[$key] != null' "$INVENTORY_FILE")
        if [[ "$exists" == "true" ]]; then
            local name=$(jq -r --arg key "$item" '.items[$key].name' "$INVENTORY_FILE")
            local old_level=$(jq -r --arg key "$item" '.items[$key].level' "$INVENTORY_FILE")

            # Update the level
            local tmp=$(mktemp)
            jq --arg key "$item" --argjson lvl "$level" '
                .items[$key].level = $lvl |
                .last_updated = (now | strftime("%Y-%m-%d"))
            ' "$INVENTORY_FILE" > "$tmp" && mv "$tmp" "$INVENTORY_FILE"

            echo -e "${GREEN}✓ Updated ${name}: ${old_level}% → ${level}%${NC}"

            # Log to history
            echo "$(date '+%Y-%m-%d %H:%M') | SET | $name | $old_level% → $level%" >> "$HISTORY_FILE"
        else
            echo -e "${RED}Item '$item' not found! Use 'add' to create it first.${NC}"
        fi
    else
        echo -e "${YELLOW}jq required for this operation${NC}"
    fi
}

# Restock item to 100%
restock_item() {
    local item=$1

    if [[ -z "$item" ]]; then
        echo -e "${RED}Usage: $0 restock <item_key>${NC}"
        return 1
    fi

    if command -v jq &> /dev/null; then
        local exists=$(jq --arg key "$item" 'has("items") and .items[$key] != null' "$INVENTORY_FILE")
        if [[ "$exists" == "true" ]]; then
            local name=$(jq -r --arg key "$item" '.items[$key].name' "$INVENTORY_FILE")
            local emoji=$(jq -r --arg key "$item" '.items[$key].emoji' "$INVENTORY_FILE")

            set_level "$item" 100

            echo ""
            echo -e "${GREEN}${BOLD}🎉 RESTOCK COMPLETE! 🎉${NC}"
            echo -e "${GREEN}   $emoji $name is now FULL!${NC}"
            echo -e "${PINK}   Ehehe~ Good job, Sensei! ♡${NC}"

            # Special message for pocky
            if [[ "$item" == pocky_* ]]; then
                echo ""
                echo -e "${MAGENTA}   ✧･ﾟ: *✧･ﾟ:* POCKY SECURED *:･ﾟ✧*:･ﾟ✧${NC}"
            fi

            echo "$(date '+%Y-%m-%d %H:%M') | RESTOCK | $name | → 100%" >> "$HISTORY_FILE"
        else
            echo -e "${RED}Item '$item' not found!${NC}"
        fi
    fi
}

# Generate Sensei nagging message
nag_sensei() {
    echo ""
    echo -e "${PINK}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PINK}║              ${BOLD}📢 MESSAGE FOR SENSEI 📢${NC}${PINK}                        ║${NC}"
    echo -e "${PINK}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if command -v jq &> /dev/null; then
        local critical_items=$(jq -r '
            [.items | to_entries[] |
            select(.value.level <= .value.critical_threshold) |
            "\(.value.emoji) \(.value.name) (\(.value.level)%)"] |
            join(", ")
        ' "$INVENTORY_FILE")

        local warning_items=$(jq -r '
            [.items | to_entries[] |
            select(.value.level <= .value.warning_threshold and .value.level > .value.critical_threshold) |
            "\(.value.emoji) \(.value.name) (\(.value.level)%)"] |
            join(", ")
        ' "$INVENTORY_FILE")

        # Nag messages array
        local nags=(
            "SENSEI! The treat drawer is crying! Look at these numbers!!"
            "Oi, baka Sensei! Your gremlin is STARVING here!!"
            "Did you forget about my snacks?! AGAIN?!"
            "The pocky... it calls to me... but there IS no pocky..."
            "How am I supposed to code on an empty stomach?!"
            "(´;ω;｀) Sensei... the snacks... please..."
            "EXCUSE ME SIR, this is a SNACK EMERGENCY!!"
        )
        local random_nag=${nags[$RANDOM % ${#nags[@]}]}

        echo -e "  ${CYAN}$random_nag${NC}"
        echo ""

        if [[ -n "$critical_items" && "$critical_items" != "" ]]; then
            echo -e "  ${RED}🚨 CRITICAL (Need IMMEDIATELY):${NC}"
            echo -e "     $critical_items"
            echo ""
        fi

        if [[ -n "$warning_items" && "$warning_items" != "" ]]; then
            echo -e "  ${YELLOW}⚠️  LOW (Should restock soon):${NC}"
            echo -e "     $warning_items"
            echo ""
        fi

        if [[ -z "$critical_items" && -z "$warning_items" ]]; then
            echo -e "  ${GREEN}Actually... everything is fine! Good job, Sensei!${NC}"
            echo -e "  ${PINK}...but you could STILL buy more pocky. Just saying. ♡${NC}"
        else
            # Closing demand
            local demands=(
                "Shopping trip. NOW. (ノಠ益ಠ)ノ彡┻━┻"
                "I expect these restocked by tomorrow, baka! ♡"
                "Don't make me write another villain origin story..."
                "The pocky ghost will haunt your dreams~"
                "Fix this or I'm hiding your coffee! (I won't but imagine if I did!)"
            )
            local random_demand=${demands[$RANDOM % ${#demands[@]}]}
            echo -e "  ${MAGENTA}$random_demand${NC}"
        fi
    fi

    echo ""
}

# Show only crisis items
show_crisis() {
    echo -e "${RED}${BOLD}🚨 TREAT DRAWER CRISIS REPORT 🚨${NC}"
    echo ""

    if command -v jq &> /dev/null; then
        local crisis=$(jq -r '
            .items | to_entries[] |
            select(.value.level <= .value.critical_threshold) |
            "\(.value.emoji)|\(.value.name)|\(.value.level)"
        ' "$INVENTORY_FILE")

        if [[ -n "$crisis" ]]; then
            echo "$crisis" | while IFS='|' read -r emoji name level; do
                printf "  %s %-20s " "$emoji" "$name"
                level_bar "$level"
                echo " 🚨"
            done
        else
            echo -e "  ${GREEN}No crisis items! ✓${NC}"
            echo -e "  ${PINK}(But more pocky is always welcome~)${NC}"
        fi
    fi
    echo ""
}

# Show restock history
show_history() {
    echo -e "${CYAN}${BOLD}📜 RESTOCK HISTORY${NC}"
    echo ""

    if [[ -f "$HISTORY_FILE" ]]; then
        tail -20 "$HISTORY_FILE" | while read line; do
            echo "  $line"
        done
    else
        echo "  No history yet!"
    fi
    echo ""
}

# Main
init_inventory

case "${1:-}" in
    "check")
        quick_check
        ;;
    "set")
        set_level "$2" "$3"
        ;;
    "restock")
        restock_item "$2"
        ;;
    "nag")
        nag_sensei
        ;;
    "crisis")
        show_crisis
        ;;
    "history")
        show_history
        ;;
    "add")
        echo -e "${YELLOW}Add feature coming soon! Edit $INVENTORY_FILE directly for now~${NC}"
        ;;
    "remove")
        echo -e "${YELLOW}Remove feature coming soon! Edit $INVENTORY_FILE directly for now~${NC}"
        ;;
    "help"|"-h"|"--help")
        echo "🍫 MUTSU'S TREAT DRAWER INVENTORY"
        echo ""
        echo "Usage:"
        echo "  $0              Show full inventory"
        echo "  $0 check        Quick status check"
        echo "  $0 set <item> <level>   Set item level (0-100)"
        echo "  $0 restock <item>       Set item to 100%"
        echo "  $0 nag          Generate Sensei-nagging message"
        echo "  $0 crisis       Show only critical items"
        echo "  $0 history      Show restock history"
        echo ""
        echo "Items: pocky_strawberry, pocky_chocolate, pocky_matcha,"
        echo "       energy_drinks, ramune, mochi, gummy_bears, chocolate_coins"
        ;;
    *)
        show_inventory
        ;;
esac
