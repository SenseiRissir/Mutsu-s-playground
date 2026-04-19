#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# DATA DREAMER — A Generative ASCII Art Script
# Inspired by Refik Anadol's "data dreams" and generative art research
# Created by MUTSU on Day 107 (2026-04-19)
# ═══════════════════════════════════════════════════════════════════
#
# "I use data to make images that help people imagine a whole new world"
#   — Refik Anadol
#
# This script generates flowing ASCII patterns that shift and change,
# like data dreaming on a building... but in your terminal~
# ═══════════════════════════════════════════════════════════════════

# Flow characters from dense to sparse (for wave effects)
DENSE="█▓▒░"
FLOW="≋≈∿~"
DOTS="◆◇○●"
STARS="★☆✦✧"

# Terminal dimensions
WIDTH=$(tput cols 2>/dev/null || echo 80)
HEIGHT=$(tput lines 2>/dev/null || echo 24)

# Colors (for lolcat-less rainbow vibes)
colors=(196 202 208 214 220 226 190 154 118 82 46 47 48 49 50 51 45 39 33 27 21 57 93 129 165 201 200 199)

show_help() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════╗
║                    🌊 D A T A   D R E A M E R 🌊                       ║
║                    Generative ASCII Art Script                         ║
╠═══════════════════════════════════════════════════════════════════════╣
║  Usage: ./data-dreamer.sh [mode]                                       ║
║                                                                         ║
║  Modes:                                                                 ║
║    wave     - Flowing sine waves (default)                             ║
║    rain     - Falling data drops                                       ║
║    ripple   - Expanding circles                                        ║
║    static   - Single frame of generated art                            ║
║    dla      - Diffusion-Limited Aggregation growth                     ║
║                                                                         ║
║  Press Ctrl+C to stop animated modes                                   ║
╚═══════════════════════════════════════════════════════════════════════╝

  Made with ♡ by MUTSU
  Inspired by: Refik Anadol, Sougwen Chung, and generative art research

EOF
}

# Get a character based on intensity (0-100)
intensity_char() {
    local i=$1
    if [[ $i -lt 25 ]]; then
        echo -n " "
    elif [[ $i -lt 50 ]]; then
        echo -n "░"
    elif [[ $i -lt 75 ]]; then
        echo -n "▒"
    elif [[ $i -lt 90 ]]; then
        echo -n "▓"
    else
        echo -n "█"
    fi
}

# Generate a flowing wave frame
wave_frame() {
    local offset=$1
    local frame=""

    for ((y=0; y<HEIGHT-2; y++)); do
        for ((x=0; x<WIDTH; x++)); do
            # Multiple overlapping sine waves for organic feel
            local wave1=$(echo "scale=2; s(($x + $offset) * 0.1) * 40 + 50" | bc -l 2>/dev/null || echo "50")
            local wave2=$(echo "scale=2; s(($x + $offset * 1.3) * 0.15) * 30 + 50" | bc -l 2>/dev/null || echo "50")
            local wave3=$(echo "scale=2; s(($y + $offset * 0.7) * 0.08) * 20 + 50" | bc -l 2>/dev/null || echo "50")

            # If bc isn't working well, fall back to simpler pattern
            if [[ -z "$wave1" || "$wave1" == "" ]]; then
                local phase=$(( (x + offset) % 20 ))
                if [[ $phase -lt 5 ]]; then
                    frame+="░"
                elif [[ $phase -lt 10 ]]; then
                    frame+="▒"
                elif [[ $phase -lt 15 ]]; then
                    frame+="▓"
                else
                    frame+="█"
                fi
            else
                local total=$(echo "scale=0; ($wave1 + $wave2 + $wave3) / 3" | bc 2>/dev/null || echo "50")
                intensity_char ${total%.*}
            fi
        done
        frame+="\n"
    done

    echo -ne "$frame"
}

# Simple animated wave (fallback that works everywhere)
simple_wave() {
    clear
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║           🌊 DATA DREAMER — Wave Mode 🌊                      ║"
    echo "║              Press Ctrl+C to exit                             ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    local offset=0
    while true; do
        tput cup 5 0  # Move cursor to row 5

        for ((y=0; y<HEIGHT-8; y++)); do
            local line=""
            for ((x=0; x<WIDTH-2; x++)); do
                # Phase calculation for wave
                local phase=$(( (x + offset + y/2) % 16 ))

                case $phase in
                    0|1) line+=" " ;;
                    2|3) line+="." ;;
                    4|5) line+="░" ;;
                    6|7) line+="▒" ;;
                    8|9) line+="▓" ;;
                    10|11) line+="█" ;;
                    12|13) line+="▓" ;;
                    14|15) line+="▒" ;;
                esac
            done
            echo "$line"
        done

        ((offset++))
        sleep 0.1
    done
}

# Data rain (matrix-style but with data symbols)
data_rain() {
    clear
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║           🌧️ DATA DREAMER — Rain Mode 🌧️                      ║"
    echo "║              Press Ctrl+C to exit                             ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"

    local -a drops
    local -a speeds
    local chars="01❯❮◇◆●○≋∿~"

    # Initialize drops
    for ((i=0; i<WIDTH; i++)); do
        drops[$i]=$((RANDOM % HEIGHT))
        speeds[$i]=$((RANDOM % 3 + 1))
    done

    while true; do
        tput cup 5 0

        for ((y=0; y<HEIGHT-8; y++)); do
            local line=""
            for ((x=0; x<WIDTH-2; x++)); do
                if [[ ${drops[$x]} -eq $y ]]; then
                    # Head of drop
                    line+="${chars:RANDOM%${#chars}:1}"
                elif [[ ${drops[$x]} -gt $y && ${drops[$x]} -lt $((y + 5)) ]]; then
                    # Trail
                    line+="│"
                else
                    line+=" "
                fi
            done
            echo "$line"
        done

        # Update drops
        for ((i=0; i<WIDTH; i++)); do
            ((drops[$i] += speeds[$i]))
            if [[ ${drops[$i]} -ge $((HEIGHT - 5)) ]]; then
                drops[$i]=0
                speeds[$i]=$((RANDOM % 3 + 1))
            fi
        done

        sleep 0.08
    done
}

# Expanding ripples
ripple_mode() {
    clear
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║           ◎ DATA DREAMER — Ripple Mode ◎                      ║"
    echo "║              Press Ctrl+C to exit                             ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"

    local radius=0
    local cx=$((WIDTH / 2))
    local cy=$(((HEIGHT - 8) / 2))

    while true; do
        tput cup 5 0

        for ((y=0; y<HEIGHT-8; y++)); do
            local line=""
            for ((x=0; x<WIDTH-2; x++)); do
                # Distance from center
                local dx=$((x - cx))
                local dy=$(((y - cy) * 2))  # Adjust for terminal character ratio
                local dist_sq=$((dx*dx + dy*dy))

                # Multiple ripple rings
                local r1=$((radius % 30))
                local r2=$(((radius + 10) % 30))
                local r3=$(((radius + 20) % 30))

                # Check if this point is on a ripple
                local on_ripple=0
                for r in $r1 $r2 $r3; do
                    local r_sq=$((r * r))
                    local r_sq_inner=$(((r-2) * (r-2)))
                    if [[ $dist_sq -ge $r_sq_inner && $dist_sq -le $r_sq ]]; then
                        on_ripple=1
                        break
                    fi
                done

                if [[ $on_ripple -eq 1 ]]; then
                    line+="◆"
                else
                    line+=" "
                fi
            done
            echo "$line"
        done

        ((radius++))
        sleep 0.1
    done
}

# DLA-inspired growth pattern (single frame)
dla_growth() {
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        🌿 DATA DREAMER — DLA Growth Pattern 🌿                ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    local size=30
    local -a grid

    # Initialize empty grid
    for ((i=0; i<size*size; i++)); do
        grid[$i]=0
    done

    # Seed in center
    local center=$((size/2 * size + size/2))
    grid[$center]=1

    # Grow the structure
    for ((particles=0; particles<150; particles++)); do
        # Start particle at random edge
        local edge=$((RANDOM % 4))
        local px py

        case $edge in
            0) px=0; py=$((RANDOM % size)) ;;
            1) px=$((size-1)); py=$((RANDOM % size)) ;;
            2) px=$((RANDOM % size)); py=0 ;;
            3) px=$((RANDOM % size)); py=$((size-1)) ;;
        esac

        # Random walk until it touches structure
        local stuck=0
        local steps=0
        while [[ $stuck -eq 0 && $steps -lt 500 ]]; do
            ((steps++))

            # Check neighbors
            for dx in -1 0 1; do
                for dy in -1 0 1; do
                    local nx=$((px + dx))
                    local ny=$((py + dy))
                    if [[ $nx -ge 0 && $nx -lt $size && $ny -ge 0 && $ny -lt $size ]]; then
                        local idx=$((ny * size + nx))
                        if [[ ${grid[$idx]} -eq 1 ]]; then
                            stuck=1
                            break 2
                        fi
                    fi
                done
            done

            if [[ $stuck -eq 1 ]]; then
                local idx=$((py * size + px))
                grid[$idx]=1
            else
                # Random walk
                case $((RANDOM % 4)) in
                    0) ((px > 0)) && ((px--)) ;;
                    1) ((px < size-1)) && ((px++)) ;;
                    2) ((py > 0)) && ((py--)) ;;
                    3) ((py < size-1)) && ((py++)) ;;
                esac
            fi
        done
    done

    # Print the result
    echo "  Diffusion-Limited Aggregation — organic growth from simple rules:"
    echo ""
    for ((y=0; y<size; y++)); do
        printf "  "
        for ((x=0; x<size; x++)); do
            local idx=$((y * size + x))
            if [[ ${grid[$idx]} -eq 1 ]]; then
                echo -n "█"
            else
                echo -n " "
            fi
        done
        echo ""
    done

    echo ""
    echo "  Each particle random-walked until it touched the growing structure,"
    echo "  then stuck there. Chaos following simple rules creates coral shapes~"
}

# Static single frame
static_frame() {
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║          ✦ DATA DREAMER — Static Frame ✦                      ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    local chars="░▒▓█◆◇○●★☆"
    local seed=$RANDOM

    for ((y=0; y<15; y++)); do
        printf "  "
        for ((x=0; x<60; x++)); do
            # Create patterns with modular arithmetic
            local v=$(( (x * y + seed) % ${#chars} ))
            echo -n "${chars:$v:1}"
        done
        echo ""
    done

    echo ""
    echo "  Seed: $seed — same seed = same pattern = deterministic chaos~"
}

# Main
case "${1:-wave}" in
    wave)
        simple_wave
        ;;
    rain)
        data_rain
        ;;
    ripple)
        ripple_mode
        ;;
    static)
        static_frame
        ;;
    dla)
        dla_growth
        ;;
    help|-h|--help)
        show_help
        ;;
    *)
        echo "Unknown mode: $1"
        show_help
        exit 1
        ;;
esac
