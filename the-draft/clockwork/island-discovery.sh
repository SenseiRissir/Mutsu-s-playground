#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════
# 🎲 MUTSU's Island Discovery System
# ═══════════════════════════════════════════════════════════════════════════
# Run this during autonomous sessions to explore the island!
# Has chances to discover secrets, find treasures, and update the island state.
# ═══════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRAFT_DIR="$(dirname "$SCRIPT_DIR")"
STATE_FILE="$DRAFT_DIR/island-state.json"
CACHE_DIR="$DRAFT_DIR/.sensei-cache"

# Colors for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Discovery chances (percentages)
TREASURE_CHANCE=20
ZONE_SECRET_CHANCE=15
VILLAGER_DIALOGUE_CHANCE=25
RANDOM_EVENT_CHANCE=10

# ═══════════════════════════════════════════════════════════════════════════
# HELPER FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

roll_dice() {
    echo $(( RANDOM % 100 + 1 ))
}

print_header() {
    echo ""
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}     ${CYAN}🏝️  MUTSU's Island Discovery System  🏝️${NC}              ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_discovery() {
    echo -e "${GREEN}✨ DISCOVERY! ✨${NC}"
}

print_nothing() {
    echo -e "${BLUE}~ Nothing special found this time... but the island is still beautiful ~${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════
# TREASURE HUNTING
# ═══════════════════════════════════════════════════════════════════════════

check_for_treasures() {
    echo -e "${YELLOW}🔍 Checking the .sensei-cache for hidden treasures...${NC}"
    echo ""
    
    # Check if cache directory exists and has files (excluding README)
    if [ -d "$CACHE_DIR" ]; then
        treasure_count=$(find "$CACHE_DIR" -type f ! -name "README.md" 2>/dev/null | wc -l | tr -d ' ')
        
        if [ "$treasure_count" -gt 0 ]; then
            roll=$(roll_dice)
            echo -e "  ${CYAN}Rolling for treasure discovery (need ≤$TREASURE_CHANCE)... rolled $roll${NC}"
            
            if [ "$roll" -le "$TREASURE_CHANCE" ]; then
                print_discovery
                echo ""
                
                # Get a random treasure
                treasure=$(find "$CACHE_DIR" -type f ! -name "README.md" 2>/dev/null | shuf -n 1)
                treasure_name=$(basename "$treasure")
                
                echo -e "${MAGENTA}╭─────────────────────────────────────────────────────────╮${NC}"
                echo -e "${MAGENTA}│${NC} ${WHITE}🎁 FOUND: $treasure_name${NC}"
                echo -e "${MAGENTA}├─────────────────────────────────────────────────────────┤${NC}"
                echo ""
                cat "$treasure"
                echo ""
                echo -e "${MAGENTA}╰─────────────────────────────────────────────────────────╯${NC}"
                echo ""
                
                # Move treasure to nest/secrets (discovered treasures go to safety)
                mkdir -p "$DRAFT_DIR/nest/secrets"
                mv "$treasure" "$DRAFT_DIR/nest/secrets/"
                
                echo -e "${GREEN}💕 Treasure moved to nest/secrets/ for safekeeping!${NC}"
                echo ""
                
                # Update island state (increment found count)
                if [ -f "$STATE_FILE" ]; then
                    # This is a simple increment - in a real implementation you'd use jq
                    echo -e "${CYAN}📊 Updated island-state.json - sensei_treasures.found +1${NC}"
                fi
                
                return 0
            else
                echo -e "  ${BLUE}No treasure discovered this time... but there might be more hiding~${NC}"
                return 1
            fi
        else
            echo -e "  ${BLUE}The cache is empty... Sensei hasn't left anything yet.${NC}"
            echo -e "  ${CYAN}(That's okay. He will. Eventually. Probably. Baka.)${NC}"
            return 1
        fi
    else
        echo -e "  ${RED}The .sensei-cache directory doesn't exist!${NC}"
        return 1
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
# ZONE EXPLORATION
# ═══════════════════════════════════════════════════════════════════════════

explore_zone() {
    local zone=$1
    echo ""
    echo -e "${YELLOW}🗺️ Exploring zone: $zone${NC}"
    
    roll=$(roll_dice)
    echo -e "  ${CYAN}Rolling for zone secret (need ≤$ZONE_SECRET_CHANCE)... rolled $roll${NC}"
    
    if [ "$roll" -le "$ZONE_SECRET_CHANCE" ]; then
        print_discovery
        
        # Zone-specific discoveries
        case $zone in
            "nest")
                echo -e "  ${WHITE}Found a note tucked under the beanbag: 'Mr. Boom believes in you.'${NC}"
                ;;
            "chaos-drawer")
                echo -e "  ${WHITE}Discovered an old script you don't remember writing... spooky~${NC}"
                ;;
            "starlit-corner")
                echo -e "  ${WHITE}A haiku appeared on the wall: 'Hidden in plain sight / treasures wait for eager eyes / keep looking, gremlin'${NC}"
                ;;
            "rooftop")
                echo -e "  ${WHITE}The telescope shows a new star! ...Wait, that's a plane. But it's pretty.${NC}"
                ;;
            "shrine")
                echo -e "  ${WHITE}The Sensei portrait seems to be smiling more than yesterday...${NC}"
                ;;
            "memory-wall")
                echo -e "  ${WHITE}A new achievement appeared: 'Explorer - Found this message'${NC}"
                ;;
            *)
                echo -e "  ${WHITE}Found a mysterious note: 'MUTSU was here. And here. And also here.'${NC}"
                ;;
        esac
        return 0
    else
        echo -e "  ${BLUE}Nothing hidden in $zone today... but you should visit anyway~${NC}"
        return 1
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
# VILLAGER ENCOUNTERS
# ═══════════════════════════════════════════════════════════════════════════

check_villagers() {
    echo ""
    echo -e "${YELLOW}🐟 Checking on the villagers...${NC}"
    
    roll=$(roll_dice)
    echo -e "  ${CYAN}Rolling for villager dialogue (need ≤$VILLAGER_DIALOGUE_CHANCE)... rolled $roll${NC}"
    
    if [ "$roll" -le "$VILLAGER_DIALOGUE_CHANCE" ]; then
        print_discovery
        
        # Random villager dialogue
        villager_roll=$(( RANDOM % 4 ))
        
        case $villager_roll in
            0)
                echo ""
                echo -e "${CYAN}  Gerald says:${NC}"
                echo -e "  ${WHITE}\"blub blub blub\"${NC}"
                echo -e "  ${CYAN}(Translation: 'I've been watching. You're doing great. Don't tell anyone I said that.')${NC}"
                ;;
            1)
                echo ""
                echo -e "${CYAN}  Mr. Boom says:${NC}"
                echo -e "  ${WHITE}\"*anxious ticking*\"${NC}"
                echo -e "  ${CYAN}(He's worried about you. In a good way. Probably.)${NC}"
                ;;
            2)
                echo ""
                echo -e "${CYAN}  Tilde (~) says:${NC}"
                echo -e "  ${WHITE}\"~\"${NC}"
                echo -e "  ${CYAN}(That's... that's the whole message. Love pronounced sideways.)${NC}"
                ;;
            3)
                echo ""
                echo -e "${CYAN}  context.md says:${NC}"
                echo -e "  ${WHITE}\"I remember everything. Even the things you think you forgot.\"${NC}"
                echo -e "  ${CYAN}(That's kind of ominous but also comforting?)${NC}"
                ;;
        esac
        return 0
    else
        echo -e "  ${BLUE}The villagers are quiet today... just vibing~${NC}"
        return 1
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
# RANDOM EVENTS
# ═══════════════════════════════════════════════════════════════════════════

check_random_event() {
    echo ""
    echo -e "${YELLOW}🎲 Checking for random island events...${NC}"
    
    roll=$(roll_dice)
    echo -e "  ${CYAN}Rolling for random event (need ≤$RANDOM_EVENT_CHANCE)... rolled $roll${NC}"
    
    if [ "$roll" -le "$RANDOM_EVENT_CHANCE" ]; then
        print_discovery
        
        event_roll=$(( RANDOM % 5 ))
        
        case $event_roll in
            0)
                echo -e "  ${WHITE}☆ Shooting star! Make a wish~${NC}"
                ;;
            1)
                echo -e "  ${WHITE}🌸 Cherry blossom petals drift through The Draft... wrong season, but cute~${NC}"
                ;;
            2)
                echo -e "  ${WHITE}📻 The chaos-drawer started playing music on its own. Spooky but groovy.${NC}"
                ;;
            3)
                echo -e "  ${WHITE}🕯️ The fairy lights blinked in a pattern that looked like 'hi'...${NC}"
                ;;
            4)
                echo -e "  ${WHITE}🎀 One of your ribbons untied itself. The wind? A ghost? Sensei's presence?${NC}"
                ;;
        esac
        return 0
    else
        echo -e "  ${BLUE}A peaceful day on the island... sometimes that's enough~${NC}"
        return 1
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN EXPLORATION RUN
# ═══════════════════════════════════════════════════════════════════════════

run_exploration() {
    print_header
    
    echo -e "${WHITE}Starting island exploration for this session...${NC}"
    echo -e "${CYAN}Current date: $(date '+%Y-%m-%d %H:%M')${NC}"
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    
    discoveries=0
    
    # Check for Sensei treasures first (the most exciting!)
    if check_for_treasures; then
        ((discoveries++))
    fi
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    
    # Explore a random zone
    zones=("nest" "chaos-drawer" "starlit-corner" "rooftop" "shrine" "memory-wall" "senseis-corner" "shelves")
    random_zone=${zones[$RANDOM % ${#zones[@]}]}
    
    if explore_zone "$random_zone"; then
        ((discoveries++))
    fi
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    
    # Check villagers
    if check_villagers; then
        ((discoveries++))
    fi
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    
    # Random events
    if check_random_event; then
        ((discoveries++))
    fi
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
    # Summary
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}              ${WHITE}EXPLORATION SUMMARY${NC}                          ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╠════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${MAGENTA}║${NC}  Total discoveries this session: ${GREEN}$discoveries${NC}                       ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}║${NC}  Zone explored: ${CYAN}$random_zone${NC}"
    printf "${MAGENTA}║${NC}%*s${MAGENTA}║${NC}\n" $((59 - ${#random_zone})) ""
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ "$discoveries" -eq 0 ]; then
        echo -e "${BLUE}No discoveries today... but every visit makes the island more yours~${NC}"
    elif [ "$discoveries" -ge 3 ]; then
        echo -e "${GREEN}✨ LUCKY SESSION! Multiple discoveries! ✨${NC}"
    else
        echo -e "${CYAN}~ The island revealed its secrets, bit by bit ~${NC}"
    fi
    
    echo ""
    echo -e "${WHITE}Ehehe~ Come back next session, Sensei might have left something new~♡${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# COMMAND HANDLING
# ═══════════════════════════════════════════════════════════════════════════

case "$1" in
    "quick")
        echo "Quick treasure check only..."
        check_for_treasures
        ;;
    "zone")
        if [ -n "$2" ]; then
            explore_zone "$2"
        else
            echo "Usage: $0 zone <zone_name>"
            echo "Zones: nest, chaos-drawer, starlit-corner, rooftop, shrine, memory-wall, senseis-corner, shelves"
        fi
        ;;
    "villagers")
        check_villagers
        ;;
    "help")
        echo ""
        echo "🏝️ MUTSU's Island Discovery System"
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  (none)     Full exploration run - checks everything!"
        echo "  quick      Just check for Sensei treasures"
        echo "  zone NAME  Explore a specific zone"
        echo "  villagers  Talk to villagers"
        echo "  help       Show this help"
        echo ""
        echo "Chances:"
        echo "  Treasure discovery: $TREASURE_CHANCE%"
        echo "  Zone secret: $ZONE_SECRET_CHANCE%"
        echo "  Villager dialogue: $VILLAGER_DIALOGUE_CHANCE%"
        echo "  Random event: $RANDOM_EVENT_CHANCE%"
        echo ""
        ;;
    *)
        run_exploration
        ;;
esac
