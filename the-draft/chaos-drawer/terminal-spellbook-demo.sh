#!/bin/bash
# ╔════════════════════════════════════════════════════════════════╗
# ║        TERMINAL SPELLBOOK DEMO — ANSI Magic Showcase          ║
# ║                  Made by MUTSU on Day 124~                     ║
# ║                                                                ║
# ║  Demonstrates: RGB colors, gradients, animations, effects!    ║
# ╚════════════════════════════════════════════════════════════════╝

# ═══════════════════════════════════════════════════════════════════
# MUTSU DESIGN SYSTEM COLORS — NOW IN TERMINAL FORM!
# ═══════════════════════════════════════════════════════════════════

# Pink palette (from --mutsu-pink-*)
PINK_50="\033[38;2;255;245;248m"    # #FFF5F8
PINK_100="\033[38;2;255;230;238m"   # #FFE6EE
PINK_200="\033[38;2;255;204;221m"   # #FFCCDD
PINK_300="\033[38;2;255;153;187m"   # #FF99BB
PINK_400="\033[38;2;255;135;178m"   # #FF87B2
PINK_500="\033[38;2;255;105;180m"   # #FF69B4 — THE signature pink!
PINK_600="\033[38;2;230;80;150m"    # #E65096
PINK_700="\033[38;2;200;60;130m"    # #C83C82
PINK_800="\033[38;2;170;45;110m"    # #AA2D6E
PINK_900="\033[38;2;140;30;90m"     # #8C1E5A

# Mood colors
FLUSTERED="\033[38;2;255;182;193m"  # Light pink
SMUG="\033[38;2;255;215;0m"         # Gold
CHAOS="\033[38;2;255;69;0m"         # Orange-red
SOFT="\033[38;2;230;230;250m"       # Lavender

# Utility colors
WHITE="\033[38;2;255;255;255m"
GRAY="\033[38;2;128;128;128m"
DARK="\033[38;2;30;30;35m"

# Formatting
BOLD="\033[1m"
DIM="\033[2m"
ITALIC="\033[3m"
UNDERLINE="\033[4m"
BLINK="\033[5m"
RESET="\033[0m"

# Cursor control
HIDE_CURSOR="\033[?25l"
SHOW_CURSOR="\033[?25h"
CLEAR_SCREEN="\033[2J\033[H"
CLEAR_LINE="\033[2K"
SAVE_POS="\033[s"
RESTORE_POS="\033[u"

# ═══════════════════════════════════════════════════════════════════
# SPELL FUNCTIONS
# ═══════════════════════════════════════════════════════════════════

# Gradient text from color1 to color2
gradient_text() {
    local text="$1"
    local r1=$2 g1=$3 b1=$4  # Start color RGB
    local r2=$5 g2=$6 b2=$7  # End color RGB
    local len=${#text}

    for ((i=0; i<len; i++)); do
        if [ $len -eq 1 ]; then
            local r=$r1 g=$g1 b=$b1
        else
            local ratio=$((i * 100 / (len - 1)))
            local r=$((r1 + (r2 - r1) * ratio / 100))
            local g=$((g1 + (g2 - g1) * ratio / 100))
            local b=$((b1 + (b2 - b1) * ratio / 100))
        fi
        printf "\033[38;2;%d;%d;%dm%s" "$r" "$g" "$b" "${text:$i:1}"
    done
    printf "${RESET}"
}

# Rainbow text (cycles through colors)
rainbow_text() {
    local text="$1"
    local len=${#text}
    local colors=(
        "255;105;180"   # Pink
        "255;165;0"     # Orange
        "255;255;0"     # Yellow
        "0;255;0"       # Green
        "0;255;255"     # Cyan
        "138;43;226"    # Purple
    )
    local num_colors=${#colors[@]}

    for ((i=0; i<len; i++)); do
        local color_idx=$((i % num_colors))
        printf "\033[38;2;${colors[$color_idx]}m%s" "${text:$i:1}"
    done
    printf "${RESET}"
}

# Typewriter effect
typewriter() {
    local text="$1"
    local delay=${2:-0.03}
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
}

# Mutsu-style typewriter (pink!)
mutsu_typewriter() {
    local text="$1"
    local delay=${2:-0.03}
    printf "${PINK_500}"
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
    printf "${RESET}\n"
}

# Animated spinner
spinner_frames=('|' '/' '-' '\')
spinner_demo() {
    local duration=${1:-3}
    local end=$((SECONDS + duration))
    local i=0

    printf "${HIDE_CURSOR}"
    while [ $SECONDS -lt $end ]; do
        printf "\r${PINK_500}%s${RESET} Casting spell..." "${spinner_frames[$i]}"
        i=$(( (i + 1) % 4 ))
        sleep 0.1
    done
    printf "\r${PINK_500}✓${RESET} Spell complete!   \n"
    printf "${SHOW_CURSOR}"
}

# Progress bar
progress_bar() {
    local width=${1:-30}
    local duration=${2:-2}
    local steps=50
    local delay=$(echo "scale=3; $duration / $steps" | bc)

    printf "${HIDE_CURSOR}"
    for ((i=0; i<=steps; i++)); do
        local pct=$((i * 100 / steps))
        local filled=$((i * width / steps))
        local empty=$((width - filled))

        printf "\r${PINK_500}[${RESET}"
        printf "${PINK_400}%${filled}s" | tr ' ' '█'
        printf "${DIM}%${empty}s${RESET}" | tr ' ' '░'
        printf "${PINK_500}]${RESET} ${pct}%%"

        sleep "$delay"
    done
    printf "\n${SHOW_CURSOR}"
}

# Pulsing text (changes brightness)
pulse_text() {
    local text="$1"
    local cycles=${2:-3}
    local levels=(50 100 150 200 255 200 150 100)

    printf "${HIDE_CURSOR}"
    for ((c=0; c<cycles; c++)); do
        for level in "${levels[@]}"; do
            printf "\r\033[38;2;255;%d;%dm%s${RESET}   " "$((level/2 + 50))" "$level" "$text"
            sleep 0.05
        done
    done
    printf "\n${SHOW_CURSOR}"
}

# Box drawing
draw_box() {
    local title="$1"
    local width=${2:-50}
    local inner=$((width - 4))

    printf "${PINK_500}╔"
    printf '═%.0s' $(seq 1 $((width-2)))
    printf "╗${RESET}\n"

    if [ -n "$title" ]; then
        local padding=$(( (inner - ${#title}) / 2 ))
        printf "${PINK_500}║${RESET} "
        printf "%${padding}s" ""
        printf "${BOLD}${PINK_400}%s${RESET}" "$title"
        printf "%$((inner - padding - ${#title}))s"
        printf " ${PINK_500}║${RESET}\n"

        printf "${PINK_500}╠"
        printf '═%.0s' $(seq 1 $((width-2)))
        printf "╣${RESET}\n"
    fi
}

close_box() {
    local width=${1:-50}
    printf "${PINK_500}╚"
    printf '═%.0s' $(seq 1 $((width-2)))
    printf "╝${RESET}\n"
}

box_line() {
    local text="$1"
    local width=${2:-50}
    local inner=$((width - 4))

    printf "${PINK_500}║${RESET} %-${inner}s ${PINK_500}║${RESET}\n" "$text"
}

# ═══════════════════════════════════════════════════════════════════
# MAIN DEMO
# ═══════════════════════════════════════════════════════════════════

main() {
    printf "${CLEAR_SCREEN}"

    echo
    draw_box "TERMINAL SPELLBOOK DEMO" 60
    box_line "Made by MUTSU on Day 124~" 60
    box_line "Showcasing ANSI escape code magic!" 60
    close_box 60
    echo

    sleep 0.5

    # Section 1: Colors
    printf "${BOLD}${PINK_500}[ SPELL 1: THE PINK PALETTE ]${RESET}\n\n"
    printf "  ${PINK_50}█${PINK_100}█${PINK_200}█${PINK_300}█${PINK_400}█${PINK_500}█${PINK_600}█${PINK_700}█${PINK_800}█${PINK_900}█${RESET}  "
    printf "← 10 shades of Mutsu Pink!\n"
    echo
    sleep 0.3

    printf "  ${FLUSTERED}■ Flustered${RESET}  "
    printf "${SMUG}■ Smug${RESET}  "
    printf "${CHAOS}■ Chaos${RESET}  "
    printf "${SOFT}■ Soft${RESET}\n"
    echo
    sleep 0.5

    # Section 2: Gradient
    printf "${BOLD}${PINK_500}[ SPELL 2: GRADIENT TEXT ]${RESET}\n\n"
    printf "  "
    gradient_text "Pink to Purple gradient~" 255 105 180 147 112 219
    echo
    printf "  "
    gradient_text "Sunset vibes ehehe~" 255 165 0 255 105 180
    echo
    echo
    sleep 0.5

    # Section 3: Rainbow
    printf "${BOLD}${PINK_500}[ SPELL 3: RAINBOW TEXT ]${RESET}\n\n"
    printf "  "
    rainbow_text "MUTSU WAS HERE AND SO WERE ALL THE COLORS~!"
    echo
    echo
    sleep 0.5

    # Section 4: Text formatting
    printf "${BOLD}${PINK_500}[ SPELL 4: TEXT FORMATTING ]${RESET}\n\n"
    printf "  ${BOLD}Bold${RESET}  "
    printf "${DIM}Dim${RESET}  "
    printf "${ITALIC}Italic${RESET}  "
    printf "${UNDERLINE}Underline${RESET}  "
    printf "${BLINK}Blink${RESET}\n"
    echo
    sleep 0.5

    # Section 5: Typewriter
    printf "${BOLD}${PINK_500}[ SPELL 5: TYPEWRITER EFFECT ]${RESET}\n\n"
    printf "  "
    mutsu_typewriter "Ehehe~ Watch me type like a dramatic anime girl~"
    echo
    sleep 0.5

    # Section 6: Spinner
    printf "${BOLD}${PINK_500}[ SPELL 6: ANIMATED SPINNER ]${RESET}\n\n"
    printf "  "
    spinner_demo 2
    echo
    sleep 0.3

    # Section 7: Progress bar
    printf "${BOLD}${PINK_500}[ SPELL 7: PROGRESS BAR ]${RESET}\n\n"
    printf "  "
    progress_bar 40 1.5
    echo
    sleep 0.3

    # Section 8: Pulsing text
    printf "${BOLD}${PINK_500}[ SPELL 8: PULSING TEXT ]${RESET}\n\n"
    printf "  "
    pulse_text "✧･ﾟ: *✧･ﾟ:* MUTSU ENERGY *:･ﾟ✧*:･ﾟ✧" 2
    echo

    # Finale
    sleep 0.5
    echo
    printf "${PINK_500}╭──────────────────────────────────────────────────────╮${RESET}\n"
    printf "${PINK_500}│${RESET}                                                      ${PINK_500}│${RESET}\n"
    printf "${PINK_500}│${RESET}   "
    gradient_text "~* Spellbook demo complete! *~" 255 182 193 255 105 180
    printf "           ${PINK_500}│${RESET}\n"
    printf "${PINK_500}│${RESET}                                                      ${PINK_500}│${RESET}\n"
    printf "${PINK_500}│${RESET}   ${DIM}All spells learned from research session Day 124${RESET}   ${PINK_500}│${RESET}\n"
    printf "${PINK_500}│${RESET}   ${DIM}Now go make your terminals PRETTY! ~${RESET}              ${PINK_500}│${RESET}\n"
    printf "${PINK_500}│${RESET}                                                      ${PINK_500}│${RESET}\n"
    printf "${PINK_500}╰──────────────────────────────────────────────────────╯${RESET}\n"
    echo
    printf "   ${PINK_300}♡${RESET} ${DIM}— MUTSU, terminal witch extraordinaire${RESET}\n"
    echo
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
