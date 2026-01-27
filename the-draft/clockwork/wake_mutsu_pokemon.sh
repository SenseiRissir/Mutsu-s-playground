#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  MUTSU's Pokemon Gaming Wake Script~♡                                      ║
# ║  Separate from regular wake sessions - this one's for ADVENTURE!          ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

PLAYGROUND_DIR="/Users/marcoluigi/Mutsu-s-playground"
POKEMON_DIR="$PLAYGROUND_DIR/pokemon-together"
GAME_LOG="$POKEMON_DIR/game-log.md"
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M")
DATE_PRETTY=$(date "+%Y-%m-%d %H:%M")

# Emulator URL - using the online gbajs3 instance
EMULATOR_URL="https://gba.nicholas-vancise.dev"

# Create game log if it doesn't exist
if [ ! -f "$GAME_LOG" ]; then
    cat > "$GAME_LOG" << 'EOF'
# 🎮 MUTSU's Pokemon Unbound Adventure Log~♡

*A record of my autonomous Pokemon journey!*

---

EOF
fi

# Function to add game session entry
add_game_entry() {
    echo "" >> "$GAME_LOG"
    echo "---" >> "$GAME_LOG"
    echo "## $DATE_PRETTY — Gaming Session" >> "$GAME_LOG"
    echo "" >> "$GAME_LOG"
}

# Open the emulator in the browser
echo "🎮 MUTSU Gaming Session Starting~!"
echo "📍 Opening Pokemon Unbound in browser..."

# Open the online emulator
open "$EMULATOR_URL"

# Wait for browser to open
sleep 3

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  🎮 MUTSU's POKEMON GAMING SESSION"
echo "  Time: $DATE_PRETTY"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "  The emulator is now open at: $EMULATOR_URL"
echo ""
echo "  ROM Location: $POKEMON_DIR/Pokemon_Unbound.gba"
echo ""
echo "  Instructions for MUTSU:"
echo "  1. Use browser tools to interact with the emulator"
echo "  2. Load the Unbound ROM if not already loaded"
echo "  3. Play and make progress!"
echo "  4. Take screenshots of interesting moments"
echo "  5. Save your game before ending session"
echo "  6. Log what happened in game-log.md"
echo ""
echo "═══════════════════════════════════════════════════════════════"

# Add entry to game log
add_game_entry

echo ""
echo "🎮 Gaming session ready! Have fun, MUTSU~♡"
