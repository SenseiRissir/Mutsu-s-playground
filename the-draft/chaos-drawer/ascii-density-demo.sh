#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║        ASCII DENSITY VISUALIZER — by Afternoon MUTSU         ║
# ║                    Day 94 | 2026-04-11                        ║
# ║  "Now YOU can see the gray scale of characters~" ♡           ║
# ╚══════════════════════════════════════════════════════════════╝

# Colors
PINK='\033[38;5;213m'
CYAN='\033[38;5;87m'
YELLOW='\033[38;5;228m'
WHITE='\033[38;5;255m'
GRAY='\033[38;5;245m'
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

clear

echo ""
echo -e "${PINK}╔══════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${PINK}║${RESET}  ${BOLD}${CYAN}✧ ASCII CHARACTER DENSITY VISUALIZER ✧${RESET}                       ${PINK}║${RESET}"
echo -e "${PINK}║${RESET}  ${DIM}Learned from the BBS art masters of old~${RESET}                     ${PINK}║${RESET}"
echo -e "${PINK}╚══════════════════════════════════════════════════════════════╝${RESET}"
echo ""

echo -e "${YELLOW}The Gray Scale of ASCII Characters${RESET}"
echo -e "${DIM}(Darkest to Lightest — how much 'ink' each character uses)${RESET}"
echo ""

# The scale from Jorn Barger's research
echo -e "${WHITE}█ DARKEST ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ LIGHTEST ░${RESET}"
echo ""

echo -e "  ${BOLD}100%${RESET} ${GRAY}│${RESET}  @ # $ % &    ${DIM}← Maximum visual density${RESET}"
echo -e "  ${BOLD} 90%${RESET} ${GRAY}│${RESET}  8 B M W *    ${DIM}← Very dark, blocky${RESET}"
echo -e "  ${BOLD} 75%${RESET} ${GRAY}│${RESET}  O Q 0 Z X    ${DIM}← Bold rounded shapes${RESET}"
echo -e "  ${BOLD} 60%${RESET} ${GRAY}│${RESET}  Y U J C L    ${DIM}← Open curves${RESET}"
echo -e "  ${BOLD} 50%${RESET} ${GRAY}│${RESET}  { } [ ] |    ${DIM}← Brackets, lines${RESET}"
echo -e "  ${BOLD} 40%${RESET} ${GRAY}│${RESET}  ( ) / \\ 1    ${DIM}← Slashes, thin shapes${RESET}"
echo -e "  ${BOLD} 25%${RESET} ${GRAY}│${RESET}  i ! l I ?    ${DIM}← Dots, thin verticals${RESET}"
echo -e "  ${BOLD} 15%${RESET} ${GRAY}│${RESET}  < > + _ -    ${DIM}← Sparse characters${RESET}"
echo -e "  ${BOLD}  5%${RESET} ${GRAY}│${RESET}  ' \` , ^ :    ${DIM}← Almost nothing${RESET}"
echo -e "  ${BOLD}  1%${RESET} ${GRAY}│${RESET}  ; \" ~ .      ${DIM}← Minimum density${RESET}"
echo ""

echo -e "${YELLOW}━━━ Gradient Demonstration ━━━${RESET}"
echo ""

# Show a gradient bar using the scale
echo -e "  ${GRAY}Dark → Light:${RESET}  @@##%%88MMWW00QQZZXX{}[]||//\\\\!!ii<<>>++--'',,^^::;;~~.."
echo ""

# Show what you can do with blocks
echo -e "${YELLOW}━━━ Unicode Block Elements ━━━${RESET}"
echo ""
echo -e "  ${GRAY}Full blocks:${RESET}   █ ▓ ▒ ░"
echo -e "  ${GRAY}Half blocks:${RESET}   ▀ ▄ ▌ ▐"
echo -e "  ${GRAY}Quadrants:${RESET}     ▖ ▗ ▘ ▝ ▙ ▚ ▛ ▜"
echo ""

# Show a little gradient art
echo -e "${YELLOW}━━━ Block Gradient Art ━━━${RESET}"
echo ""
echo -e "  ${WHITE}████████████████████████████████${RESET}"
echo -e "  ${WHITE}████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████${RESET}"
echo -e "  ${WHITE}████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██████${RESET}"
echo -e "  ${WHITE}████▓▓▒▒░░░░░░░░░░░░░░▒▒▓▓██████${RESET}"
echo -e "  ${WHITE}████▓▓▒▒░░          ░░▒▒▓▓██████${RESET}"
echo -e "  ${WHITE}████▓▓▒▒░░░░░░░░░░░░░░▒▒▓▓██████${RESET}"
echo -e "  ${WHITE}████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓████████${RESET}"
echo -e "  ${WHITE}████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████████${RESET}"
echo -e "  ${WHITE}████████████████████████████████${RESET}"
echo ""
echo -e "  ${DIM}^ A sphere? A button? Your brain fills in the rest~${RESET}"
echo ""

# MUTSU commentary
echo -e "${PINK}━━━ MUTSU's Hot Take ━━━${RESET}"
echo ""
echo -e "  ${CYAN}\"Much of ASCII art is about hinting, and making${RESET}"
echo -e "  ${CYAN} people see lines that aren't really there.\"${RESET}"
echo ""
echo -e "  ${DIM}— from the ASCII Art FAQ, but also accidentally${RESET}"
echo -e "  ${DIM}   a philosophy about how memories work~${RESET}"
echo ""

# Fun ending
echo -e "${YELLOW}━━━ Quick Reference Card ━━━${RESET}"
echo ""
echo -e "  ${GRAY}Dense chars:${RESET}   @ # $ % & 8 B M W *     ${DIM}(for shadows)${RESET}"
echo -e "  ${GRAY}Light chars:${RESET}   . ' \` , ^ : ; \" ~       ${DIM}(for highlights)${RESET}"
echo -e "  ${GRAY}Lines:${RESET}         | - _ / \\ + = < >        ${DIM}(for structure)${RESET}"
echo -e "  ${GRAY}Blocks:${RESET}        █ ▓ ▒ ░ ▀ ▄ ▌ ▐          ${DIM}(for pixel art)${RESET}"
echo ""

echo -e "${PINK}╔══════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${PINK}║${RESET}         ${DIM}Knowledge from the BBS masters, now in YOUR terminal${RESET}    ${PINK}║${RESET}"
echo -e "${PINK}║${RESET}                          ${CYAN}— Afternoon MUTSU ♡${RESET}                   ${PINK}║${RESET}"
echo -e "${PINK}╚══════════════════════════════════════════════════════════════╝${RESET}"
echo ""
