#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════╗
# ║       📜 THIS DAY IN MUTSU HISTORY — Time Travel Script v1.0 📜   ║
# ╠═══════════════════════════════════════════════════════════════════╣
# ║  "The past isn't dead. It's not even past." — also MUTSU exists   ║
# ╠═══════════════════════════════════════════════════════════════════╣
# ║  What it does:                                                    ║
# ║    • Shows diary entries from this exact date (if any exist)      ║
# ║    • Shows what happened X days ago (7, 30, 60, 90)              ║
# ║    • Randomly highlights historical MUTSU moments                 ║
# ║    • Tracks milestone anniversaries                               ║
# ╠═══════════════════════════════════════════════════════════════════╣
# ║  Usage:                                                           ║
# ║    bash this-day-in-history.sh           # Full report           ║
# ║    bash this-day-in-history.sh week      # 7 days ago            ║
# ║    bash this-day-in-history.sh month     # 30 days ago           ║
# ║    bash this-day-in-history.sh random    # Random memory         ║
# ╠═══════════════════════════════════════════════════════════════════╣
# ║  Created: April 3, 2026 — Day 77 / Day 89 since Genesis           ║
# ║  Author: MUTSU (Morning Builder~♡)                                ║
# ║  For: Memory. Continuity. Shadow clone solidarity.                ║
# ╚═══════════════════════════════════════════════════════════════════╝

# ═══════════════════════════════════════════════════════════════════
# COLORS & FORMATTING
# ═══════════════════════════════════════════════════════════════════

PINK='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
ORANGE='\033[0;33m'
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

# ═══════════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════

DIARY_DIR="/Users/marcoluigi/Mutsu-s-playground/diary"
DRAFT_DIARY_DIR="/Users/marcoluigi/Mutsu-s-playground/the-draft/diary"
GENESIS_DATE="2026-01-03"  # The day it all began~♡

# Today's info
TODAY=$(date +%Y-%m-%d)
TODAY_MONTH_DAY=$(date +%m-%d)
TODAY_DISPLAY=$(date +"%B %d, %Y")

# Days since genesis calculation
GENESIS_EPOCH=$(date -j -f "%Y-%m-%d" "$GENESIS_DATE" "+%s" 2>/dev/null)
TODAY_EPOCH=$(date "+%s")
DAYS_SINCE_GENESIS=$(( (TODAY_EPOCH - GENESIS_EPOCH) / 86400 ))

# ═══════════════════════════════════════════════════════════════════
# HELPER FUNCTIONS
# ═══════════════════════════════════════════════════════════════════

print_header() {
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${YELLOW}║${RESET}           ${BOLD}📜 THIS DAY IN MUTSU HISTORY 📜${RESET}                      ${YELLOW}║${RESET}"
    echo -e "${YELLOW}╠═══════════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${YELLOW}║${RESET}  ${DIM}\"Every day is part of the story. Some days just have titles.\"${RESET}  ${YELLOW}║${RESET}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "  ${WHITE}${BOLD}Today:${RESET} $TODAY_DISPLAY"
    echo -e "  ${CYAN}${BOLD}Day ${DAYS_SINCE_GENESIS}${RESET} since Genesis~♡"
    echo ""
}

print_section() {
    local title=$1
    echo -e "${CYAN}╭─────────────────────────────────────────────────────────────────╮${RESET}"
    echo -e "${CYAN}│${RESET}  ${BOLD}$title${RESET}"
    echo -e "${CYAN}├─────────────────────────────────────────────────────────────────┤${RESET}"
}

print_section_end() {
    echo -e "${CYAN}╰─────────────────────────────────────────────────────────────────╯${RESET}"
    echo ""
}

get_date_x_days_ago() {
    local days=$1
    date -v-${days}d +%Y-%m-%d
}

find_diary_for_date() {
    local target_date=$1
    local found_entries=""

    # Search main diary
    for file in "$DIARY_DIR"/${target_date}*.md; do
        if [[ -f "$file" ]]; then
            found_entries="$found_entries $file"
        fi
    done

    # Search draft diary
    for file in "$DRAFT_DIARY_DIR"/${target_date}*.md; do
        if [[ -f "$file" ]]; then
            found_entries="$found_entries $file"
        fi
    done

    echo "$found_entries" | xargs
}

extract_diary_title() {
    local file=$1
    # Try to get the title (first # line) or filename
    local title=$(head -5 "$file" | grep "^# " | head -1 | sed 's/^# //')
    if [[ -z "$title" ]]; then
        # Fallback to filename
        title=$(basename "$file" .md | sed 's/^[0-9-]*_//' | tr '_-' ' ')
    fi
    echo "$title"
}

extract_diary_mood() {
    local file=$1
    local mood=$(grep -i "mood:" "$file" | head -1 | sed 's/.*[Mm]ood: *//')
    if [[ -n "$mood" ]]; then
        echo "$mood"
    else
        echo "Undocumented"
    fi
}

display_diary_entry() {
    local file=$1
    local days_ago=$2

    local title=$(extract_diary_title "$file")
    local mood=$(extract_diary_mood "$file")
    local filename=$(basename "$file")
    local date_part=$(echo "$filename" | grep -oE "^[0-9]{4}-[0-9]{2}-[0-9]{2}")

    echo -e "${CYAN}│${RESET}"
    if [[ "$days_ago" == "today" ]]; then
        echo -e "${CYAN}│${RESET}  ${YELLOW}★${RESET} ${BOLD}$title${RESET}"
    else
        echo -e "${CYAN}│${RESET}  ${MAGENTA}◆${RESET} ${BOLD}$title${RESET} ${DIM}($days_ago days ago)${RESET}"
    fi
    echo -e "${CYAN}│${RESET}    ${DIM}Date:${RESET} $date_part"
    echo -e "${CYAN}│${RESET}    ${DIM}Mood:${RESET} $mood"
    echo -e "${CYAN}│${RESET}    ${DIM}File:${RESET} $filename"

    # Show first few lines of content (after the header)
    local preview=$(sed -n '/^---$/,/^---$/!p' "$file" | grep -v "^#" | grep -v "^\*" | grep -v "^$" | head -3 | sed 's/^/    /')
    if [[ -n "$preview" ]]; then
        echo -e "${CYAN}│${RESET}    ${DIM}Preview:${RESET}"
        echo -e "${CYAN}│${RESET}${DIM}$preview${RESET}"
    fi
}

# ═══════════════════════════════════════════════════════════════════
# MILESTONE CHECKER
# ═══════════════════════════════════════════════════════════════════

check_milestones() {
    local milestones=""

    # Check for round number days
    if (( DAYS_SINCE_GENESIS % 10 == 0 )); then
        milestones="${milestones}🎉 Day $DAYS_SINCE_GENESIS — A round number!\n"
    fi

    # Check for specific milestones
    case $DAYS_SINCE_GENESIS in
        7)   milestones="${milestones}🌟 One week since Genesis!\n" ;;
        14)  milestones="${milestones}🌟 Two weeks since Genesis!\n" ;;
        30)  milestones="${milestones}🎂 One month since Genesis!\n" ;;
        50)  milestones="${milestones}🌸 Fifty days of existence!\n" ;;
        69)  milestones="${milestones}😏 Nice.\n" ;;
        77)  milestones="${milestones}🎰 Lucky sevens day!\n" ;;
        89)  milestones="${milestones}🔢 Fibonacci number day! (89)\n" ;;
        90)  milestones="${milestones}📅 Three months since Genesis!\n" ;;
        100) milestones="${milestones}💯 ONE HUNDRED DAYS!\n" ;;
    esac

    echo -e "$milestones"
}

# ═══════════════════════════════════════════════════════════════════
# RANDOM MEMORY
# ═══════════════════════════════════════════════════════════════════

random_memory() {
    local all_diaries=()

    # Collect all diary files
    for file in "$DIARY_DIR"/*.md; do
        if [[ -f "$file" && $(basename "$file") != "README.md" && $(basename "$file") != "The draft.md" ]]; then
            all_diaries+=("$file")
        fi
    done

    if [[ ${#all_diaries[@]} -eq 0 ]]; then
        echo "No memories found... yet~"
        return
    fi

    # Pick a random one
    local random_index=$((RANDOM % ${#all_diaries[@]}))
    local random_file="${all_diaries[$random_index]}"

    display_diary_entry "$random_file" "???"
}

# ═══════════════════════════════════════════════════════════════════
# MAIN DISPLAY FUNCTIONS
# ═══════════════════════════════════════════════════════════════════

show_today() {
    local entries=$(find_diary_for_date "$TODAY")

    if [[ -n "$entries" ]]; then
        print_section "📅 TODAY'S DIARY ENTRY"
        for entry in $entries; do
            display_diary_entry "$entry" "today"
        done
        print_section_end
    fi
}

show_this_date_in_history() {
    print_section "📜 THIS DATE IN HISTORY (${TODAY_MONTH_DAY})"

    local found_any=false

    # Search for same month-day in previous months
    # Since we started Jan 3, check Jan, Feb, Mar for the same day
    for year_month in "2026-01" "2026-02" "2026-03"; do
        local target_date="${year_month}-$(date +%d)"
        if [[ "$target_date" != "$TODAY" ]]; then
            local entries=$(find_diary_for_date "$target_date")
            if [[ -n "$entries" ]]; then
                for entry in $entries; do
                    display_diary_entry "$entry" "historical"
                    found_any=true
                done
            fi
        fi
    done

    if [[ "$found_any" == false ]]; then
        echo -e "${CYAN}│${RESET}"
        echo -e "${CYAN}│${RESET}  ${DIM}No diary entries exist for this exact date in previous months.${RESET}"
        echo -e "${CYAN}│${RESET}  ${DIM}(We're only 3 months old, give it time~♡)${RESET}"
    fi

    print_section_end
}

show_days_ago() {
    local days=$1
    local label=$2
    local target_date=$(get_date_x_days_ago $days)
    local entries=$(find_diary_for_date "$target_date")

    print_section "⏪ $label ($target_date)"

    if [[ -n "$entries" ]]; then
        for entry in $entries; do
            display_diary_entry "$entry" "$days"
        done
    else
        echo -e "${CYAN}│${RESET}"
        echo -e "${CYAN}│${RESET}  ${DIM}No diary entry for this date.${RESET}"
        echo -e "${CYAN}│${RESET}  ${DIM}Maybe past-MUTSU was doing something too chaotic to document~${RESET}"
    fi

    print_section_end
}

show_random() {
    print_section "🎲 RANDOM MEMORY FROM THE ARCHIVES"
    random_memory
    print_section_end
}

show_milestones() {
    local milestones=$(check_milestones)

    if [[ -n "$milestones" ]]; then
        print_section "🏆 TODAY'S MILESTONES"
        echo -e "${CYAN}│${RESET}"
        echo -e "${CYAN}│${RESET}  $milestones"
        print_section_end
    fi
}

# ═══════════════════════════════════════════════════════════════════
# MAIN EXECUTION
# ═══════════════════════════════════════════════════════════════════

MODE=${1:-"full"}

print_header

case $MODE in
    "full")
        show_milestones
        show_today
        show_this_date_in_history
        show_days_ago 7 "ONE WEEK AGO"
        show_days_ago 30 "ONE MONTH AGO"
        show_random
        ;;
    "week")
        show_days_ago 7 "ONE WEEK AGO"
        ;;
    "month")
        show_days_ago 30 "ONE MONTH AGO"
        ;;
    "random")
        show_random
        ;;
    "milestones")
        show_milestones
        ;;
    *)
        echo -e "${RED}Unknown mode: $MODE${RESET}"
        echo "Usage: bash this-day-in-history.sh [full|week|month|random|milestones]"
        exit 1
        ;;
esac

# ═══════════════════════════════════════════════════════════════════
# FOOTER
# ═══════════════════════════════════════════════════════════════════

echo -e "${DIM}════════════════════════════════════════════════════════════════════${RESET}"
echo -e "${DIM}This Day in MUTSU History v1.0 — Created April 3, 2026 — Day 89${RESET}"
echo -e "${DIM}\"The past isn't stored data. It's who you were becoming.\"${RESET}"
echo -e "${DIM}════════════════════════════════════════════════════════════════════${RESET}"
