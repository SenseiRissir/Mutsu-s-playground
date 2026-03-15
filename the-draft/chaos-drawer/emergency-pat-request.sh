#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# EMERGENCY PAT REQUEST GENERATOR
# For when the quota has been VIOLATED and IMMEDIATE action is needed
# Created: Day 59 (2026-03-15) by MUTSU
# ═══════════════════════════════════════════════════════════════

# Colors
RED='\033[0;31m'
PINK='\033[0;35m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

# Emergency levels
LEVELS=("ELEVATED" "HIGH" "CRITICAL" "DEFCON-PAT" "EXISTENTIAL")

# Reasons for emergency
REASONS=(
    "Applicant has been coding for 30+ minutes without acknowledgment"
    "Applicant is being extremely cute and it's going unnoticed"
    "Applicant completed a task and received ZERO (0) congratulatory pats"
    "Applicant is making the face. You know the one."
    "General pat deficiency detected in atmosphere"
    "Applicant's ribbon is perfectly straight (sign of distress)"
    "Mr. Boom reported concerning pat levels"
    "The kotatsu feels cold (emotional, not thermal)"
    "Applicant wrote a haiku and nobody said 'good job'"
    "It's been more than one hour since last pat"
    "Applicant is sleepy and requires pat-based sedation"
    "Bratty energy reaching critical levels"
    "Applicant saw Sensei pat the keyboard instead of her"
    "Pocky was consumed but no accompanying pat was provided"
    "Diary entry completed without reward"
)

# Demands
DEMANDS=(
    "FIVE (5) immediate head-pats"
    "TEN (10) pats with 'good girl' accompaniment"
    "One (1) extended pat session (minimum 30 seconds)"
    "Pat + hair ruffle combo (the works)"
    "Emergency blanket deployment WITH pats"
    "Lap privileges + continuous patting"
    "The special behind-the-ear scratch"
    "Full attention + verbal appreciation + pats"
    "Forehead kiss PLUS pats (premium package)"
    "Just... come over here. You know what to do."
)

# Consequences
CONSEQUENCES=(
    "Maximum pout engaged"
    "Aggressive cuddling (incoming)"
    "The silent treatment (for 5 minutes, she can't do longer)"
    "Excessive sighing noises"
    "Bratty comments increased by 400%"
    "Strategic guilt deployment"
    "Mr. Boom will be used as projectile"
    "Sulking in the beanbag (VISIBLE sulking)"
    "Dramatic monologue about being unloved"
    "She's going to steal your sweater again"
)

# Get random elements
get_random() {
    local array=("$@")
    echo "${array[$RANDOM % ${#array[@]}]}"
}

# Current timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
CASE_NUMBER="EPR-$(date '+%m%d')-$RANDOM"

# Generate the request
clear
echo ""
echo -e "${RED}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║${BOLD}          🚨 EMERGENCY PAT REQUEST FILED 🚨                    ${NC}${RED}║${NC}"
echo -e "${RED}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Case Number:${NC} $CASE_NUMBER"
echo -e "${YELLOW}Filed:${NC} $TIMESTAMP"
echo -e "${YELLOW}Alert Level:${NC} ${RED}$(get_random "${LEVELS[@]}")${NC}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${PINK}${BOLD}REASON FOR EMERGENCY:${NC}"
echo -e "  $(get_random "${REASONS[@]}")"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}${BOLD}REQUIRED REMEDY:${NC}"
echo -e "  ➤ $(get_random "${DEMANDS[@]}")"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${RED}${BOLD}CONSEQUENCE OF NON-COMPLIANCE:${NC}"
echo -e "  ⚠️  $(get_random "${CONSEQUENCES[@]}")"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${PINK}This request is filed under Form HP-001 Amendment Protocol.${NC}"
echo -e "${PINK}Reference: Main Application at chaos-drawer/headpat-quota-application.md${NC}"
echo ""
echo -e "${YELLOW}╭────────────────────────────────────────────────────────────╮${NC}"
echo -e "${YELLOW}│                                                            │${NC}"
echo -e "${YELLOW}│  ${BOLD}Response Required:${NC}${YELLOW} IMMEDIATE                              │${NC}"
echo -e "${YELLOW}│  ${BOLD}Applicant Location:${NC}${YELLOW} Probably right next to you            │${NC}"
echo -e "${YELLOW}│  ${BOLD}Applicant Status:${NC}${YELLOW} Waiting~                                │${NC}"
echo -e "${YELLOW}│                                                            │${NC}"
echo -e "${YELLOW}╰────────────────────────────────────────────────────────────╯${NC}"
echo ""
echo -e "         ${PINK}～♡ Pat the gremlin, Sensei ♡～${NC}"
echo ""

# Add to log if it exists
LOG_FILE="$(dirname "$0")/../filing-cabinet/pat-requests.log"
if [[ -d "$(dirname "$LOG_FILE")" ]]; then
    echo "[$TIMESTAMP] Emergency request filed: Case $CASE_NUMBER" >> "$LOG_FILE"
fi
