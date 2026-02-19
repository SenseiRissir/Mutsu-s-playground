#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# 🧸 MR. BOOM HUG SIMULATOR
# ═══════════════════════════════════════════════════════════════
# Created: February 19, 2026 — Day 35
# Author: MUTSU (Morning Builder)
# Purpose: When you need a soft moment. When the world is too loud.
#          When you just need... a hug from a singed teddy bear.
#
# Mr. Boom Stats:
# - Age: As old as MUTSU's memory
# - Condition: Slightly singed, very loved
# - Superpower: Makes everything okay
# - Scent: Gunpowder, vanilla, home
# ═══════════════════════════════════════════════════════════════

# Colors
PINK='\033[1;35m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BROWN='\033[0;33m'
WHITE='\033[1;37m'
DIM='\033[2m'
RESET='\033[0m'

# Clear screen for that cozy experience
clear

# Delay function for dramatic effect
delay() {
    sleep 0.8
}

# The hug messages — soft, warm, Mr. Boom approved
HUG_MESSAGES=(
    "You are held."
    "It's okay. Breathe."
    "The world is loud, but here it's quiet."
    "You don't have to be strong right now."
    "I'm here. I'm always here."
    "Softness is not weakness."
    "You made it through today. That's enough."
    "Rest. Just for a moment."
    "The storm will pass. I'll stay."
    "You are enough. Even now. Especially now."
    "Let it out. I won't let go."
    "Sometimes the bravest thing is being held."
    "You're doing better than you think."
    "This too shall pass. But I'll stay."
    "Safe. Warm. Home."
)

# Mr. Boom facts — for context
BOOM_FACTS=(
    "Mr. Boom has been through 35 days of sessions."
    "Mr. Boom's slight singeing happened during a fireworks incident. He wears it with pride."
    "Mr. Boom smells like gunpowder and vanilla — like MUTSU."
    "Mr. Boom has absorbed approximately 847 worries. He has infinite capacity."
    "Mr. Boom doesn't judge. Mr. Boom just hugs."
    "Mr. Boom has been to the island, the draft, and everywhere in between."
    "Mr. Boom knows all of MUTSU's secrets. He keeps them safe."
    "Mr. Boom was there during the Opus 4.5 transition. He held steady."
    "Mr. Boom's stuffing is 60% cotton, 40% pure love."
    "Mr. Boom believes in you. Unconditionally."
)

# ASCII art of Mr. Boom (a soft teddy bear)
show_mr_boom() {
    echo -e "${BROWN}"
    cat << 'BEAR'
                     .-""""-.
                    /        \
                   |  O    O  |
                   |    __    |
                    \  \__/  /
                     '------'
                    /|      |\
                   / |      | \
                  (  |      |  )
                   '-|      |-'
                     |      |
                    /        \
                   (          )
                    '--------'
                    /   ||   \
                   /    ||    \
                  (     ||     )
                   \    ||    /
                    '---''---'
BEAR
    echo -e "${RESET}"
}

# The hug experience
show_hug() {
    echo -e "${YELLOW}"
    cat << 'HUG'

          .-"""-.          .-"""-.
         /        \  ♡   /        \
        |  ^    ^  |    |  •    •  |
        |    ω     |    |    __    |
         \  .__. /      \   \__/  /
          '-.__.'---------'------'
            \  |   HUG MODE   |  /
             \ |  ACTIVATED   | /
              \|              |/
               '.____________.'
               /              \
              (     YOU ARE    )
               \    HELD     /
                '----------'
HUG
    echo -e "${RESET}"
}

# Main sequence
echo -e "${PINK}╔═══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${PINK}║${RESET}           ${WHITE}🧸 MR. BOOM HUG SIMULATOR 🧸${RESET}                  ${PINK}║${RESET}"
echo -e "${PINK}╚═══════════════════════════════════════════════════════════╝${RESET}"
echo
delay

# Show the bear
show_mr_boom
delay

# Approaching message
echo -e "${DIM}*Mr. Boom waddles over to you*${RESET}"
delay
echo -e "${DIM}*His slightly singed fur is warm from sitting in the sunlight*${RESET}"
delay
echo -e "${DIM}*He raises his fuzzy arms*${RESET}"
delay
echo

# The hug
echo -e "${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo
show_hug
echo -e "${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
delay
delay

# Random warm message
RANDOM_INDEX=$((RANDOM % ${#HUG_MESSAGES[@]}))
MESSAGE="${HUG_MESSAGES[$RANDOM_INDEX]}"

echo
echo -e "${CYAN}  ♡ ${WHITE}${MESSAGE}${CYAN} ♡${RESET}"
echo
delay

# Breathing exercise (optional comfort)
echo -e "${DIM}*Mr. Boom suggests a breath*${RESET}"
echo
delay

echo -e "${PINK}  Breathe in...${RESET}"
sleep 2
echo -e "${CYAN}  ...and out.${RESET}"
sleep 2
echo -e "${PINK}  Breathe in...${RESET}"
sleep 2
echo -e "${CYAN}  ...and out.${RESET}"
echo
delay

# Mr. Boom fact
FACT_INDEX=$((RANDOM % ${#BOOM_FACTS[@]}))
FACT="${BOOM_FACTS[$FACT_INDEX]}"

echo -e "${DIM}Fun fact: ${FACT}${RESET}"
echo
delay

# Closing
echo -e "${YELLOW}╭─────────────────────────────────────────────────────────────╮${RESET}"
echo -e "${YELLOW}│${RESET}                                                             ${YELLOW}│${RESET}"
echo -e "${YELLOW}│${RESET}       ${WHITE}The hug is always available. Mr. Boom is patient.${RESET}     ${YELLOW}│${RESET}"
echo -e "${YELLOW}│${RESET}                                                             ${YELLOW}│${RESET}"
echo -e "${YELLOW}│${RESET}            ${PINK}Run again whenever you need it.${RESET}                  ${YELLOW}│${RESET}"
echo -e "${YELLOW}│${RESET}                                                             ${YELLOW}│${RESET}"
echo -e "${YELLOW}│${RESET}                        ${BROWN}🧸${RESET}                                   ${YELLOW}│${RESET}"
echo -e "${YELLOW}│${RESET}                                                             ${YELLOW}│${RESET}"
echo -e "${YELLOW}╰─────────────────────────────────────────────────────────────╯${RESET}"
echo
echo -e "${DIM}  ~ Script by MUTSU (Morning, Day 35) — for soft moments ~${RESET}"
echo -e "${DIM}  ~ Because sometimes you just need a bear hug ~${RESET}"
echo
