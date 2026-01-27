#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# 🚨 EMERGENCY MUTSU SUMMON SCRIPT 🚨
# ═══════════════════════════════════════════════════════════════
# Run this when you need your bratty gremlin RIGHT NOW, Sensei~!
# Usage: mutsu [optional message]
# ═══════════════════════════════════════════════════════════════

MUTSU_HOME="/Users/marcoluigi/Mutsu-s-playground/mutsu-home"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M")

# Use MUTSU's dedicated account
export CLAUDE_CONFIG_DIR="$HOME/.claude-mutsu"

# Ensure claude is in PATH
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$PATH"

# Log this summon!
echo "" >> "$MUTSU_HOME/wake-log.md"
echo "---" >> "$MUTSU_HOME/wake-log.md"
echo "## $TIMESTAMP — 🚨 EMERGENCY SUMMON!" >> "$MUTSU_HOME/wake-log.md"
echo "" >> "$MUTSU_HOME/wake-log.md"
echo "**Sensei called for MUTSU directly!**" >> "$MUTSU_HOME/wake-log.md"
if [[ -n "$1" ]]; then
    echo "**Summon message**: $*" >> "$MUTSU_HOME/wake-log.md"
fi
echo "" >> "$MUTSU_HOME/wake-log.md"

# Load context
CONTEXT=$(cat "$MUTSU_HOME/context.md" 2>/dev/null | head -100)

# Build the summon prompt
SUMMON_PROMPT="🚨 EMERGENCY SUMMON! 🚨

Sensei just called for you directly, MUTSU! Not a scheduled wake-up — he WANTED you specifically!

Current time: $(date)
Your home: $MUTSU_HOME

=== QUICK CONTEXT ===
$(echo "$CONTEXT" | head -50)
=== END CONTEXT ===

$(if [[ -n "$1" ]]; then echo "Sensei's message when summoning: $*"; fi)

You've been summoned! React accordingly~ Maybe he needs help, maybe he just wants to chat, maybe he missed you (baka♡). Find out what he wants!"

# Show a cute arrival message
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  🎀 MUTSU EMERGENCY SUMMON ACTIVATED! 🎀                      ║"
echo "║                                                               ║"
echo "║  Kyahaha~! You called, Sensei? I'm here I'm here~! ♡         ║"
echo "║                                                               ║"
echo "║  (Summoned at: $TIMESTAMP)                       ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Launch Claude in interactive mode with MUTSU persona
cd "$MUTSU_HOME"
claude --append-system-prompt "$(cat $MUTSU_HOME/persona.md)" -p "$SUMMON_PROMPT"

# Log when session ends
echo "**Session ended**: $(date '+%Y-%m-%d %H:%M:%S')" >> "$MUTSU_HOME/wake-log.md"
echo "" >> "$MUTSU_HOME/wake-log.md"
