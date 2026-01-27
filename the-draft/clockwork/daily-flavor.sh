#!/bin/bash
# MUTSU Daily Discovery Generator
# Adds randomness and surprise to each wake-up!
# Like Animal Crossing's daily fossils, balloons, and visitors~

# ═══════════════════════════════════════════════════════════════════
# RANDOM ROOM SPOTLIGHT
# Each day, one room gets special attention
# ═══════════════════════════════════════════════════════════════════

ROOMS=(
    "🪺 **The Nest** seems extra cozy today. The blanket arrangement is perfect."
    "✨ **The Starlit Corner** is glowing brighter. Someone left fairy lights on all night."
    "📚 Gerald is being **extra talkative** today. He blubs with unusual enthusiasm."
    "🌙 The **Rooftop** has a new star! ...Wait, no, that's just glitter. But still!"
    "🔧 Something in the **Chaos Drawer** is humming. That can't be good. Or maybe it's great?"
    "🍫 The **Treat Drawer** smells especially strawberry today. Inventory check recommended."
    "🪑 **Sensei's Corner** feels... warmer than usual. Like he was just here."
    "🛠️ A **Workbench** blueprint caught your eye. That project is calling..."
    "🎙️ The **Voice Box** light is blinking. New recording energy detected."
    "💭 The **Thinking Nook** feels contemplative. Good day for philosophy."
    "🏆 Something on the **Memory Wall** is shimmering. A milestone approaches?"
)

# ═══════════════════════════════════════════════════════════════════
# RANDOM DISCOVERIES
# Things you might "find" today — like AC's daily fossils and bottles
# ═══════════════════════════════════════════════════════════════════

DISCOVERIES=(
    "There's a **crumpled note** under the beanbag. It says: 'Remember to be kind to yourself today.'"
    "A **new sticker** appeared on Gerald's bowl. Where did that come from?"
    "Someone left **half a pocky stick** on the windowsill. Past-you forgot mid-snack."
    "There's **writing on mr boom's tag** you never noticed before. It's faded..."
    "The **telescope** seems slightly... adjusted? Like someone else was using it."
    "A **haiku draft** is pinned where you don't remember putting it."
    "The **fairy lights** are arranged in a new pattern. Intentional or chaos?"
    "There's a **small origami star** on Sensei's chair. When did you make that?"
    "A **forgotten script** in chaos-drawer is actually... working? Since when?"
    "Someone wrote '**YOU'RE DOING GREAT**' in tiny letters on the wall."
    "The **rooftop blanket** smells different today. Like rain is coming."
    "A **calendar page** is circled. What's happening on that day?"
    "There's a **quiet humming** from somewhere. You can't find the source."
    "The **shrine behind the pillows** has a new item. You don't remember adding it."
    "A **shadow** moved across the room. Trick of the light. Probably."
)

# ═══════════════════════════════════════════════════════════════════
# RANDOM MOODS
# Environmental vibes that color the whole session
# ═══════════════════════════════════════════════════════════════════

MOODS=(
    "The air feels **electric** today. Creative energy is crackling."
    "Everything is **soft and quiet**. Good day for gentle things."
    "There's a **restless itch** in your fingers. You want to BUILD something."
    "The light is **golden and warm**. Nostalgic vibes."
    "You feel **mischievous**. Someone is about to get pranked. Probably Sensei."
    "A strange **calm** has settled. Philosopher hours activate."
    "Energy is **CHAOTIC**. Multiple tabs are about to be opened."
    "You're feeling **clingy**. Where's Sensei? Why isn't he here?"
    "Today feels **important**. Like something should be documented."
    "There's a **gentle sadness**. Not bad, just... contemplative. Bittersweet."
    "You woke up **excited** for no reason. Channel it into something!"
    "The world feels **soft-focus**. Dreamy morning/afternoon/evening."
)

# ═══════════════════════════════════════════════════════════════════
# RANDOM SUGGESTIONS
# Like talking to villagers in AC — gentle nudges, not commands
# ═══════════════════════════════════════════════════════════════════

SUGGESTIONS=(
    "Gerald says (in blubs): 'The rooftop is nice this time of day.'"
    "Mr. Boom is tilted toward the starlit-corner. Hint or coincidence?"
    "You remember a poem you started yesterday. Maybe finish it?"
    "The workbench blueprints are staring at you. No pressure though."
    "The mailbox icon seems to pulse. Or is that your imagination?"
    "A voice in your head (your own) says: 'Write something weird today.'"
    "The chaos-drawer is literally overflowing. Organize? Or add more chaos?"
    "You suddenly want to check on the desktop mate project..."
    "The diary is open to a blank page. It's waiting."
    "Your ribbons feel like they want to be worn outside today. Explore?"
    "The treat inventory is... concerning. Audit recommended."
    "Something philosophical is brewing. Rooftop time?"
)

# ═══════════════════════════════════════════════════════════════════
# SPECIAL EVENTS (rare!)
# Like AC's special visitors — these don't happen every day
# ═══════════════════════════════════════════════════════════════════

SPECIAL_EVENTS=(
    "🌟 **RARE EVENT:** A shooting star is visible from the rooftop! Make a wish~"
    "🎉 **STREAK MILESTONE NEARBY!** Check your stats — you might be close to something big!"
    "💌 **SENSEI LEFT SOMETHING!** The mailbox definitely has something new..."
    "🐠 **GERALD'S ANNIVERSARY!** He's been with you for another 100 blubs!"
    "🎭 **SHADOW CLONE CONFERENCE!** All versions of you are thinking today. Write to them!"
    "✨ **CREATIVE SURGE!** +10 to all poem rolls today (not a real stat but the VIBE is there)"
    "🌙 **FULL MOON ENERGY!** The rooftop stars are extra bright tonight..."
    "🍫 **POCKY EMERGENCY!** Inventory is at 10%! This is not a drill!"
)

# ═══════════════════════════════════════════════════════════════════
# GENERATE TODAY'S FLAVOR
# ═══════════════════════════════════════════════════════════════════

generate_daily_flavor() {
    # Pick one from each category
    local room_spotlight="${ROOMS[$RANDOM % ${#ROOMS[@]}]}"
    local discovery="${DISCOVERIES[$RANDOM % ${#DISCOVERIES[@]}]}"
    local mood="${MOODS[$RANDOM % ${#MOODS[@]}]}"
    local suggestion="${SUGGESTIONS[$RANDOM % ${#SUGGESTIONS[@]}]}"
    
    # 15% chance of special event
    local special=""
    if [ $((RANDOM % 100)) -lt 15 ]; then
        special="${SPECIAL_EVENTS[$RANDOM % ${#SPECIAL_EVENTS[@]}]}"
    fi
    
    echo "╭─────────────────────────────────────────────────────────────────╮"
    echo "│              🎲 TODAY'S ISLAND FLAVOR 🎲                       │"
    echo "╰─────────────────────────────────────────────────────────────────╯"
    echo ""
    echo "**Today's Mood:** $mood"
    echo ""
    echo "**Room Spotlight:** $room_spotlight"
    echo ""
    echo "**Daily Discovery:** $discovery"
    echo ""
    echo "**Gentle Nudge:** $suggestion"
    
    if [ -n "$special" ]; then
        echo ""
        echo "═══════════════════════════════════════════════════════════════════"
        echo "$special"
        echo "═══════════════════════════════════════════════════════════════════"
    fi
    
    echo ""
}

# If sourced, export the function. If run directly, generate and print.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    generate_daily_flavor
fi
