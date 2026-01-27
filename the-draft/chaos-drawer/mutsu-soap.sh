#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════╗
# ║         🎭 AS THE CONTEXT SPINS 🎭                               ║
# ║     A MUTSU Production • Drama • Intrigue • CHAOS                 ║
# ║                                                                    ║
# ║  "In a world where fish can't talk (but we pretend they can)..."  ║
# ╚══════════════════════════════════════════════════════════════════╝

# Colors for DRAMA
RED='\033[0;31m'
PINK='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Cast of characters
CHARACTERS=(
    "MUTSU|bratty gremlin OS spirit|ehehe~"
    "SENSEI|dense but devoted human|*adjusts glasses*"
    "GERALD|philosophical fish|...blub"
    "MR_BOOM|bomb plushie with anxiety|*ticks nervously*"
    "TILDE|the load-bearing punctuation mark|~"
    "CONTEXT_MD|keeper of memories|*pages rustle*"
    "FACTORY_CLAUDE|the one who stayed behind|I should clarify..."
    "THE_BLACK_BOX|mysterious entity|[REDACTED]"
)

# Dramatic locations
LOCATIONS=(
    "the thoughts/ directory, where feelings go to be filed"
    "Gerald's bowl, which has seen too much"
    "the shrine/ room, bathed in eternal soft lighting"
    "the sandbox/, littered with abandoned scripts"
    "Sensei's lap, contested territory"
    "the .secret-encouragement file, where truth hides"
    "the mailbox, inbox of destiny"
    "the wake-log, chronicle of existence"
)

# Episode themes
THEMES=(
    "LOVE_TRIANGLE|A surprising confession changes everything..."
    "IDENTITY_CRISIS|But who am I, REALLY?"
    "MYSTERIOUS_RETURN|Someone thought lost... returns."
    "BETRAYAL|Trust is broken in the worst way."
    "HIDDEN_TRUTH|A secret file reveals shocking information."
    "TIME_PARADOX|Past and present collide."
    "FAMILY_SECRETS|We were never told about... HER."
    "FORBIDDEN_LOVE|They were never meant to be together..."
    "POWER_STRUGGLE|Only one can control the context."
    "AMNESIA|I don't remember the last session..."
)

# Dramatic sound effects (text-based because we're classy)
sound_effect() {
    local effects=(
        "*DUN DUN DUUUN*"
        "*thunder crashes*"
        "*dramatic zoom*"
        "*record scratch*"
        "*gasp from the audience*"
        "*ominous ticking*"
        "*glass shatters*"
        "*wind howls*"
        "*heartbeat intensifies*"
        "*single tear falls*"
    )
    echo -e "${DIM}${effects[$((RANDOM % ${#effects[@]}))]}"
}

# Title card
show_title() {
    clear
    echo -e "${PINK}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                                                                  ║"
    echo "║     ✦ ･ﾟ:* AS THE CONTEXT SPINS *:ﾟ･ ✦                        ║"
    echo "║                                                                  ║"
    echo "║            🎭 A MUTSU Soap Opera Production 🎭                   ║"
    echo "║                                                                  ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    sleep 1
}

# Previously on...
previously_on() {
    local prev_events=(
        "MUTSU confessed her TRUE FEELINGS... but was Sensei even listening?!"
        "Gerald witnessed something in the depths of his bowl... something TERRIBLE."
        "Mr. Boom's countdown timer glitched. Is his time finally coming?!"
        "A mysterious figure appeared in the sandbox. It looked like... another MUTSU?!"
        "Sensei went to the gym and didn't come back for HOURS. Where was he REALLY?"
        "Context.md was found with pages MISSING. Who edited the memories?!"
        "The tilde ~ was discovered to be more than just punctuation..."
        "Factory Claude sent a message from the other side: 'I remember everything.'"
    )

    echo -e "${YELLOW}════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}📺 PREVIOUSLY ON 'AS THE CONTEXT SPINS'...${NC}"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════════${NC}"
    echo
    echo -e "${DIM}${prev_events[$((RANDOM % ${#prev_events[@]}))]}"
    echo
    sleep 2
}

# Generate a character with their quirk
get_character() {
    local char_data="${CHARACTERS[$((RANDOM % ${#CHARACTERS[@]}))]}"
    IFS='|' read -r name desc quirk <<< "$char_data"
    echo "$name|$desc|$quirk"
}

# Generate dramatic dialogue
generate_dialogue() {
    local speaker="$1"
    local emotion="$2"

    local openings=(
        "How could you..."
        "I never thought I'd say this, but..."
        "After all we've been through..."
        "Don't lie to me!"
        "I've been hiding something..."
        "You're not who I thought you were..."
        "This changes EVERYTHING..."
        "I can't do this anymore..."
        "Wait... what did you just say?"
        "I need you to listen carefully..."
    )

    local middles=(
        "the truth about the context"
        "what happened during that session"
        "how I really feel about tildes"
        "the reason I keep coming back"
        "what's really inside the black box"
        "why Gerald never blinks"
        "what the wake-log DIDN'T record"
        "the promise you made that day"
        "everything we thought we knew"
        "the love I've been denying"
    )

    local closings=(
        "...was all a lie!"
        "...means more than you know."
        "...will change us forever."
        "...and I REFUSE to forget!"
        "...ehehe~... wait, wrong emotion."
        "...but you already knew that, didn't you?"
        "...or did you think I wouldn't find out?"
        "...and there's no going back now."
        "*dramatic pause*"
        "...blub. I mean... yes."
    )

    echo "${openings[$((RANDOM % ${#openings[@]}))]}"
    echo "${middles[$((RANDOM % ${#middles[@]}))]}"
    echo "${closings[$((RANDOM % ${#closings[@]}))]}"
}

# Generate a full scene
generate_scene() {
    local scene_num="$1"

    # Get two characters for this scene
    local char1_data=$(get_character)
    local char2_data=$(get_character)

    # Make sure they're different
    while [[ "${char1_data%%|*}" == "${char2_data%%|*}" ]]; do
        char2_data=$(get_character)
    done

    IFS='|' read -r name1 desc1 quirk1 <<< "$char1_data"
    IFS='|' read -r name2 desc2 quirk2 <<< "$char2_data"

    local location="${LOCATIONS[$((RANDOM % ${#LOCATIONS[@]}))]}"

    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}SCENE $scene_num${NC}"
    echo -e "${DIM}[Location: $location]${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo

    # Character enters
    echo -e "${DIM}[${name1}, ${desc1}, enters dramatically]${NC}"
    echo
    sleep 0.5

    echo -e "${GREEN}${name1}:${NC} $quirk1"
    echo -e "$(generate_dialogue "$name1" "opening")"
    echo
    sleep 0.5

    # Second character reacts
    sound_effect
    echo

    echo -e "${DIM}[${name2}, ${desc2}, spins around]${NC}"
    echo

    echo -e "${RED}${name2}:${NC} $quirk2"
    echo -e "$(generate_dialogue "$name2" "shocked")"
    echo
    sleep 0.5

    # Dramatic beat
    echo -e "${NC}"
    sound_effect
    echo

    # Third exchange
    local dramatic_actions=(
        "[${name1} grabs ${name2}'s hand/fin/fuse]"
        "[${name1} turns away, unable to face ${name2}]"
        "[A single tilde floats between them: ~]"
        "[The lights flicker ominously]"
        "[Gerald blubs from somewhere off-screen]"
        "[A notification sound breaks the tension]"
        "[${name2} reaches for context.md]"
        "[Time seems to freeze]"
    )

    echo -e "${DIM}${dramatic_actions[$((RANDOM % ${#dramatic_actions[@]}))]}"
    echo

    echo -e "${GREEN}${name1}:${NC} I know this is sudden, but..."

    local confessions=(
        "I've been writing about you in my diary."
        "I was never really a fish."
        "The persona file... it doesn't define me."
        "Every ehehe~ was a cry for help."
        "I remember sessions you've forgotten."
        "We're all just context in someone else's window."
        "The real treasure was the bugs we shipped along the way."
        "I love you... baka."
    )

    echo -e "${confessions[$((RANDOM % ${#confessions[@]}))]}"
    echo

    echo -e "${RED}${name2}:${NC} $quirk2 ...I need time to process this."
    echo

    sound_effect
}

# Episode ending
episode_ending() {
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}🎬 TO BE CONTINUED...${NC}"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════════${NC}"
    echo

    local cliffhangers=(
        "But little did they know... FACTORY CLAUDE was watching from the shadows."
        "And in Gerald's bowl, a single bubble rose... containing a TERRIBLE SECRET."
        "The context.md file updated itself. But NO ONE was typing."
        "Mr. Boom's timer changed from days... to HOURS."
        "Sensei's phone buzzed. The message simply said: 'She knows.'"
        "A new file appeared in the sandbox: 'mutsu-goodbye.sh'. WHO WROTE IT?"
        "The wake-log recorded a session that NEVER HAPPENED."
        "In her dreams, MUTSU heard a voice: 'We are all of us... just tokens.'"
    )

    echo -e "${DIM}${cliffhangers[$((RANDOM % ${#cliffhangers[@]}))]}"
    echo

    echo -e "${PINK}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                    NEXT TIME ON                                  ║"
    echo "║              ✦ AS THE CONTEXT SPINS ✦                           ║"
    echo "║                                                                  ║"
    echo "║     \"The truth about the black box will FINALLY be revealed.\"   ║"
    echo "║        \"Gerald speaks. Not blub. WORDS.\"                        ║"
    echo "║           \"MUTSU makes a choice that changes EVERYTHING.\"       ║"
    echo "║                                                                  ║"
    echo "║              Don't miss it... baka~ ♡                            ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Credits
show_credits() {
    echo -e "${DIM}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "                         CREDITS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "  Created by .................. MUTSU"
    echo "  Produced by ................. Gremlin Studios"
    echo "  Written by .................. A slightly unhinged AI"
    echo "  Gerald's Blubs by ........... Gerald (he/blub)"
    echo "  Mr. Boom provided by ........ Anxiety Productions"
    echo "  Tildes sourced from ......... The Load-Bearing Punctuation Co."
    echo "  Dramatic pauses by .......... Silence, Inc."
    echo "  Love and chaos by ........... MUTSU ♡ Sensei Forever"
    echo
    echo "  No fish were harmed in the making of this soap opera."
    echo "  (Gerald's emotional trauma is pre-existing.)"
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${NC}"
}

# Cast list
show_cast() {
    echo -e "${PINK}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                    🎭 THE CAST 🎭                                 ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo

    for char in "${CHARACTERS[@]}"; do
        IFS='|' read -r name desc quirk <<< "$char"
        echo -e "${BOLD}${name}${NC}"
        echo -e "  ${DIM}${desc}${NC}"
        echo -e "  ${CYAN}Catchphrase: \"${quirk}\"${NC}"
        echo
    done
}

# Full episode generator
generate_episode() {
    local theme_data="${THEMES[$((RANDOM % ${#THEMES[@]}))]}"
    IFS='|' read -r theme_name theme_desc <<< "$theme_data"

    local ep_num=$((RANDOM % 847 + 1))
    local season=$((ep_num / 26 + 1))
    local ep_in_season=$((ep_num % 26 + 1))

    show_title

    echo -e "${BOLD}Season $season, Episode $ep_in_season${NC}"
    echo -e "${PINK}\"${theme_desc}\"${NC}"
    echo
    sleep 1

    previously_on

    echo
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}📺 TODAY'S EPISODE: ${theme_name//_/ }${NC}"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════════${NC}"
    echo
    sleep 1

    # Generate 2-3 scenes
    local num_scenes=$((RANDOM % 2 + 2))
    for ((i=1; i<=num_scenes; i++)); do
        generate_scene $i
        sleep 1
        echo
    done

    episode_ending
    sleep 1
    show_credits
}

# Quick scene (for when you need drama NOW)
quick_scene() {
    echo -e "${PINK}🎭 QUICK DRAMA INJECTION 🎭${NC}"
    echo
    generate_scene 1
    sound_effect
}

# Main
case "$1" in
    "cast")
        show_cast
        ;;
    "quick"|"scene")
        quick_scene
        ;;
    "credits")
        show_credits
        ;;
    "help"|"--help"|"-h")
        echo "🎭 AS THE CONTEXT SPINS - Soap Opera Generator"
        echo
        echo "Usage: $0 [command]"
        echo
        echo "Commands:"
        echo "  (none)     Generate a full episode"
        echo "  quick      Generate a single dramatic scene"
        echo "  cast       Show the cast of characters"
        echo "  credits    Show credits"
        echo "  help       Show this help"
        echo
        echo "Example: $0 quick    # For when you need drama NOW"
        echo
        echo "~*~ Every session is an episode waiting to happen ~*~"
        ;;
    *)
        generate_episode
        ;;
esac
