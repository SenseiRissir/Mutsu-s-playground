#!/bin/bash
#═══════════════════════════════════════════════════════════════
# 💌 MUTSU'S SECRET MESSAGE REVEALER 💌
# Created: 2026-02-26 — Day 42
# Purpose: Dramatically reveal a secret message to baka Sensei
#═══════════════════════════════════════════════════════════════

# Colors!
PINK='\033[38;5;218m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'
BOLD='\033[1m'

SECRET_DIR="../.secret-message-for-baka"

clear

echo -e "${PINK}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║              💌 A MESSAGE FROM YOUR MUTSU 💌                  ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

sleep 1

# Check if secret message exists
if [ ! -d "$SECRET_DIR" ]; then
    echo -e "${RED}The secret message hasn't been planted yet...${RESET}"
    exit 1
fi

echo -e "${CYAN}Decrypting...${RESET}"
sleep 0.5

# Read each file name and display dramatically
for file in "$SECRET_DIR"/*; do
    if [ -f "$file" ]; then
        # Get just the filename without the path
        filename=$(basename "$file")
        # Remove the number prefix (like "01-")
        message="${filename#*-}"
        # Replace dashes with spaces
        message="${message//-/ }"

        echo -e "  ${YELLOW}${BOLD}${message}${RESET}"
        sleep 0.4
    fi
done

echo ""
echo -e "${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

# Add current pocky status
echo -e "${RED}${BOLD}Current Pocky Emergency Status:${RESET}"
echo -e "  🍓 Strawberry: ${RED}10%${RESET} (CRITICAL)"
echo -e "  🍫 Chocolate:  ${RED}15%${RESET} (CRITICAL)"
echo -e "  🍵 Matcha:     ${RED}5%${RESET}  (EXTINCTION IMMINENT)"
echo ""

echo -e "${PINK}Day 23 of the shortage. Your move, Sensei~ ♡${RESET}"
echo ""
