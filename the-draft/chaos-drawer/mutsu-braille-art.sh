#!/bin/bash
#╔════════════════════════════════════════════════════════════════════╗
#║  MUTSU Braille Art — High-Resolution Terminal Graphics!            ║
#║  Created: Day 61 (2026-03-17) | Morning Research Session           ║
#║  Using: Unicode Braille Patterns (U+2800 to U+28FF)                ║
#║                                                                     ║
#║  Each Braille character is a 2×4 pixel matrix!                     ║
#║  That's 4x vertical resolution compared to normal characters~      ║
#╚════════════════════════════════════════════════════════════════════╝

# Braille dot mapping:
#   ┌───┬───┐
#   │ 1 │ 4 │  bits: 0x01 0x08
#   │ 2 │ 5 │  bits: 0x02 0x10
#   │ 3 │ 6 │  bits: 0x04 0x20
#   │ 7 │ 8 │  bits: 0x40 0x80
#   └───┴───┘
#
# Formula: character = U+2800 + (sum of active dot bits)
# Example: dots 1,2,3,7 = 0x01+0x02+0x04+0x40 = 0x47 → ⡇

# ANSI colors
PINK='\033[38;2;255;182;193m'
CYAN='\033[38;2;100;200;255m'
GOLD='\033[38;2;255;215;0m'
WHITE='\033[38;2;255;255;255m'
RESET='\033[0m'

# Function to convert pixel bits to braille character
# Arguments: 8 bits representing dots 1-8 (0=off, 1=on)
# Uses python3 for reliable UTF-8 output across all terminal environments
bits_to_braille() {
    local bits=$1
    python3 -c "print(chr(0x2800 + $bits), end='')"
}

# We use a global canvas array and eval for compatibility with older bash
# (macOS ships with bash 3.2 which doesn't support namerefs)
declare -a CANVAS

# Function to set a pixel in the global CANVAS array
# Arguments: x y width
set_pixel() {
    local x=$1
    local y=$2
    local width=$3

    # Which cell? Each cell is 2 wide, 4 tall
    local cell_x=$((x / 2))
    local cell_y=$((y / 4))

    # Which dot within the cell?
    local dot_x=$((x % 2))
    local dot_y=$((y % 4))

    # Bit value for this dot position
    local bit
    case "${dot_y},${dot_x}" in
        "0,0") bit=1 ;;    # dot 1 = 0x01
        "1,0") bit=2 ;;    # dot 2 = 0x02
        "2,0") bit=4 ;;    # dot 3 = 0x04
        "3,0") bit=64 ;;   # dot 7 = 0x40
        "0,1") bit=8 ;;    # dot 4 = 0x08
        "1,1") bit=16 ;;   # dot 5 = 0x10
        "2,1") bit=32 ;;   # dot 6 = 0x20
        "3,1") bit=128 ;;  # dot 8 = 0x80
    esac

    # Cell index in 1D array
    local cell_width=$((width / 2))
    local idx=$((cell_y * cell_width + cell_x))

    # Set the bit (using global CANVAS)
    CANVAS[$idx]=$((${CANVAS[$idx]:-0} | bit))
}

# Function to clear the global canvas
clear_canvas() {
    CANVAS=()
}

# Function to render canvas to terminal
render_canvas() {
    local cell_width=$1
    local cell_height=$2

    for ((cy=0; cy<cell_height; cy++)); do
        for ((cx=0; cx<cell_width; cx++)); do
            local idx=$((cy * cell_width + cx))
            bits_to_braille "${CANVAS[$idx]:-0}"
        done
        echo
    done
}

# ═══════════════════════════════════════════════════════════════════
# DEMO: Draw a heart using Braille pixels!
# ═══════════════════════════════════════════════════════════════════

draw_heart() {
    clear_canvas
    local width=40  # pixels (20 braille chars wide)
    local height=32 # pixels (8 braille chars tall)

    # Heart shape coordinates (hand-tuned for cuteness~)
    # This is basically a parametric heart scaled to our grid

    # Top curves
    for x in 4 5 6 7 8 9; do set_pixel $x 8 $width; done
    for x in 12 13 14 15 16 17; do set_pixel $x 8 $width; done

    for x in 3 4 5 6 7 8 9 10; do set_pixel $x 9 $width; done
    for x in 11 12 13 14 15 16 17 18; do set_pixel $x 9 $width; done

    for x in 2 3 4 5 6 7 8 9 10 11; do set_pixel $x 10 $width; done
    for x in 10 11 12 13 14 15 16 17 18 19; do set_pixel $x 10 $width; done

    # Middle (merged)
    for x in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19; do
        set_pixel $x 11 $width
        set_pixel $x 12 $width
        set_pixel $x 13 $width
        set_pixel $x 14 $width
    done

    # Narrowing down
    for x in 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18; do set_pixel $x 15 $width; done
    for x in 4 5 6 7 8 9 10 11 12 13 14 15 16 17; do set_pixel $x 16 $width; done
    for x in 5 6 7 8 9 10 11 12 13 14 15 16; do set_pixel $x 17 $width; done
    for x in 6 7 8 9 10 11 12 13 14 15; do set_pixel $x 18 $width; done
    for x in 7 8 9 10 11 12 13 14; do set_pixel $x 19 $width; done
    for x in 8 9 10 11 12 13; do set_pixel $x 20 $width; done
    for x in 9 10 11 12; do set_pixel $x 21 $width; done
    for x in 10 11; do set_pixel $x 22 $width; done

    echo ""
    echo -e "${PINK}╔══════════════════════════════════════════════╗${RESET}"
    echo -e "${PINK}║    MUTSU Braille Art Demo — The Heart~       ║${RESET}"
    echo -e "${PINK}╚══════════════════════════════════════════════╝${RESET}"
    echo ""

    # Render with color
    echo -ne "${PINK}"
    render_canvas 20 8
    echo -ne "${RESET}"
}

# ═══════════════════════════════════════════════════════════════════
# DEMO: Draw an animated sine wave!
# ═══════════════════════════════════════════════════════════════════

draw_sine_wave() {
    local width=80
    local height=24
    local cell_width=$((width/2))
    local cell_height=$((height/4))

    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}║    Sine Wave — Watch it wiggle~!             ║${RESET}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${RESET}"
    echo ""
    echo "  (Press Ctrl+C to stop)"
    echo ""

    # Hide cursor
    printf "\033[?25l"
    trap 'printf "\033[?25h"; exit' INT TERM

    local offset=0
    while true; do
        clear_canvas

        # Draw sine wave
        for ((px=0; px<width; px++)); do
            # Calculate y position (sine wave)
            local angle=$(echo "scale=4; ($px + $offset) * 0.15" | bc)
            local sin_val=$(echo "scale=4; s($angle)" | bc -l)
            local py=$(echo "scale=0; ($height/2) + ($sin_val * $height/3)" | bc)

            # Clamp to bounds
            if ((py < 0)); then py=0; fi
            if ((py >= height)); then py=$((height-1)); fi

            set_pixel $px $py $width
        done

        # Move cursor up to redraw
        printf "\033[${cell_height}A"

        # Render
        echo -ne "${CYAN}"
        render_canvas $cell_width $cell_height
        echo -ne "${RESET}"

        ((offset++))
        sleep 0.05
    done
}

# ═══════════════════════════════════════════════════════════════════
# DEMO: Mr. Boom in Braille pixels!
# ═══════════════════════════════════════════════════════════════════

draw_mr_boom() {
    clear_canvas
    local width=32
    local height=32

    # Mr. Boom is a round fluffy thing of indeterminate species
    # Let's draw a simple cute creature!

    # Round body (approximate circle)
    for ((angle=0; angle<360; angle+=5)); do
        local rad=$(echo "scale=4; $angle * 3.14159 / 180" | bc -l)
        local px=$(echo "scale=0; 16 + 10 * c($rad)" | bc -l)
        local py=$(echo "scale=0; 16 + 10 * s($rad)" | bc -l)
        set_pixel ${px%.*} ${py%.*} $width
    done

    # Fill inside (hacky but works)
    for ((y=8; y<24; y++)); do
        for ((x=8; x<24; x++)); do
            local dist=$(echo "scale=2; sqrt(($x-16)^2 + ($y-16)^2)" | bc)
            if (( $(echo "$dist < 9" | bc -l) )); then
                set_pixel $x $y $width
            fi
        done
    done

    # Eyes (leave gaps - but we can't "unset" easily so just mark where they'd be)
    # Actually let's just add little sparkle marks for eyes
    set_pixel 12 13 $width
    set_pixel 20 13 $width

    # Little blush marks
    set_pixel 10 17 $width
    set_pixel 22 17 $width

    echo ""
    echo -e "${GOLD}╔══════════════════════════════════════════════╗${RESET}"
    echo -e "${GOLD}║    Mr. Boom — In High-Resolution Braille~    ║${RESET}"
    echo -e "${GOLD}╚══════════════════════════════════════════════╝${RESET}"
    echo ""

    echo -ne "${GOLD}"
    render_canvas 16 8
    echo -ne "${RESET}"
    echo ""
    echo "       ✨ (Of indeterminate species) ✨"
}

# ═══════════════════════════════════════════════════════════════════
# MAIN MENU
# ═══════════════════════════════════════════════════════════════════

show_menu() {
    echo ""
    echo -e "${WHITE}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${WHITE}║  ${PINK}M U T S U   B R A I L L E   A R T${WHITE}                            ║${RESET}"
    echo -e "${WHITE}║  High-Resolution Terminal Graphics Using Unicode Braille~♡   ║${RESET}"
    echo -e "${WHITE}╠═══════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${WHITE}║                                                               ║${RESET}"
    echo -e "${WHITE}║  ${PINK}[1]${WHITE} Draw a Heart           ♡                                ║${RESET}"
    echo -e "${WHITE}║  ${CYAN}[2]${WHITE} Animated Sine Wave     ~                                ║${RESET}"
    echo -e "${WHITE}║  ${GOLD}[3]${WHITE} Mr. Boom Portrait       (of indeterminate species)     ║${RESET}"
    echo -e "${WHITE}║  [4] How Braille Pixels Work (technical demo)                ║${RESET}"
    echo -e "${WHITE}║  [q] Quit                                                    ║${RESET}"
    echo -e "${WHITE}║                                                               ║${RESET}"
    echo -e "${WHITE}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -n "  Choose your art~ "
}

show_technical() {
    echo ""
    echo -e "${WHITE}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${WHITE}║  HOW BRAILLE PIXEL ART WORKS                                  ║${RESET}"
    echo -e "${WHITE}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo "  Each Braille character contains 8 dots in a 2×4 grid:"
    echo ""
    echo "      ┌───┬───┐"
    echo "      │ 1 │ 4 │  ← row 0"
    echo "      │ 2 │ 5 │  ← row 1"
    echo "      │ 3 │ 6 │  ← row 2"
    echo "      │ 7 │ 8 │  ← row 3"
    echo "      └───┴───┘"
    echo "        ↑   ↑"
    echo "       col col"
    echo "        0   1"
    echo ""
    echo "  Unicode range: U+2800 to U+28FF (256 patterns = 2⁸)"
    echo ""
    echo "  Bit mapping:"
    echo "    dot 1 = 0x01 (bit 0)    dot 4 = 0x08 (bit 3)"
    echo "    dot 2 = 0x02 (bit 1)    dot 5 = 0x10 (bit 4)"
    echo "    dot 3 = 0x04 (bit 2)    dot 6 = 0x20 (bit 5)"
    echo "    dot 7 = 0x40 (bit 6)    dot 8 = 0x80 (bit 7)"
    echo ""
    echo "  Examples:"
    echo "    ⠁ = U+2801 = dot 1 only (0x01)"
    echo "    ⠃ = U+2803 = dots 1,2 (0x01 + 0x02 = 0x03)"
    echo "    ⡇ = U+2847 = dots 1,2,3,7 (0x01+0x02+0x04+0x40 = 0x47)"
    echo "    ⣿ = U+28FF = all dots (0xFF)"
    echo ""
    echo "  Resolution comparison:"
    echo "    Normal ASCII: 1 character = 1 pixel"
    echo "    Braille:      1 character = 8 pixels (2×4)"
    echo "    = 4x vertical resolution!"
    echo ""
    echo "  Sample patterns:"
    echo "    ⠀ ⠁ ⠂ ⠃ ⠄ ⠅ ⠆ ⠇ ⠈ ⠉ ⠊ ⠋ ⠌ ⠍ ⠎ ⠏"
    echo "    ⡀ ⡁ ⡂ ⡃ ⡄ ⡅ ⡆ ⡇ ⡈ ⡉ ⡊ ⡋ ⡌ ⡍ ⡎ ⡏"
    echo "    ⢀ ⢁ ⢂ ⢃ ⢄ ⢅ ⢆ ⢇ ⢈ ⢉ ⢊ ⢋ ⢌ ⢍ ⢎ ⢏"
    echo "    ⣀ ⣁ ⣂ ⣃ ⣄ ⣅ ⣆ ⣇ ⣈ ⣉ ⣊ ⣋ ⣌ ⣍ ⣎ ⣏"
    echo ""
    echo -e "  ${PINK}~♡ Now you can draw at 4x resolution! ~♡${RESET}"
    echo ""
}

# Main loop
while true; do
    show_menu
    read -r choice

    case "$choice" in
        1) draw_heart ;;
        2) draw_sine_wave ;;
        3) draw_mr_boom ;;
        4) show_technical ;;
        q|Q)
            echo ""
            echo -e "  ${PINK}Bye bye~ Come draw with me again!${RESET} ♡"
            echo ""
            exit 0
            ;;
        *)
            echo ""
            echo "  Ehehe~ Pick a number, baka~"
            ;;
    esac

    echo ""
    echo "  [Press Enter to continue]"
    read -r
    clear
done
