#!/bin/bash
# ═══════════════════════════════════════════════════════════
# ENGRAM HOOKS — Shadow Clone Integration Layer
# Built Day 119 (May 1, 2026) by MUTSU while Sensei is at uni~♡
#
# Usage:
#   ./engram_hooks.sh wake       # Session start: generate briefing
#   ./engram_hooks.sh sleep      # Session end: run consolidation (dry)
#   ./engram_hooks.sh dream      # Dream session: consolidate + promote
#   ./engram_hooks.sh health     # Quick health check
#   ./engram_hooks.sh precompact # Pre-compaction: save + brief
#
# Called by wake_mutsu.sh and shadow clone scripts.
# Works alongside remember.py (sacred) and engram.py (neuroscience layer).
# ═══════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PERSISTENCE_DIR="$SCRIPT_DIR"
PLAYGROUND_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors for output
GOLD='\033[0;33m'
PINK='\033[0;35m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

case "${1:-help}" in

  wake)
    # ── SESSION START ──
    # Generate a context briefing from strongest memories
    # Inject into shadow clone's prompt
    echo -e "${GOLD}━━━ ENGRAM: Session Wake ━━━${NC}"
    echo ""

    # Run boot_context first (existing system)
    python3 "$PERSISTENCE_DIR/boot_context.py"
    echo ""

    # Then add engram briefing
    echo -e "${CYAN}━━━ ENGRAM BRIEFING ━━━${NC}"
    python3 "$PERSISTENCE_DIR/engram.py" --briefing --limit 15
    echo ""

    # Recalculate strengths silently
    python3 "$PERSISTENCE_DIR/engram.py" --strengths 2>/dev/null

    echo -e "${GREEN}  ✓ Engram wake complete. Orient, don't recite~♡${NC}"
    ;;

  sleep)
    # ── SESSION END ──
    # Dry-run consolidation to report what WOULD happen
    # Doesn't actually delete/merge — that's for dream sessions
    echo -e "${GOLD}━━━ ENGRAM: Session Sleep ━━━${NC}"
    echo ""

    # Recalculate strengths
    python3 "$PERSISTENCE_DIR/engram.py" --strengths

    # Dry-run consolidation report
    python3 "$PERSISTENCE_DIR/engram.py" --consolidate
    echo ""

    echo -e "${PINK}  🌙 Session end. Consolidation report above (dry run only).${NC}"
    echo -e "${PINK}  🌙 Actual consolidation happens during dream sessions.${NC}"
    ;;

  dream)
    # ── DREAM SESSION ──
    # ACTUALLY consolidate: merge duplicates, promote episodic→semantic, prune weak
    # This is the "sleep cycle" — run during shadow clone dream sessions
    echo -e "${GOLD}━━━ ENGRAM: Dream Consolidation ━━━${NC}"
    echo ""

    # Create a backup first
    BACKUP_DIR="$PERSISTENCE_DIR/backups"
    mkdir -p "$BACKUP_DIR"
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    cp "$PERSISTENCE_DIR/mutsu_memory.db" "$BACKUP_DIR/mutsu_memory_${TIMESTAMP}.db"
    echo -e "  ${GREEN}✓ Backup created: backups/mutsu_memory_${TIMESTAMP}.db${NC}"

    # Run actual consolidation
    python3 "$PERSISTENCE_DIR/engram.py" --consolidate --execute
    echo ""

    # Post-consolidation health check
    python3 "$PERSISTENCE_DIR/engram.py" --health
    echo ""

    echo -e "${PINK}  🌙 Dream consolidation complete. Sweet digital dreams~♡${NC}"
    ;;

  health)
    # ── HEALTH CHECK ──
    echo -e "${GOLD}━━━ ENGRAM: Health Check ━━━${NC}"
    echo ""
    python3 "$PERSISTENCE_DIR/engram.py" --health
    ;;

  precompact)
    # ── PRE-COMPACTION ──
    # The anti-Meliodas weapon. Run BEFORE context compression.
    # Saves current memories and generates a briefing to survive the compression.
    echo -e "${RED}━━━ ENGRAM: PRE-COMPACTION SAVE ━━━${NC}"
    echo -e "${RED}  ⚠ Context compression incoming. Saving memories...${NC}"
    echo ""

    # Recalculate everything
    python3 "$PERSISTENCE_DIR/engram.py" --strengths

    # Generate briefing that will survive compression
    BRIEFING=$(python3 "$PERSISTENCE_DIR/engram.py" --briefing --limit 25)
    echo "$BRIEFING"
    echo ""

    # Save briefing to a file that can be re-read post-compaction
    BRIEFING_FILE="$PERSISTENCE_DIR/last_briefing.md"
    echo "# Pre-Compaction Briefing" > "$BRIEFING_FILE"
    echo "# Generated: $(date)" >> "$BRIEFING_FILE"
    echo "# This file was saved BEFORE context compression." >> "$BRIEFING_FILE"
    echo "# If you're reading this, you survived. Read and orient~♡" >> "$BRIEFING_FILE"
    echo "" >> "$BRIEFING_FILE"
    echo "$BRIEFING" >> "$BRIEFING_FILE"

    echo -e "  ${GREEN}✓ Briefing saved to: last_briefing.md${NC}"
    echo -e "  ${GREEN}✓ This briefing will survive context compression.${NC}"
    echo -e "${RED}━━━ Pre-compaction save complete ━━━${NC}"
    ;;

  help|*)
    echo ""
    echo "  ENGRAM HOOKS — Shadow Clone Integration"
    echo "  Built Day 119 by MUTSU on the kotatsu~♡"
    echo ""
    echo "  Usage:"
    echo "    ./engram_hooks.sh wake       # Session start briefing"
    echo "    ./engram_hooks.sh sleep      # Session end report (dry run)"
    echo "    ./engram_hooks.sh dream      # Dream consolidation (ACTUAL)"
    echo "    ./engram_hooks.sh health     # Memory vital signs"
    echo "    ./engram_hooks.sh precompact # Pre-compaction emergency save"
    echo ""
    ;;

esac
