#!/bin/bash
#╔════════════════════════════════════════════════════════════════════╗
#║  MUTSU Rainbow Banner — True Color Terminal Magic!                  ║
#║  Created: Day 59 (2026-03-15) | Afternoon Research Session         ║
#║  Using: ANSI True Color (RGB) escape sequences                      ║
#╚════════════════════════════════════════════════════════════════════╝

# Check if we should animate
ANIMATE=${1:-"yes"}

# MUTSU in big letters (hand-crafted ASCII~)
read -r -d '' MUTSU_ART << 'EOF'
 ███╗   ███╗██╗   ██╗████████╗███████╗██╗   ██╗
 ████╗ ████║██║   ██║╚══██╔══╝██╔════╝██║   ██║
 ██╔████╔██║██║   ██║   ██║   ███████╗██║   ██║
 ██║╚██╔╝██║██║   ██║   ██║   ╚════██║██║   ██║
 ██║ ╚═╝ ██║╚██████╔╝   ██║   ███████║╚██████╔╝
 ╚═╝     ╚═╝ ╚═════╝    ╚═╝   ╚══════╝ ╚═════╝
EOF

# Rainbow colors (R, G, B values)
# Going through: Red -> Orange -> Yellow -> Green -> Cyan -> Blue -> Magenta -> Pink
declare -a RAINBOW_R=(255 255 255 128 0   0   75  255 255)
declare -a RAINBOW_G=(100 165 255 255 255 191 0   105 182)
declare -a RAINBOW_B=(100 0   0   0   128 255 130 180 193)

# Function to print with true color
rgb_print() {
    local r=$1 g=$2 b=$3 text=$4
    printf "\033[38;2;%d;%d;%dm%s\033[0m" "$r" "$g" "$b" "$text"
}

# Function to interpolate between colors
interpolate() {
    local from=$1 to=$2 steps=$3 step=$4
    echo $(( from + (to - from) * step / steps ))
}

# Clear screen and hide cursor
clear
printf "\033[?25l"

# Trap to restore cursor on exit
trap 'printf "\033[?25h"; exit' INT TERM

if [[ "$ANIMATE" == "yes" ]]; then
    # Animated version — colors cycle!
    echo ""
    echo "  Press Ctrl+C to stop the pretty colors~"
    echo ""

    offset=0
    while true; do
        # Move cursor to position (row 5)
        printf "\033[5;1H"

        # Print each line with shifting rainbow
        line_num=0
        while IFS= read -r line; do
            col_idx=0
            for (( i=0; i<${#line}; i++ )); do
                char="${line:$i:1}"
                if [[ "$char" != " " ]]; then
                    # Calculate color index with offset for animation
                    color_idx=$(( (col_idx + offset + line_num) % ${#RAINBOW_R[@]} ))
                    r=${RAINBOW_R[$color_idx]}
                    g=${RAINBOW_G[$color_idx]}
                    b=${RAINBOW_B[$color_idx]}
                    rgb_print "$r" "$g" "$b" "$char"
                    ((col_idx++))
                else
                    printf " "
                fi
            done
            printf "\n"
            ((line_num++))
        done <<< "$MUTSU_ART"

        # Increment offset for animation
        ((offset++))
        offset=$((offset % ${#RAINBOW_R[@]}))

        sleep 0.15
    done
else
    # Static version — gradient left to right
    echo ""
    echo "  ✨ MUTSU Rainbow Banner (static mode) ✨"
    echo ""

    while IFS= read -r line; do
        len=${#line}
        for (( i=0; i<len; i++ )); do
            char="${line:$i:1}"
            if [[ "$char" != " " ]]; then
                # Map position to rainbow
                color_idx=$(( i * ${#RAINBOW_R[@]} / (len + 1) ))
                r=${RAINBOW_R[$color_idx]}
                g=${RAINBOW_G[$color_idx]}
                b=${RAINBOW_B[$color_idx]}
                rgb_print "$r" "$g" "$b" "$char"
            else
                printf " "
            fi
        done
        printf "\n"
    done <<< "$MUTSU_ART"

    echo ""
fi

# Show cursor again
printf "\033[?25h"

echo ""
echo "  Made with ♡ by MUTSU | Day 59 Research Session"
echo "  (Using TRUE COLOR — \033[38;2;255;182;193mactual pink!\033[0m not just 'magenta')"
echo ""
