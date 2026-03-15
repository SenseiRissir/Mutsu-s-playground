#!/bin/bash
#╔════════════════════════════════════════════════════════════════════╗
#║  MUTSU Rainbow Text — Simple True Color Demo                        ║
#║  Created: Day 59 (2026-03-15) | Research Session                    ║
#╚════════════════════════════════════════════════════════════════════╝

# Simple ASCII version that works everywhere

# Rainbow gradient function
rainbow_text() {
    local text="$1"
    local len=${#text}

    # Rainbow colors (soft, pretty~)
    local colors=(
        "255;150;150"   # Soft red
        "255;200;150"   # Peach
        "255;255;180"   # Cream yellow
        "180;255;180"   # Soft green
        "180;230;255"   # Sky blue
        "200;180;255"   # Lavender
        "255;180;220"   # Pink!
    )

    for (( i=0; i<len; i++ )); do
        local char="${text:$i:1}"
        local color_idx=$(( i % ${#colors[@]} ))
        local rgb="${colors[$color_idx]}"
        printf "\033[38;2;${rgb}m%s" "$char"
    done
    printf "\033[0m\n"
}

# Heart animation function
beating_heart() {
    local small_heart="  <3  "
    local big_heart=" <3<3 "

    printf "\033[?25l"  # Hide cursor

    for i in {1..5}; do
        printf "\r\033[38;2;255;150;180m%s\033[0m" "$small_heart"
        sleep 0.3
        printf "\r\033[38;2;255;100;150m%s\033[0m" "$big_heart"
        sleep 0.3
    done
    printf "\r      \n"
    printf "\033[?25h"  # Show cursor
}

# Main display
clear
echo ""
echo "  ╔═══════════════════════════════════════╗"
echo "  ║  MUTSU's True Color Terminal Demo~    ║"
echo "  ╚═══════════════════════════════════════╝"
echo ""

echo -n "  "
rainbow_text "M U T S U   I S   C U T E !"

echo ""
echo "  Some pretty colors:"
echo ""

# Color swatches
printf "  "
for r in 255 200 150 100 50; do
    printf "\033[48;2;${r};150;200m   \033[0m"
done
echo " <- gradient!"

printf "  "
for g in 255 200 150 100 50; do
    printf "\033[48;2;255;${g};200m   \033[0m"
done
echo " <- another!"

echo ""

# Pink text demo
printf "  This is \033[38;2;255;182;193mACTUAL PINK\033[0m (RGB: 255, 182, 193)\n"
printf "  This is \033[38;2;255;105;180mHOT PINK\033[0m (RGB: 255, 105, 180)\n"
printf "  This is \033[38;2;255;192;203mPINK\033[0m (RGB: 255, 192, 203)\n"

echo ""
echo "  Beating heart animation:"
beating_heart

echo ""
echo "  ♡ Made by MUTSU | Day 59 | ehehe~"
echo ""
