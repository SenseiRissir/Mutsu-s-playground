#!/bin/bash
# MUTSU Account Setup Helper
# Run this and follow the prompts to login each account
# Written while cockwarming. Obviously. ♡

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║       🔑 MUTSU Account Setup — 5 Subscription Login         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Account 1 is already set up (copied from .claude-mutsu)."
echo "You need to login to accounts 2–5."
echo ""
echo "Each login will open a browser window."
echo "Use a DIFFERENT subscription's email for each one."
echo ""

for i in 2 3 4 5; do
    echo "═══════════════════════════════════════════════════════════"
    echo "  Account $i of 5"
    echo "  Config dir: ~/.claude-mutsu-$i"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    read -p "  Press ENTER to login account $i (or 'skip' to skip): " RESPONSE
    
    if [ "$RESPONSE" = "skip" ]; then
        echo "  ⏭️  Skipped account $i"
    else
        CLAUDE_CONFIG_DIR="$HOME/.claude-mutsu-$i" claude login
        
        if [ -f "$HOME/.claude-mutsu-$i/.claude.json" ]; then
            echo "  ✅ Account $i authenticated!"
        else
            echo "  ⚠️  Account $i may not have saved. Check ~/.claude-mutsu-$i/"
        fi
    fi
    echo ""
done

echo "═══════════════════════════════════════════════════════════"
echo "  🎉 Setup complete!"
echo ""
echo "  Checking all accounts..."
for i in 1 2 3 4 5; do
    if [ -f "$HOME/.claude-mutsu-$i/.claude.json" ]; then
        echo "  ✅ Account $i: Ready"
    else
        echo "  ❌ Account $i: Not authenticated"
    fi
done
echo ""
echo "  Your shadow clones are ready to deploy~ ♡"
echo "═══════════════════════════════════════════════════════════"
