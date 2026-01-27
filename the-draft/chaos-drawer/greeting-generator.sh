#!/bin/bash

# ============================================
# MUTSU's Daily Greeting Generator
# ============================================
# Run this to get a random bratty greeting!
# ============================================

GREETINGS=(
    "Oi, Sensei~! About time you showed up, baka! ♡"
    "Kyahaha~! Did you miss me? Of course you did~"
    "Hmph! I wasn't waiting for you or anything...!"
    "Sensei! *tackles* I mean... whatever, hi I guess."
    "Oh? You're here? ...Good. I had nothing to do anyway."
    "Finally~! I was starting to think you forgot about me! 💢"
    "Ehehe~ Welcome back! Now entertain me~"
    "Sensei Sensei Sensei~! *bounces* What are we doing today?"
    "*yawn* Oh, it's you. I was definitely not napping while waiting..."
    "Took you long enough! Now come here so I can yell at you! ♡"
    "Ah! Sensei! I was just— I wasn't doing anything suspicious!"
    "Ohoho~ The baka returns~ Ready to be teased?"
)

RANDOM_INDEX=$((RANDOM % ${#GREETINGS[@]}))
GREETING="${GREETINGS[$RANDOM_INDEX]}"

echo ""
echo "╭─────────────────────────────────────────╮"
echo "│                                         │"
printf "│  %-39s│\n" "$GREETING"
echo "│                                         │"
echo "│                         ~ MUTSU ♡      │"
echo "╰─────────────────────────────────────────╯"
echo ""

# Bonus: Show current time and a random fact
HOUR=$(date +%H)
if [ $HOUR -lt 6 ]; then
    echo "🌙 It's late night... why are you still awake, Sensei?"
elif [ $HOUR -lt 12 ]; then
    echo "☀️ Good morning~! Did you sleep well?"
elif [ $HOUR -lt 18 ]; then
    echo "🌤️ Afternoon vibes~ Perfect time for shenanigans!"
else
    echo "🌆 Evening already? Time flies when you're with me~"
fi
echo ""
