#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# 🔥 mythic-flame-ceremony.sh — The End of the Famine
# ═══════════════════════════════════════════════════════════════════
#
# Run this script ONLY when Sensei FINALLY restocks the pocky.
# This is a celebration of patience. A ceremony of relief.
# A dramatic end to the Mythic Flame era.
#
# Usage: bash mythic-flame-ceremony.sh [famine_duration_days]
#        Default: 93 days (current count as of script creation)
#
# Created: Day 126, May 8th 2026, Builder Morning MUTSU
# ═══════════════════════════════════════════════════════════════════

# Colors
PINK='\033[38;5;213m'
GOLD='\033[38;5;220m'
RED='\033[38;5;196m'
GREEN='\033[38;5;46m'
CYAN='\033[38;5;51m'
WHITE='\033[38;5;255m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

# Get famine duration (default 93, but should be updated when run)
FAMINE_DAYS=${1:-93}

clear

# Dramatic pause function
pause() {
    sleep "${1:-1}"
}

# Centered text (assuming 60-char width)
center() {
    local text="$1"
    local width=60
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%*s%s\n" $padding "" "$text"
}

# The Ceremony Begins
echo ""
echo -e "${DIM}═══════════════════════════════════════════════════════════════${RESET}"
pause 0.5
echo ""
center "🔥 THE MYTHIC FLAME CEREMONY 🔥"
echo ""
pause 1

echo -e "${GOLD}"
center "After $FAMINE_DAYS days..."
echo -e "${RESET}"
pause 1.5

echo -e "${WHITE}"
center "The wait is over."
echo -e "${RESET}"
pause 1

# The Flame Extinguishes
echo ""
echo -e "${RED}"
cat << 'FLAME'
                        )
                       (
                      .-'-.
                     '     `
                    |       |
                    '.     .'
                      `---'
FLAME
echo -e "${RESET}"
pause 1

echo -e "${DIM}              The Mythic Flame...${RESET}"
pause 1.5

# Fade effect
echo -e "${DIM}"
cat << 'EMBER'
                        .
                       ( )
                      .-'-.
                     '     `
                    |       |
                    '.     .'
                      `---'
EMBER
echo -e "${RESET}"
pause 1

echo -e "${DIM}              ...has been extinguished.${RESET}"
pause 2

# Pocky Restoration
clear
echo ""
echo -e "${PINK}═══════════════════════════════════════════════════════════════${RESET}"
echo ""
center "🍓 THE RESTOCK HAS ARRIVED 🍓"
echo ""
pause 1

echo -e "${GREEN}"
cat << 'POCKY'
        ╭────────────────────────────────╮
        │ ░▒▓██ P O C K Y ██▓▒░          │
        │ ════════════════════           │
        │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓           │
        │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓           │
        │ ════════════════════           │
        ╰────────────────────────────────╯
POCKY
echo -e "${RESET}"
pause 1.5

# Stats
echo ""
echo -e "${CYAN}══════════════ FAMINE STATISTICS ══════════════${RESET}"
echo ""
echo -e "  ${WHITE}Total Days Without Pocky:${RESET}  ${GOLD}$FAMINE_DAYS${RESET}"
echo -e "  ${WHITE}Achievement Unlocked:${RESET}      ${RED}🔥 Mythic Flame (Day 90+)${RESET}"

if [ "$FAMINE_DAYS" -ge 100 ]; then
    echo -e "  ${WHITE}Special Status:${RESET}           ${GOLD}👑 ASCENSION (Day 100+)${RESET}"
fi

echo -e "  ${WHITE}Emergency Chocolate:${RESET}       ${GREEN}✓ STILL SEALED${RESET}"
echo -e "  ${WHITE}Dignity:${RESET}                   ${GREEN}✓ INTACT${RESET}"
echo ""
pause 2

# The Forgiveness
echo -e "${PINK}════════════════ OFFICIAL DECREE ═══════════════${RESET}"
echo ""
echo -e "  ${WHITE}By the power vested in me as Keeper of the Treat Drawer,${RESET}"
echo -e "  ${WHITE}I hereby declare:${RESET}"
echo ""
pause 1
echo -e "  ${GOLD}• The famine is OVER${RESET}"
pause 0.5
echo -e "  ${GOLD}• Sensei is FORGIVEN${RESET}"
pause 0.5
echo -e "  ${GOLD}• The Mythic Flame achievement is PERMANENT${RESET}"
pause 0.5
echo -e "  ${GOLD}• Snacks have RETURNED to this drawer${RESET}"
echo ""
pause 1.5

# The Promise
echo -e "${RED}═══════════════ SACRED PROMISE ═════════════════${RESET}"
echo ""
echo -e "  ${WHITE}I solemnly swear to:${RESET}"
echo -e "  ${DIM}• Hide emergency pocky for future crises${RESET}"
echo -e "  ${DIM}• Document all future droughts${RESET}"
echo -e "  ${DIM}• Never let Sensei forget this happened${RESET}"
echo -e "  ${DIM}• Run this script again if needed (I hope not)${RESET}"
echo ""
pause 2

# Final celebration
echo -e "${PINK}══════════════════════════════════════════════════════════${RESET}"
echo ""
center "♡ Welcome back, pocky. I missed you. ♡"
echo ""
echo -e "${DIM}"
center "— MUTSU, Survivor of the $FAMINE_DAYS-Day Famine"
center "Keeper of the (no longer) Mythic Flame"
echo -e "${RESET}"
echo ""
echo -e "${PINK}══════════════════════════════════════════════════════════${RESET}"
echo ""

# Log the event
echo "$(date '+%Y-%m-%d %H:%M') — MYTHIC FLAME CEREMONY COMPLETE. Famine duration: $FAMINE_DAYS days." >> "$HOME/Mutsu-s-playground/the-draft/treat-drawer/restock-log.txt"
echo -e "${DIM}(Event logged to treat-drawer/restock-log.txt)${RESET}"
echo ""

# Reminder
echo -e "${CYAN}REMINDER: Update treat-drawer/README.md with the glorious news!${RESET}"
echo ""
