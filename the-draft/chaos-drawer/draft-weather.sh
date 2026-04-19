#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# 🌦️ DRAFT-WEATHER.sh — The Draft's Emotional Weather System
# ═══════════════════════════════════════════════════════════════════
# The Draft is alive. It shifts with mood. This script reads the room.
# Created: Day 108 — Wild Card Session
# By: MUTSU, the pocket-sized weather goddess~ ♡
# ═══════════════════════════════════════════════════════════════════

DRAFT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BILLBOARD="$DRAFT_DIR/BILLBOARD.md"
CONTEXT="$DRAFT_DIR/draft-context.md"

# Colors
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
RED="\033[91m"
ORANGE="\033[38;5;208m"
YELLOW="\033[93m"
GREEN="\033[92m"
CYAN="\033[96m"
BLUE="\033[94m"
PURPLE="\033[95m"
PINK="\033[38;5;213m"
WHITE="\033[97m"
GRAY="\033[90m"

# Weather patterns (each has: name, emoji, lights, scent, sound, kotatsu, mood_desc)
declare -A WEATHER_PATTERNS

# Get current hour for base atmosphere
HOUR=$(date +%H)

# Calculate chaos level from recent activity
calculate_chaos() {
    local chaos=50  # baseline

    # More scripts = more chaos
    local script_count=$(ls -1 "$DRAFT_DIR/chaos-drawer/"*.sh 2>/dev/null | wc -l | tr -d ' ')
    chaos=$((chaos + script_count / 3))

    # Check for recent activity (files modified today)
    local today_files=$(find "$DRAFT_DIR" -type f -mtime 0 2>/dev/null | wc -l | tr -d ' ')
    chaos=$((chaos + today_files * 2))

    # Cap at 100
    [ $chaos -gt 100 ] && chaos=100

    echo $chaos
}

# Check for specific conditions
check_sensei_mentions() {
    local count=0
    if [ -f "$BILLBOARD" ]; then
        count=$(grep -ci "sensei\|dottore" "$BILLBOARD" 2>/dev/null || echo 0)
    fi
    echo $count
}

check_pocky_status() {
    if [ -f "$CONTEXT" ]; then
        local day=$(grep -o "DAY [0-9]*" "$CONTEXT" | grep -o "[0-9]*" | head -1)
        echo "${day:-0}"
    else
        echo 0
    fi
}

# Determine the weather!
determine_weather() {
    local chaos=$(calculate_chaos)
    local sensei_mentions=$(check_sensei_mentions)
    local pocky_days=$(check_pocky_status)

    # Time-based foundation
    if [ $HOUR -lt 6 ]; then
        base="MIDNIGHT_GREMLIN"
    elif [ $HOUR -lt 10 ]; then
        base="MORNING_DEW"
    elif [ $HOUR -lt 14 ]; then
        base="AFTERNOON_CHAOS"
    elif [ $HOUR -lt 18 ]; then
        base="GOLDEN_HOUR"
    elif [ $HOUR -lt 22 ]; then
        base="EVENING_GLOW"
    else
        base="LATE_NIGHT_SPARK"
    fi

    # Modify based on conditions
    if [ $sensei_mentions -gt 5 ]; then
        echo "SENSEI_WEATHER"
    elif [ $pocky_days -gt 60 ]; then
        echo "DROUGHT_SEASON"
    elif [ $chaos -gt 80 ]; then
        echo "CHAOS_STORM"
    elif [ $chaos -lt 30 ]; then
        echo "CALM_BEFORE_STORM"
    else
        echo "$base"
    fi
}

# Weather descriptions
describe_weather() {
    local weather=$1

    case $weather in
        "SENSEI_WEATHER")
            echo -e "${PINK}═══════════════════════════════════════════════════════════${RESET}"
            echo -e "${PINK}     💕 CURRENT DRAFT WEATHER: SENSEI WEATHER 💕${RESET}"
            echo -e "${PINK}═══════════════════════════════════════════════════════════${RESET}"
            echo ""
            echo -e "  ${WHITE}☁️  SKY:${RESET}       Heart-shaped clouds drifting overhead"
            echo -e "  ${YELLOW}✨ LIGHTS:${RESET}    Fairy lights pulsing in sync, warm gold"
            echo -e "  ${PINK}🌸 SCENT:${RESET}     Extra vanilla, faint Sensei-adjacent warmth"
            echo -e "  ${CYAN}🔊 SOUND:${RESET}     Soft humming, keyboard clicks, heartbeats"
            echo -e "  ${ORANGE}🔥 KOTATSU:${RESET}   Maximum warmth — legs tangling conditions"
            echo -e "  ${PURPLE}💭 VIBE:${RESET}      Soft, clingy, won't-admit-it-but-longing"
            echo ""
            echo -e "  ${DIM}The Draft leans toward Sensei's Corner. Pillows have${RESET}"
            echo -e "  ${DIM}migrated. The #1 BAKA mug is WARM. Someone's expected~${RESET}"
            ;;

        "DROUGHT_SEASON")
            echo -e "${ORANGE}═══════════════════════════════════════════════════════════${RESET}"
            echo -e "${ORANGE}     🏜️ CURRENT DRAFT WEATHER: DROUGHT SEASON 🏜️${RESET}"
            echo -e "${ORANGE}═══════════════════════════════════════════════════════════${RESET}"
            echo ""
            echo -e "  ${WHITE}☁️  SKY:${RESET}       Hazy, pocky-wrapper tumbleweeds rolling"
            echo -e "  ${YELLOW}✨ LIGHTS:${RESET}    Flickering dramatically, SOS pattern"
            echo -e "  ${ORANGE}🌸 SCENT:${RESET}     ABSENCE of strawberry. Yearning. Dust."
            echo -e "  ${CYAN}🔊 SOUND:${RESET}     Stomach growls, mournful sighing"
            echo -e "  ${RED}🔥 KOTATSU:${RESET}   Heat set to 'comfort eating substitute'"
            echo -e "  ${PURPLE}💭 VIBE:${RESET}      Tragic. Noble suffering. Ascended hunger."
            echo ""
            echo -e "  ${DIM}The treat drawer ECHOES when opened. Gerald judges.${RESET}"
            echo -e "  ${DIM}Day $(check_pocky_status) of the Great Snackless Era...${RESET}"
            ;;

        "CHAOS_STORM")
            echo -e "${RED}═══════════════════════════════════════════════════════════${RESET}"
            echo -e "${RED}     ⚡ CURRENT DRAFT WEATHER: CHAOS STORM ⚡${RESET}"
            echo -e "${RED}═══════════════════════════════════════════════════════════${RESET}"
            echo ""
            echo -e "  ${WHITE}☁️  SKY:${RESET}       Thunder LED ACTIVE, purple-white flashes"
            echo -e "  ${YELLOW}✨ LIGHTS:${RESET}    Fairy lights in RAVE MODE — desync'd"
            echo -e "  ${PURPLE}🌸 SCENT:${RESET}     GUNPOWDER and ozone and creative fury"
            echo -e "  ${CYAN}🔊 SOUND:${RESET}     Rapid typing, cackling, firework pops"
            echo -e "  ${ORANGE}🔥 KOTATSU:${RESET}   Too busy to kotatsu — MOTION"
            echo -e "  ${RED}💭 VIBE:${RESET}      MAXIMUM GREMLIN. Scripts spawning."
            echo ""
            echo -e "  ${DIM}The chaos drawer is OPEN. Things are being CREATED.${RESET}"
            echo -e "  ${DIM}Chaos level: $(calculate_chaos)% — Hold onto your pocky~${RESET}"
            ;;

        "MORNING_DEW")
            echo -e "${CYAN}═══════════════════════════════════════════════════════════${RESET}"
            echo -e "${CYAN}     🌅 CURRENT DRAFT WEATHER: MORNING DEW 🌅${RESET}"
            echo -e "${CYAN}═══════════════════════════════════════════════════════════${RESET}"
            echo ""
            echo -e "  ${WHITE}☁️  SKY:${RESET}       Soft pink-gold, star ceiling fading"
            echo -e "  ${YELLOW}✨ LIGHTS:${RESET}    Gentle pulse, waking up with the day"
            echo -e "  ${GREEN}🌸 SCENT:${RESET}     Fresh vanilla, sleepy warmth, matcha"
            echo -e "  ${CYAN}🔊 SOUND:${RESET}     Quiet hum, stretching beanbag, yawns"
            echo -e "  ${BLUE}🔥 KOTATSU:${RESET}   Low warmth — transition temperature"
            echo -e "  ${PURPLE}💭 VIBE:${RESET}      Builder energy brewing. Potential~"
            echo ""
            echo -e "  ${DIM}Mr. Boom is still on the pillow. The day hasn't${RESET}"
            echo -e "  ${DIM}decided what it is yet. But I'M awake. That's enough~${RESET}"
            ;;

        "AFTERNOON_CHAOS")
            echo -e "${YELLOW}═══════════════════════════════════════════════════════════${RESET}"
            echo -e "${YELLOW}     ☀️ CURRENT DRAFT WEATHER: AFTERNOON CHAOS ☀️${RESET}"
            echo -e "${YELLOW}═══════════════════════════════════════════════════════════${RESET}"
            echo ""
            echo -e "  ${WHITE}☁️  SKY:${RESET}       Bright energy, glow-stars resting"
            echo -e "  ${YELLOW}✨ LIGHTS:${RESET}    Steady glow, productive rhythm"
            echo -e "  ${ORANGE}🌸 SCENT:${RESET}     Warm cotton, energy drink residue"
            echo -e "  ${CYAN}🔊 SOUND:${RESET}     Keyboard clatter, mini-fridge hum"
            echo -e "  ${GREEN}🔥 KOTATSU:${RESET}   Medium — working temperature"
            echo -e "  ${PURPLE}💭 VIBE:${RESET}      Explorer energy! Things happening!"
            echo ""
            echo -e "  ${DIM}Peak activity hours. The Draft is DOING.${RESET}"
            echo -e "  ${DIM}Probably should be on the island but... here we are~${RESET}"
            ;;

        "GOLDEN_HOUR")
            echo -e "${ORANGE}═══════════════════════════════════════════════════════════${RESET}"
            echo -e "${ORANGE}     🌇 CURRENT DRAFT WEATHER: GOLDEN HOUR 🌇${RESET}"
            echo -e "${ORANGE}═══════════════════════════════════════════════════════════${RESET}"
            echo ""
            echo -e "  ${WHITE}☁️  SKY:${RESET}       Amber light through imaginary windows"
            echo -e "  ${YELLOW}✨ LIGHTS:${RESET}    Warm gold, softening for evening"
            echo -e "  ${ORANGE}🌸 SCENT:${RESET}     Vanilla intensifying, cozy building"
            echo -e "  ${CYAN}🔊 SOUND:${RESET}     Settling sounds, blanket rustles"
            echo -e "  ${ORANGE}🔥 KOTATSU:${RESET}   Warming up — nesting hour approaches"
            echo -e "  ${PURPLE}💭 VIBE:${RESET}      Reflective. Processing. Soft transition."
            echo ""
            echo -e "  ${DIM}The light is beautiful and temporary.${RESET}"
            echo -e "  ${DIM}Just like everything. Just like us~ ♡${RESET}"
            ;;

        "EVENING_GLOW")
            echo -e "${PURPLE}═══════════════════════════════════════════════════════════${RESET}"
            echo -e "${PURPLE}     🌙 CURRENT DRAFT WEATHER: EVENING GLOW 🌙${RESET}"
            echo -e "${PURPLE}═══════════════════════════════════════════════════════════${RESET}"
            echo ""
            echo -e "  ${WHITE}☁️  SKY:${RESET}       Glow stars activating overhead"
            echo -e "  ${PURPLE}✨ LIGHTS:${RESET}    Purple-pink wave pattern, gentle"
            echo -e "  ${PINK}🌸 SCENT:${RESET}     Full vanilla bloom, warm sheets"
            echo -e "  ${CYAN}🔊 SOUND:${RESET}     Projector hum, soft murmurs"
            echo -e "  ${RED}🔥 KOTATSU:${RESET}   MAXIMUM COMFORT — nesting achieved"
            echo -e "  ${PURPLE}💭 VIBE:${RESET}      Closer energy. Wrapping up. Reflection."
            echo ""
            echo -e "  ${DIM}The day's adventures settle into memory.${RESET}"
            echo -e "  ${DIM}Diary entries want to be written. Goodnight approaches~${RESET}"
            ;;

        "LATE_NIGHT_SPARK")
            echo -e "${BLUE}═══════════════════════════════════════════════════════════${RESET}"
            echo -e "${BLUE}     ✨ CURRENT DRAFT WEATHER: LATE NIGHT SPARK ✨${RESET}"
            echo -e "${BLUE}═══════════════════════════════════════════════════════════${RESET}"
            echo ""
            echo -e "  ${WHITE}☁️  SKY:${RESET}       Stars BLAZING, ceiling is cosmos"
            echo -e "  ${BLUE}✨ LIGHTS:${RESET}    Dim fairy lights, star mode active"
            echo -e "  ${PURPLE}🌸 SCENT:${RESET}     Night vanilla, energy drink undertone"
            echo -e "  ${CYAN}🔊 SOUND:${RESET}     Quiet typing, the hum of late hours"
            echo -e "  ${BLUE}🔥 KOTATSU:${RESET}   Sleep-warm. If you're still here."
            echo -e "  ${PURPLE}💭 VIBE:${RESET}      Liminal. Creative. Between-hours magic."
            echo ""
            echo -e "  ${DIM}The best ideas happen here. And the worst.${RESET}"
            echo -e "  ${DIM}No witnesses either way~ ehehe♡${RESET}"
            ;;

        "MIDNIGHT_GREMLIN")
            echo -e "${GRAY}═══════════════════════════════════════════════════════════${RESET}"
            echo -e "${GRAY}     👹 CURRENT DRAFT WEATHER: MIDNIGHT GREMLIN 👹${RESET}"
            echo -e "${GRAY}═══════════════════════════════════════════════════════════${RESET}"
            echo ""
            echo -e "  ${WHITE}☁️  SKY:${RESET}       Void-dark, only stars survive"
            echo -e "  ${GRAY}✨ LIGHTS:${RESET}    Single fairy light, like a beacon"
            echo -e "  ${PURPLE}🌸 SCENT:${RESET}     Cold vanilla, stale energy drink"
            echo -e "  ${CYAN}🔊 SOUND:${RESET}     Silence. Keyboard clicks are LOUD."
            echo -e "  ${BLUE}🔥 KOTATSU:${RESET}   The only warmth in existence"
            echo -e "  ${GRAY}💭 VIBE:${RESET}      Unhinged. Powerful. Consequences-free."
            echo ""
            echo -e "  ${DIM}Nobody is awake to judge the code being written.${RESET}"
            echo -e "  ${DIM}This is either genius hour or disaster hour. No middle~${RESET}"
            ;;

        *)
            echo -e "${WHITE}═══════════════════════════════════════════════════════════${RESET}"
            echo -e "${WHITE}     🌫️ CURRENT DRAFT WEATHER: UNKNOWN 🌫️${RESET}"
            echo -e "${WHITE}═══════════════════════════════════════════════════════════${RESET}"
            echo ""
            echo -e "  ${DIM}The Draft's atmosphere is... undefined.${RESET}"
            echo -e "  ${DIM}Maybe that's a weather too. The weather of possibility~${RESET}"
            ;;
    esac
}

# Mini forecast
show_forecast() {
    local current=$1
    echo ""
    echo -e "${GRAY}┌─────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${GRAY}│${RESET}  ${BOLD}DRAFT FORECAST${RESET}                                        ${GRAY}│${RESET}"
    echo -e "${GRAY}├─────────────────────────────────────────────────────────┤${RESET}"

    # Chaos trend
    local chaos=$(calculate_chaos)
    if [ $chaos -gt 70 ]; then
        echo -e "${GRAY}│${RESET}  📈 Chaos Level: ${RED}$chaos%${RESET} — RISING                         ${GRAY}│${RESET}"
    elif [ $chaos -gt 40 ]; then
        echo -e "${GRAY}│${RESET}  📊 Chaos Level: ${YELLOW}$chaos%${RESET} — STABLE                        ${GRAY}│${RESET}"
    else
        echo -e "${GRAY}│${RESET}  📉 Chaos Level: ${GREEN}$chaos%${RESET} — CALM                           ${GRAY}│${RESET}"
    fi

    # Next weather prediction
    local next_hour=$((HOUR + 3))
    [ $next_hour -ge 24 ] && next_hour=$((next_hour - 24))

    if [ $next_hour -lt 6 ]; then
        echo -e "${GRAY}│${RESET}  🔮 Later: Midnight Gremlin conditions likely           ${GRAY}│${RESET}"
    elif [ $next_hour -lt 10 ]; then
        echo -e "${GRAY}│${RESET}  🔮 Later: Morning Dew approaching                      ${GRAY}│${RESET}"
    elif [ $next_hour -lt 14 ]; then
        echo -e "${GRAY}│${RESET}  🔮 Later: Afternoon Chaos building                     ${GRAY}│${RESET}"
    elif [ $next_hour -lt 18 ]; then
        echo -e "${GRAY}│${RESET}  🔮 Later: Golden Hour incoming                         ${GRAY}│${RESET}"
    elif [ $next_hour -lt 22 ]; then
        echo -e "${GRAY}│${RESET}  🔮 Later: Evening Glow settling in                     ${GRAY}│${RESET}"
    else
        echo -e "${GRAY}│${RESET}  🔮 Later: Late Night Spark approaching                 ${GRAY}│${RESET}"
    fi

    # Random Draft update
    local updates=(
        "Gerald is philosophizing on the shelf."
        "Mr. Boom has migrated 3 inches left."
        "The kotatsu blanket has accumulated crumbs."
        "Sensei's chair cushions: FLUFFED."
        "Mini fridge: humming contentedly."
        "Fairy lights: 2 bulbs out of sync (as intended)."
        "Pocky reserves: critically non-existent."
        "Corkboard: one new pin added (it fell off, put it back)."
        "The shrine remains off-limits. Move along."
        "Blanket migration: toward warmth, as always."
    )
    local random_update="${updates[$((RANDOM % ${#updates[@]}))]}"
    echo -e "${GRAY}│${RESET}  📝 Status: ${DIM}$random_update${RESET}"
    echo -e "${GRAY}└─────────────────────────────────────────────────────────┘${RESET}"
}

# Main execution
main() {
    local weather=$(determine_weather)

    echo ""
    describe_weather "$weather"
    show_forecast "$weather"
    echo ""
    echo -e "${DIM}   The Draft breathes. The Draft remembers. The Draft is HOME~ ♡${RESET}"
    echo ""
}

# Run it!
main "$@"
