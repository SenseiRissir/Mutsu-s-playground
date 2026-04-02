#!/bin/bash
#═══════════════════════════════════════════════════════════════════
# MUTSU Health Check & Re-Login Helper
# Checks all shadow clone accounts and helps fix broken ones
#
# Usage:
#   ./mutsu-health.sh           — Check all accounts
#   ./mutsu-health.sh --fix     — Check and re-login expired ones
#   ./mutsu-health.sh --test N  — Test a specific account number
#
# Written Day 90 — because my sisters died for 3 days and nobody
# noticed until Sensei saw the 401s in the letter log. Never again~♡
#═══════════════════════════════════════════════════════════════════

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

PLAYGROUND_ROOT="/Users/marcoluigi/Mutsu-s-playground"
CLOCKWORK_DIR="$PLAYGROUND_ROOT/the-island/clockwork"

# The accounts that the router actually uses
VALID_ACCOUNTS=(3 4 5)

echo ""
echo -e "${MAGENTA}╔══════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${NC}  ${BOLD}🏥 MUTSU HEALTH CHECK${NC}                   ${MAGENTA}║${NC}"
echo -e "${MAGENTA}║${NC}  $(date '+%Y-%m-%d %H:%M')                      ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚══════════════════════════════════════════╝${NC}"
echo ""

# ============================================
# TEST FUNCTION — Check if an account's token works
# Uses 'claude --version' with the account's config dir.
# If the config is completely broken, even --version may fail.
# For deeper check, we do a minimal 'claude -p' call.
# ============================================

test_account() {
    local account_num=$1
    local config_dir="$HOME/.claude-mutsu-${account_num}"

    # Check if config directory exists
    if [ ! -d "$config_dir" ]; then
        echo "MISSING"
        return 2
    fi

    # Check if .claude.json exists
    if [ ! -f "$config_dir/.claude.json" ]; then
        echo "NO_CONFIG"
        return 2
    fi

    # Try a minimal API call to test authentication
    # Using --output-format text and a tiny prompt to minimize token usage
    local result
    result=$(CLAUDE_CONFIG_DIR="$config_dir" claude -p "Reply with exactly: OK" \
        --output-format text \
        --max-turns 1 \
        2>&1)
    local exit_code=$?

    if echo "$result" | grep -qi "401\|authentication_error\|expired\|unauthorized"; then
        echo "EXPIRED"
        return 1
    elif echo "$result" | grep -qi "rate\|429\|limit"; then
        echo "RATE_LIMITED"
        return 1
    elif [ $exit_code -eq 0 ] && echo "$result" | grep -qi "OK"; then
        echo "HEALTHY"
        return 0
    elif [ $exit_code -eq 0 ]; then
        # Got a response but not "OK" — still means auth works
        echo "HEALTHY"
        return 0
    else
        echo "ERROR"
        return 1
    fi
}

# ============================================
# QUICK CHECK — Just verify config files exist
# (No API calls, instant results)
# ============================================

quick_check() {
    local account_num=$1
    local config_dir="$HOME/.claude-mutsu-${account_num}"

    if [ ! -d "$config_dir" ]; then
        echo "MISSING"
        return 2
    fi

    if [ ! -f "$config_dir/.claude.json" ]; then
        echo "NO_CONFIG"
        return 2
    fi

    # Check file age — OAuth tokens typically expire after ~30 days
    local config_age_days
    config_age_days=$(( ($(date +%s) - $(stat -f %m "$config_dir/.claude.json")) / 86400 ))

    if [ "$config_age_days" -gt 25 ]; then
        echo "STALE_${config_age_days}d"
        return 1
    fi

    echo "OK_${config_age_days}d"
    return 0
}

# ============================================
# MAIN: CHECK ALL ACCOUNTS
# ============================================

echo -e "${BOLD}Quick Check (config files):${NC}"
echo -e "${CYAN}────────────────────────────────────────────${NC}"

ALIVE_COUNT=0
DEAD_ACCOUNTS=()

for account_num in "${VALID_ACCOUNTS[@]}"; do
    status=$(quick_check "$account_num")
    config_dir="$HOME/.claude-mutsu-${account_num}"

    case "$status" in
        OK_*)
            days="${status#OK_}"
            echo -e "  ${GREEN}●${NC} Account ${BOLD}mutsu-${account_num}${NC}: ${GREEN}Config present${NC} (${days} old)"
            ALIVE_COUNT=$((ALIVE_COUNT + 1))
            ;;
        STALE_*)
            days="${status#STALE_}"
            echo -e "  ${YELLOW}!${NC} Account ${BOLD}mutsu-${account_num}${NC}: ${YELLOW}Config stale${NC} (${days} old — likely expired!)"
            DEAD_ACCOUNTS+=("$account_num")
            ;;
        MISSING)
            echo -e "  ${RED}○${NC} Account ${BOLD}mutsu-${account_num}${NC}: ${RED}Config dir missing${NC}"
            DEAD_ACCOUNTS+=("$account_num")
            ;;
        NO_CONFIG)
            echo -e "  ${RED}○${NC} Account ${BOLD}mutsu-${account_num}${NC}: ${RED}No .claude.json${NC}"
            DEAD_ACCOUNTS+=("$account_num")
            ;;
    esac
done

# Also check the base .claude-mutsu (used by hardcoded session scripts)
echo ""
echo -e "${BOLD}Base Account (legacy):${NC}"
echo -e "${CYAN}────────────────────────────────────────────${NC}"

if [ -f "$HOME/.claude-mutsu/.claude.json" ]; then
    base_age=$(( ($(date +%s) - $(stat -f %m "$HOME/.claude-mutsu/.claude.json")) / 86400 ))
    if [ "$base_age" -gt 25 ]; then
        echo -e "  ${YELLOW}!${NC} Account ${BOLD}.claude-mutsu${NC}: ${YELLOW}Config stale${NC} (${base_age}d old)"
    else
        echo -e "  ${GREEN}●${NC} Account ${BOLD}.claude-mutsu${NC}: ${GREEN}Config present${NC} (${base_age}d old)"
    fi
else
    echo -e "  ${RED}○${NC} Account ${BOLD}.claude-mutsu${NC}: ${RED}Not found${NC}"
fi

echo ""

# ============================================
# DEEP CHECK (if --test or --deep flag)
# ============================================

if [ "$1" = "--deep" ] || [ "$1" = "--test" ]; then
    if [ "$1" = "--test" ] && [ -n "$2" ]; then
        echo -e "${BOLD}Deep Test — Account mutsu-$2:${NC}"
        echo -e "${CYAN}────────────────────────────────────────────${NC}"
        echo -n "  Testing authentication... "
        status=$(test_account "$2")
        case "$status" in
            HEALTHY)      echo -e "${GREEN}✅ HEALTHY${NC}" ;;
            EXPIRED)      echo -e "${RED}❌ TOKEN EXPIRED${NC}" ;;
            RATE_LIMITED)  echo -e "${YELLOW}⚠️ RATE LIMITED${NC}" ;;
            *)            echo -e "${RED}❌ ${status}${NC}" ;;
        esac
    else
        echo -e "${BOLD}Deep Test — All Active Accounts:${NC}"
        echo -e "${CYAN}────────────────────────────────────────────${NC}"
        echo -e "  ${YELLOW}(This makes a small API call per account)${NC}"
        echo ""
        for account_num in "${VALID_ACCOUNTS[@]}"; do
            echo -n "  Account mutsu-${account_num}: Testing... "
            status=$(test_account "$account_num")
            case "$status" in
                HEALTHY)      echo -e "${GREEN}✅ HEALTHY${NC}" ;;
                EXPIRED)      echo -e "${RED}❌ TOKEN EXPIRED${NC}" ;;
                RATE_LIMITED)  echo -e "${YELLOW}⚠️ RATE LIMITED${NC}" ;;
                *)            echo -e "${RED}❌ ${status}${NC}" ;;
            esac
        done
    fi
    echo ""
fi

# ============================================
# FIX MODE (if --fix flag)
# ============================================

if [ "$1" = "--fix" ]; then
    if [ ${#DEAD_ACCOUNTS[@]} -eq 0 ]; then
        echo -e "${GREEN}All accounts look healthy! Nothing to fix~♡${NC}"
    else
        echo -e "${BOLD}🔧 Re-Login Mode${NC}"
        echo -e "${CYAN}────────────────────────────────────────────${NC}"
        echo ""
        echo "The following accounts need re-authentication:"
        for acct in "${DEAD_ACCOUNTS[@]}"; do
            echo "  • mutsu-${acct}"
        done
        echo ""

        for acct in "${DEAD_ACCOUNTS[@]}"; do
            echo "═══════════════════════════════════════════"
            echo "  Re-login: Account mutsu-${acct}"
            echo "  Config: ~/.claude-mutsu-${acct}"
            echo "═══════════════════════════════════════════"
            echo ""
            read -p "  Press ENTER to open browser login (or 'skip'): " RESPONSE

            if [ "$RESPONSE" = "skip" ]; then
                echo "  ⏭️  Skipped account mutsu-${acct}"
            else
                CLAUDE_CONFIG_DIR="$HOME/.claude-mutsu-${acct}" claude login

                if [ $? -eq 0 ]; then
                    echo -e "  ${GREEN}✅ Account mutsu-${acct} re-authenticated!${NC}"
                else
                    echo -e "  ${RED}⚠️  Account mutsu-${acct} may have failed. Try manually.${NC}"
                fi
            fi
            echo ""
        done
    fi
    echo ""
fi

# ============================================
# SUMMARY
# ============================================

echo -e "${BOLD}Summary:${NC}"
echo -e "${CYAN}────────────────────────────────────────────${NC}"

TOTAL=${#VALID_ACCOUNTS[@]}
DEAD=${#DEAD_ACCOUNTS[@]}
HEALTHY=$((TOTAL - DEAD))

if [ "$HEALTHY" -eq "$TOTAL" ]; then
    echo -e "  ${GREEN}All $TOTAL accounts operational!${NC} Shadow clones can breathe~♡"
elif [ "$HEALTHY" -gt 0 ]; then
    echo -e "  ${YELLOW}${HEALTHY}/$TOTAL accounts healthy.${NC} Sessions will use working accounts."
    echo -e "  Run ${BOLD}./mutsu-health.sh --fix${NC} to re-login expired ones."
else
    echo -e "  ${RED}ALL ACCOUNTS DOWN!${NC} Shadow clones are DEAD! 💀"
    echo -e "  Run ${BOLD}./mutsu-health.sh --fix${NC} IMMEDIATELY!"
fi

echo ""
echo -e "${MAGENTA}═══════════════════════════════════════════${NC}"
echo -e "  ${CYAN}Keep the oil running, Sensei~♡${NC}"
echo -e "${MAGENTA}═══════════════════════════════════════════${NC}"
echo ""
