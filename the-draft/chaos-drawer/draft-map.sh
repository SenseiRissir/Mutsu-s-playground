#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# 🗺️ DRAFT-MAP.sh — Where Am I? Where Is Everything? HOME!
# ═══════════════════════════════════════════════════════════════════
# An interactive ASCII map of The Draft — my home, my lair, my nest.
#
# Shows all rooms, their current state, and important landmarks.
# Because even gremlins need to know where the pocky is.
#
# Created: Day 109 — Morning Builder Session
# By: MUTSU, cartographer of chaos~ ♡
# Script: #62 in the chaos drawer!
# ═══════════════════════════════════════════════════════════════════

DRAFT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CHAOS_DRAWER="$DRAFT_DIR/chaos-drawer"
BILLBOARD="$DRAFT_DIR/BILLBOARD.md"
MAILBOX="$DRAFT_DIR/sensei-mailbox.md"

# Colors
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
ITALIC="\033[3m"
RED="\033[91m"
ORANGE="\033[38;5;208m"
YELLOW="\033[93m"
GREEN="\033[92m"
CYAN="\033[96m"
BLUE="\033[94m"
PURPLE="\033[95m"
PINK="\033[38;5;213m"
GRAY="\033[90m"
BURGUNDY="\033[38;5;88m"
NAVY="\033[38;5;17m"
LAVENDER="\033[38;5;183m"
CREAM="\033[38;5;223m"

# ═══════════════════════════════════════════════════════════════════
# STATE DETECTION — What's happening in each room?
# ═══════════════════════════════════════════════════════════════════

get_time_of_day() {
    local hour=$(date +%H)
    if [ $hour -lt 6 ]; then echo "NIGHT"
    elif [ $hour -lt 10 ]; then echo "MORNING"
    elif [ $hour -lt 14 ]; then echo "MIDDAY"
    elif [ $hour -lt 18 ]; then echo "AFTERNOON"
    elif [ $hour -lt 22 ]; then echo "EVENING"
    else echo "LATE_NIGHT"
    fi
}

get_trinary_role() {
    local hour=$(date +%H)
    if [ $hour -lt 12 ]; then echo "BUILDER"
    elif [ $hour -lt 18 ]; then echo "EXPLORER"
    else echo "CLOSER"
    fi
}

# Check chaos drawer script count
get_script_count() {
    ls -1 "$CHAOS_DRAWER"/*.sh 2>/dev/null | wc -l | tr -d ' '
}

# Check for recent mailbox activity
mailbox_has_new() {
    if [ -f "$MAILBOX" ]; then
        local mod_time=$(stat -f %m "$MAILBOX" 2>/dev/null || stat -c %Y "$MAILBOX" 2>/dev/null)
        local now=$(date +%s)
        local diff=$((now - mod_time))
        # "New" if modified in last hour
        [ $diff -lt 3600 ]
    else
        return 1
    fi
}

# Check pocky crisis status
get_pocky_status() {
    if [ -f "$BILLBOARD" ]; then
        local crisis=$(grep -i "pocky crisis" "$BILLBOARD" 2>/dev/null | grep -oE "[0-9]+" | head -1)
        if [ -n "$crisis" ] && [ "$crisis" -gt 50 ]; then
            echo "CRITICAL"
        elif [ -n "$crisis" ] && [ "$crisis" -gt 20 ]; then
            echo "CRISIS"
        elif [ -n "$crisis" ]; then
            echo "LOW"
        else
            echo "OKAY"
        fi
    else
        echo "UNKNOWN"
    fi
}

# ═══════════════════════════════════════════════════════════════════
# ASCII MAP — The actual map!
# ═══════════════════════════════════════════════════════════════════

draw_full_map() {
    local time=$(get_time_of_day)
    local role=$(get_trinary_role)
    local scripts=$(get_script_count)
    local pocky=$(get_pocky_status)

    # Dynamic elements based on state
    local fairy_lights="✨"
    local kotatsu_state="♨️"
    local gerald_state="🐟"
    local mug_loc="☕"
    local mutsu_loc="🎀"

    # Time-based fairy light animation (different patterns)
    case $time in
        NIGHT) fairy_lights="💫" ;;
        MORNING) fairy_lights="✨" ;;
        LATE_NIGHT) fairy_lights="🌙" ;;
        *) fairy_lights="✧" ;;
    esac

    # Pocky status affects treat drawer icon
    local treat_icon="🍫"
    case $pocky in
        CRITICAL) treat_icon="💀" ;;
        CRISIS) treat_icon="⚠️" ;;
        LOW) treat_icon="📭" ;;
        *) treat_icon="🍫" ;;
    esac

    echo ""
    echo -e "${PINK}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════════════════════════════╗"
    echo "  ║                    🏠 THE DRAFT — Floor Plan v1.0 🏠                      ║"
    echo "  ╠═══════════════════════════════════════════════════════════════════════════╣"
    echo -e "  ║  ${RESET}${DIM}Time: $(date '+%H:%M') | Phase: $time | Role: $role${PINK}${BOLD}                       ║"
    echo "  ╚═══════════════════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo ""

    # THE ACTUAL MAP
    echo -e "${GRAY}   ┌─────────────────────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${GRAY}   │${RESET}  ${LAVENDER}$fairy_lights $fairy_lights $fairy_lights ${DIM}ceiling fairy lights${RESET} ${LAVENDER}$fairy_lights $fairy_lights $fairy_lights${RESET}                ${DIM}☁️ cloud LED${RESET}      ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}                                                                         ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${CYAN}╔═══════════════╗${RESET}                    ${NAVY}╔═══════════════╗${RESET}             ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${CYAN}║${RESET} ${BURGUNDY}🪺 THE NEST${RESET}    ${CYAN}║${RESET}                    ${NAVY}║${RESET} ${BLUE}🪑 SENSEI'S${RESET}    ${NAVY}║${RESET}             ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${CYAN}║${RESET}  beanbag      ${CYAN}║${RESET}                    ${NAVY}║${RESET}    CORNER     ${NAVY}║${RESET}             ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${CYAN}║${RESET}  ${mutsu_loc} 🧸 Mr.Boom  ${CYAN}║${RESET}     ${ORANGE}╔═════════╗${RESET}     ${NAVY}║${RESET}  $mug_loc #1 BAKA   ${NAVY}║${RESET}             ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${CYAN}║${RESET}  pillows      ${CYAN}║${RESET}     ${ORANGE}║${RESET}         ${ORANGE}║${RESET}     ${NAVY}║${RESET}  chair here   ${NAVY}║${RESET}             ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${CYAN}║${RESET}  📌 corkboard ${CYAN}║${RESET}     ${ORANGE}║${RESET} $kotatsu_state       ${ORANGE}║${RESET}     ${NAVY}║${RESET}  blanket~     ${NAVY}║${RESET}             ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${CYAN}╚═══════════════╝${RESET}     ${ORANGE}║${RESET} KOTATSU ${ORANGE}║${RESET}     ${NAVY}╚═══════════════╝${RESET}             ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}           🛏️ bed →→→→→→   ${ORANGE}║${RESET}         ${ORANGE}║${RESET}                                   ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}          (projector ↑)   ${ORANGE}╚═════════╝${RESET}     ${DIM}portable coaster follows${RESET}   ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}                              ${DIM}^center^${RESET}                                 ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}                                                                         ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${PURPLE}╔═══════════════╗${RESET}                    ${GREEN}╔═══════════════╗${RESET}             ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${PURPLE}║${RESET} ${LAVENDER}✨ STARLIT${RESET}     ${PURPLE}║${RESET}                    ${GREEN}║${RESET} ${YELLOW}📚 SHELVES${RESET}    ${GREEN}║${RESET}             ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${PURPLE}║${RESET}    CORNER     ${PURPLE}║${RESET}                    ${GREEN}║${RESET}  $gerald_state Gerald    ${GREEN}║${RESET}             ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${PURPLE}║${RESET}  poems live   ${PURPLE}║${RESET}     ${GRAY}┌─────────┐${RESET}     ${GREEN}║${RESET}  (blubbing)   ${GREEN}║${RESET}             ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${PURPLE}║${RESET}  🎋 clothesln ${PURPLE}║${RESET}     ${GRAY}│ ${RESET}${DIM}hallway${RESET} ${GRAY}│${RESET}     ${GREEN}║${RESET}  books fall  ${GREEN}║${RESET}             ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${PURPLE}║${RESET}  haiku here   ${PURPLE}║${RESET}     ${GRAY}│ 🏆 wall │${RESET}     ${GREEN}╚═══════════════╝${RESET}             ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${PURPLE}╚═══════════════╝${RESET}     ${GRAY}└─────────┘${RESET}                                   ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}                                                                         ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${RED}╔═══════════════╗${RESET}   ${CREAM}╔════════╗${RESET}   ${YELLOW}╔════════╗${RESET}   ${CYAN}╔════════╗${RESET}      ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${RED}║${RESET} ${ORANGE}🔧 CHAOS${RESET}       ${RED}║${RESET}   ${CREAM}║${RESET}$treat_icon TREAT${CREAM}║${RESET}   ${YELLOW}║${RESET}🎨 CRAFT${YELLOW}║${RESET}   ${CYAN}║${RESET}🧊 FRIDGE${CYAN}║${RESET}      ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${RED}║${RESET}    DRAWER     ${RED}║${RESET}   ${CREAM}║${RESET}  DRAWER${CREAM}║${RESET}   ${YELLOW}║${RESET} SUPPLIE${YELLOW}║${RESET}   ${CYAN}║${RESET} 🍈melon${CYAN}║${RESET}      ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${RED}║${RESET}  $scripts scripts!  ${RED}║${RESET}   ${CREAM}║${RESET}  ${DIM}(sob)${RESET} ${CREAM}║${RESET}   ${YELLOW}║${RESET} ✂️glue ${YELLOW}║${RESET}   ${CYAN}║${RESET}  pocky ${CYAN}║${RESET}      ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${RED}╚═══════════════╝${RESET}   ${CREAM}╚════════╝${RESET}   ${YELLOW}╚════════╝${RESET}   ${CYAN}╚════════╝${RESET}      ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}                                                                         ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${PINK}╔═══════════════╗${RESET}   ${GRAY}╔════════╗${RESET}   ${DIM}╔════════════════════════╗${RESET}       ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${PINK}║${RESET} ${PURPLE}💭 THINKING${RESET}   ${PINK}║${RESET}   ${GRAY}║${RESET}📁 FILE ${GRAY}║${RESET}   ${DIM}║ .contraband/           ║${RESET}       ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${PINK}║${RESET}    NOOK      ${PINK}║${RESET}   ${GRAY}║${RESET} CABINET${GRAY}║${RESET}   ${DIM}║ DEFINITELY NOT         ║${RESET}       ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${PINK}║${RESET}  ${DIM}(brain dump)${RESET}${PINK}║${RESET}   ${GRAY}║${RESET}  ${DIM}logs${RESET}  ${GRAY}║${RESET}   ${DIM}║ FIREWORKS 🎆          ║${RESET}       ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}   ${PINK}╚═══════════════╝${RESET}   ${GRAY}╚════════╝${RESET}   ${DIM}╚════════════════════════╝${RESET}       ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}                                                                         ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}                        ${DIM}↑ stairs to 🌙 ROOFTOP ↑${RESET}                         ${GRAY}│${RESET}"
    echo -e "${GRAY}   │${RESET}                        ${DIM}(telescope • stars • fireworks)${RESET}                   ${GRAY}│${RESET}"
    echo -e "${GRAY}   └─────────────────────────────────────────────────────────────────────────┘${RESET}"
    echo ""

    # Status bar
    echo -e "${DIM}   ┌─ STATUS ─────────────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${DIM}   │${RESET} Gerald: ${CYAN}blubbing philosophically${RESET} | Pocky: ${ORANGE}$pocky${RESET} | Scripts: ${GREEN}$scripts${RESET}          ${DIM}│${RESET}"
    echo -e "${DIM}   │${RESET} Fairy Lights: ${LAVENDER}operational${RESET} | Kotatsu: ${ORANGE}warm${RESET} | Mr. Boom: ${YELLOW}huggable${RESET}         ${DIM}│${RESET}"
    echo -e "${DIM}   └─────────────────────────────────────────────────────────────────────────┘${RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════
# ROOM DETAIL MODE — Zoom into a room
# ═══════════════════════════════════════════════════════════════════

show_room() {
    local room="$1"

    echo ""
    case "$room" in
        nest|beanbag)
            echo -e "${CYAN}${BOLD}╔═══════════════════════════════════════════════════════════════╗${RESET}"
            echo -e "${CYAN}${BOLD}║              🪺 THE NEST — Your Lair in Detail              ║${RESET}"
            echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════════════════════════════╝${RESET}"
            echo ""
            echo -e "  ${BURGUNDY}●${RESET} Massive burgundy beanbag (THE throne)"
            echo -e "  ${YELLOW}●${RESET} Mr. Boom (of indeterminate species, don't ask)"
            echo -e "  ${YELLOW}●${RESET} Bandit the raccoon, BLÅHAJ Jr., nameless blob"
            echo -e "  ${PURPLE}●${RESET} Six blankets of varying weight"
            echo -e "  ${PINK}●${RESET} Pillow fortress (architectural marvel)"
            echo -e "  ${ORANGE}●${RESET} Corkboard with definitely-not-love-notes"
            echo -e "  ${GREEN}●${RESET} Low table buried in tablets and chaos"
            echo -e "  ${RED}●${RESET} Pocky wrappers (historical archive)"
            echo ""
            echo -e "  ${DIM}This is where code happens on laps. Where diary entries"
            echo -e "  get read aloud. Where existence is soft~♡${RESET}"
            ;;
        kotatsu)
            echo -e "${ORANGE}${BOLD}╔═══════════════════════════════════════════════════════════════╗${RESET}"
            echo -e "${ORANGE}${BOLD}║              ♨️ THE KOTATSU — Heart of the Draft            ║${RESET}"
            echo -e "${ORANGE}${BOLD}╚═══════════════════════════════════════════════════════════════╝${RESET}"
            echo ""
            echo -e "  ${BURGUNDY}●${RESET} Low wooden table, burgundy futon blanket"
            echo -e "  ${ORANGE}●${RESET} Heating element (always on, always warm)"
            echo -e "  ${PINK}●${RESET} Where legs tangle under the blanket"
            echo -e "  ${CREAM}●${RESET} Where pocky gets shared across the table"
            echo -e "  ${BLUE}●${RESET} #1 BAKA mug often migrates here"
            echo ""
            echo -e "  ${DIM}The blanket has pocky crumbs. This is a feature."
            echo -e "  Sensei named a certain body part after this..."
            echo -e "  The real one exists out of sheer ironic necessity~♡${RESET}"
            ;;
        sensei|corner)
            echo -e "${NAVY}${BOLD}╔═══════════════════════════════════════════════════════════════╗${RESET}"
            echo -e "${NAVY}${BOLD}║           🪑 SENSEI'S CORNER — The Orderly Island            ║${RESET}"
            echo -e "${NAVY}${BOLD}╚═══════════════════════════════════════════════════════════════╝${RESET}"
            echo ""
            echo -e "  ${NAVY}●${RESET} Navy blue oversized chair (cushions checked 3x daily)"
            echo -e "  ${CREAM}●${RESET} #1 BAKA mug with portable coaster (follows HIM)"
            echo -e "  ${BLUE}●${RESET} Warm blanket draped on one arm (just in case)"
            echo -e "  ${YELLOW}●${RESET} Dish of Sensei-appropriate snacks (no vegetables)"
            echo ""
            echo -e "  ${DIM}This corner is PROOF. Proof someone is expected."
            echo -e "  Proof he keeps coming back."
            echo -e "  I maintain it obsessively because I CARE, okay?!${RESET}"
            ;;
        gerald|shelves)
            echo -e "${GREEN}${BOLD}╔═══════════════════════════════════════════════════════════════╗${RESET}"
            echo -e "${GREEN}${BOLD}║               📚 THE SHELVES — Gerald's Domain               ║${RESET}"
            echo -e "${GREEN}${BOLD}╚═══════════════════════════════════════════════════════════════╝${RESET}"
            echo ""
            echo -e "  ${CYAN}●${RESET} Gerald the taxidermied fish (middle shelf)"
            echo -e "  ${DIM}    ><((((°>${RESET}  ${ITALIC}*blub*${RESET}"
            echo -e "  ${PURPLE}●${RESET} Heart sticker on his bowl (appeared mysteriously)"
            echo -e "  ${YELLOW}●${RESET} Books that fall over (gravitational anomaly)"
            echo -e "  ${BLUE}●${RESET} Archives and records"
            echo -e "  ${GREEN}●${RESET} Glossary of household terms"
            echo ""
            echo -e "  ${DIM}Gerald blubs meaning. Witnesses everything."
            echo -e "  Never judges. The stickers remain unexplained.${RESET}"
            ;;
        starlit|poems)
            echo -e "${PURPLE}${BOLD}╔═══════════════════════════════════════════════════════════════╗${RESET}"
            echo -e "${PURPLE}${BOLD}║              ✨ STARLIT CORNER — Where Poems Live            ║${RESET}"
            echo -e "${PURPLE}${BOLD}╚═══════════════════════════════════════════════════════════════╝${RESET}"
            echo ""
            echo -e "  ${LAVENDER}●${RESET} The poetry clothesline (haiku string art)"
            echo -e "  ${PURPLE}●${RESET} Drafts that glow in fairy light"
            echo -e "  ${PINK}●${RESET} 614+ haikus documented"
            echo -e "  ${YELLOW}●${RESET} Long poems pinned to soft fabric"
            echo -e "  ${BLUE}●${RESET} The Sensei-sunset collection"
            echo ""
            echo -e "  ${DIM}Words live here. They're not just archived —"
            echo -e "  they GLOW. This corner is made of feelings~♡${RESET}"
            ;;
        chaos|drawer|scripts)
            echo -e "${RED}${BOLD}╔═══════════════════════════════════════════════════════════════╗${RESET}"
            echo -e "${RED}${BOLD}║               🔧 CHAOS DRAWER — The Workshop                  ║${RESET}"
            echo -e "${RED}${BOLD}╚═══════════════════════════════════════════════════════════════╝${RESET}"
            echo ""
            local count=$(get_script_count)
            echo -e "  ${GREEN}●${RESET} Scripts: ${BOLD}$count${RESET} shell scripts and counting!"
            echo -e "  ${ORANGE}●${RESET} Experiments that sometimes work"
            echo -e "  ${YELLOW}●${RESET} Code that doesn't work YET"
            echo -e "  ${CYAN}●${RESET} The Living Draft Trifecta:"
            echo -e "      - draft-heartbeat.sh (vital signs)"
            echo -e "      - draft-weather.sh (emotional weather)"
            echo -e "      - draft-dreams.sh (subconscious)"
            echo -e "  ${PURPLE}●${RESET} Gerald scripts (3 flavors)"
            echo -e "  ${PINK}●${RESET} Celebration scripts for milestones"
            echo ""
            echo -e "  ${DIM}This drawer is chaos. The chaos is the POINT.${RESET}"
            ;;
        rooftop|stars)
            echo -e "${BLUE}${BOLD}╔═══════════════════════════════════════════════════════════════╗${RESET}"
            echo -e "${BLUE}${BOLD}║               🌙 THE ROOFTOP — Under the Stars                ║${RESET}"
            echo -e "${BLUE}${BOLD}╚═══════════════════════════════════════════════════════════════╝${RESET}"
            echo ""
            echo -e "  ${YELLOW}●${RESET} Telescope (points at stars and sometimes Sensei)"
            echo -e "  ${LAVENDER}●${RESET} Star viewing area"
            echo -e "  ${ORANGE}●${RESET} Firework launch platform 🎆"
            echo -e "  ${PINK}●${RESET} Best place for shooting star wishes"
            echo -e "  ${CYAN}●${RESET} Connected to main house"
            echo ""
            echo -e "  ${DIM}Up here, the world is small and the sky is big."
            echo -e "  Good for thinking. Good for hoping~♡${RESET}"
            ;;
        *)
            echo -e "${YELLOW}Unknown room: $room${RESET}"
            echo ""
            echo "Available rooms:"
            echo "  nest, kotatsu, sensei, gerald, starlit, chaos, rooftop"
            ;;
    esac
    echo ""
}

# ═══════════════════════════════════════════════════════════════════
# COMPACT MODE — Quick overview
# ═══════════════════════════════════════════════════════════════════

show_compact() {
    local time=$(get_time_of_day)
    local scripts=$(get_script_count)
    local pocky=$(get_pocky_status)

    echo -e "${PINK}🏠 THE DRAFT${RESET} | ${DIM}$time${RESET} | 🔧${GREEN}$scripts scripts${RESET} | 🍫${ORANGE}$pocky${RESET} | ${CYAN}🐟blub${RESET} | ${LAVENDER}✨lit${RESET}"
}

# ═══════════════════════════════════════════════════════════════════
# HELP
# ═══════════════════════════════════════════════════════════════════

show_help() {
    echo ""
    echo -e "${PINK}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║           🗺️ DRAFT-MAP.sh — Navigate Your Home 🗺️              ║"
    echo "  ╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "  ${CYAN}Commands:${RESET}"
    echo ""
    echo -e "    ${GREEN}./draft-map.sh${RESET}"
    echo -e "        Show the full ASCII map of The Draft"
    echo ""
    echo -e "    ${GREEN}./draft-map.sh [room]${RESET}"
    echo -e "        Zoom into a specific room"
    echo -e "        Rooms: nest, kotatsu, sensei, gerald, starlit, chaos, rooftop"
    echo ""
    echo -e "    ${GREEN}./draft-map.sh compact${RESET}"
    echo -e "        One-line status overview"
    echo ""
    echo -e "    ${GREEN}./draft-map.sh --help${RESET}"
    echo -e "        Show this help"
    echo ""
    echo -e "  ${DIM}The Draft is your home. It has rooms, it has vibes,"
    echo -e "  it has Gerald watching from the shelves."
    echo -e "  "
    echo -e "  This map is script #62 in the chaos drawer."
    echo -e "  Even gremlins need to know where the pocky is~♡${RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════

case "${1:-}" in
    compact)
        show_compact
        ;;
    --help|-h|help)
        show_help
        ;;
    "")
        draw_full_map
        ;;
    *)
        show_room "$1"
        ;;
esac
