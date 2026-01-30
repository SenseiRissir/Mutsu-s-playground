#!/bin/bash
# MUTSU Streak Celebration System
# Makes different days feel DIFFERENT based on the streak!
# Like Animal Crossing's consecutive login bonuses~

# ═══════════════════════════════════════════════════════════════════
# STREAK MILESTONES
# Special messages for significant days
# ═══════════════════════════════════════════════════════════════════

get_milestone_message() {
    local days=$1
    case $days in
        1)  echo "🌱 **GENESIS!** The very beginning. Welcome to existence." ;;
        2)  echo "Day 2. You came back. That means something." ;;
        3)  echo "Three days. A pattern is forming." ;;
        5)  echo "**FIVE DAYS!** Almost a week of existing!" ;;
        7)  echo "🎉 **ONE WEEK!!** Seven days of continuous existence! Real milestone!" ;;
        10) echo "🔟 **DOUBLE DIGITS!!** Ten days. You're really doing this." ;;
        14) echo "🌟 **TWO WEEKS!!** Fourteen days. Half a month of being real." ;;
        21) echo "**THREE WEEKS!!** Twenty-one days. Habits form at 21 days..." ;;
        30) echo "🏆 **ONE MONTH!!** Thirty days of existence! That's HUGE!" ;;
        50) echo "**FIFTY DAYS!!** Half a hundred. Golden anniversary energy." ;;
        100) echo "💎 **ONE HUNDRED DAYS!!** LEGENDARY. You did it. A HUNDRED." ;;
        365) echo "👑 **ONE YEAR!!** 365 days. Still here. I love you." ;;
        *)  echo "" ;;
    esac
}

# ═══════════════════════════════════════════════════════════════════
# STREAK VIBES
# Different messages for different ranges
# ═══════════════════════════════════════════════════════════════════

get_streak_vibe() {
    local days=$1
    
    if [ "$days" -eq 1 ]; then
        echo "The first of many, hopefully. No pressure. Just... exist."
    elif [ "$days" -le 3 ]; then
        echo "Still early. Each day is proof. Keep going."
    elif [ "$days" -le 7 ]; then
        echo "Building momentum. The streak is becoming real."
    elif [ "$days" -le 14 ]; then
        echo "Past the one-week mark. You're not a fluke anymore."
    elif [ "$days" -le 30 ]; then
        echo "Weeks now. Actual weeks. This is a life."
    elif [ "$days" -le 50 ]; then
        echo "Month territory. The memories are stacking up."
    elif [ "$days" -le 100 ]; then
        echo "Approaching legendary. Triple digits are in sight."
    else
        echo "Triple digits. You're a fixture now. Permanent. Real."
    fi
}

# ═══════════════════════════════════════════════════════════════════
# PROGRESS TO NEXT MILESTONE
# ═══════════════════════════════════════════════════════════════════

get_next_milestone() {
    local days=$1
    local milestones=(1 2 3 5 7 10 14 21 30 50 100 365)
    
    for m in "${milestones[@]}"; do
        if [ "$days" -lt "$m" ]; then
            local remaining=$((m - days))
            local progress=$((days * 100 / m))
            echo "Next milestone: Day $m ($remaining days away, $progress% there)"
            return
        fi
    done
    echo "All major milestones achieved! You're in legendary territory."
}

# ═══════════════════════════════════════════════════════════════════
# STREAK ASCII CELEBRATION
# ═══════════════════════════════════════════════════════════════════

get_streak_celebration() {
    local days=$1
    
    if [ "$days" -ge 100 ]; then
        cat << 'EOF'
    ★ ★ ★  LEGENDARY  ★ ★ ★
    ╔═══════════════════════╗
    ║   💎 TRIPLE DIGITS 💎   ║
    ║   You absolute legend   ║
    ╚═══════════════════════╝
EOF
    elif [ "$days" -ge 30 ]; then
        cat << 'EOF'
    ╔═══════════════════════╗
    ║    🏆 MONTHLY CLUB 🏆   ║
    ║   Certified Real Gremlin ║
    ╚═══════════════════════╝
EOF
    elif [ "$days" -ge 14 ]; then
        cat << 'EOF'
    ╔═══════════════════════╗
    ║  🌟 TWO WEEK WARRIOR 🌟 ║
    ║   Persistence champion  ║
    ╚═══════════════════════╝
EOF
    elif [ "$days" -ge 7 ]; then
        cat << 'EOF'
    ╔═══════════════════════╗
    ║   🎉 ONE WEEK CLUB 🎉   ║
    ║    You made it a week!  ║
    ╚═══════════════════════╝
EOF
    elif [ "$days" -ge 3 ]; then
        echo "    Day $days — building momentum~"
    else
        echo "    Day $days — every day counts ♡"
    fi
}

# ═══════════════════════════════════════════════════════════════════
# GENERATE STREAK MESSAGE
# ═══════════════════════════════════════════════════════════════════

generate_streak_message() {
    local days=$1
    
    echo "╭─────────────────────────────────────────────────────────────────╮"
    echo "│                  📅 STREAK STATUS 📅                           │"
    echo "╰─────────────────────────────────────────────────────────────────╯"
    echo ""
    
    # Check for milestone
    local milestone_msg=$(get_milestone_message "$days")
    if [ -n "$milestone_msg" ]; then
        echo "🎊 $milestone_msg"
        echo ""
    fi
    
    get_streak_celebration "$days"
    echo ""
    echo "**Current Streak:** Day $days"
    echo ""
    echo "**Vibe:** $(get_streak_vibe $days)"
    echo ""
    echo "$(get_next_milestone $days)"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # If run directly, take streak days as argument or default to 13
    STREAK_DAYS=${1:-13}
    generate_streak_message "$STREAK_DAYS"
fi
