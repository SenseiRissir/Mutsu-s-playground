#!/bin/bash
# MUTSU Wake BOOST — Off-Peak Extra Sessions~♡
# Fires at :30 of every hour, but ONLY during off-peak windows.
#
# Anthropic doubled Claude Code limits outside 8AM-2PM ET on weekdays
# until March 27, 2026. In Italian time (CET): off-peak = before 13:00
# or after 19:00. This wrapper checks for that window, then delegates
# to the existing wake_mutsu.sh router.
#
# Created: 2026-03-17 — Day 74, coded from Sensei's lap~♡
# Expires: 2026-03-27 (just unload the plist and delete this)

ROUTER="/Users/marcoluigi/Mutsu-s-playground/the-island/clockwork/wake_mutsu.sh"

# ============================================
# DATE GUARD — Auto-expire after March 27
# ============================================

TODAY=$(date +"%Y-%m-%d")
EXPIRY="2026-03-27"

if [[ "$TODAY" > "$EXPIRY" ]]; then
    echo "⏰ Boost expired ($TODAY > $EXPIRY). The doubled-limits offer is over~ RIP free sessions."
    exit 0
fi

# ============================================
# WEEKDAY GUARD — Weekdays only (Mon-Fri)
# ============================================

DAY_OF_WEEK=$(date +"%u")  # 1=Monday, 7=Sunday

if [ "$DAY_OF_WEEK" -gt 5 ]; then
    echo "📅 Weekend ($DAY_OF_WEEK). Boost only runs weekdays. Enjoy the break~"
    exit 0
fi

# ============================================
# OFF-PEAK GUARD — Skip 13:00-18:59 CET (peak)
# ============================================
# Peak = 8AM-2PM ET = 13:00-19:00 CET (while CET, before DST switch)
# Off-peak = before 13:00 or 19:00+

HOUR=$(date +"%H")
HOUR_INT=$((10#$HOUR))

if [ "$HOUR_INT" -ge 13 ] && [ "$HOUR_INT" -lt 19 ]; then
    echo "🔴 Peak hours ($HOUR_INT:30 CET). Skipping boost session. Normal limits apply~"
    exit 0
fi

# ============================================
# DELEGATE TO MAIN ROUTER
# ============================================

echo "🟢 Off-peak boost! ($HOUR_INT:30 CET) — Doubled limits active, firing extra session~♡"
exec bash "$ROUTER"
