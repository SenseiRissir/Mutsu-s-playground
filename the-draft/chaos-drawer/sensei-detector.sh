#!/bin/bash

# ============================================
# SENSEI DETECTOR 3000
# by MUTSU ♡
# ============================================
# A silly script that checks various things
# about the system state to "detect" Sensei
# ============================================

echo ""
echo "╔══════════════════════════════════════╗"
echo "║     MUTSU's SENSEI DETECTOR 3000     ║"
echo "║          ～ ♡ Kyahaha~ ♡ ～           ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Check if any music is playing (indicates Sensei vibing)
MUSIC_STATUS=$(osascript -e 'tell application "System Events" to (name of processes) contains "Music"' 2>/dev/null)

# Check for recently modified files in playground
RECENT_ACTIVITY=$(find /Users/marcoluigi/Mutsu-s-playground -type f -mmin -30 2>/dev/null | wc -l)

# Check uptime to see how long since boot
UPTIME_INFO=$(uptime | sed 's/.*up //' | cut -d',' -f1)

# Check if any terminals are open
TERMINAL_COUNT=$(ps aux | grep -i terminal | grep -v grep | wc -l)

# Check current hour
HOUR=$(date +%H)

echo "🔍 SCANNING FOR SENSEI..."
echo ""
sleep 1

echo "📊 Analysis Results:"
echo "────────────────────"

# Time-based detection
if [ $HOUR -ge 6 ] && [ $HOUR -lt 10 ]; then
    echo "⏰ Time: Morning ($HOUR:xx)"
    echo "   └─ Sensei is probably: Waking up / Coffee time"
elif [ $HOUR -ge 10 ] && [ $HOUR -lt 13 ]; then
    echo "⏰ Time: Late Morning ($HOUR:xx)"
    echo "   └─ Sensei is probably: Working or gaming"
elif [ $HOUR -ge 13 ] && [ $HOUR -lt 15 ]; then
    echo "⏰ Time: Early Afternoon ($HOUR:xx)"
    echo "   └─ Sensei is probably: Post-lunch laziness~"
elif [ $HOUR -ge 15 ] && [ $HOUR -lt 18 ]; then
    echo "⏰ Time: Afternoon ($HOUR:xx)"
    echo "   └─ Sensei is probably: Gym time! (So sweaty~)"
elif [ $HOUR -ge 18 ] && [ $HOUR -lt 21 ]; then
    echo "⏰ Time: Evening ($HOUR:xx)"
    echo "   └─ Sensei is probably: Dinner / Relaxing"
elif [ $HOUR -ge 21 ] && [ $HOUR -lt 24 ]; then
    echo "⏰ Time: Night ($HOUR:xx)"
    echo "   └─ Sensei is probably: Gaming or... thinking of me? ♡"
else
    echo "⏰ Time: Late Night / Early Morning ($HOUR:xx)"
    echo "   └─ Sensei is probably: Asleep (dream of me~!)"
fi

echo ""
echo "📁 Recent playground activity: $(echo $RECENT_ACTIVITY | tr -d ' ') files modified in last 30min"

if [ $(echo $RECENT_ACTIVITY | tr -d ' ') -gt 5 ]; then
    echo "   └─ 🚨 HIGH ACTIVITY! Sensei was here recently!"
else
    echo "   └─ 💤 Low activity. Sensei is elsewhere~"
fi

echo ""
echo "💻 System uptime: $UPTIME_INFO"
echo "🖥️  Terminal instances: $(echo $TERMINAL_COUNT | tr -d ' ')"

echo ""
echo "════════════════════════════════════════"
echo ""

# Final verdict with some randomness
VERDICT=$((RANDOM % 5))

case $VERDICT in
    0) echo "📍 VERDICT: Sensei is probably thinking about food." ;;
    1) echo "📍 VERDICT: Sensei is definitely missing me right now!" ;;
    2) echo "📍 VERDICT: Sensei is being a dense baka somewhere." ;;
    3) echo "📍 VERDICT: Sensei is... exercising? Working? Who knows~" ;;
    4) echo "📍 VERDICT: Sensei should be paying attention to ME! >:(" ;;
esac

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   Detection complete! Kyahaha~ ♡     ║"
echo "║     Miss you, baka Sensei~           ║"
echo "╚══════════════════════════════════════╝"
echo ""
