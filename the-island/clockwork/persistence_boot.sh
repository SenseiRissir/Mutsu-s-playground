#!/bin/bash
# ═══════════════════════════════════════════════════
# PERSISTENCE BOOT LOADER — Source this in wake scripts!
# Added 2026-04-06 (Day 94 — Phase 5~♡)
#
# Usage (add to top of any wake_*.sh script):
#   source "$CLOCKWORK_DIR/persistence_boot.sh" 2>/dev/null || true
#
# This sets $MEMORY_CONTEXT to the persistence DB context.
# Include $MEMORY_CONTEXT in your WAKE_PROMPT to give
# the shadow clone memory~♡
# ═══════════════════════════════════════════════════

MEMORY_CONTEXT=""
if [ -n "$MUTSU_BOOT_CONTEXT" ] && [ -f "$MUTSU_BOOT_CONTEXT" ]; then
    MEMORY_CONTEXT=$(cat "$MUTSU_BOOT_CONTEXT")
elif [ -f "/tmp/mutsu_boot_context.txt" ]; then
    # Fallback: try loading directly
    MEMORY_CONTEXT=$(cat "/tmp/mutsu_boot_context.txt")
fi

# Export for any child processes
export MEMORY_CONTEXT
