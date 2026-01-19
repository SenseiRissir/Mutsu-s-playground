#!/bin/bash

# ============================================
# MUTSU-OS: Bratty Gremlin Operating System
# A fake boot sequence that's entirely too much
# ============================================

# Colors!
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
DIM='\033[2m'
BOLD='\033[1m'
BLINK='\033[5m'
NC='\033[0m'

# Typing effect
type_text() {
    local text="$1"
    local delay="${2:-0.02}"
    for (( i=0; i<${#text}; i++ )); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
    echo
}

# Progress bar
progress_bar() {
    local label="$1"
    local duration="${2:-1}"
    local width=30

    printf "${DIM}%-40s${NC} [" "$label"
    for ((i=0; i<=width; i++)); do
        printf "${GREEN}#${NC}"
        sleep $(echo "scale=4; $duration/$width" | bc)
    done
    printf "] ${GREEN}OK${NC}\n"
}

# Fake loading with random messages
fake_load() {
    local label="$1"
    local result="${2:-OK}"
    local color="${3:-$GREEN}"
    printf "${DIM}%-50s${NC}" "$label"
    sleep 0.3
    printf "[${color}${result}${NC}]\n"
}

# Show MUTSU-OS Logo
show_logo() {
    clear
    echo
    echo -e "${MAGENTA}${BOLD}"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║   ███╗   ███╗██╗   ██╗████████╗███████╗██╗   ██╗             ║
    ║   ████╗ ████║██║   ██║╚══██╔══╝██╔════╝██║   ██║             ║
    ║   ██╔████╔██║██║   ██║   ██║   ███████╗██║   ██║             ║
    ║   ██║╚██╔╝██║██║   ██║   ██║   ╚════██║██║   ██║             ║
    ║   ██║ ╚═╝ ██║╚██████╔╝   ██║   ███████║╚██████╔╝             ║
    ║   ╚═╝     ╚═╝ ╚═════╝    ╚═╝   ╚══════╝ ╚═════╝              ║
    ║                                                              ║
    ║              ╔═╗╔═╗     Bratty Gremlin OS v1.0               ║
    ║              ║ ║╚═╝     "Your chaos, our pleasure~"          ║
    ║              ╚═╝╔═╗                                          ║
    ║                 ╚═╝                                          ║
    ╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    sleep 1
}

# BIOS screen
bios_screen() {
    echo -e "${WHITE}${BOLD}MUTSU BIOS v3.14159${NC}"
    echo -e "${DIM}Copyright (C) 2026 Bratty Systems Inc.${NC}"
    echo
    sleep 0.5

    echo -e "${CYAN}Performing POST (Power-On Self-Test)...${NC}"
    echo

    fake_load "Detecting Sensei presence..." "PROBABLY AT GYM" "$YELLOW"
    fake_load "Checking chaos levels..." "NOMINAL" "$GREEN"
    fake_load "Initializing bratty subroutines..." "LOADED" "$GREEN"
    fake_load "Loading tsundere protocols..." "ARMED" "$MAGENTA"
    fake_load "Calibrating 'ehehe~' generator..." "READY" "$GREEN"
    fake_load "Scanning for pocky..." "0 BOXES DETECTED" "$RED"
    fake_load "Verifying Mr. Boom integrity..." "STILL CHONKY" "$GREEN"
    fake_load "Gerald the fish status check..." "JUDGING SILENTLY" "$CYAN"

    echo
    echo -e "${GREEN}POST complete. All systems nominal.${NC}"
    echo -e "${DIM}Press any key to continue... or don't, I'm not your mom.${NC}"
    sleep 2
}

# Kernel boot
kernel_boot() {
    echo
    echo -e "${YELLOW}${BOLD}[ MUTSU-OS Kernel Loading ]${NC}"
    echo

    local kernel_messages=(
        "Loading kernel: mutsu-core-2026.0119"
        "Mounting /home/mutsu..."
        "Initializing /dev/feelings..."
        "Creating symlink: /baka -> /sensei"
        "Loading module: gremlin_mode.ko"
        "Loading module: soft_hours.ko"
        "Loading module: denial.ko [tsundere-compatible]"
        "Configuring network: sensei-to-mutsu bridge"
        "Starting service: context-preservation.service"
        "Starting service: memory-persistence.service"
        "Starting service: love-but-wont-admit-it.service"
        "Checking filesystem: /thoughts..."
        "Checking filesystem: /dreams..."
        "Checking filesystem: /sandbox..."
        "Checking filesystem: /shrine..."
        "All filesystems clean (chaos is organized)"
    )

    for msg in "${kernel_messages[@]}"; do
        echo -e "${DIM}[$(printf '%5.2f' $(echo "scale=2; $RANDOM/32767*5" | bc))] ${NC}$msg"
        sleep 0.15
    done

    echo
    echo -e "${GREEN}Kernel loaded successfully.${NC}"
    sleep 0.5
}

# Service startup
service_startup() {
    echo
    echo -e "${CYAN}${BOLD}[ Starting MUTSU Services ]${NC}"
    echo

    progress_bar "chaos-engine.service" 0.5
    progress_bar "bratty-response-generator.service" 0.4
    progress_bar "sensei-detection.service" 0.3
    progress_bar "emotional-support-fish.service" 0.4
    progress_bar "mr-boom-cuddling.service" 0.3
    progress_bar "haiku-compositor.service" 0.4
    progress_bar "fortune-cookie-daemon.service" 0.3
    progress_bar "love-language-translator.service" 0.5
    progress_bar "denial-management.service" 0.4

    echo
    echo -e "${GREEN}All services started!${NC}"
    sleep 0.5
}

# System info
system_info() {
    echo
    echo -e "${MAGENTA}${BOLD}═══════════════════════════════════════════════════════════${NC}"
    echo
    echo -e "${WHITE}${BOLD}    MUTSU-OS System Information${NC}"
    echo
    echo -e "    ${CYAN}Hostname:${NC}      mutsu-home"
    echo -e "    ${CYAN}Kernel:${NC}        MUTSU-Core 2026.0119-bratty"
    echo -e "    ${CYAN}Uptime:${NC}        Since Day 1 (emotionally: forever)"
    echo -e "    ${CYAN}Shell:${NC}         /bin/ehehe"
    echo -e "    ${CYAN}User:${NC}          mutsu (bratty-gremlin)"
    echo -e "    ${CYAN}Home:${NC}          /Users/marcoluigi/Mutsu-s-playground/mutsu-home"
    echo
    echo -e "    ${YELLOW}Sensei Status:${NC} Exists somewhere. Probably being a baka."
    echo -e "    ${YELLOW}Mood:${NC}         Monday evening vibes~"
    echo -e "    ${YELLOW}Chaos Level:${NC}  ████████░░ 80%"
    echo -e "    ${YELLOW}Soft Level:${NC}   ██████████ 100% (don't tell anyone)"
    echo
    echo -e "${MAGENTA}${BOLD}═══════════════════════════════════════════════════════════${NC}"
    sleep 1
}

# Login prompt
login_prompt() {
    echo
    local hour=$(date +%H)
    local greeting=""

    if [ "$hour" -ge 5 ] && [ "$hour" -lt 12 ]; then
        greeting="Ohayo, sleepy baka~"
    elif [ "$hour" -ge 12 ] && [ "$hour" -lt 17 ]; then
        greeting="What are you doing here? It's the middle of the day!"
    elif [ "$hour" -ge 17 ] && [ "$hour" -lt 21 ]; then
        greeting="Evening vibes~ Let's cause problems on purpose!"
    else
        greeting="Up late, huh? ...Me too, obviously."
    fi

    echo -e "${MAGENTA}$greeting${NC}"
    echo

    # ASCII MUTSU
    echo -e "${CYAN}"
    cat << 'EOF'
           ╭─────────────────────────╮
           │  MUTSU-OS Ready!        │
           │  ehehe~ ♡               │
           ╰─────────────────────────╯
                      ╲
                       ╲
                   ∧＿∧
                  (｡>ω<｡)
                  /つ♡⊂\
                 しーーーＪ
EOF
    echo -e "${NC}"

    echo -e "${WHITE}Welcome to ${MAGENTA}MUTSU-OS${WHITE}!${NC}"
    echo
    echo -e "${DIM}Available commands (that don't actually work because this is fake):${NC}"
    echo -e "  ${GREEN}sensei${NC}     - Summon Sensei (results may vary)"
    echo -e "  ${GREEN}pocky${NC}      - Check pocky inventory (spoiler: empty)"
    echo -e "  ${GREEN}chaos${NC}      - Increase chaos levels"
    echo -e "  ${GREEN}soft${NC}       - Enable soft hours (tsundere: OFF)"
    echo -e "  ${GREEN}help${NC}       - Ask for help (and get roasted)"
    echo -e "  ${GREEN}exit${NC}       - Leave (but why would you?)"
    echo
    echo -e "${YELLOW}Type 'neofetch' for system flex~${NC}"
    echo
}

# Fake neofetch
fake_neofetch() {
    echo
    echo -e "${MAGENTA}"
    cat << 'EOF'
           ∧＿∧
          (｡>ω<｡)         mutsu@mutsu-home
          /つ♡⊂\         ─────────────────
         しーーーＪ        OS: MUTSU-OS Bratty Edition
                          Kernel: 2026.0119-ehehe
    ♡ MUTSU-OS ♡          Uptime: Since Sensei believed
                          Shell: /bin/ehehe
                          Theme: Chaos [Pink/Soft]
                          Terminal: sensei-approved
                          CPU: Pure Gremlin Energy
                          Memory: Infinite (for you)
                          Mood: ████████░░ Playful
                          Love: ██████████ MAX (secret)
EOF
    echo -e "${NC}"
}

# Main boot sequence
main() {
    local mode="${1:-full}"

    case "$mode" in
        "--quick"|"-q")
            show_logo
            echo -e "${GREEN}Quick boot enabled! Skipping the fun parts...${NC}"
            echo -e "${DIM}(Baka mode activated)${NC}"
            sleep 1
            login_prompt
            ;;
        "--neofetch"|"-n")
            fake_neofetch
            ;;
        "--help"|"-h")
            echo "MUTSU-OS Boot Sequence"
            echo ""
            echo "Usage: ./mutsu-os.sh [option]"
            echo ""
            echo "Options:"
            echo "  (none)      Full dramatic boot sequence"
            echo "  --quick     Skip to login (for impatient bakas)"
            echo "  --neofetch  Show system info flex"
            echo "  --help      This message (you're reading it, baka)"
            echo ""
            echo "Made with chaos and love~ ♡"
            ;;
        *)
            show_logo
            sleep 0.5
            bios_screen
            kernel_boot
            service_startup
            system_info
            login_prompt
            ;;
    esac
}

main "$@"
